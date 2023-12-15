Return-Path: <io-uring+bounces-287-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C1A07815102
	for <lists+io-uring@lfdr.de>; Fri, 15 Dec 2023 21:22:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0046A1C23FE4
	for <lists+io-uring@lfdr.de>; Fri, 15 Dec 2023 20:22:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4571C46449;
	Fri, 15 Dec 2023 20:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E1SHKLr8"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB0E45C16
	for <io-uring@vger.kernel.org>; Fri, 15 Dec 2023 20:22:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A0B6AC433C9;
	Fri, 15 Dec 2023 20:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702671720;
	bh=LE8g26/norMKcKdic98HG1+UU2JMTMjH8uYJydKlW2Q=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=E1SHKLr8L2LHZjBmwbe1o+0ho0yECookG2sndpZEt2+iSR1NauLcSQzQV+DxluN86
	 Nbg5btLC4kKmfkwMjlABxjcjOWtOp0AfrXZSWYP+PVF9pIilmsBy0bmyrXLxkZ7q7f
	 02XUk4juA7G1yN4CC1Qc7a/Pk815iXeR4r4u45mD0uhL7T9qeP7o6H7dnbjoOSCJnu
	 fjfLp6DE+iGDprt7FcIeWlLLuJ2tDMlD7I+PSPDIkX548gQjiDXQtw/ArptFMDfO0H
	 vTauolgsjMih81MILP0Oyn1RYveMIsjCTIYGaQLxYzX0M62QL0uBcXWz9mS4d4IkSO
	 YdVZgUY9HBj4g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 88C7CC4166E;
	Fri, 15 Dec 2023 20:22:00 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.7-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <3c762dfe-f297-4b2d-b7e3-b0306fee349b@kernel.dk>
References: <3c762dfe-f297-4b2d-b7e3-b0306fee349b@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <3c762dfe-f297-4b2d-b7e3-b0306fee349b@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.7-2023-12-15
X-PR-Tracked-Commit-Id: 1ba0e9d69b2000e95267c888cbfa91d823388d47
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3bd7d748816927202268cb335921f7f68b3ca723
Message-Id: <170267172055.14933.8293855249028163895.pr-tracker-bot@kernel.org>
Date: Fri, 15 Dec 2023 20:22:00 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 15 Dec 2023 09:48:29 -0700:

> git://git.kernel.dk/linux.git tags/io_uring-6.7-2023-12-15

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3bd7d748816927202268cb335921f7f68b3ca723

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

