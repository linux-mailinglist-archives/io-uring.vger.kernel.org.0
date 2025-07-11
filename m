Return-Path: <io-uring+bounces-8647-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 067C1B02305
	for <lists+io-uring@lfdr.de>; Fri, 11 Jul 2025 19:45:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF90D1CC29A1
	for <lists+io-uring@lfdr.de>; Fri, 11 Jul 2025 17:45:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91B2A2F0C67;
	Fri, 11 Jul 2025 17:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bcItQrZs"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0481A7AF7
	for <io-uring@vger.kernel.org>; Fri, 11 Jul 2025 17:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752255863; cv=none; b=OaMIneYy9AJ25Qp8wLyzmJeqP2le85o6Y+yoUQx4LA++DS+4afUNQ7MpsSQBh5tGcDMBA1pm7aK+/xdFY1m6Vxn1DumiZh9VaHLvghZgTcza67V7EPJeoydZRkpl/MbaLp3PoKeenbTH9xwKYrvVDhBjyejWnLJuN0OrCX7MQqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752255863; c=relaxed/simple;
	bh=kgl/Z1OtVDx6fzVmltVYkeF2IH7mnfGEJuvjTTLjdH4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=td3OIGGCfYkf8gQnBfHXSwp9Poo/2hOwyF8AhaTOuD7eVzmawTsIhApI9QmiJKgMbCzht2m/VrP4rSRevdCOZuMo1YaTx1nvGNzWcti2wnHwXYzNLYavqFEqVaWV/2/FDH2I5PP+JnSuKGJ/NhMXts54GNjjh8sDXrOzBbPu2zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bcItQrZs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 513CEC4CEED;
	Fri, 11 Jul 2025 17:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752255863;
	bh=kgl/Z1OtVDx6fzVmltVYkeF2IH7mnfGEJuvjTTLjdH4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=bcItQrZsZwRhbbEOURAEox7YF30NWLh7uZTCEM7fghznBoOXEhuUv1RjfT4PeNz4Q
	 254u66s9K5rKnGe51jM3au9OcG13oGFnka5MgrgaRyyGm68Co6EnqMOg1lmSs3IQmH
	 yjNpcht9pfd/DmEXb3z7Yl7rnGwE6XK4eM4nczNJaMwGHviyqpnI/jaMGhJ5dgCMrD
	 DUnMjGCouRuRKxkMbp3fvmrP8WHiaPWrJx+diDfO3Gi5H2FZc3U0AlC8g0v4d1wQjB
	 VBdUamKaazZaF/gtU8Q8fByVD7JACUiMIu+Dmn7A39IGg6S9leyGYPSV+U+21ryGRi
	 PcCq9f1q+TIcA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70F9A383B275;
	Fri, 11 Jul 2025 17:44:46 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.16-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <bc75d13a-cea1-4a0d-a849-84b1379a1bc3@kernel.dk>
References: <bc75d13a-cea1-4a0d-a849-84b1379a1bc3@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <bc75d13a-cea1-4a0d-a849-84b1379a1bc3@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.16-20250710
X-PR-Tracked-Commit-Id: 9dff55ebaef7e94e5dedb6be28a1cafff65cc467
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cb3002e0e977a6342c19ba957b971f7ce17ef958
Message-Id: <175225588492.2350666.8045400600918800880.pr-tracker-bot@kernel.org>
Date: Fri, 11 Jul 2025 17:44:44 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 11 Jul 2025 07:47:44 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.16-20250710

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cb3002e0e977a6342c19ba957b971f7ce17ef958

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

