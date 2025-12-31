Return-Path: <io-uring+bounces-11343-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 43084CEBB85
	for <lists+io-uring@lfdr.de>; Wed, 31 Dec 2025 10:50:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CB4B230109B1
	for <lists+io-uring@lfdr.de>; Wed, 31 Dec 2025 09:49:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6A273148C3;
	Wed, 31 Dec 2025 09:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gOEjDBfB"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5267311C31
	for <io-uring@vger.kernel.org>; Wed, 31 Dec 2025 09:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767174598; cv=none; b=Yn0Om4y9w8zOsOLj4sbK57fwufzt4bTPetfugm0RmbwcDhlwi7gMOYnoZFdMzQgXhAT6Ep7nbgtlHvbb/t9X/27/P4N+VZsQz2DTd7yTVTQCC9VTMdx4Mselk8j2SK8pgKxF4FLJeDv1dCBZ9shJkQEDrcPHh5Po7dT1sOQoSu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767174598; c=relaxed/simple;
	bh=F/Zl9i9tpVZDEmS/CL8ZOYBxywoJ0mjDHAb5r9PxyFQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VWLOH1B73WXaoxi9PdDRsI/1/nHdgkdK6X4eZ/xZ6jHDbFWI7qdNNOHlLfouKJjylddTishvrpXfq1Nj53Jho+5Ac7hhY+m0jR3L+O48fI5ZAUlbQk0voXfLHojpNVuhcbveaJ0C1ZORIMWtP1I6ziaKlSe4fDnm/KnpaawsX+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gOEjDBfB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767174595;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AI+iUMyfF3dGxKxZNaqJORzWknrLEklaB5g9aOWZWDQ=;
	b=gOEjDBfBeBVmA7ThDxYok0MXXB8uVWyU/0ClHJkom4kcOAO2eewuk0/rQ93QlV4dtKS9qG
	NlqSYWNkOl/CIc6FtGNwEQL6Y6wXK3Bfl4hN164KETeAAnL9L70er5993A6zBBb7RIIB1H
	bXMI3N1wXtXVPGZsKt+HiushSSYdsKA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-694-eAYuctNJOtOdiG1ilt-WPQ-1; Wed,
 31 Dec 2025 04:49:54 -0500
X-MC-Unique: eAYuctNJOtOdiG1ilt-WPQ-1
X-Mimecast-MFC-AGG-ID: eAYuctNJOtOdiG1ilt-WPQ_1767174593
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E2C561800365;
	Wed, 31 Dec 2025 09:49:52 +0000 (UTC)
Received: from fedora (unknown [10.72.116.125])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9E6E130001A2;
	Wed, 31 Dec 2025 09:49:48 +0000 (UTC)
Date: Wed, 31 Dec 2025 17:49:43 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	Akilesh Kailash <akailash@google.com>, bpf@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH 2/5] io_uring: bpf: add io_uring_ctx setup for BPF into
 one list
Message-ID: <aVTxt_0DR1ZEE8SW@fedora>
References: <20251104162123.1086035-1-ming.lei@redhat.com>
 <20251104162123.1086035-3-ming.lei@redhat.com>
 <CADUfDZonj-mn9oOF-cGgw2TS9Emmk0vP=3=+n0bJbhGw43ra3A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZonj-mn9oOF-cGgw2TS9Emmk0vP=3=+n0bJbhGw43ra3A@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Tue, Dec 30, 2025 at 08:13:51PM -0500, Caleb Sander Mateos wrote:
> On Tue, Nov 4, 2025 at 8:22 AM Ming Lei <ming.lei@redhat.com> wrote:
> >
> > Add io_uring_ctx setup for BPF into one list, and prepare for syncing
> > bpf struct_ops register and un-register.
> >
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  include/linux/io_uring_types.h |  5 +++++
> >  include/uapi/linux/io_uring.h  |  5 +++++
> >  io_uring/bpf.c                 | 15 +++++++++++++++
> >  io_uring/io_uring.c            |  7 +++++++
> >  io_uring/io_uring.h            |  3 ++-
> >  io_uring/uring_bpf.h           | 11 +++++++++++
> >  6 files changed, 45 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> > index 92780764d5fa..d2e098c3fd2c 100644
> > --- a/include/linux/io_uring_types.h
> > +++ b/include/linux/io_uring_types.h
> > @@ -465,6 +465,11 @@ struct io_ring_ctx {
> >         struct io_mapped_region         ring_region;
> >         /* used for optimised request parameter and wait argument passing  */
> >         struct io_mapped_region         param_region;
> > +
> > +#ifdef CONFIG_IO_URING_BPF
> > +       /* added to uring_bpf_ctx_list */
> > +       struct list_head                bpf_node;
> > +#endif
> >  };
> >
> >  /*
> > diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> > index b167c1d4ce6e..b8c49813b4e5 100644
> > --- a/include/uapi/linux/io_uring.h
> > +++ b/include/uapi/linux/io_uring.h
> > @@ -237,6 +237,11 @@ enum io_uring_sqe_flags_bit {
> >   */
> >  #define IORING_SETUP_SQE_MIXED         (1U << 19)
> >
> > +/*
> > + * Allow to submit bpf IO
> > + */
> > +#define IORING_SETUP_BPF               (1U << 20)
> 
> Is the setup flag really necessary? It doesn't look like there's much
> overhead to allowing BPF programs to be used on any io_ring_ctx, so I
> would be inclined to avoid needing to set an additional flag to use
> it.

It is used for dealing with unregistering & registering bpf prog vs. handling IO.



Thanks,
Ming


