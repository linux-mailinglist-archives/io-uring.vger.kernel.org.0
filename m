Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 946986C25AF
	for <lists+io-uring@lfdr.de>; Tue, 21 Mar 2023 00:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjCTXgV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Mar 2023 19:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjCTXgT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Mar 2023 19:36:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF7D36084
        for <io-uring@vger.kernel.org>; Mon, 20 Mar 2023 16:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679355333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kjfXSYwWtjRXvLD+ftgo6H8OtvG4yBz+q5yhwWK5AGM=;
        b=MPtq9ukfha8ga7K4rxQid89oiLLXZfgiQ60ib3tAaVyRo6zw+pg8KY5ZqTQ0+Yjz/7D0PQ
        A9K0LZyw8BQabOXYBUo+cyk4BEXLILe1eCOtJ8HtvG68aLNFzkSPk1IKnVO65SiVzF6wZs
        C3q8FAkbpB2Qz9BEPtgmV9w7/rMfF5g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-508-8-VKM4BnNeKq3UObJ3VW8w-1; Mon, 20 Mar 2023 19:35:30 -0400
X-MC-Unique: 8-VKM4BnNeKq3UObJ3VW8w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C6D073806100;
        Mon, 20 Mar 2023 23:35:29 +0000 (UTC)
Received: from ovpn-8-29.pek2.redhat.com (ovpn-8-29.pek2.redhat.com [10.72.8.29])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E5D640C83AC;
        Mon, 20 Mar 2023 23:35:25 +0000 (UTC)
Date:   Tue, 21 Mar 2023 07:35:21 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
        Kanchan Joshi <joshi.k@samsung.com>, ming.lei@redhat.com
Subject: Re: [PATCH] io_uring/uring_cmd: push IRQ based completions through
 task_work
Message-ID: <ZBjtuebXxIPpXoIG@ovpn-8-29.pek2.redhat.com>
References: <4b4e3526-e6b5-73dd-c6fb-f7ddccf19f33@kernel.dk>
 <CA+1E3rKBNhmT63GMNpe-c+EVDpzvs4voTkL-efkdbJHdNZhZ7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+1E3rKBNhmT63GMNpe-c+EVDpzvs4voTkL-efkdbJHdNZhZ7w@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Mar 20, 2023 at 08:36:15PM +0530, Kanchan Joshi wrote:
> On Sun, Mar 19, 2023 at 8:51 PM Jens Axboe <axboe@kernel.dk> wrote:
> >
> > This is similar to what we do on the non-passthrough read/write side,
> > and helps take advantage of the completion batching we can do when we
> > post CQEs via task_work. On top of that, this avoids a uring_lock
> > grab/drop for every completion.
> >
> > In the normal peak IRQ based testing, this increases performance in
> > my testing from ~75M to ~77M IOPS, or an increase of 2-3%.
> >
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >
> > ---
> >
> > diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> > index 2e4c483075d3..b4fba5f0ab0d 100644
> > --- a/io_uring/uring_cmd.c
> > +++ b/io_uring/uring_cmd.c
> > @@ -45,18 +45,21 @@ static inline void io_req_set_cqe32_extra(struct io_kiocb *req,
> >  void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2)
> >  {
> >         struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
> > +       struct io_ring_ctx *ctx = req->ctx;
> >
> >         if (ret < 0)
> >                 req_set_fail(req);
> >
> >         io_req_set_res(req, ret, 0);
> > -       if (req->ctx->flags & IORING_SETUP_CQE32)
> > +       if (ctx->flags & IORING_SETUP_CQE32)
> >                 io_req_set_cqe32_extra(req, res2, 0);
> > -       if (req->ctx->flags & IORING_SETUP_IOPOLL)
> > +       if (ctx->flags & IORING_SETUP_IOPOLL) {
> >                 /* order with io_iopoll_req_issued() checking ->iopoll_complete */
> >                 smp_store_release(&req->iopoll_completed, 1);
> > -       else
> > -               io_req_complete_post(req, 0);
> > +               return;
> > +       }
> > +       req->io_task_work.func = io_req_task_complete;
> > +       io_req_task_work_add(req);
> >  }
> 
> Since io_uring_cmd_done itself would be executing in task-work often
> (always in case of nvme), can this be further optimized by doing
> directly what this new task-work (that is being set up here) would
> have done?
> Something like below on top of your patch -

But we have io_uring_cmd_complete_in_task() already, just wondering why
not let driver decide if explicit running in task-work is taken?

Thanks,
Ming

