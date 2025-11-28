Return-Path: <io-uring+bounces-10835-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41522C932DE
	for <lists+io-uring@lfdr.de>; Fri, 28 Nov 2025 22:18:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00EDC3AB97D
	for <lists+io-uring@lfdr.de>; Fri, 28 Nov 2025 21:18:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 914C8246BC7;
	Fri, 28 Nov 2025 21:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ctHSmIRg"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A00326E6F6
	for <io-uring@vger.kernel.org>; Fri, 28 Nov 2025 21:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764364715; cv=none; b=sCzoHYj0iQa/XqcbBRLguMAJQmmzQfYVk8l42Ot47xZuD+SegCedj4zzNEa+QrtDnEZONuzBkkh2619lpFbxbaRS+CkzIrxtAq4KKwsL1bRM13Pipx7CCk8gIX2mQq8ZMfGpjJckwyLo0oq2ubxPHh8CqKkVJJjzHcZeBaASmTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764364715; c=relaxed/simple;
	bh=Cy1Fbmw2Ex+psjR2AXuVlmTa6j5o0g4gYZWvrg2seVQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=K3hfpSIZ00e4PaqOL4T7RIW/jaWC8zuNRHcKitZOlOmhCnDwWzWvl+0V22gTR7loOJyjIba8OxDL78oVLXiVq/eMWZ1e7B4xmzoCD5iymVWl+n3JQtdy7m99C+RmI6uMkT8X49x05E+ChnoTdctN0HTlRPhUoy2F1nobvfmPrdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ctHSmIRg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B10C4CEF1;
	Fri, 28 Nov 2025 21:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764364715;
	bh=Cy1Fbmw2Ex+psjR2AXuVlmTa6j5o0g4gYZWvrg2seVQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ctHSmIRgP9g2BXGS8PG2dG+jayPjNkjvL4VtMb/V//cmI1sGgxgOYLJh62kX9YzH0
	 fR28dJN2nQaMvNFiKOciCqCJO+fbZSS4p+oKFhUP79Z2auhvh0LJGe4HMd3KSNvKR+
	 leFr5g7kn6r5Ll1dnetXT1AVe1atqDRH/xUhnGKtdvp2lD4RmiOe+UcerYQPsbDMJH
	 y6aMf8mTnlMYI91MPtQZyOSt7+ZxEgNcSN5HUGcpC5DcKhJYH/Fh8ajO6QzZprjyTy
	 ZLlh0Pqen2Pz84CXVmF45BHzCfPL62uoNb3R0ZzAVPeL/g2Rt3A67Uk9l91ulrdbeR
	 24c68czz2TzXQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F2803380692B;
	Fri, 28 Nov 2025 21:15:37 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.18-final
From: pr-tracker-bot@kernel.org
In-Reply-To: <c7983db3-002d-41a0-bc04-523eceb70748@kernel.dk>
References: <c7983db3-002d-41a0-bc04-523eceb70748@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <c7983db3-002d-41a0-bc04-523eceb70748@kernel.dk>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.18-20251128
X-PR-Tracked-Commit-Id: f6dc5a36195d3f5be769f60d6987150192dfb099
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9917bf8e7f5a9efbab844cf06cfd8da8eb7e13b6
Message-Id: <176436453652.799297.13615048823146938365.pr-tracker-bot@kernel.org>
Date: Fri, 28 Nov 2025 21:15:36 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 28 Nov 2025 12:32:52 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.18-20251128

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9917bf8e7f5a9efbab844cf06cfd8da8eb7e13b6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

