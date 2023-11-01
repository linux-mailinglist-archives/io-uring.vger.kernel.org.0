Return-Path: <io-uring+bounces-17-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D9867DE841
	for <lists+io-uring@lfdr.de>; Wed,  1 Nov 2023 23:47:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 43BC02813BF
	for <lists+io-uring@lfdr.de>; Wed,  1 Nov 2023 22:47:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D71B4168B0;
	Wed,  1 Nov 2023 22:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S9N9X65n"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C3A14F6E
	for <io-uring@vger.kernel.org>; Wed,  1 Nov 2023 22:47:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 56B95C433CB;
	Wed,  1 Nov 2023 22:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698878847;
	bh=b2oT5gvPaU3k2pCiHXeYhBxPtUKkjM/j2f5Mfnr5VBs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=S9N9X65nTfNB9fr3xA4vDZVIEQ3SbBmu226gYUTsXts100W8Z3cnkvv0ARoG1mc7g
	 UbQRwbzNoAq7WQtH/S+W8tlgswUBu4TCky/qLaJQ/VJstIvkb27AZTnM45hVxfQR4F
	 1MJp7RTDeRMjFixQaZllZeJ9LpqMYsjZQJBw2y4qHf+/Qt7shwXSjIVWlj+lmBXzCS
	 lYxmX3jdyLhvh1ummYQ5R+cc2PP6C6sJFAzTu1PGQNs9e7f5PSTWuICtDHyieEla80
	 2tlP4Gz/HtlcWjtLOm2Sb86ilojVbG7WNlKvP7AGDiqlvn0O/x2FoNHC9CV1DJ20VQ
	 a49uv+LXM6vTQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 412A3C4316B;
	Wed,  1 Nov 2023 22:47:27 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring futex support
From: pr-tracker-bot@kernel.org
In-Reply-To: <49ec1791-f353-48f2-a39a-378b5463db42@kernel.dk>
References: <49ec1791-f353-48f2-a39a-378b5463db42@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <49ec1791-f353-48f2-a39a-378b5463db42@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-futex-2023-10-30
X-PR-Tracked-Commit-Id: 8f350194d5cfd7016d4cd44e433df0faa4d4a703
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4de520f1fcefd4ebb7dddcf28bde1b330c2f6b5d
Message-Id: <169887884726.15957.2097278812294400804.pr-tracker-bot@kernel.org>
Date: Wed, 01 Nov 2023 22:47:27 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 30 Oct 2023 19:07:01 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-futex-2023-10-30

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4de520f1fcefd4ebb7dddcf28bde1b330c2f6b5d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

