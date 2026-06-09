Return-Path: <io-uring+bounces-13648-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id drE8Dut3J2r0xgIAu9opvQ
	(envelope-from <io-uring+bounces-13648-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 09 Jun 2026 04:18:19 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id CB1A265BD4E
	for <lists+io-uring@lfdr.de>; Tue, 09 Jun 2026 04:18:18 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=R3xyBKCC;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13648-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.232.135.74 as permitted sender) smtp.mailfrom="io-uring+bounces-13648-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 39853302FA59
	for <lists+io-uring@lfdr.de>; Tue,  9 Jun 2026 02:18:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A043E2C11C6;
	Tue,  9 Jun 2026 02:18:15 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4941C1A9F83
	for <io-uring@vger.kernel.org>; Tue,  9 Jun 2026 02:18:14 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780971495; cv=none; b=E/UVwYsBvKtqTwhOxTPZR6xsNPrma3FyUHbyfUz0xUY4NpchYwj+ldn4nt9Gu2D4+azmjMYO7nfRWc4BejdksBbvNgjN7MX4vCmmALMNMQ9TzKN8C1pP+zAEKsKIAb7XD5T8XmUC06fbkRPTpPk/AxnnrqfnEI0DE444Tnir968=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780971495; c=relaxed/simple;
	bh=Mkviq+qggEudIoPYzqDzbvZSr5qiT7nOEwvXHPgabOc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uhe+v0O9+GM1nPQUD/VFxoFohG8gtAawhPJuxHA6A84FLPWJ/e+hQQd9E9fpvW+ZIgnRBa2QUkAdI1GSrdhm6qQqYAizezIlI9Mw0oH/g1NhW6pu9ySFRiXEIuDj93hw7VH8hxwwiPtb9OlmddinjoYQvjvzKPpl0w1t2l3KrAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R3xyBKCC; arc=none smtp.client-ip=74.125.224.53
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-66061993121so4758183d50.0
        for <io-uring@vger.kernel.org>; Mon, 08 Jun 2026 19:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780971493; x=1781576293; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dy/z932Zn93LzHK/EBT1LPsSBdnELKH772opW/v2goE=;
        b=R3xyBKCC33lL/y2/BEx1xBc+Ap+ocuvKFUFi41cHnlG8Axby8pLxUjZPKwU6ZShzcP
         2D0wxKXcrhS3QAilSIJLf2G3wlTPTNLPsqQATGAWEhJsHiz51I41jC9DY+Y/N5Ti0wVn
         9QXhNFTnbZjF+jXyEiGMbAAzE4P8RJIzBfIai/2jdEDBXJs+YTo2/lL94TsOsDNGCgxd
         L0p08eOKNE9WmRzMSQoUS5p9HitrEG54ctZ8Xb8FMq0o3pQh7I9T9TWSKpQ64WNYmYls
         3FfzHdAXaIcChNvS4zxpmKhOv2xegxFhPwsethrlBU5xtMGeu5fHLWcwU05uZRUOizo0
         iqVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780971493; x=1781576293;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dy/z932Zn93LzHK/EBT1LPsSBdnELKH772opW/v2goE=;
        b=G82wAQ/4YBGwLt5IWYGWPwcdLv5SIijXAl44vALt2sESANSO4rl8nhYYO7S2TQH4a6
         yuWvAxtYykmyZZBUQD04lZK5Tnvb5lvOAXnMBJOJkSDqs/lUhyl2BQ6fIV9dKrmllb/Y
         1wySPs13Gb90z8UXD/1yAoLYc2jT/uYLVcGulatuOMGXTUIZ3qurgD09OQ4QzNeDH5oW
         1JKYVHtGGxgGDzXpcuRqYeCLUwkJB4vu/rqGZy4I8a7Z4WpwlIFr8BvHNmDhEBUCGcUT
         +Hi8TAxJrUGBM+sIEXzptXGJLjWH4Ca9OiFV8jfj0ziEq0z+S7Mxx/+O92v1rXJF8FqE
         FKSw==
X-Gm-Message-State: AOJu0YwlHSb+GJWJrbPCYSKCNDQY/dk9YUbpoDiNniX42CovtkCN3tJl
	Du/mkOgyxVvOCw6ZMIVJ8XitPletq3KJx6qpKlHToRdPfX2jK9hnHTgA
X-Gm-Gg: Acq92OFQ9woSJW9CIPVnScKouBds6n72E3W9C0A6aRqqglYdbnRgvtjlRrBEDYfztzZ
	QZQIO8MhpQbC8AN9/hlbSzU7GAltYL8USGZ96P5PtRRt1LmpQv3GNs4kujqLlCNg6kzDjqcUUtT
	MS4O/WP1/LC9X4Zgo1nA5+lmzk5PBS96ZCaAROwE2O+1gVzBrqQOfrlnFYybxxbNqhwvCsQU5p6
	RpLu7LDqDyhVVGO1OXJeYOnuJp1NuO/PSwV1QqRz0F9kb5AgZyOcjP5h8AWzGmrvGxUItwPFe9k
	zUgCfDsSPpZfDJPIsaA24j9ITZI54Sb4SlucD91QxkNxjBvrjC5HOkC9CBAubCEXb8VW/fGUvT1
	Yr6GQUK7olEedwJq9Fp3PX7r8Y5JT8jUm9WVRxeeelS8YBIqw9/SHEVVk274wdKZUED0zuC/smc
	7bw+BuI5Y4pvj53kxLXWpZXv0cR3Ly0pWIntu7wiXOImm9z/YAUHHTLxkRgA==
X-Received: by 2002:a05:690e:bc2:b0:660:8508:5c15 with SMTP id 956f58d0204a3-6610779e086mr14176111d50.49.1780971493233;
        Mon, 08 Jun 2026 19:18:13 -0700 (PDT)
Received: from 5163NRD-SPRABHU.ssi.samsung.com ([50.205.20.42])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7ea20ea819esm91777437b3.10.2026.06.08.19.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 19:18:12 -0700 (PDT)
Date: Mon, 8 Jun 2026 19:18:10 -0700
From: Swarna Prabhu <sw.prabhu6@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
	dave@stgolabs.net, dongjoo.seo1@samsung.com,
	Swarna Prabhu <s.prabhu@samsung.com>
Subject: Re: [RFC v1] io_uring/rsrc: add fast path huge page handling in
 buffer registration
Message-ID: <aid34r6sAVBkjID9@5163NRD-SPRABHU.ssi.samsung.com>
References: <20260608062937.804758-1-sw.prabhu6@gmail.com>
 <bdd63eb8-e8f8-4640-b769-24ceb619779e@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bdd63eb8-e8f8-4640-b769-24ceb619779e@kernel.dk>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13648-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:dave@stgolabs.net,m:dongjoo.seo1@samsung.com,m:s.prabhu@samsung.com,s:lists@lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER(0.00)[swprabhu6@gmail.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[swprabhu6@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: CB1A265BD4E

On Mon, Jun 08, 2026 at 09:57:03AM -0600, Jens Axboe wrote:
> On 6/8/26 12:29 AM, sw.prabhu6@gmail.com wrote:
> > From: Swarna Prabhu <sw.prabhu6@gmail.com>
> > 
> > io_uring sqe buffer registration path returns pinned user pages in 4k
> > granularity. If the first pinned page is in a hugetlb folio and
> > pages[nr_pages - 1] is also in the same folio then store a single page
> > entry and report *npages = 1 while dropping nr_pages - 1 of the pin
> > references it took earlier.
> > 
> > io_uring has support to identify and coalesce multi-hugepage-backed
> > fixed buffers from the function 'io_check_coalesce_buffer()'. However
> > we need to iterate over the entire page array and this patch bypasses
> > the additional checks for this case. The fast path reduces the overall
> > sqe buffer registration time that are backed by huge pages.
> > 
> > Measured with fio on bare metal backed by 1024 boot-allocated 2MB hugetlb
> > pages and setting the cpu cores to governor for max performance.
> > (hugepages=1024,hugepage_size=2M):
> >   fio --ioengine=io_uring --rw=randwrite --bs=1M --size=2G --iodepth=256
> >   --direct=1 --numjobs=5 --fixedbufs=1 --registerfiles=1 --iomem=mmaphuge
> >   --hugepage-size=2M.
> > 
> > Avg across 3 runs:
> > Metric                          Upstream(7.1-rc1)  Patched    Delta
> > Reg time(io_sqe_buffer_register): 3797ns            2970ns   -21.8%
> > Total reg for workload:           14.35ms           11.34ms  -21.9%
> > fio write bandwidth:              1416MiB/s   1416MiB/s    No regression
> 
> This looks pretty reasonable. Curious what inspired this change though?
> Workloads that register and unregister huge page backed buffers at
> a rapid pace? The registration path should obviously not be slower than
> it needs to on purpose, but it should also not be part of the application
> fast path in general. I'd expect most users to register their IO memory
> pool upfront and then never really touch it.
> 
> Can you expand on the background that led to this?

We started out looking at whether io_uring could get a bandwidth 
improvement from hugetlb/THP-backed fixed buffers ie having the kernel 
take better advantage of huge-page backing for the registered IO memory.
This attempt was encouraged by an RFC on the VFIO side [1], which 
introduces optimization while pinning pages backed by huge pages to 
avoid the latencies of pinning at 4k granularity.

io_uring has already implemented the post processing of pinned pages 
from the coalesce check. So bandwidth angle didn't pan out. 
However we found registration-time savings from short circuiting 
the page array walks in 'io_check_coalesce_buffer' when whole buffer 
lives in a single hugetlb folio. 

We don't have a workload that register and unregister huge page backed 
buffers at a rapid pace. Hence it is a one-time registration cost saving 
that seemed worth sending for feedback.

[1] https://lore.kernel.org/all/20251223230044.2617028-2-aaronlewis@google.com/> 

> > Signed-off-by: Swarna Prabhu <s.prabhu@samsung.com>
> 
> This doesn't match your From: in the patch, that would need to be
> corrected.

Noted. 


Thank you
Swarna

