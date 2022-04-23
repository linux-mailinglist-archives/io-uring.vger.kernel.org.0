Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6A9A50CA60
	for <lists+io-uring@lfdr.de>; Sat, 23 Apr 2022 15:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235547AbiDWNLC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Apr 2022 09:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235584AbiDWNLA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Apr 2022 09:11:00 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601BF1C919
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 06:08:01 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id j6so8198913pfe.13
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 06:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=l9rGnE0FmPTdm4T9abVYfx9vNfUzoJsXVSpgXd6I5Kk=;
        b=dGSZqyiexHcohmzGEv4YmhWNsYDQuH2Y7y1uM1K2sttBFljLq6QcBDPq+jc6R92+WG
         sDaRrdZnDY+2TnxRmQeqGxEn/T/ZS5g295NgDdDsGyQGcTx68SxXYVqTyFT8GQ4+pYBW
         C1fM8oREloEoN5EqtBRG5MNwmvirS9PE4PSLbkKrXhgQuvTA/4RdGUaxAhEszxtgRvGs
         ohd1Bz+7jWq3fVidh8RqELb0ADbBx4DluWg8tKXPDKz46Oy5K6FcPewguJPGDuVMGzBF
         jNS3kHC+VXBgHY8vSC97NR8Tf7yscynDEB8FAFr1X1irN1fhSf3DSuRGghXRbYi9Fpf4
         A+GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=l9rGnE0FmPTdm4T9abVYfx9vNfUzoJsXVSpgXd6I5Kk=;
        b=1RN1Dq5++7N8qgeh0maItYHzHj4aOGQM4FODF0RDCnciPofN2dBmNYSb98FpkuorKq
         I6wiMX3ZCEX8BeMWKKkZkfHj84Q31Cs+OdyZa+EgiOFMxLx95FfTuzft57Io+bzLLnZ5
         gAnmfZmtKtp8bhUTC6KX5Wt07lkXeQJgixLOLSnPX9pNI96uZ+yd4rVvVK0RFLu50f1l
         KzbGl8YY1z5Owfvd/r3HvH4gMpTM3lbuessV0iWyJKKbONR3MrbatmrcqCMNtv+1KNtN
         97vd4F3KE3UhQ/KtZkPHueN019gh9uQ7LglFSjPp7oqWSeHmCC+NMh3pXzQLl6+AH8ow
         zuEQ==
X-Gm-Message-State: AOAM532WOh/tKZHLaP0BvRsCN/5yzag3AGU4PlmSwLkNHmzS4A+WSebl
        h9nOgpWeE41e05SiEq7kfKEONnv+xg9a2ZBY
X-Google-Smtp-Source: ABdhPJyAKh0WbV7cyNx2Ucn8jYulYMCTb6F4oK/hTaJuqXcDh5MUWpZ/EkR1Ahq3OEgOBWASLHnhAw==
X-Received: by 2002:a63:6ac5:0:b0:3aa:f01e:3280 with SMTP id f188-20020a636ac5000000b003aaf01e3280mr3102393pgc.207.1650719280435;
        Sat, 23 Apr 2022 06:08:00 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d21-20020a056a0010d500b004fd9ee64134sm5846213pfu.74.2022.04.23.06.07.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Apr 2022 06:07:59 -0700 (PDT)
Message-ID: <b648c1c5-c1c6-2f8b-e74c-249729158226@kernel.dk>
Date:   Sat, 23 Apr 2022 07:07:59 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 2/5] io_uring: serialize ctx->rings->sq_flags with
 cmpxchg()
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20220422214214.260947-1-axboe@kernel.dk>
 <20220422214214.260947-3-axboe@kernel.dk>
 <baf8826d-b94f-d009-c912-7262a825a409@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <baf8826d-b94f-d009-c912-7262a825a409@gmail.com>
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

On 4/23/22 2:06 AM, Pavel Begunkov wrote:
> On 4/22/22 22:42, Jens Axboe wrote:
>> Rather than require ctx->completion_lock for ensuring that we don't
>> clobber the flags, use try_cmpxchg() instead. This removes the need
>> to grab the completion_lock, in preparation for needing to set or
>> clear sq_flags when we don't know the status of this lock.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>   fs/io_uring.c | 54 ++++++++++++++++++++++++++++++---------------------
>>   1 file changed, 32 insertions(+), 22 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 626bf840bed2..38e58fe4963d 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -1999,6 +1999,34 @@ static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
>>           io_cqring_wake(ctx);
>>   }
>>   +static void io_ring_sq_flag_clear(struct io_ring_ctx *ctx, unsigned int flag)
>> +{
>> +    struct io_rings *rings = ctx->rings;
>> +    unsigned int oldf, newf;
>> +
>> +    do {
>> +        oldf = READ_ONCE(rings->sq_flags);
>> +
>> +        if (!(oldf & flag))
>> +            break;
>> +        newf = oldf & ~flag;
>> +    } while (!try_cmpxchg(&rings->sq_flags, &oldf, newf));
>> +}
>> +
>> +static void io_ring_sq_flag_set(struct io_ring_ctx *ctx, unsigned int flag)
>> +{
>> +    struct io_rings *rings = ctx->rings;
>> +    unsigned int oldf, newf;
>> +
>> +    do {
>> +        oldf = READ_ONCE(rings->sq_flags);
>> +
>> +        if (oldf & flag)
>> +            break;
>> +        newf = oldf | flag;
>> +    } while (!try_cmpxchg(&rings->sq_flags, &oldf, newf));
>> +}
> 
> atomic and/or might be a better fit

That would indeed be great, but the type is fixed. Not sure if all archs
end up with a plain int as the type?

-- 
Jens Axboe

