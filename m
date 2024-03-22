Return-Path: <io-uring+bounces-1201-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AEE8887417
	for <lists+io-uring@lfdr.de>; Fri, 22 Mar 2024 21:05:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BAB2D282E44
	for <lists+io-uring@lfdr.de>; Fri, 22 Mar 2024 20:05:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0610E7EF11;
	Fri, 22 Mar 2024 20:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FOqxkb+m"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D500B54789
	for <io-uring@vger.kernel.org>; Fri, 22 Mar 2024 20:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711137911; cv=none; b=UmQU9H11la6/jOSbULo5eNEEyiK2/tgCfGWbbUBL1BA5wd1miT4YwuzqIVZ7B4oz7liXv1Ls9zZDjoKZ4Sq0H7Ghq7elJObCsDBkx7a6YyzSR6b03b459wqrGtdi6NGX0X1wHcsrz1LbOghY3kpla1XgiB0PvtVMjrFZnMd95zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711137911; c=relaxed/simple;
	bh=dbHNHHdaBBwKeEqFBM4ufwfDWr+7ZJwNNoBhswjN22U=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=RMEAzzR62Z56FGJlnnOvDAFnU+22eYuJ6yOJ6RCGbwp1700onMfljyXkh6ItImalizjHES45nTZz0N5OZTzTAkeqhPuuf2+jGfCpbcPIYSF2E39I+XkAbkmASGpY6dPcqRrFgOS0TEli2k5xIkxYMZse9J9sGFbfGVkMOvg6/co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FOqxkb+m; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id B58B1C433F1;
	Fri, 22 Mar 2024 20:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711137911;
	bh=dbHNHHdaBBwKeEqFBM4ufwfDWr+7ZJwNNoBhswjN22U=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=FOqxkb+mJ6INKQr7SsthgSWRQ4hFBdAwQd8MKKZzeStFn3iMwEpJlggwFXmTxqxxg
	 r/vLsulz0acYxWi16D39M1jPtIwKpXYCa4ODRkQm3R5Stb7K0kfHgDn26mBBtHcxMb
	 HLs3pk/CdMK4KhPVWwvZD2arU3yp3/AoTWmoyPF0udaooxHSN06qo7RbjXmNExiadl
	 zBan9OH8pCjcR4xmcFBs5mCBj/SqVFP6fKPgGGaGM5VV9JylHKaAc5gGH89CXomkNk
	 sQY01cJ9qrkbI3tZXePCnoSqDmenCeshA3aegVDurNFK/uqsd6vuabxAjW/YpDJq7s
	 kum3og9aF/IYg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AB921D8BCE2;
	Fri, 22 Mar 2024 20:05:11 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.9-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <35b87421-96fe-468c-9136-dcfb24a70a95@kernel.dk>
References: <35b87421-96fe-468c-9136-dcfb24a70a95@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <35b87421-96fe-468c-9136-dcfb24a70a95@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.9-20240322
X-PR-Tracked-Commit-Id: 1251d2025c3e1bcf1f17ec0f3c0dfae5e5bbb146
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 19dba097071ec4fd6486b9f0d52d12a3c5743d44
Message-Id: <171113791169.14477.11828652124053615507.pr-tracker-bot@kernel.org>
Date: Fri, 22 Mar 2024 20:05:11 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 22 Mar 2024 11:07:06 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.9-20240322

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/19dba097071ec4fd6486b9f0d52d12a3c5743d44

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

