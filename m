Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C56066E24D1
	for <lists+io-uring@lfdr.de>; Fri, 14 Apr 2023 15:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbjDNNyV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Apr 2023 09:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjDNNyU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Apr 2023 09:54:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E368176B4
        for <io-uring@vger.kernel.org>; Fri, 14 Apr 2023 06:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681480409;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3925XMRYQh/k+pq/25u0WQoYIP6eBvBIiykh9rJI75o=;
        b=IUZ7YatfAclzd8TEohV5WwlLH9WVSS0croeUOw/AN8Kdjb9uZw9cNj3uTz8yJSpbhctc4f
        8px1D33igc+ZiqWTeLbhuEFzaNsXfcgF9aN66+b4NzYvLZxA8M/dO+r92EN5RwudN3xCvK
        DwdIhK0l+bSwnMW3DQ9bovRIbKjjpC4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-107-5uBWkRf-OpuD654y7DG33A-1; Fri, 14 Apr 2023 09:53:25 -0400
X-MC-Unique: 5uBWkRf-OpuD654y7DG33A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 831E63822DEB;
        Fri, 14 Apr 2023 13:53:25 +0000 (UTC)
Received: from ovpn-8-21.pek2.redhat.com (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D7951121320;
        Fri, 14 Apr 2023 13:53:20 +0000 (UTC)
Date:   Fri, 14 Apr 2023 21:53:15 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Kanchan Joshi <joshi.k@samsung.com>, ming.lei@redhat.com
Subject: Re: [PATCH] io_uring: complete request via task work in case of
 DEFER_TASKRUN
Message-ID: <ZDlay1++tidiKv+n@ovpn-8-21.pek2.redhat.com>
References: <20230414075313.373263-1-ming.lei@redhat.com>
 <68ddddc0-fb0e-47b4-9318-9dd549d851a1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68ddddc0-fb0e-47b4-9318-9dd549d851a1@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Apr 14, 2023 at 02:01:26PM +0100, Pavel Begunkov wrote:
> On 4/14/23 08:53, Ming Lei wrote:
> > So far io_req_complete_post() only covers DEFER_TASKRUN by completing
> > request via task work when the request is completed from IOWQ.
> > 
> > However, uring command could be completed from any context, and if io
> > uring is setup with DEFER_TASKRUN, the command is required to be
> > completed from current context, otherwise wait on IORING_ENTER_GETEVENTS
> > can't be wakeup, and may hang forever.
> 
> fwiw, there is one legit exception, when the task is half dead
> task_work will be executed by a kthread. It should be fine as it
> locks the ctx down, but I can't help but wonder whether it's only
> ublk_cancel_queue() affected or there are more places in ublk?

No, it isn't.

It isn't triggered on nvme-pt just because command is always done
in task context.

And we know more uring command cases are coming.

> 
> One more thing, cmds should not be setting issue_flags but only
> forwarding what the core io_uring code passed, it'll get tons of
> bugs in no time otherwise.

Here io_uring_cmd_done() is changed to this way recently, and it
could be another topic.

> 
> static void ublk_cancel_queue(struct ublk_queue *ubq)
> {
>     ...
>     io_uring_cmd_done(io->cmd, UBLK_IO_RES_ABORT, 0,
>                       IO_URING_F_UNLOCKED);
> }
> 
> Can we replace it with task_work? It should be cold, and I
> assume ublk_cancel_queue() doesn't assume that all requests will
> put down by the end of the function as io_uring_cmd_done()
> can offload it in any case.

But it isn't specific for ublk, any caller of io_uring_cmd_done()
has such issue since io_uring_cmd_done() is one generic API.


thanks,
Ming

