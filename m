Return-Path: <io-uring+bounces-201-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C21C38015BA
	for <lists+io-uring@lfdr.de>; Fri,  1 Dec 2023 22:49:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7BE10281DCD
	for <lists+io-uring@lfdr.de>; Fri,  1 Dec 2023 21:49:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B25255A0E7;
	Fri,  1 Dec 2023 21:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RMplYpg8"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961C059B6E
	for <io-uring@vger.kernel.org>; Fri,  1 Dec 2023 21:49:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6A631C433C7;
	Fri,  1 Dec 2023 21:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701467388;
	bh=GbV0ibqFP2Vc8KKNPuZkmwhIqXEWbwHaaL9+LUrOvBA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=RMplYpg8yyNCp+0vicLRd0p/jMCY0RAuqm5k6kkigyN7qGlNfyGxZrBCYTglfVtAk
	 talbGUgmYMD/Y3urr7tYcd7rPtiU2vmMzCTGTl7aifx+MIGH5/p0IwWSVLUWdVzcYo
	 UDi4bTpvK93zTec8dz884Wa5WMlysDIl1JDn67qTe8rgOsrbNN8aGiR7l7hOK+7TVK
	 eJlUUBNCq4D8c7IZUyUUZKL5TbPr8ar5IH+QXXIHJxVYmCNbVJgxDMCn+0xr2GpiSN
	 HmftcYQV+54JTFxxYzgq1FFly99s/WZFbHoWUzIgp5csLrbT7fUt1meG0L7UykOTfY
	 IPzDRN9JwYxqg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5881BDFAA94;
	Fri,  1 Dec 2023 21:49:48 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.7-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <a9499ad7-e4b4-4af4-8165-336aad7913a3@kernel.dk>
References: <a9499ad7-e4b4-4af4-8165-336aad7913a3@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <a9499ad7-e4b4-4af4-8165-336aad7913a3@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.7-2023-11-30
X-PR-Tracked-Commit-Id: 73363c262d6a7d26063da96610f61baf69a70f7c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c9a925b7bcd9552f19ba50519c6a49ed7ca61691
Message-Id: <170146738835.2332.18344969192605700590.pr-tracker-bot@kernel.org>
Date: Fri, 01 Dec 2023 21:49:48 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 1 Dec 2023 11:56:29 -0700:

> git://git.kernel.dk/linux.git tags/io_uring-6.7-2023-11-30

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c9a925b7bcd9552f19ba50519c6a49ed7ca61691

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

