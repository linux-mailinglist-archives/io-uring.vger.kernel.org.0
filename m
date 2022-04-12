Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1284FE5C6
	for <lists+io-uring@lfdr.de>; Tue, 12 Apr 2022 18:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235689AbiDLQ1x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Apr 2022 12:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357659AbiDLQ1u (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Apr 2022 12:27:50 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE6F57153
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 09:25:31 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id s21so13180967pgv.13
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 09:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=PrSACCrvToYGEmGCqnMU/r5BWxXvoZymZ43mY63YUDQ=;
        b=FnRbuVx5P5N5CadWF1bSTFbc/T8+mfBapFjmpnsll86jtobnAtHMpjBc0gM5c8SRDX
         SpKXJ3Kv2GFFIZlBp4waEB5bkDrC/v28e8q4+M4Z3iYr7RU9uIk0/RMeWTm8n/IkCd+Y
         pXvzNnxdx0zgPTaubP6iyeR9LBzmKJZQ5sjDDAN62vCnlZZENy+CTTw3W7VqbV/jb5cc
         Qh3nZEV1Bg8D8Zrzg7jjq8ZR8hRAWlVYZxuyabkYrle+4UypQ2zcMUKdEQfnQ6TzaVur
         NMKQVHMjgX6ElBcS8p5a6IEetZKF1TqRcca0FxlTCFj7PTQ2MG1Lef+td9dExHuK/ANy
         Ntlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PrSACCrvToYGEmGCqnMU/r5BWxXvoZymZ43mY63YUDQ=;
        b=aVJnh/okl2bFSRtquwTKvPHUljls982hSaKYNH2q3sAfkuMh60DiisRToVEKwJab/w
         h1YMdmPKQJYpvcOzdjT0zVFBkzgKIZ1C6g0f2896ysVHGYGG0bISk63WV84JHIoRYUMB
         PLueJqhhBEfUinAkXxi/G/96RY+CV+2lAV5XfhoRUV+ESh+c8NeY1RO3NYDI1pBhNBDG
         lzh6ahpeOrcBCjpdCyxHWiRSh5BP2xtHwuNm376InT6kYoXAC5bnF0fpC2ZIiuFJnqb8
         zE7lZBFpYDxGpASi4GJZX84NdzWl1NVmoho9Qk7VocqOQ/h301NOyOsUC0bkV7vEW+3a
         x2cA==
X-Gm-Message-State: AOAM532nH9tLyDE4LV7pdIVv9vvEoXaPJl7smcFG8Q7t3PJV6eiQePIh
        1aain3QjYbeBXd9sucohcLdkTfWyAvP3ox+Y
X-Google-Smtp-Source: ABdhPJwYi/OY8HNe9bqk2PPBKL6H1FhskPsy87ZjlZB4YkxeVAQyvtJg3ZFhe74Vicebw+JBftxQNQ==
X-Received: by 2002:a63:2266:0:b0:39c:f643:ee69 with SMTP id t38-20020a632266000000b0039cf643ee69mr18196208pgm.288.1649780730531;
        Tue, 12 Apr 2022 09:25:30 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id v4-20020a17090a00c400b001cb4f242c92sm3491266pjd.26.2022.04.12.09.25.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 09:25:30 -0700 (PDT)
Message-ID: <01c568c3-8248-215c-1525-b78422f3910e@kernel.dk>
Date:   Tue, 12 Apr 2022 10:25:28 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 9/9] io_uring: optimise io_get_cqe()
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Florian Schmaus <flo@geekplace.eu>, io-uring@vger.kernel.org
References: <cover.1649771823.git.asml.silence@gmail.com>
 <487eeef00f3146537b3d9c1a9cef2fc0b9a86f81.1649771823.git.asml.silence@gmail.com>
 <49f6ed82-0250-bb8c-d12a-c8cce1f72ad2@geekplace.eu>
 <bfede80f-b712-f34e-47d7-a81bd7f17afb@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <bfede80f-b712-f34e-47d7-a81bd7f17afb@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/12/22 10:15 AM, Pavel Begunkov wrote:
> On 4/12/22 17:06, Florian Schmaus wrote:
>> On 12/04/2022 16.09, Pavel Begunkov wrote:
>>> io_get_cqe() is expensive because of a bunch of loads, masking, etc.
>>> However, most of the time we should have enough of entries in the CQ,
>>> so we can cache two pointers representing a range of contiguous CQE
>>> memory we can use. When the range is exhausted we'll go through a slower
>>> path to set up a new range. When there are no CQEs avaliable, pointers
>>> will naturally point to the same address.
>>>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>   fs/io_uring.c | 46 +++++++++++++++++++++++++++++++++++-----------
>>>   1 file changed, 35 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index b349a3c52354..f2269ffe09eb 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -416,6 +416,13 @@ struct io_ring_ctx {
>>>       unsigned long        check_cq_overflow;
>>>       struct {
>>> +        /*
>>> +         * We cache a range of free CQEs we can use, once exhausted it
>>> +         * should go through a slower range setup, see __io_get_cqe()
>>> +         */
>>> +        struct io_uring_cqe    *cqe_cached;
>>> +        struct io_uring_cqe    *cqe_santinel;
>>
>> I think this should s/santinel/sentinel.

I fixed it up.

-- 
Jens Axboe

