Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DABFB59BE0F
	for <lists+io-uring@lfdr.de>; Mon, 22 Aug 2022 13:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbiHVLC2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Aug 2022 07:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233920AbiHVLC1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Aug 2022 07:02:27 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0431632062;
        Mon, 22 Aug 2022 04:02:26 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id v7-20020a1cac07000000b003a6062a4f81so7557305wme.1;
        Mon, 22 Aug 2022 04:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=KQdaH+y51iTAZBH9HoOQfzAnclEGsM3F+rfp9wcD55I=;
        b=BJEMwh3q/lfpdveUKLdRQd8P7/Yinf5jUaTsExSR07VwplkT4lTrfHlNFd16/hGYN4
         nFnI9glnzwdWUAN9h0Nx2GnBmno9+rbKqPQ3/aYUCSGsnXJd5cciIHK9XCM4hF4KLZyi
         ScoRM1EMREdLURYBWVQm6pMADh9NoOUFRi9kTgFHWCTtS5REufvZEswZWsrr0mWpTp7u
         bbLh10jhXdkTJ9D7C1+PRAYuaMglgZzC8rxpZCF/fXtCP6aHu1G/2Yy8UGC71kyWbVK0
         91RPAH/UQt2f1peUuW2on6ihtZXVEsV4OvgOSSNkP4+jY+KYIUGE27MPCcEhNhk/Nrpv
         mZNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=KQdaH+y51iTAZBH9HoOQfzAnclEGsM3F+rfp9wcD55I=;
        b=p1AYn5DDWFdfYgKfOeD6C+yxO52sRAA6rWvE6LP6FiuRnRhp45hAJJEcb/A5erT/NY
         DDP+YKvFoXpGawEV0p+avDzTePQv2MHPETezGHcnPDcxzssfoil2g3fJmEs4v0S7F5xc
         nNSf6tLZpVtRgGhGSFu+knqEtLGURRiGCKhK9OWdNVOAuRl0ehZLzfojcNEmLfEWKAcq
         i78Vk4WTLr9UUARf0a8DQy8gkqBGCcDcGa/6T1dNwr5+AJyHDi38n/M/eN45H7/Uw1/J
         +chDfYmNbQNX2oIAotUpwihOuZ9praA2dSi0+Y362ZuyhuWx/t7RNNz7MVlMf3ogmSmy
         QwDQ==
X-Gm-Message-State: ACgBeo2Df6jGzty33FPgNeTjIR8o7ye3Jdg/dObjP0m8KPtxz8aABlMs
        EUm79vtSEJ8l5c7k7OU/2oo=
X-Google-Smtp-Source: AA6agR63qfL/hLf7eY7bLV5bv3fgRsHmScWk0OvZL+qsmIwKAtBhtx7zsPhdTvFy1A8XLNRGyrun1g==
X-Received: by 2002:a1c:7916:0:b0:3a6:3540:5b3c with SMTP id l22-20020a1c7916000000b003a635405b3cmr8858346wme.178.1661166144340;
        Mon, 22 Aug 2022 04:02:24 -0700 (PDT)
Received: from [192.168.8.198] (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id a17-20020adffb91000000b002207a0b93b4sm11302657wrr.49.2022.08.22.04.02.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Aug 2022 04:02:23 -0700 (PDT)
Message-ID: <3294f1e9-1946-2fbf-d5cd-fcdff9288f72@gmail.com>
Date:   Mon, 22 Aug 2022 11:58:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH for-next 2/4] io_uring: introduce fixed buffer support for
 io_uring_cmd
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk, hch@lst.de,
        kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, ming.lei@redhat.com,
        gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
References: <20220819103021.240340-1-joshi.k@samsung.com>
 <CGME20220819104038epcas5p265c9385cfd9189d20ebfffeaa4d5efae@epcas5p2.samsung.com>
 <20220819103021.240340-3-joshi.k@samsung.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220819103021.240340-3-joshi.k@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/19/22 11:30, Kanchan Joshi wrote:
> From: Anuj Gupta <anuj20.g@samsung.com>
> 
> Add IORING_OP_URING_CMD_FIXED opcode that enables sending io_uring
> command with previously registered buffers. User-space passes the buffer
> index in sqe->buf_index, same as done in read/write variants that uses
> fixed buffers.
> 
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> ---
>   include/linux/io_uring.h      |  5 ++++-
>   include/uapi/linux/io_uring.h |  1 +
>   io_uring/opdef.c              | 10 ++++++++++
>   io_uring/rw.c                 |  3 ++-
>   io_uring/uring_cmd.c          | 18 +++++++++++++++++-
>   5 files changed, 34 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
> index 60aba10468fc..40961d7c3827 100644
> --- a/include/linux/io_uring.h
> +++ b/include/linux/io_uring.h
> @@ -5,6 +5,8 @@
>   #include <linux/sched.h>
>   #include <linux/xarray.h>
>   
> +#include<uapi/linux/io_uring.h>
> +
>   enum io_uring_cmd_flags {
>   	IO_URING_F_COMPLETE_DEFER	= 1,
>   	IO_URING_F_UNLOCKED		= 2,
> @@ -15,6 +17,7 @@ enum io_uring_cmd_flags {
>   	IO_URING_F_SQE128		= 4,
>   	IO_URING_F_CQE32		= 8,
>   	IO_URING_F_IOPOLL		= 16,
> +	IO_URING_F_FIXEDBUFS		= 32,
>   };
>   
>   struct io_uring_cmd {
> @@ -33,7 +36,7 @@ struct io_uring_cmd {
>   
>   #if defined(CONFIG_IO_URING)
>   int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
> -		struct iov_iter *iter, void *ioucmd)
> +		struct iov_iter *iter, void *ioucmd);

Please try to compile the first patch separately

>   void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2);
>   void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
>   			void (*task_work_cb)(struct io_uring_cmd *));
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 1463cfecb56b..80ea35d1ed5c 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -203,6 +203,7 @@ enum io_uring_op {
>   	IORING_OP_SOCKET,
>   	IORING_OP_URING_CMD,
>   	IORING_OP_SENDZC_NOTIF,
> +	IORING_OP_URING_CMD_FIXED,

I don't think it should be another opcode, is there any
control flags we can fit it in?


>   	/* this goes last, obviously */
>   	IORING_OP_LAST,
> diff --git a/io_uring/opdef.c b/io_uring/opdef.c
> index 9a0df19306fe..7d5731b84c92 100644
> --- a/io_uring/opdef.c
> +++ b/io_uring/opdef.c
> @@ -472,6 +472,16 @@ const struct io_op_def io_op_defs[] = {
>   		.issue			= io_uring_cmd,
>   		.prep_async		= io_uring_cmd_prep_async,
>   	},
> +	[IORING_OP_URING_CMD_FIXED] = {
> +		.needs_file		= 1,
> +		.plug			= 1,
> +		.name			= "URING_CMD_FIXED",
> +		.iopoll			= 1,
> +		.async_size		= uring_cmd_pdu_size(1),
> +		.prep			= io_uring_cmd_prep,
> +		.issue			= io_uring_cmd,
> +		.prep_async		= io_uring_cmd_prep_async,
> +	},
>   	[IORING_OP_SENDZC_NOTIF] = {
>   		.name			= "SENDZC_NOTIF",
>   		.needs_file		= 1,
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 1a4fb8a44b9a..3c7b94bffa62 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -1005,7 +1005,8 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
>   		if (READ_ONCE(req->iopoll_completed))
>   			break;
>   
> -		if (req->opcode == IORING_OP_URING_CMD) {
> +		if (req->opcode == IORING_OP_URING_CMD ||
> +				req->opcode == IORING_OP_URING_CMD_FIXED) {

I don't see the changed chunk upstream

>   			struct io_uring_cmd *ioucmd = (struct io_uring_cmd *)rw;
>   
>   			ret = req->file->f_op->uring_cmd_iopoll(ioucmd);
[...]

-- 
Pavel Begunkov
