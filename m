Return-Path: <io-uring+bounces-8512-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C29ACAEBD64
	for <lists+io-uring@lfdr.de>; Fri, 27 Jun 2025 18:31:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BEE1164223D
	for <lists+io-uring@lfdr.de>; Fri, 27 Jun 2025 16:29:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E71502EA72E;
	Fri, 27 Jun 2025 16:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WOUijFqv"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E1E2EA72C
	for <io-uring@vger.kernel.org>; Fri, 27 Jun 2025 16:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751041738; cv=none; b=W2lISqeLcMo0MbGPodAiPZWRGjffEJbWyLq22nTAU8zn5jaVxguizEeBO0UCiK/LZOyzlqF53FWUZnDCpHQqa0tZDEijT7Rs7GGPrCj+EhzDrwozzT6Mrv3loD+ZAB1gAK89UERel9PiXeTvWQPtCTEIvXRaKvIIxvjhm9aPOWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751041738; c=relaxed/simple;
	bh=1xyovcnLuQVCyKPlZbF3+iqCErc9DWt3LVGLxRmNKQE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=YDaiyMqBxQb+bz1bR7jMCDRqJStAHy+njNlWPINHc6pkW76HvbGaUkBSplRhX39nSrkqbZjHWcQthH3X+qyxpwhVdvuDYqpSATj/cXZKL5dfjFrE6F/TPOe3+4VTo9GnfPfMBJJnz+Xv9HJUz/GVhBdquMN4MXNeXLO79AIxPBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WOUijFqv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4561C4CEE3;
	Fri, 27 Jun 2025 16:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751041738;
	bh=1xyovcnLuQVCyKPlZbF3+iqCErc9DWt3LVGLxRmNKQE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=WOUijFqvD7QPRqEABWMm+BfVQQytdxzjqqJabhiDT0DVnL3gUHvg0c0vN+dfsTGUj
	 xHYUCIdcFhFUdC0SSzKfUGXaykd0Di7HPOnwP/NoG7xFkQ3VSN9JWOg/cSGXAvbfGC
	 DDecssTK2qBvyuq1jWdG1oWUHyQsqeFXHIMRdh0pFI+BnucVY+HHtDWN/AZQRFrV44
	 Ohe1ggLRAPugg2ldwmMavvBkeXWqVDKV9EnSQq6RRO+EYr9yCqMBL9Jc+l0zexrOtb
	 6m05Dswa/TJhXXaNr13WdU8cPk7zY6J25D2obkqs6ydeGuCoQLBVqQoU90ELg6Tu9q
	 NwGNLLR9rieRQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAD68380DBEE;
	Fri, 27 Jun 2025 16:29:25 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.16-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <681fa987-b28b-4669-82f2-d8d89966561e@kernel.dk>
References: <681fa987-b28b-4669-82f2-d8d89966561e@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <681fa987-b28b-4669-82f2-d8d89966561e@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.16-20250626
X-PR-Tracked-Commit-Id: 178b8ff66ff827c41b4fa105e9aabb99a0b5c537
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0a47e02d8a283a99592876556b9d42e087525828
Message-Id: <175104176456.1986529.16905641735333062033.pr-tracker-bot@kernel.org>
Date: Fri, 27 Jun 2025 16:29:24 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 27 Jun 2025 08:25:24 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.16-20250626

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0a47e02d8a283a99592876556b9d42e087525828

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

