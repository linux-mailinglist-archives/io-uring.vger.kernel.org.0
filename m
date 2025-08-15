Return-Path: <io-uring+bounces-8979-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BE0C0B282B5
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 17:10:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55586AE5435
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 15:10:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AA1E28C865;
	Fri, 15 Aug 2025 15:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rndXqAlB"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1BB22578C
	for <io-uring@vger.kernel.org>; Fri, 15 Aug 2025 15:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755270657; cv=none; b=I2oeUxM+D8475mrOJiNvJ4qbthpA48as6SeCbm4JiTam+HNyTkppkXm1dbGFCVEWhTt76ZXIFg+8GdutaTwZ9pDJMJubsFghlb2zBcO6mOZ/QGIL/KJjO1iryNH7BlYPEy4yHFxveba+s8OQq3W0zBqa1q0Oedwl6iokR9EzqZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755270657; c=relaxed/simple;
	bh=J/2VQXOL+w9X0ylnP4GHU4WU9bA+9XCqqDdsKonIQCs=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=pHgQUoZfRLuDXbrydRzABxwR/pB3F54UNrvqqqeauod/kNVEAhPoX0S/mHWlfob9BQnmD6SYeO0GaQ2WGC8pQS6ACiuHRuolYtO6X/S/+4ycF/yU5csI2TMeQbH3wZgmzkGrvdKAS8v9s5A4m8+5IEbwBcVP9k3RbhtI8PXp61Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rndXqAlB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72956C4CEEB;
	Fri, 15 Aug 2025 15:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755270656;
	bh=J/2VQXOL+w9X0ylnP4GHU4WU9bA+9XCqqDdsKonIQCs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=rndXqAlBAwdXC61E/pMb7h0lEynYmMlLjbruk8nKachdYwPFRmo25QsqVYGD+yz7Y
	 3cUGTFmdJvVZ29wyHQM3nZUQwOjwx7pEhqVJN0FK77DIZ7ai7qjkPQYcq9kJ1vSnzN
	 P0lOjoz/TqF7QUO1CL/UmnL8oPsII+433YBKLcAbF3ITi+liGeMVM/CJA35vkES6xU
	 tVu47JZTx4ZbUXx0eBDP7pYnfjpdz4Du58lPF+V41gQ0vzu02Js0yWTnKYPgbtmGT0
	 ux114vCv3BLNwJ+q5a578yz7+RmA8noxIXARlIfB45WKKktyTuhuatBDNZYrKRiE8Q
	 k6PZoZd2jojmw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B1A6139D0C3D;
	Fri, 15 Aug 2025 15:11:08 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.17-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <dc23ce94-35bb-4224-8b9f-2d456f05a561@kernel.dk>
References: <dc23ce94-35bb-4224-8b9f-2d456f05a561@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <dc23ce94-35bb-4224-8b9f-2d456f05a561@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.17-20250815
X-PR-Tracked-Commit-Id: 9d83e1f05c98bab5de350bef89177e2be8b34db0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4ad976b0e8ea3247c607cd37abb09440806f898d
Message-Id: <175527066715.1124927.11831839514089007314.pr-tracker-bot@kernel.org>
Date: Fri, 15 Aug 2025 15:11:07 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 15 Aug 2025 09:01:39 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.17-20250815

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4ad976b0e8ea3247c607cd37abb09440806f898d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

