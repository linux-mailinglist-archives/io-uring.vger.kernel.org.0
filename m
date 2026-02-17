Return-Path: <io-uring+bounces-12298-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wKxIGMerlGl7GQIAu9opvQ
	(envelope-from <io-uring+bounces-12298-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 18:56:23 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C326614EC83
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 18:56:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6BB9E3042258
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 17:55:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2FD0372B44;
	Tue, 17 Feb 2026 17:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OjcV1ig4"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD38A372B21
	for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 17:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771350926; cv=none; b=cCPsg5twJJagTbUGa9SYXv2cS1HDDghcPmk7O+PwqSJ+7XmW/SIE4KWzNqS3rl1lnyF4Wgq87D+2HlFPzVQGkV8M9/QXzEULXrsKd5giyU4bSOQkFIRsrPyoOJQZeu+qZtuZd0qSVLaAPN0fsDKEQWhfLbSnQ+lfq4GTSo2Iju4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771350926; c=relaxed/simple;
	bh=5y+mFtYG1mCgsp3nLDEd4gL3YUvfW7oCFg5P1c9nTK8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=lRfMo/KveJ7dBwpyFnYHGYFmMDImSuxkIOIbT+LQ29fNlc7P4BnQVAXD3q2hpxxrFK3E9+BpdGrsCoW6fzyrPLaWD95nCvhVwcojEmmoSbLQu43iXvBzEr2bBBQCPPawz089zLMW/HiiCLfvcZNovPZy/pwpdrbgTc/niku6JBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OjcV1ig4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F527C4CEF7;
	Tue, 17 Feb 2026 17:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771350926;
	bh=5y+mFtYG1mCgsp3nLDEd4gL3YUvfW7oCFg5P1c9nTK8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=OjcV1ig4lAz38z8jC6NZGNyVOFa9ftKGHUdhEAQn027NH4qWHWYEW33cXaQss+ll9
	 W57shmLtpHE72b06QfeY34B/YX25yPG3Zu3TDFuFhyxeK+4P9yRFsQLkd59NlyD5/l
	 zAgch5PzSEeK8V3wvnoPkp9U5ga0IgmWYNf9/VYjecXhndMOWtKjl0Gcaw7HTa94Gd
	 pQnJuxG92hQNfvzcioEjFBWis7ZcNl/zZStbOaOO5FgUKF7JDeS4JdtOK3k9WWga1p
	 TK7eLoasJ4oJtrLt1Jch39bXdqYOW4xYNuqureUK4jRniKiz+sk6z7+JjvGucxQl7W
	 RK8jZ6fq/CdFw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 85079380AAF2;
	Tue, 17 Feb 2026 17:55:19 +0000 (UTC)
Subject: Re: [GIT PULL] Final io_uring fixes and changes for 7.0-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <73fba1d9-05bb-4f4c-9de0-514688c10947@kernel.dk>
References: <73fba1d9-05bb-4f4c-9de0-514688c10947@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <73fba1d9-05bb-4f4c-9de0-514688c10947@kernel.dk>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.0-20260216
X-PR-Tracked-Commit-Id: be3573124e630736d2d39650b12f5ef220b47ac1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7b751b01ade7f666de2f5c365bd9562c2dcd7d60
Message-Id: <177135091811.577366.2815981357197283316.pr-tracker-bot@kernel.org>
Date: Tue, 17 Feb 2026 17:55:18 +0000
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12298-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_NO_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pr-tracker-bot@kernel.org,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C326614EC83
X-Rspamd-Action: no action

The pull request you sent on Mon, 16 Feb 2026 20:46:45 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.0-20260216

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7b751b01ade7f666de2f5c365bd9562c2dcd7d60

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

