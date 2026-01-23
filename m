Return-Path: <io-uring+bounces-11904-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oKmGFlnnc2nhzQAAu9opvQ
	(envelope-from <io-uring+bounces-11904-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 23 Jan 2026 22:25:45 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 12A267AE28
	for <lists+io-uring@lfdr.de>; Fri, 23 Jan 2026 22:25:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5A4F5303D392
	for <lists+io-uring@lfdr.de>; Fri, 23 Jan 2026 21:25:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7F4729993D;
	Fri, 23 Jan 2026 21:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BjvzOFct"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96143271464
	for <io-uring@vger.kernel.org>; Fri, 23 Jan 2026 21:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769203497; cv=none; b=Us/X73zxkye1EpYl8K6aoMck2oZrWixHzxPaGgg4neIPIM1uxa5W511vb8oYkzn41oOXgjDgwBhnmQMif2wGcMc3AOq2f/sfijvjwIrCZ0Abk/W3Zjv04UKTcl7slJbu4tlOjy6e7y+eQLqHbSvCZcE0Y+++wP5ncdWCUVk0Y9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769203497; c=relaxed/simple;
	bh=XnM8fBIhSJhztyMPTWlQq7lqGQKY88feHa+rH2bGRSw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Y5u4GVTMokguc3Mc59CDzxz5YhufnfiADX+LmOYJJIBxKLtz+jCbC+QR6YQfg9tY2eLYFs3vC8Ih+pzbPZCwHVL92BUwGvC9ZVaQ4nkBU1R04FfwM5KtEWrVrefvwEKQvDNpL4eBOHHBpjivGWuzEZsBFoPHlF+54jxTmGWIPiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BjvzOFct; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BAF8C4CEF1;
	Fri, 23 Jan 2026 21:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769203497;
	bh=XnM8fBIhSJhztyMPTWlQq7lqGQKY88feHa+rH2bGRSw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=BjvzOFctavPyh+O159eg83DrjcZo4IK/oZC04Oiufmy2GjHK4kFw59LOXcxZVuHko
	 VagIpFVT3EjPz+uaxO4y+kjKyy4DhPFiX1KHWHI53LdGEymM7c7YK0+xuprsiTgrWJ
	 Hs5VuET6aBAJ1oQ3/z3yydBkyZaaADHtyXI/DqrHdP+XhU9g2qvHBxRS5TKtLUDtnH
	 mkt/6Vn2n0Umf94rBme1VLbzaI/wJJwZXdAtYyPFQkon3bvmTusVxDuyydAz16ZA5r
	 zs7gSiOa0hCycH54A+1M9YhG3EaUzzdVvg8O1FChPUi05jZjLw24rAafTUYY3tvyaI
	 IV0w6wpSfew4w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 4E7D13808200;
	Fri, 23 Jan 2026 21:24:54 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.19-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <40479c6a-b214-47ea-a777-f600cfa03acc@kernel.dk>
References: <40479c6a-b214-47ea-a777-f600cfa03acc@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <40479c6a-b214-47ea-a777-f600cfa03acc@kernel.dk>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.19-20260122
X-PR-Tracked-Commit-Id: 145e0074392587606aa5df353d0e761f0b8357d5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7907f673d0ea569b23274ce2fc75f479b905e547
Message-Id: <176920349295.2720183.4154260727694229262.pr-tracker-bot@kernel.org>
Date: Fri, 23 Jan 2026 21:24:52 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11904-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_NO_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-0.989];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[pr-tracker-bot@kernel.org,io-uring@vger.kernel.org]
X-Rspamd-Queue-Id: 12A267AE28
X-Rspamd-Action: no action

The pull request you sent on Fri, 23 Jan 2026 04:48:29 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.19-20260122

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7907f673d0ea569b23274ce2fc75f479b905e547

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

