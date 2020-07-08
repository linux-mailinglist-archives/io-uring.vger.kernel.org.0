Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC1721928C
	for <lists+io-uring@lfdr.de>; Wed,  8 Jul 2020 23:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbgGHVdt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jul 2020 17:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgGHVds (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jul 2020 17:33:48 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10196C03541E
        for <io-uring@vger.kernel.org>; Wed,  8 Jul 2020 14:33:48 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id k5so129240pjg.3
        for <io-uring@vger.kernel.org>; Wed, 08 Jul 2020 14:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kJlp04A10B02cT2+NkSkX1Z9OhY8tAEE4STgZf3/EFo=;
        b=HQkS1pBOShuRLG2SrBoml5oxDJxIHZQ2XJ6EnSkHZlOsr3MHf/2yMsDLKTJp676rTu
         k1ZVlBwPrVWw1UC5EvzPDeoINnerYM46tGAFXauAXaEJiiN7TOd7hjw22rS/WYikYacB
         ZAtjCW5Rwec2hY3mDZ+ykYoy/HJO9EEZNMryXlhUu3C27Z3hVbEwAIDjHJe0VLyVSDtQ
         hPEnlLZtAOWVYyXwA2aIM7nBFRKvxC/STMLYXHmb5vz9KB8mWBh48OXCSiPJlTBSqrUM
         IH+DLuIH3TlMo/aLmbrBjojTwaVMt+6sMxOisy1tWgu0G5fpNqqeZhdsuTT+e7l5iA6d
         DOvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kJlp04A10B02cT2+NkSkX1Z9OhY8tAEE4STgZf3/EFo=;
        b=cwQeXd0fs1OTgUp1MLEXlM1LrR/r5l1B2v5zur8yR9KrvMBL2L6j3CJp5x6SYMgGUe
         A6wH+qefwj4FJ2EgHinCj1ympYI2FEhdxa02cOlGBBkyp03SR7NVfaulocQq0gSMjiNB
         l8j8GsALDODwXvi5lbXro1zJ1u10r5octBtrJuA+0aNJpHCe6HbCQ+XdeTZ1U0wNwcYG
         alGJ5zI0S7pgLHXGn3zmwX58plQw/zk4/sakRLWWXBSf5kXRS5jkRD5ELp+oqP3AOpug
         Bjbm245xgDKnR/nUFKWySjZI5o0wI1U8bXbf+H14jAbou2HZkNwhAsht0NYdwRAGd0eK
         AQew==
X-Gm-Message-State: AOAM530MQ4lgugyUcvrynbR2O/ygaTNXBjVs2iPKvMejtzvc+Q9HIPMR
        K2gZjuX/l3mBJmbVHvlN2L7WBAdPihCvDA==
X-Google-Smtp-Source: ABdhPJw1FvOgJl012fe8f69W4fgYjRndV92MTCBNdJD/O6In7I1D9jbqrxrh17aAJVKqWuexWen5Tw==
X-Received: by 2002:a17:90a:df11:: with SMTP id gp17mr10741070pjb.188.1594244027323;
        Wed, 08 Jul 2020 14:33:47 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id y8sm412116pju.49.2020.07.08.14.33.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 14:33:46 -0700 (PDT)
Subject: Re: [PATCH] io_uring: export cq overflow status to userspace
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, joseph.qi@linux.alibaba.com
References: <c4e40cba-4171-a253-8813-ca833c8ce575@linux.alibaba.com>
 <D59FC4AE-8D3B-44F4-A6AA-91722D97E202@kernel.dk>
 <83a3a0eb-8dea-20ad-ffc5-619226b47998@linux.alibaba.com>
 <f2cad5fb-7daf-611e-91dd-81d3eb268d26@kernel.dk>
 <54ce9903-4016-5b30-2fe9-397da9161bfe@linux.alibaba.com>
 <6c770628-34bd-f75a-3d4a-c1810f652054@kernel.dk>
 <c986d7f5-f085-c57c-450e-6f3bbee40640@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <706ecf46-63e5-ac5f-a2e9-b15a75e0be11@kernel.dk>
Date:   Wed, 8 Jul 2020 15:33:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c986d7f5-f085-c57c-450e-6f3bbee40640@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/8/20 10:51 AM, Xiaoguang Wang wrote:
> hi,
> 
>> On 7/8/20 9:39 AM, Xiaoguang Wang wrote:
>>> hi,
>>>
>>>> On 7/7/20 11:29 PM, Xiaoguang Wang wrote:
>>>>> I modify above test program a bit:
>>>>> #include <errno.h>
>>>>> #include <stdio.h>
>>>>> #include <unistd.h>
>>>>> #include <stdlib.h>
>>>>> #include <string.h>
>>>>> #include <fcntl.h>
>>>>> #include <assert.h>
>>>>>
>>>>> #include "liburing.h"
>>>>>
>>>>> static void test_cq_overflow(struct io_uring *ring)
>>>>> {
>>>>>            struct io_uring_cqe *cqe;
>>>>>            struct io_uring_sqe *sqe;
>>>>>            int issued = 0;
>>>>>            int ret = 0;
>>>>>            int i;
>>>>>
>>>>>            for (i = 0; i < 33; i++) {
>>>>>                    sqe = io_uring_get_sqe(ring);
>>>>>                    if (!sqe) {
>>>>>                            fprintf(stderr, "get sqe failed\n");
>>>>>                            break;;
>>>>>                    }
>>>>>                    ret = io_uring_submit(ring);
>>>>>                    if (ret <= 0) {
>>>>>                            if (ret != -EBUSY)
>>>>>                                    fprintf(stderr, "sqe submit failed: %d\n", ret);
>>>>>                            break;
>>>>>                    }
>>>>>                    issued++;
>>>>>            }
>>>>>
>>>>>            printf("issued requests: %d\n", issued);
>>>>>
>>>>>            while (issued) {
>>>>>                    ret = io_uring_peek_cqe(ring, &cqe);
>>>>>                    if (ret) {
>>>>>                            if (ret != -EAGAIN) {
>>>>>                                    fprintf(stderr, "peek completion failed: %s\n",
>>>>>                                            strerror(ret));
>>>>>                                    break;
>>>>>                            }
>>>>>                            printf("left requets: %d %d\n", issued, IO_URING_READ_ONCE(*ring->sq.kflags));
>>>>>                            continue;
>>>>>                    }
>>>>>                    io_uring_cqe_seen(ring, cqe);
>>>>>                    issued--;
>>>>>                    printf("left requets: %d\n", issued);
>>>>>            }
>>>>> }
>>>>>
>>>>> int main(int argc, char *argv[])
>>>>> {
>>>>>            int ret;
>>>>>            struct io_uring ring;
>>>>>
>>>>>            ret = io_uring_queue_init(16, &ring, 0);
>>>>>            if (ret) {
>>>>>                    fprintf(stderr, "ring setup failed: %d\n", ret);
>>>>>                    return 1;
>>>>>            }
>>>>>
>>>>>            test_cq_overflow(&ring);
>>>>>            return 0;
>>>>> }
>>>>>
>>>>> Though with your patches applied, we still can not peek the last cqe.
>>>>> This test program will only issue 33 sqes, so it won't get EBUSY error.
>>>>
>>>> How about we make this even simpler, then - make the
>>>> IORING_SQ_CQ_OVERFLOW actually track the state, rather than when we fail
>>>> on submission. The liburing change would be the same, the kernel side
>>>> would then look like the below.
>>>>
>>>>
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index 4c9a494c9f9f..01981926cdf4 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -1342,6 +1342,7 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
>>>>    	if (cqe) {
>>>>    		clear_bit(0, &ctx->sq_check_overflow);
>>>>    		clear_bit(0, &ctx->cq_check_overflow);
>>>> +		ctx->rings->sq_flags &= ~IORING_SQ_CQ_OVERFLOW;
>>>>    	}
>>>>    	spin_unlock_irqrestore(&ctx->completion_lock, flags);
>>>>    	io_cqring_ev_posted(ctx);
>>>> @@ -1379,6 +1380,7 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
>>>>    		if (list_empty(&ctx->cq_overflow_list)) {
>>>>    			set_bit(0, &ctx->sq_check_overflow);
>>>>    			set_bit(0, &ctx->cq_check_overflow);
>>>> +			ctx->rings->sq_flags |= IORING_SQ_CQ_OVERFLOW;
> Some callers to __io_cqring_fill_event() don't hold completion_lock, for example:
> ==> io_iopoll_complete
> ====> __io_cqring_fill_event()
> So this patch maybe still not safe when SQPOLL is enabled.
> Do you perfer adding a new lock or just do completion_lock here only when cq ring is overflowed?

The polled side isn't IRQ driven, so should be serialized separately. This works
because we don't allow non-polled IO on a polled context, and vice versa. If not,
we'd have bigger issues than just the flags modification.

So it should be fine as-is.

-- 
Jens Axboe

