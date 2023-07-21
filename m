Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91E4475CFEF
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 18:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjGUQoV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 12:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbjGUQoT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 12:44:19 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB70F30C7
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 09:43:55 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id ca18e2360f4ac-7835bbeb6a0so28537439f.0
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 09:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689957835; x=1690562635;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eiZgZcQFiqyg5IS0pp/m5dbxQQoqv3FSGpjr+LBmXFA=;
        b=IKrA9imwmphxPutvJFTfMlJb0GM4dNocxg9YEp+WB+MPudF4jF7vRicJxnJeW/DnCk
         wz7dlUVPaJjouImfuyQEIU9v+7rNcYjtcMqdhsm153YiZQDiUmFvMehsgXwzXhDqNbmA
         dYxoJkKzqrFFQtLyVT8m508lI0pGz3zq5Qjqcv+QU1JMVi1WubZm4MSwyjQFRClrjITy
         RA/j+++8mCy/MISEW5lhBxZ60Zg9+aeZoqNgENQVRfbrH5EGeA0KWc5TqGBM1WR6fkgm
         kSFJldlwdYtfh4xH3qI/6bPbkfqdrtwfejYVkOXnn7MeZvXety02irVkk2d9CHlQ7mW2
         zMzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689957835; x=1690562635;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eiZgZcQFiqyg5IS0pp/m5dbxQQoqv3FSGpjr+LBmXFA=;
        b=HH23QSDL4OQpIbjP76ptYix5fARo4nUGtw+8oXzOSEdJ8+FkrB9YqBUkNnsjAuOOHt
         dv0cEUnd+xI0J7F45gmKfoL256TwgfnDidUETBQ5bg1IJtngqkKACnIf17dzIHlp+/n+
         /eNk6fvQrak5tkJ52+gwJHWUI+QMYPrxgOYcalu83Zv3mLxnCizN5c3sfH2PuQJA5q4Z
         67goch2mlKl/AAFHD/7Tfmqs+QWtCYhKotHGbVtBTdCwRguW5ma+uhbkI3FrGEZ7EVdA
         WfYi6MXoJbDg1deeaQaJXgBahZAV8z3FkboSQq6KBCMFb671yJQPQ5bNf9bTpK1hZ4tY
         2v9g==
X-Gm-Message-State: ABy/qLauFibZGlns9q5paAYiabXMJ32vENOanEvN+w8r16tOFu50i1AG
        yD3mebHlQIYXo4sJkd7LL/perw==
X-Google-Smtp-Source: APBJJlEzSf18nSmR4k4qHbSXMJawA6JM3rpFaOeaJ8GzmOetEN0p1IEnGnhS+19IbUO4qvHNNTWpWw==
X-Received: by 2002:a05:6602:480b:b0:780:d6ef:160 with SMTP id ed11-20020a056602480b00b00780d6ef0160mr2614636iob.1.1689957835278;
        Fri, 21 Jul 2023 09:43:55 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id f19-20020a5d8793000000b00786f50d6bf5sm1155353ion.19.2023.07.21.09.43.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jul 2023 09:43:54 -0700 (PDT)
Message-ID: <7239267f-7216-d606-6c08-5d8cf6dbb32f@kernel.dk>
Date:   Fri, 21 Jul 2023 10:43:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6/9] fs: add IOCB flags related to passing back dio
 completions
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de, david@fromorbit.com
References: <20230721161650.319414-1-axboe@kernel.dk>
 <20230721161650.319414-7-axboe@kernel.dk>
 <20230721162807.GT11352@frogsfrogsfrogs>
 <3829033a-40fb-5de1-853b-a9b367681d51@kernel.dk>
In-Reply-To: <3829033a-40fb-5de1-853b-a9b367681d51@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/21/23 10:30?AM, Jens Axboe wrote:
> On 7/21/23 10:28?AM, Darrick J. Wong wrote:
>>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>>> index 6867512907d6..60e2b4ecfc4d 100644
>>> --- a/include/linux/fs.h
>>> +++ b/include/linux/fs.h
>>> @@ -338,6 +338,20 @@ enum rw_hint {
>>>  #define IOCB_NOIO		(1 << 20)
>>>  /* can use bio alloc cache */
>>>  #define IOCB_ALLOC_CACHE	(1 << 21)
>>> +/*
>>> + * IOCB_DIO_CALLER_COMP can be set by the iocb owner, to indicate that the
>>> + * iocb completion can be passed back to the owner for execution from a safe
>>> + * context rather than needing to be punted through a workqueue.If this If this
>>
>> "...through a workqueue.  If this flag is set..."
>>
>> Need a space after the period, and delete one of the "If this".
>>
>> With that fixed,
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> Thanks - same ask on the edit. Or let me know if:
> 
> a) you're fine with staging this in a separate branch for 6.6, or
> b) you want a v5a/v6 edition posted
> 
> Either way is no trouble for me, just wary of spamming...

FWIW, here's the updated branch:

https://git.kernel.dk/cgit/linux/log/?h=xfs-async-dio.5

-- 
Jens Axboe

