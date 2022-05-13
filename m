Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2DAA526250
	for <lists+io-uring@lfdr.de>; Fri, 13 May 2022 14:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380424AbiEMMuQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 May 2022 08:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380448AbiEMMt6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 May 2022 08:49:58 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7694888E
        for <io-uring@vger.kernel.org>; Fri, 13 May 2022 05:49:55 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id w24so9857426edx.3
        for <io-uring@vger.kernel.org>; Fri, 13 May 2022 05:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=fZEHXsUXAGeOJfWG/oHMm4kHHSJBgts2AdFFA6z4BHA=;
        b=SBPvGEO1BDaouwJUJkjg/doS9Mc0egmh4hwt3pYQXY7vWRDE+r3jKM+wHUGpVEuw4Z
         aPEV8NlXmNNm14zvlOMKIoqrXGuLZ9faEWcCU0aDUpCynw/tZI0hA/IqiEfg4vBCD5k2
         wed41xs8BwUBI+eclPHXdVq/GdR4tKRgsCvh4HPQ0K790rjOlkSzYtnDqbRci6lZnRoc
         p7ftE8CBkXn1SEQn8QB0REZBKTr8nX3kr24fdPPpMfgN4Qiwm8MW/ML3ZyiOy3T9kvSJ
         ZdhJkaXGhiqit+jYQ/2pICujGJSyWIC4apsEiRGvvmy7Jyqapdosas6KZ7IlCVqfYom9
         viPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fZEHXsUXAGeOJfWG/oHMm4kHHSJBgts2AdFFA6z4BHA=;
        b=CbjP1u7f8l68cmXLuTEsIrIgzQ9iFkJHtsCOBh3U+NPA3QYlmiO7I88SdXnAsBeFD7
         Lm4Yzoto/UMsbTEZsKzH4OI9zJDr+LT9bsAUaptPRPKttx4CqmnrLRc4P7Me4DCLK22z
         Cz0r/muBk/aYaxAbqJKHSIfwL6FTiZlknH3ZtmQ4e3qqqpdLdMDtJiDnWPrIWjIcyYbH
         hPjP3iKdQkHKvIzGf6TMogPWpsJWRxCEdx4iNDQEw5aMci61GRMo/bg6mlsykLZp8gvf
         NLb2Na4At0noT2Z4KJ+uPAAx1NifVXb4CV02/pDi7QnYCakuFhruZoWP0VhRLvqOjpJz
         IyrA==
X-Gm-Message-State: AOAM533cOxT/lha12ewq6agUcLqpLmorBAVbivo+ICtm5zwyXXZZuDnZ
        2wK4zEnSvC/ytWsagVayR7ZXn1pSM6I=
X-Google-Smtp-Source: ABdhPJxh+OYpA/jZiU7EjXHvw3RribmMMAwj1bqlDc702I/muYeFq9BFt+evTxF8jjnLaX5R66VVaA==
X-Received: by 2002:a05:6402:368c:b0:428:715f:5cf7 with SMTP id ej12-20020a056402368c00b00428715f5cf7mr36318002edb.158.1652446193658;
        Fri, 13 May 2022 05:49:53 -0700 (PDT)
Received: from [192.168.8.198] ([185.69.144.161])
        by smtp.gmail.com with ESMTPSA id h9-20020a50cdc9000000b0042617ba63d5sm917283edj.95.2022.05.13.05.49.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 May 2022 05:49:53 -0700 (PDT)
Message-ID: <7876d493-2a63-c66c-7dab-4f6c57916d14@gmail.com>
Date:   Fri, 13 May 2022 13:49:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] io_uring: avoid iowq again trap
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <f168b4f24181942f3614dd8ff648221736f572e6.1652433740.git.asml.silence@gmail.com>
 <64c7ae41-9c6c-5dc9-c58d-54bc752a2017@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <64c7ae41-9c6c-5dc9-c58d-54bc752a2017@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/13/22 13:31, Jens Axboe wrote:
> On 5/13/22 4:24 AM, Pavel Begunkov wrote:
>> If an opcode handler semi-reliably returns -EAGAIN, io_wq_submit_work()
>> might continue busily hammer the same handler over and over again, which
>> is not ideal. The -EAGAIN handling in question was put there only for
>> IOPOLL, so restrict it to IOPOLL mode only.
> 
> Looks good, needs:
> 
> Fixes: 90fa02883f06 ("io_uring: implement async hybrid mode for pollable requests")
> 
> unless I'm mistaken.

It's probably more of

Fixes: def596e9557c9 ("io_uring: support for IO polling")

-- 
Pavel Begunkov
