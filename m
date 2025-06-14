Return-Path: <io-uring+bounces-8343-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A511CAD9EDD
	for <lists+io-uring@lfdr.de>; Sat, 14 Jun 2025 20:13:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D2E861898450
	for <lists+io-uring@lfdr.de>; Sat, 14 Jun 2025 18:13:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CA4E2E8893;
	Sat, 14 Jun 2025 18:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WaXhXXym"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784532E7642
	for <io-uring@vger.kernel.org>; Sat, 14 Jun 2025 18:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749924635; cv=none; b=GuWuNmznvwNwkt7U7oZ5flPeI4lwDJ17ysJpiib05TEShkJOKXxxIFf05KIA1t8Xz5DFptt0yZEzu9FcUI4CPyM5pWayH3x1SR0gJeODMSx8PFDR9ljyV6UGkA1bmSGl2F+VvJsREEYFkZ3bLJxHDgA+52F4zqV9eX/zzuQf53c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749924635; c=relaxed/simple;
	bh=U8FIR/PFzcx3nUGI5jIGlx8JXiJvSJC5ndQGb/2gXKM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=GBVmHIwaxgt3m8As9RMbZicYNUpwzhpU8wQXK6B5IZiRQECeI4ttshbv4WWBq0dWnLWW+kvfSE8R0qJxNNJ0GGK9xT8PtQwtZrYadVLjw/sifS8P3FkoA8sPcBKMHNqO3dUWn4Dqu6illFqBhTC2NM+D3NzK86kK0uXXddhZxhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WaXhXXym; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E4FC4CEEB;
	Sat, 14 Jun 2025 18:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749924635;
	bh=U8FIR/PFzcx3nUGI5jIGlx8JXiJvSJC5ndQGb/2gXKM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=WaXhXXymWpn1fkNrthyP7CtAdu/aI2zn/Fx9dZHdEMXXSd6WLJn9OgKoY0xqE+BbS
	 oLSYB7ZQP4x74ES3XcWNenrHM2NC7g+gwktI2A0Zdl+D+F1DqM75eZOiclIa3TUFdA
	 soAGHGyjKFENojZ6YTYlQWPKr/7P9CH3pg+jBZuv8rx5nI9oY7SlgxG6iYN919hXtR
	 RgGx1HJe4fLV6Z6iCitkdtQ3E0oKb/WRWDWes+f4wO390rbde0ZC/dTncNpSPR89My
	 w4FX1BlZ4JEp19lc55+Y51+vKQs/8JIpTBRTu6e3cb945ooJKlcFbBJWvTb7e6AH26
	 RWHVpskEox64A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EABAB380AAD0;
	Sat, 14 Jun 2025 18:11:05 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.16-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <2b9b7ac1-31e1-4e1b-972d-81ede60d2c05@kernel.dk>
References: <2b9b7ac1-31e1-4e1b-972d-81ede60d2c05@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <2b9b7ac1-31e1-4e1b-972d-81ede60d2c05@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.16-20250614
X-PR-Tracked-Commit-Id: b62e0efd8a8571460d05922862a451855ebdf3c6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6d13760ea3a746c329d534b90d2b38a0ef7690d2
Message-Id: <174992466448.1140315.13125748676256537729.pr-tracker-bot@kernel.org>
Date: Sat, 14 Jun 2025 18:11:04 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 14 Jun 2025 06:28:48 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.16-20250614

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6d13760ea3a746c329d534b90d2b38a0ef7690d2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

