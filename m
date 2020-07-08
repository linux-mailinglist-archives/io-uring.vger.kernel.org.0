Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93B7F218BF6
	for <lists+io-uring@lfdr.de>; Wed,  8 Jul 2020 17:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730315AbgGHPni (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jul 2020 11:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730545AbgGHPlq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jul 2020 11:41:46 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E74C061A0B
        for <io-uring@vger.kernel.org>; Wed,  8 Jul 2020 08:41:46 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id c16so47483323ioi.9
        for <io-uring@vger.kernel.org>; Wed, 08 Jul 2020 08:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=clHMhe6qVnv5ly8L5/GZeOajpz5AqYI57hi/uKTJuvA=;
        b=G5cACxvK/haQZKq9zgPLteTDsBWRjtAb8bCPQpoU0L2HiExW3iMTZlJsjmCELfmg8u
         8bCBMry4JUHKsV3SUbQMLGidkomV5jkH5B9Th4miuaP2JeDbXlfkrzKmydbCsJ6U/NbC
         AD81oIcmP9NNYLRaC0dn1/r8fVphsRHJEGSIrm7EVs/SttajfflPZCzQ/Vo2LOwIrYah
         ap3VqRXNhoj4vqdUTucjQrs/cj0H6mucaKZc7/5IvvUKjoI5TEOxNhab8KVr5mL8REIu
         ffzDBYYRrFea9i3K7DLR1ppK8e6hAL2U3t8LUiAIFL8wkyaddyTuOecyYLhhSiuBV+zL
         VJQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=clHMhe6qVnv5ly8L5/GZeOajpz5AqYI57hi/uKTJuvA=;
        b=dnnm6QcD017fQ/fw/TPguGSBVocTPxmPxhnZopOHuE1+WYMkBIZtzu1nis55vystZM
         dlgXwIIuOtWOttDK9pObVhgW1uFENgLxbXJf9PBVellEscYWPmmvA/UgTT9N3+Ah1i1I
         cf161y1w0hZSfjDVgD5F1U4apSferjka3/yoIEpepLwOXWMJEX7qz9j1m1UPBQNSnVHC
         4rLn0Xlyyavp/nTo0M4CNJt6dMMqU0Q5qouebzaroGKZwt6su7G1evBx1S2gxT2ltLoX
         8BJXvCKgnPdPztX5tHU9EnvxL83cdFxiFjlw/OCx3GYBcA6tJkeqNUQwpOe/BfJdcUKO
         +Lhg==
X-Gm-Message-State: AOAM532CYBFwx6zw4Nq2Y3B0gprT9/0rRiDgt7ySml53Y2U1kxDaQY6A
        Zw1G9SJZkVSoELu4o/jZbrAqDmFnkSuDCg==
X-Google-Smtp-Source: ABdhPJx/QLbKUmlEUpFjR2GayBIuWepU41w7g8/9mR8dRhmhVRaYIwAtbsxK0qq2r/uc+JxbJwDkFg==
X-Received: by 2002:a6b:661a:: with SMTP id a26mr37370793ioc.197.1594222905246;
        Wed, 08 Jul 2020 08:41:45 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p84sm43747ill.64.2020.07.08.08.41.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 08:41:44 -0700 (PDT)
Subject: Re: [PATCH] io_uring: export cq overflow status to userspace
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, joseph.qi@linux.alibaba.com
References: <c4e40cba-4171-a253-8813-ca833c8ce575@linux.alibaba.com>
 <D59FC4AE-8D3B-44F4-A6AA-91722D97E202@kernel.dk>
 <83a3a0eb-8dea-20ad-ffc5-619226b47998@linux.alibaba.com>
 <f2cad5fb-7daf-611e-91dd-81d3eb268d26@kernel.dk>
 <54ce9903-4016-5b30-2fe9-397da9161bfe@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6c770628-34bd-f75a-3d4a-c1810f652054@kernel.dk>
Date:   Wed, 8 Jul 2020 09:41:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <54ce9903-4016-5b30-2fe9-397da9161bfe@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/8/20 9:39 AM, Xiaoguang Wang wrote:
> hi,
> 
>> On 7/7/20 11:29 PM, Xiaoguang Wang wrote:
>>> I modify above test program a bit:
>>> #include <errno.h>
>>> #include <stdio.h>
>>> #include <unistd.h>
>>> #include <stdlib.h>
>>> #include <string.h>
>>> #include <fcntl.h>
>>> #include <assert.h>
>>>
>>> #include "liburing.h"
>>>
>>> static void test_cq_overflow(struct io_uring *ring)
>>> {
>>>           struct io_uring_cqe *cqe;
>>>           struct io_uring_sqe *sqe;
>>>           int issued = 0;
>>>           int ret = 0;
>>>           int i;
>>>
>>>           for (i = 0; i < 33; i++) {
>>>                   sqe = io_uring_get_sqe(ring);
>>>                   if (!sqe) {
>>>                           fprintf(stderr, "get sqe failed\n");
>>>                           break;;
>>>                   }
>>>                   ret = io_uring_submit(ring);
>>>                   if (ret <= 0) {
>>>                           if (ret != -EBUSY)
>>>                                   fprintf(stderr, "sqe submit failed: %d\n", ret);
>>>                           break;
>>>                   }
>>>                   issued++;
>>>           }
>>>
>>>           printf("issued requests: %d\n", issued);
>>>
>>>           while (issued) {
>>>                   ret = io_uring_peek_cqe(ring, &cqe);
>>>                   if (ret) {
>>>                           if (ret != -EAGAIN) {
>>>                                   fprintf(stderr, "peek completion failed: %s\n",
>>>                                           strerror(ret));
>>>                                   break;
>>>                           }
>>>                           printf("left requets: %d %d\n", issued, IO_URING_READ_ONCE(*ring->sq.kflags));
>>>                           continue;
>>>                   }
>>>                   io_uring_cqe_seen(ring, cqe);
>>>                   issued--;
>>>                   printf("left requets: %d\n", issued);
>>>           }
>>> }
>>>
>>> int main(int argc, char *argv[])
>>> {
>>>           int ret;
>>>           struct io_uring ring;
>>>
>>>           ret = io_uring_queue_init(16, &ring, 0);
>>>           if (ret) {
>>>                   fprintf(stderr, "ring setup failed: %d\n", ret);
>>>                   return 1;
>>>           }
>>>
>>>           test_cq_overflow(&ring);
>>>           return 0;
>>> }
>>>
>>> Though with your patches applied, we still can not peek the last cqe.
>>> This test program will only issue 33 sqes, so it won't get EBUSY error.
>>
>> How about we make this even simpler, then - make the
>> IORING_SQ_CQ_OVERFLOW actually track the state, rather than when we fail
>> on submission. The liburing change would be the same, the kernel side
>> would then look like the below.
>>
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 4c9a494c9f9f..01981926cdf4 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -1342,6 +1342,7 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
>>   	if (cqe) {
>>   		clear_bit(0, &ctx->sq_check_overflow);
>>   		clear_bit(0, &ctx->cq_check_overflow);
>> +		ctx->rings->sq_flags &= ~IORING_SQ_CQ_OVERFLOW;
>>   	}
>>   	spin_unlock_irqrestore(&ctx->completion_lock, flags);
>>   	io_cqring_ev_posted(ctx);
>> @@ -1379,6 +1380,7 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
>>   		if (list_empty(&ctx->cq_overflow_list)) {
>>   			set_bit(0, &ctx->sq_check_overflow);
>>   			set_bit(0, &ctx->cq_check_overflow);
>> +			ctx->rings->sq_flags |= IORING_SQ_CQ_OVERFLOW;
>>   		}
>>   		req->flags |= REQ_F_OVERFLOW;
>>   		refcount_inc(&req->refs);
>> @@ -6375,9 +6377,9 @@ static int io_sq_thread(void *data)
>>   			}
>>   
>>   			/* Tell userspace we may need a wakeup call */
>> +			spin_lock_irq(&ctx->completion_lock);
>>   			ctx->rings->sq_flags |= IORING_SQ_NEED_WAKEUP;
>> -			/* make sure to read SQ tail after writing flags */
>> -			smp_mb();
>> +			spin_unlock_irq(&ctx->completion_lock);
>>   
>>   			to_submit = io_sqring_entries(ctx);
>>   			if (!to_submit || ret == -EBUSY) {
>> @@ -6400,7 +6402,9 @@ static int io_sq_thread(void *data)
>>   			}
>>   			finish_wait(&ctx->sqo_wait, &wait);
>>   
>> +			spin_lock_irq(&ctx->completion_lock);
>>   			ctx->rings->sq_flags &= ~IORING_SQ_NEED_WAKEUP;
>> +			spin_unlock_irq(&ctx->completion_lock);
>>   		}
>>   
>>   		mutex_lock(&ctx->uring_lock);
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index 8d033961cb78..91953b543125 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -198,6 +198,7 @@ struct io_sqring_offsets {
>>    * sq_ring->flags
>>    */
>>   #define IORING_SQ_NEED_WAKEUP	(1U << 0) /* needs io_uring_enter wakeup */
>> +#define IORING_SQ_CQ_OVERFLOW	(1U << 1) /* app needs to enter kernel */
>>   
>>   struct io_cqring_offsets {
>>   	__u32 head;
>>
> Looks good, I think it'll work now.
> I'll test and send patches soon, thanks.

One missing bit clear, and I corrected that last comment. Just base on
this one, thanks!


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4c9a494c9f9f..0b6a4b2d7e76 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1342,6 +1342,7 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 	if (cqe) {
 		clear_bit(0, &ctx->sq_check_overflow);
 		clear_bit(0, &ctx->cq_check_overflow);
+		ctx->rings->sq_flags &= ~IORING_SQ_CQ_OVERFLOW;
 	}
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 	io_cqring_ev_posted(ctx);
@@ -1379,6 +1380,7 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
 		if (list_empty(&ctx->cq_overflow_list)) {
 			set_bit(0, &ctx->sq_check_overflow);
 			set_bit(0, &ctx->cq_check_overflow);
+			ctx->rings->sq_flags |= IORING_SQ_CQ_OVERFLOW;
 		}
 		req->flags |= REQ_F_OVERFLOW;
 		refcount_inc(&req->refs);
@@ -6375,9 +6377,9 @@ static int io_sq_thread(void *data)
 			}
 
 			/* Tell userspace we may need a wakeup call */
+			spin_lock_irq(&ctx->completion_lock);
 			ctx->rings->sq_flags |= IORING_SQ_NEED_WAKEUP;
-			/* make sure to read SQ tail after writing flags */
-			smp_mb();
+			spin_unlock_irq(&ctx->completion_lock);
 
 			to_submit = io_sqring_entries(ctx);
 			if (!to_submit || ret == -EBUSY) {
@@ -6400,7 +6402,9 @@ static int io_sq_thread(void *data)
 			}
 			finish_wait(&ctx->sqo_wait, &wait);
 
+			spin_lock_irq(&ctx->completion_lock);
 			ctx->rings->sq_flags &= ~IORING_SQ_NEED_WAKEUP;
+			spin_unlock_irq(&ctx->completion_lock);
 		}
 
 		mutex_lock(&ctx->uring_lock);
@@ -7810,6 +7814,7 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 			if (list_empty(&ctx->cq_overflow_list)) {
 				clear_bit(0, &ctx->sq_check_overflow);
 				clear_bit(0, &ctx->cq_check_overflow);
+				ctx->rings->sq_flags &= ~IORING_SQ_CQ_OVERFLOW;
 			}
 			spin_unlock_irq(&ctx->completion_lock);
 
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 8d033961cb78..d65fde732518 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -198,6 +198,7 @@ struct io_sqring_offsets {
  * sq_ring->flags
  */
 #define IORING_SQ_NEED_WAKEUP	(1U << 0) /* needs io_uring_enter wakeup */
+#define IORING_SQ_CQ_OVERFLOW	(1U << 1) /* CQ ring is overflown */
 
 struct io_cqring_offsets {
 	__u32 head;

-- 
Jens Axboe

