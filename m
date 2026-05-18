Return-Path: <io-uring+bounces-13391-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QDnMAPXsCmo89gQAu9opvQ
	(envelope-from <io-uring+bounces-13391-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 12:41:57 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id E052756ADB5
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 12:41:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0C2EE300B1A5
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 10:41:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5C7333EAF3;
	Mon, 18 May 2026 10:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YOYYn5lU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C7A3321A2
	for <io-uring@vger.kernel.org>; Mon, 18 May 2026 10:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779100826; cv=none; b=HvQggSICSv3t5dzrI+7OM1v8PcYr3OPgR0thRAxoFlnA8PSAkVzEWIo7K14PHZW1UkJ57xcoWRTi9yiY/YBqNcORERTTAJVxxvtiqF29EArzry3uHRJCg2wx/22yeNtSlca990xBzdmA4T/KYGTiyD6qCA4xQSFb75ylSEWnpd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779100826; c=relaxed/simple;
	bh=nvWmJIaONRzVgGZxYOqc+RrJHx05ZpEkKGknRiyvoD8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T0kQJY+gaf8fB/q+zypMPut+BudWajvHLQCg4IAI3Dkh0nt+2/AxqhKyV/erSEm6aEfPrX4YVSwd2e8sgIPivQRI02VbhdzrcNwiKRiNg140VSUuIlm49et4odbNd2Q893y1LG+h40yPof720Tm23ETcJuxnXufJidtgwkfaikc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YOYYn5lU; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48909558b3aso22780805e9.0
        for <io-uring@vger.kernel.org>; Mon, 18 May 2026 03:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779100813; x=1779705613; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KBUJm1g4jrVLHLARnQ410xCyIfZ2+knqUA7xvFczZVo=;
        b=YOYYn5lUbwDpJJVHgwa+b/uqKmMzzJUm2hIehQT0RfeFic6DPTkEctu4+6yrgoTAaT
         u9kxlBwiCUk0uHQ4MQ/QBAMPpt5K718IZ1zg5BOo0iQ4OLbx3XAXNVsWFT6PYjxqxiG3
         oHvr3OC9nqzpeCxci5FlRGKp37b70XvyPHj0YP2cIbP8cJX6i2a3sWtAjU3noV+2X2PV
         wkzhPFtUIxCLP4t2y+z/oBQ4ozn1vMXZ6+OkNNIHU/t1RtK8qSsYeCEvIA84yzvQhJL7
         MTCcnZhiu8pCfSAOkym3yaNcHT8UovdrqFjblxy1DWYmyiaOdzDrXeutHhDa+t8th2oz
         CsUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779100813; x=1779705613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KBUJm1g4jrVLHLARnQ410xCyIfZ2+knqUA7xvFczZVo=;
        b=LEJx1Ikgh28MQJkr7TVsg0nOkqgHuECQCef5iSHMwrsm6bbiTPm6VNLf4Q9CbOczDq
         0eYrHYOBLpUtaJrUm1RWB9Ptvv4B4xWVxDYxZTASW6mltGGiF2WTu3i27K74iemALlNE
         4+3cXd0UEitm/ycHFDsv8iKnjufirlENvVM1uD1eZp9jdrmAz+BUUdaAA5qvUHNVYD67
         MvoBaXZezAakCdTOQBO4mD02eVksx9Iwf2LDJTZQOpRYPRXAOC+PbKPlFQMOjB/8lon/
         ks8x3lT6KBuAPGDutJil7B1EhEgVXDjgTC9BPZ0qm0BBbgHb7Uqy1Gh3IphHPeMQkyKY
         caFg==
X-Forwarded-Encrypted: i=1; AFNElJ84tfKUh+94E58TuYU1Mrr6yY5OcFKmoCOsDpi8sUE/lSPcJubTKN1NItC+M9jGFLsj5UxNHY/mHg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7j0cKhNfE01waiAidLlbQcUSM/YPnOOuGxPoP+kqZiQPzgBIi
	JDgTO7vvuxbHB6HRK8+MI8TrU+dzsy0HSEWU6zuZwD/mr+yRaiAPX9c0
X-Gm-Gg: Acq92OHm5uh+MlgRYJyi6Ky8uyn7Tp6HcrMMgAr3ZrH40VfxjwrG6h9XKwvKzsmE4Gy
	f1uM/1G8pI6ZC30YNoPELftudMVKixTre5Tw/QAVs+3GzYvDVhViuwH5+lZjyzti0tZaxM01Q2e
	JtjDLJSNuqgdVo+xGrHJn0tkh+v5rT1RUtdpfgshlxr34FbA5Ic6ak0lH4ZY+BIRBOV7gvpot8N
	uJgIlSMrPkMpGrqDNsBI3Q4SXmBdYmAsJ6w5crM/XhJztPmm0bN8xEgwcnweHrlHR+MoiI5l9VZ
	1TLrD8eTGg92bJH3y6NsT9xlXRLSAkBfgNA9t858tO8/kGts1W7QZillEUJMZz0zLggF0mbe6H4
	8fNs1EjLEDLuGnFZejF7MxpbhuYWcbyHGm++VfPgf8S0EXQwWQhS8jWt3ksTHfXD6D5b3TLBDg9
	urDDbI5LXi9QU6RA6C/E0Jf55/W0K777V7TGlPeanAGLZhmmq4fs0shOj+KrGlxQtCp3+u80UqJ
	25Cv0GxzpuVNQ==
X-Received: by 2002:a05:600c:4fc9:b0:489:1c1f:35df with SMTP id 5b1f17b1804b1-48fe60e58ecmr202920365e9.10.1779100812550;
        Mon, 18 May 2026 03:40:12 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe4c90b27sm255713955e9.8.2026.05.18.03.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 03:40:12 -0700 (PDT)
Date: Mon, 18 May 2026 11:40:10 +0100
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
Message-ID: <20260518114010.6e1f7391@pumpkin>
In-Reply-To: <4b2f74e9-3225-47f6-85fe-911720030e35@gmail.com>
References: <cover.1777475843.git.asml.silence@gmail.com>
	<20a233d2f35274817aa643cc0fe113707eb47e72.1777475843.git.asml.silence@gmail.com>
	<20260513110557.705bdeed@pumpkin>
	<20260513142909.03ae6c2b@pumpkin>
	<4b2f74e9-3225-47f6-85fe-911720030e35@gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E052756ADB5
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
	TAGGED_FROM(0.00)[bounces-13391-lists,io-uring=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Action: no action

On Mon, 18 May 2026 10:24:35 +0100
Pavel Begunkov <asml.silence@gmail.com> wrote:

> On 5/13/26 14:29, David Laight wrote:
> > On Wed, 13 May 2026 11:05:57 +0100
> > David Laight <david.laight.linux@gmail.com> wrote:
> > 
> > ...  
> >>> @@ -575,7 +575,8 @@ void iov_iter_advance(struct iov_iter *i, size_t size)
> >>>   {
> >>>   	if (unlikely(i->count < size))
> >>>   		size = i->count;
> >>> -	if (likely(iter_is_ubuf(i)) || unlikely(iov_iter_is_xarray(i))) {
> >>> +	if (likely(iter_is_ubuf(i)) || unlikely(iov_iter_is_xarray(i)) ||
> >>> +	    unlikely(iov_iter_is_dmabuf_map(i))) {  
> >>
> >>
> >> Doesn't the extra check add more code to all the non-ubuf cases?
...
> >> or writing an iter_is_one_of(i, ITER_xxx, ITER_yyy) define that uses
> >> '(1 << i->iter_type) & ((1 << ITER_xxx) | ...)'  
> > 
> > This seems to DTRT:
> > 
> > #define _ITER_IS_ONE_OF(iter, t1, t2, t3, t4, t5, t6, t7, t8, ...) \
> >      ((1u << (iter)->iter_type) & ((1u << ITER_##t1) | (1u << ITER_##t2) | \
> >          (1u << ITER_##t3) | (1u << ITER_##t4) | (1u << ITER_##t5) | \
> >          (1u << ITER_##t6) | (1u << ITER_##t7) | (1u << ITER_##t8)))
> > #define ITER_IS_ONE_OF(iter, t, ...) \
> >      _ITER_IS_ONE_OF(iter, t, ## __VA_ARGS__, t, t, t, t, t, t, t)  
> 
> We definitely don't want that, using them directly would've been
> much cleaner.
> 
> if (get_type_mask(i) & (TYPE1 | TYPE2)) ...

You need to shift all the TYPEn as well.
The above condition would become:
	if (likely(ITER_IS_ONE_OF(i, UBUF, XARRAY, DMABUF_MAP))) {
which reads reasonable well.
Without the token pasting it becomes:
	if (likely(ITER_IS_ONE_OF(i, ITER_UBUF, ITER_XARRAY, ITER_DMABUF_MAP))) {
and the line starts getting long.
Although that version probably needs a check that the mask is constant.

-- David


> 


