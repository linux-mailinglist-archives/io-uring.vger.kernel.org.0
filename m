Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14F836F46FB
	for <lists+io-uring@lfdr.de>; Tue,  2 May 2023 17:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234495AbjEBPVo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 May 2023 11:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233271AbjEBPV0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 May 2023 11:21:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B11D212E
        for <io-uring@vger.kernel.org>; Tue,  2 May 2023 08:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683040825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Za7NFd4AI/q6+jaM9pggaMzbvwNlSjLc3P58MOyPj84=;
        b=Rjiouzu4YKQ2BhTZFiQdZZPBazWjvTLXLnz4PqYD2Szz6MTozaEVOtwISuLNwX0dqIwvJS
        YzNKu8osq7qUrw+KVV1H3A4EvzDHsWXFmHqqO0yQB9Uvywv+qtZL8Lu2g+qVo3FwA0HCVx
        luuPfvpzmGbXxiBgoWxgBIodpCBdVbQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-136-DAgpydCuPSWIuYkEPnhedQ-1; Tue, 02 May 2023 11:20:20 -0400
X-MC-Unique: DAgpydCuPSWIuYkEPnhedQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 55BDF29AB3E7;
        Tue,  2 May 2023 15:20:20 +0000 (UTC)
Received: from ovpn-8-16.pek2.redhat.com (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D2030492C13;
        Tue,  2 May 2023 15:20:17 +0000 (UTC)
Date:   Tue, 2 May 2023 23:20:12 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, ming.lei@redhat.com
Subject: Re: [RFC 7/7] io_uring,fs: introduce IORING_OP_GET_BUF
Message-ID: <ZFEqLGEERVMvFq+C@ovpn-8-16.pek2.redhat.com>
References: <cover.1682701588.git.asml.silence@gmail.com>
 <fc43826d510dc75de83d81161ca03e2688515686.1682701588.git.asml.silence@gmail.com>
 <ZFEk2rQv2//KRBeK@ovpn-8-16.pek2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZFEk2rQv2//KRBeK@ovpn-8-16.pek2.redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, May 02, 2023 at 10:57:30PM +0800, Ming Lei wrote:
> On Sun, Apr 30, 2023 at 10:35:29AM +0100, Pavel Begunkov wrote:
> > There are several problems with splice requests, aka IORING_OP_SPLICE:
> > 1) They are always executed by a worker thread, which is a slow path,
> >    as we don't have any reliable way to execute it NOWAIT.
> > 2) It can't easily poll for data, as there are 2 files it operates on.
> >    It would either need to track what file to poll or poll both of them,
> >    in both cases it'll be a mess and add lot of overhead.
> > 3) It has to have pipes in the middle, which adds overhead and is not
> >    great from the uapi design perspective when it goes for io_uring
> >    requests.
> > 4) We want to operate with spliced data as with a normal buffer, i.e.
> >    write / send / etc. data as normally while it's zerocopy.
> > 
> > It can partially be solved, but the root cause is a suboptimal for
> > io_uring design of IORING_OP_SPLICE. Introduce a new request type
> > called IORING_OP_GET_BUF, inspired by splice(2) as well as other
> > proposals like fused requests. The main idea is to use io_uring's
> > registered buffers as the middle man instead of pipes. Once a buffer
> > is fetched / spliced from a file using a new fops callback
> > ->iou_get_buf, it's installed as a registered buffers and can be used
> > by all operations supporting the feature.
> > 
> > Once the userspace releases the buffer, io_uring will wait for all
> > requests using the buffer to complete and then use a file provided
> > callback ->release() to return the buffer back. It operates on the
> 
> In the commit of "io_uring: add an example for buf-get op", I don't see
> any code to release the buffer, can you explain it in details about how
> to release the buffer in userspace? And add it in your example?
> 
> Here I guess the ->release() is called in the following code path:
> 
> io_buffer_unmap
>     io_rsrc_buf_put
>         io_rsrc_put_work
>             io_rsrc_node_ref_zero
>                 io_put_rsrc_node
> 
> If it is true, what is counter-pair code for io_put_rsrc_node()?

It is io_req_set_rsrc_node() called from io_prep_rw() and
io_send_zc_prep().

So only fs IO and net zc supports it, however the fixed buffer
is used in ->prep(), that means this way can't work when the
rw/net_send_zc OP follows IORING_OP_GET_BUF by IO_LINK.

This way is one big defect because IOSQE_IO_LINK does simplify
application a lot.

Thanks,
Ming

