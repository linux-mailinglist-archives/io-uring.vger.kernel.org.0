Return-Path: <io-uring+bounces-16-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4976D7DE840
	for <lists+io-uring@lfdr.de>; Wed,  1 Nov 2023 23:47:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0324B281596
	for <lists+io-uring@lfdr.de>; Wed,  1 Nov 2023 22:47:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFCCF15E85;
	Wed,  1 Nov 2023 22:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H+5z91mB"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08D514AA5;
	Wed,  1 Nov 2023 22:47:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1E09EC433C7;
	Wed,  1 Nov 2023 22:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698878847;
	bh=zuk24VyIhH3b0aIqqYro+nOwM0P1lXalIY2BpZxiaXo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=H+5z91mBjITwQRq6y2zStlFK6kXVe9JyosfXxW5MBxkMGkIGBiOEdFyrQYqT6Krqg
	 uWgskv6r/XGRZSeOycFZoSCj5gKDVpx3WVcVc/bWm/3+qgaHGhAbzVfbqXxPJrjgID
	 CdStVDCZnlW1NjRIQOo0PiGpPIzIVzgLCP7jSynruIbIe/mD/uhCgelFFzmGWq143C
	 Bw1GX0NQKMOA4Pj7+Up+Sr0ie2xICGglTy47z+nfLSyUnV2V7ibRV3QQGt/6LiBQqe
	 Xtvj1C7DzT/cgOD8Xntl98SoVfdGd6tqQKJ9nHZFwcYLVvnBIOQGe4/aXGvTewZhiT
	 T8WEloeXCzXsQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0DC50C43168;
	Wed,  1 Nov 2023 22:47:27 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring support for get/setsockopt
From: pr-tracker-bot@kernel.org
In-Reply-To: <7a0893f0-bae8-4aee-9e05-7c81354fc829@kernel.dk>
References: <7a0893f0-bae8-4aee-9e05-7c81354fc829@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <7a0893f0-bae8-4aee-9e05-7c81354fc829@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/for-6.7/io_uring-sockopt-2023-10-30
X-PR-Tracked-Commit-Id: b9ec913212e6e91efa5a0a612c4a8ec4cf5da896
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f5277ad1e9768dbd05b1ae8dcdba690215d8c5b7
Message-Id: <169887884705.15957.4697402444529795323.pr-tracker-bot@kernel.org>
Date: Wed, 01 Nov 2023 22:47:27 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>, netdev <netdev@vger.kernel.org>, Breno Leitao <leitao@debian.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 30 Oct 2023 08:36:04 -0600:

> git://git.kernel.dk/linux.git tags/for-6.7/io_uring-sockopt-2023-10-30

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f5277ad1e9768dbd05b1ae8dcdba690215d8c5b7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

