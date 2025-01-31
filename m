Return-Path: <io-uring+bounces-6208-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F7E7A24414
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 21:30:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B20EF3AA579
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 20:29:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2EDF1E9B1F;
	Fri, 31 Jan 2025 20:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="td4ws5Ju"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEC41F2C29
	for <io-uring@vger.kernel.org>; Fri, 31 Jan 2025 20:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738355186; cv=none; b=UUuhlpGmP2lNCNdmrYWaSCTm7TDeBFcplMBiE9VfyJ3jgy6w49uSnDsbThxzSeSkj2Ecvt405aoeEnI+BMrU7j5HYAvWNz/tlpi3ah+4qZYg7AvCQvSCOSKuRpk9g8/vwbi8Cydyooyb7bhKbA9iNccgCzn4GBE06la+QO5WTSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738355186; c=relaxed/simple;
	bh=j6Xp60HSxUHLY1kAi2Gh8tx0ciAwKMUhCtU589TPL6k=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=tAA3t4UntPHBorgMvT0pUuqryl9suWzB0364nguwhbNMAFHpGWp2i4ZcAYZiyWLsILKR0bOtgrphkFm0fHOVSaSMUEBljGxQOtNEhEZDCXkqqzWi8A9cZtGv2I4iEDvS0YQTA3e9rB2tYzw8IpVLlBd9kG31bzp2Cn/DkT2k+WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=td4ws5Ju; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709CEC4CED1;
	Fri, 31 Jan 2025 20:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738355186;
	bh=j6Xp60HSxUHLY1kAi2Gh8tx0ciAwKMUhCtU589TPL6k=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=td4ws5JuoRKqHnNedzOIR+8uo7UfYNgTbNKpc1dji/TKroM1jNW5jo7WvvV6Lcoca
	 Dd3zxt1lwLKjlfXp2Ilretu3NtsfzPotO1R7MituEmm7+KlQ5EBPt8MS2jc1O6EvGy
	 ksrZMjkJ/Hx56kTpqFSCOfLHVJsQkmQ7LMZGFx6nMyHc1godOmHQn1MMnBuUbE+sN4
	 fL4tsjuftI+kEF4LBtXtP6cj5Q61O/1g8Ei3TXL7/QzCxh5pjgep+nc9xJvkjGBX/Q
	 itTMPEZcLVaDruoB32xwVXvJuLz1kJ+NbcesWiMUChM/lMNRWws/rpuMaE78bwaWp3
	 BXgHEzmic94SQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33B80380AA7D;
	Fri, 31 Jan 2025 20:26:54 +0000 (UTC)
Subject: Re: [GIT PULL] Final io_uring updates for 6.14-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <d4331bf1-d6bd-4883-a460-fbd40ea837ab@kernel.dk>
References: <d4331bf1-d6bd-4883-a460-fbd40ea837ab@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <d4331bf1-d6bd-4883-a460-fbd40ea837ab@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.14-20250131
X-PR-Tracked-Commit-Id: 8c8492ca64e79c6e0f433e8c9d2bcbd039ef83d0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c82da38b28f39e0cca835139ab31bf80ac91f282
Message-Id: <173835521285.1719808.17274021608809077501.pr-tracker-bot@kernel.org>
Date: Fri, 31 Jan 2025 20:26:52 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 31 Jan 2025 08:45:45 -0700:

> git://git.kernel.dk/linux.git tags/io_uring-6.14-20250131

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c82da38b28f39e0cca835139ab31bf80ac91f282

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

