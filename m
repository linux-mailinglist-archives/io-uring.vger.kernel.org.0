Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B40C6162BD
	for <lists+io-uring@lfdr.de>; Wed,  2 Nov 2022 13:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiKBMeX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Nov 2022 08:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiKBMeW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Nov 2022 08:34:22 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74DEA201A3
        for <io-uring@vger.kernel.org>; Wed,  2 Nov 2022 05:34:21 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id r186-20020a1c44c3000000b003cf4d389c41so1186668wma.3
        for <io-uring@vger.kernel.org>; Wed, 02 Nov 2022 05:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ffo6sUekuwYvcpFuuo0C3lxP9xjET9MC56Nugypmn0w=;
        b=HoCAOCLNajDzmf4aUqRqm+04RWjd2ZaNV6QUx6xa6aD2cevvqa6Q4srUhuibEetpU7
         ESGlSGsBMicQ61BtAwv8geSD44nENwzOgx3b1zRhDPB0zeU58AVQwrV4y3I3nN/QH5pb
         NBU4183pHhelr9HO4Zblz1xTxjLH0KB0inMv+npTHN9o6XcACftuCfk7lw91afWWBlBK
         AjlTqAo7TGCF/g8Rmo365xw2o+Qn9d5P9Vi8MC29afYqNU+uwXcGVxYzm5yUXmR0oNFn
         Q5QZVfgvnJC4Gy8jPSvhc2fo+g+rKz9sCbq92ajYOoW47rqPzYvIr9lIWQr4VsGa+0zN
         8Hxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ffo6sUekuwYvcpFuuo0C3lxP9xjET9MC56Nugypmn0w=;
        b=AlNB9skLkm/dnSh1xNqQvqF0M1hg1GPF6VqCQ2KBVzdfFHlthMHdC2lAJXvrIcyWvL
         WNW1nxyTox81KmdVnHjobDgvCWmG1462enHmPhRgIc5jEKRaJEOX9PRAIyvJrRt9dGZe
         ZJ1prX9bI/QzElcHABuOeZpXJMUjTu2vVSMJQV5Qk6MrZOvNTU1p3+YOR9Wsb2nwgrdl
         g7hhFJe8R1YvfsSVvkFiy6oHXd5dJGPe9UxgMmK029dlwZh4wUrtvwv9Ymtr5k3hrFzO
         KCSv3NiQYe30Zdb18i4pMuK9oCuSWZYNv+X7ydgjlJLdXvg6NqZbnG7jFUMH3AoHdNnI
         pn0Q==
X-Gm-Message-State: ACrzQf05q9awiCY4jsiNoScmTSbSakb0cnlht4vvUsxT+wSWziuStYp/
        XrpuU0c/yZ5TrvniobbnJlHO9xB95sA=
X-Google-Smtp-Source: AMsMyM5jaxowewA7C1Okl1jM7541exc+LamSX8QcMEwWMH8jCL8iIa8hDKAA4v/8kpkDl8Ln9vNupA==
X-Received: by 2002:a05:600c:22d6:b0:3cf:69fc:3046 with SMTP id 22-20020a05600c22d600b003cf69fc3046mr13871619wmg.5.1667392459912;
        Wed, 02 Nov 2022 05:34:19 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:2365])
        by smtp.gmail.com with ESMTPSA id y9-20020adffa49000000b002345cb2723esm12580226wrr.17.2022.11.02.05.34.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 05:34:19 -0700 (PDT)
Message-ID: <38291f08-7bc0-aa00-488d-639b20bb86bf@gmail.com>
Date:   Wed, 2 Nov 2022 12:33:25 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH 1/1] io_uring/net: introduce IORING_SEND_ZC_REPORT_USAGE
 flag
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
References: <cover.1666895626.git.metze@samba.org>
 <8945b01756d902f5d5b0667f20b957ad3f742e5e.1666895626.git.metze@samba.org>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8945b01756d902f5d5b0667f20b957ad3f742e5e.1666895626.git.metze@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/27/22 19:34, Stefan Metzmacher wrote:
> It might be useful for applications to detect if a zero copy
> transfer with SEND[MSG]_ZC was actually possible or not.
> The application can fallback to plain SEND[MSG] in order
> to avoid the overhead of two cqes per request.
> Or it can generate a log message that could indicate
> to an administrator that no zero copy was possible
> and could explain degraded performance.

Looks good,

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>



> Link: https://lore.kernel.org/io-uring/fb6a7599-8a9b-15e5-9b64-6cd9d01c6ff4@gmail.com/T/#m2b0d9df94ce43b0e69e6c089bdff0ce6babbdfaa
> Cc: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> ---
>   include/uapi/linux/io_uring.h | 18 ++++++++++++++++++
>   io_uring/net.c                |  6 +++++-
>   io_uring/notif.c              | 12 ++++++++++++
>   io_uring/notif.h              |  3 +++
>   4 files changed, 38 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index ab7458033ee3..423f98781a20 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -296,10 +296,28 @@ enum io_uring_op {
>    *
>    * IORING_RECVSEND_FIXED_BUF	Use registered buffers, the index is stored in
>    *				the buf_index field.
> + *
> + * IORING_SEND_ZC_REPORT_USAGE
> + *				If set, SEND[MSG]_ZC should report
> + *				the zerocopy usage in cqe.res
> + *				for the IORING_CQE_F_NOTIF cqe.
> + *				0 is reported if zerocopy was actually possible.
> + *				IORING_NOTIF_USAGE_ZC_COPIED if data was copied
> + *				(at least partially).
>    */
>   #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
>   #define IORING_RECV_MULTISHOT		(1U << 1)
>   #define IORING_RECVSEND_FIXED_BUF	(1U << 2)
> +#define IORING_SEND_ZC_REPORT_USAGE	(1U << 3)
> +
> +/*
> + * cqe.res for IORING_CQE_F_NOTIF if
> + * IORING_SEND_ZC_REPORT_USAGE was requested
> + *
> + * It should be treated as a flag, all other
> + * bits of cqe.res should be treated as reserved!
> + */
> +#define IORING_NOTIF_USAGE_ZC_COPIED    (1U << 31)
>   
>   /*
>    * accept flags stored in sqe->ioprio
> diff --git a/io_uring/net.c b/io_uring/net.c
> index 15dea91625e2..0a8cdc5ae7af 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -939,7 +939,8 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>   
>   	zc->flags = READ_ONCE(sqe->ioprio);
>   	if (zc->flags & ~(IORING_RECVSEND_POLL_FIRST |
> -			  IORING_RECVSEND_FIXED_BUF))
> +			  IORING_RECVSEND_FIXED_BUF |
> +			  IORING_SEND_ZC_REPORT_USAGE))
>   		return -EINVAL;
>   	notif = zc->notif = io_alloc_notif(ctx);
>   	if (!notif)
> @@ -957,6 +958,9 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>   		req->imu = READ_ONCE(ctx->user_bufs[idx]);
>   		io_req_set_rsrc_node(notif, ctx, 0);
>   	}
> +	if (zc->flags & IORING_SEND_ZC_REPORT_USAGE) {
> +		io_notif_to_data(notif)->zc_report = true;
> +	}
>   
>   	if (req->opcode == IORING_OP_SEND_ZC) {
>   		if (READ_ONCE(sqe->__pad3[0]))
> diff --git a/io_uring/notif.c b/io_uring/notif.c
> index e37c6569d82e..4bfef10161fa 100644
> --- a/io_uring/notif.c
> +++ b/io_uring/notif.c
> @@ -18,6 +18,10 @@ static void __io_notif_complete_tw(struct io_kiocb *notif, bool *locked)
>   		__io_unaccount_mem(ctx->user, nd->account_pages);
>   		nd->account_pages = 0;
>   	}
> +
> +	if (nd->zc_report && (nd->zc_copied || !nd->zc_used))
> +		notif->cqe.res |= IORING_NOTIF_USAGE_ZC_COPIED;
> +
>   	io_req_task_complete(notif, locked);
>   }
>   
> @@ -28,6 +32,13 @@ static void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
>   	struct io_notif_data *nd = container_of(uarg, struct io_notif_data, uarg);
>   	struct io_kiocb *notif = cmd_to_io_kiocb(nd);
>   
> +	if (nd->zc_report) {
> +		if (success && !nd->zc_used && skb)
> +			WRITE_ONCE(nd->zc_used, true);
> +		else if (!success && !nd->zc_copied)
> +			WRITE_ONCE(nd->zc_copied, true);
> +	}
> +
>   	if (refcount_dec_and_test(&uarg->refcnt)) {
>   		notif->io_task_work.func = __io_notif_complete_tw;
>   		io_req_task_work_add(notif);
> @@ -55,6 +66,7 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
>   	nd->account_pages = 0;
>   	nd->uarg.flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
>   	nd->uarg.callback = io_uring_tx_zerocopy_callback;
> +	nd->zc_report = nd->zc_used = nd->zc_copied = false;
>   	refcount_set(&nd->uarg.refcnt, 1);
>   	return notif;
>   }
> diff --git a/io_uring/notif.h b/io_uring/notif.h
> index 5b4d710c8ca5..4ae696273c78 100644
> --- a/io_uring/notif.h
> +++ b/io_uring/notif.h
> @@ -13,6 +13,9 @@ struct io_notif_data {
>   	struct file		*file;
>   	struct ubuf_info	uarg;
>   	unsigned long		account_pages;
> +	bool			zc_report;
> +	bool			zc_used;
> +	bool			zc_copied;
>   };
>   
>   void io_notif_flush(struct io_kiocb *notif);

-- 
Pavel Begunkov
