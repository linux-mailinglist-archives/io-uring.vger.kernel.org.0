Return-Path: <io-uring+bounces-13795-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id ypNdE/92NWpJxAYAu9opvQ
	(envelope-from <io-uring+bounces-13795-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 19:06:07 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 406716A7361
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 19:06:06 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=h6mFDwP2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cTji1GMq;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=h6mFDwP2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cTji1GMq;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13795-lists+io-uring=lfdr.de@vger.kernel.org" designates 104.64.211.4 as permitted sender) smtp.mailfrom="io-uring+bounces-13795-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=suse.de;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5088530086A2
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 17:06:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 455553BE174;
	Fri, 19 Jun 2026 17:06:02 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A053314C5
	for <io-uring@vger.kernel.org>; Fri, 19 Jun 2026 17:06:00 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781888762; cv=none; b=jegUDmUYunUkCK31e5KpiklqEeoERIelH8GkTHG/iDFysNQM2IHIibW0GrnkzBL6WDjt6hP5HkFAKLE1NKqow+VI/IPnfVBI+YUfNwE9QQF/8gA7AkhAagRSemqC7L3QbwZf5NJtQVdLJqSVGXhjtQkBXHbP1ozsl38qdh5s/ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781888762; c=relaxed/simple;
	bh=lsQZQW4+8JfVZE36IEIO6JU+y9pLFg1Od7D0L1ULxHg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=rpJfwDXqDTpHnNkLj6aUiE/efbNxk0Yxj2OHb8unKgAdwjHkajvOWPRBTSLUmbxUStJBEZi0cdHa+pGSDZ8UcCjreq4S4pGvJQxNbbnk80pxFobUx8bltMmYQAYx1xTGvRrU3/uPoQ1PJuCUdb1XEBTnyY40hWDNaGYL50d0Uqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=h6mFDwP2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cTji1GMq; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=h6mFDwP2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cTji1GMq; arc=none smtp.client-ip=195.135.223.130
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B24D86DCA1;
	Fri, 19 Jun 2026 17:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781888758; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UhndOz+MFir7koa8jr8Zp9EFxnkyot+Q3cfaFJU/aDA=;
	b=h6mFDwP28dhtoZr6TuSBeH32cHSNeL+AUCibIvCMVTshMlpo59Qkri+E9gThnHse4ZXa5l
	PSeM9vyQe5IVOLYqJBK69lGfKo8Eft5SPff6xwPaZbveKnY8jCfycO4yVGoWTh1ycV1zHS
	3MWBb9ITNUG9cCwVqxTvUJ0ODo9Bm/I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781888758;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UhndOz+MFir7koa8jr8Zp9EFxnkyot+Q3cfaFJU/aDA=;
	b=cTji1GMqP31QUUyoquDqFUrbrx1kICsY+T+ft4Xq3lqcMhJWIz5owXfLoAgATjqhvYhxEA
	Mm6ZTUrD8Ty89cCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781888758; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UhndOz+MFir7koa8jr8Zp9EFxnkyot+Q3cfaFJU/aDA=;
	b=h6mFDwP28dhtoZr6TuSBeH32cHSNeL+AUCibIvCMVTshMlpo59Qkri+E9gThnHse4ZXa5l
	PSeM9vyQe5IVOLYqJBK69lGfKo8Eft5SPff6xwPaZbveKnY8jCfycO4yVGoWTh1ycV1zHS
	3MWBb9ITNUG9cCwVqxTvUJ0ODo9Bm/I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781888758;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UhndOz+MFir7koa8jr8Zp9EFxnkyot+Q3cfaFJU/aDA=;
	b=cTji1GMqP31QUUyoquDqFUrbrx1kICsY+T+ft4Xq3lqcMhJWIz5owXfLoAgATjqhvYhxEA
	Mm6ZTUrD8Ty89cCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6F480779A8;
	Fri, 19 Jun 2026 17:05:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HfDkFPZ2NWo1NwAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 19 Jun 2026 17:05:58 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring Mailing List
 <io-uring@vger.kernel.org>
Subject: Re: [RFC PATCH liburing] man: Convert manpages to markdown
In-Reply-To: <4217902f-5b99-4592-aeea-9ac3804da325@gnuweeb.org>
References: <20260618230524.4088053-1-krisman@suse.de>
 <4217902f-5b99-4592-aeea-9ac3804da325@gnuweeb.org>
Date: Fri, 19 Jun 2026 13:05:52 -0400
Message-ID: <87eci2pij3.fsf@mailhost.krisman.be>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13795-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:ammarfaizi2@gnuweeb.org,m:axboe@kernel.dk,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[suse.de:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,suse.de:dkim,suse.de:from_mime,mailhost.krisman.be:mid,gnuweeb.org:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 406716A7361

Ammar Faizi <ammarfaizi2@gnuweeb.org> writes:

> On 6/19/26 6:05 AM, Gabriel Krisman Bertazi wrote:
>> This has been discussed for a while due to the ongoing pain of writing
>> groff.  Now that we just had a release, convert the manpages to markdown
>> and add infrastructure to generate back the groff automatically during
>> compilation.
>
> Wow, big changes:
>
>    399 files changed, 11719 insertions(+), 18975 deletions(-)
>
> Yeah, I agree that writing in GNU roff is more painful than writing in
> markdown. Interesting patch.

Yeah, this is gonna be shitty to review.  The conversion was done
mostly automatically though, you can review Makefile for that.

I'll split it up into manageable chunks.

>
> Can we also word-wrap the markdown files? It's easier to read them in
> raw if they're word-wrapped as well.

Let me see if I can get the right pandoc incantation.

-- 
Gabriel Krisman Bertazi

