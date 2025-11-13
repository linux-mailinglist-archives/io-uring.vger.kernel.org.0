Return-Path: <io-uring+bounces-10585-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 92F2BC57160
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 12:05:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E719B355C43
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 11:01:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC3AE337B8E;
	Thu, 13 Nov 2025 11:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LchsgSqo"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843C23346A2
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 11:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763031675; cv=none; b=iGMIDsu2aGWWEOuR7THbOxXCCgXdOznpw63CaRUm6vslXfUB6iJcCAGKt3KcR5UY6bWztCG+MjjQd7m/vW3dayMghSwmXL9zZ2bUitBYm2+zWAT6bCauhCezaNQYcu7+N4G3DuSOeA3tCQYs3l5L20R8K9emfONJ/5VzcuCnMhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763031675; c=relaxed/simple;
	bh=dWZ57ctAvh6zYSImXe3rOe28g+rysrCLCpD2RZJukd8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jglUR1NumyvSOeS3l07Lpje+nS4s8ngnzspMD66C0fISU3nvsFFMxgebtmOrRKpsuOVJLFJ8X/rZQJF9l8yz/Cqn4rE6ke4SRasLg9EfEn79DauVEVhrRxLT6ef6PQke7ETWHOUP5xRJHKpFbDSIivn3yDZ0zN33E1rHlHh9+fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LchsgSqo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763031672;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xkwPanruht+tVCaTSjqmyz1RwODzJHjVCA3D3SgXxaA=;
	b=LchsgSqoNJ7vEhhJmhUh63ZdztjGEZBPYVRj6jLXC/N2TzovW8efjhGphSs/ghpaRWmfRd
	HYPzfnZniRPb/hDIQLl1H1P901k5VlFo4VkwGFph/zvY2CYYxK18+tcnq96lVZ+kX1kS3M
	MHXCujoVgiOfzgg3JdGyBR3QtJySot0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-444-MaKrvlBuNZ-BTZZXknTIww-1; Thu,
 13 Nov 2025 06:00:16 -0500
X-MC-Unique: MaKrvlBuNZ-BTZZXknTIww-1
X-Mimecast-MFC-AGG-ID: MaKrvlBuNZ-BTZZXknTIww_1763031614
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2B31418002F8;
	Thu, 13 Nov 2025 11:00:07 +0000 (UTC)
Received: from fedora (unknown [10.72.116.82])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DD2DA18004A3;
	Thu, 13 Nov 2025 11:00:02 +0000 (UTC)
Date: Thu, 13 Nov 2025 18:59:57 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Stefan Metzmacher <metze@samba.org>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>,
	Akilesh Kailash <akailash@google.com>, bpf@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH 3/5] io_uring: bpf: extend io_uring with bpf struct_ops
Message-ID: <aRW6LfJi63X7wbPm@fedora>
References: <20251104162123.1086035-1-ming.lei@redhat.com>
 <20251104162123.1086035-4-ming.lei@redhat.com>
 <94f94f0e-7086-4f44-a658-9cb3b5496faf@samba.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94f94f0e-7086-4f44-a658-9cb3b5496faf@samba.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Thu, Nov 13, 2025 at 11:32:56AM +0100, Stefan Metzmacher wrote:
> Hi Ming,
> 
> > io_uring can be extended with bpf struct_ops in the following ways:
> > 
> > 1) add new io_uring operation from application
> > - one typical use case is for operating device zero-copy buffer, which
> > belongs to kernel, and not visible or too expensive to export to
> > userspace, such as supporting copy data from this buffer to userspace,
> > decompressing data to zero-copy buffer in Android case[1][2], or
> > checksum/decrypting.
> > 
> > [1] https://lpc.events/event/18/contributions/1710/attachments/1440/3070/LPC2024_ublk_zero_copy.pdf
> > 
> > 2) extend 64 byte SQE, since bpf map can be used to store IO data
> >     conveniently
> > 
> > 3) communicate in IO chain, since bpf map can be shared among IOs,
> > when one bpf IO is completed, data can be written to IO chain wide
> > bpf map, then the following bpf IO can retrieve the data from this bpf
> > map, this way is more flexible than io_uring built-in buffer
> > 
> > 4) pretty handy to inject error for test purpose
> > 
> > bpf struct_ops is one very handy way to attach bpf prog with kernel, and
> > this patch simply wires existed io_uring operation callbacks with added
> > uring bpf struct_ops, so application can define its own uring bpf
> > operations.
> 
> This sounds useful to me.
> 
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >   include/uapi/linux/io_uring.h |   9 ++
> >   io_uring/bpf.c                | 271 +++++++++++++++++++++++++++++++++-
> >   io_uring/io_uring.c           |   1 +
> >   io_uring/io_uring.h           |   3 +-
> >   io_uring/uring_bpf.h          |  30 ++++
> >   5 files changed, 311 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> > index b8c49813b4e5..94d2050131ac 100644
> > --- a/include/uapi/linux/io_uring.h
> > +++ b/include/uapi/linux/io_uring.h
> > @@ -74,6 +74,7 @@ struct io_uring_sqe {
> >   		__u32		install_fd_flags;
> >   		__u32		nop_flags;
> >   		__u32		pipe_flags;
> > +		__u32		bpf_op_flags;
> >   	};
> >   	__u64	user_data;	/* data to be passed back at completion time */
> >   	/* pack this to avoid bogus arm OABI complaints */
> > @@ -427,6 +428,13 @@ enum io_uring_op {
> >   #define IORING_RECVSEND_BUNDLE		(1U << 4)
> >   #define IORING_SEND_VECTORIZED		(1U << 5)
> > +/*
> > + * sqe->bpf_op_flags		top 8bits is for storing bpf op
> > + *				The other 24bits are used for bpf prog
> > + */
> > +#define IORING_BPF_OP_BITS	(8)
> > +#define IORING_BPF_OP_SHIFT	(24)
> > +
> >   /*
> >    * cqe.res for IORING_CQE_F_NOTIF if
> >    * IORING_SEND_ZC_REPORT_USAGE was requested
> > @@ -631,6 +639,7 @@ struct io_uring_params {
> >   #define IORING_FEAT_MIN_TIMEOUT		(1U << 15)
> >   #define IORING_FEAT_RW_ATTR		(1U << 16)
> >   #define IORING_FEAT_NO_IOWAIT		(1U << 17)
> > +#define IORING_FEAT_BPF			(1U << 18)
> >   /*
> >    * io_uring_register(2) opcodes and arguments
> > diff --git a/io_uring/bpf.c b/io_uring/bpf.c
> > index bb1e37d1e804..8227be6d5a10 100644
> > --- a/io_uring/bpf.c
> > +++ b/io_uring/bpf.c
> > @@ -4,28 +4,95 @@
> >   #include <linux/kernel.h>
> >   #include <linux/errno.h>
> >   #include <uapi/linux/io_uring.h>
> > +#include <linux/init.h>
> > +#include <linux/types.h>
> > +#include <linux/bpf_verifier.h>
> > +#include <linux/bpf.h>
> > +#include <linux/btf.h>
> > +#include <linux/btf_ids.h>
> > +#include <linux/filter.h>
> >   #include "io_uring.h"
> >   #include "uring_bpf.h"
> > +#define MAX_BPF_OPS_COUNT	(1 << IORING_BPF_OP_BITS)
> > +
> >   static DEFINE_MUTEX(uring_bpf_ctx_lock);
> >   static LIST_HEAD(uring_bpf_ctx_list);
> > +DEFINE_STATIC_SRCU(uring_bpf_srcu);
> > +static struct uring_bpf_ops bpf_ops[MAX_BPF_OPS_COUNT];
> 
> This indicates to me that the whole system with all applications in all namespaces
> need to coordinate in order to use these 256 ops?

So far there is only 62 in-tree io_uring operation defined, I feel 256
should be enough.

> 
> I think in order to have something useful, this should be per
> struct io_ring_ctx and each application should be able to load
> its own bpf programs.

per-ctx requirement looks reasonable, and it shouldn't be hard to
support.

> 
> Something that uses bpf_prog_get_type() based on a bpf_fd
> like SIOCKCMATTACH in net/kcm/kcmsock.c.

I considered per-ctx prog before, one drawback is the prog can't be shared
among io_ring_ctx, which could waste memory. In my ublk case, there can be
lots of devices sharing same bpf prog.



thanks,
Ming


