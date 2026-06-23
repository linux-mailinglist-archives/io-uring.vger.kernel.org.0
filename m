Return-Path: <io-uring+bounces-13817-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id ESGbFnVpOmrO8QcAu9opvQ
	(envelope-from <io-uring+bounces-13817-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2026 13:09:41 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F0D6D6B690A
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2026 13:09:40 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=on8pQFKO;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13817-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13817-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6EA933002313
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2026 11:09:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9304C26AE5;
	Tue, 23 Jun 2026 11:09:37 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E183D3008
	for <io-uring@vger.kernel.org>; Tue, 23 Jun 2026 11:09:36 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782212977; cv=none; b=NipVLWx+gga0+edD5XemkONI5ixhT+uSRZ+1w03zJy+ZllIbVsPFSguzwopSTnLyjPcTA++DXdCoyPD6PhNIasHTeeKS6qYb+3Z7qrvpCRh2SsnyMx/ilc4YBLlw/9h0irdp1+BE0lZdRXo5VkOoIS0jpuJjn71M2FsN+Da7NL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782212977; c=relaxed/simple;
	bh=Xl8cH5r4DiHwX4Z4zIdYVYnfcPJGwMsvWT8iXVpTO1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ImZl1JNyO3Vl6MdFI3l1+HyXFmyHIci55HxhZjngpCG+x3pSpGeZDig/YU2s4Rr5xn9/L/lh1caeBdZ5q7dQfifFQTLdRS165O+YeyGhfsvNyCk0A9o5Oib1DtKTum4X4dYiEc4qW+SRWeEWS3KG2xZJmFMS2kgu8wFKN6iJJOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=on8pQFKO; arc=none smtp.client-ip=209.85.214.170
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2c6c101aeafso34623975ad.0
        for <io-uring@vger.kernel.org>; Tue, 23 Jun 2026 04:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782212975; x=1782817775; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l7Gkrm+MAaYW1+T2C8EgcjFTjwo2mLAidhxEQKtNchE=;
        b=on8pQFKOVCQrFSjEEi8N3z0bDWfVm0WPQUYqRm0ajd9PD3dRZV8uU5GovpNRfc6StC
         9Gd9Mk5MlgDCi+o123w5gHHQIMUKkKI7L0WpLWKIRagGKkrvzvivtknK3was+lWr6hCJ
         TfhvKjRFkz2eBdSwjnGs2FnjFVOpYXNYpXlvNUd+LIbWlG0FUcfr1f66TRtRJmsHhdff
         f/fSitg70OuFyl0G5AJ0CnYPj9NQqbnFcXFRAP1zao7BGxb36piSIJ9OorDXQb+TY4bR
         JCafizw6vmhmzjCdWhC/oDtoB1hg5j5Vc1PG+mBi0UMQvFTtqffOAO+lxnJZ1Gvgqxqm
         XFUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782212975; x=1782817775;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=l7Gkrm+MAaYW1+T2C8EgcjFTjwo2mLAidhxEQKtNchE=;
        b=aiPP0mumPvY/tugJyZwsWD+mvbGals5CtN5KNjA2Kw6MXXnoSV4X6vPBrnX1gZuhw5
         nBV9Zuep9LDhamxxGgno8WXeJoVpqI6EIpUqxEwDkcxoH+rVDmfy5Rl93mgDORkqEKUp
         RJKB65+6gKwmFUm2fDTHRur4/uTPEwZ/4ppWsezvS2ez+FUHZ6yKCBWXTqfn4otrX16e
         7qN9ifbBcEvykVUNglJZ22mq3eAszKjQEJ9lhUryAd1Qr68RaZRogAZpx5MweVY0lcRT
         2oiNjnCbnhNzyWJ1buCZZW4oq2TDGc1gnUSh/Rzo8PbksuHi0Tdqu+1SQL7AiPp+VrN7
         Ao4g==
X-Gm-Message-State: AOJu0YzrKdDYAdHt1GGxeT0nCusD9Fc1ymuAFJdEsniIJ2Ih0qSfIdIN
	J5oDzpWayunmCsxILrqN4h/B51WjLJMQPwukN2xNvvlYpUdS++ApWxQm
X-Gm-Gg: AfdE7ckZMAmEKLBZbKrROilAkt40FLBpLs1/74k08TVu/vuRkBW1iyl4SbYyrxTNAHf
	MgWQIf6uoIsRaeYUZj3PWEHPd1GnmE44UlnnyHiiaZ+mqwzf3A9BnzHO+TwnYjq8fH0lZTa7voi
	mIn2LjF+s4QxG6RVKQpRF1Me/ZnxfVJF46cvydMuJ0uic/Fj2u6p3dZC0hnqK3izEjGA1oFPhjh
	xu1fqIuIyWVeHo/fRpcPavWSDBdIdg8tY1nrYhcPLJEYxnIiXYLUrfq+2LvhPblb1US1RW+nFBT
	4NIzPENsqdB+1uF6Zj1PLrDBbI5mX9pqH4KNt7/TyYTSGUVLPzfb8YxG6GW/grkDnGRIFluejTZ
	B1zg56XHtbmd4wQvTJYTzAjMAVsNdUu5F5dWwAGGPqBwtBFb9D14zHgz5Cqognztc+GCisMBzO2
	e7ddVyknDvKrvUhSlq8QiWwVbt5N9dpqX6ce+HwWS+VM8oyHVa105g0OUh/oCvJg8nEBTdBVkPs
	jq3QfjK+R+05Y6pLGs9z39jfaLZBn0=
X-Received: by 2002:a17:903:189:b0:2c6:9897:dbaa with SMTP id d9443c01a7336-2c7c99445d1mr18106965ad.3.1782212975292;
        Tue, 23 Jun 2026 04:09:35 -0700 (PDT)
Received: from prateek-Aspire-A515-57G.. ([182.77.73.131])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7436af558sm121843415ad.14.2026.06.23.04.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 04:09:34 -0700 (PDT)
From: Prateek <kprateek283@gmail.com>
To: gabriel@krisman.be
Cc: io-uring@vger.kernel.org,
	kprateek283@gmail.com
Subject: Re: [PATCH] setup: dynamically detect default huge page size
Date: Tue, 23 Jun 2026 16:39:30 +0530
Message-ID: <20260623110930.910263-1-kprateek283@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <87qzlyy0zd.fsf@mailhost.krisman.be>
References: <87qzlyy0zd.fsf@mailhost.krisman.be>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	TAGGED_FROM(0.00)[bounces-13817-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER(0.00)[kprateek283@gmail.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS(0.00)[m:gabriel@krisman.be,m:io-uring@vger.kernel.org,m:kprateek283@gmail.com,s:lists@lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kprateek283@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: F0D6D6B690A

Hi Gabriel,

Thanks for the review.

On Mon, Jun 22, 2026 at 16:49 Gabriel Krisman Bertazi wrote:
> > +static size_t get_huge_page_size(void)
> > +{
> > +   static size_t hps;
>
> Please, initialize your static variables to makes it readable. I.e,
> should be initialized it to 2MB.

hps is left at 0 on purpose as a "not computed yet" flag -- same thing get_page_size() does in arch/aarch64/lib.h with cache_val. If I set hps = 2MB upfront, the first call just returns 2MB without ever reading /proc/meminfo, which defeats the point.

> > +   size_t ret = 2 * 1024 * 1024; /* fallback: 2MB */
>
> ret redundant with hps, could go away.

The local ret is there so I only write to hps once at the end. If two threads race into this function, neither one sees a half-baked fallback value in hps. The race itself is harmless since both threads would compute the same result anyway.

> > +       if (p + 13 <= end &&
> > +           p[0]  == 'H' && p[1]  == 'u' && p[2]  == 'g' &&
> > +           p[3]  == 'e' && p[4]  == 'p' && p[5]  == 'a' &&
> > +           p[6]  == 'g' && p[7]  == 'e' && p[8]  == 's' &&
> > +           p[9]  == 'i' && p[10] == 'z' && p[11] == 'e' &&
> > +           p[12] == ':') {
>
> This is unreadable.  It would be much better as a two line loop
> iterating over two strings...  But then, why not create it a couple line
> implementation of memcmp and atoi in arch/generic/lib.h instead?

Yeah, the char-by-char match is ugly, agreed. For v2 I'll add a __uring_memcmp in nolibc.c and shim it in lib.h behind #ifdef CONFIG_NOLIBC, same way memset/malloc/free are done today. arch/generic/lib.h only gets included on archs without nolibc support, so putting memcmp there wouldn't help x86/aarch64/riscv64 nolibc builds. nolibc.c + lib.h shim covers all configs. Then setup.c just calls memcmp(p, "Hugepagesize:", 13) -- normal builds use libc's memcmp, nolibc builds use the shim. I'll keep the digit parsing loop as-is since it's simple enough and pulling in atoi feels like overkill.

> This function should go in arch/generic/lib.h too.  A hint is the
> get_page_size is already there.

get_huge_page_size() only lives in setup.c and uses the __sys* wrappers from syscall.h, which work in all build configs. Unlike get_page_size() which is needed across multiple files, there's no reason to put this in the arch headers and duplicate it four times.

> That said, we should be looking into something like the kernel's nolibc
> instead of reinventing libc.

Agreed, worth looking into separately. This patch just fixes the immediate hugepage issue.

Will send a v2 with the memcmp approach.

Thanks,
Prateek

