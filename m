Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23E8C6C27A1
	for <lists+io-uring@lfdr.de>; Tue, 21 Mar 2023 02:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbjCUBzl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Mar 2023 21:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjCUBzk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Mar 2023 21:55:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22B111EBA
        for <io-uring@vger.kernel.org>; Mon, 20 Mar 2023 18:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679363687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DbWljtYJs8jkVB9GMPW3S70ZjuO/S75tSE8YAgihd1A=;
        b=SwOAkuonVqNDeaK8uNS51mI8RNQvHDvRNJNbjME1pY9brzJsPrbTRut54+uPF40PEJDj55
        5DlaBfqNqTsC6uysK3IxN+ecm7yLmNOZVOmBuTCCj9px4koLsEU2xXnPnAsxMETRaM+v1d
        t4/rgNLrVmebJw4XYMGcuH4AtXpDPbs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-571-STy93GxJNRCJY5S_RLCikg-1; Mon, 20 Mar 2023 21:54:43 -0400
X-MC-Unique: STy93GxJNRCJY5S_RLCikg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 61B6180C8C1;
        Tue, 21 Mar 2023 01:54:43 +0000 (UTC)
Received: from ovpn-8-18.pek2.redhat.com (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DF2802166B29;
        Tue, 21 Mar 2023 01:54:39 +0000 (UTC)
Date:   Tue, 21 Mar 2023 09:54:34 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Kanchan Joshi <joshiiitr@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        Kanchan Joshi <joshi.k@samsung.com>, ming.lei@redhat.com
Subject: Re: [PATCH] io_uring/uring_cmd: push IRQ based completions through
 task_work
Message-ID: <ZBkOWo1kE56q1QJ6@ovpn-8-18.pek2.redhat.com>
References: <4b4e3526-e6b5-73dd-c6fb-f7ddccf19f33@kernel.dk>
 <CA+1E3rKBNhmT63GMNpe-c+EVDpzvs4voTkL-efkdbJHdNZhZ7w@mail.gmail.com>
 <ZBjtuebXxIPpXoIG@ovpn-8-29.pek2.redhat.com>
 <149cd773-f302-faec-d77d-9db41be6744c@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149cd773-f302-faec-d77d-9db41be6744c@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Mar 20, 2023 at 07:39:30PM -0600, Jens Axboe wrote:
> On 3/20/23 5:35?PM, Ming Lei wrote:
> > On Mon, Mar 20, 2023 at 08:36:15PM +0530, Kanchan Joshi wrote:
> >> On Sun, Mar 19, 2023 at 8:51?PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>
> >>> This is similar to what we do on the non-passthrough read/write side,
> >>> and helps take advantage of the completion batching we can do when we
> >>> post CQEs via task_work. On top of that, this avoids a uring_lock
> >>> grab/drop for every completion.
> >>>
> >>> In the normal peak IRQ based testing, this increases performance in
> >>> my testing from ~75M to ~77M IOPS, or an increase of 2-3%.
> >>>
> >>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >>>
> >>> ---
> >>>
> >>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> >>> index 2e4c483075d3..b4fba5f0ab0d 100644
> >>> --- a/io_uring/uring_cmd.c
> >>> +++ b/io_uring/uring_cmd.c
> >>> @@ -45,18 +45,21 @@ static inline void io_req_set_cqe32_extra(struct io_kiocb *req,
> >>>  void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2)
> >>>  {
> >>>         struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
> >>> +       struct io_ring_ctx *ctx = req->ctx;
> >>>
> >>>         if (ret < 0)
> >>>                 req_set_fail(req);
> >>>
> >>>         io_req_set_res(req, ret, 0);
> >>> -       if (req->ctx->flags & IORING_SETUP_CQE32)
> >>> +       if (ctx->flags & IORING_SETUP_CQE32)
> >>>                 io_req_set_cqe32_extra(req, res2, 0);
> >>> -       if (req->ctx->flags & IORING_SETUP_IOPOLL)
> >>> +       if (ctx->flags & IORING_SETUP_IOPOLL) {
> >>>                 /* order with io_iopoll_req_issued() checking ->iopoll_complete */
> >>>                 smp_store_release(&req->iopoll_completed, 1);
> >>> -       else
> >>> -               io_req_complete_post(req, 0);
> >>> +               return;
> >>> +       }
> >>> +       req->io_task_work.func = io_req_task_complete;
> >>> +       io_req_task_work_add(req);
> >>>  }
> >>
> >> Since io_uring_cmd_done itself would be executing in task-work often
> >> (always in case of nvme), can this be further optimized by doing
> >> directly what this new task-work (that is being set up here) would
> >> have done?
> >> Something like below on top of your patch -
> > 
> > But we have io_uring_cmd_complete_in_task() already, just wondering why
> > not let driver decide if explicit running in task-work is taken?
> 
> Because it's currently broken, see my patch from earlier today.

OK, got it, just miss your revised patch.

Then I guess your patch needs to split into one bug fix(for backporting) on
io_uring_cmd_done() and one optimization?

thanks,
Ming

