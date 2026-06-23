Return-Path: <io-uring+bounces-13818-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id Kv+gOpWjOmqLCQgAu9opvQ
	(envelope-from <io-uring+bounces-13818-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2026 17:17:41 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AFD76B83F4
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2026 17:17:41 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bSLK41f0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FIcYQtFd;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Ffw27Ijz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=AFioEuWV;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13818-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13818-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=suse.de;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1721E3139FC9
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2026 15:11:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 582573D7D60;
	Tue, 23 Jun 2026 15:11:34 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0ACC3D7D83
	for <io-uring@vger.kernel.org>; Tue, 23 Jun 2026 15:11:32 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782227494; cv=none; b=lWtTJgQI+L4h5GBvyd1AVQWIOQ0qPoJHY8/6uLhy6d1CBImNbw/if6Zt9htr8zwSmfh4SbtXAWqVE1NSbE+L0p0Lmzr5y1/V8okkIRLBoZPUlsrKA+BkMITE2xKpMcrJiUDjI5OQHtLoUs+tYBhFJG9oR/xzf5afOLjUX1iM1co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782227494; c=relaxed/simple;
	bh=KrE18r1pnujfuaglIDxCS1hhUuxePbDk+kE9eQnEvjg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=O4ISLMQxS5ug0g6AqZlVJTyLx8mOUWDqRoYuHiIkcYbb4Q5MtzfRmQIKv8IpdqvaKrh4SV5kh7nIbWn+9G/dNTGEQG8jt9F8aJ5+9GvSP5DSp3R3UoXA44lvYObBr0ZAZA0cqfOQtCVJAJgKvGC8eoQoJtDg+c3YnzEvay/To0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bSLK41f0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=FIcYQtFd; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Ffw27Ijz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AFioEuWV; arc=none smtp.client-ip=195.135.223.131
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AA5AA75B3E;
	Tue, 23 Jun 2026 15:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782227490; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JUIdX+cuQxmf/QBPQGQf4EzL0EUySkrV1FzpCj/UfNE=;
	b=bSLK41f0rxnmqtQ+/w6WQ2082btIAJZfXQ7VgHlu5PKnmVmj+JQncaP5U7oeCkEK3Pgtjs
	hDvG6EQ9vJvJ6Bw3meQHW9BzeLFrzFzVnh43GLQ0iUeRxaak6gFhazlSepo9sULZUMQUTO
	pz9QGTiiACRKr+uWzsh9LweflKYglUY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782227490;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JUIdX+cuQxmf/QBPQGQf4EzL0EUySkrV1FzpCj/UfNE=;
	b=FIcYQtFd0S8oR6YF67FuNFNSt7eiL4hhhWry+Jd66qw/j8hFj90m0/+OLAfHAk6EulMrB0
	vui1QlN10Kh0CNBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782227489; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JUIdX+cuQxmf/QBPQGQf4EzL0EUySkrV1FzpCj/UfNE=;
	b=Ffw27Ijz12J5UX23RhlJRP159NiwCpWnox/DJ9Q4rIrd03g+NK/vq4AhRZtjbYxv1VocOu
	Lo7kCMD1otaKLHsoKJ2CylY11d2fLLiENjSvvme2Tjtb6tYest+ufjZ7GSSHgOYHmPOo4n
	8ffM4v2ED171ikU0eM2X0ic+ZGxu/1M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782227489;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JUIdX+cuQxmf/QBPQGQf4EzL0EUySkrV1FzpCj/UfNE=;
	b=AFioEuWVTEpo7gsfoHjcGnOB3XN5OA160eKJoDk8MtGJw3FTp59hN4wQECiDZRxLjrhynj
	IY4hFbhB/rtnohCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6DE9A779A8;
	Tue, 23 Jun 2026 15:11:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pnawDiGiOmpdWAAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 23 Jun 2026 15:11:29 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Prateek <kprateek283@gmail.com>
Cc: io-uring@vger.kernel.org, kprateek283@gmail.com
Subject: Re: [PATCH] setup: dynamically detect default huge page size
In-Reply-To: <20260623110930.910263-1-kprateek283@gmail.com>
Organization: SUSE
References: <87qzlyy0zd.fsf@mailhost.krisman.be>
 <20260623110930.910263-1-kprateek283@gmail.com>
Date: Tue, 23 Jun 2026 11:11:27 -0400
Message-ID: <87jyrpuw9s.fsf@mailhost.krisman.be>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -4.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13818-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:kprateek283@gmail.com,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	HAS_ORG_HEADER(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	FREEMAIL_TO(0.00)[gmail.com];
	FORWARDED(0.00)[lists@lfdr.de];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.de:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,vger.kernel.org:from_smtp,suse.de:dkim,suse.de:from_mime,mailhost.krisman.be:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 5AFD76B83F4

Prateek <kprateek283@gmail.com> writes:

> Hi Gabriel,
>
> Thanks for the review.
>
> On Mon, Jun 22, 2026 at 16:49 Gabriel Krisman Bertazi wrote:
>> > +static size_t get_huge_page_size(void)
>> > +{
>> > +   static size_t hps;
>>
>> Please, initialize your static variables to makes it readable. I.e,
>> should be initialized it to 2MB.
>
> hps is left at 0 on purpose as a "not computed yet" flag -- same thing
> get_page_size() does in arch/aarch64/lib.h with cache_val. If I set
> hps = 2MB upfront, the first call just returns 2MB without ever
> reading /proc/meminfo, which defeats the point.

Ah, of course.  Back to the original point, please initialize hps
explicitly (to 0). Yeah, I know the compiler should do that for you in
C99.  Still, make it explicit.

>
>> > +   size_t ret = 2 * 1024 * 1024; /* fallback: 2MB */
>>
>> ret redundant with hps, could go away.
>
> The local ret is there so I only write to hps once at the end. If two
> threads race into this function, neither one sees a half-baked
> fallback value in hps. The race itself is harmless since both threads
> would compute the same result anyway.

No, it is redundant.  You don't need to have "half-baked" values in hps
either. as you already use val to build your hugepage size.  ret is just an
extra step that will vanish in compilation.

There are many ways around it.  For instance:

unsigned long val = 0;
...
out:
hps = (val)?: 2*1024*1024;  	/* fallback to 2 MB pages */
return hps;

-- 
Gabriel Krisman Bertazi

