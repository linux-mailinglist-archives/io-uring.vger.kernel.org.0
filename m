Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38AB0761ACA
	for <lists+io-uring@lfdr.de>; Tue, 25 Jul 2023 15:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbjGYN5l (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Jul 2023 09:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbjGYN5c (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Jul 2023 09:57:32 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45CA2106
        for <io-uring@vger.kernel.org>; Tue, 25 Jul 2023 06:57:30 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1b867f9198dso10978755ad.0
        for <io-uring@vger.kernel.org>; Tue, 25 Jul 2023 06:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690293450; x=1690898250;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qvj5gOVjt2yR6l6DvqXEZUSm5kz7/R15spF7yjIfTdw=;
        b=rrQU5bvPrC9qO6/XD3PjlCUmbJ+WByGqOA5v1lxHxoLDKIKEWPpmWaKdBfXWTzvlUY
         pLVEmpBU3K7Ceq/yQ4xozdapGPazLbWVRh4NvaSKk4xL6zzNzIK+fkLQ0kWCAGbwrHJt
         F7DZ01M1sj1sW2ui2BKyc61qBsNAAHrfvu14NgNrKQ5Bj7ALhqFfXZE9hEzLkatp602M
         bG7lvFygFItXOeyXNSqb3wcN5PYSwb+NtLNzKNRbWp343zd1rvwE/sXeh3syjYNYrWIE
         tFgj7Pb9mzuQWhAmjO7gUClVS+HXjanrU2lRu2ks5lisZgkhVCR1AoIc2hA/VNyGCcK6
         KZ2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690293450; x=1690898250;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qvj5gOVjt2yR6l6DvqXEZUSm5kz7/R15spF7yjIfTdw=;
        b=I8OLHjjUfbEDIegdh1UJVhSSI0yEteMqAl4O8YuAPDyWxKK4MbB+04DIlfY3J+kbAV
         eDDCDSQNjMUuRPI8Zq+VdRg0TIsIBxt+qpYeYwEsLqtukPLIl//a0uuZYKLsza+FeJlm
         sYEu2PpBEmVKyRoDif/ry+9qgkyLcnzaNAOpVcyZ/Dnd8Fxr5rZ3MtjyX8nH/PR3ObFs
         GPcPEplebJUzrE78Zb6MiAb+tVqAPGMjDf9ZCg/fv57Womhm0UOzyV2r0J3GaFE5igAN
         mFqNACLud2ZEj2imK6jWzSyZdjyYLOy8wS0K2kD73pcURETfOwtpLVN5M/k3SYGI87RM
         mnig==
X-Gm-Message-State: ABy/qLZiVqMXEkteiYadDHnYtWUNJhQZTTFJBpkzyPpEq+ChPSSoPjBu
        D9evmYYvU5PBX1wWEJNRjYemTL5Ws/RUIwWc0N8=
X-Google-Smtp-Source: APBJJlFcmE47gcbUYzvlmdBFhNhJf6SowsYT94oUfjYOkmgBEi9+hb/k2cp1BjFd/18S68L3c66ppA==
X-Received: by 2002:a17:902:ce92:b0:1b8:1591:9f81 with SMTP id f18-20020a170902ce9200b001b815919f81mr16614934plg.4.1690293449811;
        Tue, 25 Jul 2023 06:57:29 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y1-20020a170902b48100b001b86492d724sm11105189plr.223.2023.07.25.06.57.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jul 2023 06:57:29 -0700 (PDT)
Message-ID: <9a197037-4732-c524-2eb9-250ef7175a82@kernel.dk>
Date:   Tue, 25 Jul 2023 07:57:28 -0600
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
In-Reply-To: <28a42d23-6d70-bc4c-5abc-0b3cc5d7338d@kernel.dk>
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

On 7/25/23 7:48?AM, Jens Axboe wrote:
> On 7/25/23 7:00?AM, Peter Zijlstra wrote:
>> On Fri, Jul 21, 2023 at 09:29:14AM -0600, Jens Axboe wrote:
>>
>>> FWIW, here's the io_uring incremental after that rebase. Update the
>>> liburing futex branch as well, updating the prep helpers to take 64 bit
>>> values for mask/val and also add the flags argument that was missing as
>>> well. Only other addition was adding those 4 new patches instead of the
>>> old 3 ones, and adding single patch that just moves FUTEX2_MASK to
>>> futex.h.
>>>
>>> All checks out fine, tests pass and it works.
>>>
>>>
>>> diff --git a/io_uring/futex.c b/io_uring/futex.c
>>> index 93df54dffaa0..4c9f2c841b98 100644
>>> --- a/io_uring/futex.c
>>> +++ b/io_uring/futex.c
>>> @@ -18,11 +18,11 @@ struct io_futex {
>>>  		u32 __user			*uaddr;
>>>  		struct futex_waitv __user	*uwaitv;
>>>  	};
>>> +	unsigned long	futex_val;
>>> +	unsigned long	futex_mask;
>>>  	unsigned long	futexv_owned;
>>> +	u32		futex_flags;
>>> +	unsigned int	futex_nr;
>>>  };
>>>  
>>>  struct io_futex_data {
>>> @@ -171,15 +171,28 @@ bool io_futex_remove_all(struct io_ring_ctx *ctx, struct task_struct *task,
>>>  int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>  {
>>>  	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
>>> +	u32 flags;
>>>  
>>> +	if (unlikely(sqe->fd || sqe->buf_index || sqe->file_index))
>>>  		return -EINVAL;
>>>  
>>>  	iof->uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
>>> +	iof->futex_val = READ_ONCE(sqe->addr2);
>>> +	iof->futex_mask = READ_ONCE(sqe->addr3);
>>> +	iof->futex_nr = READ_ONCE(sqe->len);
>>> +	if (iof->futex_nr && req->opcode != IORING_OP_FUTEX_WAITV)
>>> +		return -EINVAL;
>>> +
>>
>> Hmm, would something like:
>>
>> 	if (req->opcode == IORING_OP_FUTEX_WAITV) {
>> 		if (iof->futex_val && iof->futex_mask)
>> 			return -EINVAL;
>>
>> 		/* sys_futex_waitv() doesn't take @flags as of yet */
>> 		if (iof->futex_flags)
>> 			return -EINVAL;
>>
>> 		if (!iof->futex_nr)
>> 			return -EINVAL;
>>
>> 	} else {
>> 		/* sys_futex_{wake,wait}() don't take @nr */
>> 		if (iof->futex_nr)
>> 			return -EINVAL;
>>
>> 		/* both take @flags and @mask */
>> 		flags = READ_ONCE(sqe->futex_flags);
>> 		if (flags & ~FUTEX2_MASK)
>> 			return -EINVAL;
>>
>> 		iof->futex_flags = futex2_to_flags(flags);
>> 		if (!futex_flags_valid(iof->futex_flags))
>> 			return -EINVAL;
>>
>> 		if (!futex_validate_input(iof->futex_flags, iof->futex_mask))
>> 			return -EINVAL;
>>
>> 		/* sys_futex_wait() takes @val */
>> 		if (req->iocode == IORING_OP_FUTEX_WAIT) {
>> 			if (!futex_validate_input(iof->futex_flags, iof->futex_val))
>> 				return -EINVAL;
>> 		} else {
>> 			if (iof->futex_val)
>> 				return -EINVAL;
>> 		}
>> 	}
>>
>> work? The waitv thing is significantly different from the other two.
> 
> I think I'll just have prep and prepv totally separate. It only makes
> sense to share parts of them if one is a subset of the other. That'll
> get rid of the odd conditionals and sectioning of it.

Something like the below - totally untested, but just to show what I
mean. Will need to get split and folded into the two separate patches.
Will test and fold them later today.


diff --git a/io_uring/futex.c b/io_uring/futex.c
index 4c9f2c841b98..b0f90154d974 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -168,7 +168,7 @@ bool io_futex_remove_all(struct io_ring_ctx *ctx, struct task_struct *task,
 	return found;
 }
 
-int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+static int __io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
 	u32 flags;
@@ -179,9 +179,6 @@ int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	iof->uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	iof->futex_val = READ_ONCE(sqe->addr2);
 	iof->futex_mask = READ_ONCE(sqe->addr3);
-	iof->futex_nr = READ_ONCE(sqe->len);
-	if (iof->futex_nr && req->opcode != IORING_OP_FUTEX_WAITV)
-		return -EINVAL;
 
 	flags = READ_ONCE(sqe->futex_flags);
 	if (flags & ~FUTEX2_MASK)
@@ -191,14 +188,36 @@ int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (!futex_flags_valid(iof->futex_flags))
 		return -EINVAL;
 
-	if (!futex_validate_input(iof->futex_flags, iof->futex_val) ||
-	    !futex_validate_input(iof->futex_flags, iof->futex_mask))
+	if (!futex_validate_input(iof->futex_flags, iof->futex_mask))
 		return -EINVAL;
 
-	iof->futexv_owned = 0;
 	return 0;
 }
 
+int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
+	int ret;
+
+	if (unlikely(sqe->len))
+		return -EINVAL;
+
+	ret = __io_futex_prep(req, sqe);
+	if (ret)
+		return ret;
+
+	/* sys_futex_wait() takes @val */
+	if (req->opcode == IORING_OP_FUTEX_WAIT) {
+		if (!futex_validate_input(iof->futex_flags, iof->futex_val))
+			return -EINVAL;
+	} else {
+		if (iof->futex_val)
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
 static void io_futex_wakev_fn(struct wake_q_head *wake_q, struct futex_q *q)
 {
 	struct io_kiocb *req = q->wake_data;
@@ -220,10 +239,15 @@ int io_futexv_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	struct futex_vector *futexv;
 	int ret;
 
-	ret = io_futex_prep(req, sqe);
+	ret = __io_futex_prep(req, sqe);
 	if (ret)
 		return ret;
 
+	/* No flags supported for waitv */
+	if (iof->futex_flags)
+		return -EINVAL;
+
+	iof->futex_nr = READ_ONCE(sqe->len);
 	if (!iof->futex_nr || iof->futex_nr > FUTEX_WAITV_MAX)
 		return -EINVAL;
 
@@ -238,6 +262,7 @@ int io_futexv_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return ret;
 	}
 
+	iof->futexv_owned = 0;
 	req->flags |= REQ_F_ASYNC_DATA;
 	req->async_data = futexv;
 	return 0;


-- 
Jens Axboe

