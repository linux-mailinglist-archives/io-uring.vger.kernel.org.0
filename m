Return-Path: <io-uring+bounces-10729-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id DB962C7B7B7
	for <lists+io-uring@lfdr.de>; Fri, 21 Nov 2025 20:20:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3EBF94EACFF
	for <lists+io-uring@lfdr.de>; Fri, 21 Nov 2025 19:20:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 865022EA168;
	Fri, 21 Nov 2025 19:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OjC6vv3j"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BE42D8367
	for <io-uring@vger.kernel.org>; Fri, 21 Nov 2025 19:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763752825; cv=none; b=ZNSzSz1GBkX8iI8FKHX/fLVdcyCsJ3rjF++hlAq0vudpi0gediXBTWrfHlUwQC5cCycoFVKYNquXLvqqAkwws9K3AXKE8PEy3d0OYKe5GvSCMt9NXUDEE+0yXgauJXQLB5Pc9cIfHminw/Q9CeWQMUdGdzfo8iotfTgLt6PjwdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763752825; c=relaxed/simple;
	bh=vNkqXkGWiesZv3FMoV1jRLWMm68gbsvZkiEw4mvulLs=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Q49F9/fGnKkPnp/M8KRxU9piV3DKJh0kYGm8fshLyEb+ZGNLrOcZ0Yb4eJFEf/ZUzpA+bui+FHZ3o/Utefest3izH+at6eUYIrwGjW6fh42I19jcCqX0P2qrZKdRCCGnFJ7zkvoNsofI/sDhmXBySrENBIEHZgxueTX4THzHWYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OjC6vv3j; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D15E0C4CEF1;
	Fri, 21 Nov 2025 19:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763752824;
	bh=vNkqXkGWiesZv3FMoV1jRLWMm68gbsvZkiEw4mvulLs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=OjC6vv3jBJHoBhVCPVF4wxySb5f3coAWjcPGOyxFEqyZ40AdWEhePUkfxindFHHbJ
	 XQJi/GOcBmK8phqLrVD7csLiyXmRJ6rrhCyleK/HYL3kgakEGYnoCGEZGUpuVLDfV9
	 XatFxSKGH1afQ0SkZqBfrjci5gI8PjC7D7mcr/uUEBkmfg67DCYzYtNnCGGtiHu/Qu
	 59k/gI03mrR/oiBX+9HkSezSrVkOvZ8jtLB0GuNdc/Jkuy3aCxE3WmSUGyLmtqmPkc
	 UpfBbDduM1VkscxUuOmGnpFkhG9oJ4YGB5WCKG8IVYq2Ey3QLdKjvP6INcZaE8U8TE
	 RAOrN6RlRC49Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADD3D3A78A5F;
	Fri, 21 Nov 2025 19:19:50 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 6.18-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <55fa81a1-45d4-47fa-a452-bc9891d5101f@kernel.dk>
References: <55fa81a1-45d4-47fa-a452-bc9891d5101f@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <55fa81a1-45d4-47fa-a452-bc9891d5101f@kernel.dk>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.18-20251120
X-PR-Tracked-Commit-Id: 46447367a52965e9d35f112f5b26fc8ff8ec443d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a07a003ce6d475014e71e1c4f52f4ed7146dd35e
Message-Id: <176375278933.2554018.3598410845045771746.pr-tracker-bot@kernel.org>
Date: Fri, 21 Nov 2025 19:19:49 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 21 Nov 2025 10:36:40 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.18-20251120

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a07a003ce6d475014e71e1c4f52f4ed7146dd35e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

