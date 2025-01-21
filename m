Return-Path: <io-uring+bounces-6029-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BE748A17706
	for <lists+io-uring@lfdr.de>; Tue, 21 Jan 2025 06:30:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B4B733A83E1
	for <lists+io-uring@lfdr.de>; Tue, 21 Jan 2025 05:30:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CD7D1B21A7;
	Tue, 21 Jan 2025 05:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k0pv4YE6"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485091B0F14
	for <io-uring@vger.kernel.org>; Tue, 21 Jan 2025 05:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737437405; cv=none; b=AQsR1EPjD/LeY5Odv+DhJmej4tQi7kR/miXK1T/KH58T6izCQ7uf/9AqwCoSSPjIHctyaVTvT3va7aEZ1vzxKR7LW0Nez3Hw7dq+zvnLDMW7fOzi/b4A0CKZ+g9/WQSN35PFabmE1WUtUDBGT4yxkV9y57y43kIqMVEtnmmrOSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737437405; c=relaxed/simple;
	bh=pNzaNf2zOcslRNqgnepkr0jeVcfLHK5mgraVdqPzjLE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=u8CBfydt569UH9R9aNd1+znJRfrURpT0j86nrkrHmSUu+xdBlzWZbSEbTik+Zkw+nW8WZz1G4EEsPrm/A4K1/enBV13peJ3E5VhlZm3b7ri5AVeUzGW9yFto9+IDcSQR7YPELcObSvw/J7txD/eYeHI0kjPO9spGAQnGJyiyNts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k0pv4YE6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263D5C4CEE4;
	Tue, 21 Jan 2025 05:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737437405;
	bh=pNzaNf2zOcslRNqgnepkr0jeVcfLHK5mgraVdqPzjLE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=k0pv4YE6Unjyk60c2Md9pUFX82rj4ZU1DqsL82TVWk2NTAmj2g0zUOe5oH0xNbcdK
	 MjW/qq8w9y/ZpOHSNCqRWAYGfthmMuhlyZG05wR6Ok2NoypMO0vyRHLdLQzKTXnhR1
	 GA24Gnmq9tzuKk4DT7/JRG8+Kri4erACX7kxLD52S2GYro22TSaqA8iouzhngXR0Sm
	 uzMi0iFVFc7cPf2DWK6AYZDLdDEmoFEHdk0PymCTkkBT1Bq/nD0MRoOHF5hCmnQq9T
	 MYj0E+2P3SDGh0S9W1unC4elCRVcnGAfFNBUH9oc1yHgMTdPh7VIwg3hZnUc84bfMf
	 AOaYUFa3q/guw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 77782380AA6D;
	Tue, 21 Jan 2025 05:30:30 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring updates for 6.14-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <1481b709-d47b-4346-8802-0222d8a79a7e@kernel.dk>
References: <1481b709-d47b-4346-8802-0222d8a79a7e@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <1481b709-d47b-4346-8802-0222d8a79a7e@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/for-6.14/io_uring-20250119
X-PR-Tracked-Commit-Id: 561e3a0c40dc7e3ab7b0b3647a2b89eca16215d9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a312e1706ce6c124f04ec85ddece240f3bb2a696
Message-Id: <173743742936.3745731.18000883731238057669.pr-tracker-bot@kernel.org>
Date: Tue, 21 Jan 2025 05:30:29 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 19 Jan 2025 08:05:26 -0700:

> git://git.kernel.dk/linux.git tags/for-6.14/io_uring-20250119

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a312e1706ce6c124f04ec85ddece240f3bb2a696

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

