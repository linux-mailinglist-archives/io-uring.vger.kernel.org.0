Return-Path: <io-uring+bounces-11795-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4783BD38C6C
	for <lists+io-uring@lfdr.de>; Sat, 17 Jan 2026 06:03:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6D9E4301EA39
	for <lists+io-uring@lfdr.de>; Sat, 17 Jan 2026 05:03:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 386BC30C378;
	Sat, 17 Jan 2026 05:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z5YU3zE3"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15619500962
	for <io-uring@vger.kernel.org>; Sat, 17 Jan 2026 05:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768626193; cv=none; b=hcAdi6QIpap0nwkwfLQdDvsZMdChz2W0/Bf7Hsb0/h5WOtEUNTThpZkW7hkI/ZrPNUg9IqtNV3TMBWREgin6LukevY/gmb/soJF5dJZvYL4mPLW8RY2rda8bdU7V3/8iABsDqnOJ9VCmQLh95F7yE0b9xjv91WyiJM9m4NixFfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768626193; c=relaxed/simple;
	bh=VOMOp5Gi96FWvxHNKu3SEx3pBjXh00E5HfL9iODpe9c=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=RaGk0sPuX1bL1bKT1/SFrZ/52RLUfL806j84MqucVLCuANAaVg3zvYBSAvhmwi6uICcLss5GlsF76f0QVQpx3QEc4+eO3okhDt5/UZoK1h3Zab/Z0s74D2qkwie5d1iGayS/x4qSQqTCTXQozC3UQPJReFZgrXR4W/b08FnAFzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z5YU3zE3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F45C4CEF7;
	Sat, 17 Jan 2026 05:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768626192;
	bh=VOMOp5Gi96FWvxHNKu3SEx3pBjXh00E5HfL9iODpe9c=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Z5YU3zE3gTYa+7Bb6kdI2qyrpG5b6XZ+YLZfWG2BL1PG6PHemmYgkcO3RHLt4/PP8
	 pj9XKq+lxJzIBrwaS8QZnuONbr953fOOpluEkRY/MtXu40qyRrqdNE3NpiiD8H+y0u
	 pk1oEd71rlTbr06yClZcCxX5Q3cgy06AaETIRbRgeSXHREjQZu+EZzN43hhgWWs3xP
	 0EcBqpu7u+NF7d/qhAatxwU708Ivgdvjmsc9VXV3kKOCFMU+eva199C+URJfI+sSAz
	 uQgElfrN9eDgiJILC7DCgNmulxjl9ugGO+1yfVz0yyagBW8EirDbrJ+WvxO7yf5L3G
	 t4vUCSu12VbSA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3BB74380CEFE;
	Sat, 17 Jan 2026 04:59:45 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 6.19-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <ab5cffa7-4799-4e34-a340-be1a8ff7fd61@kernel.dk>
References: <ab5cffa7-4799-4e34-a340-be1a8ff7fd61@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <ab5cffa7-4799-4e34-a340-be1a8ff7fd61@kernel.dk>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.19-20260116
X-PR-Tracked-Commit-Id: da579f05ef0faada3559e7faddf761c75cdf85e1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 216c7a0326c6c598c7c3d4450200af33982e35e2
Message-Id: <176862598379.903237.15735449421073031257.pr-tracker-bot@kernel.org>
Date: Sat, 17 Jan 2026 04:59:43 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 16 Jan 2026 20:50:35 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.19-20260116

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/216c7a0326c6c598c7c3d4450200af33982e35e2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

