Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C84A6D30F3
	for <lists+io-uring@lfdr.de>; Sat,  1 Apr 2023 15:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjDANUR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 1 Apr 2023 09:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjDANUR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 1 Apr 2023 09:20:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD201DFB1
        for <io-uring@vger.kernel.org>; Sat,  1 Apr 2023 06:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680355168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=55c8Ywmc7577GsWNsJB5Esm9IzYPPCfFBU2vYViyiwQ=;
        b=YShxHppeKjvaByNFOjRaZ3JVHxa/qvaoZpiEP+sfURBzmCzyRiF0F67EuYH3J5xh+znowA
        27f+B/tBBQxs44UhW0RHdX8YbuiwzcB4NDm+lg/uvbpCMdnHrQIqezAEO9QKiRWu2B0JVF
        ifHloaYwDinz4kc1FkQDeywjn194rAo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-GrpuRTF2MhqPklnttPGbCg-1; Sat, 01 Apr 2023 09:19:25 -0400
X-MC-Unique: GrpuRTF2MhqPklnttPGbCg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0BED93802128;
        Sat,  1 Apr 2023 13:19:25 +0000 (UTC)
Received: from ovpn-8-18.pek2.redhat.com (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E6F9C15BA0;
        Sat,  1 Apr 2023 13:19:16 +0000 (UTC)
Date:   Sat, 1 Apr 2023 21:19:11 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bernd Schubert <bschubert@ddn.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH V6 17/17] block: ublk_drv: apply io_uring FUSED_CMD for
 supporting zero copy
Message-ID: <ZCgvT5sHax67zlZu@ovpn-8-18.pek2.redhat.com>
References: <20230330113630.1388860-1-ming.lei@redhat.com>
 <20230330113630.1388860-18-ming.lei@redhat.com>
 <bffb98ef-ff50-92f5-7854-7a5245b9ab63@ddn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bffb98ef-ff50-92f5-7854-7a5245b9ab63@ddn.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Mar 31, 2023 at 07:13:21PM +0000, Bernd Schubert wrote:
> On 3/30/23 13:36, Ming Lei wrote:
> > Apply io_uring fused command for supporting zero copy:
> > 
> > 1) init the fused cmd buffer(io_mapped_buf) in ublk_map_io(), and deinit it
> > in ublk_unmap_io(), and this buffer is immutable, so it is just fine to
> > retrieve it from concurrent fused command.
> > 
> > 1) add sub-command opcode of UBLK_IO_FUSED_SUBMIT_IO for retrieving this
> > fused cmd(zero copy) buffer
> > 
> > 2) call io_fused_cmd_start_secondary_req() to provide buffer to secondary
> > request and submit secondary request; meantime setup complete callback via
> > this API, once secondary request is completed, the complete callback is
> > called for freeing the buffer and completing the fused command
> > 
> > Also request reference is held during fused command lifetime, and this way
> > guarantees that request buffer won't be freed until all inflight fused
> > commands are completed.
> > 
> > userspace(only implement sqe128 fused command):
> > 
> > 	https://github.com/ming1/ubdsrv/tree/fused-cmd-zc-for-v6
> > 
> > liburing test(only implement normal sqe fused command: two 64byte SQEs)
> > 
> > 	https://github.com/ming1/liburing/tree/fused_cmd_miniublk_for_v6
> > 
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >   Documentation/block/ublk.rst  | 126 ++++++++++++++++++++--
> >   drivers/block/ublk_drv.c      | 192 ++++++++++++++++++++++++++++++++--
> >   include/uapi/linux/ublk_cmd.h |   6 +-
> >   3 files changed, 303 insertions(+), 21 deletions(-)
> > 
> > diff --git a/Documentation/block/ublk.rst b/Documentation/block/ublk.rst
> > index 1713b2890abb..7b7aa24e9729 100644
> > --- a/Documentation/block/ublk.rst
> > +++ b/Documentation/block/ublk.rst
> > @@ -297,18 +297,126 @@ with specified IO tag in the command data:
> >     ``UBLK_IO_COMMIT_AND_FETCH_REQ`` to the server, ublkdrv needs to copy
> >     the server buffer (pages) read to the IO request pages.
> >   
> > -Future development
> > -==================
> > +- ``UBLK_IO_FUSED_SUBMIT_IO``
> > +
> > +  Used for implementing zero copy feature.
> > +
> > +  It has to been the primary command of io_uring fused command. This command
> 
> s/been/be/ ?

Yeah.

> 
> > +  submits the generic secondary IO request with io buffer provided by our primary
> > +  command, and won't be completed until the secondary request is done.
> > +
> > +  The provided buffer is represented as ``io_uring_bvec_buf``, which is
> > +  actually ublk request buffer's reference, and the reference is shared &
> > +  read-only, so the generic secondary request can retrieve any part of the buffer
> > +  by passing buffer offset & length.
> >   
> >   Zero copy
> > ----------
> > +=========
> > +
> > +What is zero copy?
> > +------------------
> > +
> > +When application submits IO to ``/dev/ublkb*``, userspace buffer(direct io)
> > +or page cache buffer(buffered io) or kernel buffer(meta io often) is used
> > +for submitting data to ublk driver, and all kinds of these buffers are
> > +represented by bio/bvecs(ublk request buffer) finally. Before supporting
> > +zero copy, data in these buffers has to be copied to ublk server userspace
> > +buffer before handling WRITE IO, or after handing READ IO, so that ublk
> > +server can handle IO for ``/dev/ublkb*`` with the copied data.
> > +
> > +The extra copy between ublk request buffer and ublk server userspace buffer
> > +not only increases CPU utilization(such as pinning pages, copy data), but
> > +also consumes memory bandwidth, and the cost could be very big when IO size
> > +is big. It is observed that ublk-null IOPS may be increased to ~5X if the
> > +extra copy can be avoided.
> > +
> > +So zero copy is very important for supporting high performance block device
> > +in userspace.
> > +
> > +Technical requirements
> > +----------------------
> > +
> > +- ublk request buffer use
> > +
> > +ublk request buffer is represented by bio/bvec, which is immutable, so do
> > +not try to change bvec via buffer reference; data can be read from or
> > +written to the buffer according to buffer direction, but bvec can't be
> > +changed
> > +
> > +- buffer lifetime
> > +
> > +Ublk server borrows ublk request buffer for handling ublk IO, ublk request
> > +buffer reference is used. Reference can't outlive the referent buffer. That
> > +means all request buffer references have to be released by ublk server
> > +before ublk driver completes this request, when request buffer ownership
> > +is transferred to upper layer(FS, application, ...).
> > +
> > +Also after ublk request is completed, any page belonging to this ublk
> > +request can not be written or read any more from ublk server since it is
> > +one block device from kernel viewpoint.
> > +
> > +- buffer direction
> > +
> > +For ublk WRITE request, ublk request buffer should only be accessed as data
> > +source, and the buffer can't be written by ublk server
> > +
> > +For ublk READ request, ublk request buffer should only be accessed as data
> > +destination, and the buffer can't be read by ublk server, otherwise kernel
> > +data is leaked to ublk server, which can be unprivileged application.
> > +
> > +- arbitrary size sub-buffer needs to be retrieved from ublk server
> > +
> > +ublk is one generic framework for implementing block device in userspace,
> > +and typical requirements include logical volume manager(mirror, stripped, ...),
> > +distributed network storage, compressed target, ...
> > +
> > +ublk server needs to retrieve arbitrary size sub-buffer of ublk request, and
> > +ublk server needs to submit IOs with these sub-buffer(s). That also means
> > +arbitrary size sub-buffer(s) can be used to submit IO multiple times.
> > +
> > +Any sub-buffer is actually one reference of ublk request buffer, which
> > +ownership can't be transferred to upper layer if any reference is held
> > +by ublk server.
> > +
> > +Why slice isn't good for ublk zero copy
> 
> slice

Good catch.

> 
> > +---------------------------------------
> > +
> > +- spliced page from ->splice_read() can't be written
> > +
> > +ublk READ request can't be handled because spliced page can't be written to, and
> > +extending splice for ublk zero copy isn't one good solution [#splice_extend]_
> > +
> > +- it is very hard to meet above requirements  wrt. request buffer lifetime
> > +
> > +splice/pipe focuses on page reference lifetime, but ublk zero copy pays more
> > +attention to ublk request buffer lifetime. If is very inefficient to respect
> > +request buffer lifetime by using all pipe buffer's ->release() which requires
> > +all pipe buffers and pipe to be kept when ublk server handles IO. That means
> > +one single dedicated ``pipe_inode_info`` has to be allocated runtime for each
> > +provided buffer, and the pipe needs to be populated with pages in ublk request
> > +buffer.
> > +
> > +
> > +io_uring fused command based zero copy
> > +--------------------------------------
> > +
> > +io_uring fused command includes one primary command(uring command) and one
> > +generic secondary request. The primary command is responsible for submitting
> > +secondary request with provided buffer from ublk request, and primary command
> > +won't be completed until the secondary request is completed.
> > +
> > +Typical ublk IO handling includes network and FS IO, so it is usual enough
> > +for io_uring net & fs to support IO with provided buffer from primary command.
> >   
> > -Zero copy is a generic requirement for nbd, fuse or similar drivers. A
> 
> Maybe replace 'requirement' with "very useful"? It works without zc, 
> just with limited performance.

OK, also it has been observed that the extra copy affects performance a log for
big IO size(64K+). 

> 
> > -problem [#xiaoguang]_ Xiaoguang mentioned is that pages mapped to userspace
> > -can't be remapped any more in kernel with existing mm interfaces. This can
> > -occurs when destining direct IO to ``/dev/ublkb*``. Also, he reported that
> > -big requests (IO size >= 256 KB) may benefit a lot from zero copy.
> > +Once primary command is submitted successfully, ublk driver guarantees that
> > +the ublk request buffer won't be gone away since secondary request actually
> > +grabs the buffer's reference. This way also guarantees that multiple
> > +concurrent fused commands associated with same request buffer works fine,
> > +as the provided buffer reference is shared & read-only.
> >   
> > +Also buffer usage direction flag is passed to primary command from userspace,
> > +so ublk driver can validate if it is legal to use buffer with requested
> > +direction.
> >   
> >   References
> >   ==========
> > @@ -323,4 +431,4 @@ References
> >   
> >   .. [#stefan] https://lore.kernel.org/linux-block/YoOr6jBfgVm8GvWg@stefanha-x1.localdomain/
> >   
> > -.. [#xiaoguang] https://lore.kernel.org/linux-block/YoOr6jBfgVm8GvWg@stefanha-x1.localdomain/
> > +.. [#splice_extend] https://lore.kernel.org/linux-block/CAHk-=wgJsi7t7YYpuo6ewXGnHz2nmj67iWR6KPGoz5TBu34mWQ@mail.gmail.com/
> 
> 
> Any chance you could add a few code path into this document? For example 
> as in Documentation/filesystems/fuse.rst,
> section "Kernel - userspace interface"

OK, just it isn't handy to describe the flow by pure text.

BTW, you can also see the code path in the link:

https://github.com/ming1/ubdsrv/blob/master/doc/ublk_intro.pdf


thanks,
Ming

