Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBB3150CA9A
	for <lists+io-uring@lfdr.de>; Sat, 23 Apr 2022 15:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235770AbiDWNbC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Apr 2022 09:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235773AbiDWNa7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Apr 2022 09:30:59 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E67967C166
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 06:28:02 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id r83so9589999pgr.2
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 06:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:in-reply-to:content-transfer-encoding;
        bh=Ym7BCNOCiEdrJ3CUHpBLnxFL9/mZGVu3okqyzfvn5m0=;
        b=T4ugpikrPYTGIrxTh1NzC6GknNJLpjtHibPBqSys04Qzms6FsnWM9midFDa5j5d0MA
         zh7td3pjuZiytr4fXeCovNYhGUIhmPHaX/KesNsxHE7j5vXUG+rTQPOSjn79SDafK4aZ
         qcIzoYeiPa200ZuQaq3NAEjPNA1xNGGY+QZFhxQKlUfVJTYg6vS6Ni4VqPFugN313o+4
         1dL72M7UCnY/NCnOzHFpY8WWjykGWuYBgV1XJQTMSg4OCOLGQsoixsA1euaTr+TJ78m7
         oxDZURg/3CfiP8/ecAhqNML0kjRh3oTPc3bu5jWynbCF7RLpBo9riPKG1zXL/LS/eRdq
         bbJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=Ym7BCNOCiEdrJ3CUHpBLnxFL9/mZGVu3okqyzfvn5m0=;
        b=S6IbmShZSL73jzAS3afDhteKD4JWPpvWsYxUqIPIjAtbgdlaMNdASJUYxDzOlKRLr0
         X8WaFwMOsfmGbL4iaT65haiILEBhZB9smBtWYj2H6rUohFhQtY7oTa0ZEWb8Zp0lr8le
         /p66JrAlryJXrYiV3r/viD8RuaMHfJA8QNLdTCDnBj2qBzIUhRe6eh25LpHwIS/bex/X
         M8EHN66Ij+4ofZLoAY9ZkwizxbrfHmz1NstaU9GnW1ISKCWXhvZ+RNN7ln96sC1YhgU8
         mZExjqhKlh3u21pkRIbrBzyCCPyPYxy9U0k+9aJTuAabA24s/bagy42JyLPoqdH5L9KI
         XwXA==
X-Gm-Message-State: AOAM531uzBPbzlY2zd6/ILguCC40a0n+g+9C7Vbv1FLfxEjJT9nMM1q+
        9sWuNAqwAlgKxkWznopzHXJvSA==
X-Google-Smtp-Source: ABdhPJyzEmnpFOgHaf9qUEe30B8ZBgiT1VX6kjKbgPiv8ulshLTR62P6VHqEHtDsrKx4Csd7CJJwCA==
X-Received: by 2002:a65:6e41:0:b0:39c:c97b:2aef with SMTP id be1-20020a656e41000000b0039cc97b2aefmr8210415pgb.473.1650720482331;
        Sat, 23 Apr 2022 06:28:02 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id h18-20020a63c012000000b0039cc3c323f7sm4903655pgg.33.2022.04.23.06.28.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Apr 2022 06:28:01 -0700 (PDT)
Message-ID: <333c998b-6abb-fd8a-b043-e5f7a1d314ee@kernel.dk>
Date:   Sat, 23 Apr 2022 07:28:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 2/5] io_uring: serialize ctx->rings->sq_flags with
 cmpxchg()
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20220422214214.260947-1-axboe@kernel.dk>
 <20220422214214.260947-3-axboe@kernel.dk>
 <baf8826d-b94f-d009-c912-7262a825a409@gmail.com>
 <b648c1c5-c1c6-2f8b-e74c-249729158226@kernel.dk>
In-Reply-To: <b648c1c5-c1c6-2f8b-e74c-249729158226@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/23/22 7:07 AM, Jens Axboe wrote:
> On 4/23/22 2:06 AM, Pavel Begunkov wrote:
>> On 4/22/22 22:42, Jens Axboe wrote:
>>> Rather than require ctx->completion_lock for ensuring that we don't
>>> clobber the flags, use try_cmpxchg() instead. This removes the need
>>> to grab the completion_lock, in preparation for needing to set or
>>> clear sq_flags when we don't know the status of this lock.
>>>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> ---
>>>   fs/io_uring.c | 54 ++++++++++++++++++++++++++++++---------------------
>>>   1 file changed, 32 insertions(+), 22 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 626bf840bed2..38e58fe4963d 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -1999,6 +1999,34 @@ static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
>>>           io_cqring_wake(ctx);
>>>   }
>>>   +static void io_ring_sq_flag_clear(struct io_ring_ctx *ctx, unsigned int flag)
>>> +{
>>> +    struct io_rings *rings = ctx->rings;
>>> +    unsigned int oldf, newf;
>>> +
>>> +    do {
>>> +        oldf = READ_ONCE(rings->sq_flags);
>>> +
>>> +        if (!(oldf & flag))
>>> +            break;
>>> +        newf = oldf & ~flag;
>>> +    } while (!try_cmpxchg(&rings->sq_flags, &oldf, newf));
>>> +}
>>> +
>>> +static void io_ring_sq_flag_set(struct io_ring_ctx *ctx, unsigned int flag)
>>> +{
>>> +    struct io_rings *rings = ctx->rings;
>>> +    unsigned int oldf, newf;
>>> +
>>> +    do {
>>> +        oldf = READ_ONCE(rings->sq_flags);
>>> +
>>> +        if (oldf & flag)
>>> +            break;
>>> +        newf = oldf | flag;
>>> +    } while (!try_cmpxchg(&rings->sq_flags, &oldf, newf));
>>> +}
>>
>> atomic and/or might be a better fit
> 
> That would indeed be great, but the type is fixed. Not sure if all archs
> end up with a plain int as the type?

Looks like it actually is defined generically, so this could work.

-- 
Jens Axboe

