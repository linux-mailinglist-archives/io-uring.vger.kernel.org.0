Return-Path: <io-uring+bounces-5582-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A17F9F9C9F
	for <lists+io-uring@lfdr.de>; Fri, 20 Dec 2024 23:12:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04D2E160A51
	for <lists+io-uring@lfdr.de>; Fri, 20 Dec 2024 22:12:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7853226881;
	Fri, 20 Dec 2024 22:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tP4caqKm"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93361227565
	for <io-uring@vger.kernel.org>; Fri, 20 Dec 2024 22:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734732710; cv=none; b=OREIQHINAWA2kSfPAEra0FUNXmtcO/2+rYBlG5XJ0TZn4Z26NgnL+30A3Bi0vrQOJYdDmn+NmvEyLIMvIwFNUMQjPDX5iNjXc9ZRuUbzPjEYVVGuBvhS4/VRHe2ZAFFaPPjTgjZNQFGzNyS1HqFObNDTCRjijvu9Z0yh6k6ddRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734732710; c=relaxed/simple;
	bh=u+u7tJv2hRXMasn4uLP9oJNv7cLYAtqY4FClfYbI2mY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=bG9++/c6ZKPoRCPZXE0N1a5m3w/MtnQc5/LrrQ4IfXwaAnaVzjOZSRStnXxiTIosGZENaPzYFu1P9m8Y+PS7m0JrCKatSqH5Gfr1wnLqK0kOAY8CdZkhy21F7LZkEIYkHl/NuvfvVJkFrmJD/DIN37xyEF+4447CYVmvbr3KcAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tP4caqKm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC5AC4CECD;
	Fri, 20 Dec 2024 22:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734732710;
	bh=u+u7tJv2hRXMasn4uLP9oJNv7cLYAtqY4FClfYbI2mY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=tP4caqKmlUzpOkmXkoG1sXYu3OP7Nn5UsILZjdmvCnoz/WOoD/DCtzx9L7ZZ+ZqOD
	 EKvJvmffACXvCahsFqsTiYphg6oek50GQv0rHaZZztBg1pT2r+O51CEvK1UMK9Eec4
	 PvTvY4BdPUlrod8LPK7ahb49HTYzxt443OeMok019V01uOdrEFVTgRj4jwpiMvyetY
	 TUTxCbzN5fMw3JzjuEcPo4yufDnWxRxq9SH0D0m+v+U2QSGrHxq71ZxMj7V3b3r6KX
	 E1vSGXl697wooINGU4AIGRVH66axBxlNG7SFrwpX/cIej4NbY9+iVEsBXZNOw8Rprj
	 2bHVeDO71Grkw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33BDA3806656;
	Fri, 20 Dec 2024 22:12:09 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.13-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <785290eb-4182-4ea0-bce1-b3d895de09bf@kernel.dk>
References: <785290eb-4182-4ea0-bce1-b3d895de09bf@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <785290eb-4182-4ea0-bce1-b3d895de09bf@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.13-20241220
X-PR-Tracked-Commit-Id: dbd2ca9367eb19bc5e269b8c58b0b1514ada9156
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7c05bd92305d13e18945270b7bfaf300d53f6ed2
Message-Id: <173473272777.3035596.13892821208371673065.pr-tracker-bot@kernel.org>
Date: Fri, 20 Dec 2024 22:12:07 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 20 Dec 2024 09:24:27 -0700:

> git://git.kernel.dk/linux.git tags/io_uring-6.13-20241220

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7c05bd92305d13e18945270b7bfaf300d53f6ed2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

