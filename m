Return-Path: <io-uring+bounces-4342-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C71259B9C13
	for <lists+io-uring@lfdr.de>; Sat,  2 Nov 2024 02:48:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B140282B71
	for <lists+io-uring@lfdr.de>; Sat,  2 Nov 2024 01:47:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 916D339AD6;
	Sat,  2 Nov 2024 01:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f+hjRHR0"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC7F2E630
	for <io-uring@vger.kernel.org>; Sat,  2 Nov 2024 01:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730512053; cv=none; b=t5qw91LTC3JtkSD9pGPYRTIp+kxJ6FPF1s5OP3PHxSEkIm+Gaqg+U7XbiWG1IvhGGduxXi7TBUyFhMvrzRP993jZZtyCDRQNY/CgM18K/07V2B2AIU3uFvNlKFQVGgXHDWGqYBHSMbDq7knBAKa7m4lXPY1eqDEeU/Q+M5FBWtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730512053; c=relaxed/simple;
	bh=W0jlGRLVNs33l/IItdYqj8qljd7U1O6/hKGsxuJMe5c=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=gqAiJg7hwdhtPA4VK0gSRKlF8kODMM3QI28EFyFXCBdh8x6V55NF4oTL1vrc/BEx03c78UnB3MeTbep42YlOIdfYpGmMjLjzXrkJEpRRWmkaCIuaIcb1bHWnu4stTq9xDi4DdGlSWzI3btYMjrulD6WBcp7du/woGOW6gF3IX7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f+hjRHR0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B3FC4CECD;
	Sat,  2 Nov 2024 01:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730512053;
	bh=W0jlGRLVNs33l/IItdYqj8qljd7U1O6/hKGsxuJMe5c=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=f+hjRHR07B0sNWDj44QOQxyaI2s1FFGNqTBgUAWEtwrnUF+h0xyVwDMWsWLrdshXl
	 yqpZ1uoS8Ig7M1becVQWUo4BwJhlA+sPnMtAO29y/V2Q2kgn1CGGXpZ/YS9hLnXTjV
	 2n3Bltfa7wmCM09fjuiwnvqw3Jhb8peTFaXxQq85q72qtNhHVqiwMGsjx4MU++vmko
	 SBQgMGo+PRwjONGWEFIg5jfaSwSJgkP5IHL9Ouvkpzc2Q71JOCXTo5xEg8nUDkNsVu
	 MUZXS3Lgx7y69k7Jpy+ZEycphE4jnClH0g5h5iJ2yY9q2v6z+hF4OyI+3/S7oWUpZO
	 ePNjWGRIfEENA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE5E83AB8A90;
	Sat,  2 Nov 2024 01:47:42 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 6.12-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <8a3c26ea-bebb-401c-9fa3-e900aacfa77d@kernel.dk>
References: <8a3c26ea-bebb-401c-9fa3-e900aacfa77d@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <8a3c26ea-bebb-401c-9fa3-e900aacfa77d@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.12-20241101
X-PR-Tracked-Commit-Id: 1d60d74e852647255bd8e76f5a22dc42531e4389
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f0d3699aef2b6f864c78ccfa8e2a7327f65b8841
Message-Id: <173051206128.2889628.4084676108044508266.pr-tracker-bot@kernel.org>
Date: Sat, 02 Nov 2024 01:47:41 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 1 Nov 2024 12:10:14 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.12-20241101

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f0d3699aef2b6f864c78ccfa8e2a7327f65b8841

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

