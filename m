Return-Path: <io-uring+bounces-7938-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8685FAB1C58
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 20:30:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 641A29E69E5
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 18:30:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B77C23E350;
	Fri,  9 May 2025 18:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ESQPxaQ1"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDBA23E347
	for <io-uring@vger.kernel.org>; Fri,  9 May 2025 18:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746815426; cv=none; b=Hp5nOOqicW3qMARFSwAMuKIo7uri5SVK7uQjP4kn8uOUG/5dYg4j4QfoJ84LUtCdADSuTyTHhXUjKNMHCKH5z1mbD5jbYDK/s/3Pb0B0pN32jt72S3otouT5FcPrj5DNnGj6QlqWpaWcmKrvcEXriIp845JBF2VRsXyFZzorZo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746815426; c=relaxed/simple;
	bh=zIyVjWuGr+rf7e6mY1L14lq131oYv8z+/KpzOFSBvdk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=o5cqwgktxAJ1+i90kF+pKyPc2Wy0nDOHgsdhRrBOAcFI/SSXH2NG2hJ2hoAS4JhQLJVjQ62Nj3fpfDE++CGvPRum2Q4KWJ7Zsv2lkIOi+STlUivUHXtEu/udwEuhwEs1xoc9jFy/pgrSHp9jKh2oBcsnP9wfWP+2ABHxYKT8ciY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ESQPxaQ1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC54CC4CEEE;
	Fri,  9 May 2025 18:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746815426;
	bh=zIyVjWuGr+rf7e6mY1L14lq131oYv8z+/KpzOFSBvdk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ESQPxaQ1TU/tGaZkr3OYwUXL8+TzjV52V8TB3MMeZEmIYph8VMmxOR2dxtDQLtXIO
	 bFkmhJCd+eUZv7ugbiP2138wbK1G11n4W8X9mPXfbTR58oBzQQoNZ2De6Y/X47J+xO
	 cCrDwBfxB/YqUP4K4gzLntDvzTJY2WNBFzcs1vBAQ1oJeFP2vFLGnMhYcML8ENPFkb
	 LMKH2Y77pM32SL3LrDtZqWIRiSoYY68jnbBUHa9MhTK9vknpPDiEmetC8KBKwDRHJp
	 U0z5M7AjvoO0nywHJCleGjDrsoLoBHNH0fGOBYziAEc/XN7TIEgqIPR8PIDw3NwJx1
	 X2B3Px22yNWsw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70B36380DBCB;
	Fri,  9 May 2025 18:31:06 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.15-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <570b6c7d-e273-4ceb-80fb-ac00090b8f94@kernel.dk>
References: <570b6c7d-e273-4ceb-80fb-ac00090b8f94@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <570b6c7d-e273-4ceb-80fb-ac00090b8f94@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.15-20250509
X-PR-Tracked-Commit-Id: 92835cebab120f8a5f023a26a792a2ac3f816c4f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7380c60b2831220ca6d60d1560ecf8d9bdf06288
Message-Id: <174681546514.3713200.6826624688631165253.pr-tracker-bot@kernel.org>
Date: Fri, 09 May 2025 18:31:05 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 9 May 2025 09:32:02 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.15-20250509

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7380c60b2831220ca6d60d1560ecf8d9bdf06288

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

