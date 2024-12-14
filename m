Return-Path: <io-uring+bounces-5495-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F0BD39F1BF1
	for <lists+io-uring@lfdr.de>; Sat, 14 Dec 2024 02:36:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C4D0B7A085E
	for <lists+io-uring@lfdr.de>; Sat, 14 Dec 2024 01:36:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BBE2101F2;
	Sat, 14 Dec 2024 01:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OaQABXJw"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175BF14012
	for <io-uring@vger.kernel.org>; Sat, 14 Dec 2024 01:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734140166; cv=none; b=NojmsXKdKSbSWjAtSiDVuG1az0vno09linyVpqUkWwf+moEjaGW5jxGqHWrwu7abdH/mG/Fa7X1KIMX3izpKWL9K0I+r2o1LK65/5SiHjoZi11g7gg8Ss4N5qro274pMmA2e5NokU8s27tPwaKAe+DHkfRb+ARddH1TbWNpRh3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734140166; c=relaxed/simple;
	bh=cN2m1r2bKnllY5MDGEcCmuQpwMnb8A6TSBu7zQvk790=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=eJJDtxLPosGptTEYcY3gAl0t2IRJh5IXCcRbiKV5m1+FKbvdltAYMivsOUKIwj9k96IpZALP1/7Bo5ktgHR9FEfeEEbKDZu2yVrjYpTwswkmPJeofjr4vCozULvOW7Tb5iyq0wgOWi5yvz4tNlXkxxVbG/HscNDU+ycUgbhzz2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OaQABXJw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD3FC4CED0;
	Sat, 14 Dec 2024 01:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734140166;
	bh=cN2m1r2bKnllY5MDGEcCmuQpwMnb8A6TSBu7zQvk790=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=OaQABXJwC3eN7/7s3NIN5xoZSq44Ff7zBhpna5v0M1g9W+usw48nPiReLvmNj3j78
	 7j25Zuf/IqySrttB25fOcN1E9p2c9Owfx5DUCRJlKT3UfSITlWiP4Jc39PBh6VmGqn
	 N/IpM7+ksZj6YykiCGtYT7I7r/UcF43TZB1F//aVmlsYNaf/1MUR5sZKRa8TSSs5ts
	 yAqbikJpogG3+766Tgjv8XoqJiFp6KYVwsn6aTthOYA1SKkgZ+3e794csFY83Gk2nw
	 1DZFK8uVZbwD+yWIEXmX6RuVw0l7bQg2ONiT5vMBz5ClUpYLq3c0vxKqXuUp2jG7/x
	 qpX6b/puntZMQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADCB1380A959;
	Sat, 14 Dec 2024 01:36:23 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 6.13-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <a92669cb-c413-463e-b2f1-ddea802dad0c@kernel.dk>
References: <a92669cb-c413-463e-b2f1-ddea802dad0c@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <a92669cb-c413-463e-b2f1-ddea802dad0c@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.13-20241213
X-PR-Tracked-Commit-Id: 99d6af6e8a22b792e1845b186f943cd10bb4b7b0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2a816e4f6a407cfbd7a8345a0c09473eff656139
Message-Id: <173414018226.3218065.13960161341959793495.pr-tracker-bot@kernel.org>
Date: Sat, 14 Dec 2024 01:36:22 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 13 Dec 2024 13:46:12 -0700:

> git://git.kernel.dk/linux.git tags/io_uring-6.13-20241213

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2a816e4f6a407cfbd7a8345a0c09473eff656139

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

