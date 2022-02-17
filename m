Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F59F4BA792
	for <lists+io-uring@lfdr.de>; Thu, 17 Feb 2022 18:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243937AbiBQR4y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Feb 2022 12:56:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240904AbiBQR4x (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Feb 2022 12:56:53 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D1886E38;
        Thu, 17 Feb 2022 09:56:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6ckybct3FPMLo0xdtJt/GmtfVHGW/Fz7SoVWRuRzIWI=; b=TUk9ZD8zmd4WwF2rBQG9Jy/e5p
        5/RU/3srRwzJ89C2uJkDKgQuUAGrU8foXgaLFUMGR2nd11CEsvw2Fw0ISiVnq6/VKwHMlzZrPSpmJ
        ElBjW1AZ30cUxiqF4MLaObpeC6e2QMklaIVBovHi/3AZudcLuRvJoXiKbpySC9wiyCbVXK2AQKyaw
        BQyXz9oUsgb1xwPDCTO+GJG8q9dEhlOQGxGLKLT6rdqKneCfI1OGhMvMMrE2fRfYiyDIJv1pD+xhz
        4BmfyHUJ/USaLx3Ho9w3G8yhtnYjljxZzb4t8Lt24dtC/yqRYdI3ekqAGwztwJx0/iF1LU4piW2qB
        QTXPatVQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nKl1B-00BeVy-81; Thu, 17 Feb 2022 17:56:37 +0000
Date:   Thu, 17 Feb 2022 09:56:37 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Kanchan Joshi <joshiiitr@gmail.com>,
        Kanchan Joshi <joshi.k@samsung.com>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier@javigon.com>,
        Anuj Gupta <anuj20.g@samsung.com>,
        Pankaj Raghav <pankydev8@gmail.com>
Subject: Re: [RFC 01/13] io_uring: add infra for uring_cmd completion in
 submitter-task
Message-ID: <Yg6MVe2Qpy92CsNF@bombadil.infradead.org>
References: <20211220141734.12206-1-joshi.k@samsung.com>
 <CGME20211220142228epcas5p2978d92d38f2015148d5f72913d6dbc3e@epcas5p2.samsung.com>
 <20211220141734.12206-2-joshi.k@samsung.com>
 <Yg2vP7lo3hGLGakx@bombadil.infradead.org>
 <CA+1E3rLpKp0h2x7CoFPXwsYOc4ZYg_sqQQ+ed8cJhq77ESOAjg@mail.gmail.com>
 <b11ede2b-b737-f99a-7b31-20d6b4eccb42@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b11ede2b-b737-f99a-7b31-20d6b4eccb42@kernel.dk>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Feb 17, 2022 at 08:50:59AM -0700, Jens Axboe wrote:
> On 2/17/22 8:39 AM, Kanchan Joshi wrote:
> > On Thu, Feb 17, 2022 at 7:43 AM Luis Chamberlain <mcgrof@kernel.org> wrote:
> >>
> >> On Mon, Dec 20, 2021 at 07:47:22PM +0530, Kanchan Joshi wrote:
> >>> Completion of a uring_cmd ioctl may involve referencing certain
> >>> ioctl-specific fields, requiring original submitter context.
> >>> Export an API that driver can use for this purpose.
> >>> The API facilitates reusing task-work infra of io_uring, while driver
> >>> gets to implement cmd-specific handling in a callback.
> >>>
> >>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> >>> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> >>> ---
> >>>  fs/io_uring.c            | 16 ++++++++++++++++
> >>>  include/linux/io_uring.h |  8 ++++++++
> >>>  2 files changed, 24 insertions(+)
> >>>
> >>> diff --git a/fs/io_uring.c b/fs/io_uring.c
> >>> index e96ed3d0385e..246f1085404d 100644
> >>> --- a/fs/io_uring.c
> >>> +++ b/fs/io_uring.c
> >>> @@ -2450,6 +2450,22 @@ static void io_req_task_submit(struct io_kiocb *req, bool *locked)
> >>>               io_req_complete_failed(req, -EFAULT);
> >>>  }
> >>>
> >>> +static void io_uring_cmd_work(struct io_kiocb *req, bool *locked)
> >>> +{
> >>> +     req->uring_cmd.driver_cb(&req->uring_cmd);
> >>
> >> If the callback memory area is gone, boom.
> > 
> > Why will the memory area be gone?
> > Module removal is protected because try_module_get is done anyway when
> > the namespace was opened.
> 
> And the req isn't going away before it's completed.

Groovy, it would be nice to add a little /* comment */ to just remind
the reader?

> >>> +{
> >>> +     struct io_kiocb *req = container_of(ioucmd, struct io_kiocb, uring_cmd);
> >>> +
> >>> +     req->uring_cmd.driver_cb = driver_cb;
> >>> +     req->io_task_work.func = io_uring_cmd_work;
> >>> +     io_req_task_work_add(req, !!(req->ctx->flags & IORING_SETUP_SQPOLL));
> >>
> >> This can schedules, and so the callback may go fishing in the meantime.
> > 
> > io_req_task_work_add is safe to be called in atomic context. FWIW,
> > io_uring uses this for regular (i.e. direct block) io completion too.
> 
> Correct, it doesn't schedule and is safe from irq context as long as the
> task is pinned (which it is, via the req itself).

Great, a kdoc explaining the routine and that it can be called from
atomic context and the rationale would be very useful to users. And ..
so the callback *must* be safe in atomic context too or can it sleep?

  Luis
