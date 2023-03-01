Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B10966A7553
	for <lists+io-uring@lfdr.de>; Wed,  1 Mar 2023 21:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjCAUbe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Mar 2023 15:31:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCAUbd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Mar 2023 15:31:33 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4BD474F2
        for <io-uring@vger.kernel.org>; Wed,  1 Mar 2023 12:31:32 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id g3so3549908eda.1
        for <io-uring@vger.kernel.org>; Wed, 01 Mar 2023 12:31:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VHFbHeMNf/rnBFWill7Ye5o4zN7IG8LU9oPhmx/DTJk=;
        b=DuCN9N+aymrPcDOvH3P8hUqhXut1ZL9zPeJb/5iawboH2ydE/qORl9UJGRpiREBn64
         ogYjHePK0MBT4aLwPb1tYv2tzjOw8rS7wHSKZxNRiUem0S5E/ri7zyTShEJC6jElN4sO
         d7WSnzUqMMb+YYEU4rJLE74oE5TTM++iz5vFUv4q3OlrhvjllEo+qh1HT6FCWoM2uCKM
         R8ZjttuDU6D/u0vKKTv7HmKjaNaKw4ZN2e2k04j/L+5alDGlonztpQGVu/qd0gUfYI+6
         7F9bALscSit3XgAIYvtqoEU4sCk8EVzXhAwYUu6y03aUIFCsu5xlUU2i8wlXvYZ01871
         awhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VHFbHeMNf/rnBFWill7Ye5o4zN7IG8LU9oPhmx/DTJk=;
        b=jVxdMeBHkzNT6TeBMdnB6w/gdG8FdLRl1yVoVZLrASgOxmNVhXR+hyLkR8LGAm1gag
         gJT2vulCOq70eo1DkY1yTFSxVdGUrg+fVD8Lopwhb5xn8KKMC2k5hxTHG+Kt010QzcPI
         gIvjXspaVQlFSr3Fq7qCHKISUh7xiw0yMYC96Me1p+dmKr+iI9cqbUzP3EWxLeym/3tQ
         N7sLUeRpq/pNzNOsHcoXhOfzpA3MH8+kfkXBLvaroS9GhOTlyw/SEw/1AHcVBRpyUYDx
         AinZRBd3qmp+zLsDg9AQKEn5SKeRLHdTt9du+4NOAMVnSHkYLL5AJ43/IvLkXE7l4bcV
         Sc5Q==
X-Gm-Message-State: AO0yUKWfn7I3gS4fZkupn3/3zz3sbWeJ0qWoRXNGREl7og3ju0ngpqs5
        weYpWu8pFQpSuhF8Sw2k0V+nh+a/qyI=
X-Google-Smtp-Source: AK7set/C65juGvhvklt1mQ+OvgFqqiOhOe8e6nyZC0LB6s7/Lx7UMLBoPs0Oy1If+YNcTCG2Dz5I5Q==
X-Received: by 2002:a17:907:ea2:b0:8aa:c038:974c with SMTP id ho34-20020a1709070ea200b008aac038974cmr12553545ejc.54.1677702691069;
        Wed, 01 Mar 2023 12:31:31 -0800 (PST)
Received: from [192.168.8.100] (188.31.124.10.threembb.co.uk. [188.31.124.10])
        by smtp.gmail.com with ESMTPSA id a26-20020a170906191a00b008e56a0d546csm6092275eje.123.2023.03.01.12.31.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 12:31:30 -0800 (PST)
Message-ID: <73a8c741-a9b6-4585-3ae4-0ef72b8cdb39@gmail.com>
Date:   Wed, 1 Mar 2023 20:31:11 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH liburing 0/3] sendzc test improvements
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1677686850.git.asml.silence@gmail.com>
 <c8842e6d-4ce6-75f5-5ca0-c77fa23290db@kernel.dk>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c8842e6d-4ce6-75f5-5ca0-c77fa23290db@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/1/23 20:00, Jens Axboe wrote:
> On 3/1/23 9:10 AM, Pavel Begunkov wrote:
>> Add affinity, multithreading and the server
>>
>> Pavel Begunkov (3):
>>    examples/send-zc: add affinity / CPU pinning
>>    examples/send-zc: add multithreading
>>    examples/send-zc: add the receive part
>>
>>   examples/Makefile        |   3 +
>>   examples/send-zerocopy.c | 277 ++++++++++++++++++++++++++++++++++-----
>>   2 files changed, 249 insertions(+), 31 deletions(-)
> 
> This doesn't apply to the current tree, what am I missing? I
> don't see any send-zc changes since the last ones you did.
> First patch:

Don't know what that is, I'll resend later
  
> axboe@m1max ~/gi/liburing (master)> patch -p1 --dry-run < 1
> checking file examples/send-zerocopy.c
> Hunk #1 succeeded at 12 with fuzz 2.
> Hunk #2 FAILED at 51.
> Hunk #3 succeeded at 78 (offset -2 lines).
> Hunk #4 succeeded at 192 (offset -7 lines).
> Hunk #5 FAILED at 333.
> Hunk #6 succeeded at 360 with fuzz 2 (offset -14 lines).
> Hunk #7 succeeded at 382 (offset -14 lines).
> 2 out of 7 hunks FAILED
> 

-- 
Pavel Begunkov
