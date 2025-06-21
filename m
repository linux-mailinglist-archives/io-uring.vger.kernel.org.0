Return-Path: <io-uring+bounces-8446-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DFBA2AE29F5
	for <lists+io-uring@lfdr.de>; Sat, 21 Jun 2025 17:47:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7DF15189923D
	for <lists+io-uring@lfdr.de>; Sat, 21 Jun 2025 15:47:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6F62221FAC;
	Sat, 21 Jun 2025 15:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k9mJ00bU"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08A422156F
	for <io-uring@vger.kernel.org>; Sat, 21 Jun 2025 15:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750520826; cv=none; b=hz9oGit0Dy8/fXNkui07qRN/tL9b5a37c2rSWa9GLVPe/FGAU8FrseALtJRhrP9IqIO1nEZR8T0UEjmWLiJofm6GVxKW9SFisyoyepoVUu4vzkoLoB4sPJapYAVDs422Q86hXt2iTHWzUsP1oF31Y5N/1JU0/HMGm5K9+f5+efo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750520826; c=relaxed/simple;
	bh=QAQs7r+fz8EV2yOWtKxC2kQERwSc1slAosdfV8RvHvY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=shLI9U38m39VxEyIyKdp3R9PSnzLh2/ichHzT6jMgPd0Dolf9XzKRCrkqtHyk+4S1auZ/878h7KYMgjIwS+ENCyPVGBgW1IjvnUCDH2rqvN4eVyVgRs2jqrOAbofgi0wq4dSCDj3wIlOLDEn8sTtJWJj2FsxhyDk0L7/ymwRYrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k9mJ00bU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93FF6C4CEE7;
	Sat, 21 Jun 2025 15:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750520826;
	bh=QAQs7r+fz8EV2yOWtKxC2kQERwSc1slAosdfV8RvHvY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=k9mJ00bUxzcD4/1Km7VajJ8izFzF06lt5AMEszymWPVvlHJQc9EpLBPF15G5b9Acq
	 QisTg5e3eb/4t635M+Opdv6FzbddIrz7t4HV+cHlnPUHqs5XUT1bssmYzPbBSrVd7N
	 jYoIQrfFQ7C7iZ+Tseg8dgFp6R5nVYz+iE6bYURX3FwByxIrNIDhLrtgDgGOBoPD3D
	 XZEiodvCvpvOGMy/E+1a/9lPj8lJAo9tZSGOoGjF43W5A3xZwuwPRcXSdaQ1ISEm62
	 2cay+5johT/PSHY3RhoCZ0yfVABeo6ajWI1gLr8GUwACQcoIVzODQ9CSnrKeItxQ4m
	 MrnXtZQyiW06g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70AC138111DD;
	Sat, 21 Jun 2025 15:47:35 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 6.16-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <d84da304-de2c-4587-a78b-20efdff71787@kernel.dk>
References: <d84da304-de2c-4587-a78b-20efdff71787@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <d84da304-de2c-4587-a78b-20efdff71787@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.16-20250621
X-PR-Tracked-Commit-Id: 51a4598ad5d9eb6be4ec9ba65bbfdf0ac302eb2e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f7301f856d351f068f807d0a3d442b85b2c6a01d
Message-Id: <175052085408.1887408.6688069743352580354.pr-tracker-bot@kernel.org>
Date: Sat, 21 Jun 2025 15:47:34 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 21 Jun 2025 06:57:59 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.16-20250621

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f7301f856d351f068f807d0a3d442b85b2c6a01d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

