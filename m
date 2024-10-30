Return-Path: <io-uring+bounces-4184-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E2B8B9B5A32
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 04:08:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 525CAB22BB0
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 03:08:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 319074437;
	Wed, 30 Oct 2024 03:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RQIDAd10"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5624F4204F
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 03:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730257715; cv=none; b=BBoSBpcDDPR8y3xkA6AvrOs1jNXIPHMyqsi6FpIn126NksvejjTgjG6uxVufyw2rZydMCTMEcgUDUaungwm+u9BU77tc8wCDtFE94c7lrRObY4eZROx4RCxvPfDvE4zwOB+Ii4vAlMQy8MnX6KasmEdInrls8nSiIdKht6ArmN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730257715; c=relaxed/simple;
	bh=UkycRODotxZEcNkAU8JknJDQPDP8o7pTJtvemAw36fE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MbkE1ZNIXQKoieAe1S8zvhuiRJhBN04q2xajQOtma4iyCSl+Bs+nPb8ApSk3Z5ZJijs5H4FKCYf2ATLf8N42SCF50USMe/cxFqdI/AR3YxfeyTBBFiokgTIrcd4Z951E5dfLV4Gaog9AFY6c8BkfPnYHgDx0/S6EPdKjSJi+tXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RQIDAd10; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730257711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fbHuXlFlnl48M3O3jSnpkto2uwlwm2XUX+8EBx8eszo=;
	b=RQIDAd10RY4OugOzkHKowAMnC6KeYGL0bu0Rbu3gPoVohj+/qMNncQ2WWE0MGVYlmdN89j
	4ps2IWkLMjFEoy3oMAdjLiUEmCLgEAOCYVBkrbD6eGN0B9/ZXXWD5vA368VplPhg3CLmeO
	GGkuYoDxcnhfb5sL2n81aqq4hRstcGk=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-494-Kt-XLbwqPB2Z0xKMT4R5Qg-1; Tue,
 29 Oct 2024 23:08:27 -0400
X-MC-Unique: Kt-XLbwqPB2Z0xKMT4R5Qg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7144B19560A3;
	Wed, 30 Oct 2024 03:08:26 +0000 (UTC)
Received: from fedora (unknown [10.72.116.45])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1782A19560AA;
	Wed, 30 Oct 2024 03:08:21 +0000 (UTC)
Date: Wed, 30 Oct 2024 11:08:16 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Akilesh Kailash <akailash@google.com>
Subject: Re: [PATCH V8 0/8] io_uring: support sqe group and leased group kbuf
Message-ID: <ZyGjID-17REc9X3e@fedora>
References: <20241025122247.3709133-1-ming.lei@redhat.com>
 <15b9b1e0-d961-4174-96ed-5a6287e4b38b@gmail.com>
 <d859c85c-b7bf-4673-8c77-9d7113f19dbb@kernel.dk>
 <bc44d3c0-41e8-425c-957f-bad70aedcc50@kernel.dk>
 <e76d9742-5693-4057-b925-3917943c7441@kernel.dk>
 <f51e50c8-271e-49b6-b3e1-a63bf61d7451@kernel.dk>
 <ZyGT3h5jNsKB0mrZ@fedora>
 <674e8c3c-1f2c-464a-ad59-da3d00104383@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <674e8c3c-1f2c-464a-ad59-da3d00104383@kernel.dk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Tue, Oct 29, 2024 at 08:43:39PM -0600, Jens Axboe wrote:
> On 10/29/24 8:03 PM, Ming Lei wrote:
> > On Tue, Oct 29, 2024 at 03:26:37PM -0600, Jens Axboe wrote:
> >> On 10/29/24 2:06 PM, Jens Axboe wrote:
> >>> On 10/29/24 1:18 PM, Jens Axboe wrote:
> >>>> Now, this implementation requires a user buffer, and as far as I'm told,
> >>>> you currently have kernel buffers on the ublk side. There's absolutely
> >>>> no reason why kernel buffers cannot work, we'd most likely just need to
> >>>> add a IORING_RSRC_KBUFFER type to handle that. My question here is how
> >>>> hard is this requirement? Reason I ask is that it's much simpler to work
> >>>> with userspace buffers. Yes the current implementation maps them
> >>>> everytime, we could certainly change that, however I don't see this
> >>>> being an issue. It's really no different than O_DIRECT, and you only
> >>>> need to map them once for a read + whatever number of writes you'd need
> >>>> to do. If a 'tag' is provided for LOCAL_BUF, it'll post a CQE whenever
> >>>> that buffer is unmapped. This is a notification for the application that
> >>>> it's done using the buffer. For a pure kernel buffer, we'd either need
> >>>> to be able to reference it (so that we KNOW it's not going away) and/or
> >>>> have a callback associated with the buffer.
> >>>
> >>> Just to expand on this - if a kernel buffer is absolutely required, for
> >>> example if you're inheriting pages from the page cache or other
> >>> locations you cannot control, we would need to add something ala the
> >>> below:
> >>
> >> Here's a more complete one, but utterly untested. But it does the same
> >> thing, mapping a struct request, but it maps it to an io_rsrc_node which
> >> in turn has an io_mapped_ubuf in it. Both BUFFER and KBUFFER use the
> >> same type, only the destruction is different. Then the callback provided
> >> needs to do something ala:
> >>
> >> struct io_mapped_ubuf *imu = node->buf;
> >>
> >> if (imu && refcount_dec_and_test(&imu->refs))
> >> 	kvfree(imu);
> >>
> >> when it's done with the imu. Probably an rsrc helper should just be done
> >> for that, but those are details.
> >>
> >> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> >> index 9621ba533b35..050868a4c9f1 100644
> >> --- a/io_uring/rsrc.c
> >> +++ b/io_uring/rsrc.c
> >> @@ -8,6 +8,8 @@
> >>  #include <linux/nospec.h>
> >>  #include <linux/hugetlb.h>
> >>  #include <linux/compat.h>
> >> +#include <linux/bvec.h>
> >> +#include <linux/blk-mq.h>
> >>  #include <linux/io_uring.h>
> >>  
> >>  #include <uapi/linux/io_uring.h>
> >> @@ -474,6 +476,9 @@ void io_free_rsrc_node(struct io_rsrc_node *node)
> >>  		if (node->buf)
> >>  			io_buffer_unmap(node->ctx, node);
> >>  		break;
> >> +	case IORING_RSRC_KBUFFER:
> >> +		node->kbuf_fn(node);
> >> +		break;
> > 
> > Here 'node' is freed later, and it may not work because ->imu is bound
> > with node.
> 
> Not sure why this matters? imu can be bound to any node (and has a
> separate ref), but the node will remain for as long as the submission
> runs. It has to, because the last reference is put when submission of
> all requests in that series ends.

Fine, how is the imu found from OP? Not see related code to add the
allocated node into submission_state or ctx->buf_table.

io_rsrc_node_lookup() needs to find the buffer any way, right?

> 
> >> @@ -1070,6 +1075,65 @@ int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
> >>  	return ret;
> >>  }
> >>  
> >> +struct io_rsrc_node *io_rsrc_map_request(struct io_ring_ctx *ctx,
> >> +					 struct request *req,
> >> +					 void (*kbuf_fn)(struct io_rsrc_node *))
> >> +{
> >> +	struct io_mapped_ubuf *imu = NULL;
> >> +	struct io_rsrc_node *node = NULL;
> >> +	struct req_iterator rq_iter;
> >> +	unsigned int offset;
> >> +	struct bio_vec bv;
> >> +	int nr_bvecs;
> >> +
> >> +	if (!bio_has_data(req->bio))
> >> +		goto out;
> >> +
> >> +	nr_bvecs = 0;
> >> +	rq_for_each_bvec(bv, req, rq_iter)
> >> +		nr_bvecs++;
> >> +	if (!nr_bvecs)
> >> +		goto out;
> >> +
> >> +	node = io_rsrc_node_alloc(ctx, IORING_RSRC_KBUFFER);
> >> +	if (!node)
> >> +		goto out;
> >> +	node->buf = NULL;
> >> +
> >> +	imu = kvmalloc(struct_size(imu, bvec, nr_bvecs), GFP_NOIO);
> >> +	if (!imu)
> >> +		goto out;
> >> +
> >> +	imu->ubuf = 0;
> >> +	imu->len = 0;
> >> +	if (req->bio != req->biotail) {
> >> +		int idx = 0;
> >> +
> >> +		offset = 0;
> >> +		rq_for_each_bvec(bv, req, rq_iter) {
> >> +			imu->bvec[idx++] = bv;
> >> +			imu->len += bv.bv_len;
> >> +		}
> >> +	} else {
> >> +		struct bio *bio = req->bio;
> >> +
> >> +		offset = bio->bi_iter.bi_bvec_done;
> >> +		imu->bvec[0] = *__bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
> >> +		imu->len = imu->bvec[0].bv_len;
> >> +	}
> >> +	imu->nr_bvecs = nr_bvecs;
> >> +	imu->folio_shift = PAGE_SHIFT;
> >> +	refcount_set(&imu->refs, 1);
> > 
> > One big problem is how to initialize the reference count, because this
> > buffer need to be used in the following more than one request. Without
> > one perfect counter, the buffer won't be freed in the exact time without
> > extra OP.
> 
> Each request that uses the node, will grab a reference to the node. The
> node holds a reference to the buffer. So at least as the above works,
> the buf will be put when submission ends, as that puts the node and
> subsequently the one reference the imu has by default. It'll outlast any
> of the requests that use it during submission, and there cannot be any
> other users of it as it isn't discoverable outside of that.

OK, if the node/buffer is only looked up in ->prep(), this way works.

> 
> > I think the reference should be in `node` which need to be live if any
> > consumer OP isn't completed.
> 
> That is how it works... io_req_assign_rsrc_node() will assign a node to
> a request, which will be there until the request completes.
> 
> >> +	node->buf = imu;
> >> +	node->kbuf_fn = kbuf_fn;
> >> +	return node;
> > 
> > Also this function needs to register the buffer to table with one
> > pre-defined buf index, then the following request can use it by
> > the way of io_prep_rw_fixed().
> 
> It should not register it with the table, the whole point is to keep
> this node only per-submission discoverable. If you're grabbing random
> request pages, then it very much is a bit finicky and needs to be of
> limited scope.

There can be more than 1 buffer uses in single submission, can you share
how OP finds the specific buffer with ->buf_index from submission state?
This part is missed in your patch.

> 
> Each request type would need to support it. For normal read/write, I'd
> suggest just adding IORING_OP_READ_LOCAL and WRITE_LOCAL to do that.
> 
> > If OP dependency can be avoided, I think this approach is fine,
> > otherwise I still suggest sqe group. Not only performance, but
> > application becomes too complicated.
> 
> You could avoid the OP dependency with just a flag, if you really wanted
> to. But I'm not sure it makes a lot of sense. And it's a hell of a lot

Yes, IO_LINK won't work for submitting multiple IOs concurrently, extra
syscall makes application too complicated, and IO latency is increased.

> simpler than the sqe group scheme, which I'm a bit worried about as it's
> a bit complicated in how deep it needs to go in the code. This one
> stands alone, so I'd strongly encourage we pursue this a bit further and
> iron out the kinks. Maybe it won't work in the end, I don't know, but it
> seems pretty promising and it's soooo much simpler.

If buffer register and lookup are always done in ->prep(), OP dependency
may be avoided.

> 
> > We also we need to provide ->prep() callback for uring_cmd driver, so
> > that io_rsrc_map_request() can be called by driver in ->prep(),
> > meantime `io_ring_ctx` and `io_rsrc_node` need to be visible for driver.
> > What do you think of these kind of changes?
> 
> io_ring_ctx is already visible in the normal system headers,
> io_rsrc_node we certainly could make visible. That's not a big deal. It
> makes a lot more sense to export than some of the other stuff we have in
> there! As long as it's all nicely handled by helpers, then we'd be fine.

OK.


thanks,
Ming


