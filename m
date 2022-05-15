Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE11A527801
	for <lists+io-uring@lfdr.de>; Sun, 15 May 2022 16:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237063AbiEOOV7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 May 2022 10:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiEOOV6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 May 2022 10:21:58 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF975DF4A
        for <io-uring@vger.kernel.org>; Sun, 15 May 2022 07:21:57 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id q20so7366499wmq.1
        for <io-uring@vger.kernel.org>; Sun, 15 May 2022 07:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XKyLufaM1smpqhj4b5d7L05DU8EzQ7R4rAClmUu2Cj8=;
        b=h6d95BTmNP11+O8G7VdoLkfRr+irhrdgtaVneSUHrFg+PfC+PdmmRnYtkAGexB+Jv6
         lwoWLf50jmvJCoFbcMyh/yqVFLFZDPFAch/9mNWqNxkohgbya9FBI9KHekMGPK/fNj4D
         ETcF7ycABuAaQlWsLa+bfzHuLqTrqkFX6nK03a7CybpxsgCJ+iba6ro6jrtbr/c58UkY
         EAwlBu8HvEUHYnm+cG2qNn8GjGxiReCe375hJZCY2nk53vkEvSIwCrVThwr5xA6qdBkc
         FjrEVXYuDICwvj+jwTU2HLsor1QZrkRXitD+2xyJqJ4x+nxF6ofdJiA00gg2Y1yCRr+f
         yS4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XKyLufaM1smpqhj4b5d7L05DU8EzQ7R4rAClmUu2Cj8=;
        b=2u7rfrgC+NcccOQW2RjtpNVFgtL1iA7rnqSCv4njFbSszcumhnXqL8Z9h36q+k8TDW
         JKfx9OjVX+0Va/lUlg5Ssq+GV1h7n+gUTcun4oot1J0SazvCozX28HH3Y36P2Qw7clrH
         bqOQ4V8vd3wWrvJwi2J2VQ3y1YdeVxtegQlZD06blstnZCFrJ1bWQZsTSB/h+jMGWbla
         AnstxN+K9OkYZ0pnvqgRObVTJjPfexLZMl//Q4hsnGdA62vR6HuVbZlnOJqAh/EGn0aA
         Xk3DW4UL30XF85lhGVeLV3uRVihiy9XzHZ77Lt+Z1z0/2whjOH5Q1ctuWp7qoQIslBdK
         6reg==
X-Gm-Message-State: AOAM532734ht6T0IkFkrpO98jqjhZrywQj+FLy4BZEdiKl8+0o9idaNt
        OsHxqBVYOGhXQx2kHmFnuxo=
X-Google-Smtp-Source: ABdhPJwUbUAmrjrWpsYSN9R6DckiVWfD9fUhzyKEtfx6Rt9Hes2A+yjq6AMVc2k88WYvlxnD1iFSxQ==
X-Received: by 2002:a05:600c:48b:b0:394:2ee9:5847 with SMTP id d11-20020a05600c048b00b003942ee95847mr24329123wme.117.1652624516129;
        Sun, 15 May 2022 07:21:56 -0700 (PDT)
Received: from [192.168.8.198] ([148.252.129.73])
        by smtp.gmail.com with ESMTPSA id c13-20020adfa70d000000b0020c5253d8bfsm7341277wrd.11.2022.05.15.07.21.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 May 2022 07:21:55 -0700 (PDT)
Message-ID: <05310b9c-bfe1-3c75-f3e2-eb9d87925db0@gmail.com>
Date:   Sun, 15 May 2022 15:21:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] io_uring: avoid iowq again trap
Content-Language: en-US
To:     Hao Xu <haoxu.linux@icloud.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <f168b4f24181942f3614dd8ff648221736f572e6.1652433740.git.asml.silence@gmail.com>
 <5b4e6d37-f25d-099a-81a7-9125eb958251@icloud.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <5b4e6d37-f25d-099a-81a7-9125eb958251@icloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/15/22 08:31, Hao Xu wrote:
> On 5/13/22 18:24, Pavel Begunkov wrote:
>> If an opcode handler semi-reliably returns -EAGAIN, io_wq_submit_work()
> 
> Hi Pavel,
> When would it return -EAGAIN in non-IOPOLL mode?

I didn't see it in the wild but stumbled upon while preparing some
future patches. I hope it's not a real issue, but it's better to not
leave a way for some driver/etc. to abuse it.


>> might continue busily hammer the same handler over and over again, which
>> is not ideal. The -EAGAIN handling in question was put there only for
>> IOPOLL, so restrict it to IOPOLL mode only.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   fs/io_uring.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index e01f595f5b7d..3af1905efc78 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -7319,6 +7319,8 @@ static void io_wq_submit_work(struct io_wq_work *work)
>>            * wait for request slots on the block side.
>>            */
>>           if (!needs_poll) {
>> +            if (!(req->ctx->flags & IORING_SETUP_IOPOLL))
>> +                break;
>>               cond_resched();
>>               continue;
>>           }
> 

-- 
Pavel Begunkov
