Return-Path: <io-uring+bounces-10643-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 065EDC5ED8F
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 19:26:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 8069A363995
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 18:21:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECCFB31C595;
	Fri, 14 Nov 2025 18:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gm+TgY6L"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA32F347BDC
	for <io-uring@vger.kernel.org>; Fri, 14 Nov 2025 18:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763144439; cv=none; b=GJUpGa7CYu2sy0UFJ8twVrdQs72VN8zeyjVrUgsdRlnw9b5ynsHJpnPy4bq677V9TxB6RUv80S+tT7hvKtcGwCR9+CqZA5pPfTAfg6yfQn3w9vAKK5l0mpp6xUgX/hYQH/uBSrP2n6uw98x9RjDcWylYPG4RJ/PjrWHXRtmhApM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763144439; c=relaxed/simple;
	bh=oTx5WZBhOnayVyDCZtYZc5ykPgo57VqQq61QJp5/FUQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=bTJod5pmxB0zXdyutBp9yRLFZljnjBZ47d+rob6sWZRLcrQQJq8cCHwgu2fpkrGcU6q8qxpEDZx28p7xYEqP6nFtsUjgGrjWuDMIMPsdlT69yUhG8cwMpQpriH6YB12dbt7E1+heuhZBjmK3dDNDDhODFyIlXDwgjM5aC1sGZjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gm+TgY6L; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C7FC2BCAF;
	Fri, 14 Nov 2025 18:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763144439;
	bh=oTx5WZBhOnayVyDCZtYZc5ykPgo57VqQq61QJp5/FUQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Gm+TgY6LMG2dj4uAoSo/1LbUsgQI19tN2BpICnF8J6IA8xfbsH9V7Kq6OBdRCx87w
	 DeEOy5sFyiAD/wRbwxaaMpY3HbT69f/NxgVPFFzK6wF/qjYVARirGXsusoWXjukCYm
	 MRJcCxBCHY+FkGGcZI5tKh0xIO+9m8PWfkhN8jVpti5XanrIwEVfIWPG8dbn3sWP+5
	 dxU1zb/OdfBA446kyXjovymN6XwmlT9Z+fsrNUG/5WZQptNEbkT1U+1XEQsCovtDdc
	 IVfXON3fowAeqG9k3QqPC1Q9YC240AMB7aJL4qc2x7gEPGMcjizl0dX9COobvi49go
	 q8RWI7Ni3a88Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 711283A78A5D;
	Fri, 14 Nov 2025 18:20:09 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.18-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <962882e4-207a-49a3-beb3-81067ead6681@kernel.dk>
References: <962882e4-207a-49a3-beb3-81067ead6681@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <962882e4-207a-49a3-beb3-81067ead6681@kernel.dk>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.18-20251113
X-PR-Tracked-Commit-Id: 2d0e88f3fd1dcb37072d499c36162baf5b009d41
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ac9f4f306d943c1c551280977ae5321167835088
Message-Id: <176314440796.1790683.2721090713694539631.pr-tracker-bot@kernel.org>
Date: Fri, 14 Nov 2025 18:20:07 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 14 Nov 2025 05:29:51 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.18-20251113

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ac9f4f306d943c1c551280977ae5321167835088

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

