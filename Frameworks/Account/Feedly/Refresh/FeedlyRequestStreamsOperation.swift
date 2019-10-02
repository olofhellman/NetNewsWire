//
//  FeedlyRequestStreamsOperation.swift
//  Account
//
//  Created by Kiel Gillard on 20/9/19.
//  Copyright © 2019 Ranchero Software, LLC. All rights reserved.
//

import Foundation
import os.log

protocol FeedlyRequestStreamsOperationDelegate: class {
	func feedlyRequestStreamsOperation(_ operation: FeedlyRequestStreamsOperation, enqueue collectionStreamOperation: FeedlyGetCollectionStreamOperation)
}

/// Single responsibility is to create one stream request operation for one Feedly collection.
/// This is the start of the process of refreshing the entire contents of a Folder.
final class FeedlyRequestStreamsOperation: FeedlyOperation {
	
	weak var queueDelegate: FeedlyRequestStreamsOperationDelegate?
	
	let collectionsProvider: FeedlyCollectionProviding
	let caller: FeedlyAPICaller
	let account: Account
	let log: OSLog
		
	init(account: Account, collectionsProvider: FeedlyCollectionProviding, caller: FeedlyAPICaller, log: OSLog) {
		self.account = account
		self.caller = caller
		self.collectionsProvider = collectionsProvider
		self.log = log
	}
	
	override func main() {
		defer { didFinish() }
		
		guard !isCancelled else { return }
		
		assert(queueDelegate != nil, "This is not particularly useful unless the `queueDelegate` is non-nil.")
		
		// TODO: Prioritise the must read collection/category before others so the most important content for the user loads first.
		
		for collection in collectionsProvider.collections {
			let operation = FeedlyGetCollectionStreamOperation(account: account, collection: collection, caller: caller)
			queueDelegate?.feedlyRequestStreamsOperation(self, enqueue: operation)
		}
		
		os_log(.debug, log: log, "Requested %i collection streams", collectionsProvider.collections.count)
	}
}
