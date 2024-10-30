Return-Path: <io-uring+bounces-4180-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B79059B59B9
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 03:03:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E28B21C22481
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 02:03:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BA6814E2E2;
	Wed, 30 Oct 2024 02:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gTtN0f+X"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC16733CFC
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 02:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730253811; cv=none; b=S0gwl99pb1pC4fQ4u3ClEYur37RuYOtfWPZkA0t+vinZRxWcZb4woqmojh6UeKTeZyB6iZ9VM1aODIDr2ZbheayPN2WhcDBUi+DFTHHiAa2WgeyH1dmcwEj7HgEJlUCMBLRX5F1LRPcV690qwZe1c1TvEgdx0PpJ3kG7zk3NhPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730253811; c=relaxed/simple;
	bh=LU1WE0bQtdB1RPf/2yVDnHWzxB3haG8OLEiQV7bYcsk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OB391EY2LdHBf2xlZFg7EVrMJEaz21gnfVwiDzGAkrkU2pJPRroGUXaiQlg0O7mr3BUDH3kN8r3K/ST2ix330pHwMf0TKw7fRWiPwuLXWjSTYLkfgVeTVRF9/gxCdPdCLvzVjk9SeLEC3t7GrcHjOTgOskh8zyUsPfIMaNJPJCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gTtN0f+X; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730253806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Sx7Y3kuzS6Yv4+4Wap4ntFPjaeMUnRc7s/tK0L5UIy0=;
	b=gTtN0f+XD1t26bCdfTaXzHp3dIY2aSszoMwmg/zYnXD96DPUWYvRodSKyEabQCyXkuc6Id
	9gWAQMXTHemP4mTvJcmGiTZmjPBLkcGXmQKA0aXX/PtkqDYta4eAXu+gnTgA69U7wY5K14
	I3IbncLxkHFIz//gkYRArzg7me8sRHU=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-612-XfoAEF_KOYyxmz6XJwo0IA-1; Tue,
 29 Oct 2024 22:03:23 -0400
X-MC-Unique: XfoAEF_KOYyxmz6XJwo0IA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3AD4B195608A;
	Wed, 30 Oct 2024 02:03:22 +0000 (UTC)
Received: from fedora (unknown [10.72.116.45])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5363019560A3;
	Wed, 30 Oct 2024 02:03:16 +0000 (UTC)
Date: Wed, 30 Oct 2024 10:03:10 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Akilesh Kailash <akailash@google.com>, ming.lei@redhat.com
Subject: Re: [PATCH V8 0/8] io_uring: support sqe group and leased group kbuf
Message-ID: <ZyGT3h5jNsKB0mrZ@fedora>
References: <20241025122247.3709133-1-ming.lei@redhat.com>
 <15b9b1e0-d961-4174-96ed-5a6287e4b38b@gmail.com>
 <d859c85c-b7bf-4673-8c77-9d7113f19dbb@kernel.dk>
 <bc44d3c0-41e8-425c-957f-bad70aedcc50@kernel.dk>
 <e76d9742-5693-4057-b925-3917943c7441@kernel.dk>
 <f51e50c8-271e-49b6-b3e1-a63bf61d7451@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f51e50c8-271e-49b6-b3e1-a63bf61d7451@kernel.dk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Tue, Oct 29, 2024 at 03:26:37PM -0600, Jens Axboe wrote:
> On 10/29/24 2:06 PM, Jens Axboe wrote:
> > On 10/29/24 1:18 PM, Jens Axboe wrote:
> >> Now, this implementation requires a user buffer, and as far as I'm told,
> >> you currently have kernel buffers on the ublk side. There's absolutely
> >> no reason why kernel buffers cannot work, we'd most likely just need to
> >> add a IORING_RSRC_KBUFFER type to handle that. My question here is how
> >> hard is this requirement? Reason I ask is that it's much simpler to work
> >> with userspace buffers. Yes the current implementation maps them
> >> everytime, we could certainly change that, however I don't see this
> >> being an issue. It's really no different than O_DIRECT, and you only
> >> need to map them once for a read + whatever number of writes you'd need
> >> to do. If a 'tag' is provided for LOCAL_BUF, it'll post a CQE whenever
> >> that buffer is unmapped. This is a notification for the application that
> >> it's done using the buffer. For a pure kernel buffer, we'd either need
> >> to be able to reference it (so that we KNOW it's not going away) and/or
> >> have a callback associated with the buffer.
> > 
> > Just to expand on this - if a kernel buffer is absolutely required, for
> > example if you're inheriting pages from the page cache or other
> > locations you cannot control, we would need to add something ala the
> > below:
> 
> Here's a more complete one, but utterly untested. But it does the same
> thing, mapping a struct request, but it maps it to an io_rsrc_node which
> in turn has an io_mapped_ubuf in it. Both BUFFER and KBUFFER use the
> same type, only the destruction is different. Then the callback provided
> needs to do something ala:
> 
> struct io_mapped_ubuf *imu = node->buf;
> 
> if (imu && refcount_dec_and_test(&imu->refs))
> 	kvfree(imu);
> 
> when it's done with the imu. Probably an rsrc helper should just be done
> for that, but those are details.
> 
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 9621ba533b35..050868a4c9f1 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -8,6 +8,8 @@
>  #include <linux/nospec.h>
>  #include <linux/hugetlb.h>
>  #include <linux/compat.h>
> +#include <linux/bvec.h>
> +#include <linux/blk-mq.h>
>  #include <linux/io_uring.h>
>  
>  #include <uapi/linux/io_uring.h>
> @@ -474,6 +476,9 @@ void io_free_rsrc_node(struct io_rsrc_node *node)
>  		if (node->buf)
>  			io_buffer_unmap(node->ctx, node);
>  		break;
> +	case IORING_RSRC_KBUFFER:
> +		node->kbuf_fn(node);
> +		break;

Here 'node' is freed later, and it may not work because ->imu is bound
with node.

>  	default:
>  		WARN_ON_ONCE(1);
>  		break;
> @@ -1070,6 +1075,65 @@ int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
>  	return ret;
>  }
>  
> +struct io_rsrc_node *io_rsrc_map_request(struct io_ring_ctx *ctx,
> +					 struct request *req,
> +					 void (*kbuf_fn)(struct io_rsrc_node *))
> +{
> +	struct io_mapped_ubuf *imu = NULL;
> +	struct io_rsrc_node *node = NULL;
> +	struct req_iterator rq_iter;
> +	unsigned int offset;
> +	struct bio_vec bv;
> +	int nr_bvecs;
> +
> +	if (!bio_has_data(req->bio))
> +		goto out;
> +
> +	nr_bvecs = 0;
> +	rq_for_each_bvec(bv, req, rq_iter)
> +		nr_bvecs++;
> +	if (!nr_bvecs)
> +		goto out;
> +
> +	node = io_rsrc_node_alloc(ctx, IORING_RSRC_KBUFFER);
> +	if (!node)
> +		goto out;
> +	node->buf = NULL;
> +
> +	imu = kvmalloc(struct_size(imu, bvec, nr_bvecs), GFP_NOIO);
> +	if (!imu)
> +		goto out;
> +
> +	imu->ubuf = 0;
> +	imu->len = 0;
> +	if (req->bio != req->biotail) {
> +		int idx = 0;
> +
> +		offset = 0;
> +		rq_for_each_bvec(bv, req, rq_iter) {
> +			imu->bvec[idx++] = bv;
> +			imu->len += bv.bv_len;
> +		}
> +	} else {
> +		struct bio *bio = req->bio;
> +
> +		offset = bio->bi_iter.bi_bvec_done;
> +		imu->bvec[0] = *__bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
> +		imu->len = imu->bvec[0].bv_len;
> +	}
> +	imu->nr_bvecs = nr_bvecs;
> +	imu->folio_shift = PAGE_SHIFT;
> +	refcount_set(&imu->refs, 1);

One big problem is how to initialize the reference count, because this
buffer need to be used in the following more than one request. Without
one perfect counter, the buffer won't be freed in the exact time without
extra OP.

I think the reference should be in `node` which need to be live if any
consumer OP isn't completed.

> +	node->buf = imu;
> +	node->kbuf_fn = kbuf_fn;
> +	return node;

Also this function needs to register the buffer to table with one
pre-defined buf index, then the following request can use it by
the way of io_prep_rw_fixed().

If OP dependency can be avoided, I think this approach is fine,
otherwise I still suggest sqe group. Not only performance, but
application becomes too complicated.

We also we need to provide ->prep() callback for uring_cmd driver, so
that io_rsrc_map_request() can be called by driver in ->prep(),
meantime `io_ring_ctx` and `io_rsrc_node` need to be visible for driver.
What do you think of these kind of changes?


thanks, 
Ming


