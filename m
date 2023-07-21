Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E26BB75CBB6
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 17:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbjGUP3W (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 11:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231947AbjGUP3V (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 11:29:21 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5178E3580
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 08:29:17 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id ca18e2360f4ac-77dcff76e35so29657439f.1
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 08:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689953356; x=1690558156;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+Jtor7wVKKNS5MffYiRyHgMXWkSZohtdTTdgJNdmVDU=;
        b=xEAHe0ukghvZo0tCv+eVYjjDykaj3iRP+0jpRYElUjWwhDUsDI6IHCM+UGflw+0KdF
         MHHNsYgi2cSvcZmvLeY1Nyrgj0KzN5l+2lp87/TLA5HYBhQ3kGnnugU6r7P2Iayw5UwM
         3jh9AWURrmJ/YVbWOLsM6GJgxsIKcSt+mvagtSxiSt7cDNFF1BpwDDMcDO8vGvrNA+hf
         mCbbu6v2PSO4TTENBgtLo3SzA7KjZSirF+ueXCYvHYHUkPB4eKdSOylvY1Ve7varVnDt
         etyltBVKEDzP2tXHXh0AVjho4k5G6uv0u8RmzWExzAqDTYlXCFpUtLI8PfHvQYr4DAq2
         Otlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689953356; x=1690558156;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+Jtor7wVKKNS5MffYiRyHgMXWkSZohtdTTdgJNdmVDU=;
        b=hOXUztPA50FMQjwlytgxhyM03u542oH/cYfn7NUaQSSPK1ZV8yV1p9OkQdlHHOh1l7
         gpckgYC7CFAzcJvHs1ooXxOIZvN7tCil5vYX6FsYLxwr1ljqjx32S6TBa5ozvALKCn2U
         WI6YUPCdU/mnOqLNnQ0QEJuoQqZ3dBuP7Ea0bW56ABWZ2w6g2b23qbGbYR91nOycMhrK
         Qf5M+Ve518etfLx+KKEOgJlYfa0T3yiDrXu7sPvf4dYbBybWdliXrT3mueze5+qF8cVD
         7pxLQyd1GDWX+ZwCzQLk3D65P5ps8iROvm1vEk7UVMHQ+aVbr2TQdxegqdm73/dub9sD
         m00Q==
X-Gm-Message-State: ABy/qLaRzrzaEpwMr/0FwzPq/PT5j7KPV5xrgufAfPXww9+o8bWDbVBV
        pGnC7MfiIaN4hvJXLFCDNwWtdaBiGBqfBQa3jvY=
X-Google-Smtp-Source: APBJJlEVGaNCKFR7+1cfV39/HjnyQ+uTcb2cHxXEki5jpiThdtmm0KnESMDy5qbAo0yDTUuiCnyBjQ==
X-Received: by 2002:a05:6602:3e87:b0:780:cb36:6f24 with SMTP id el7-20020a0566023e8700b00780cb366f24mr2123148iob.2.1689953356527;
        Fri, 21 Jul 2023 08:29:16 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id t18-20020a6b0912000000b00787496dad4bsm1123827ioi.49.2023.07.21.08.29.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jul 2023 08:29:15 -0700 (PDT)
Message-ID: <94b8fcc4-12b5-8d8c-3eb3-fe1e73a25456@kernel.dk>
Date:   Fri, 21 Jul 2023 09:29:14 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 06/10] io_uring: add support for futex wake and wait
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        andres@anarazel.de
References: <20230720221858.135240-1-axboe@kernel.dk>
 <20230720221858.135240-7-axboe@kernel.dk>
 <20230721113031.GG3630545@hirez.programming.kicks-ass.net>
 <20230721113718.GA3638458@hirez.programming.kicks-ass.net>
 <d95bfb98-8d76-f0fd-6283-efc01d0cc015@kernel.dk>
In-Reply-To: <d95bfb98-8d76-f0fd-6283-efc01d0cc015@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/21/23 8:43?AM, Jens Axboe wrote:
> On 7/21/23 5:37?AM, Peter Zijlstra wrote:
>> On Fri, Jul 21, 2023 at 01:30:31PM +0200, Peter Zijlstra wrote:
>>
>> Sorry, I was too quick..
>>
>> 	iof->uaddr = sqe->addr;
>> 	iof->val   = sqe->futex_val;
>> 	iof->mask  = sqe->futex_mask;
>> 	flags      = sqe->futex_flags;
>>
>> 	if (flags & ~FUTEX2_MASK)
>> 		return -EINVAL;
>>
>> 	iof->flags = futex2_to_flags(flags);
>> 	if (!futex_flags_valid(iof->flags))
>> 		return -EINVAL;
>>
>> 	if (!futex_validate_input(iof->flags, iof->val) ||
>> 	    !futex_validate_input(iof->flags, iof->mask))
>> 		return -EINVAL
> 
> Something like that should work, with some variable names fixed up. I
> just went with 'addr' for the futex address, addr2 for the value, and
> addr3 for the mask.
> 
> Rebased on top of your first 4 updated patches, and added a single patch
> that moves FUTEX2_MASK, will run some testing to validate it's all still
> sane.

FWIW, here's the io_uring incremental after that rebase. Update the
liburing futex branch as well, updating the prep helpers to take 64 bit
values for mask/val and also add the flags argument that was missing as
well. Only other addition was adding those 4 new patches instead of the
old 3 ones, and adding single patch that just moves FUTEX2_MASK to
futex.h.

All checks out fine, tests pass and it works.


diff --git a/io_uring/futex.c b/io_uring/futex.c
index 93df54dffaa0..4c9f2c841b98 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -18,11 +18,11 @@ struct io_futex {
 		u32 __user			*uaddr;
 		struct futex_waitv __user	*uwaitv;
 	};
-	unsigned int	futex_val;
-	unsigned int	futex_flags;
-	unsigned int	futex_mask;
-	unsigned int	futex_nr;
+	unsigned long	futex_val;
+	unsigned long	futex_mask;
 	unsigned long	futexv_owned;
+	u32		futex_flags;
+	unsigned int	futex_nr;
 };
 
 struct io_futex_data {
@@ -171,15 +171,28 @@ bool io_futex_remove_all(struct io_ring_ctx *ctx, struct task_struct *task,
 int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
+	u32 flags;
 
-	if (unlikely(sqe->fd || sqe->buf_index || sqe->addr3))
+	if (unlikely(sqe->fd || sqe->buf_index || sqe->file_index))
 		return -EINVAL;
 
 	iof->uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
-	iof->futex_val = READ_ONCE(sqe->len);
-	iof->futex_mask = READ_ONCE(sqe->file_index);
-	iof->futex_flags = READ_ONCE(sqe->futex_flags);
-	if (iof->futex_flags & FUTEX_CMD_MASK)
+	iof->futex_val = READ_ONCE(sqe->addr2);
+	iof->futex_mask = READ_ONCE(sqe->addr3);
+	iof->futex_nr = READ_ONCE(sqe->len);
+	if (iof->futex_nr && req->opcode != IORING_OP_FUTEX_WAITV)
+		return -EINVAL;
+
+	flags = READ_ONCE(sqe->futex_flags);
+	if (flags & ~FUTEX2_MASK)
+		return -EINVAL;
+
+	iof->futex_flags = futex2_to_flags(flags);
+	if (!futex_flags_valid(iof->futex_flags))
+		return -EINVAL;
+
+	if (!futex_validate_input(iof->futex_flags, iof->futex_val) ||
+	    !futex_validate_input(iof->futex_flags, iof->futex_mask))
 		return -EINVAL;
 
 	iof->futexv_owned = 0;
@@ -211,7 +224,6 @@ int io_futexv_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (ret)
 		return ret;
 
-	iof->futex_nr = READ_ONCE(sqe->off);
 	if (!iof->futex_nr || iof->futex_nr > FUTEX_WAITV_MAX)
 		return -EINVAL;
 

-- 
Jens Axboe

