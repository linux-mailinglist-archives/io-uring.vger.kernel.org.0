Return-Path: <io-uring+bounces-11313-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 21514CDEF35
	for <lists+io-uring@lfdr.de>; Fri, 26 Dec 2025 20:54:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 71B0930169BA
	for <lists+io-uring@lfdr.de>; Fri, 26 Dec 2025 19:53:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D6662222D2;
	Fri, 26 Dec 2025 19:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xoa6NF0Z"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0565F2609FD
	for <io-uring@vger.kernel.org>; Fri, 26 Dec 2025 19:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766778801; cv=none; b=rS8ZsBXpP9pQEJIuxSzB03KuxcxmtEQLJ+PagA6Thx6F2XUznEKlzNHgvgkjxpoz/8hpdcSObtA+gwEuY4jPTn7RbroChZjJZlycx4JiBAvsXVwIMr2xvndJnT1uflgs1Q0JQaVW62L7NVp6CX52Mjgbw4ARDZkoWzfmTzL87h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766778801; c=relaxed/simple;
	bh=pQPvuYgV//Im8cuo5JnrT56AJFxnl3pjFZoiHWhjWX4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=LY1F8y2yuAlkvNvQbomrelttdzHeIfEpQKZgJvHjNI/zmxZbkLPfQwPK4kkSc3yfMEdzB/K8mvUHWqnFNc3JKpoUrCVtn1xJCWfVwJ4xrG6eGCux+A84Yf00yppXr9SvTpcYRFJUB5zaCA/QELVTuqqYPY4tgKWmyVkpZCq3+/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xoa6NF0Z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57DCC4CEF7;
	Fri, 26 Dec 2025 19:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766778800;
	bh=pQPvuYgV//Im8cuo5JnrT56AJFxnl3pjFZoiHWhjWX4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Xoa6NF0Z2zAngvJMFJnNxUwce9nx5ZVg/w0uU4sFDVG1m7MmyNunb+4L/uLDaPKcF
	 MIM4nYiEAUVeECgAzQJk6lrs0lwvQr4Y4nD1uhhAhRvebPo57v7acfyjBunRIMxd1s
	 Tb0PZB+Bf1SrEIdrEA5slXmJigd5f2vt8kpUx1MwpOtjIKWcy1XReMxWfMq/Gc3pJ+
	 u6/xNEDTlXVlUn7Ap9QVqr8qYLKH1uwff3u/XjVqTbJ/dGn492bBq2RFw55rhIEG9+
	 9tO467r0BYLEPQbdNUhDMV22DdTrzb5sGIdI4BAG6PLOBPX62OZwea+mw/aFF+nhLP
	 BNqFpLvhS8IsA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 792F8380A959;
	Fri, 26 Dec 2025 19:50:06 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 6.19-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <aba6a23d-6b91-4f51-86f9-cbe26597ab04@kernel.dk>
References: <aba6a23d-6b91-4f51-86f9-cbe26597ab04@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <aba6a23d-6b91-4f51-86f9-cbe26597ab04@kernel.dk>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.19-20251226
X-PR-Tracked-Commit-Id: b14fad555302a2104948feaff70503b64c80ac01
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4079a38693910c44780b31cd3cbd220b4144e473
Message-Id: <176677860505.1987988.9075188445568286246.pr-tracker-bot@kernel.org>
Date: Fri, 26 Dec 2025 19:50:05 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 26 Dec 2025 08:51:42 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.19-20251226

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4079a38693910c44780b31cd3cbd220b4144e473

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

