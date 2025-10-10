Return-Path: <io-uring+bounces-9962-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 51572BCE378
	for <lists+io-uring@lfdr.de>; Fri, 10 Oct 2025 20:25:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 04A4819A778F
	for <lists+io-uring@lfdr.de>; Fri, 10 Oct 2025 18:26:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CBD022B8D0;
	Fri, 10 Oct 2025 18:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VvZjvHRI"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666C221CC61
	for <io-uring@vger.kernel.org>; Fri, 10 Oct 2025 18:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760120747; cv=none; b=oj/9OT6iWMhj3pbfMX4MscL7OHafoP7nTz58oyy3iGHb1scyfby7f801iLXEGWVVJsr3plf76SW9KypbJh2cx0ehFXvNPDU48aOXO5/PDuLkViP8ZVhXjwH5tbhAEDINm3Js9q0n3Uyonb9we7vox5xiM9D/jrYrJ6hTwPxTV+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760120747; c=relaxed/simple;
	bh=vW/zUa6DNYeb7XPjrnRe4Q13e6y9iDF1hH6bXoLOvUQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Czqvw4EZM0SFtWDN3eCxMfyuui02TabK8wcppc0u9AlXq81xp2JQlkRjRPrNJcLYKkYEFkbKZsCIids+/Z0IDVAFWkhgULJyjtE16YpbHgX3y+kWr3mpkTDEz/yckonqwI8YaZYo92m8rRXmpxkQgodOvUY1ygClZC2TKkJ1TLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VvZjvHRI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 476DDC4CEF1;
	Fri, 10 Oct 2025 18:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760120747;
	bh=vW/zUa6DNYeb7XPjrnRe4Q13e6y9iDF1hH6bXoLOvUQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=VvZjvHRIgeTnAyVc5m+VYjH48amUKoS2Qds3fMIiD+Cy45aaRp559eW1CquaBWUqF
	 bemqIaqBVq+Iix5XwbkZdIdDjrLoWSlKxVcKiqvBzeDZr60E4pc99yR2/jvbghPiFd
	 fLqbhofhX31MTfdhy2M8YEAtWixsr1uCZqV1uKgzfN/XWFCN91LoUw1tw+Dxhj1m64
	 VLv46xqIIYPqiiZFM3BPGMpEHfSHbijdg4UOhDS5KUgyUBCJk7DVOhRjUeUYS0H6MS
	 RCeab8xDZO8Hf0gFK9jU+/qTWzR5coMqAaxi7TxnTV8ubel1CGE+2Xi2+5B87QWPNX
	 6Q/mnjoJLzGHQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAED43809A00;
	Fri, 10 Oct 2025 18:25:35 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.18-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <503fa8c8-e123-4a08-9c01-7c60232798f4@kernel.dk>
References: <503fa8c8-e123-4a08-9c01-7c60232798f4@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <503fa8c8-e123-4a08-9c01-7c60232798f4@kernel.dk>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.18-20251009
X-PR-Tracked-Commit-Id: e9a9dcb4ccb32446165800a9d83058e95c4833d2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: eba41c0173c8c27702b720730ed9d399088409f0
Message-Id: <176012073459.1074429.15271923111626100929.pr-tracker-bot@kernel.org>
Date: Fri, 10 Oct 2025 18:25:34 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 10 Oct 2025 07:27:16 -0600:

> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.18-20251009

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/eba41c0173c8c27702b720730ed9d399088409f0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

