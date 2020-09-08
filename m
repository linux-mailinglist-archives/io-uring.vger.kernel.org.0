Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8EEF2617FD
	for <lists+io-uring@lfdr.de>; Tue,  8 Sep 2020 19:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731760AbgIHRqm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Sep 2020 13:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731900AbgIHRq0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Sep 2020 13:46:26 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9808FC061756
        for <io-uring@vger.kernel.org>; Tue,  8 Sep 2020 10:46:25 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id l4so16245702ilq.2
        for <io-uring@vger.kernel.org>; Tue, 08 Sep 2020 10:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IW9/ysYOgZTPDE2ml9+Vo0aYgTilQfixVfrjQMzOlis=;
        b=Xvv5M77VDUDBNopVZl5AyrToeHUwunjthRynB7JFmFJTNrwkDaetHsYNi3p47NagmR
         nNBLeNf10JOzU6MO0pnSRWHl3kvQ5Pd/0E1bMpWuBLfV3Apww6w4vaps2/APgt7NSHWW
         6qmBrvVhvD3cCh2MVy3v6a+0svQIA8uH/CsL9tmfVKmiufJfccaodmsByZ6CUDj5A8d7
         X6UlQZbwqnuqMUH6rw9Ocj1HkYX6Vb8rh9RFZJ3PWB+aPJ7Yprk2ITeTBJFNwE1ppO6V
         +yLgLYQXps5NvV1uZ1j3LPyLAM5pkhx8LhXDP/SHWjnryL9ERgPlBCrJqodnZPV4pU1e
         lFlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IW9/ysYOgZTPDE2ml9+Vo0aYgTilQfixVfrjQMzOlis=;
        b=EUnI62q2ckXSlR+gZSaOD8ocojVzMuMn5lBXlmjtjircd2DEH8jhUc/Hw+og7Ywhqs
         9yFtA8Ki43b2Oe1/pecKSUQNRVILgJ/8HV8r7lo4ARIaWKZB6xoJIJ9QUG29FTOX3NAm
         WGubplsKzyS0aZw2oGPmzC0MUq8rym87FzaBy5im0X8n5vBl0be5oGAyIzMhnKUKSiDw
         RieaIiqri1WLJUPdLIJ/zMYRERvwI7w4dvyCTigCMmp+k9UTJEXdTkIpxR5mlgKlO81A
         NOr2easyjjiIAuyYN4/B5rV369q/grex2z/Dc+KuzRPxm/FWoen98IudzWS07AFZdLSM
         iKyA==
X-Gm-Message-State: AOAM530bYwBD9Kds8m5RxI1s8IfeSEsZK6RXu4L5TtFyDr/XHkOUIcsA
        uzzHlkIZq5aBZYOMZ6XIRngTBA==
X-Google-Smtp-Source: ABdhPJyZBEN6vBiw1ZVDLU3hy1UaEi51g7IQbhLgujVqHbzGeqLcz8/O3wQrvAFIkFTr8p25TgWN2w==
X-Received: by 2002:a05:6e02:c6e:: with SMTP id f14mr22569559ilj.60.1599587184799;
        Tue, 08 Sep 2020 10:46:24 -0700 (PDT)
Received: from [192.168.1.10] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e4sm7471iom.14.2020.09.08.10.46.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 10:46:24 -0700 (PDT)
Subject: Re: SQPOLL question
To:     Josef <josef.grieb@gmail.com>, io-uring@vger.kernel.org
Cc:     norman@apache.org
References: <CAAss7+p8iVOsP8Z7Yn2691-NU-OGrsvYd6VY9UM6qOgNwNF_1Q@mail.gmail.com>
 <68c62a2d-e110-94cc-f659-e8b34a244218@kernel.dk>
 <CAAss7+qjPqGMMLQAtdRDDpp_4s1RFexXtn7-5Sxo7SAdxHX3Zg@mail.gmail.com>
 <711545e2-4c07-9a16-3a1d-7704c901dd12@kernel.dk>
 <CAAss7+rgZ+9GsMq8rRN11FerWjMRosBgAv=Dokw+5QfBsUE4Uw@mail.gmail.com>
 <93e9b2a2-b4b4-3cde-b5a7-64c8c504848d@kernel.dk>
 <CAAss7+oa=tyf00Kudp-4O=TiduDUFZueuYvwRQsAEWxLfWQc-g@mail.gmail.com>
 <8f22db0e-e539-49b0-456a-fa74e2b56001@kernel.dk>
 <CAAss7+pjbh2puVsQTOt7ymKSmbruBZbaOvB8tqfw0z-cMuhJYg@mail.gmail.com>
 <cd44ec4a-41b9-0fa0-877d-710991b206f1@kernel.dk>
 <dd59bd5e-cb81-98c1-4bc8-fa1a290429c2@kernel.dk>
 <CAAss7+oJF-KMRAnkjMWmW9Zd-dNnTojFOeC7LR-AoHcJDOc36Q@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <79ffa584-237a-0d81-7ae3-6581ae6c8c48@kernel.dk>
Date:   Tue, 8 Sep 2020 11:46:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAAss7+oJF-KMRAnkjMWmW9Zd-dNnTojFOeC7LR-AoHcJDOc36Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/8/20 11:42 AM, Josef wrote:
>> Are you using for-5.10 and SQEPOLL + ASYNC accept? I'll give that a
>> test spin.
> 
> yes exactly
> 
>> This should do it for your testing, need to confirm this is absolutely
>> safe. But it'll make it work for the 5.10/io_uring setup of allowing
>> file open/closes.
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 80913973337a..e21a7a9c6a59 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -6757,7 +6757,7 @@ static enum sq_ret __io_sq_thread(struct io_ring_ctx *ctx,
>>
>>         mutex_lock(&ctx->uring_lock);
>>         if (likely(!percpu_ref_is_dying(&ctx->refs)))
>> -               ret = io_submit_sqes(ctx, to_submit, NULL, -1);
>> +               ret = io_submit_sqes(ctx, to_submit, ctx->ring_file, ctx->ring_fd);
>>         mutex_unlock(&ctx->uring_lock);
>>
>>         if (!io_sqring_full(ctx) && wq_has_sleeper(&ctx->sqo_sq_wait))
>> @@ -8966,6 +8966,11 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
>>                 goto err;
>>         }
>>
>> +       if (p->flags & IORING_SETUP_SQPOLL) {
>> +               ctx->ring_fd = fd;
>> +               ctx->ring_file = file;
>> +       }
>> +
>>         ret = io_sq_offload_create(ctx, p);
>>         if (ret)
>>                 goto err;
>>
> 
> sorry I couldn't apply this patch, my last commit is
> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/commit/?h=for-5.10/io_uring&id=9c2446cffaf55da88e7a9a7c0a5aeb02a9eba2c0
> what's your last commit?
> 
> it's a small patch, so I'll try it manually :)

Oops sorry, pushed out the queue. Should apply cleanly on top of that.

-- 
Jens Axboe

