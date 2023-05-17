Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B01E705E8E
	for <lists+io-uring@lfdr.de>; Wed, 17 May 2023 06:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbjEQEGr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 May 2023 00:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjEQEGp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 May 2023 00:06:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE92A3A8B
        for <io-uring@vger.kernel.org>; Tue, 16 May 2023 21:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684296359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cEGDo2RyYOMpb25+HTYApsHqFuz7L6PMY5EU7kcMr64=;
        b=STKPOPfIaks7HURZ1ca/XAsX1JGrIXtn2fDrBIm9xDYalIKerQnbofo+3lc70VA0R06pU/
        bbP54ikprhrJZi4v22nG3fG+AbtNF3ZiHC1sgydxPx+ur4GVfxIaWAqgj7Gfknn+Rl8igz
        RUdwoYbG5qRJIYbOSI8c3DaLC54vcxI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-197-hroTBhGPM9KQ8us3I39qKQ-1; Wed, 17 May 2023 00:05:51 -0400
X-MC-Unique: hroTBhGPM9KQ8us3I39qKQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 28667101A54F;
        Wed, 17 May 2023 04:05:51 +0000 (UTC)
Received: from ovpn-8-19.pek2.redhat.com (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1CE39C16024;
        Wed, 17 May 2023 04:05:47 +0000 (UTC)
Date:   Wed, 17 May 2023 12:05:43 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, ming.lei@redhat.com
Subject: Re: [RFC 7/7] io_uring,fs: introduce IORING_OP_GET_BUF
Message-ID: <ZGRSl3ePGP/49kFg@ovpn-8-19.pek2.redhat.com>
References: <cover.1682701588.git.asml.silence@gmail.com>
 <fc43826d510dc75de83d81161ca03e2688515686.1682701588.git.asml.silence@gmail.com>
 <ZFEk2rQv2//KRBeK@ovpn-8-16.pek2.redhat.com>
 <4527d9f3-d7d5-908e-bf34-5c2a4e4e9609@gmail.com>
 <ZFMTJX2H5ByOygzw@ovpn-8-16.pek2.redhat.com>
 <a63fea56-6b56-e043-f746-597963312205@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a63fea56-6b56-e043-f746-597963312205@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, May 08, 2023 at 03:30:55AM +0100, Pavel Begunkov wrote:
> On 5/4/23 03:06, Ming Lei wrote:
> > On Wed, May 03, 2023 at 03:54:02PM +0100, Pavel Begunkov wrote:
> > > On 5/2/23 15:57, Ming Lei wrote:
> > > > On Sun, Apr 30, 2023 at 10:35:29AM +0100, Pavel Begunkov wrote:
> > > > > There are several problems with splice requests, aka IORING_OP_SPLICE:
> > > > > 1) They are always executed by a worker thread, which is a slow path,
> > > > >      as we don't have any reliable way to execute it NOWAIT.
> > > > > 2) It can't easily poll for data, as there are 2 files it operates on.
> > > > >      It would either need to track what file to poll or poll both of them,
> > > > >      in both cases it'll be a mess and add lot of overhead.
> > > > > 3) It has to have pipes in the middle, which adds overhead and is not
> > > > >      great from the uapi design perspective when it goes for io_uring
> > > > >      requests.
> > > > > 4) We want to operate with spliced data as with a normal buffer, i.e.
> > > > >      write / send / etc. data as normally while it's zerocopy.
> > > > > 
> > > > > It can partially be solved, but the root cause is a suboptimal for
> > > > > io_uring design of IORING_OP_SPLICE. Introduce a new request type
> > > > > called IORING_OP_GET_BUF, inspired by splice(2) as well as other
> > > > > proposals like fused requests. The main idea is to use io_uring's
> > > > > registered buffers as the middle man instead of pipes. Once a buffer
> > > > > is fetched / spliced from a file using a new fops callback
> > > > > ->iou_get_buf, it's installed as a registered buffers and can be used
> > > > > by all operations supporting the feature.
> > > > > 
> > > > > Once the userspace releases the buffer, io_uring will wait for all
> > > > > requests using the buffer to complete and then use a file provided
> > > > > callback ->release() to return the buffer back. It operates on the
> > > > 
> > > > In the commit of "io_uring: add an example for buf-get op", I don't see
> > > > any code to release the buffer, can you explain it in details about how
> > > > to release the buffer in userspace? And add it in your example?
> > > 
> > > Sure, we need to add buf updates via request.
> > 
> > I guess it can't be buf update, here we need to release buf. At least
> > ublk needs to release the buffer explicitly after all consumers are done
> > with the buffer registered by IORING_OP_GET_BUF, when there may not be
> > any new buffer to be provided, and the buffer is per-IO for each io
> > request from /dev/ublkbN.
> 
> By "updates" I usually mean removals as well, just like
> IORING_REGISTER_BUFFERS_UPDATE with iov_base == 0 would remove
> the buffer.

OK.

> 
> 
> > > Particularly, in this RFC, the removal from the table was happening
> > > in io_install_buffer() by one of the test-only patches, the "remove
> > > previous entry on update" style as it's with files. Then it's
> > > released with the last ref put, either on removal with a request
> > > like:

This way can't work for ublk, we definitely need to release the buffer immediately
after it is consumed, otherwise the ublk block request won't be completed.

> > > 
> > > io_free_batch_list()
> > >       io_req_put_rsrc_locked()
> > >           ...
> > > 
> > > > Here I guess the ->release() is called in the following code path:
> > > > 
> > > > io_buffer_unmap
> > > >       io_rsrc_buf_put
> > > >           io_rsrc_put_work
> > > >               io_rsrc_node_ref_zero
> > > >                   io_put_rsrc_node
> > > > 
> > > > If it is true, what is counter-pair code for io_put_rsrc_node()?
> > > > So far, only see io_req_set_rsrc_node() is called from
> > > > io_file_get_fixed(), is it needed for consumer OP of the buffer?
> > > > 
> > > > Also io_buffer_unmap() is called after io_rsrc_node's reference drops
> > > > to zero, which means ->release() isn't called after all its consumer(s)
> > > > are done given io_rsrc_node is shared by in-flight requests. If it is
> > > > true, this way will increase buffer lifetime a lot.
> > > 
> > > That's true. It's not a new downside, so might make more sense
> > > to do counting per rsrc (file, buffer), which is not so bad for
> > > now, but would be a bit concerning if we grow the number of rsrc
> > > types.
> > 
> > It may not be one deal for current fixed file user, which isn't usually
> > updated in fast path.
> 
> With opening/accepting right into io_uring skipping normal file
> tables and cases like open->read->close, it's rather somewhat of
> medium hotness, definitely not a slow path. And the problem affects
> it as well

OK, then it becomes more rationale to remove the delayed release by
using io_rsrc_node, I am wondering why not add reference counter
to the buffer which needs to be used in such fast path?

> > But IORING_OP_GET_BUF is supposed to be for fast path, this delay
> > release is really one problem. Cause if there is any new buffer provided &
> > consumed, old buffer can't be released any more. And this way can't
> > be used in ublk zero copy, let me share the ublk model a bit:
> > 
> > 1) one batch ublk blk io requests(/dev/ublkbN) are coming, and batch size is
> > often QD of workload on /dev/ublkbN, and batch size could be 1 or more.
> > 
> > 2) ublk driver notifies the blk io requests via io_uring command
> > completion
> > 
> > 3) ublk server starts to handle this batch of io requests, by calling
> > IORING_OP_GET_BUF on /dev/ublkcN & normal OPs(rw, net recv/send, ...)
> > for each request in this batch
> > 
> > 4) new batch of ublk blk io requests can come when handling the previous
> > batch of io requests, then the old buffer release is delayed until new
> > batch of ublk io requests are completed.
> > 
> > > 
> > > > ublk zero copy needs to call ->release() immediately after all
> > > > consumers are done, because the ublk disk request won't be completed
> > > > until the buffer is released(the buffer actually belongs to ublk block request).
> > > > 
> > > > Also the usage in liburing example needs two extra syscall(io_uring_enter) for
> > > > handling one IO, not take into account the "release OP". IMO, this way makes
> > > 
> > > Something is amiss here. It's 3 requests, which means 3 syscalls
> > > if you send requests separately (each step can be batch more
> > > requests), or 1 syscall if you link them together. There is an
> > > example using links for 2 requests in the test case.
> > 
> > See the final comment about link support.
> > 
> > > 
> > > > application more complicated, also might perform worse:
> > > > 
> > > > 1) for ublk zero copy, the original IO just needs one OP, but now it
> > > > takes three OPs, so application has to take coroutine for applying
> > > 
> > > Perhaps, you mean two requests for fused, IORING_OP_FUSED_CMD + IO
> > > request, vs three for IORING_OP_GET_BUF. There might be some sort of
> > > auto-remove on use, making it two requests, but that seems a bit ugly.
> > 
> > The most important part is that IORING_OP_GET_BUF adds two extra wait:
> > 
> > 1) one io_uring_enter() is required after submitting IORING_OP_GET_BUF
> > 
> > 2) another io_uring_enter() is needed after submitting buffer consumer
> > OPs, before calling buffer release OP(not added yet in your patchset)
> > 
> > The two waits not only causes application more complicated, but also
> > hurts performance, cause IOs/syscall is reduced. People loves io_uring
> > because it is really async io model, such as, all kinds of IO can be
> > submitted in single context, and wait in single io_uring_enter().
> 
> *Pseudo code*
> N = get_free_buffer_slot();
> sqe1 = prep_getbuf_sqe(buf_idx = N);
> sqe1->flags |= F_LINK;
> 
> sqe2 = prep_write_sqe(buf_idx = N);
> sqe2->flags |= F_LINK;
> 
> sqe3 = prep_release_buf_sqe(buf_idx = N);
> sqe3->flags |= F_LINK;

The above link shouldn't be needed.

> 
> submit_and_wait(nr_wait=3);
> 
> 
> That should work, there is only 1 syscall. We can also
> play with SKIP_CQE_SUCCESS and/or HARDLINK to fold 3 cqes
> into 1.

Yeah, this way does simplify application and is more efficient since more
OPs can be issued via single syscall, but another problem is raised, if
there are multiple prep_write_sqe() in this chain and all consume this same
buffer, all WRITEs have to be issued after the previous one is completed,
this way is slow, and no such problem in fused command.

> 
> > > > 3 stages batch submission(GET_BUF, IO, release buffer) since IO_LINK can't
> > > > or not suggested to be used. In case of low QD, batch size is reduced much,
> > > > and performance may hurt because IOs/syscall is 1/3 of fused command.
> > > 
> > > I'm not a big fan of links for their inflexibility, but it can be
> > > used. The point is rather it's better not to be the only way to
> > > use the feature as we may need to stop in the middle, return
> > 
> > LINK always support to stop in the middle, right?
> 
> Normal links will stop execution on "error", which is usually
> cqe->res < 0, but read/write will also break the link on short
> IO, and the short IO behaviour of send/recv will depend on
> MSG_WAITALL. IOSQE_IO_HARDLINK will continue executing linked
> requests even with prior errors.

I think ublk server is fine with current handling of link break.

> 
> > > control to the userspace and let it handle errors, do data processing
> > > and so on. The latter may need a partial memcpy() into the userspace,
> > > e.g. copy a handful bytes of headers to decide what to do with the
> > > rest of data.
> > 
> > At least this patchset doesn't work with IO_LINK, please see my previous
> > reply because the current rw/net zc retrieves fixed buffer in ->prep().
> > 
> > Yeah, the problem can be addressed by moving the buffer retrieving into
> > ->issue().
> 
> Right, one of the test patches does exactly that (fwiw, not tested
> seriously), and as it was previously done for files. It won't be
> a big problem.

OK, looks you must forget to include the patch in this series.

> 
> > But my concern is more about easy use and performance:
> > 
> > 1) with io_link, the extra two waits(after IORING_OP_GET_BUF and before IORING_OP_GET_BUF)
> > required can be saved, then application doesn't need coroutine or
> > similar trick for avoiding the extra wait handling.
> 
> It shouldn't need that, see above.
> 
> > 2) but if three OPs uses the buffer registered by IORING_OP_GET_BUF, the three
> > OPs have to be linked one by one, then all three have to be be submitted one
> > after the previous one is completed, performance is hurt a lot.
> 
> In general, it sounds like a generic feature and should be as such.
> But
> 
> I agree with the sentiment, that's exactly why I was saying that
> they're not perfectly flexible and don't cover all the cases, but
> the same can be said for the 1->N kinds of dependency. And even
> with a completely configurable graphs of requests there will be
> questions like "how to take result from one request and give it
> to another with a random meaning, i.e. as a buffer/fd/size/
> index/whatnot", and there are more complicated examples.
> 
> I don't see any good scalable way for that without programmability.
> It appeared before that it was faster to return back to the userspace
> than using BPF, might be worth to test it again, especially with
> DEFER_TASKRUN and recent optimisations.

I don't think result from one request need to be retrieved for the
following request, such as by taking your previous code:

	*Pseudo code*
	N = get_free_buffer_slot();
	sqe1 = prep_getbuf_sqe(buf_idx = N);
	sqe1->flags |= F_LINK;
	
	sqe2 = prep_write_sqe(buf_idx = N);
	sqe2->flags |= F_LINK;

	sqe3= prep_write_sqe(buf_idx = N);
	sqe3->flags |= F_LINK;
	
	sqe4 = prep_release_buf_sqe(buf_idx = N);
	sqe4->flags |= F_LINK;

After sqe1 is done, we just need to support to submit sqe2/sqe3/sqe4
concurrently, however prep_release_buf_sqe need to support async buf
release.

> 
> 
> > > I deem fused cmds to be a variant of linking, so it's rather with
> > > it you link 2 requests vs optionally linking 3 with this patchset.
> > 
> > IMO, one extra 64byte touching may slow things a little, but I think it
> 
> Fwiw, the overhead comes from all io_uring hops a request goes
> through, e.g. init, ->prep, ->issue, free, etc. I'd love to
> see it getting even slimmer, and there are definitely spots
> that can be optimised.
> 
> > won't be big deal, what really matters is that easy use of the interface
> > and performance.
> 
> Which should also be balanced with flexibility and not only.

That is why I prefer to fused command which can solve the problem in
one easy way without big core code change(include interface), then generic
core code still can keep its flexibility.

thanks,
Ming

