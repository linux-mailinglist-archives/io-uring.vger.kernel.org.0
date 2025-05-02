Return-Path: <io-uring+bounces-7825-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C67B4AA791F
	for <lists+io-uring@lfdr.de>; Fri,  2 May 2025 20:07:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E10D4E344D
	for <lists+io-uring@lfdr.de>; Fri,  2 May 2025 18:07:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A1AA267385;
	Fri,  2 May 2025 18:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HlTZ3Wkf"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FD63D6F
	for <io-uring@vger.kernel.org>; Fri,  2 May 2025 18:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746209248; cv=none; b=sDEIEf/OtcA+mzzDzzGNICIPc6NHa0ZKKGN9LM9QnVpBHnAx8vS84doqyhbgPMfY18zekA3V3EvTsMoE2twL6Pnfts2WQrNurjSrnZs38eYn+hlzvL5rrVYzvqccg/aZ/Sf+WOSPi20mihy7uUGn2Fib32TsYfAIHb4trsg6ryY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746209248; c=relaxed/simple;
	bh=nCM0t/UgRgOFYF5pMvxgFk504/vRqmwfAU1Ls/ki+v4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=lunVDj200CQ+FVDD15eL2/TtRvSUJwky9pwqlBJ4A/hDWk3WcBnb5H6PIVgVlyBTzlgnwacozLK3Oy8ti4FT7Rd/MFQ+WCqyVoTMoC/twT4LrjCOFlHEIOrTJwN3qLNdfwiGuREN0RcUfsWdI5nu4phvQuuap4U0LEC/29qEepw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HlTZ3Wkf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CAAEC4CEE4;
	Fri,  2 May 2025 18:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746209248;
	bh=nCM0t/UgRgOFYF5pMvxgFk504/vRqmwfAU1Ls/ki+v4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=HlTZ3WkfBt9OTdjdgSVf9soejFU438JXpfiuhiLoNIxMjTLCt2OXd/tC5zkY7rZau
	 dA7K5C/1GoHyK0oq94ETzHvxK2CiNm3Jy8/kjvSbkIOBlWHlSx32wQCxShXcraXnq8
	 vMESsqY/fKC+nQYlcE1wUbpEuvOrLpQtvnWgWQ5Lhi/Mf+3Op6SQhrRwx/Aamjy8Mb
	 h/mq28quOEQNkFzXkcOFsDOh0xLCIE+ZZ3AeEtfMZfq8N3D8KvW1WDDUGUXqDonbqC
	 yhRJa1mp+luswce58SnWDBC2u9j1FBfdkUo3n0/k8MHfOGqfI37W33W4JBA68OcKmc
	 YGfgzYkNVgb2A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70BB1380DBE9;
	Fri,  2 May 2025 18:08:07 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 6.15-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <6526a5f1-f00c-46ab-85d8-2afaeda2198e@kernel.dk>
References: <6526a5f1-f00c-46ab-85d8-2afaeda2198e@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <6526a5f1-f00c-46ab-85d8-2afaeda2198e@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.15-20250502
X-PR-Tracked-Commit-Id: f024d3a8ded0d8d2129ae123d7a5305c29ca44ce
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 731e5e1a5bf411934b5d5bb0e0a5fb904985301c
Message-Id: <174620928613.3693103.4678735872753023189.pr-tracker-bot@kernel.org>
Date: Fri, 02 May 2025 18:08:06 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 2 May 2025 11:00:28 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.15-20250502

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/731e5e1a5bf411934b5d5bb0e0a5fb904985301c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

