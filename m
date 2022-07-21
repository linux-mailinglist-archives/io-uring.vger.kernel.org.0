Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD6D57CF5E
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 17:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232657AbiGUPhE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jul 2022 11:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232521AbiGUPgm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jul 2022 11:36:42 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5C71CFF2
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 08:36:37 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id h145so1610946iof.9
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 08:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OrqRySjOXI9PvYjmbDKnaFiNO+kUpLoVvF3M+JCPY5w=;
        b=1Rw213sJDIxdGp4WSfsJmGL3scABePeE8hPw+he9EgsvijsbMVyru1RkWISlEXiGfG
         vssnYsYwEJ72TmRa2gWcnFjDH9xSi7dVmXF8etHF2xlwR8Bug8ZkzyPvWMwfYBZ3W7Ys
         a5R+mOpKaKbHK7dqfsURln+ocCsmTVpoJUPFyAknJP0C6VOPDWr+oIpgkCHDWTOeMcRo
         4d9REonScAqqvIlcyG8lhCejHhgnW2pbEKKUqTNnLr8Ao5+wlOtt7uyF1p2kS0jTanYi
         /tTOmRYpYS2tmcUH0J3j3HBOkUaldsazUN+lCmjbigsUbRrp+8aCEDXQukaN8oqVua9k
         UvlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OrqRySjOXI9PvYjmbDKnaFiNO+kUpLoVvF3M+JCPY5w=;
        b=yqsbYth8V36Nb4EogVGky6eMnR42SByAum3G2z/8Hbp+WewFA9B6nShBDZXfW3dKHh
         x/lB68yDTI+Gm1dhYOH3K5potp/gMQiSToR85UZxIjIT3iAaHmLjjow1MoHIfIgoEfe8
         Li+ZxWMDAAJYvHbzR44YMAk+VeQcNquCl+T+P7wJxpH1SUG4ZVybOl65Fmj+rl71GZyC
         q0Wg1xSfnfNbWNx4wgkk2xbHIkHhI8FARZcoyPpWzTX+KEZmMLhd9XpsSK7dpBaGVGw5
         HmuXeQWF5zjoaAglW4/LIYPxX3yQ0pN2cARRjgVrxeWP9LtGEk1pH3KDPfdWXapMcCT/
         pIPg==
X-Gm-Message-State: AJIora/SnWuN1IztNsGv9v7zoDVfOJKt1mqVeoi5lM+WQBKJCjuVBSzm
        f625B/0vAmpXAhcunFFZ1tVtHCVYljzIGg==
X-Google-Smtp-Source: AGRyM1sqPTsydK4ICbucfRYH92xSonQ+V8VoB0jFNrvs0xjFNALLyzQKyWn6AAy1jge9J69441SAmQ==
X-Received: by 2002:a05:6638:31c1:b0:33f:2450:46a9 with SMTP id n1-20020a05663831c100b0033f245046a9mr22550650jav.45.1658417796323;
        Thu, 21 Jul 2022 08:36:36 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id u14-20020a02b1ce000000b00339e42c3e2fsm914433jah.80.2022.07.21.08.36.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jul 2022 08:36:35 -0700 (PDT)
Message-ID: <2a1a1e2d-6c9c-acc8-ac46-78d30ba35a6a@kernel.dk>
Date:   Thu, 21 Jul 2022 09:36:34 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH liburing] Delete `src/syscall.c` and get back to use
 `__sys_io_uring*` functions
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Hao Xu <howeyxu@tencent.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <20220721090443.733104-1-ammarfaizi2@gnuweeb.org>
 <165841756488.96243.3609313686511469611.b4-ty@kernel.dk>
 <aa364933-4113-3e69-eed9-8fe6a8197f42@gnuweeb.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aa364933-4113-3e69-eed9-8fe6a8197f42@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/21/22 9:35 AM, Ammar Faizi wrote:
> On 7/21/22 10:32 PM, Jens Axboe wrote:
>> On Thu, 21 Jul 2022 16:04:43 +0700, Ammar Faizi wrote:
>>> Back when I was adding nolibc support for liburing, I added new
>>> wrapper functions for io_uring system calls. They are ____sys_io_uring*
>>> functions (with 4 underscores), all defined as an inline function.
>>>
>>> I left __sys_uring* functions (with 2 underscores) live in syscall.c
>>> because I thought it might break the user if we delete them. But it
>>> turned out that I was wrong, no user should use these functions
>>> because we don't export them. This situation is reflected in
>>> liburing.map and liburing.h which don't have those functions.
>>>
>>> [...]
>>
>> Applied, thanks!
>>
>> [1/1] Delete `src/syscall.c` and get back to use `__sys_io_uring*` functions
>>        commit: 4aa1a8aefc3dc3875621c64cef0087968e57181d
> 
> Sorry Jens, it breaks other architectures, will send a patch shortly.

I ran x86-64 and aarch64, seems that it did indeed break x86. I'll wait
for your patch.

-- 
Jens Axboe

