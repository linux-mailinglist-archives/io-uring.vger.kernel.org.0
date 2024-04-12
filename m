Return-Path: <io-uring+bounces-1531-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 62E048A3516
	for <lists+io-uring@lfdr.de>; Fri, 12 Apr 2024 19:45:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 19B901F23CA7
	for <lists+io-uring@lfdr.de>; Fri, 12 Apr 2024 17:45:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48872446BD;
	Fri, 12 Apr 2024 17:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KeNirwp8"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254BA84A35
	for <io-uring@vger.kernel.org>; Fri, 12 Apr 2024 17:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712943937; cv=none; b=A5OFe9R4fIbbmIZnfkkW6TqeIVIjdKnsYLr94RK7GvoC8x8L3ZyLLiDqtWoiOfqTmBVudh/LALe6K2QEV3+w6XX2R5hsWmrVWYLQpS9LAKPSh7PwWTjKUtaN97Y2ayZnU9q19M/xB93gIOii5ipZ9FNM/kO26Eiw3/J+A2EaJVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712943937; c=relaxed/simple;
	bh=ajylR1T7+dCKpF+i+XrMSkmlQ/6LxlaPJq9MDUwWi88=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Sy4kKz+XRednjWrn/0UFDl8rNp2uySZoWDIHhpwQGwCPfrRZoJou2egtxKPCXEWeTWC+DUdvZyEfulW+AXPSAoWHt8bZPkDC264/iVedNhnpF+QlMyIeaQDgEcrrBqAJ2Ous6QM8n6vtbHCQRke2EoQwyx3MFGkNKEzD6rR86uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KeNirwp8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id A0626C113CC;
	Fri, 12 Apr 2024 17:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712943936;
	bh=ajylR1T7+dCKpF+i+XrMSkmlQ/6LxlaPJq9MDUwWi88=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=KeNirwp8MhdJsQfmkqIfJm08oaFG+dzDK9ycYSswWQmzA0u507IJSLnTarxXmux3/
	 mMTZIZUZ/N4Nwy95953CV5Kf4wxd35k7lK9lk3yQIvsm7p8XSqjcVChU+R5f+OCdVB
	 ARvSVCRLcIDAd8/jdfgoJjdjBH59Es83Bq1wLrjEeJ+sqEcFjhWp/Won/724PWzaWJ
	 2plaCY/wIam34JwJQ2+QXRAYoclFgiJLLSpdTyQXX69jAI4YcDu8+DsUdFg7ADGbOi
	 Sdp0dr4S1dBVbvZJtPoCv2yc+/K09+LLFxID2u/ryyFNIVAjDsVKC//8dkPiw893JO
	 4E3BiXgP2PHZQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9567CDF7857;
	Fri, 12 Apr 2024 17:45:36 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.9-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <d9cb3787-7373-4963-b3dd-1ce21ecd415e@kernel.dk>
References: <d9cb3787-7373-4963-b3dd-1ce21ecd415e@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <d9cb3787-7373-4963-b3dd-1ce21ecd415e@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.9-20240412
X-PR-Tracked-Commit-Id: ff81dade48608363136d52bb2493a6df76458b28
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c7adbe2eb7639c9408599dd9762ba2fa3b87297c
Message-Id: <171294393660.29341.3765902125195771933.pr-tracker-bot@kernel.org>
Date: Fri, 12 Apr 2024 17:45:36 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 12 Apr 2024 10:46:23 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.9-20240412

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c7adbe2eb7639c9408599dd9762ba2fa3b87297c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

