Return-Path: <io-uring+bounces-1417-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BEFB89A7DF
	for <lists+io-uring@lfdr.de>; Sat,  6 Apr 2024 02:10:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BAB6528279C
	for <lists+io-uring@lfdr.de>; Sat,  6 Apr 2024 00:10:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50D5B1DFE1;
	Sat,  6 Apr 2024 00:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SJWlbe5L"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9B21DFCB
	for <io-uring@vger.kernel.org>; Sat,  6 Apr 2024 00:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712362208; cv=none; b=qJi25QssXJT9huAivFJ3jAtWLsFAtERnMbyI/R5EOisY56SaX93SATGbKgkyuvjWF6AHVLlI/STZ+Jq6EUzT+3Lb/kuGsbKBweOn3ykI6s0yHZc1mH3RdewNUrrn8bSg7bkWFYypzo87JSEU85O+eDtzJK00PPbY5G12/hKLF6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712362208; c=relaxed/simple;
	bh=/txZ1dZZ6sieT6Npl5U21+ztzUyXQdQts4laumFkCRU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=P8/d508osYuxHtKdUbpGA+AgF/Ozysk7yBHGzb5f6Rjzz0ZFDBQgqtqtPMOyv7cTkJ2gx2uWUxN+iECbd7ePczdCMGgsFCwBX4HOqVaP+uEPGBHo+svI6QheA1tp748zUzWkBp1M3LUumJaa9cyKSzcgukhKTQhTsAK8ZeDTxBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SJWlbe5L; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id B0FF9C43394;
	Sat,  6 Apr 2024 00:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712362207;
	bh=/txZ1dZZ6sieT6Npl5U21+ztzUyXQdQts4laumFkCRU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=SJWlbe5LpSvLvEKiMngZOqL5YoXMKIBbLsRA/a10HBYcQcuN3MyVv6+4fQT6wj77g
	 kzOATooODjhCSrhTispqMhbRT9ESnhczPxWmYWJ77yyF8Grs9mOtFgBN/DhJ7AL9/7
	 AhHakyC7Iqtl7zB9UX9o6M12vywAd/IXDPWT5QBsdL5F3nkM9MeOT214f1+1yMuzPH
	 nhqFnF59TMvefYd5bpr5cmJSvm2fXG585JQLtcCZ+DPwz7h1kHoX8isZ8JtyPo0VTw
	 Ks99cm/nim4GN63YHSDFG32aLbh0Y8gS90hFAsHPMBUX4w7hGHYvZy/JNxsDbsM6iP
	 hkPK0/MFaPV8w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A88F8D84BAC;
	Sat,  6 Apr 2024 00:10:07 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.9-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <ceeb1b95-070a-4812-8a43-12a638da4c94@kernel.dk>
References: <ceeb1b95-070a-4812-8a43-12a638da4c94@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <ceeb1b95-070a-4812-8a43-12a638da4c94@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.9-20240405
X-PR-Tracked-Commit-Id: 561e4f9451d65fc2f7eef564e0064373e3019793
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4f72ed492d7798919269a20d157d34495a988935
Message-Id: <171236220768.3482.10209751595714340151.pr-tracker-bot@kernel.org>
Date: Sat, 06 Apr 2024 00:10:07 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 5 Apr 2024 14:46:55 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.9-20240405

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4f72ed492d7798919269a20d157d34495a988935

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

