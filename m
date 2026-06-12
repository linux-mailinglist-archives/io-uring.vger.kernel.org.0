Return-Path: <io-uring+bounces-13700-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id /1/yErNPLGrPPAQAu9opvQ
	(envelope-from <io-uring+bounces-13700-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 20:28:03 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id AC47267BAD6
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 20:28:02 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G+i6C1Kw;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13700-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13700-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EFCFF3104C78
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 18:25:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 311D137BE9C;
	Fri, 12 Jun 2026 18:25:37 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A80393DEB
	for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 18:25:35 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781288737; cv=none; b=qlhiXMp09ExFjx3LZ0pkkwS2bI0YNNF6yz9EJrmK3djsxth238EZpCpEOilBcDUqS839WvSJW9NaOpF6rTaddhmnSypYbKfES2ZzUjqHrzf1FvoVtthR0g5l6wCNMZvt4PSkX1pfpq46ykCo/rqHMSMIldXHXc28n8TiWkWJsJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781288737; c=relaxed/simple;
	bh=TajGpklmeHraS32i3iPFAZ5zkzHXUb32QvcF8E3EGjQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Qtm7OE01oGVEJv0H2WpkQWf1OdAJfEkJI9tomP8PAKa41enUZ2f+4CkFBVUsf6sbSmhfsL39/UM7HPR7YZYezJvcdJYkRdmOs3uUGtzi1nrhZrrxdTUUiOHNK+REMD0kiP3dttUDQ7TBueGaLv8uK9Pv+SJfD4vXgfP53+K0X8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G+i6C1Kw; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46EF1F000E9;
	Fri, 12 Jun 2026 18:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781288735;
	bh=1Ws/q+30EBLDZmLwyx0AWhRhc1EXxgFXigUaBNi3MCM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=G+i6C1KwlXznQudTQR0K21im95EoDxyWBbtpjoHWmjUgUTIz/mF4umX4v7+74GK46
	 cjhG5gd8dI74ozBiII7TazkrdJaFrJWsQPLuHSoHwZ7pqG3BXymYgv0neO+hy++g0h
	 QFg2a9qi87pOj9uF1uXL3bFZi2qHEhDED/VkamEaBIPQj4wnoeStht9HGt/mK4jrMu
	 t0M+3tLWG+xAsd46W91PXImUhxo+PebRv2mWYRCTo2WjOnEc5ssE9a52uCNziBWsxn
	 DigURw2dxFCbz4PAw01BQOgWK17AYtuksyob4GDAkQ2QHaoO27Zd5NYJCA9uqxhyFK
	 kKqP9ZB4X8dcA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0A3E39D2F40;
	Fri, 12 Jun 2026 18:25:33 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 7.1-final
From: pr-tracker-bot@kernel.org
In-Reply-To: <98373ad8-4777-489c-9cef-1ff9227c63a4@kernel.dk>
References: <98373ad8-4777-489c-9cef-1ff9227c63a4@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <98373ad8-4777-489c-9cef-1ff9227c63a4@kernel.dk>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.1-20260611
X-PR-Tracked-Commit-Id: 29fe1bd01b99714f3136f922230a643c2742cda9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 880b719ca0da9d2470fd2652e8ed959ca5143280
Message-Id: <178128873250.784234.17252517907368850599.pr-tracker-bot@kernel.org>
Date: Fri, 12 Jun 2026 18:25:32 +0000
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:torvalds@linux-foundation.org,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-13700-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: AC47267BAD6

The pull request you sent on Fri, 12 Jun 2026 10:27:03 -0600:

> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.1-20260611

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/880b719ca0da9d2470fd2652e8ed959ca5143280

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

