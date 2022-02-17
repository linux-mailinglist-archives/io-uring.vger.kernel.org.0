Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C06364B95D1
	for <lists+io-uring@lfdr.de>; Thu, 17 Feb 2022 03:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbiBQCNf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Feb 2022 21:13:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiBQCNe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Feb 2022 21:13:34 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA29280EE1;
        Wed, 16 Feb 2022 18:13:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=AtTr1AIg2fX5MAGAguqHpar1HIdpAfeTlW/Zsbtatqo=; b=yAbYH+PNgI4yfK6Oc0x1/9WwAo
        B57GyZh4dKaKmYo4WBvEI9qJQId/5rs4IkiKbAXnJ1w3BrBTkm+ZlUmlObuTCvCjZ7kWZu2YxCmNQ
        KxBt3Jx86cgbnS3MYbteeeKYxbfwIzRgVzv/lH9SdAea6M6wJCfH5FCG9IAmoK8/VDlPSgGmVcS3V
        fNhTMglfQs1cJ4a8MEUVYdZkRenqkcRIHJ027E3/tx9woItuLTwg8wwwNqYWzInUjeBor61z5YaJU
        2VVNuLrmaw9rfZ4Fddz5Wv46x9hW1P9S2sqI8sGec+t2bzHWcuxcKrYa13YO3L1YrTJYyyhyxFXHK
        mjW0v2rA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nKWIJ-008jY5-RC; Thu, 17 Feb 2022 02:13:19 +0000
Date:   Wed, 16 Feb 2022 18:13:19 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, axboe@kernel.dk, hch@lst.de,
        kbusch@kernel.org, javier@javigon.com, anuj20.g@samsung.com,
        joshiiitr@gmail.com, pankydev8@gmail.com
Subject: Re: [RFC 01/13] io_uring: add infra for uring_cmd completion in
 submitter-task
Message-ID: <Yg2vP7lo3hGLGakx@bombadil.infradead.org>
References: <20211220141734.12206-1-joshi.k@samsung.com>
 <CGME20211220142228epcas5p2978d92d38f2015148d5f72913d6dbc3e@epcas5p2.samsung.com>
 <20211220141734.12206-2-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211220141734.12206-2-joshi.k@samsung.com>
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

On Mon, Dec 20, 2021 at 07:47:22PM +0530, Kanchan Joshi wrote:
> Completion of a uring_cmd ioctl may involve referencing certain
> ioctl-specific fields, requiring original submitter context.
> Export an API that driver can use for this purpose.
> The API facilitates reusing task-work infra of io_uring, while driver
> gets to implement cmd-specific handling in a callback.
> 
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> ---
>  fs/io_uring.c            | 16 ++++++++++++++++
>  include/linux/io_uring.h |  8 ++++++++
>  2 files changed, 24 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index e96ed3d0385e..246f1085404d 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2450,6 +2450,22 @@ static void io_req_task_submit(struct io_kiocb *req, bool *locked)
>  		io_req_complete_failed(req, -EFAULT);
>  }
>  
> +static void io_uring_cmd_work(struct io_kiocb *req, bool *locked)
> +{
> +	req->uring_cmd.driver_cb(&req->uring_cmd);

If the callback memory area is gone, boom.

> +}
> +
> +void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
> +			void (*driver_cb)(struct io_uring_cmd *))

Adding kdoc style comment for this would be nice. Please document
the context that is allowed.

> +{
> +	struct io_kiocb *req = container_of(ioucmd, struct io_kiocb, uring_cmd);
> +
> +	req->uring_cmd.driver_cb = driver_cb;
> +	req->io_task_work.func = io_uring_cmd_work;
> +	io_req_task_work_add(req, !!(req->ctx->flags & IORING_SETUP_SQPOLL));

This can schedules, and so the callback may go fishing in the meantime.

> +}
> +EXPORT_SYMBOL_GPL(io_uring_cmd_complete_in_task);
> +
>  static void io_req_task_queue_fail(struct io_kiocb *req, int ret)
>  {
>  	req->result = ret;
> diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
> index 64e788b39a86..f4b4990a3b62 100644
> --- a/include/linux/io_uring.h
> +++ b/include/linux/io_uring.h
> @@ -14,11 +14,15 @@ struct io_uring_cmd {
>  	__u16		op;
>  	__u16		unused;
>  	__u32		len;
> +	/* used if driver requires update in task context*/

By using kdoc above youcan remove this comment.

> +	void (*driver_cb)(struct io_uring_cmd *cmd);

So we'd need a struct module here I think if we're going to
defer this into memory which can be removed.

  Luis
