Return-Path: <io-uring+bounces-10945-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 74714CA2495
	for <lists+io-uring@lfdr.de>; Thu, 04 Dec 2025 05:04:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 32B6B306314A
	for <lists+io-uring@lfdr.de>; Thu,  4 Dec 2025 04:04:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41D6B42048;
	Thu,  4 Dec 2025 04:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PrXYOyTs"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B568398F99
	for <io-uring@vger.kernel.org>; Thu,  4 Dec 2025 04:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764821053; cv=none; b=oqhjPnsZvG3gR+AHTAFxWcZWtAOy5WqLuFeJ6eeHAho0QshmxK3ddvMZMPI62vwb9PNZkl3QBY+LlBScSn3sgxN03TEUl8pcIw6RBVKCEvZ9i1uy/Q1zmuJuFYQ7evfiDEcrqBU0BKB/XOkth9G583CADDuULdxubaX1v0wPWF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764821053; c=relaxed/simple;
	bh=gTNULjsB5LtBZN6mtB0rj2zScQlQAcgDAC3F2n9HoRo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=TIRQmybDjIxvCkXzwxO151++G/XXzvivAuf6iaPKu0kZ3qqIuoLG86JfaIdujD0n43LgAg66hC6aVFmZtlWNZDy+wfcvrVLuYz6EJoYLg5wiIIFu8GutHoe0im8lbCEgWBlILnZuERmkMfvdu4+0gKreXneU3pDZrkfb7s7uJjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PrXYOyTs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3940C113D0;
	Thu,  4 Dec 2025 04:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764821053;
	bh=gTNULjsB5LtBZN6mtB0rj2zScQlQAcgDAC3F2n9HoRo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=PrXYOyTsyj0ME3oDTdUF8rvGoXcLeoa4qXFpEFHJ3XZXxhpz1EUUPW1Cm/gvfk53+
	 O+VDJaJbNMGe7QeNTTu9rNILGXryCrUFOj43+xaKCAaq9mH1BCw9oRjFYuKF79Am7V
	 v5/tG+8+BKTJChIgnctDbtmEAtHRgsow6g9T7oqlmSA28iKNbZpYrHjIxTC41evLRp
	 ZxjfxkX94dAT1OVi4gtmYOeGa+nBwLnrcI+0HY1kZKjB3n/CiDq0/xa/Z9CnxMkuV8
	 Vg5XlKDkKIpbtlut9eLfddlnxDVtnpE5OoMQQgvGzNNCu68rhimNo5YWSBrPrENAhC
	 nVL6EnKIodS3g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B57723AA9A83;
	Thu,  4 Dec 2025 04:01:12 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring updates for 6.19-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <973ff83d-995b-4b0a-a800-3941aa0082ef@kernel.dk>
References: <973ff83d-995b-4b0a-a800-3941aa0082ef@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <973ff83d-995b-4b0a-a800-3941aa0082ef@kernel.dk>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/for-6.19/io_uring-20251201
X-PR-Tracked-Commit-Id: 5d24321e4c159088604512d7a5c5cf634d23e01a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0abcfd8983e3d3d27b8f5f7d01fed4354eb422c4
Message-Id: <176482087123.219416.16545501328199812158.pr-tracker-bot@kernel.org>
Date: Thu, 04 Dec 2025 04:01:11 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 1 Dec 2025 08:51:46 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/for-6.19/io_uring-20251201

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0abcfd8983e3d3d27b8f5f7d01fed4354eb422c4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

