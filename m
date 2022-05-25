Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD4BA533BD4
	for <lists+io-uring@lfdr.de>; Wed, 25 May 2022 13:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236545AbiEYLeI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 May 2022 07:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235944AbiEYLeG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 May 2022 07:34:06 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8391D87210
        for <io-uring@vger.kernel.org>; Wed, 25 May 2022 04:34:05 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id m1so18321251plx.3
        for <io-uring@vger.kernel.org>; Wed, 25 May 2022 04:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/nFzavGX2YiHrnbw12QE7/j3YNQjQjKDX7nQv/RshOI=;
        b=UxY4DNpVAhPCHrLClO1ubMdR2j+Bq20PMM//t6AkIzf7sl8z11Jf4Qw0WphNpSdOrX
         RKdvfp30c5po5iNvMYFGzq+CEu7Xc7+1lEMtJsmzxMHpxcO3IEFydl4BLrhVYpW7ovcg
         J7Lk9BHWOufBM21wf87Vw8DKon2yYiMyiU2eQPBkhFH9cq5f8F40is7U8Cfp/BQuuBrL
         sRwK8Nhjwlu2QJ24R4/az9nE1I6fJbYmiesDy9Dk6kFG6jY4GyfinNVNXwLxFG46l6F1
         Du0lwlMSge2ACQJgRZJCzJ9//V8oTI7BMZ5MYZKKEwanR6a7SbWRUFk815rdPVaWeC8b
         yjdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/nFzavGX2YiHrnbw12QE7/j3YNQjQjKDX7nQv/RshOI=;
        b=hH7ZteEOFALOW/fkl27yzmgCG5xLl9HUqd69hvzbTg3AS5PqLVdMPGTGzEsSLqkzYv
         nFe6oCl/acqd3+I08VuV+5cj+i9+vkjwxDG3sSExLvFO4B6HQvQtBq2qi+ePxfiEa/LM
         xc2unhKy8sbNRGIGZ+E7EIOdeoSCHBW7lrEfPlspxzSmohsqKKKgfu2gMQX2m5YWep2p
         K1V08dCItyZ7Czp8b1y2G85XddH1XjOgBalSkyNMwv0uj7N7vGStYaY1LxReooLrCUG0
         CnqV82FuXMpGsWjIsa92uYD08zIF+rjE/nPrZkGbufWcTakaZ3QIJ1OqvCU0YNMKu9bY
         I8Ew==
X-Gm-Message-State: AOAM532CV5/yVq9KgYAs5C9gepKraCVoHlMeJol+l31PgmaqhVWCodqr
        9AhhAGmHjwKBlsSDtsZ8SV70y/dUI8UVbA==
X-Google-Smtp-Source: ABdhPJyWJ3JZeB9IHll1qjCJfJVUwa//Ujhq7yxJlCuEVdFhy0MXrUfeFe4GkNN6ct7j9bqfOUN/DA==
X-Received: by 2002:a17:902:8644:b0:153:9f01:2090 with SMTP id y4-20020a170902864400b001539f012090mr31568957plt.101.1653478444958;
        Wed, 25 May 2022 04:34:04 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x26-20020aa7941a000000b0050dc76281f0sm11225649pfo.202.2022.05.25.04.34.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 May 2022 04:34:04 -0700 (PDT)
Message-ID: <c2865802-0962-c114-8466-fc03e86e95b7@kernel.dk>
Date:   Wed, 25 May 2022 05:34:03 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 5/6] io_uring: drop confusion between cleanup flags
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     io-uring@vger.kernel.org
References: <20220524213727.409630-1-axboe@kernel.dk>
 <CGME20220524213745epcas5p20d52948d7d4a07ff8b7830d19ae4596d@epcas5p2.samsung.com>
 <20220524213727.409630-6-axboe@kernel.dk> <20220525084632.GA7442@test-zns>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220525084632.GA7442@test-zns>
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

On 5/25/22 2:46 AM, Kanchan Joshi wrote:
> On Tue, May 24, 2022 at 03:37:26PM -0600, Jens Axboe wrote:
>> If the opcode only stores data that needs to be kfree'ed in
>> req->async_data, then it doesn't need special handling in
>> our cleanup handler.
>>
>> This has the added bonus of removing knowledge of those kinds of
>> special async_data to the io_uring core.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>> fs/io_uring.c | 18 ------------------
>> 1 file changed, 18 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 408265a03563..8188c47956ad 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -8229,24 +8229,6 @@ static void io_clean_op(struct io_kiocb *req)
>>
>>     if (req->flags & REQ_F_NEED_CLEANUP) {
>>         switch (req->opcode) {
>> -        case IORING_OP_READV:
>> -        case IORING_OP_READ_FIXED:
>> -        case IORING_OP_READ:
>> -        case IORING_OP_WRITEV:
>> -        case IORING_OP_WRITE_FIXED:
>> -        case IORING_OP_WRITE: {
>> -            struct io_async_rw *io = req->async_data;
>> -
>> -            kfree(io->free_iovec);
> 
> Removing this kfree may cause a leak.
> For READV/WRITEV atleast, io->free_iovec will hold the address of
> allocated iovec array if input was larger than UIO_FASTIOV.

I think I was too tired when I did and saw it freeing ->async_data,
which is obviously not the case. I'll drop this one.


-- 
Jens Axboe

