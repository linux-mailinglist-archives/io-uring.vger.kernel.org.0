Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 078A05AE541
	for <lists+io-uring@lfdr.de>; Tue,  6 Sep 2022 12:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239347AbiIFKXf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Sep 2022 06:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239468AbiIFKWv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Sep 2022 06:22:51 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18906422F4
        for <io-uring@vger.kernel.org>; Tue,  6 Sep 2022 03:22:04 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 29so9415673edv.2
        for <io-uring@vger.kernel.org>; Tue, 06 Sep 2022 03:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Uz9ZAK6ck4wBvAyeCT0iHieN5QViHrWfJeaXfWEUF1k=;
        b=XslRzVIzOxZjCGKL+uSHmvB5q+FrVuRettBfzoulgeRp7RvEYFGYfehavjBYx0B2ou
         waKH8IRmSdYsaIY67vHG1oH4uW/Zxl/aKyUa2nsnIUoWCrWCpvOnnCi12igo7hyBpKUn
         c+nyta6PEmHcoLBsiF/f9yoknOi8NDRHQP/tfin70p2G2KEoqkzIt4owaP0813t9a2Hd
         KV9OVjwB2EP+7ORldwAzVGki9epl6J+2sQNn2XeDN/+N6kqlyGE/gKfWnKImh7FarG8D
         TWbSD86pD4rXAfjwu96AZZnHc+xPIX8ZYj3l+ebSyWwBGDOjvfRglD2Fiks5oTmldC+j
         BkXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Uz9ZAK6ck4wBvAyeCT0iHieN5QViHrWfJeaXfWEUF1k=;
        b=Y3rUnMp5nYMQ8s3qjJlNdY8ksZNqZTGigfNY01pvcbQQgAqv4Ik/RXnRYMDJuNe2L1
         KEn5CDlFuktn458nmuPsFkc0lYdXo2Kg/8gXTKZioEYCaa2OA9yTShLe2bncSZCbhCbI
         OKYWMM3V53wiWmXh9F1p/aLFaapjR12VzWESP059MMLG9a5YwW5WLNM6UFcKaJCOHYQy
         2JNTWRGPdnZUJyBXEfmsaczi5ScjJNlw0+1Tp8m1TCTIspBk6YpzOQmEV6MHj15Y+Wmy
         wnaPodzZQuSmY7YHcz4nKMXQpMkN267MmKz6CB/KtFJ0JsYLLoB+hYKPh5PfZAQgCTbG
         cmiw==
X-Gm-Message-State: ACgBeo265eeUy4YxPTXZ9qDU78MAF/UZcPoQFwJlmMIk+EVWGpzBV8VL
        ZRy2U4xD97ggL51hMc2mcHk=
X-Google-Smtp-Source: AA6agR5CFGgJKBMaJfb32uYQ/PCLDNQirSeY+B4hJvi5cTLX/oRKJ2H6is76fA0Ssl6giZOdXq0eLA==
X-Received: by 2002:a05:6402:1946:b0:44e:a406:5ff5 with SMTP id f6-20020a056402194600b0044ea4065ff5mr5583615edz.14.1662459718991;
        Tue, 06 Sep 2022 03:21:58 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:55eb])
        by smtp.gmail.com with ESMTPSA id c18-20020a17090618b200b0073cc17cdb92sm6239844ejf.106.2022.09.06.03.21.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 03:21:58 -0700 (PDT)
Message-ID: <a7085672-1d14-0d92-c1e8-05e444e05a08@gmail.com>
Date:   Tue, 6 Sep 2022 11:19:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH liburing] man/io_uring_enter.2: document IORING_OP_SEND_ZC
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <b56a06f431ea01d125627d4fd95d712e5d72a51c.1662415676.git.asml.silence@gmail.com>
 <ea903226-581a-c512-f438-b948add1d1a7@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ea903226-581a-c512-f438-b948add1d1a7@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/5/22 23:51, Jens Axboe wrote:
> On 9/5/22 4:09 PM, Pavel Begunkov wrote:
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>
>> Doc writing is not my strongest side, comments are welcome.
>>
>>   man/io_uring_enter.2 | 44 ++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 44 insertions(+)
>>
>> diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
>> index 1a9311e..7fd275c 100644
>> --- a/man/io_uring_enter.2
>> +++ b/man/io_uring_enter.2
>> @@ -1059,6 +1059,50 @@ value being passed in. This request type can be used to either just wake or
>>   interrupt anyone waiting for completions on the target ring, or it can be used
>>   to pass messages via the two fields. Available since 5.18.
>>   
>> +.TP
>> +.B IORING_OP_SEND_ZC
>> +Issue the zerocopy equivalent of a
>> +.BR send(2)
>> +system call. It's similar to IORING_OP_SEND, but when the
>> +.I flags
>> +field of the
>> +.I "struct io_uring_cqe"
>> +contains IORING_CQE_F_MORE, the userspace should expect a second cqe, a.k.a.
>> +notification, and until then it should not modify data in the buffer. The
>> +notification will have the same
>> +.I user_data
>> +as the first one and its
>> +.I flags
>> +field will contain the
>> +.I IORING_CQE_F_NOTIF
>> +flag. It's guaranteed that IORING_CQE_F_MORE is set IFF the result is
>> +non-negative.
>> +.I fd
>> +must be set to the socket file descriptor,
>> +.I addr
>> +must contain a pointer to the buffer,
>> +.I len
>> +denotes the length of the buffer to send, and
>> +.I msg_flags
>> +holds the flags associated with the system call. When
>> +.I addr2
>> +is non-zero it points to the address of the target with
>> +.I addr_len
>> +specifying its size, turning the request into a
>> +.BR sendto(2)
>> +system call equivalent.
>> +
>> +.B IORING_OP_SEND_ZC
>> +tries to avoid making intermediate data copies but still may fall back to
>> +copying. Furthermore, zerocopy is not always faster, especially when the
>> +per-request payload size is small. The two completion model is needed because
>> +the kernel might hold on to buffers for a long time, e.g. waiting for a TCP ACK,
>> +and having a separate cqe for request completions allows the userspace to push
>> +more data without extra delays. Note, notifications don't guarantee that the
>> +data has been or will ever be received by the other endpoint.
> 
> I'd probably reorder this a bit to introduce it with the fact that's
> it's like SEND, but zero-copy. Then explain the mechanics of how MORE is
> set for the 2 stage completion notification if zc is done. I can shuffle
> it around a bit if you want me to - just let me know!

I don't mind you editing it at all, makes my life easier. Anyway,
sent out a v2, let's see if it reads better.

-- 
Pavel Begunkov
