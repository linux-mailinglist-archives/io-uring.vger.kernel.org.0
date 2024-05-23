Return-Path: <io-uring+bounces-1954-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E4498CDB8B
	for <lists+io-uring@lfdr.de>; Thu, 23 May 2024 22:49:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D98E51F230A2
	for <lists+io-uring@lfdr.de>; Thu, 23 May 2024 20:49:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0831584FC5;
	Thu, 23 May 2024 20:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mJ4Jwl43"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D579484FB1
	for <io-uring@vger.kernel.org>; Thu, 23 May 2024 20:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716497346; cv=none; b=RbCmQBm9qAsOCEgevZv9T/fUHZtoiWF17iWpczPcP7Pe4JnAjK+MiSP0Fzx/iTBEMriL3GK/uVvO1HJBCbdGo4XO1MKr7PqTBEbZGpfbfY68xWu9L2mSL7GnkHQmKlALPz3KrSGE7jWHC2Mu1W+J7Bp3vRjJnahxIbWPI/l5OhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716497346; c=relaxed/simple;
	bh=VYkwjMHrViinNN0/E6oF1oV7PXjPopioFibBzLX8yVM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=o0ayqDkQwdJ31gb5xfJ1wFx6y2QubxD2cv9x5vjtp99yvrTyM/BlmhA5ogUyVCByl+m4QXcla8caY6Xb4Yot8tDwMEnibNXMbnE78hI+YVIPaSF7bB1MWkK6WmCol00SPF+8A0mOE6eFVxLtuc0ECeFDiz5KgPggP0psi4mKfE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mJ4Jwl43; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5FE13C2BD10;
	Thu, 23 May 2024 20:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716497346;
	bh=VYkwjMHrViinNN0/E6oF1oV7PXjPopioFibBzLX8yVM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=mJ4Jwl43Vb1iIH649tvMuQVk5MZDSrujxLziEo0Lqhg253Vs/dFzgJIVwJBd8AhDl
	 RKgtVH8nzNd4uImeDB69Ycb2XPhqp5hVh5jx+zvVwEDjZaDKYJfwMJO+qqLfNvqtGt
	 6fAwxjz/Mv3TEeEb38Yhbo1glQTxw9kvNiptsLMy+NjPQWCX9Pfue1mXzPoC/2ncwa
	 c6tXZObGsFglem+V+O8C2t2lHIAKhgPtwiKa+U/+hSFzxfMDdsU2o1Fat+26ygHULM
	 2CaksBXrATQxBjZhyYCkNiWaiJnsp+8l/nnz5Cy9+hUjBpydiHs71J2nQ6oDnUt2N5
	 cCfUgGG+R/22g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 54797C54BB2;
	Thu, 23 May 2024 20:49:06 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.10-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <986ba297-eb14-41cc-ba16-b74062ff3470@kernel.dk>
References: <986ba297-eb14-41cc-ba16-b74062ff3470@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <986ba297-eb14-41cc-ba16-b74062ff3470@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.10-20240523
X-PR-Tracked-Commit-Id: 547988ad0f9661cd9632bdebd63cf38e008b55b2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 483a351ed4d464265aed61cab4a990b0023f8400
Message-Id: <171649734633.28255.15996097387132553898.pr-tracker-bot@kernel.org>
Date: Thu, 23 May 2024 20:49:06 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 23 May 2024 10:12:00 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.10-20240523

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/483a351ed4d464265aed61cab4a990b0023f8400

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

