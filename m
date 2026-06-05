Return-Path: <io-uring+bounces-13617-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id yyfSMWZKI2oJoAEAu9opvQ
	(envelope-from <io-uring+bounces-13617-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 06 Jun 2026 00:15:02 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 162E864B95A
	for <lists+io-uring@lfdr.de>; Sat, 06 Jun 2026 00:15:02 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="S5B/Ni28";
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13617-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13617-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BBFE1301829C
	for <lists+io-uring@lfdr.de>; Fri,  5 Jun 2026 22:15:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 572B43A873B;
	Fri,  5 Jun 2026 22:15:00 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DB33CBE6B
	for <io-uring@vger.kernel.org>; Fri,  5 Jun 2026 22:14:59 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780697700; cv=none; b=aa3jNrI0UK7tyhA/bx3Q2IXODlJruqKU2cvYpeVJ4MybL5pVhEXsS/0mSFF2POkYMUZRzSlaVrx95yCRPsw6J1yxfJsoH0ig5g9I8pK2BPRPCbg4NFGj/LbcH1NhBfX8YceenwF1NyAJlaYzefMPTKhzOnj6OJYC5lVf4qSHR3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780697700; c=relaxed/simple;
	bh=owIGJzutine+z63NXkBU00TVEy+7LhtdbWnJDbt/GcI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=sOhi2jsy3YCmW4LPFX9xHpJEc4TQld4A/o2Swb64xkz6IFTclAdAolH0HgVgzSIOMupHPld5NbEDsZHxY+T8uHw6ijsN5zosaUSvacTyjlDmgZszMU08dzFY39Y52+1yiCXCBlnJDbqFCi98LdGZua8QpshIwr/fxhmLxOmeA4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S5B/Ni28; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255C21F00893;
	Fri,  5 Jun 2026 22:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780697699;
	bh=9uDan0MZvGDiLqmItSHSAXcAoNpSgOuMj24z67v8NiM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=S5B/Ni282a4U2lX86LPZUCFQ1113qByhaB/BFg+RWVBtnUEQeRTsYN8r6XA8F958f
	 deTakMJ3w8vZT11ZF1t/X8iIzMdWnruVY3cMQpxmB+WEDS8AuZvhN8TrNQyRrNz1OE
	 bFUI2J1OfQKBBfBEDV4BiDBZCelTyx0le3Dt0l+nqM6JH65UhB7OtXWp6GA4GL7x1z
	 3jTTyBRCQ61/smqaonM5crqBvAe4uUDZ2yfuWQJBsAgj6ReYgVTV/sntRlclD33Bhj
	 hRMv8EQ5qOya1KXMUy49Qll8YPCB7+SQQtbo5KGvHy5ZPyAD11/mjEH0tyrOh1pxOH
	 3pwtGZJNJQXmA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93CFB3930C04;
	Fri,  5 Jun 2026 22:15:00 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 7.1-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <956f675b-1106-4e26-86ec-8592bafd99ad@kernel.dk>
References: <956f675b-1106-4e26-86ec-8592bafd99ad@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <956f675b-1106-4e26-86ec-8592bafd99ad@kernel.dk>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.1-20260605
X-PR-Tracked-Commit-Id: ed46f39c47eb5530a9c161481a2080d3a869cfaf
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c10130c234c81f4a7a143edbf413080235f8d8ce
Message-Id: <178069769924.3938369.7693869478519494336.pr-tracker-bot@kernel.org>
Date: Fri, 05 Jun 2026 22:14:59 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13617-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	FORGED_SENDER(0.00)[pr-tracker-bot@kernel.org,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:torvalds@linux-foundation.org,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_NO_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pr-tracker-bot@kernel.org,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 162E864B95A

The pull request you sent on Fri, 5 Jun 2026 13:37:03 -0600:

> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.1-20260605

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c10130c234c81f4a7a143edbf413080235f8d8ce

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

