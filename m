Return-Path: <io-uring+bounces-9889-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DCE2BB4BD8
	for <lists+io-uring@lfdr.de>; Thu, 02 Oct 2025 19:49:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5084B320815
	for <lists+io-uring@lfdr.de>; Thu,  2 Oct 2025 17:49:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 174D2219A89;
	Thu,  2 Oct 2025 17:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="twireaYF"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3B51DB54C
	for <io-uring@vger.kernel.org>; Thu,  2 Oct 2025 17:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759427371; cv=none; b=L/yBh9kz8GoKJtxL6BA5PtUj4uP/ekJahTNOOVgBx9+nUztajtSqm/Ygy6E9ns61E4t4LRRwPKBGA2qinXvtvv/GNJoYst2vuHMuHfCcHaT/uUaIAmI+Jvs8skb3Cf0x83J6lyPM4G24pZQh4Eu6S21AuXJpfvHQGfZVOIf/Czk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759427371; c=relaxed/simple;
	bh=xnHqVBET9Re4eAIGua6znzkq8Veri0W8022ba0QrHNA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Ou7Ab1tKVfh/3IDKSFROTGr+0FAlSw+yQaK5CvRjOoXfVvK/25bl/Qb2wRfSJNh9r3sEZZSzAx43U7HzscLe1p+noL8x5XiItZJrictQGGXAPkNCHePsw0JA9gKKcxwcpf2PCfkeNqZ3ipNj+UwY/ajau9OlzDrUUqJuzeQwg+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=twireaYF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C074DC4CEF4;
	Thu,  2 Oct 2025 17:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759427371;
	bh=xnHqVBET9Re4eAIGua6znzkq8Veri0W8022ba0QrHNA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=twireaYF9qnXZRAaZaA6Uk82/gGgJ+mZQWGPVpwOGv2Qy2dj+f3D0Z0yorZ4/gn18
	 6vdeeefZx9Lx4kQgWcl1pN8P+J4a/p/n3t0m4q7/gxi0ehj8WrS+3RYFj8C7etFz9n
	 /vfc5v7FYqWWOx73rQOP9b/QqIPTbdMxeGbJgjgaTlga33bVzWwaZMenFf2ydZ20SJ
	 49jb7tLRCTClv9ESdgc/Lbwg27vwjrhpyvO6RiIjkVwkC04KO0bv+xfohmgrPDpefh
	 Z10pZmfur4V5EKYcEsF7RJEdZJEgLipxUn9mN2HKG3OTec6h/EsIXbHcwG5bMMxkPT
	 6FYjaKWxzyBng==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB05439D0C1A;
	Thu,  2 Oct 2025 17:49:24 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring changes for 6.18-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <41da83f9-0816-46fe-bbda-db1b93d786bd@kernel.dk>
References: <41da83f9-0816-46fe-bbda-db1b93d786bd@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <41da83f9-0816-46fe-bbda-db1b93d786bd@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/for-6.18/io_uring-20250929
X-PR-Tracked-Commit-Id: ef9f603fd3d4b7937f2cdbce40e47df0a54b2a55
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5832d26433f2bd0d28f8b12526e3c2fdb203507f
Message-Id: <175942736353.3363093.3212533726291213630.pr-tracker-bot@kernel.org>
Date: Thu, 02 Oct 2025 17:49:23 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 29 Sep 2025 19:15:24 -0600:

> git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/for-6.18/io_uring-20250929

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5832d26433f2bd0d28f8b12526e3c2fdb203507f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

