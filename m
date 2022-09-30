Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2C55F0C96
	for <lists+io-uring@lfdr.de>; Fri, 30 Sep 2022 15:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbiI3NmU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Sep 2022 09:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbiI3NmK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Sep 2022 09:42:10 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559FF198684
        for <io-uring@vger.kernel.org>; Fri, 30 Sep 2022 06:42:08 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id z191so3262243iof.10
        for <io-uring@vger.kernel.org>; Fri, 30 Sep 2022 06:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=xqlNMZQ3D1AS+gGJtbQ5nwPfHLNZekdJiLeGB/2P0Oo=;
        b=g/SZlfEnW/xtL+38NFDeER7npa/YEubRwkLHoo7w9fm/7CxnBOtSpUYdY2mj8BA0Zs
         0oGpWEt4q45AGsJo6T8vpUTuRGV7Arl8LoU48M6d65vi+Kb8kfT8Lwi4ZxCaLuKCBxyZ
         xTqB13NvJVsAycKAY8x4J2NFMBqpPnf6YDMYXj6068D10m7OxZOK0zsVynWpRHUH+der
         Y8lxqnZlpfL/AvT/Se1lXMGoEEk409Lqu6W2OHwmAnoKHM0E2+T8U8drsN+CSTfUAm1A
         xGiejsbM8mDML6UBOFft3rtgMR3brw30FEz9h1IBIv51w7absU4zHRrgH4SudrGfWNEH
         sj7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=xqlNMZQ3D1AS+gGJtbQ5nwPfHLNZekdJiLeGB/2P0Oo=;
        b=rqxl32FevheDkHEYxmSnsSX4UvSiZCbPavRbtvA83ZcBVIfkFbOiM6+6O+VsS2hb2h
         Piydeu7z5lg3eNx4GKUbbrcIRX3tNqe30dEAzP/JiOUiR9M8BpVH73UgGIx2BqWJZME1
         qP/gieoD2WoqX0zBkEwEcaSe6pZQbdMOEQl61lriJNIlKLHXBIihoMLAErYSOB1Q/CkL
         fIw4qIDtH3fqAd53gi9bEO3uNk1rku3xuy0cb/OEbKAJpkqarz2xDxPMMbH+wnTf+LgL
         dKHTwW/2ZncdgwmA5+9Uzpj38v9Ra9EL3gU/+EJDYpyWYlr1wt6ukNlm13aySMYFfoxf
         6hlA==
X-Gm-Message-State: ACrzQf3QZh5vHaoguYzG2Q2xaxA7B0sIp0A7MbX4AV7WxA9hW6tSkjCp
        r8BOd08tuwIGanjaRZsAZ0BimA==
X-Google-Smtp-Source: AMsMyM68NxJth0vMZTHBU5g6/kMmGIAZO++J6bTpObKSqOmiBAa83Dd5SOy69a0F9kxxELXGdjUJww==
X-Received: by 2002:a05:6638:22c5:b0:35a:88fa:3d3a with SMTP id j5-20020a05663822c500b0035a88fa3d3amr4803594jat.115.1664545327131;
        Fri, 30 Sep 2022 06:42:07 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id d17-20020a0566022bf100b006a10d068d39sm1111030ioy.41.2022.09.30.06.42.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Sep 2022 06:42:06 -0700 (PDT)
Message-ID: <a08df763-b84f-0360-f1bf-4dd1da3a97bc@kernel.dk>
Date:   Fri, 30 Sep 2022 07:42:04 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH for-next v12 02/12] io_uring: introduce fixed buffer
 support for io_uring_cmd
To:     Anuj Gupta <anuj20.g@samsung.com>, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
References: <20220930062749.152261-1-anuj20.g@samsung.com>
 <CGME20220930063809epcas5p328b9e14ead49e9612b905e6f5b6682f7@epcas5p3.samsung.com>
 <20220930062749.152261-3-anuj20.g@samsung.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220930062749.152261-3-anuj20.g@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/30/22 12:27 AM, Anuj Gupta wrote:
> Add IORING_URING_CMD_FIXED flag that is to be used for sending io_uring
> command with previously registered buffers. User-space passes the buffer
> index in sqe->buf_index, same as done in read/write variants that uses
> fixed buffers.
> 
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> ---
>  include/linux/io_uring.h      |  2 +-
>  include/uapi/linux/io_uring.h |  9 +++++++++
>  io_uring/uring_cmd.c          | 18 +++++++++++++++++-
>  3 files changed, 27 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
> index 1dbf51115c30..e10c5cc81082 100644
> --- a/include/linux/io_uring.h
> +++ b/include/linux/io_uring.h
> @@ -28,7 +28,7 @@ struct io_uring_cmd {
>  		void *cookie;
>  	};
>  	u32		cmd_op;
> -	u32		pad;
> +	u32		flags;
>  	u8		pdu[32]; /* available inline for free use */
>  };
>  
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 92f29d9505a6..ab7458033ee3 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -56,6 +56,7 @@ struct io_uring_sqe {
>  		__u32		hardlink_flags;
>  		__u32		xattr_flags;
>  		__u32		msg_ring_flags;
> +		__u32		uring_cmd_flags;
>  	};
>  	__u64	user_data;	/* data to be passed back at completion time */
>  	/* pack this to avoid bogus arm OABI complaints */
> @@ -219,6 +220,14 @@ enum io_uring_op {
>  	IORING_OP_LAST,
>  };
>  
> +/*
> + * sqe->uring_cmd_flags
> + * IORING_URING_CMD_FIXED	use registered buffer; pass thig flag
> + *				along with setting sqe->buf_index.
> + */
> +#define IORING_URING_CMD_FIXED	(1U << 0)
> +
> +
>  /*
>   * sqe->fsync_flags
>   */
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 6a6d69523d75..05e8ad8cef87 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -4,6 +4,7 @@
>  #include <linux/file.h>
>  #include <linux/io_uring.h>
>  #include <linux/security.h>
> +#include <linux/nospec.h>
>  
>  #include <uapi/linux/io_uring.h>
>  
> @@ -77,7 +78,22 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  {
>  	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
>  
> -	if (sqe->rw_flags || sqe->__pad1)
> +	if (sqe->__pad1)
> +		return -EINVAL;
> +
> +	ioucmd->flags = READ_ONCE(sqe->uring_cmd_flags);
> +	if (ioucmd->flags & IORING_URING_CMD_FIXED) {
> +		struct io_ring_ctx *ctx = req->ctx;
> +		u16 index;
> +
> +		req->buf_index = READ_ONCE(sqe->buf_index);
> +		if (unlikely(req->buf_index >= ctx->nr_user_bufs))
> +			return -EFAULT;
> +		index = array_index_nospec(req->buf_index, ctx->nr_user_bufs);
> +		req->imu = ctx->user_bufs[index];
> +		io_req_set_rsrc_node(req, ctx, 0);
> +	}
> +	if (ioucmd->flags & ~IORING_URING_CMD_FIXED)
>  		return -EINVAL;

Not that it _really_ matters, but why isn't this check the first thing
that is done after reading the flags? No need to respin, I can just move
it myself.

-- 
Jens Axboe
