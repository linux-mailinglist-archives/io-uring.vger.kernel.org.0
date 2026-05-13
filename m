Return-Path: <io-uring+bounces-13313-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OA+zCr6DBGpwLAIAu9opvQ
	(envelope-from <io-uring+bounces-13313-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2026 15:59:26 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id D887D534898
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2026 15:59:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C437730AA1B0
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2026 13:36:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20988328B62;
	Wed, 13 May 2026 13:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a107B9Ew"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96222330D34
	for <io-uring@vger.kernel.org>; Wed, 13 May 2026 13:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778678955; cv=none; b=bUya21fXQAoHFb54cT0ehVZw258eZapmTNCbm249F6q9N0CYKTNohNo44FA70ShZk/UgN1knFHnf5dDN9r4Bv/C/tFmJpD24oaU+7Mzad1/zUMgExKYzX9X/T8j1DFRaVZT2uwyEAmvihZ0HHIljPAkTeRI5rU7UaDEXcwKA3k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778678955; c=relaxed/simple;
	bh=qvrzIgPI09xnL+lPNRKw47FDVzkn2xkt2K7Rwhlyrpg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jg+/1CRqoJQpJpQoa02ewDQBzc/pPa28JAQmCgOoACSPo7rQm4dCB2rGnfoJWhK/GDbAsAK/KUt7nFBOMuCM0RtkiR/UQrN8FIco61dw1LjdT/70kPy3prVdNNpXrKh3WzxHl9Xo5C0gSNenCY43QvTnxUyun5DxP+/uV5UtLjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a107B9Ew; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-441209fb77eso4152107f8f.1
        for <io-uring@vger.kernel.org>; Wed, 13 May 2026 06:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778678952; x=1779283752; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+cq+23+E96HQoAhwgeeSJr3+OJ8IJX5BGImZhad/wV8=;
        b=a107B9Ew/L+JG9kf+Z1nV/fx/+/Yb5mbJ9IZSmqcqG5NRhHtSigWVxLyt5e4tVheRP
         fVjtYzbSvKxWG/9swUAl2JC7bOL4zt7vyjCnIC8OuK2OMjbgJBd7ZXSOd9A2k/U6ZdZx
         IjexhbZVncU3yj8qsWTZZXbphJKEGru0GTV9TW0VSNxNUEF9TejQU1LxeC23owu6b8iT
         ERboyV8DTmKJyNrtYYu2ZtgNGMFqTuCpA+7JxZMpzt9wq45ITtvGgvRTJ8s7Z9NXHaiv
         Dc2JWteKzwRsB8GUKRASoBUvNyZQ288ROHW0dQRuuliK8uDWf25EzvdXbuywp4OcMKw3
         hDpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778678952; x=1779283752;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+cq+23+E96HQoAhwgeeSJr3+OJ8IJX5BGImZhad/wV8=;
        b=bVMVPmRlTX4CVBMX++tDRFzsese8AHUyXi3zuYeXN/b7iA7jSKx/m+S6GHV0hkVMvU
         X6WbhCbdMAlDhtf++LTtqpH4SlTV7rJqp4I94/ewxoOacH6w4FGqMn09aOUGjzcTIZ+6
         Q1diGbCLPyR7t0KOzIVYLBXr99EbKSa9ULRdBnlEWRlWJU6Xk3Xv+BEWDb0LWBWHvOHd
         NQaAhlAoZA95pZ8gkGw9luA7gYmYBVuEc3+AaOX5z6KKZ+OfM6JKgYWwlpHXGMDt+hor
         NRKykUu4pUoS6q9b5ieC4XCi1XhLbz55KUWBEVdc+tt9j46VKzOd4VMMlHb1PzrQhF0c
         dDDQ==
X-Forwarded-Encrypted: i=1; AFNElJ+p1ywZ8nEBSQCn5CKeWaZf+VZZJ80fMNOfHOphRc8uCSCVZa02bsWk0K1xG6btzW7DZO7md0X2SA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxsN6l2JHngcpKqnuB4AysfGKqyXxFY9ZdqnHj2xGFW2LH6VSPZ
	sDAhdZ2uZjujLoLvQjBGQn+k7jaClcZYTq2f3YH21n2yRqfyr8KdcuWT
X-Gm-Gg: Acq92OF3yXqwAalYxhlXqOtm2KWXS0bqoZA+UlwoN1pNjmVMwXNt1FqehI2L6dfB+jC
	71K6Y5TV5joI+z3VZWwxhWxzRQlotyKsDrn6ZRu/DAG62eXEwR8YUEpA7GyRYw+BK/Q8emdO0Wo
	mS97ToU4a4EbzzhVWmSl599F6VcMI3sFbpPo9e/YLgW3RGAxzA2sSDc47gh9PB4A5TpNsyRSbfP
	YRAVJsog8uhYfFv65HNYXnuoAgOdSvWdrn22uhe71NGB/ouBHoWCNdHgnk+CwG+bGGV4oZcXz9Z
	A8AOSnWfij08Vw3D+DthKkJXCH/RkqdTqkwK3F4cxDl+eB6dAGB5m37Ff0BNaFarh7TKtxfh39S
	11J0LvZz8RyxwD41jsqxrPbX2Th3XKlwpZWp8ujjmRQ3sIYzF6W7IGZmnFbHW0WWA8bO+72GoDT
	Kkhr1uNpDB4+J+AQUJIquqmLS34xjwmEXouF6UyhjVRJKLFnPeDL74JFrX+Il/
X-Received: by 2002:a5d:591c:0:b0:446:708e:1e8d with SMTP id ffacd0b85a97d-45ac4504a13mr9930360f8f.30.1778678951817;
        Wed, 13 May 2026 06:29:11 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4549120ec0asm40068578f8f.17.2026.05.13.06.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 06:29:11 -0700 (PDT)
Date: Wed, 13 May 2026 14:29:09 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, Christoph
 Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Andrew
 Morton <akpm@linux-foundation.org>, Sumit Semwal <sumit.semwal@linaro.org>,
 Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, Nitesh
 Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>, Anuj
 Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>, Phil Cayton
 <phil.cayton@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v3 02/10] iov_iter: add iterator type for dmabuf maps
Message-ID: <20260513142909.03ae6c2b@pumpkin>
In-Reply-To: <20260513110557.705bdeed@pumpkin>
References: <cover.1777475843.git.asml.silence@gmail.com>
	<20a233d2f35274817aa643cc0fe113707eb47e72.1777475843.git.asml.silence@gmail.com>
	<20260513110557.705bdeed@pumpkin>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D887D534898
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13313-lists,io-uring=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[25];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[davidlaightlinux@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,godbolt.org:url]
X-Rspamd-Action: no action

On Wed, 13 May 2026 11:05:57 +0100
David Laight <david.laight.linux@gmail.com> wrote:

...
> > @@ -575,7 +575,8 @@ void iov_iter_advance(struct iov_iter *i, size_t size)
> >  {
> >  	if (unlikely(i->count < size))
> >  		size = i->count;
> > -	if (likely(iter_is_ubuf(i)) || unlikely(iov_iter_is_xarray(i))) {
> > +	if (likely(iter_is_ubuf(i)) || unlikely(iov_iter_is_xarray(i)) ||
> > +	    unlikely(iov_iter_is_dmabuf_map(i))) {  
> 
> 
> Doesn't the extra check add more code to all the non-ubuf cases?
> This could be fixed by either making iter_type a bitmask (with one bit set)
> or writing an iter_is_one_of(i, ITER_xxx, ITER_yyy) define that uses
> '(1 << i->iter_type) & ((1 << ITER_xxx) | ...)'

This seems to DTRT:

#define _ITER_IS_ONE_OF(iter, t1, t2, t3, t4, t5, t6, t7, t8, ...) \
    ((1u << (iter)->iter_type) & ((1u << ITER_##t1) | (1u << ITER_##t2) | \
        (1u << ITER_##t3) | (1u << ITER_##t4) | (1u << ITER_##t5) | \
        (1u << ITER_##t6) | (1u << ITER_##t7) | (1u << ITER_##t8)))
#define ITER_IS_ONE_OF(iter, t, ...) \
    _ITER_IS_ONE_OF(iter, t, ## __VA_ARGS__, t, t, t, t, t, t, t)

int foo(void *);
int f(struct iov_iter *i)
{
    return ITER_IS_ONE_OF(i, UBUF, KVEC) ? foo(i) : 0;
}

See https://godbolt.org/z/sMz93zah1

Pasting ITER_ on the front ensures the values are constants of the right type.
OTOH it makes it harder to search for uses of each type.
You could paste _ITER_ on the front, elsewhere define _ITER_ITER_UVEC
to be ITER_UVEC (etc), and require the caller use the full name.

-- David

