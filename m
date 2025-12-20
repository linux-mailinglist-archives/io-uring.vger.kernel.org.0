Return-Path: <io-uring+bounces-11238-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C82A2CD34D0
	for <lists+io-uring@lfdr.de>; Sat, 20 Dec 2025 19:03:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 574F23008E9B
	for <lists+io-uring@lfdr.de>; Sat, 20 Dec 2025 18:03:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E33402749E0;
	Sat, 20 Dec 2025 18:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m5SVeC6R"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9B4201004
	for <io-uring@vger.kernel.org>; Sat, 20 Dec 2025 18:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766253805; cv=none; b=BxGcBtpu2jxiFSBLBCO0PQV9BhpLHDhEOj8svfkk1zvPdtYyvz/3KHytYbdvdy3rJWQhBdPu/q90lzhB+nohXeSKBnb4js57s2yRVZ1ceKVcDMuu3nGmu1KInGpoKrz4xBPAT3rTdEO5W8juJuKehwXH4SeRNt//pbw/4mE66NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766253805; c=relaxed/simple;
	bh=XLxwsniHGVBgBPT2rNE0/wqzQwCkVIOfvMmRtklDHOY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Xrj51p+C5Pe/as5jrU148T07AybYFIVonmZdiprGnAbJBrts+xf59wIr17jFkyU6KNlesVEnqDuS1VomAm5T2kRRs5/pZ8v5oBWJuv9EolYi21GH/KsYdrNA7qnzQPiqo5mPypoVZxvnjidvGSvR1LWcGNt1G+Pjhtxz2Eb5Byo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m5SVeC6R; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F904C4CEF5;
	Sat, 20 Dec 2025 18:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766253805;
	bh=XLxwsniHGVBgBPT2rNE0/wqzQwCkVIOfvMmRtklDHOY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=m5SVeC6RRXEUOyW98Lzd1ir5A+O5P9ih/GpdfboIqN8CpFztugqSqR5EnH7vOebMM
	 1CO6S6AxDPCKXT0NmzXzi4oXS2MWXn2vNI/ymnMUq8xoMW9es43sTGbuB4dcDY6qQC
	 vUbwIrnalseQQgdva9cwadCtSQZ+tay2pgt1j24uMDgJb0UhsGtu/68U07UuNgSNKV
	 sx46yzb/TIZDQqqm2Nvc9MPrzAD0CbiSdDb7e+2sZv7vamFaexkQ+LJVx65kSUYiKm
	 Hdwdv5UgPcSdKOwhPCicu58ORjB9QvSRzwTdi00W9pevdgXbS23AIZrYZaWzArN3A1
	 aG+77ymgzM9XA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F2A1B39F1DED;
	Sat, 20 Dec 2025 18:00:14 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 6.19-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <4298564b-41fa-4f34-96d3-5988d6a9c9b7@kernel.dk>
References: <4298564b-41fa-4f34-96d3-5988d6a9c9b7@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <4298564b-41fa-4f34-96d3-5988d6a9c9b7@kernel.dk>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.19-20251218
X-PR-Tracked-Commit-Id: 114ea9bbaf7681c4d363e13b7916e6fef6a4963a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d245b2e53e816716637be508c90190ef471457c7
Message-Id: <176625361349.102235.17045185429962839403.pr-tracker-bot@kernel.org>
Date: Sat, 20 Dec 2025 18:00:13 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 18 Dec 2025 20:47:03 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.19-20251218

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d245b2e53e816716637be508c90190ef471457c7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

