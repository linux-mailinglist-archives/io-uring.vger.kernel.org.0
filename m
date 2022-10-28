Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F451611279
	for <lists+io-uring@lfdr.de>; Fri, 28 Oct 2022 15:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiJ1NO4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Oct 2022 09:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbiJ1NOy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Oct 2022 09:14:54 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7148B1F60D
        for <io-uring@vger.kernel.org>; Fri, 28 Oct 2022 06:14:48 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id k8so6587590wrh.1
        for <io-uring@vger.kernel.org>; Fri, 28 Oct 2022 06:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2SIh3pOgy8pMx0cRMNCz/Hn9jbl+NCWXHAK/FwcOQr8=;
        b=hlcok/JXbjb1YDfdnvidkSy+sskRMbJcloQQcAiad4p+oltRYiu/MvuNdMPqpnFRvP
         oEY5FFPdfIAtaml2yJWfrD/zaJlpd87olV31vkaMLqkg470oxTU3ufTEeN4l82bnM3K5
         rtVej4TheGbsMIeKHodL/LFWUqY6CIkFD4jBeWtqvePp/QUNIer1H5HcB7Oa+Y14sReA
         z6wcDVG3cNCvQwAo/6WTO4mIuU+RxiW3++nbnQSHJwa5RiOyJfkOHaKKaBDT1v1duO4w
         hwGqhV0jzAWg+4BZSmZ9zutEJ+LEPaujZgPErRVfVP1EX0W7XbFeJBIzxMOYe/uI3I5x
         y23Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2SIh3pOgy8pMx0cRMNCz/Hn9jbl+NCWXHAK/FwcOQr8=;
        b=Mwyy0PRKzrpnkjUWLgc+GtkPRS1uSV7DN0hPxY4qKvswiv4JgFdCVunu9d5d5xb8sZ
         /pul9XjQ4NHJVgyJ0coSb9r3F7ZbpMFQ+0RWgz6IcF0uj+ell4aK8h1qWY4g9StSRVT+
         Nk2oeb58V8nIwPWuwd4t7WKjpsO74JolZ8n/5H+m/WXtyi3rpyiEQE/JVBhjL1vwE/2s
         9ztI/R08l9vQVydmDJLqQMCTheVEk5coe1fWX9Or1y7TNqH/iY/bHvh69xp/bMFzJlp2
         QpBPshxcdk0mAD4NLZJmyOBkyDw9Ma7YQBgcb2Fl6bxcdOidYZT0dn03A92zYmN29jem
         S/Xw==
X-Gm-Message-State: ACrzQf0kSmfbov6w5RsEcKZIcVvZe7A6LaywCqW6ue4bcNXISifi9VGY
        N0ajZxj2tLI3ejNYdxKof6S0k2Zsdtb3vg==
X-Google-Smtp-Source: AMsMyM6Ke6Fcp0XxHK/D1pnp2cCDTo9p/PF4F8m6EyL1qk7NGymReqdGX1yrVquP3t6YWGxXHXw0AA==
X-Received: by 2002:adf:e385:0:b0:236:91a6:bd1b with SMTP id e5-20020adfe385000000b0023691a6bd1bmr6628827wrm.278.1666962886848;
        Fri, 28 Oct 2022 06:14:46 -0700 (PDT)
Received: from [192.168.43.77] (82-132-219-192.dab.02.net. [82.132.219.192])
        by smtp.gmail.com with ESMTPSA id a5-20020adffb85000000b002366fb99cdasm3609208wrr.50.2022.10.28.06.14.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Oct 2022 06:14:46 -0700 (PDT)
Message-ID: <9900e8b5-6dbb-9423-7020-0a2b5297fe1f@gmail.com>
Date:   Fri, 28 Oct 2022 14:12:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH 1/1] io_uring/net: introduce IORING_SEND_ZC_REPORT_USAGE
 flag
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
References: <cover.1666895626.git.metze@samba.org>
 <8945b01756d902f5d5b0667f20b957ad3f742e5e.1666895626.git.metze@samba.org>
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

 From a quick look seems good, I'll test and double check
when I'm back on tuesday


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
