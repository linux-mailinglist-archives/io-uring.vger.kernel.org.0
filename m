Return-Path: <io-uring+bounces-13814-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id uET2DZNnOWpXrwcAu9opvQ
	(envelope-from <io-uring+bounces-13814-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 22 Jun 2026 18:49:23 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 70E636B140D
	for <lists+io-uring@lfdr.de>; Mon, 22 Jun 2026 18:49:22 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=krisman.be header.s=MBO0001 header.b=Fj9FcfKY;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13814-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13814-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=krisman.be;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1AE713016530
	for <lists+io-uring@lfdr.de>; Mon, 22 Jun 2026 16:49:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51475231830;
	Mon, 22 Jun 2026 16:49:20 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010051AA1F4
	for <io-uring@vger.kernel.org>; Mon, 22 Jun 2026 16:49:17 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782146960; cv=none; b=f7Lxw6hkN7/hQPWJDbmD4wl2bGUjKj+bNKttA7nsLN2ivi7nOoi0UJ5g5dKaRKP3z3FJLj7lPrXXR+DW3G6FQs1JwXucYc2bWO78Of5hzhek2PuiYJM/DwXh+rYRI8FBWavEO9Jw9hKoOGzffcDXrpD5qkfloTLWky0t9ngIFzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782146960; c=relaxed/simple;
	bh=FhrsZbW2/qgvtadsv3Dtq1cwx1+hqEJblCqO2ICyOt4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=b9xdE3Bjhazu4fvFtXqeBZWCz83jiKkFMgEJC+kF4bmuKVm1ZBuhdLLjqHGnfSI8a2l600SaH12/nUCzqlC51BSu1S1M20o2U1oBrS5Nj9rDRPqB/Gnmz2mwH9SGvs5CiF0k069mGkczk3e3AOzKlx2WUGb2RTltWAUAuKVhKdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=krisman.be; spf=pass smtp.mailfrom=krisman.be; dkim=pass (2048-bit key) header.d=krisman.be header.i=@krisman.be header.b=Fj9FcfKY; arc=none smtp.client-ip=80.241.56.172
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4gkZ0p3vTWz9tKY;
	Mon, 22 Jun 2026 18:49:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=krisman.be; s=MBO0001;
	t=1782146954;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=guAxcvNev80PJJNaSfr2rQ0gVfF/x9k6deCYW4poJ2k=;
	b=Fj9FcfKYFp4367661ERhqJ+Fm3+a6hT5nkSqtYgagLVtTcyhZnfJmlw//b/8pjPYQ7YN6z
	BAdrpC9urJMzb0wGVKa/VSmOP3Kn5Q9L8Xjcae53idmyJa8NGHZIzavEAqaaFddqECuFtS
	fu5Q2X4q9IUFi+9Y978lvIRCCdkbI2PzV2IQYln23YeAB04TKJgqofzhtt3/QZtfnB9cSq
	Ohcq7qROxxu4KlJT99CnX0xyHuMe+m+2vXwD18+ewS46xD9PnLNMeiIPCywRp88NaUA3Eo
	kSqdhaojlG+/THboAVDmYqB3u+X7CODAhijzrSxV+NFHTusX6sVLe8ID5/4v5g==
From: Gabriel Krisman Bertazi <gabriel@krisman.be>
To: Prateek <kprateek283@gmail.com>, io-uring@vger.kernel.org
Cc: Prateek <kprateek283@gmail.com>
Subject: Re: [PATCH] setup: dynamically detect default huge page size
In-Reply-To: <20260620113609.123575-1-kprateek283@gmail.com>
References: <20260620113609.123575-1-kprateek283@gmail.com>
Date: Mon, 22 Jun 2026 12:49:10 -0400
Message-ID: <87qzlyy0zd.fsf@mailhost.krisman.be>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[krisman.be,none];
	R_DKIM_ALLOW(-0.20)[krisman.be:s=MBO0001];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13814-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:kprateek283@gmail.com,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com];
	FORGED_SENDER(0.00)[gabriel@krisman.be,io-uring@vger.kernel.org];
	FORWARDED(0.00)[lists@lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gabriel@krisman.be,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[krisman.be:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 70E636B140D

Prateek <kprateek283@gmail.com> writes:

>     Replaces the hardcoded 2MB huge page size with dynamic detection by
>     parsing /proc/meminfo. This fixes no-mmap allocation failures on
>     architectures with different default huge page sizes (like ARM64
>     which often uses 512MB) or x86 systems configured for 1GB pages.
>
>     - Safely parses /proc/meminfo without allocating memory.
>     - Uses raw syscalls and manual byte-by-byte matching to maintain
>       strict compatibility with CONFIG_NOLIBC builds (avoiding strstr).
>     - Drops the MAP_HUGE_2MB mmap flag to allow the kernel to correctly
>       apply the system's default huge page size.
>     - Falls back safely to 2MB if /proc/meminfo is unreadable.
>
> Signed-off-by: Prateek <kprateek283@gmail.com>
> ---
>  src/setup.c | 84 +++++++++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 68 insertions(+), 16 deletions(-)
>
> diff --git a/src/setup.c b/src/setup.c
> index ea6f11fd..46e20e0b 100644
> --- a/src/setup.c
> +++ b/src/setup.c
> @@ -220,15 +220,67 @@ __cold int io_uring_ring_dontfork(struct io_uring *ring)
>  	return 0;
>  }
>  
> -#ifndef MAP_HUGE_SHIFT
> -#define MAP_HUGE_SHIFT	26
> -#endif
> -#ifndef MAP_HUGE_2MB
> -#define MAP_HUGE_2MB	(21U << MAP_HUGE_SHIFT)
> -#endif
>  
> -/* FIXME */
> -static size_t huge_page_size = 2 * 1024 * 1024;
> +static size_t get_huge_page_size(void)
> +{
> +	static size_t hps;

Please, initialize your static variables to makes it readable. I.e,
should be initialized it to 2MB.

> +	size_t ret = 2 * 1024 * 1024; /* fallback: 2MB */

ret redundant with hps, could go away.

> +	char buf[4096];
> +	char *p, *end;
> +	unsigned long val;
> +	ssize_t n;
> +	int fd;
> +
> +	if (hps)
> +		return hps;
> +
> +	fd = __sys_open("/proc/meminfo", O_RDONLY, 0);
> +	if (fd < 0)
> +		goto out;
> +
> +	n = __sys_read(fd, buf, sizeof(buf) - 1);
> +	__sys_close(fd);
> +	if (n <= 0)
> +		goto out;
> +	buf[n] = '\0';
> +
> +	/*
> +	 * Scan line-by-line for "Hugepagesize:". We avoid strstr() and
> +	 * memcmp() because they are not available in CONFIG_NOLIBC builds.
> +	 */
> +	p = buf;
> +	end = buf + n;
> +	while (p < end) {
> +		/* Check if this line starts with "Hugepagesize:" (13 chars) */
> +		if (p + 13 <= end &&
> +		    p[0]  == 'H' && p[1]  == 'u' && p[2]  == 'g' &&
> +		    p[3]  == 'e' && p[4]  == 'p' && p[5]  == 'a' &&
> +		    p[6]  == 'g' && p[7]  == 'e' && p[8]  == 's' &&
> +		    p[9]  == 'i' && p[10] == 'z' && p[11] == 'e' &&
> +		    p[12] == ':') {

This is unreadable.  It would be much better as a two line loop
iterating over two strings...  But then, why not create it a couple line
implementation of memcmp and atoi in arch/generic/lib.h instead?


> +			p += 13;
> +			while (p < end && (*p == ' ' || *p == '\t'))
> +				p++;
> +			val = 0;
> +			while (p < end && *p >= '0' && *p <= '9') {
> +				val = val * 10 + (*p - '0');
> +				p++;
> +			}
> +			if (val)
> +				ret = val * 1024; /* kB -> bytes */
> +			break;
> +		}
> +		/* Advance to next line */
> +		while (p < end && *p != '\n')
> +			p++;
> +		if (p < end)
> +			p++;
> +	}
> +out:
> +	hps = ret;
> +	return hps;
> +}

This function should go in arch/generic/lib.h too.  A hint is the
get_page_size is already there.

That said, we should be looking into something like the kernel's nolibc
instead of reinventing libc.

-- 
Gabriel Krisman Bertazi

