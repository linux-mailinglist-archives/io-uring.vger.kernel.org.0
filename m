Return-Path: <io-uring+bounces-13623-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id +0vXKr5KJWoRGQIAu9opvQ
	(envelope-from <io-uring+bounces-13623-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 07 Jun 2026 12:41:02 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 275C764FE6B
	for <lists+io-uring@lfdr.de>; Sun, 07 Jun 2026 12:41:02 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=none;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13623-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13623-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3B05E30038DA
	for <lists+io-uring@lfdr.de>; Sun,  7 Jun 2026 10:41:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3FA4328610;
	Sun,  7 Jun 2026 10:40:59 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cae.in-ulm.de (cae.in-ulm.de [217.10.14.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89742C1595;
	Sun,  7 Jun 2026 10:40:57 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828859; cv=none; b=rDjjKkYxy6lHk3Z5TILEyher24Zc+YnQfToZbzf+vM+33W/byaEc54awzf/W2DjScYXfEmwuWeJQbtJlnbtlTt/zv13rMyDPG3/mctckhICBAqdxPeb1eqeUuedp2RmwGZglfNQBours8KhlLEoCvdI1guzFyDCmaTqX6jDL3GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828859; c=relaxed/simple;
	bh=atPpHUvyDAfZiMwvPlJzn47dH3tmznKBq5f5M8qsFak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qMuqnVVAkp1K0+HZGFcfsWQVmhuzDhsB6Ff1GeJl/V5oX91H6nT/PFq8yDLWOj4GmlwZPbEMsnGzHtNdG86AbsF959d3J8U6L0iHv4YR0m6VQwCwnPBZIiqtalwBsOPceUb4euucfwJtPiNUmujOL2nRZXv6fkal3sihskykyMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=c--e.de; spf=pass smtp.mailfrom=c--e.de; arc=none smtp.client-ip=217.10.14.231
Received: by cae.in-ulm.de (Postfix, from userid 1000)
	id 9CF02140025; Sun,  7 Jun 2026 12:40:55 +0200 (CEST)
Date: Sun, 7 Jun 2026 12:40:55 +0200
From: "Christian A. Ehrhardt" <lk@c--e.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tip ten Brink <tip@tenbrinkmeijs.com>, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iouring: Fix min_timeout behaviour
Message-ID: <aiVKt4sNjSFULeOD@cae.in-ulm.de>
References: <20260606201120.1441447-1-lk@c--e.de>
 <9f94f066-ea36-443e-b989-cf920ff9d27e@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f94f066-ea36-443e-b989-cf920ff9d27e@kernel.dk>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_NA(0.00)[c--e.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:tip@tenbrinkmeijs.com,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[lk@c--e.de,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13623-lists,io-uring=lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lk@c--e.de,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	R_DKIM_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,vger.kernel.org:from_smtp,c--e.de:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 275C764FE6B

On Sat, Jun 06, 2026 at 03:55:18PM -0600, Jens Axboe wrote:
> On 6/6/26 2:11 PM, Christian A. Ehrhardt wrote:
> > The wakeup condition if a min timeout is present and has
> > expired is that at least _one_ CQE was posted. Thus set
> > the cq_tail target to ->cq_min_tail + 1. Without this
> > commit a spurious wakeup can result in a premature wakeup
> > because io_should_wake() will return true even if _no_ CQE
> > was posted at all.
> > 
> > Tested by running the liburing testsuite with no regressions.
> > 
> > Additionally, tested by turning all calls to schedule() in
> > io_uring/wait.c into calls to schedule_timeout(1) to force
> > the spurious wakeups. With these spurious wakeups the
> > min-timeout.t test fails before and passes after this commit.
> 
> Either this or the test case is broken, with or without the change
> you sent for the test case. I'll take a look, but it's definitely
> not passing as-is.

I also tested with the zig reproducer from
	https://github.com/axboe/liburing/issues/1477
and with the spurious wakeups the reproducer shows the premature
wakeup without any CQE posted, too. It seems that the missing "+1"
is an oversight that got introduced between v1 and v2 of the commit
that fixed the above issue.


Best regards,
Christian

