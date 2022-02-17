Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D83834BA8B2
	for <lists+io-uring@lfdr.de>; Thu, 17 Feb 2022 19:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238405AbiBQSqx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Feb 2022 13:46:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235553AbiBQSqw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Feb 2022 13:46:52 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C443CFCD;
        Thu, 17 Feb 2022 10:46:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=s56TtY8DxMR7zBFoRRt9eI9KXJDyEEH2IYtgCwy2sC8=; b=a249VHjfyQYY9fpZ9TV8pJzxRO
        veDARkv1Wr6CPTEB0/uMLIGiIgggQ1XI/Q4O2iw6UyUj8G2xA2aiM2FZHabWv4XPOSYE/tdpHHpVA
        YFrTqSZs2BeGEQgkQe4AA+5LO2mMzg+6bRxn8dq8oG/BI7kjAS/XrJallZmXcQjRikEBm2a9l3HH6
        EtwF1qQoZTK5xXdWyb44BkGvhJJD+xzRlNfi4l8hvuNQaV++47QDnanD9AzaN1ttfy/0J5BqWKavu
        VvPc2ThkJ+O6+KozhzBDnCT9Vpay4kAjR5/czaUtuelASEdH5X8V6jhidJNfkjBhLuN925nY9pCiM
        85wtsH5Q==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nKlnY-00BmkR-7h; Thu, 17 Feb 2022 18:46:36 +0000
Date:   Thu, 17 Feb 2022 10:46:36 -0800
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
Message-ID: <Yg6YDJHcSh1WPh2+@bombadil.infradead.org>
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

Just to be clear, I was thinking outside of the block layer context too.
Does this still hold true?

  Luis
