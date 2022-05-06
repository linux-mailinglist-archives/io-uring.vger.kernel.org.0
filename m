Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F21A51DCA5
	for <lists+io-uring@lfdr.de>; Fri,  6 May 2022 17:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381295AbiEFQBW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 12:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381488AbiEFQBV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 12:01:21 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C82566AA4B;
        Fri,  6 May 2022 08:57:37 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id q20so4704825wmq.1;
        Fri, 06 May 2022 08:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=EeZj1dGWsQkVJ1iS0n/s/P2JaTRMKlII01rLO3gK3+Q=;
        b=L8qWpjdJmgzu7fDGSTAGk13x7NsF9WIouXk64i8UQIdN98QXayan/y2ugDETkqowNH
         8scLRKPZdbOotJ5yqGqRfAttKwXwZ5vmRjBXVA6QY/2suWwFmeGtoWSRWpDbCHv4hZzu
         FnREcqHiLA3g7Q3DIC+V4SQXSOQRhUkxX0CuS5Ijg+AIiZOVVtd5xPtvPg8Z/38WEmeF
         bCvKeOATw885JpXVGOrb4xMSWrLrSMJ1Jix18l8OifseWpsOJ6JnomrcHj5PDuDWqoAR
         Ii1QVU2KGjaexiIhtcygEGkHaafxYKxosx2kua4aj9M12xO/ciVnTe22ZurQt1aprnJ1
         lP0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=EeZj1dGWsQkVJ1iS0n/s/P2JaTRMKlII01rLO3gK3+Q=;
        b=rBPpFtAUG+Emc8NKokEd7QqgOp1nLffRvMS7UnRXB6ZZTvXohdqnPem1RkD7sZ2A+G
         40AlfXtQ6jPYh4FO8NbMmJvf8s9wGzQeo/pHUfae1aoThz9SSq19bhR5rwN4ShR+3SKb
         BKBfI6xTz7zveuMy5EZxfni2YRhQGG6G42OhbWsfQ/9n5nNPD0XYIB9TU7CNYwIevcdv
         UMISGrguNUBy1GC5MM0it3f5bARRLrrL7htbetqjPsdqSoEv6ffywvn+r+wz5A8dFWdM
         A6FJo9u4tm0MHTd5YE7eE1LTWPSGlofFgag0Dv1HqXewUIcEY0hIhEMeKK3YnYKyCN+7
         wSpQ==
X-Gm-Message-State: AOAM5302M1hpy8NuurHh8n181EmlT16viPZWxyUb/Mqzp/bcTD7G/PMJ
        +AnP1EbPM8hSP+YD1DveCXY=
X-Google-Smtp-Source: ABdhPJy+PqqaPA+OnQJ7/hVk4A0vwg56Hg6gEahabjoKMAAZiiBABLtRdHtOZHfJmBMBGHMJQjDFZg==
X-Received: by 2002:a1c:f413:0:b0:37b:d1de:5762 with SMTP id z19-20020a1cf413000000b0037bd1de5762mr3991836wma.108.1651852656311;
        Fri, 06 May 2022 08:57:36 -0700 (PDT)
Received: from [192.168.8.198] ([85.255.237.75])
        by smtp.gmail.com with ESMTPSA id d10-20020adffd8a000000b0020c5253d925sm3850318wrr.113.2022.05.06.08.57.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 08:57:35 -0700 (PDT)
Message-ID: <31ae3426-b835-3a3f-f6d1-aecad24066e8@gmail.com>
Date:   Fri, 6 May 2022 16:57:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: linux-stable-5.10-y CVE-2022-1508 of io_uring module
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Guo Xuenan <guoxuenan@huawei.com>
Cc:     lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, yi.zhang@huawei.com, houtao1@huawei.com
References: <dd122760-5f87-10b1-e50d-388c2631c01a@kernel.dk>
 <20220505141159.3182874-1-guoxuenan@huawei.com>
 <7d54523e-372b-759b-1ebb-e0dbc181f18d@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <7d54523e-372b-759b-1ebb-e0dbc181f18d@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/6/22 03:16, Jens Axboe wrote:
> On 5/5/22 8:11 AM, Guo Xuenan wrote:
>> Hi, Pavel & Jens
>>
>> CVE-2022-1508[1] contains an patch[2] of io_uring. As Jones reported,
>> it is not enough only apply [2] to stable-5.10.
>> Io_uring is very valuable and active module of linux kernel.
>> I've tried to apply these two patches[3] [4] to my local 5.10 code, I
>> found my understanding of io_uring is not enough to resolve all conflicts.
>>
>> Since 5.10 is an important stable branch of linux, we would appreciate
>> your help in solving this problem.
> 
> Yes, this really needs to get buttoned up for 5.10. I seem to recall
> there was a reproducer for this that was somewhat saner than the
> syzbot one (which doesn't do anything for me). Pavel, do you have one?

No, it was the only repro and was triggering the problem
just fine back then

-- 
Pavel Begunkov
