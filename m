Return-Path: <io-uring+bounces-8264-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 28DC9AD091C
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 22:31:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B207E1BA004B
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 20:31:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 119AB1DFCB;
	Fri,  6 Jun 2025 20:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AeoHlEOM"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD37A31
	for <io-uring@vger.kernel.org>; Fri,  6 Jun 2025 20:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749241885; cv=none; b=BJd5NH49O4AGnqYfL4TGuhjPiIEvCARbaTMCEt8/dwOJ8gDbP6ZfdS2zuv06gCDp2ysZuBXLYlnQfXwB/74hu0SOfF7gz2UpzmFUK70TbqP2RATUKmIG5YhnnTxWpa56Ppbsckzyml0dvI/b0a1MrcBg2Fqveol5vCchOWfkb5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749241885; c=relaxed/simple;
	bh=8pKa5uhYrJ4XXSlRF7WMzHsX8zoAkkqeKo2VMMS35TM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=N+fV3jF+Pj9qWiSlJiJiYnHNkXJjAQO5yVADXcRpc/HxmibeRC//1fOi/TuylKxFtuW4fDHIIrX6FIdbK0WAfu56vr0yH5DmB9ieQ5wQ4pTs/TJLA61de0m1ce1KvLQMACf7KwNfhs7EA9zu+IlyWZ77gJvjJw8LnlmWDLvMR44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AeoHlEOM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F95C4CEEB;
	Fri,  6 Jun 2025 20:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749241884;
	bh=8pKa5uhYrJ4XXSlRF7WMzHsX8zoAkkqeKo2VMMS35TM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=AeoHlEOMTjE/06vgESgpeYIbXkBrlcjhZLcljCYKWAk/nc6jMyA7i4H7A7qlPnNPv
	 qZUoHBgKv1m/clkU54WvzkLdXXsouvDRP98QfiR9CMoH7tJK5xi0bqGxn+VWnM0m0U
	 ZsMAA+3Wqkj6QvDonBQVkAS64plyAsInAL7O78yRUgSPWjnu9dGXIav+pyBdsbz0Qg
	 sZqYVyaKvU2t1hSjYhRinKlgoxLU1vF2ILnFlTCd/VM7rRhL6oKelkPU+dLqEfPFe4
	 eJPbNGsNTU/6i4RZzSbwUfXv2xyDaQLuAjJZVXFgVTd431WGhLcNqefsSkt0BucCYP
	 J680ZQdwb5+SA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33FAC3822E05;
	Fri,  6 Jun 2025 20:31:57 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.16-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <11cd89b1-1650-4c73-b358-79ab4fe6916f@kernel.dk>
References: <11cd89b1-1650-4c73-b358-79ab4fe6916f@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <11cd89b1-1650-4c73-b358-79ab4fe6916f@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.16-20250606
X-PR-Tracked-Commit-Id: 079afb081c4288e94d5e4223d3eb6306d853c68b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 794a54920781162c4503acea62d88e725726e319
Message-Id: <174924191578.3982463.8767420495722575078.pr-tracker-bot@kernel.org>
Date: Fri, 06 Jun 2025 20:31:55 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 6 Jun 2025 07:46:33 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.16-20250606

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/794a54920781162c4503acea62d88e725726e319

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

