Return-Path: <io-uring+bounces-13915-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id y2a0C1ksTWqKwAEAu9opvQ
	(envelope-from <io-uring+bounces-13915-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 07 Jul 2026 18:42:01 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 749F771DF32
	for <lists+io-uring@lfdr.de>; Tue, 07 Jul 2026 18:42:00 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RcB1LQjh;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="h1/y+fYM";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RcB1LQjh;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="h1/y+fYM";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13915-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13915-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 639DC305DE4C
	for <lists+io-uring@lfdr.de>; Tue,  7 Jul 2026 16:38:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABF5942F6F0;
	Tue,  7 Jul 2026 16:38:47 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5FC3F4DD9
	for <io-uring@vger.kernel.org>; Tue,  7 Jul 2026 16:38:45 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783442327; cv=none; b=cTQSOQshgqklYcoAho+MPMXRdW+lhuR0w5HJJvMCvo8fPIVv9dkVdaNSI/mBBt0Ap2RqswoczltBLcMLsHiMO0tnTOtUowQzZV0jeKy5QDhuTZJ7tJeI65rBHdYguhhZ1YV5ei1xTHMxiPNUSo8mm0QpsfpLC1O1x1XdZo3XHWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783442327; c=relaxed/simple;
	bh=TyQSNN/F6awEpk5VKGdCmJtS13/FAii4vnXQV+vfLF0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=tcKxPUvSnKlGOHMFUkKOCmji/fDC12Y4kqPNW7SwFlPDDLEA1w1hVTVme4riIq00+xrMhVeca+3UYRSVu1t0Y4tUoQs6dke8Ed/ceqaTp7EWyiLCENLBp6a2i3ywRxmeLmfcBfQ8iPZuNwBQCiJdWtlvkwS5oYPcLNafLC65dDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RcB1LQjh; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=h1/y+fYM; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RcB1LQjh; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=h1/y+fYM; arc=none smtp.client-ip=195.135.223.130
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 083FC75CC0;
	Tue,  7 Jul 2026 16:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783442324; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+nJF0eP+kef4BUnE2z/TVSeSxEEdliJUdHJZrllYo+8=;
	b=RcB1LQjhPDhy03Izip0WI+tyom0OaReCywbfYjzdpwOMo8RzAHPMl9olGC1bN7f9bA6/qI
	iyNUm++FaITv3u9ZJWvdc3Z6qaaB+kIi5V2WaRl6S87/y2/a08GnLki/NTvhjik6bh1ny1
	+lQVMCE1ijy5Q96cMHvkEBXLmyqSSko=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783442324;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+nJF0eP+kef4BUnE2z/TVSeSxEEdliJUdHJZrllYo+8=;
	b=h1/y+fYMMhdV8AF/vWZT/B/L0CX59zGTS6RuEsoOxzDM38eDL9MuOyU0eKYkYiHZpCu/wX
	y6u5mK8k8+7VHmAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783442324; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+nJF0eP+kef4BUnE2z/TVSeSxEEdliJUdHJZrllYo+8=;
	b=RcB1LQjhPDhy03Izip0WI+tyom0OaReCywbfYjzdpwOMo8RzAHPMl9olGC1bN7f9bA6/qI
	iyNUm++FaITv3u9ZJWvdc3Z6qaaB+kIi5V2WaRl6S87/y2/a08GnLki/NTvhjik6bh1ny1
	+lQVMCE1ijy5Q96cMHvkEBXLmyqSSko=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783442324;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+nJF0eP+kef4BUnE2z/TVSeSxEEdliJUdHJZrllYo+8=;
	b=h1/y+fYMMhdV8AF/vWZT/B/L0CX59zGTS6RuEsoOxzDM38eDL9MuOyU0eKYkYiHZpCu/wX
	y6u5mK8k8+7VHmAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BFB11779AE;
	Tue,  7 Jul 2026 16:38:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Q3EpIpMrTWqcawAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 07 Jul 2026 16:38:43 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Prateek <kprateek283@gmail.com>
Cc: io-uring@vger.kernel.org, kprateek283@gmail.com
Subject: Re: [PATCH v2] setup: dynamically detect default huge page size
In-Reply-To: <20260623154305.1115403-1-kprateek283@gmail.com>
Organization: SUSE
References: <20260623154305.1115403-1-kprateek283@gmail.com>
Date: Tue, 07 Jul 2026 12:38:38 -0400
Message-ID: <87v7aqhi0h.fsf@mailhost.krisman.be>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13915-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mailhost.krisman.be:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 749F771DF32

Prateek <kprateek283@gmail.com> writes:

>     Replaces the hardcoded 2MB huge page size with dynamic detection by
>     parsing /proc/meminfo. This fixes no-mmap allocation failures on
>     architectures with different default huge page sizes (like ARM64
>     which often uses 512MB) or x86 systems configured for 1GB pages.
>
>     - Safely parses /proc/meminfo without allocating memory.
>     - Adds a __uring_memcmp shim for CONFIG_NOLIBC builds, allowing
>       setup.c to use standard memcmp for the Hugepagesize: match.
>     - Drops the MAP_HUGE_2MB mmap flag to allow the kernel to correctly
>       apply the system's default huge page size.
>     - Falls back safely to 2MB if /proc/meminfo is unreadable.

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>

>
> Signed-off-by: Prateek <kprateek283@gmail.com>
> ---
> Changes in v2:
> - Initialized hps explicitly to 0.
> - Replaced the char-by-char Hugepagesize comparison with a new __uring_memcmp helper.
> - Removed the redundant ret variable and simplified the fallback assignment using a ternary operator.
>
>  src/lib.h    |  2 ++
>  src/nolibc.c | 19 +++++++++++++
>  src/setup.c  | 75 +++++++++++++++++++++++++++++++++++++++++-----------
>  3 files changed, 80 insertions(+), 16 deletions(-)
>
> diff --git a/src/lib.h b/src/lib.h
> index 4d32d3e1..463dd4b5 100644
> --- a/src/lib.h
> +++ b/src/lib.h
> @@ -41,10 +41,12 @@
>  void *__uring_memset(void *s, int c, size_t n);
>  void *__uring_malloc(size_t len);
>  void __uring_free(void *p);
> +int __uring_memcmp(const void *s1, const void *s2, size_t n);
>  
>  #define malloc(LEN)		__uring_malloc(LEN)
>  #define free(PTR)		__uring_free(PTR)
>  #define memset(PTR, C, LEN)	__uring_memset(PTR, C, LEN)
> +#define memcmp(S1, S2, LEN)	__uring_memcmp(S1, S2, LEN)
>  #endif
>  
>  #endif /* #ifndef LIBURING_LIB_H */
> diff --git a/src/nolibc.c b/src/nolibc.c
> index 88b1494a..14ede500 100644
> --- a/src/nolibc.c
> +++ b/src/nolibc.c
> @@ -25,6 +25,25 @@ void *__uring_memset(void *s, int c, size_t n)
>  	return s;
>  }
>  
> +int __uring_memcmp(const void *s1, const void *s2, size_t n)
> +{
> +	size_t i;
> +	const unsigned char *p1 = s1, *p2 = s2;
> +
> +	for (i = 0; i < n; i++) {
> +		if (p1[i] != p2[i])
> +			return p1[i] - p2[i];
> +
> +		/*
> +		 * An empty inline ASM to avoid auto-vectorization
> +		 * because it's too bloated for liburing.
> +		 */
> +		__asm__ volatile ("");
> +	}
> +
> +	return 0;
> +}
> +
>  struct uring_heap {
>  	size_t		len;
>  	char		user_p[] __attribute__((__aligned__));
> diff --git a/src/setup.c b/src/setup.c
> index ea6f11fd..88f86784 100644
> --- a/src/setup.c
> +++ b/src/setup.c
> @@ -220,15 +220,58 @@ __cold int io_uring_ring_dontfork(struct io_uring *ring)
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
> +	static size_t hps = 0;
> +	char buf[4096];
> +	char *p, *end;
> +	unsigned long val = 0;
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
> +	 * Scan line-by-line for "Hugepagesize:".
> +	 */
> +	p = buf;
> +	end = buf + n;
> +	while (p < end) {
> +		/* Check if this line starts with "Hugepagesize:" (13 chars) */
> +		if (p + 13 <= end && !memcmp(p, "Hugepagesize:", 13)) {
> +			p += 13;
> +			while (p < end && (*p == ' ' || *p == '\t'))
> +				p++;
> +			val = 0;
> +			while (p < end && *p >= '0' && *p <= '9') {
> +				val = val * 10 + (*p - '0');
> +				p++;
> +			}
> +			break;
> +		}
> +		/* Advance to next line */
> +		while (p < end && *p != '\n')
> +			p++;
> +		if (p < end)
> +			p++;
> +	}
> +out:
> +	hps = val ? val * 1024 : 2 * 1024 * 1024;
> +	return hps;
> +}
> +
>  
>  #define KRING_SIZE	64
>  
> @@ -261,13 +304,13 @@ static int io_uring_alloc_huge(unsigned entries, struct io_uring_params *p,
>  	mem_used = (mem_used + page_size - 1) & ~(page_size - 1);
>  
>  	/*
> -	 * A maxed-out number of CQ entries with IORING_SETUP_CQE32 fills a 2MB
> -	 * huge page by itself, so the SQ entries won't fit in the same huge
> -	 * page. For SQEs, that shouldn't be possible given KERN_MAX_ENTRIES,
> +	 * A maxed-out number of CQ entries with IORING_SETUP_CQE32 can fill a
> +	 * single huge page by itself, so the SQ entries won't fit in the same
> +	 * huge page. For SQEs, that shouldn't be possible given KERN_MAX_ENTRIES,
>  	 * but check that too to future-proof (e.g. against different huge page
>  	 * sizes). Bail out early so we don't overrun.
>  	 */
> -	if (!buf && (sqes_mem > huge_page_size || ring_mem > huge_page_size))
> +	if (!buf && (sqes_mem > get_huge_page_size() || ring_mem > get_huge_page_size()))
>  		return -ENOMEM;
>  
>  	if (buf) {
> @@ -279,8 +322,8 @@ static int io_uring_alloc_huge(unsigned entries, struct io_uring_params *p,
>  		if (sqes_mem <= page_size)
>  			buf_size = page_size;
>  		else {
> -			buf_size = huge_page_size;
> -			map_hugetlb = MAP_HUGETLB | MAP_HUGE_2MB;
> +			buf_size = get_huge_page_size();
> +			map_hugetlb = MAP_HUGETLB;
>  		}
>  		sqes_size = buf_size;
>  		ptr = __sys_mmap(NULL, sqes_size, PROT_READ|PROT_WRITE,
> @@ -302,8 +345,8 @@ static int io_uring_alloc_huge(unsigned entries, struct io_uring_params *p,
>  		if (ring_mem <= page_size)
>  			buf_size = page_size;
>  		else {
> -			buf_size = huge_page_size;
> -			map_hugetlb = MAP_HUGETLB | MAP_HUGE_2MB;
> +			buf_size = get_huge_page_size();
> +			map_hugetlb = MAP_HUGETLB;
>  		}
>  		ptr = __sys_mmap(NULL, buf_size, PROT_READ|PROT_WRITE,
>  					MAP_SHARED|MAP_ANONYMOUS|map_hugetlb,
> -- 
> 2.43.0
>

-- 
Gabriel Krisman Bertazi

