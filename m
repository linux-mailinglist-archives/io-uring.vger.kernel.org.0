Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0654834AAC4
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 16:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbhCZPBN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 11:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbhCZPBC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 11:01:02 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F5FBC0613AA
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:01:02 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id k8so5650172iop.12
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bg/XFgK0j4Bi2nzOGM6CJPuGBSSM2wwPb1IUUNZ4ZrY=;
        b=w5p4jCPEbegwqL/nLPd0eJhquxW4K7gr74rDlgmo0q9j5vfRhtfBbo3QQa8S56E8fu
         AGx2JxN0WMKpb2iZSEFWWrZE76sPsjvq7FRce0E2ewdJa2iSVOZcPR8WzLEFnx6w+ZPU
         YMDPY8WM5jVGiSkwE6QdEoJlpALgByfLgkqQ+vh/vtDanm1fByUbHfAGpasJCLNoTSeH
         93D7GXS8OzVYnnnPTln82sGuVUWABUnlMZ8tW6W9+qsJ2JdQ5emGr1422YvR+UXYDRdK
         hWRucUvSjF3XYTluWRew/75UOe0ljhp2ooDHLivMCE97IflSY5mdjTalDMt5NVqrjsv7
         4h8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bg/XFgK0j4Bi2nzOGM6CJPuGBSSM2wwPb1IUUNZ4ZrY=;
        b=mg10Et8dKcGaXuHJVfOm+o3ev8bWc+ACJpTDQYU2XgAOwroFIZUSNMQljRZQYl0zjO
         pBEckruSaVNOyW67Ooa46wUMtxj8RWcnZSTqaYCQWbvgfZYubvmQNVJCiKHdg2Skl5JW
         F6Mm3ARozIQR1/uvoYU3OfcGSy3Q0Gvh4zsp+h0k9kXqgpyHFttWWyWvTR/klgqh5TJ1
         jaxi6a8uFY3OWapxkOxvd2jwRiRInPFALa429azc3JzSw9s1PBBPZk7sHKatfLfmHYQj
         mg39CDwejtUVuba+qq4Cm/o10K/uzifxNN2kBks0DkdjqTZxmNkUsm7UuGdze9aQSw+Z
         UI4w==
X-Gm-Message-State: AOAM533FwBE3TU+8vdNQ26xYmhMJLY1Tm+vHwH5wmw9V9W97r248Y8iS
        uFZBVErwiQvrqf9Wj2H7kFvzIA==
X-Google-Smtp-Source: ABdhPJztBUwc5LhorRM9v0qt8CshTMiYbtZYm1iwC/n0UNrWtWPlWKltgXE2SKA9UpeDT9fnUgobjQ==
X-Received: by 2002:a05:6602:21cd:: with SMTP id c13mr10293909ioc.44.1616770861565;
        Fri, 26 Mar 2021 08:01:01 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id i67sm4584479ioa.3.2021.03.26.08.01.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 08:01:01 -0700 (PDT)
Subject: Re: [PATCH 2/8] kernel: unmask SIGSTOP for IO threads
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     io-uring@vger.kernel.org, torvalds@linux-foundation.org,
        ebiederm@xmission.com, metze@samba.org,
        linux-kernel@vger.kernel.org
References: <20210326003928.978750-1-axboe@kernel.dk>
 <20210326003928.978750-3-axboe@kernel.dk> <20210326134840.GA1290@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a179ad33-5656-b644-0d92-e74a6bd26cc8@kernel.dk>
Date:   Fri, 26 Mar 2021 09:01:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210326134840.GA1290@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/26/21 7:48 AM, Oleg Nesterov wrote:
> Jens, sorry, I got lost :/

Let's bring you back in :-)

> On 03/25, Jens Axboe wrote:
>>
>> With IO threads accepting signals, including SIGSTOP,
> 
> where can I find this change? Looks like I wasn't cc'ed...

It's this very series.

>> unmask the
>> SIGSTOP signal from the default blocked mask.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  kernel/fork.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/fork.c b/kernel/fork.c
>> index d3171e8e88e5..d5a40552910f 100644
>> --- a/kernel/fork.c
>> +++ b/kernel/fork.c
>> @@ -2435,7 +2435,7 @@ struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
>>  	tsk = copy_process(NULL, 0, node, &args);
>>  	if (!IS_ERR(tsk)) {
>>  		sigfillset(&tsk->blocked);
>> -		sigdelsetmask(&tsk->blocked, sigmask(SIGKILL));
>> +		sigdelsetmask(&tsk->blocked, sigmask(SIGKILL)|sigmask(SIGSTOP));
> 
> siginitsetinv(blocked, sigmask(SIGKILL)|sigmask(SIGSTOP)) but this is minor.

Ah thanks.

> To remind, either way this is racy and can't really help.
> 
> And if "IO threads accepting signals" then I don't understand why. Sorry,
> I must have missed something.

I do think the above is a no-op at this point, and we can probably just
kill it. Let me double check, hopefully we can just remove this blocked
part.

-- 
Jens Axboe

