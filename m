Return-Path: <io-uring+bounces-7164-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B7FBA6C1BC
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 18:41:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F2F5A485858
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 17:39:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D35D222D7A0;
	Fri, 21 Mar 2025 17:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dOLhGMdG"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB7522D7A4
	for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 17:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742578771; cv=none; b=DplLOuMZI91WRMMdvxAo2RbdM5H+lovxIP48f64a+ClCpXszg8BljmmuZZBwDBUWap7J0z7ftzPtY6PIVynzURxUi0mThZSLJ/damUDD6Nkd+BEHD6Uz+xIky7uhvkngtkvqyUGKQxIDy6TgybTDEKpFWRxVzKNRjQil4ijpXYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742578771; c=relaxed/simple;
	bh=3aBfQ/susEbCMJ/8KH/uMjp1/AYooD/edtSDHPOA4gI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=teEDqFcTITN5CTKR5MGvs6wbbjh+41miSrLlstLpr4ZCGV0R8VUtWnwVXAPqOtR+vmzn5CEgPoow7yi3xoNvaKdRfhfaal7VSOncHb2PsrIB00hV/xBSqayE3fRb05oJt+8cV2wjFLJRvDE7OA517PAdpo3c7QATlQhrAh5DexQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dOLhGMdG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB37C4CEE3;
	Fri, 21 Mar 2025 17:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742578771;
	bh=3aBfQ/susEbCMJ/8KH/uMjp1/AYooD/edtSDHPOA4gI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=dOLhGMdGY2fn6Bjs8LtHbRcPfQaKxboReoDeti5GKjmBLr6kRq4vuqOZ0K9XtM9k4
	 /d5//Xfs0kA6zZD+9cGh5sRZpmj5kvAp8KF2nvcH0ub7IjVTYP1PJxFh5eHO9gWfey
	 /akUAyigRD0x3NxHa8/CvcbZ/36DrsmbikWVZ3zsA5zLyCWGNt9TjAvpRva9SSxyi+
	 W7sWfgKmJU+ho5q09TTe5jmg2F1IGTXFX/qm+Cb3OQNGksvnlty0VsxAmFQ8nOJ17f
	 GsjmqehR0ZPDqN/ki9sAUEcPw4s/3HhWcfsEZfL9boYzTWsvfZmiiCkoyz7R8CViSD
	 oS+i410rAkysA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7548C3806659;
	Fri, 21 Mar 2025 17:40:08 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 6.14-final
From: pr-tracker-bot@kernel.org
In-Reply-To: <9f3a5862-cd77-462c-bb8a-3cc26f905391@kernel.dk>
References: <9f3a5862-cd77-462c-bb8a-3cc26f905391@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <9f3a5862-cd77-462c-bb8a-3cc26f905391@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.14-20250321
X-PR-Tracked-Commit-Id: cc34d8330e036b6bffa88db9ea537bae6b03948f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d07de43e3f05576fd275c8c82e413d91932119a5
Message-Id: <174257880706.2568513.10469142209466929774.pr-tracker-bot@kernel.org>
Date: Fri, 21 Mar 2025 17:40:07 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 21 Mar 2025 06:53:13 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.14-20250321

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d07de43e3f05576fd275c8c82e413d91932119a5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

