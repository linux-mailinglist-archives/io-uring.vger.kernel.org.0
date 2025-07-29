Return-Path: <io-uring+bounces-8854-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 61A10B1453C
	for <lists+io-uring@lfdr.de>; Tue, 29 Jul 2025 02:13:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B120A1AA19E9
	for <lists+io-uring@lfdr.de>; Tue, 29 Jul 2025 00:13:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1C001361;
	Tue, 29 Jul 2025 00:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F9f49BcM"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB524A02
	for <io-uring@vger.kernel.org>; Tue, 29 Jul 2025 00:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753747983; cv=none; b=eIM+INAggRN93fkI+6V5AgxgfeERfWjKLdKub0WDc4QkDNCvdAWPz/BZLdG016kIfnv21GB2V5mQfa5o4bRp2JZ8CBAouywChCQUJ+Y4rNr9gS8wjEbIsp7iBcQu+kigX0ixOYxUjV/JfEmYaibWov3ssBbOCKRNd0tpO1BGM1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753747983; c=relaxed/simple;
	bh=FpvjPwiA80lmvgvJMRNsGhe0xZYwKg/F+zawgEHtL+g=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=RSCw8ZT9UZiSX5RsWrIYYHB3swSmrFJq8Q3KP53wzEJk6Pi2hcsS9Ba6+ucpMkXSk9APplSA+gopxPQfZszNoTi4XkhfjBeZ6Hb973HGpmP492X1L5nphlLe9hj63IKp7ilbpWAXIWlguUvzcy9VO7fAg7MYU7tXFVDOh4N39lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F9f49BcM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D0EFC4CEE7;
	Tue, 29 Jul 2025 00:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753747983;
	bh=FpvjPwiA80lmvgvJMRNsGhe0xZYwKg/F+zawgEHtL+g=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=F9f49BcMZ1s4DhdIUXRTNCAnqoJzHdYmf8cBv52wJhdeltSi3KMKCq/t2F7/m9rq9
	 aA80AKf/HZ+J08l6Uj7VxW848/bXwaY1gQbbswUg/C6yyrOMA10DbKLJ8bAKjM6bwO
	 CyQ0NTpf6vRecs1vx0jigdtGBPKUwZwRSq5f1fAXU1U4uYUodxPqHEfiyHtAI/a6it
	 PycU2ZAKNY1x49Mwxs5im1BZYOgj8M2OaVdi0Oz9xufQqDpeIcO2R8jiDKs6n8RhJo
	 bVAtFM4F/bCJrmipbQelWeHuowU7/KiTk28McxbNpM+EH1rl8rlwNXmvgsok9bw8rC
	 chrd3VziKdm2A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33A59383BF5F;
	Tue, 29 Jul 2025 00:13:21 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring updates for 6.17-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <1219f4d0-7014-43cc-8fae-26918089795f@kernel.dk>
References: <1219f4d0-7014-43cc-8fae-26918089795f@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <1219f4d0-7014-43cc-8fae-26918089795f@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/for-6.17/io_uring-20250728
X-PR-Tracked-Commit-Id: d9f595b9a65e9c9eb03e21f3db98fde158d128db
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c3018a2c6adae9b32f7b9259f5b38257ba9a758e
Message-Id: <175374799970.902610.4619906768569121750.pr-tracker-bot@kernel.org>
Date: Tue, 29 Jul 2025 00:13:19 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 28 Jul 2025 07:02:58 -0600:

> git://git.kernel.dk/linux.git tags/for-6.17/io_uring-20250728

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c3018a2c6adae9b32f7b9259f5b38257ba9a758e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

