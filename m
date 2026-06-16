Return-Path: <io-uring+bounces-13743-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id NO6uJjsBMWo/aQUAu9opvQ
	(envelope-from <io-uring+bounces-13743-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 09:54:35 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 917BC68CFAC
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 09:54:34 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IT8R9C1n;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13743-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c15:e001:75::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13743-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 7817930072BD
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 07:54:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C6D6324705;
	Tue, 16 Jun 2026 07:54:24 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6CD435A384
	for <io-uring@vger.kernel.org>; Tue, 16 Jun 2026 07:54:23 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781596464; cv=none; b=qiSjbaO/xLmdCYphoCcYLHs+iWQayAyjZBIxHCWBZb9u5jlLCcpsvnLUe+uV8FyxJcXdRBUg1VQIYUcXydAJRypA376WJXPGQM7MSUcLby24Eh8QQNh0ph71+zRaiA3Ob7QuIlppFzXOynHyU/8A9XBxEOHBrQhMcvDH7sAnZeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781596464; c=relaxed/simple;
	bh=OW5AFZzWV4WIwMqBfegEgmrdE3+iq/u3TakOuEOtTFw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=GvFTjF2+xxm0dW6oelN1Fvq9ICXO0r7NyL93wyrS54TO1TWTsbpLp5hXGm+SJW/+sh/tENgA92kDmsqd5el84JmrRrMtE0nb+Or7hQkecBO8/kyDKZDJxUc5ZSNkwdPzih0/yCmfBBvnC+0/qmtfwv+BzrpM4bFGMi/eE9HgOlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IT8R9C1n; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568901F000E9;
	Tue, 16 Jun 2026 07:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781596463;
	bh=n4RzTwz3Ur65PuYso7PoXgBZe0KNbIllp1rNJhQ7ep0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=IT8R9C1nrnqIkwT5aCq/3Y1f870kYcJFmeEo6fbOPHWIJ3wR/x4Ck+wEJapwoWI/S
	 /9mKauykWUBJRfLJCMYodQpj4o3EY01NIxnPxjjhGi2DZvRRaGwPJM7BTUgtg9a/je
	 5mlPUrvgeTcx2X+WnJypkol7T1Fx/6/hZYpengBaCbQBmzCtpoIj0REzcSIVrL2tez
	 zUe39HhKRKMArilbiov/bPf0okTP+2n41kWsS3rvvyLWNLaKtcryOEvJi2Cr41AVxg
	 JsxVTCnJtja2YWuctT4le6gKNUkgrLlmxWVYUaX/Mr6xIrABzmrvWkvrbpt1i35D5K
	 FbsdLbDy+wQhw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56C46383BF68;
	Tue, 16 Jun 2026 07:54:19 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring updates for 7.2
From: pr-tracker-bot@kernel.org
In-Reply-To: <8829b16a-4247-4e07-aa35-c3a185780731@kernel.dk>
References: <8829b16a-4247-4e07-aa35-c3a185780731@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <8829b16a-4247-4e07-aa35-c3a185780731@kernel.dk>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/for-7.2/io_uring-20260615
X-PR-Tracked-Commit-Id: d9b710f683dc68b5c0b7dd0c6c64aeb5d27a1ac4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9b40ba14edcdf70240af8114092a76f75f070774
Message-Id: <178159645787.515891.1010742501547887088.pr-tracker-bot@kernel.org>
Date: Tue, 16 Jun 2026 07:54:17 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.66 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:torvalds@linux-foundation.org,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-13743-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	FORGED_SENDER(0.00)[pr-tracker-bot@kernel.org,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pr-tracker-bot@kernel.org,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FROM_NO_DN(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 917BC68CFAC

The pull request you sent on Mon, 15 Jun 2026 09:18:22 -0600:

> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/for-7.2/io_uring-20260615

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9b40ba14edcdf70240af8114092a76f75f070774

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

