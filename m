Return-Path: <io-uring+bounces-5827-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 56826A0A5C2
	for <lists+io-uring@lfdr.de>; Sat, 11 Jan 2025 21:01:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 301F8188A07D
	for <lists+io-uring@lfdr.de>; Sat, 11 Jan 2025 20:01:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1409A1B6D17;
	Sat, 11 Jan 2025 20:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BsW1ZGLY"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43B31B6CEF
	for <io-uring@vger.kernel.org>; Sat, 11 Jan 2025 20:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736625674; cv=none; b=UJbs35IeaCV5C9Iw5ltgrzNgrl+eH0+VXWWYQ0OA8jU8tnHwEmQd4RcoagupX0cYwp2ZZfpA6470ezJioy2U8Sok9VuMcaRTiL6sAoOmoDHTT+BWFsg+HHJUQm/Xkb1pZam8qPZp/DUhnW3WqLI0pK200RL113l2miLVSXBi65E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736625674; c=relaxed/simple;
	bh=pARfolSqxgpAw6N57A77cpNc2Gclthbrl8C9FFR8z4E=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=c8oQs6l0/FzSk/e4J/S1ojET/PYfNR5KPG/o9nS39pKXDZU7l61/M+qU8qk9c9n5ApZrzTTKqKZbme8vlNiyQPG0wMzcIqezIao8KSx/c6B9HZG8nSh2RSvHT6XaNwxn/uon6RofbBFiVt7S0D/dpAcuYZoAQVWGEzkzNYtuwx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BsW1ZGLY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C659FC4CED2;
	Sat, 11 Jan 2025 20:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736625673;
	bh=pARfolSqxgpAw6N57A77cpNc2Gclthbrl8C9FFR8z4E=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=BsW1ZGLYMCxiizoNFjgfWFBuB5REL8ncmfvDEhPWZr3BTdoSYL6yEfAgjHVj9E7Iv
	 Ee9jhNb6nabwTbRnJM5fAI/FcRgklzMm9FiSMUtHiSfl50R09UrWktLDALFPlej53y
	 aTT5cWoZ767UR0p4CLHNMThMqIKDfFUh+s1A2wsYTTtL8xk6EApXNSmYm5stF+xWWw
	 uq1w9a5PHD1KG0Ktm3jF3kOJ3+qru22BNIVWPln0Zt9ccFpYhA416Uvw1nvNuDwSfJ
	 hSU8AX8VDvSkdAWbYmcHosd1MTv7SFoSTXb/H7z7X2meTCDJpqCRyjWo5vJQgwCI+D
	 nJtUlokUgs/Sw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33B4F380AA54;
	Sat, 11 Jan 2025 20:01:37 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.13-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <0733034c-a280-4846-a501-70262a76fe45@kernel.dk>
References: <0733034c-a280-4846-a501-70262a76fe45@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <0733034c-a280-4846-a501-70262a76fe45@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.13-20250111
X-PR-Tracked-Commit-Id: bd2703b42decebdcddf76e277ba76b4c4a142d73
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 52a5a22d8afe3bd195f7b470c7535c63717f5ff7
Message-Id: <173662569574.2439897.3884683855137935032.pr-tracker-bot@kernel.org>
Date: Sat, 11 Jan 2025 20:01:35 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 11 Jan 2025 09:19:00 -0700:

> git://git.kernel.dk/linux.git tags/io_uring-6.13-20250111

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/52a5a22d8afe3bd195f7b470c7535c63717f5ff7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

