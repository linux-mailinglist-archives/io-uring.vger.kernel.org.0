Return-Path: <io-uring+bounces-7257-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EF3CA72962
	for <lists+io-uring@lfdr.de>; Thu, 27 Mar 2025 05:00:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 675241896652
	for <lists+io-uring@lfdr.de>; Thu, 27 Mar 2025 04:00:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F8E61B0411;
	Thu, 27 Mar 2025 03:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T4rDWB44"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B84C1B0409
	for <io-uring@vger.kernel.org>; Thu, 27 Mar 2025 03:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743047999; cv=none; b=rhueiOuUT6P01jQHmLgQ6K7HMYGWmW4LFz10YCqhyo94I+b1dc2v7kBG9igbuJjaSyvfOO4rFLTndMNvbejomq/CMHxz8z7cJNWJQD3oYAIqxD8bWwGF+I8Y8ONBnkz1stU80EJmJ3gw5YdK+jx6IfsPMAzQg+yC3IrDBl2oJXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743047999; c=relaxed/simple;
	bh=lrrGpZ7zpWj5+rtPuV6ZACiKn90VOj3edNTBZiJY26g=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=S2mS5zmhRwVAiUXhIbhblsVQtju3JJK4kiQZWQD8up8CC2ScMw1I6IWeXA9vBtSf1Qz1BfBLjIcBtdPJzt90EXrr9zu5arY0U3Xrch98S2Ki/d7sDm1iIP1HPLneZrOa99RWSV8lHgfGfCj0IgDnBHUmb6Q/bTHZ7CXIvmDFqqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T4rDWB44; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E936C4CEEA;
	Thu, 27 Mar 2025 03:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743047999;
	bh=lrrGpZ7zpWj5+rtPuV6ZACiKn90VOj3edNTBZiJY26g=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=T4rDWB44+PaoFC7YG96cL4WeSbdFejM6ndUf/V/E7cBsQPEbljqLlizbdc13FCCfn
	 whLsgIQ6bTm4qu8mokI1BEnllXFMdwCOz8NCjdky46MTGo0SOGpLZEBRiCVoV4/1E1
	 +WACOkgC/AtdpXvPhOTIbNyTHJZGLDm+zMGuOlacaRHhblT9HKzHisC6eXShdM7tbi
	 uFfuLQOd9qx/jBU7x/6Ud8dNbeHvL2qBhDlXHaJByjUnBPZ5tfzAGrntrQEoZuZlJI
	 r7dRboCXzfZebQkWKircc1ENCs90YWCd3Uh9VKf/3s9jLK4pGJcjQ3ePZ3HKVlbDiv
	 Tdw4F/L8csAig==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id A9ACE380AAFE;
	Thu, 27 Mar 2025 04:00:36 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring updates for 6.15-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <c8ee770c-09a8-41d1-a417-0455361d1045@kernel.dk>
References: <c8ee770c-09a8-41d1-a417-0455361d1045@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <c8ee770c-09a8-41d1-a417-0455361d1045@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/for-6.15/io_uring-20250322
X-PR-Tracked-Commit-Id: 0f3ebf2d4bc0296c61543b2a729151d89c60e1ec
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 91928e0d3cc29789f4483bffee5f36218f23942b
Message-Id: <174304803551.1563585.9234883382362323192.pr-tracker-bot@kernel.org>
Date: Thu, 27 Mar 2025 04:00:35 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 22 Mar 2025 11:28:42 -0600:

> git://git.kernel.dk/linux.git tags/for-6.15/io_uring-20250322

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/91928e0d3cc29789f4483bffee5f36218f23942b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

