Return-Path: <io-uring+bounces-10990-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 544CFCAE75E
	for <lists+io-uring@lfdr.de>; Tue, 09 Dec 2025 01:15:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1649E3015174
	for <lists+io-uring@lfdr.de>; Tue,  9 Dec 2025 00:15:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3AF31FF5E3;
	Tue,  9 Dec 2025 00:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MrpJLfsB"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD64D1FE46D
	for <io-uring@vger.kernel.org>; Tue,  9 Dec 2025 00:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765239356; cv=none; b=UCHDF+tNtdpL4lBw7rEl+vJpof5w3jGxBAz3dYqRLDvgSITcP472J4wuY7W18z2pK9C6R6pl/495gRLh1blNgNw3/Q8SMIBJDqbnO7WEKyFA7BObod3geutvQWi24GvNJRC7mNIdcnhF+3RVAjjAqZjRKMzG46yAWnnRfUgKX2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765239356; c=relaxed/simple;
	bh=MdJpGJNlipvkZoTc0Lc0qgxWfZ82022k+60eoBOiMcw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=JTPpqj3X8z5qzAIICYJVXSTKZvaJ8nKc8pVjQhTnL0kv8J6F8sFQvW5W3oD+IzDhGYM/BduXi3wQt0z6e3ALjXf0SbF6TeRMpEoSyqrx6qdu8uHA/yG4oBY7HbHLHreKNi4P/I4c2XFzrmGld2OR3htVmG55/Dxzo1599ec1K+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MrpJLfsB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD2DBC113D0;
	Tue,  9 Dec 2025 00:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765239356;
	bh=MdJpGJNlipvkZoTc0Lc0qgxWfZ82022k+60eoBOiMcw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=MrpJLfsB22naBUikzr7wt8T/gZg9kU3MGw0bjR+6rXM2T9AdRUBOIBy753aBBGvzd
	 ciac4K3/s8ETMcxKXj2r1K11eWabR7iMNS1h1X5B2+Sq2jJlcHJlxrQDr6vASCkKJW
	 9eKBte7qJG8FDb+uJujtP3AcefXH5qwd+1X21Xu2xDOJxyUb7UkwP1ZRlvhAYF16MM
	 nZjFPzVF46wzW6rqQOar1YpzepmzfQGlBZaZepfnAmC90GUtNMXGT5AiOPdmHfcHxR
	 3QCY0vCx2rLnPfDAqOezh126leg6AHM0j5HtajyOr29+QnHLLIKSDkNWS9sgv5Ql5s
	 j42ED6KluYUEg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 788923808200;
	Tue,  9 Dec 2025 00:12:53 +0000 (UTC)
Subject: Re: [GIT PULL] Followup io_uring fixes for 6.19-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <fdab55a9-8a66-40e4-b824-b473b63c974b@kernel.dk>
References: <fdab55a9-8a66-40e4-b824-b473b63c974b@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <fdab55a9-8a66-40e4-b824-b473b63c974b@kernel.dk>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.19-20251208
X-PR-Tracked-Commit-Id: 55d57b3bcc7efcab812a8179e2dc17d781302997
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cfd4039213e7b5a828c5b78e1b5235cac91af53d
Message-Id: <176523917201.3343091.17072612878039707484.pr-tracker-bot@kernel.org>
Date: Tue, 09 Dec 2025 00:12:52 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 8 Dec 2025 13:31:06 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.19-20251208

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cfd4039213e7b5a828c5b78e1b5235cac91af53d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

