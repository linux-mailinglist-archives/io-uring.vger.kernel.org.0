Return-Path: <io-uring+bounces-13986-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 0NsRCfF5UmpEQQMAu9opvQ
	(envelope-from <io-uring+bounces-13986-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 19:14:25 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A0787425F1
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 19:14:24 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JToILtqz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13986-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13986-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 90FCD301725F
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 17:14:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BC30255E43;
	Sat, 11 Jul 2026 17:14:23 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7663CBE8F
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 17:14:22 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783790063; cv=none; b=bvroBFdONJOmCP+4xWCXp4ryr4jbSVnmbhK11bjkCGzfJpPKvSYClrd6GUQUAJzAY2baDftNxcmD/TaveoXRi80AIZ7lbQoeioa1VWwR1IEN+3ju0NVvwYdnjssdn7bx8D5WRWKQojtUExxgQA3TUBBLQlw+B3Hgyt3p3xq4hdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783790063; c=relaxed/simple;
	bh=LOvk5yShPDfIpiGnHXpaYX3BhZdKdAihwzZ7MBeVu48=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=QsyiWBPb3lw0XZ74PkS2ZOsq5UlP0h4D0z4iJZtRzcU0Ahy/NR0BxNTOYCRB5ENHGqNrJEltIo2xyIOJzWhssd87/MBjnADKx9pmeSU6ZEEaRAu4WIK9DaAofABnosiuPwMIE0PbssbgcPUPOIzaQkyuFoHyzJq0r0p1CWK6sz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JToILtqz; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378BF1F00A3A;
	Sat, 11 Jul 2026 17:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783790062;
	bh=srtZcySPe39Wu77Pd3CURvKNflPuy4Cqp5a2KC6G93U=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=JToILtqzm6GEkpHdxAFIjccsYsOkdfx1B3EeydWgNGHM2zial1c8uZI5wYYFgaggY
	 LVs4rgVmYGwI3HOvos8kaS9/ylAiq1iYGIgPj2Ul++DdWk934hmkI4jNiY8ROpPM3i
	 KTrGPGeK9a1d3c19Iew13sYNKPrZU4Iw9lp3wUfs6S5Tjww2Lp1mCtcwv403/GMARU
	 g8FV1Yx6+cHpfu708r+KUuXmgy7fZUsbg88qUw8QLj9IETis/PMAxwOe808zXDeffz
	 Oin5y+4KcWYWGZojlHiXZzgeo1XJXoOka05al7l75WPfqymwRHExX0u31tMxDAgcRM
	 km814qUf7RK5A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 569853924A0A;
	Sat, 11 Jul 2026 17:14:00 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 7.2-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <ebf34c44-2a7b-4656-a9ff-528660a070c5@kernel.dk>
References: <ebf34c44-2a7b-4656-a9ff-528660a070c5@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <ebf34c44-2a7b-4656-a9ff-528660a070c5@kernel.dk>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.2-20260710
X-PR-Tracked-Commit-Id: f3176c8ac4217c88fe1147ab084c47092921ffc4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 596d603126e4fe6857e5e39b6d5433c3f6ab5cdd
Message-Id: <178379003884.1164209.6664329241613095167.pr-tracker-bot@kernel.org>
Date: Sat, 11 Jul 2026 17:13:58 +0000
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:torvalds@linux-foundation.org,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-13986-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 7A0787425F1

The pull request you sent on Fri, 10 Jul 2026 22:30:17 -0600:

> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.2-20260710

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/596d603126e4fe6857e5e39b6d5433c3f6ab5cdd

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

