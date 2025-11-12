Return-Path: <io-uring+bounces-10524-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD26AC5046A
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 03:00:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 971F33B387F
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 02:00:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E636C296BD4;
	Wed, 12 Nov 2025 01:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dDEMgj8B"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6CDC296BD7
	for <io-uring@vger.kernel.org>; Wed, 12 Nov 2025 01:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762912790; cv=none; b=c6B4JRBb0ZiUliEjulvzDUwB+icQLtdcn3at2m6JvQTRG3i0+8NRzIXYJbAX8stBfHH9Omw250XudkIjD8vJFGUf+yenUAsdrUHBQQdd6sWeE/GSN21WBD+H5HpyYWJSOixaaBJALf/3KuNvYKy2jS2B4kZKKIx4uFywdbmrwXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762912790; c=relaxed/simple;
	bh=Wfr3708VkOzQuU9pmmB7aToKJOPuRgH/eukxjbY9KU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dE06rrKsfFko/0vbDmjmbTVlmFCdHtJp9Tiesgc1sUlb5XyZGtJNDg4zQNwoWnxEWElvmmmbs/eI+sZEADurmzDE3I/X9/EWHk5B1TfixvTBbfzaVCIT/CdP0jeiZD1t9nX87RE4SxeDMJfs7Kea+P429nod69zEJbMazdpUDuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dDEMgj8B; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762912787;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wngBwJkqZcDDqt4ItO4kcRZbl92Nxn6rjpRy3iP5nl0=;
	b=dDEMgj8BcWzCgUBB5abIQHl10Pas6yrpF82tpOqJekbDX5wK4b9ZAxDeNZaNq/eAFMzF64
	gl7V4QzyJ7KZl2OIOB6Y++SL2xQa1F80gFg3lVOEkM3TIgqzcIKQDmU2qTpEN/M0NlWA+f
	l0InVqbDHnQgeDSOq9KiJ9bCsfAY3z0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-596-AcWe2vnTNfGQGEaV41nhWQ-1; Tue,
 11 Nov 2025 20:59:44 -0500
X-MC-Unique: AcWe2vnTNfGQGEaV41nhWQ-1
X-Mimecast-MFC-AGG-ID: AcWe2vnTNfGQGEaV41nhWQ_1762912782
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F243219560B2;
	Wed, 12 Nov 2025 01:59:41 +0000 (UTC)
Received: from fedora (unknown [10.72.116.179])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D790D18004D8;
	Wed, 12 Nov 2025 01:59:36 +0000 (UTC)
Date: Wed, 12 Nov 2025 09:59:31 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Keith Busch <kbusch@kernel.org>, Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] io_uring/rsrc: don't use blk_rq_nr_phys_segments() as
 number of bvecs
Message-ID: <aRPqA1XGWnY4YpIm@fedora>
References: <20251111191530.1268875-1-csander@purestorage.com>
 <aRPcdmpZoet2fwbu@fedora>
 <CADUfDZovn5fPh_E6GGvGkPYbW12L2z6BS4jPkpQjuEjNd=bRGA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZovn5fPh_E6GGvGkPYbW12L2z6BS4jPkpQjuEjNd=bRGA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Tue, Nov 11, 2025 at 05:44:18PM -0800, Caleb Sander Mateos wrote:
> On Tue, Nov 11, 2025 at 5:01 PM Ming Lei <ming.lei@redhat.com> wrote:
> >
> > On Tue, Nov 11, 2025 at 12:15:29PM -0700, Caleb Sander Mateos wrote:
> > > io_buffer_register_bvec() currently uses blk_rq_nr_phys_segments() as
> > > the number of bvecs in the request. However, bvecs may be split into
> > > multiple segments depending on the queue limits. Thus, the number of
> > > segments may overestimate the number of bvecs. For ublk devices, the
> > > only current users of io_buffer_register_bvec(), virt_boundary_mask,
> > > seg_boundary_mask, max_segments, and max_segment_size can all be set
> > > arbitrarily by the ublk server process.
> > > Set imu->nr_bvecs based on the number of bvecs the rq_for_each_bvec()
> > > loop actually yields. However, continue using blk_rq_nr_phys_segments()
> > > as an upper bound on the number of bvecs when allocating imu to avoid
> > > needing to iterate the bvecs a second time.
> > >
> > > Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> > > Fixes: 27cb27b6d5ea ("io_uring: add support for kernel registered bvecs")
> >
> > Reviewed-by: Ming Lei <ming.lei@redhat.com>
> >
> > BTW, this issue may not be a problem because ->nr_bvecs is only used in
> > iov_iter_bvec(), in which 'offset' and 'len' can control how far the
> > iterator can reach, so the uninitialized bvecs won't be touched basically.
> 
> I see your point, but what about iov_iter_extract_bvec_pages()? That
> looks like it only uses i->nr_segs to bound the iteration, not
> i->count. Hopefully there aren't any other helpers relying on nr_segs.

iov_iter_extract_bvec_pages() is only called from iov_iter_extract_pages(),
in which 'maxsize' is capped by i->count. 

> If you really don't think it's a problem, I'm fine deferring the patch
> to 6.19. We haven't encountered any problems caused by this bug, but
> we haven't tested with any non-default virt_boundary_mask,
> seg_boundary_mask, max_segments, or max_segment_size on the ublk
> device.

IMO it should belong to v6.18: your fix not only makes code more robust, but
also it is correct thing to do.

I am just thinking why the issue wasn't triggered because we have lots of
test cases(rw verify, mkfs & mount ...) 

> 
> >
> > Otherwise, the issue should have been triggered somewhere.
> >
> > Also the bvec allocation may be avoided in case of single-bio request,
> > which can be one future optimization.
> 
> I'm not sure what you're suggesting. The bio_vec array is a flexible
> array member of io_mapped_ubuf, so unless we add another pointer
> indirection, I don't see how to reuse the bio's bi_io_vec array.
> io_mapped_ubuf is also used for user registered buffers, where this
> optimization isn't possible, so it may not be a clear win.

io_mapped_ubuf->acct_pages can be one field reused for the indirect
pointer, please see lo_rw_aio() about how to reuse the bvec array.

Thanks,
Ming


