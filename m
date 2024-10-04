Return-Path: <io-uring+bounces-3423-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FD1B990A65
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 19:51:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A696FB21E59
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 17:51:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 209631DAC90;
	Fri,  4 Oct 2024 17:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hgsWPYTi"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC3E1DAC8F
	for <io-uring@vger.kernel.org>; Fri,  4 Oct 2024 17:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728064229; cv=none; b=AD6BhEI1kdnRM4Er1PT1Xxgs/BCmWtOy5o+/FLIJdfB5Uec6SczHZGLsby+P5ag7i7IX2Rzbj4ZlDqPyo/YaHuW4AXnE4hEhO5G8UQVNcOBh8VSBbzS94IplqQ5LgFSFC7Ot5u7vQ+zb0QM3CXIkmk5krvUOyY3vAPghyAlIZJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728064229; c=relaxed/simple;
	bh=mP18Wvhe6bB+ZdmASWBDWyWDdMxUfCOzzC5WY/RtK8k=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=cBxEW1b3MloliiImnpExjpLpzo/Z6Fkf0i7vJ6OPvA08WgKOr359lEUJYTq461yHcDy/mwpQHdNYgB90REu6YKqra3X1PPtqOXP4+3sY3G2dJCX7v3IqQs3SLmqll4rs/s1yQfOOmY6aWCZvhJ+fXEzKygj5WzK1JEs2AHXmkMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hgsWPYTi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1309C4CECC;
	Fri,  4 Oct 2024 17:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728064228;
	bh=mP18Wvhe6bB+ZdmASWBDWyWDdMxUfCOzzC5WY/RtK8k=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=hgsWPYTijqn7p7Oux4qD7cBmFRshZVKhmVNz0uwquBKjN9MV8MKK0DPgNs5kElTGP
	 pylrg26ctbYnaMkStF+JXqCmktdJggX+ZwLWQMDFGWZ8VX3SyRHhfQDnYgbWavY2ON
	 utt1TuI+SCIDir0vS8l3/plkTkdkxa30OI5GGTdll29yYXsypUTxGxGHoU0xH+Slwn
	 HaNfZPjjF3luwiyuJEJzGUEM4yW2sTH7mrL+bhA3yG58KPJK8GSiP9qmMcEyGFGizA
	 mmIwCasxk7LY57BowkRkvFzKwB9yR3ekKJpxQpwQAah9gHuIt2HYbn9kQ6R1NL1Wq6
	 PW6ioTs3Z+LqA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE7C039F76FF;
	Fri,  4 Oct 2024 17:50:33 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.12-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <08765cba-88f0-4439-ab81-ce949544cdc0@kernel.dk>
References: <08765cba-88f0-4439-ab81-ce949544cdc0@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <08765cba-88f0-4439-ab81-ce949544cdc0@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.12-20241004
X-PR-Tracked-Commit-Id: c314094cb4cfa6fc5a17f4881ead2dfebfa717a7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 43454e83916dc515e3d11fd07d50c40e6e555873
Message-Id: <172806423246.2676326.10451054637667863398.pr-tracker-bot@kernel.org>
Date: Fri, 04 Oct 2024 17:50:32 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 4 Oct 2024 09:10:53 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.12-20241004

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/43454e83916dc515e3d11fd07d50c40e6e555873

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

