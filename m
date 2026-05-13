Return-Path: <io-uring+bounces-13309-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oEB2Js5NBGrNGgIAu9opvQ
	(envelope-from <io-uring+bounces-13309-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2026 12:09:18 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9772153128D
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2026 12:09:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A7DAC304FA88
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2026 10:06:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5286338E5DF;
	Wed, 13 May 2026 10:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nYiQ/0MW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97FDA38BF67
	for <io-uring@vger.kernel.org>; Wed, 13 May 2026 10:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778666764; cv=none; b=sETEfLmIjsfed1/kYcx0IzcMfwJfkM6cJpWu8dl8f/XUXeeW68Q9snupbA4QbdybgNJALDoz28PXyfpvV2rGhmP9y3TZsTMw4MnAbO/cDK177hqo/AeVm/FcuOvmw8Qt8QO4/692HIWeT5/D7lmmEBJZq/cJRW94xCRABtFQRYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778666764; c=relaxed/simple;
	bh=CfUsDrF5ylNvxQAC5m07A4hEbvmSGmwJUzmCib0VNCs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ppBIOUavsNuIppXSHZ+Md0TK/ak1KUh2lB1m+yf/FWue90SXI3bybUyM7sYLOadrzIMF0pKWrFcLIcjNAxymX2JZtCfrOb4I+HsvEprwDtdCDbgTvsDvA8UtNnq9Cz3M2z/nbWH0hXt32O19rEWaA8TTSExyFMTz9rTNgsCsBEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nYiQ/0MW; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-bce57c132b2so526601666b.0
        for <io-uring@vger.kernel.org>; Wed, 13 May 2026 03:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778666761; x=1779271561; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y8agHE2UtR+0v8hUNRpGN3/NHmgQczj9TZKmKbKc+JU=;
        b=nYiQ/0MWx9zqnzz8qzzGMzyLjhAbZWS6PTm/379VNMshJcLtpIu5kxF6cnraFj1DbO
         BlzU1fL4lAJVK+xJyT+t0C2pgU0zXoRNRBJDuoDV7aRAV8/BXPrXurjZhhbFPRP66G4B
         IJsfO+VD/5yKfUDzBtYj/qCOyb/VG1WmTK1QWVOgt5y86ToAS0jGu5rCD0iTU4ZwdKbt
         PGSxd6voPOYFRhsskQZ2JVQRddLAKGHuQPOZVZK0jJea0/IaUCVN2Tich+MDh3mSnq/3
         vJA4Hf9G9AHe9O8fkuLzpoR2r1IZWqWqTZZsA1X2Vx2+bgVyylnlQ272ERqYKRVGESq0
         DC0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778666761; x=1779271561;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Y8agHE2UtR+0v8hUNRpGN3/NHmgQczj9TZKmKbKc+JU=;
        b=VbYa6qcH2lT5kSHSXzAA0T+Rk+wUPHcsDnDLiQocj9rcKuxN9/ZaDoDH2cm86MCLzD
         exhCKcEQ4nf7pLW5BfWpc1fRJS/aB22jaQOx4xa1VF2zLIy/Pjql2LBO3i7JJwm8dQJu
         nuOgiuv84RCdwlPTweNBzMNUP67H607ZR0BagJ9hfbhEFJ1FvWHvMFIyJw68nwFCT6qD
         AEfdF35I+GX5qnWsZTTcMTkRxxftMiXO6t+GGK2tDKeASVfScXiqlOxFBXnYV8gDJyGt
         AMSxsq2OPxNznnjL/6MGqi7sXjuls0fxr3F1BXT0nMU3/BCOvNb9rqokpNaETofHMW8g
         BlhA==
X-Forwarded-Encrypted: i=1; AFNElJ9qhSMaME1Hfwx5gchDtws/UwZsYmRI0at3f4jQ4Wij7kmLHgvUmFLfQ+eTNc+Lfkp01qhzeFWFxQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzISRkOsjykERXN1nXeQ/wrlC3Gr9yxIOGm1CQz4fxVfr7IbBZJ
	+JnAz1hfJTRBvQdJL6VnP1rpVeqcqd2jLbONzDX8A0zTDf2VuNuXJB8AUf1u1g1j
X-Gm-Gg: Acq92OG7uGjJwLMAg9wNv1pvSJtQlKudx1NJq8LkSFWNjpNPXP86dEz1feosB63xbcJ
	9O+QizGksa84LzqLikgIECtH9IyB9ocjnArmXLD5HvP19jzwWFu2E7GMxfF+8DC7vK2s8YqqaJq
	jb4Jin196qAZGWAnE6D1OgHve2jZSjB0ukBAUkUesDxDHBEsRItQbsifZuR7ZPPMwahiiqOHwBc
	t1HFR+NdPiV/Mp1EgdIYvggCL95DP1ef1+F6Y3T4/KPIsP+qqcNrppuUJ9xR3+KM1oWtDkMkLWL
	tR90ql1KmFQBOwqXitO7Wi/MrdHcoG75JUHw5VAJJFshLnNtQhH1oUMoT+W+AYDs7+bfIHWzGKH
	+q8p4Okl/0TY9+ESLD0NKtxVBr+k1PCLOMQ30kKZvoNG+w22b0MwgYNDXjggHhF3PJP5OPeoePK
	uRsdoYetTzMc2lEaoMWv9wxZ1wnsSEAct6e47vbHbM4PI84ZtGGZ9V0XTvCYas
X-Received: by 2002:a17:907:9493:b0:bc5:2352:555c with SMTP id a640c23a62f3a-bd3add39c4bmr174356866b.14.1778666759127;
        Wed, 13 May 2026 03:05:59 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bd2dba8fd22sm216615666b.16.2026.05.13.03.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 03:05:58 -0700 (PDT)
Date: Wed, 13 May 2026 11:05:57 +0100
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
Message-ID: <20260513110557.705bdeed@pumpkin>
In-Reply-To: <20a233d2f35274817aa643cc0fe113707eb47e72.1777475843.git.asml.silence@gmail.com>
References: <cover.1777475843.git.asml.silence@gmail.com>
	<20a233d2f35274817aa643cc0fe113707eb47e72.1777475843.git.asml.silence@gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9772153128D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13309-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Action: no action

On Wed, 29 Apr 2026 16:25:48 +0100
Pavel Begunkov <asml.silence@gmail.com> wrote:

> Introduce a new iterator type for dmabuf maps. The map in an opaque
> object with internals and format specific to the subsystem / driver, and
> only it can use that subsystem / driver for issuing IO. The task of the
> middle layers is to pass the map / iterator further down, maybe doing
> basic splitting and length checking. The iterator can only be used by
> operations of the file the associated map was created for.
> 
> Suggested-by: Keith Busch <kbusch@kernel.org>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  include/linux/uio.h | 11 +++++++++++
>  lib/iov_iter.c      | 29 +++++++++++++++++++++++------
>  2 files changed, 34 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/uio.h b/include/linux/uio.h
> index a9bc5b3067e3..75051aed70de 100644
> --- a/include/linux/uio.h
> +++ b/include/linux/uio.h
> @@ -12,6 +12,7 @@
>  
>  struct page;
>  struct folio_queue;
> +struct io_dmabuf_map;
>  
>  typedef unsigned int __bitwise iov_iter_extraction_t;
>  
> @@ -29,6 +30,7 @@ enum iter_type {
>  	ITER_FOLIOQ,
>  	ITER_XARRAY,
>  	ITER_DISCARD,
> +	ITER_DMABUF_MAP,
>  };
>  
>  #define ITER_SOURCE	1	// == WRITE
> @@ -71,6 +73,7 @@ struct iov_iter {
>  				const struct folio_queue *folioq;
>  				struct xarray *xarray;
>  				void __user *ubuf;
> +				struct io_dmabuf_map *dmabuf_map;
>  			};
>  			size_t count;
>  		};
> @@ -155,6 +158,11 @@ static inline bool iov_iter_is_xarray(const struct iov_iter *i)
>  	return iov_iter_type(i) == ITER_XARRAY;
>  }
>  
> +static inline bool iov_iter_is_dmabuf_map(const struct iov_iter *i)
> +{
> +	return iov_iter_type(i) == ITER_DMABUF_MAP;
> +}
> +
>  static inline unsigned char iov_iter_rw(const struct iov_iter *i)
>  {
>  	return i->data_source ? WRITE : READ;
> @@ -300,6 +308,9 @@ void iov_iter_folio_queue(struct iov_iter *i, unsigned int direction,
>  			  unsigned int first_slot, unsigned int offset, size_t count);
>  void iov_iter_xarray(struct iov_iter *i, unsigned int direction, struct xarray *xarray,
>  		     loff_t start, size_t count);
> +void iov_iter_dmabuf_map(struct iov_iter *i, unsigned int direction,
> +			struct io_dmabuf_map *map,
> +			loff_t off, size_t count);
>  ssize_t iov_iter_get_pages2(struct iov_iter *i, struct page **pages,
>  			size_t maxsize, unsigned maxpages, size_t *start);
>  ssize_t iov_iter_get_pages_alloc2(struct iov_iter *i, struct page ***pages,
> diff --git a/lib/iov_iter.c b/lib/iov_iter.c
> index 243662af1af7..e2253684b991 100644
> --- a/lib/iov_iter.c
> +++ b/lib/iov_iter.c
> @@ -575,7 +575,8 @@ void iov_iter_advance(struct iov_iter *i, size_t size)
>  {
>  	if (unlikely(i->count < size))
>  		size = i->count;
> -	if (likely(iter_is_ubuf(i)) || unlikely(iov_iter_is_xarray(i))) {
> +	if (likely(iter_is_ubuf(i)) || unlikely(iov_iter_is_xarray(i)) ||
> +	    unlikely(iov_iter_is_dmabuf_map(i))) {


Doesn't the extra check add more code to all the non-ubuf cases?
This could be fixed by either making iter_type a bitmask (with one bit set)
or writing an iter_is_one_of(i, ITER_xxx, ITER_yyy) define that uses
'(1 << i->iter_type) & ((1 << ITER_xxx) | ...)'
(look at the the nolibc printf code for an example).

>  		i->iov_offset += size;
>  		i->count -= size;
>  	} else if (likely(iter_is_iovec(i) || iov_iter_is_kvec(i))) {
> @@ -631,7 +632,8 @@ void iov_iter_revert(struct iov_iter *i, size_t unroll)
>  		return;
>  	}
>  	unroll -= i->iov_offset;
> -	if (iov_iter_is_xarray(i) || iter_is_ubuf(i)) {
> +	if (iov_iter_is_xarray(i) || iter_is_ubuf(i) ||

iter_is_ubuf() should have been first here.

-- David

> +	    iov_iter_is_dmabuf_map(i)) {
>  		BUG(); /* We should never go beyond the start of the specified
>  			* range since we might then be straying into pages that
>  			* aren't pinned.
> @@ -775,6 +777,20 @@ void iov_iter_xarray(struct iov_iter *i, unsigned int direction,
>  }
>  EXPORT_SYMBOL(iov_iter_xarray);
>  
> +void iov_iter_dmabuf_map(struct iov_iter *i, unsigned int direction,
> +			 struct io_dmabuf_map *map,
> +			 loff_t off, size_t count)
> +{
> +	WARN_ON(direction & ~(READ | WRITE));
> +	*i = (struct iov_iter){
> +		.iter_type = ITER_DMABUF_MAP,
> +		.data_source = direction,
> +		.dmabuf_map = map,
> +		.count = count,
> +		.iov_offset = off,
> +	};
> +}
> +
>  /**
>   * iov_iter_discard - Initialise an I/O iterator that discards data
>   * @i: The iterator to initialise.
> @@ -841,7 +857,7 @@ static unsigned long iov_iter_alignment_bvec(const struct iov_iter *i)
>  
>  unsigned long iov_iter_alignment(const struct iov_iter *i)
>  {
> -	if (likely(iter_is_ubuf(i))) {
> +	if (likely(iter_is_ubuf(i)) || iov_iter_is_dmabuf_map(i)) {
>  		size_t size = i->count;
>  		if (size)
>  			return ((unsigned long)i->ubuf + i->iov_offset) | size;
> @@ -872,7 +888,7 @@ unsigned long iov_iter_gap_alignment(const struct iov_iter *i)
>  	size_t size = i->count;
>  	unsigned k;
>  
> -	if (iter_is_ubuf(i))
> +	if (iter_is_ubuf(i) || iov_iter_is_dmabuf_map(i))
>  		return 0;
>  
>  	if (WARN_ON(!iter_is_iovec(i)))
> @@ -1469,11 +1485,12 @@ EXPORT_SYMBOL_GPL(import_ubuf);
>  void iov_iter_restore(struct iov_iter *i, struct iov_iter_state *state)
>  {
>  	if (WARN_ON_ONCE(!iov_iter_is_bvec(i) && !iter_is_iovec(i) &&
> -			 !iter_is_ubuf(i)) && !iov_iter_is_kvec(i))
> +			 !iter_is_ubuf(i) && !iov_iter_is_kvec(i) &&
> +			 !iov_iter_is_dmabuf_map(i)))
>  		return;
>  	i->iov_offset = state->iov_offset;
>  	i->count = state->count;
> -	if (iter_is_ubuf(i))
> +	if (iter_is_ubuf(i) || iov_iter_is_dmabuf_map(i))
>  		return;
>  	/*
>  	 * For the *vec iters, nr_segs + iov is constant - if we increment


