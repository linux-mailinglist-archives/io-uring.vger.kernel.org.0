Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 751B15247C3
	for <lists+io-uring@lfdr.de>; Thu, 12 May 2022 10:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350586AbiELIUx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 May 2022 04:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235236AbiELIUw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 May 2022 04:20:52 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8DA52E0A2
        for <io-uring@vger.kernel.org>; Thu, 12 May 2022 01:20:50 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id n18so4203544plg.5
        for <io-uring@vger.kernel.org>; Thu, 12 May 2022 01:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:in-reply-to:content-transfer-encoding;
        bh=AjAp+/wLFGV0k5bBOaOSeUaKIS76zE7L2xzIKrjl2RA=;
        b=CCZoMT6XZCJnVcAO8A4a5oW+80tYszqiHLH9tOSOAlqst9Mc3F0wzCue6lSSfeTeYQ
         l3af7H4CiTMG7aM15HUVtWzdF9KmTBkoRT0eMEdTpOIv33KyE3tue4VIHGk49BVxWh2V
         0r/oX8nsOBjNSndJJIq53VIC8R7zOUwpTh7Cs+e7irJp/P4wJOpQFc63dGwVtELvs5c3
         1lOYVZS2ENISzieEmX05sNSDqlcXQAn//9CBqfLM/pyRo52WqFoBWlGFN6WX2hTPpVhL
         AB9wmrwOgwKkqIxAOrA2LZ+Iic6V3HQjnBbbqKQK2n/Bx6pq1Sy80Hfi/lLcbkp6D/fe
         M/Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=AjAp+/wLFGV0k5bBOaOSeUaKIS76zE7L2xzIKrjl2RA=;
        b=FpOk2VIt1nowc8RWpnSEYZJpPPNL3CnY7JCbc8Uc0uR9+OH+PnWfTv8cZ5dyfXdqSg
         YZLs5yAigCBLJefnH4hzj6aiUzeNBdsQA4MEPl99iCCWdQX9+iwXAGlrPOQT/nPEUB7U
         ILVysFJW6jr8fwRhxB6YoiaOJuZs33l/LShekAXnwDCctDun+aJJEXeeW2QAmtPShmE4
         XhFwgvdYRyZNQUM4DuZQN8splEWdVLuUR9IPYLcecthmI/ZSjYmLtPDgELTIieQoqcIh
         8MnVOb0iS+52WUGK+/6NE1241HIDEct4Crvqi7IHZXXt+Py09gR0pya7T6E/mMd3bBY1
         5xYg==
X-Gm-Message-State: AOAM532loYJqDdWR06whddSOJMUXVx81bTEPVHbmEPIm8OZ3MzW/Pks7
        xJPro71IedjSrRZTYSy8u4g=
X-Google-Smtp-Source: ABdhPJxeN52P5OgfPMk5osRUNWRadyb/PJRCFw1fm5j5MA+dQ//YYYu1ME42ygEVnMETWkkoquaziA==
X-Received: by 2002:a17:902:dac5:b0:15e:8ba0:a73d with SMTP id q5-20020a170902dac500b0015e8ba0a73dmr28903147plx.22.1652343650436;
        Thu, 12 May 2022 01:20:50 -0700 (PDT)
Received: from [192.168.255.10] ([106.53.4.151])
        by smtp.gmail.com with ESMTPSA id t3-20020aa79463000000b0050dc7628159sm3121034pfq.51.2022.05.12.01.20.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 01:20:50 -0700 (PDT)
Message-ID: <e2b53efa-32d5-4732-bce3-c8b8d55ec0b9@gmail.com>
Date:   Thu, 12 May 2022 16:21:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
From:   Hao Xu <haoxu.linux@gmail.com>
Subject: Re: [PATCH 3/6] io_uring: allow allocated fixed files for
 openat/openat2
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220509155055.72735-1-axboe@kernel.dk>
 <20220509155055.72735-4-axboe@kernel.dk>
In-Reply-To: <20220509155055.72735-4-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2022/5/9 下午11:50, Jens Axboe 写道:
> If the application passes in IORING_FILE_INDEX_ALLOC as the file_slot,
> then that's a hint to allocate a fixed file descriptor rather than have
> one be passed in directly.
> 
> This can be useful for having io_uring manage the direct descriptor space.
> 
> Normal open direct requests will complete with 0 for success, and < 0
> in case of error. If io_uring is asked to allocated the direct descriptor,
> then the direct descriptor is returned in case of success.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   fs/io_uring.c                 | 32 +++++++++++++++++++++++++++++---
>   include/uapi/linux/io_uring.h |  9 +++++++++
>   2 files changed, 38 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 8c40411a7e78..ef999d0e09de 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4697,7 +4697,7 @@ static int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>   	return __io_openat_prep(req, sqe);
>   }
>   
> -static int __maybe_unused io_file_bitmap_get(struct io_ring_ctx *ctx)
> +static int io_file_bitmap_get(struct io_ring_ctx *ctx)
>   {
>   	struct io_file_table *table = &ctx->file_table;
>   	unsigned long nr = ctx->nr_user_files;
> @@ -4722,6 +4722,32 @@ static int __maybe_unused io_file_bitmap_get(struct io_ring_ctx *ctx)
>   	return -ENFILE;
>   }
>   
> +static int io_fixed_fd_install(struct io_kiocb *req, unsigned int issue_flags,
> +			       struct file *file, unsigned int file_slot)
> +{
> +	int alloc_slot = file_slot == IORING_FILE_INDEX_ALLOC;
> +	struct io_ring_ctx *ctx = req->ctx;
> +	int ret;
> +
> +	if (alloc_slot) {
> +		io_ring_submit_lock(ctx, issue_flags);
> +		file_slot = io_file_bitmap_get(ctx);
> +		if (unlikely(file_slot < 0)) {
> +			io_ring_submit_unlock(ctx, issue_flags);
> +			return file_slot;
> +		}
> +	}

if (alloc_slot) {
  ...
} else {
         file_slot -= 1;
}

Otherwise there is off-by-one error.

Others looks good,

Reviewed-by: Hao Xu <howeyxu@tencent.com>

