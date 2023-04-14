Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A64AC6E2732
	for <lists+io-uring@lfdr.de>; Fri, 14 Apr 2023 17:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjDNPoK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Apr 2023 11:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbjDNPoJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Apr 2023 11:44:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE9DF3C0B
        for <io-uring@vger.kernel.org>; Fri, 14 Apr 2023 08:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681487005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W168nCHb4CDZ+RY4rBSIsbuardmikyDFHhV8GOglloE=;
        b=EASxNMfHEPflUvruvy9nbQHQ1asJY6pj5aj/ONj0Z0Nt/deSnMFPlfjrmifCfO3mE/mpgu
        ycLCCMtrLgEOxxzhmg3JWn4JRU58CuOqWoS+MKiaB3XLCWc5UgZu8N6tIa2tosE0LJuW9f
        kD1AQlHX05KjPaF+8glZdmNYNBgF/hQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-91-kB8Pp-6WNQeBZ_GYSXwWNg-1; Fri, 14 Apr 2023 11:43:08 -0400
X-MC-Unique: kB8Pp-6WNQeBZ_GYSXwWNg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64A808057BF;
        Fri, 14 Apr 2023 15:43:08 +0000 (UTC)
Received: from ovpn-8-21.pek2.redhat.com (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DCAD492B00;
        Fri, 14 Apr 2023 15:43:03 +0000 (UTC)
Date:   Fri, 14 Apr 2023 23:42:57 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Kanchan Joshi <joshi.k@samsung.com>, ming.lei@redhat.com
Subject: Re: [PATCH] io_uring: complete request via task work in case of
 DEFER_TASKRUN
Message-ID: <ZDl0gXfxR+W9luej@ovpn-8-21.pek2.redhat.com>
References: <20230414075313.373263-1-ming.lei@redhat.com>
 <68ddddc0-fb0e-47b4-9318-9dd549d851a1@gmail.com>
 <ZDlay1++tidiKv+n@ovpn-8-21.pek2.redhat.com>
 <9d5d57ec-c76a-754b-1f33-7557b2443d5c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d5d57ec-c76a-754b-1f33-7557b2443d5c@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Apr 14, 2023 at 04:07:52PM +0100, Pavel Begunkov wrote:
> On 4/14/23 14:53, Ming Lei wrote:
> > On Fri, Apr 14, 2023 at 02:01:26PM +0100, Pavel Begunkov wrote:
> > > On 4/14/23 08:53, Ming Lei wrote:
> > > > So far io_req_complete_post() only covers DEFER_TASKRUN by completing
> > > > request via task work when the request is completed from IOWQ.
> > > > 
> > > > However, uring command could be completed from any context, and if io
> > > > uring is setup with DEFER_TASKRUN, the command is required to be
> > > > completed from current context, otherwise wait on IORING_ENTER_GETEVENTS
> > > > can't be wakeup, and may hang forever.
> > > 
> > > fwiw, there is one legit exception, when the task is half dead
> > > task_work will be executed by a kthread. It should be fine as it
> > > locks the ctx down, but I can't help but wonder whether it's only
> > > ublk_cancel_queue() affected or there are more places in ublk?
> > 
> > No, it isn't.
> > 
> > It isn't triggered on nvme-pt just because command is always done
> > in task context.
> > 
> > And we know more uring command cases are coming.
> 
> Because all requests and cmds but ublk complete it from another
> task, ublk is special in this regard.

Not sure it is true, cause it is allowed to call io_uring_cmd_done from other
task technically. And it could be more friendly for driver to not limit
its caller in the task context. Especially we have another API of
io_uring_cmd_complete_in_task().

> 
> I have several more not so related questions:
> 
> 1) Can requests be submitted by some other task than ->ubq_daemon?

Yeah, requests can be submitted by other task, but ublk driver doesn't
allow it because ublk driver has not knowledge when the io_uring context
goes away, so has to limit requests submitted from ->ubq_daemon only,
then use this task's information for checking if the io_uring context
is going to exit. When the io_uring context is dying, we need to
abort these uring commands(may never complete), see ublk_cancel_queue().

The only difference is that the uring command may never complete,
because one uring cmd is only completed when the associated block request
is coming. The situation could be improved by adding API/callback for
notifying io_uring exit.


> Looking at
> 
> static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
> {
>     ...
>     if (ubq->ubq_daemon && ubq->ubq_daemon != current)
>        goto out;
> }
> 
> ublk_queue_cmd() avoiding io_uring way of delivery and using
> raw task_work doesn't seem great. Especially with TWA_SIGNAL_NO_IPI.

Yeah, it has been in my todo list to kill task work. In ublk early time,
task work just performs better than io_uring_cmd_complete_in_task(), but
the gap becomes pretty small or even not visible now. 

> 
> 2) What the purpose of the two lines below? I see how
> UBLK_F_URING_CMD_COMP_IN_TASK is used, but don't understand
> why it changes depending on whether it's a module or not.

task work isn't available in case of building ublk as module.

> 
> 3) The long comment in ublk_queue_cmd() seems quite scary.
> If you have a cmd / io_uring request it hold a ctx reference
> and is always allowed to use io_uring's task_work infra like
> io_uring_cmd_complete_in_task(). Why it's different for ublk?

The thing is that we don't know if there is io_uring request for the
coming blk request. UBLK_IO_FLAG_ABORTED just means that the io_uring
context is dead, and we can't use io_uring_cmd_complete_in_task() any
more.

> 
> > > 
> > > One more thing, cmds should not be setting issue_flags but only
> > > forwarding what the core io_uring code passed, it'll get tons of
> > > bugs in no time otherwise.
> > 
> > Here io_uring_cmd_done() is changed to this way recently, and it
> > could be another topic.
> 
> And it's abused, but as you said, not particularly related
> to this patch.
> 
> 
> > > static void ublk_cancel_queue(struct ublk_queue *ubq)
> > > {
> > >      ...
> > >      io_uring_cmd_done(io->cmd, UBLK_IO_RES_ABORT, 0,
> > >                        IO_URING_F_UNLOCKED);
> > > }
> > > 
> > > Can we replace it with task_work? It should be cold, and I
> > > assume ublk_cancel_queue() doesn't assume that all requests will
> > > put down by the end of the function as io_uring_cmd_done()
> > > can offload it in any case.
> > 
> > But it isn't specific for ublk, any caller of io_uring_cmd_done()
> > has such issue since io_uring_cmd_done() is one generic API.
> 
> Well, fair enough, considering that IO_URING_F_UNLOCKED was
> just added (*still naively hoping it'll be clean up*)

IMO, it is reasonable for io_uring_cmd_done to hide any io_uring
implementation details, even the task context concept, but not
sure if it is doable.


Thanks,
Ming

