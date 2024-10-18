Return-Path: <io-uring+bounces-3834-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 64F9D9A49C9
	for <lists+io-uring@lfdr.de>; Sat, 19 Oct 2024 00:57:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F0337B216EA
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 22:57:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22FE119067C;
	Fri, 18 Oct 2024 22:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mpN7ycoW"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF30D7485
	for <io-uring@vger.kernel.org>; Fri, 18 Oct 2024 22:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729292225; cv=none; b=PsCoBxnIzYRvAEzZ6nsfakvEYSgfTnvHihouB0cHh6C/rTXOzCvZXYdh4GnYK5CemvJcfjTpmR8Sz0yWs5boLqIy0r4tcdcYwjT6qXXFBBCHDFMsG5cLlyLzgjP/BrFjtQYHENbWJjmwlc24cHyzkbRSWFxAWx9Tdpqof9+0z38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729292225; c=relaxed/simple;
	bh=HmlJavELTD86bIzmutLbIqG373ziGziivGc4QARJG/4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=qWEaqvGgei50FarPJFxJOrssSLp86t103coJEEkP+Kgnh3ePbayyC4Albp3PnDpfHIqnW4cy8gLzHFCCHny/sH92BDIBaij6S4KEVID/h15u96L+MJG55Q6PF/2LMuYlsJuc/jE/v97yG5+FdM7znzw5NxA+huRp5Zysh6w9zHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mpN7ycoW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC58C4CEC3;
	Fri, 18 Oct 2024 22:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729292224;
	bh=HmlJavELTD86bIzmutLbIqG373ziGziivGc4QARJG/4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=mpN7ycoW7xClCRR86kqo885P5qC2L2buESRqbQauOeVFB0UBHDG+bYrxvXnjW7uF5
	 AVzJJtmsPd7FbtVfi8Gaz4jC2EdB1B1ghon4wBhXxN9qWGL3oaPbt9fPbUIysrwq5D
	 RlV+tPKPSqc5emlycPJO3wi+Mg6exHpDRR/3AULHhiX3BONuSiJEuIVLviNqdhXktk
	 41L86/Jp+zGlk/QIlOYLSbHO/KK75YHV6Dg3hhikfIFt+pTSNN4YyUpzg261guxOYt
	 9cl6vCAo6OI8mN5AhMZPj8c49Bdb64bknP0dezWf8O6zFPWIW2L32SuMRsJ3wftA5/
	 mxvcyMdb+3UuA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADDF13805CC0;
	Fri, 18 Oct 2024 22:57:11 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.12-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <ac3e8b7b-fa02-4a70-bd1e-80ab3da328af@kernel.dk>
References: <ac3e8b7b-fa02-4a70-bd1e-80ab3da328af@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <ac3e8b7b-fa02-4a70-bd1e-80ab3da328af@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.12-20241018
X-PR-Tracked-Commit-Id: 8f7033aa4089fbaf7a33995f0f2ee6c9d7b9ca1b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a041f47898e30e01fea5da4a47bd6bcd72d8955a
Message-Id: <172929223024.3285619.12828379490417817170.pr-tracker-bot@kernel.org>
Date: Fri, 18 Oct 2024 22:57:10 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 18 Oct 2024 11:06:02 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.12-20241018

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a041f47898e30e01fea5da4a47bd6bcd72d8955a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

