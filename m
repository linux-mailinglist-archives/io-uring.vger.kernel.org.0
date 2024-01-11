Return-Path: <io-uring+bounces-392-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DBEE82B756
	for <lists+io-uring@lfdr.de>; Thu, 11 Jan 2024 23:58:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E89A52883A7
	for <lists+io-uring@lfdr.de>; Thu, 11 Jan 2024 22:58:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CD8A56476;
	Thu, 11 Jan 2024 22:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oNAZrQ1Y"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C1C52F83
	for <io-uring@vger.kernel.org>; Thu, 11 Jan 2024 22:57:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1AA51C43394;
	Thu, 11 Jan 2024 22:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705013876;
	bh=cq2pJ5j+vavnggom1wAG4ThGcUzPhfpiouiScx7mZMM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=oNAZrQ1YfFFt/BeWXU9LM2PxZ3yCXX0+5rsUU9sqd0lSAEV2uNr6FKUeghBvwW+JH
	 cZcdzCaM7Wr9a8ctntl3FyGPA7EZdiaG5avbTlrmBgqfiSh6EIE5Qc8EKWOYiHBg4M
	 y3afSN0aQvmma7VU+Xe+g7BBgm/l6pCQee/r8SlYc4iAUFAO7BOq8spcUrI/bhgrBw
	 M9nEcZVfeQQNErd9ZNIbdTqE1Wcdydi/L+cuv4KtTx5/Re8vMFNXe/HJwEBImdAXnQ
	 irHMTiR3LBKVkQuiu7SGkl97uH1sl8fjvd6s58yomg3n/Gg3cloT39NiZStaeHZfUh
	 rWze/1DqMef3g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0AB01DFC698;
	Thu, 11 Jan 2024 22:57:56 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring updates for 6.8-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <c5c21ccf-201b-486a-b184-a99924f4fc04@kernel.dk>
References: <c5c21ccf-201b-486a-b184-a99924f4fc04@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <c5c21ccf-201b-486a-b184-a99924f4fc04@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/for-6.8/io_uring-2024-01-08
X-PR-Tracked-Commit-Id: 6ff1407e24e6fdfa4a16ba9ba551e3d253a26391
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4c72e2b8c42e57f65d8fbfb01329e79d2b450653
Message-Id: <170501387603.24643.17329773226691857083.pr-tracker-bot@kernel.org>
Date: Thu, 11 Jan 2024 22:57:56 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>, Christian Brauner <brauner@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 8 Jan 2024 11:24:23 -0700:

> git://git.kernel.dk/linux.git tags/for-6.8/io_uring-2024-01-08

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4c72e2b8c42e57f65d8fbfb01329e79d2b450653

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

