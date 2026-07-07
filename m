Return-Path: <io-uring+bounces-13917-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id GESFLll4TWrp0gEAu9opvQ
	(envelope-from <io-uring+bounces-13917-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 08 Jul 2026 00:06:17 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A84071FFBC
	for <lists+io-uring@lfdr.de>; Wed, 08 Jul 2026 00:06:17 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kN1euJH7;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=o0tAnC8a;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kN1euJH7;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=o0tAnC8a;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13917-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13917-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 72FB43020EA2
	for <lists+io-uring@lfdr.de>; Tue,  7 Jul 2026 22:06:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5165A3A7F41;
	Tue,  7 Jul 2026 22:06:06 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7883B27FF
	for <io-uring@vger.kernel.org>; Tue,  7 Jul 2026 22:06:02 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783461965; cv=none; b=hyEEPjznW+StCUg1PALpRGpgQBmBjjoIK3J8LU9ATppKUN+yCbykBDqB7IVh51oGVX8mrCe2Ba1Je328yc84QztOhjEz1Rbdpn9lAfOb+Q/ZBZkx2wx8QCEZVfilh6FhJ/HAjrZVop+YUQkdgqb4Qwq/q6V4XVCeJP+vGmllQ3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783461965; c=relaxed/simple;
	bh=leTn+NMc1/Z8x6U5Xj1IHRURoMgXYWnJN8hpUQZYMQQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=lb2AXm9q/QuUWR9aom5uTblMWYy5qUikdl+T73bLuTKp7FUNs832u4V7KgIy1tHQuswb+VqUUTuaNf+NnaXHqzgay30wMhFv1lhGsK33Jgj7iYWPIeIrNY8kJf4jyo5impW1U8XpNHCtPLm4tq7Qh1RjMpQXx3g8sSbCiVpxTa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kN1euJH7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=o0tAnC8a; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kN1euJH7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=o0tAnC8a; arc=none smtp.client-ip=195.135.223.130
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0B3687445E;
	Tue,  7 Jul 2026 22:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783461961; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kEVJ4g6K/zDyGG1+1UYrTr4EL81uZje3jZzH6bFCDWY=;
	b=kN1euJH7LW4ikbdpBvK8uJfRzyYrFFU0HYpG0aHpLzY4dEjiDcqbpC2o1+Y+pHLswP1lds
	zyicqfIQos9XY8E7LaSbeDrshjZMPXLZv3YCzMdWl6bbyUX1R3si6tFZYWIsC+lqUvU4JZ
	twXWZu16sfbBS90c4Gr1gTViXaB9+x4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783461961;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kEVJ4g6K/zDyGG1+1UYrTr4EL81uZje3jZzH6bFCDWY=;
	b=o0tAnC8a7PSDCKR+OTa+PTYQFO3SWyH15e5CAoke48vRMzSZinGsAcznX/Ks3G+XrV1Wa7
	DUClcSFV7bOWSTDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783461961; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kEVJ4g6K/zDyGG1+1UYrTr4EL81uZje3jZzH6bFCDWY=;
	b=kN1euJH7LW4ikbdpBvK8uJfRzyYrFFU0HYpG0aHpLzY4dEjiDcqbpC2o1+Y+pHLswP1lds
	zyicqfIQos9XY8E7LaSbeDrshjZMPXLZv3YCzMdWl6bbyUX1R3si6tFZYWIsC+lqUvU4JZ
	twXWZu16sfbBS90c4Gr1gTViXaB9+x4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783461961;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kEVJ4g6K/zDyGG1+1UYrTr4EL81uZje3jZzH6bFCDWY=;
	b=o0tAnC8a7PSDCKR+OTa+PTYQFO3SWyH15e5CAoke48vRMzSZinGsAcznX/Ks3G+XrV1Wa7
	DUClcSFV7bOWSTDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C4FEB779AE;
	Tue,  7 Jul 2026 22:06:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dFyDKUh4TWqiIgAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 07 Jul 2026 22:06:00 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org, ammarfaizi2@gnuweeb.org
Subject: Re: [PATCH liburing 0/3] Convert manpages to markdown
In-Reply-To: <x49zf02vfbx.fsf@segfault.usersys.redhat.com>
Organization: SUSE
References: <20260706214132.2841060-1-krisman@suse.de>
 <x49fr1vvvbe.fsf@segfault.usersys.redhat.com>
 <87y0fmhlnc.fsf@mailhost.krisman.be>
 <x49zf02vfbx.fsf@segfault.usersys.redhat.com>
Date: Tue, 07 Jul 2026 18:05:59 -0400
Message-ID: <87zf028ng8.fsf@mailhost.krisman.be>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -4.30
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13917-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:jmoyer@redhat.com,m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:ammarfaizi2@gnuweeb.org,s:lists@lfdr.de];
	HAS_ORG_HEADER(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[suse.de:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 2A84071FFBC

Jeff Moyer <jmoyer@redhat.com> writes:

> I don't have a strong opinion.  Either way, I'll be looking at
> documentation and/or prior examples to make the changes I need to make.
> :)  As I said in my last follow-up, it would be enough for me if the
> generated man pages were simply part of the release tarballs (it's not
> necessary to check them into git).  I'm sure that can be accomplished
> with makefile magic.

I considered that, part of a 'make dist'-kind of rule.  But
there is the tarballs generated by github which do a simple
git-archive. I don't think we can change them to run a custom command.

We fetch our sources from https://brick.kernel.dk.  That seems to be
generated by the create-archive rule, which we could patch.

If github tarballs differing from Jens' server are not a problem, and
you can use that server, I'm happy make it build through the
create-archive rule.  Should solve the problem.

>
>>> At the very least, please make generation of the man pages optional
>>> via configure.
>
> And this would be a necessary part of the solution, were things to go
> that way.

ack!

>
> Thanks!
> Jeff
>

-- 
Gabriel Krisman Bertazi

