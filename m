Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E947055E97E
	for <lists+io-uring@lfdr.de>; Tue, 28 Jun 2022 18:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiF1QUd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jun 2022 12:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237194AbiF1QTq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jun 2022 12:19:46 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B88F03AA49
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 09:12:30 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 23so12638629pgc.8
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 09:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=kgYaAZrlSeo0dmxhHtmkYtWSbK7b0bYeLWDaKtpANxk=;
        b=WIFcWcoKEVyzE/IG6byQm6qmhMwLxGQmLs10KKKsDrT3pTOQEyO8IEis77KIXpgJ5I
         lqt+7fb/UNZvmfhtSsqblSJXvAVMAV98PH4RGTI7oqSW/SBPsUo7zUQ9R2SJrBUySHgE
         YGa/WuduTwXyECwoCx33G88CHKNr7wOnWCEv+El/E7ew6VmiVKaN9rmJI3U6zJl51D3K
         FPvHdl5FqU/NnqURaXwZIey+5zvF5A4e/+9ugNETQI1x4oRQirXdQW0NN3uTS72noKoK
         buA9TnnYHSMzIBYBbijCNZRoorFBdPBH30aEfRXuy41yyYQr0aLywP15eFT/2L44Uon2
         c2wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kgYaAZrlSeo0dmxhHtmkYtWSbK7b0bYeLWDaKtpANxk=;
        b=yD/kno1X8leIM2Zb9ddHfYXQnapJDVw9PiiMvOXqS8qfc0Ey6EpUcztO8b+726DpDW
         oaUJSqQVOdaGoukfjn2xpSTfzTLc3ls0PtaypSHGCsYcZnNk6G6l2PlkXF9xCa8ddToa
         IGL2vPRMQMy4Sk8XB/fDjB1n2l2BLI5DS2gPh/EMbDdbYEYQltG8YtMrQgzKgnw7W4Vo
         1CB2hRwSBIb3pLmm2BDgW8Z0E5mCHL24C6dPMiiVcNDCPeRvzQkWeo6tEn0DtJQU6KzQ
         02C79tSbE101b7ywZRsOnyfa0LAuTfpysLFhcrwWyEGv9kmNr45+UTNsHDifkiND3ks8
         0nmQ==
X-Gm-Message-State: AJIora9b+y0KHGWuqlp+Yk6dtcqeoEhxPdbHrWyNitF+BIOuGByHo9kN
        qtFT1hykxNGg0fCub3e8f7jD+w==
X-Google-Smtp-Source: AGRyM1sITv6OlCcHTJ4NkKJ30PSN4qYEgJyYsGYL0PdaPIHl3HHkppfS3L/eJpfNvYwiKXwSGMJV3g==
X-Received: by 2002:a05:6a00:a8b:b0:4e1:52db:9e5c with SMTP id b11-20020a056a000a8b00b004e152db9e5cmr4280417pfl.38.1656432750082;
        Tue, 28 Jun 2022 09:12:30 -0700 (PDT)
Received: from ?IPV6:2620:10d:c085:21e1::165b? ([2620:10d:c090:400::5:f46f])
        by smtp.gmail.com with ESMTPSA id a3-20020a1709027e4300b0016b8b35d725sm2461913pln.95.2022.06.28.09.12.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 09:12:29 -0700 (PDT)
Message-ID: <f1feef16-6ea2-0653-238f-4aaee35060b6@kernel.dk>
Date:   Tue, 28 Jun 2022 10:12:27 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH liburing 2/4] add IORING_RECV_MULTISHOT to io_uring.h
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Dylan Yudaken <dylany@fb.com>
Cc:     Facebook Kernel Team <kernel-team@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Bart Van Assche <bvanassche@acm.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <20220628150414.1386435-1-dylany@fb.com>
 <20220628150414.1386435-3-dylany@fb.com>
 <684dc062-b152-db2b-1fb9-fbd52e0b21e5@gnuweeb.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <684dc062-b152-db2b-1fb9-fbd52e0b21e5@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/28/22 10:10 AM, Ammar Faizi wrote:
> On 6/28/22 10:04 PM, Dylan Yudaken wrote:
>> copy from include/uapi/linux/io_uring.h
>>
>> Signed-off-by: Dylan Yudaken <dylany@fb.com>
>> ---
>>   src/include/liburing/io_uring.h | 53 ++++++++++++++++++++++++---------
>>   1 file changed, 39 insertions(+), 14 deletions(-)
>>
>> diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
>> index 2f391c9..1e5bdb3 100644
>> --- a/src/include/liburing/io_uring.h
>> +++ b/src/include/liburing/io_uring.h
>> @@ -10,10 +10,7 @@
>>     #include <linux/fs.h>
>>   #include <linux/types.h>
>> -
>> -#ifdef __cplusplus
>> -extern "C" {
>> -#endif
> 
> Dylan,
> 
> That `extern "C"` thing is for C++, we shouldn't omit it.
> 
> Or better add that to the kernel tree as well, it won't break
> the kernel because we have a __cplusplus guard here.
> 
> Jens what do you think?

It'd be nice to keep them fully in sync. If I recall correctly, the only
differences right now is that clause, and the change to not using a zero
sized array at the end of a struct (which is slated for the kernel too).

-- 
Jens Axboe

