Return-Path: <io-uring+bounces-13195-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SLtLKUz09GnJFwIAu9opvQ
	(envelope-from <io-uring+bounces-13195-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 01 May 2026 20:43:24 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 142704AEE89
	for <lists+io-uring@lfdr.de>; Fri, 01 May 2026 20:43:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9B5D7300F948
	for <lists+io-uring@lfdr.de>; Fri,  1 May 2026 18:43:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D5E635C185;
	Fri,  1 May 2026 18:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dBavxdTN"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABA7359A7E
	for <io-uring@vger.kernel.org>; Fri,  1 May 2026 18:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777660998; cv=none; b=SBiJS06c1rjScbUgEiSiqUJJbYe+HN544QywGF8ZEKT9XXuac1CY+7nyNK7TmZ7eMg/KBk7qkBg/xl+AOpymgA7zmPs/WEsMxZXb0yngfBbOKl0DH7krVoGbzagtnwd3RgvF8hYbcfKMiXMb7ouqhTKi2we5Np+phI+vMVIOqMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777660998; c=relaxed/simple;
	bh=OOwfo7x4bTrXVlVI4nPKOQjVBUloILKoWHCuzkzOCGA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Lm2B4BgMbAbNcaZyXbYsBAH8WuUvvqRdNZMQ6JJaHBzwntV5LH1hOdFssHrwNpvK1iwgpdngBGh4Q2OrnhKCOd7+KmY5WQw/5Nnnu0m3+Ap/u/1MihQ3a1SWPH2bbYjevxX14mFpuBtL4dtT6Hirxm4QMm54yjSLDVFtNZxAYuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dBavxdTN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31595C2BCB9;
	Fri,  1 May 2026 18:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777660998;
	bh=OOwfo7x4bTrXVlVI4nPKOQjVBUloILKoWHCuzkzOCGA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=dBavxdTNQR9Jvnd3zqaR4deYIrEnAGtniHuZxDKsHnGcEhOHu5s+oMpKteXnmX0SG
	 1kX/iCLpZcNHlT7nFYSvT2LaPegQOCtDOVK+rGTFS2reuayecZWOIZDuVlhFBpaAgO
	 4f21hpXQNsRNpoYH/WszNs2D4/ipm/Eq+Zg1sfspnaciPDMHPrkJUBK1ec4juOkAds
	 x74euVGjTtza9oF3H9NsfNz2diUquv2FG3+B5zEQDXE2M7bS66yaY6ajy+YOWSC9jW
	 phDnbW7dKSzShp7mGqWbLffBTL7IQxan4b9PwyVKTwwxRsh41F7T/shV4drYun3V6m
	 sTU32o7mJC22A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id BA161380CEE6;
	Fri,  1 May 2026 18:42:32 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 7.1-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <8f3dd419-e06b-4b83-aaa4-7f7bafc098b4@kernel.dk>
References: <8f3dd419-e06b-4b83-aaa4-7f7bafc098b4@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <8f3dd419-e06b-4b83-aaa4-7f7bafc098b4@kernel.dk>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.1-20260430
X-PR-Tracked-Commit-Id: 17666e2d7592c3e85260cafd3950121524acc2c5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9d88bb929aa1193f9c0b9595a0c46930d6699647
Message-Id: <177766095136.3581397.5791505581031541516.pr-tracker-bot@kernel.org>
Date: Fri, 01 May 2026 18:42:31 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
X-Rspamd-Queue-Id: 142704AEE89
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_ALL(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_FROM(0.00)[bounces-13195-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_NO_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pr-tracker-bot@kernel.org,io-uring@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]

The pull request you sent on Thu, 30 Apr 2026 19:49:35 -0600:

> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.1-20260430

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9d88bb929aa1193f9c0b9595a0c46930d6699647

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

