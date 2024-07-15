Return-Path: <io-uring+bounces-2513-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 776D4931CA8
	for <lists+io-uring@lfdr.de>; Mon, 15 Jul 2024 23:36:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 226971F22CA0
	for <lists+io-uring@lfdr.de>; Mon, 15 Jul 2024 21:36:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C0CB13E05F;
	Mon, 15 Jul 2024 21:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DQUPj4Ro"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050AD13D28C
	for <io-uring@vger.kernel.org>; Mon, 15 Jul 2024 21:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721079348; cv=none; b=lVkmMnL32yJXV+84Nh3m4qcoKRnAGIW9jjknkKAlriECv0tVZQz0nWGWBVLX0s310SF2wsRHiB2xX85SuV1dTDXSsqoCovqEDk8UZYCHX2DMd3Az8afJMZ836qFmbrXFVG1+DAlNim26NjVyiMKA03zsZOUrcHVsit6ZA+/7dbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721079348; c=relaxed/simple;
	bh=cRiALqqOBCJ8WamXLE3RGwuWB0T7T4jkVNBS30SV0jg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=G7/5qdBjTTTpmDnX2hI8hA+BFCmPsSqQwqdxMHkVCwIRwWd6+PyCXCg5xed4MtMJ1qZo1/sC+AhFfuKY84YvpFJjYgshI9gWmCZLfS7pf0hWUwssV4PamAi9IZoPgxfeyX9vGyG7FkMeNbVIG+7cpR5LLsX6q3fhirxuMPwUOyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DQUPj4Ro; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id DCA00C32782;
	Mon, 15 Jul 2024 21:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721079347;
	bh=cRiALqqOBCJ8WamXLE3RGwuWB0T7T4jkVNBS30SV0jg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=DQUPj4RoA7/gp2qVPTvMd8x7maQ0BAjavFBZ17EsIcaJ8m3T9sDc+pVUeV9A9vFww
	 TZo5xgNYRDckWr5/i81fGB8K496LWAR3L23LaVzGu9t7z/rpWOkgp5VFBpQWcY3Ex0
	 yTgpsXZY8otlxXm/bSRW+0RKIWxvOnSSCNjROSfOvqfDAvJf+YMMAJnvZgY5LMRaqg
	 T4Er3Kc3/pLg2YMSyciGMgF+KSFlOFggK05YwlTR8cVspaHTrLDJZkWbJRmqbdjaPL
	 38OWUmWeUlH7TsfadOAcRMcn02TF87TfQI7jI5P91LVMzLh0Ds3Iym5Zca/KdwpbrJ
	 +7fnnIShkTVYQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D44A0C433E9;
	Mon, 15 Jul 2024 21:35:47 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring updates for 6.11-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <5e5b2431-dd9b-488e-a0c9-578008e14208@kernel.dk>
References: <5e5b2431-dd9b-488e-a0c9-578008e14208@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <5e5b2431-dd9b-488e-a0c9-578008e14208@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/for-6.11/io_uring-20240711
X-PR-Tracked-Commit-Id: 943ad0b62e3c21f324c4884caa6cb4a871bca05c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ad00e629145b2b9f0d78aa46e204a9df7d628978
Message-Id: <172107934786.10457.2955676489865681932.pr-tracker-bot@kernel.org>
Date: Mon, 15 Jul 2024 21:35:47 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 11 Jul 2024 23:43:36 -0600:

> git://git.kernel.dk/linux.git tags/for-6.11/io_uring-20240711

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ad00e629145b2b9f0d78aa46e204a9df7d628978

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

