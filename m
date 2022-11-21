Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2BD632B0B
	for <lists+io-uring@lfdr.de>; Mon, 21 Nov 2022 18:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbiKURbs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Nov 2022 12:31:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbiKURbr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Nov 2022 12:31:47 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C00CB68E
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 09:31:46 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id p184so9101617iof.11
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 09:31:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dCzG/rE97QDksiVoED+SWkv21agj8B5Y20WBspVv9Pg=;
        b=rRXMN2UjfyEIf7/2GimpTl1iglVuqEaUcLvtz/aVMIYvH3TuTBrWYyXYz278zm/uEG
         SJSNvN+VAgOWp3XKDAO3i/63f+t+xOFM4ZJhZ2QL5oUgF7ZrKHCOcAGgxEJjSN9eVIYq
         Wp2yhHGoR6ejsTSa6bfyH3ZhQ899S62af1vxqUy+4g+ixV+0dPNtRazVugq/68pzlHoa
         zI9pI7TfwY9T/lN+W1Qi3dz0cEvFrKmjA97xq7L58RW9PrugZs4irQ/BD/Gl4wCVEIc8
         +XecsD2cDjVUgKkmrYoKCgnN5sNvm4nTFNx7ahaueTk+gGii1L4G6ykJ1bB1kxkhBuCn
         Qidg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dCzG/rE97QDksiVoED+SWkv21agj8B5Y20WBspVv9Pg=;
        b=w3ps8ZvZolL4IOGJ+MOvoHfUd9B93nb1AwUlfMI9owsxohlUkINE7WL49T9r0qgHSt
         aYjQvSyO6u+e4kzT5CRoqT8iEl1IOXYNtfaJw/YPbRnguHT0MqNJbKmxmM85q26eClms
         NLD75uQUx4/KsEt8lGBN1u8pNV64L6IvhMIx0YI/SA/wjVjHs2V8jLYt077srELesfTa
         hYlHgH8cTcZyW5Ubh9f7vHvNuTivYq0TGaAX3Zz64iNGHgnEndyBuDaSJ/NnGE/70CO8
         6mac+UG9pkhg8WBZXphw4ZwGyQmsKgnvCmhqB8w863q2NCnVsEYjDiXkj2cQ8nCqlZ5U
         Vzlg==
X-Gm-Message-State: ANoB5plE9PxIYrUygDN/q8Vd3OQdP8/e88p0dfaeQ4G9R46Q3rp0uxnr
        K7gXqdCqN1QAxdrvqc8NdOGsjw==
X-Google-Smtp-Source: AA0mqf5wVvOjBCs/0K890roXDi9ibb0xca9DlsC0j6EUy2GcNIXLcmHWa6Vlf2ahQc0Qf2DT+WYrng==
X-Received: by 2002:a6b:4114:0:b0:6d2:76f4:e041 with SMTP id n20-20020a6b4114000000b006d276f4e041mr10102ioa.11.1669051905311;
        Mon, 21 Nov 2022 09:31:45 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id z22-20020a056638215600b00375750e03fesm4427039jaj.81.2022.11.21.09.31.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 09:31:44 -0800 (PST)
Message-ID: <4708643a-b543-f762-363f-32ba03a67516@kernel.dk>
Date:   Mon, 21 Nov 2022 10:31:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH for-next 09/10] io_uring: allow io_post_aux_cqe to defer
 completion
To:     Dylan Yudaken <dylany@meta.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com
References: <20221121100353.371865-1-dylany@meta.com>
 <20221121100353.371865-10-dylany@meta.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20221121100353.371865-10-dylany@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/21/22 3:03?AM, Dylan Yudaken wrote:
> diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
> index afb543aab9f6..c5e831e3dcfc 100644
> --- a/io_uring/msg_ring.c
> +++ b/io_uring/msg_ring.c
> @@ -23,7 +23,7 @@ struct io_msg {
>  	u32 flags;
>  };
>  
> -static int io_msg_ring_data(struct io_kiocb *req)
> +static int io_msg_ring_data(struct io_kiocb *req, unsigned int issue_flags)
>  {
>  	struct io_ring_ctx *target_ctx = req->file->private_data;
>  	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
> @@ -31,7 +31,8 @@ static int io_msg_ring_data(struct io_kiocb *req)
>  	if (msg->src_fd || msg->dst_fd || msg->flags)
>  		return -EINVAL;
>  
> -	if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
> +	if (io_post_aux_cqe(target_ctx, false,
> +			    msg->user_data, msg->len, 0))
>  		return 0;
>  
>  	return -EOVERFLOW;
> @@ -116,7 +117,8 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
>  	 * completes with -EOVERFLOW, then the sender must ensure that a
>  	 * later IORING_OP_MSG_RING delivers the message.
>  	 */
> -	if (!io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
> +	if (!io_post_aux_cqe(target_ctx, false,
> +			     msg->user_data, msg->len, 0))
>  		ret = -EOVERFLOW;
>  out_unlock:
>  	io_double_unlock_ctx(ctx, target_ctx, issue_flags);
> @@ -153,7 +155,7 @@ int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags)
>  
>  	switch (msg->cmd) {
>  	case IORING_MSG_DATA:
> -		ret = io_msg_ring_data(req);
> +		ret = io_msg_ring_data(req, issue_flags);
>  		break;
>  	case IORING_MSG_SEND_FD:
>  		ret = io_msg_send_fd(req, issue_flags);

This is a bit odd, either we can drop this or it should be wired up for
defer?

-- 
Jens Axboe
