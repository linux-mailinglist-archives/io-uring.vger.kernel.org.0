Return-Path: <io-uring+bounces-148-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 910397F6A47
	for <lists+io-uring@lfdr.de>; Fri, 24 Nov 2023 02:51:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A75D28182A
	for <lists+io-uring@lfdr.de>; Fri, 24 Nov 2023 01:51:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5977A64C;
	Fri, 24 Nov 2023 01:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jwKBLpjc"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F54646
	for <io-uring@vger.kernel.org>; Fri, 24 Nov 2023 01:51:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C1E18C433C8;
	Fri, 24 Nov 2023 01:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700790681;
	bh=mNeN/s9cAkl1qHCV/SK+jmZHUDEjfwRIm9XiSpwRSI8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=jwKBLpjcZ75XGCSG5vJ2FsWAX+wEoiTUDXQJuS1C4DCq9feXPZPDUbHq+3tEVeWY9
	 SXc3VV6PANClCfg6cei4IjfEjkx/bAU7u+Fqv6zqQjIOdeSIUGs20OT5vYFrGkDxCe
	 6ZxuH+3WKhqGmgCR+FNx/wA0/avrtcfPrXaOLcyD02FA5Y1mi04OI4gnp9oez5HfvY
	 Z7SFA1R/eh4HTg7sAy+sdya5JQewvdhcurnVDVgsHXkUEHqWkMBXDFj8IGEH+3qpl9
	 MOHM+1+jKBunFbHnPRmVlBbokOWLER3uxfSX/RHr5wg6c2HphNELWZXmCWhlS9+/kq
	 R+w0Y6fyNLaFA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ADE92EAA95A;
	Fri, 24 Nov 2023 01:51:21 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.7-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <14e0cca0-03b5-48d8-8976-28170e105d8d@kernel.dk>
References: <14e0cca0-03b5-48d8-8976-28170e105d8d@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <14e0cca0-03b5-48d8-8976-28170e105d8d@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.7-2023-11-23
X-PR-Tracked-Commit-Id: d6fef34ee4d102be448146f24caf96d7b4a05401
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 004442384416cbb3cedf99eb8ab5f10c32e4dd34
Message-Id: <170079068170.3340.4562364280437171018.pr-tracker-bot@kernel.org>
Date: Fri, 24 Nov 2023 01:51:21 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 23 Nov 2023 12:50:10 -0700:

> git://git.kernel.dk/linux.git tags/io_uring-6.7-2023-11-23

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/004442384416cbb3cedf99eb8ab5f10c32e4dd34

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

