Return-Path: <io-uring+bounces-97-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EA1CB7EFB3F
	for <lists+io-uring@lfdr.de>; Fri, 17 Nov 2023 23:16:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27D151C20869
	for <lists+io-uring@lfdr.de>; Fri, 17 Nov 2023 22:16:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E6FA45009;
	Fri, 17 Nov 2023 22:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XxZHjdFX"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1308B2A1A4
	for <io-uring@vger.kernel.org>; Fri, 17 Nov 2023 22:16:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7A9BCC433C8;
	Fri, 17 Nov 2023 22:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700259373;
	bh=y7/b1Fw+Cn3WCATXMmvNp8G9RJOkhxRJ9VPPlxtuNA4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=XxZHjdFXa2FOupE1CQ5bmxcOa04qbIoGAV7XEbUm4L4N1yonEdOtKNwaVgUNEulDn
	 jBSilmCtdMLtDemkaXgMc7UuS7c1qKE5RBjlR1JO+nfR/RDUZEAaKh1yxPFbuc8AfQ
	 ZYguCJ5wCu7gsSyHy18JoMcb4NLvTJcEWOTkrg4D0q63tlZ+R8wtZ0LCw3NJkrQI1d
	 qkXuHVhVT33kVTazjr7VET9xDb1ZVEDA7aP1htt/P3vPZ1MtQWlSBANKJn46e9RQmg
	 dPfjqpDxK8qgAGaQ8V1Pqgc3mXG27u+aiqvE8EL0paA0VFx8N3Uv6V5V1WH2H3ejMs
	 lKoQP8bG81klg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 68E14C4316B;
	Fri, 17 Nov 2023 22:16:13 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 6.7-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <f5892835-cf39-42ad-8280-e9f63498ea96@kernel.dk>
References: <f5892835-cf39-42ad-8280-e9f63498ea96@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <f5892835-cf39-42ad-8280-e9f63498ea96@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.7-2023-11-17
X-PR-Tracked-Commit-Id: a0d45c3f596be53c1bd8822a1984532d14fdcea9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0e413c2a737f4ce8924645ee80438c3be7c44ee3
Message-Id: <170025937342.27809.3958351771960602408.pr-tracker-bot@kernel.org>
Date: Fri, 17 Nov 2023 22:16:13 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 17 Nov 2023 10:41:23 -0700:

> git://git.kernel.dk/linux.git tags/io_uring-6.7-2023-11-17

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0e413c2a737f4ce8924645ee80438c3be7c44ee3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

