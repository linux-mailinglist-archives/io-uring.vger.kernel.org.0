Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A41F3938A7
	for <lists+io-uring@lfdr.de>; Fri, 28 May 2021 00:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236083AbhE0WUM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 May 2021 18:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236024AbhE0WUK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 May 2021 18:20:10 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0367FC061574
        for <io-uring@vger.kernel.org>; Thu, 27 May 2021 15:18:36 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id p7so1307205wru.10
        for <io-uring@vger.kernel.org>; Thu, 27 May 2021 15:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TIRIowBxLrLeOVctaY4W7AyAAHic2j3+szZoMY9q70o=;
        b=sv8PnCb/4VZ3ISzuAsUCAMipEdtIGx1bVRNjkQcVYgqzL0hzTweN3LwwOv60XSIqG3
         qhOoiMLPHwh1vWaW6DexZZ4at4gP4ORQVrk80AT6N+gy3uNymt13sAp9pgIL6hSYVb6F
         auSDPb2FI4zBi0lTpPElZWg0Z2hLR4SYv+XFGqMlTsjn7RfU5umzojaUSRXtfuOHWqXn
         UEEoY74YlAvmM1WdXknNxhh4a6i3D/BkQJHsoqMTDpikUOsDE9rhWN7g/DMIabDSPLJx
         WWO6lBKpdNpiDZ7yCDLjEv2V8Oak7VCVgWOAnjo2vXIWdR2UoTo3DeWYUYTMUAPcVykP
         YeNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TIRIowBxLrLeOVctaY4W7AyAAHic2j3+szZoMY9q70o=;
        b=WkhApAuT7U53zOdb1ZRBgEoCZHzMKS4869WcGdCWggopR2DKHuZNdDNEc3C+xtEnQF
         bSt0Z4l1pmN5iZOmI7SuiBNTh1H9H/qNABRj8rld73qlOEU08MjKYslOshirqeBnXW30
         5zWwL9iuIl5Io2ST55ZgfJuOJYcY9SjeYWLMzhqilMXzmw6pHfF5CK2pRWtp8/HBi3G6
         MxBcXOtz/WwbGTGYLqWfMl0BkXZyX9H5KkoT+9LD7DBCWBf9Ad+UWnswSI0S8GWGIw7R
         GNoUxTwFX0cjSc3ykUNMoeZhGYVgWoZXFRi5fqbxUwLGgZzQkAPubU25PHeRTV6Byupu
         nrew==
X-Gm-Message-State: AOAM531Ld2+Dk9Fn1A/IsIET1MRrWR66sG9gPmtK1W2Lyv8p+iLfJEsH
        VVzA4lNv02j1/9Y6VnqB5u6A3F5vFyzm6Dt2
X-Google-Smtp-Source: ABdhPJwNFoBUWEl+mV0kXFnMse3+2q03LYgaPoHBe7hieQgAPd6vID30wkdfBlPc67ghDVdpOtjwNw==
X-Received: by 2002:adf:ee44:: with SMTP id w4mr5233945wro.415.1622153914312;
        Thu, 27 May 2021 15:18:34 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.129.19])
        by smtp.gmail.com with ESMTPSA id m7sm5621916wrv.35.2021.05.27.15.18.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 15:18:33 -0700 (PDT)
Subject: Re: [PATCH 05/13] io-wq: replace goto while
To:     Noah Goldstein <goldstein.w.n@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "open list:IO_URING" <io-uring@vger.kernel.org>
References: <cover.1621899872.git.asml.silence@gmail.com>
 <031ec5e0189daa5b21bf89117bdf30b1889c3f72.1621899872.git.asml.silence@gmail.com>
 <CAFUsyf+9f=w5WTZ65rMmYMOuSz7xLQ81rzAgEK=uG_a7gF_FWw@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <7999405c-49fe-1d24-580f-a647ad77d3c4@gmail.com>
Date:   Thu, 27 May 2021 23:18:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAFUsyf+9f=w5WTZ65rMmYMOuSz7xLQ81rzAgEK=uG_a7gF_FWw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/27/21 10:48 PM, Noah Goldstein wrote:
> On Mon, May 24, 2021 at 7:51 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> If for/while is simple enough it's more prefered over goto with labels
>> as the former one is more explicit and easier to read. So, replace a
>> trivial goto-based loop in io_wqe_worker() with a while.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>  fs/io-wq.c | 9 +++++----
>>  1 file changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/io-wq.c b/fs/io-wq.c
>> index a0e43d1b94af..712eb062f822 100644
>> --- a/fs/io-wq.c
>> +++ b/fs/io-wq.c
>> @@ -538,12 +538,13 @@ static int io_wqe_worker(void *data)
>>                 long ret;
>>
>>                 set_current_state(TASK_INTERRUPTIBLE);
>> -loop:
>> -               raw_spin_lock_irq(&wqe->lock);
>> -               if (io_wqe_run_queue(wqe)) {
>> +               while (1) {
>> +                       raw_spin_lock_irq(&wqe->lock);
> Can acquiring the spinlock be hoisted from the loop?

lock();
while(1) { ... }
unlock();

If this, then no. If taken inside io_worker_handle_work(),
maybe, but not with this commit.

>> +                       if (!io_wqe_run_queue(wqe))
>> +                               break;
>>                         io_worker_handle_work(worker);
>> -                       goto loop;
>>                 }
>> +
>>                 __io_worker_idle(wqe, worker);
>>                 raw_spin_unlock_irq(&wqe->lock);
>>                 if (io_flush_signals())
>> --
>> 2.31.1
>>

-- 
Pavel Begunkov
