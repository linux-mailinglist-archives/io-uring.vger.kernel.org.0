Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C57F762448
	for <lists+io-uring@lfdr.de>; Tue, 25 Jul 2023 23:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjGYVYf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Jul 2023 17:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjGYVYe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Jul 2023 17:24:34 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01B71FC4
        for <io-uring@vger.kernel.org>; Tue, 25 Jul 2023 14:24:32 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1b867f9198dso11706215ad.0
        for <io-uring@vger.kernel.org>; Tue, 25 Jul 2023 14:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690320272; x=1690925072;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qOwYhJqUq3D663PZgGRKI9AwUgB7kco5aTPJuVz2jM8=;
        b=T9+ZPl9/0tvDMUzT9Qz/Q2qYTagxybCNzCvcrJHrK0Z7jl1FNa9B1DsbqsGbzcfsIq
         Wio5R3fISiDCcsqkIOC3D+G490z/P71YTO6xie7bgXcG+mRIsH1GAv/GsUkUc/GDX+iM
         HGhuTMA9RTPaAInNJQfXvGmY1UymyOQV94GfnjeVH0e0aQ2nOKl0nA19KpuREqKYH8oe
         QR9e5aEyqS8gzBlojWjc53/IivuSH6wW+qp1ELdrVynTWpTq04Oo8Cwz4vr15W4FaQsZ
         RnLQVc2jgHUTiBG070OO00xgH+ptoWz6WzrG9N2pNg1S7Fn8bx0f7Psgt1gcd9r89ZtK
         wacQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690320272; x=1690925072;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qOwYhJqUq3D663PZgGRKI9AwUgB7kco5aTPJuVz2jM8=;
        b=WcjALZrztU8GbGMbNmAomKQenPBH2YHgYT8xV3pBy1x5GWhU1+euPDKini0zsl943S
         KS96FO04zlHCOFS3VLXMmOSTXdkmaXugNv530JuE2b89ZtNccwzskaxfDJS6kcCJi/0I
         smBcUWuchhbHtTo7U511pU5MQNnzBpVApZzLDKel27wOPNP1SR+l++6J4WGJVGed0rgJ
         GA2swI9Xj4BTkfK7pUp03448ZLUmner+2p5RfcB0RVn/QY35/3DZnmghMs5sehA6fSkq
         mpAs9yZXuhtIGKjy1GEOiY58Omg/mBGzzMl2TB1DAf7CdphTey08BbFVQb0l1PQSkXqp
         dCpw==
X-Gm-Message-State: ABy/qLbYWBQTgrHwOpIHTBFN3ADq7Xw0MeIjx+Y/b9WZ3SddNmWFUf/E
        dl+g8aTCjrbpM7DEupounGfusHXiKvkjWemjBo4=
X-Google-Smtp-Source: APBJJlG7TkPzcrMBGkjgwzK5p/lgqRVZou7FiQ7zGUbGbapfzthrBdbYTD6lHekcLlEn7WUee66umQ==
X-Received: by 2002:a17:902:da82:b0:1b8:811:b079 with SMTP id j2-20020a170902da8200b001b80811b079mr496471plx.0.1690320272274;
        Tue, 25 Jul 2023 14:24:32 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id m9-20020a170902768900b001a80ad9c599sm11431754pll.294.2023.07.25.14.24.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jul 2023 14:24:31 -0700 (PDT)
Message-ID: <9b6522bc-314e-d663-a035-c4614b21b756@kernel.dk>
Date:   Tue, 25 Jul 2023 15:24:30 -0600
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
 <94b8fcc4-12b5-8d8c-3eb3-fe1e73a25456@kernel.dk>
 <20230725130015.GI3765278@hirez.programming.kicks-ass.net>
 <28a42d23-6d70-bc4c-5abc-0b3cc5d7338d@kernel.dk>
 <9a197037-4732-c524-2eb9-250ef7175a82@kernel.dk>
 <20230725151909.GT4253@hirez.programming.kicks-ass.net>
 <24a8a74a-e218-6105-ee97-02f60b1523bb@kernel.dk>
In-Reply-To: <24a8a74a-e218-6105-ee97-02f60b1523bb@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/25/23 2:42?PM, Jens Axboe wrote:
> On 7/25/23 9:19?AM, Peter Zijlstra wrote:
>> On Tue, Jul 25, 2023 at 07:57:28AM -0600, Jens Axboe wrote:
>>
>>> Something like the below - totally untested, but just to show what I
>>> mean. Will need to get split and folded into the two separate patches.
>>> Will test and fold them later today.
>>>
>>>
>>> diff --git a/io_uring/futex.c b/io_uring/futex.c
>>> index 4c9f2c841b98..b0f90154d974 100644
>>> --- a/io_uring/futex.c
>>> +++ b/io_uring/futex.c
>>> @@ -168,7 +168,7 @@ bool io_futex_remove_all(struct io_ring_ctx *ctx, struct task_struct *task,
>>>  	return found;
>>>  }
>>>  
>>> -int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>> +static int __io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>  {
>>>  	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
>>>  	u32 flags;
>>> @@ -179,9 +179,6 @@ int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>  	iof->uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
>>>  	iof->futex_val = READ_ONCE(sqe->addr2);
>>>  	iof->futex_mask = READ_ONCE(sqe->addr3);
>>> -	iof->futex_nr = READ_ONCE(sqe->len);
>>> -	if (iof->futex_nr && req->opcode != IORING_OP_FUTEX_WAITV)
>>> -		return -EINVAL;
>>>  
>>>  	flags = READ_ONCE(sqe->futex_flags);
>>>  	if (flags & ~FUTEX2_MASK)
>>> @@ -191,14 +188,36 @@ int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>  	if (!futex_flags_valid(iof->futex_flags))
>>>  		return -EINVAL;
>>>  
>>> -	if (!futex_validate_input(iof->futex_flags, iof->futex_val) ||
>>> -	    !futex_validate_input(iof->futex_flags, iof->futex_mask))
>>> +	if (!futex_validate_input(iof->futex_flags, iof->futex_mask))
>>>  		return -EINVAL;
>>>  
>>> -	iof->futexv_owned = 0;
>>>  	return 0;
>>>  }
>>
>> I think you can/should split more into io_futex_prep(), specifically
>> waitv should also have zero @val and @mask.
> 
> Yep, I'll include that. Updating them now...

It ends up just being this incremental for the very last patch, moving
all the waitv related prep to the wait prep and not relying on the
non-vectored one at all.


diff --git a/io_uring/futex.c b/io_uring/futex.c
index 4c9f2c841b98..e885aac12df8 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -179,9 +179,6 @@ int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	iof->uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	iof->futex_val = READ_ONCE(sqe->addr2);
 	iof->futex_mask = READ_ONCE(sqe->addr3);
-	iof->futex_nr = READ_ONCE(sqe->len);
-	if (iof->futex_nr && req->opcode != IORING_OP_FUTEX_WAITV)
-		return -EINVAL;
 
 	flags = READ_ONCE(sqe->futex_flags);
 	if (flags & ~FUTEX2_MASK)
@@ -195,7 +192,6 @@ int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	    !futex_validate_input(iof->futex_flags, iof->futex_mask))
 		return -EINVAL;
 
-	iof->futexv_owned = 0;
 	return 0;
 }
 
@@ -220,10 +216,13 @@ int io_futexv_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	struct futex_vector *futexv;
 	int ret;
 
-	ret = io_futex_prep(req, sqe);
-	if (ret)
-		return ret;
+	/* No flags or mask supported for waitv */
+	if (unlikely(sqe->fd || sqe->buf_index || sqe->file_index ||
+		     sqe->addr2 || sqe->addr3))
+		return -EINVAL;
 
+	iof->uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	iof->futex_nr = READ_ONCE(sqe->len);
 	if (!iof->futex_nr || iof->futex_nr > FUTEX_WAITV_MAX)
 		return -EINVAL;
 
@@ -238,6 +237,7 @@ int io_futexv_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return ret;
 	}
 
+	iof->futexv_owned = 0;
 	req->flags |= REQ_F_ASYNC_DATA;
 	req->async_data = futexv;
 	return 0;

-- 
Jens Axboe

