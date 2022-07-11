Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95288570B21
	for <lists+io-uring@lfdr.de>; Mon, 11 Jul 2022 22:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiGKUGN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Jul 2022 16:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiGKUGM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Jul 2022 16:06:12 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1416F27B17;
        Mon, 11 Jul 2022 13:06:10 -0700 (PDT)
Received: from localhost (modemcable141.102-20-96.mc.videotron.ca [96.20.102.141])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: krisman)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id C26656601A08;
        Mon, 11 Jul 2022 21:06:07 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1657569968;
        bh=efrJfkm08T5FY+7Y8iGb9989f4nc7vX6C2ArCPvjvWQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=a306mNVTN0BsPoTAetON5dOm4kOZj0IgmaZErfOUqt+9KckBizWehTEEg/XTKfxNU
         6uPTpM1HLKOwipOEB31AZyL2nqWuoDzbdthzBDdwWIuynCVQV+E/vs2cjTBtw3lejm
         9mRvq8lsBrBlfq+WJNv18fLVsYZsHJ+pthOoDMU5dzxi9mweqbYsX/6ftdk6v8oGao
         PoCKf0YGUzzGvS+RN7BivX6VIaIWEqHHyf4HCyDSJ7DqNLo/7PYu/XkvLhOe9wQcr+
         54qCd0F0eARcchs9PXAbA9OCH2J3qCIxR/WRqHttiO6zCUiUCipcd0SUhCLnuguq0k
         +M8q89lxZAeuw==
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: Re: [PATCH V4 2/2] ublk_drv: add UBLK_IO_REFETCH_REQ for supporting
 to build as module
Organization: Collabora
References: <20220711022024.217163-1-ming.lei@redhat.com>
        <20220711022024.217163-3-ming.lei@redhat.com>
Date:   Mon, 11 Jul 2022 16:06:04 -0400
In-Reply-To: <20220711022024.217163-3-ming.lei@redhat.com> (Ming Lei's message
        of "Mon, 11 Jul 2022 10:20:24 +0800")
Message-ID: <87lesze7o3.fsf@collabora.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Ming Lei <ming.lei@redhat.com> writes:

> Add UBLK_IO_REFETCH_REQ command to fetch the incoming io request in
> ubq daemon context, so we can avoid to call task_work_add(), then
> it is fine to build ublk driver as module.
>
> In this way, iops is affected a bit, but just by ~5% on ublk/null,
> given io_uring provides pretty good batching issuing & completing.
>
> One thing to be careful is race between ->queue_rq() and handling
> abort, which is avoided by quiescing queue when aborting queue.
> Except for that, handling abort becomes much easier with
> UBLK_IO_REFETCH_REQ since aborting handler is strictly exclusive with
> anything done in ubq daemon kernel context.

Hi Ming,

FWIW, I'm not very fond this change.  It adds complexity to the kernel
driver and to the userspace server implementation, who now have to deal
with different interface semantics just because the driver was built-in
or built as a module.  I don't think the tristate support warrants such
complexity.  I was hoping we might get away with exporting that symbol
or adding a built-in ubd-specific wrapper that can be exported and
invokes task_work_add.

Either way, Alibaba seems to consider this feature useful, and if that
is the case, we can just not use it on our side.

That said, the patch looks good to me, just a minor comment inline.

Thanks,

> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/block/Kconfig         |   2 +-
>  drivers/block/ublk_drv.c      | 121 ++++++++++++++++++++++++++--------
>  include/uapi/linux/ublk_cmd.h |  17 +++++
>  3 files changed, 113 insertions(+), 27 deletions(-)
>
> diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
> index d218089cdbec..2ba77fd960c2 100644
> --- a/drivers/block/Kconfig
> +++ b/drivers/block/Kconfig
> @@ -409,7 +409,7 @@ config BLK_DEV_RBD
>  	  If unsure, say N.
>  
>  config BLK_DEV_UBLK
> -	bool "Userspace block driver"
> +	tristate "Userspace block driver"
>  	select IO_URING
>  	help
>            io uring based userspace block driver.
> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
> index 0076418e6fad..98482f8d1a77 100644
> --- a/drivers/block/ublk_drv.c
> +++ b/drivers/block/ublk_drv.c
> @@ -92,6 +92,7 @@ struct ublk_queue {
>  	int q_id;
>  	int q_depth;
>  
> +	unsigned long flags;
>  	struct task_struct	*ubq_daemon;
>  	char *io_cmd_buf;
>  
> @@ -141,6 +142,15 @@ struct ublk_device {
>  	struct work_struct	stop_work;
>  };
>  
> +#define ublk_use_task_work(ubq)						\
> +({                                                                      \
> +	bool ret = false;						\
> +	if (IS_BUILTIN(CONFIG_BLK_DEV_UBLK) &&                          \
> +			!((ubq)->flags & UBLK_F_NEED_REFETCH))		\
> +		ret = true;						\
> +	ret;								\
> +})
> +

This should be an inline function, IMO.


-- 
Gabriel Krisman Bertazi
