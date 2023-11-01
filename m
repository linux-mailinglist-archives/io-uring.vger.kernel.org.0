Return-Path: <io-uring+bounces-15-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ADC07DE83F
	for <lists+io-uring@lfdr.de>; Wed,  1 Nov 2023 23:47:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B6A92812ED
	for <lists+io-uring@lfdr.de>; Wed,  1 Nov 2023 22:47:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB55D14AAD;
	Wed,  1 Nov 2023 22:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qfo8p7Ds"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2D78835
	for <io-uring@vger.kernel.org>; Wed,  1 Nov 2023 22:47:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DBE26C433C8;
	Wed,  1 Nov 2023 22:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698878846;
	bh=Q28lS+3oqfUrmG3fPteRgvaY5UAiLpqhU3Uc0z0qPkw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Qfo8p7DsArhuGB8vGe6BpjsYq8leBmsFMt3R1UGqDgmJiFFDf/nDpyBv8OVitWJQG
	 /1SrRxFrmKvd1+Z+XYbNcsAbgVfb/9DykdpDb6Pbx9UocT7vz2uhLU4a5TvG19HVMX
	 6miepLaZvD/ql8HnaLfmkF2lfDHzqM+hOrqh+gYsQP7i1JV16fTvkTDtdzhakb0b0W
	 ylHwsRNSLYapR/UDEZcaORxvfvDNaO2Bk/TPpfzdKZ/Ua3oUi/NZYOqbW1wTx1Q4KB
	 5vH/RVUECT1XpQCrMpq4VwqmumOVrNVZIPGPzr5wZ5K3WVlz649RoGQ85JEMVG5Ql3
	 UvLVTDbdi4hFA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C9429C4316B;
	Wed,  1 Nov 2023 22:47:26 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring updates for 6.7-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <2a4567f5-7599-4729-8563-3f9c8b23d672@kernel.dk>
References: <2a4567f5-7599-4729-8563-3f9c8b23d672@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <2a4567f5-7599-4729-8563-3f9c8b23d672@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/for-6.7/io_uring-2023-10-30
X-PR-Tracked-Commit-Id: 6ce4a93dbb5bd93bc2bdf14da63f9360a4dcd6a1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a615f67e1a426f35366b8398c11f31c148e7df48
Message-Id: <169887884681.15957.13958698109918202987.pr-tracker-bot@kernel.org>
Date: Wed, 01 Nov 2023 22:47:26 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>, Christian Brauner <brauner@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 30 Oct 2023 08:34:07 -0600:

> git://git.kernel.dk/linux.git tags/for-6.7/io_uring-2023-10-30

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a615f67e1a426f35366b8398c11f31c148e7df48

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

