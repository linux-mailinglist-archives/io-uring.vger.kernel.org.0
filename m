Return-Path: <io-uring+bounces-11576-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 88343D0CCF2
	for <lists+io-uring@lfdr.de>; Sat, 10 Jan 2026 03:19:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0B57A303530A
	for <lists+io-uring@lfdr.de>; Sat, 10 Jan 2026 02:18:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA7B61C1F02;
	Sat, 10 Jan 2026 02:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Syl2hjoZ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7899221FCD
	for <io-uring@vger.kernel.org>; Sat, 10 Jan 2026 02:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768011515; cv=none; b=OrTH59ufC7YyY4kDUhqJ9euxhNk6Bgoh5pPwofWLd79UHa3+lnym1jnaT/sc4ayAvt6aHrhEnRansbnhNuPbX3W3DOJV+tp7+7O+51URp1ZTHImA9XVApSP4UKTMvcX2dTMa/Pt2ltRHfyCeFfEmw3stTH9BXBICgg6nz2GKEXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768011515; c=relaxed/simple;
	bh=cRQIr35x6X821hDcT/nHfMP75figpZZDg8hh9X8yi6Y=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=HY9w97RIOJ4NN8wP1EKyTGU3h1cHGLLEGX5n6wnXSrf7BSqpnEnfP+F8MKAuQ4ohapqcntgDafEasEV7yB6Q9pfUq3Iq5qqOl5X9Y1V0Ex0r7YVDhJWnJs6hisliUacQpskNxSazMe7X8WIKy1XYUk1PST4AhC2yFMvxBMgpxmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Syl2hjoZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B755C4CEF1;
	Sat, 10 Jan 2026 02:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768011515;
	bh=cRQIr35x6X821hDcT/nHfMP75figpZZDg8hh9X8yi6Y=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Syl2hjoZg+POaAyZSMAKfKsQhapzvJXrNRQ5JAmCe1srDFAKeULhacGDciTROJ+dV
	 R0tk05KjMdQBgi6BIYMU8//zbpOw6FmYeXac7E1Af83a/QSi94W+rmyNjSdJfP80Nr
	 Zf6hrYVYRucAu+BTVoMmPkckS5QD3dWODy48ZI1l6SsPznKaFwjo+KivWd5HnBLur5
	 4+9ROLynMk21KfauRwL/3uOBuS5SIxGXq4J2qr+EbYMp90tCU2Cga2O6IEdNa1Sjan
	 YceZIvgg0y7VxOhBrGxdFL/SlJg7UsLN3sIIH91v7u63I48dBOfLURKkjn5eRJ12Vt
	 RB4LfFl7kR0xw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7883B3AA9F46;
	Sat, 10 Jan 2026 02:15:12 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 6.19-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <107197ad-1de3-4773-89ad-a3c1977dd7eb@kernel.dk>
References: <107197ad-1de3-4773-89ad-a3c1977dd7eb@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <107197ad-1de3-4773-89ad-a3c1977dd7eb@kernel.dk>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.19-20260109
X-PR-Tracked-Commit-Id: e4fdbca2dc774366aca6532b57bfcdaae29aaf63
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 68ad2095ca0f42a92d16d8cd1df0fb4f4bff634a
Message-Id: <176801131120.452892.2451834005176211031.pr-tracker-bot@kernel.org>
Date: Sat, 10 Jan 2026 02:15:11 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 9 Jan 2026 11:44:27 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.19-20260109

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/68ad2095ca0f42a92d16d8cd1df0fb4f4bff634a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

