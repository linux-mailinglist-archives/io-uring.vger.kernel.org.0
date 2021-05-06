Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE00337591C
	for <lists+io-uring@lfdr.de>; Thu,  6 May 2021 19:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236207AbhEFRUE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 May 2021 13:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235881AbhEFRUD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 May 2021 13:20:03 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D555C061763
        for <io-uring@vger.kernel.org>; Thu,  6 May 2021 10:19:05 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id h6so5396104ila.7
        for <io-uring@vger.kernel.org>; Thu, 06 May 2021 10:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4oeI1ENytqqmXNy/83BHktcOhvhEtV8ViBHQnvlBBP8=;
        b=E/R/KwewNXvJ99NdEBNNYYQyeOqw24RNHWJ6psYDBFTSwu57oZdq4HMeIAkfbHiKcR
         UPdYpUySlSJ2+MpVYxwmJIwre52IsuZjGBzIIp8ZpjaELc4qSb7TvUYh5j/cVKqD4UWH
         Jo/F346Aot+je9n5xfLpYwAZX/dZjgEQyO52jBnSKBSKlujpUwbaXp15TsE0lb5dg1tR
         XQa2hoUsImrh7KZGjzobfz3DfPSSsWULtfKeLjhbC81T1o5lPaymRniZGOgEGcrEAc/q
         ogdHRt7qSKH3b0XmaJJcw1aHmgAbOlBgyJMwUNlJxIuieA7aYEKDla7mZBQdwswKB8q4
         PMUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4oeI1ENytqqmXNy/83BHktcOhvhEtV8ViBHQnvlBBP8=;
        b=nTGRGuXpcGWlOdzIQ9pWxNPo08i1sqRn7Ax+lvAhNhX/SBJX0lsloAdLxj2jIrZu+X
         /FfbPOQcMoYgdsQpnlitEn/LgJbhYhL1hPCtcyTVrrPSg674Czc270rJUwMqmeM75oSP
         FUzEJB2OB4msqz1Y2nQq/vYBh7nPFKSdvGpNYKcs89QCFKaIXFZ5iflDrW+ny6IS1NeJ
         g1+CnX1VZOX0EvOFNTaGaPVSVqg5ysfgQEdzvh77fGTaCVGt2iwpBbIhLdjLCqCPbt0F
         1MIXUVz7GXfP3vGi3l0gBlhXVt+UW03t0K0wJI/JUf2888xg8Lq4B1mhYKB+ON4jS+tf
         Zsxg==
X-Gm-Message-State: AOAM531rnScQpXT0kZsBlsBicnV/mRXV7qHqdj5+sTgPZzbUOxUGkhAL
        H/7P7NbVwPwHGptWTrvIFp+y1xFz6KVQ3w==
X-Google-Smtp-Source: ABdhPJxfUaBQ5l68xWwyAiJqDO2ixxxOgiSx+I/HNxXVoj6sZ8RTolRwQ+jMnOH4fI8sTif6Dy6xqw==
X-Received: by 2002:a05:6e02:13e2:: with SMTP id w2mr5457598ilj.53.1620321544531;
        Thu, 06 May 2021 10:19:04 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w15sm1548985ill.78.2021.05.06.10.19.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 May 2021 10:19:03 -0700 (PDT)
Subject: Re: [PATCH] block: reexpand iov_iter after read/write
To:     Al Viro <viro@zeniv.linux.org.uk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     yangerkun <yangerkun@huawei.com>, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
References: <20210401071807.3328235-1-yangerkun@huawei.com>
 <a2e97190-936d-ebe0-2adc-748328076f31@gmail.com>
 <7ff7d1b7-8b6d-a684-1740-6a62565f77b6@gmail.com>
 <3368729f-e61d-d4b6-f2ae-e17ebe59280e@gmail.com>
 <3d6904c0-9719-8569-2ae8-dd9694da046b@huawei.com>
 <05803db5-c6de-e115-3db2-476454b20668@gmail.com>
 <YIwVzWEU97BylYK1@zeniv-ca.linux.org.uk>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2ee68ca3-e466-24d4-3766-8c627d94d71e@kernel.dk>
Date:   Thu, 6 May 2021 11:19:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YIwVzWEU97BylYK1@zeniv-ca.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/30/21 8:35 AM, Al Viro wrote:
> On Fri, Apr 30, 2021 at 01:57:22PM +0100, Pavel Begunkov wrote:
>> On 4/28/21 7:16 AM, yangerkun wrote:
>>> Hi,
>>>
>>> Should we pick this patch for 5.13?
>>
>> Looks ok to me
> 
> 	Looks sane.  BTW, Pavel, could you go over #untested.iov_iter
> and give it some beating?  Ideally - with per-commit profiling to see
> what speedups/slowdowns do they come with...
> 
> 	It's not in the final state (if nothing else, it needs to be
> rebased on top of xarray stuff, and there will be followup cleanups
> as well), but I'd appreciate testing and profiling data...
> 
> 	It does survive xfstests + LTP syscall tests, but that's about
> it.

Al, I ran your v3 branch of that and I didn't see anything in terms
of speedups. The test case is something that just writes to eventfd
a ton of times, enough to get a picture of the overall runtime. First
I ran with the existing baseline, which is eventfd using ->write():

Executed in  436.58 millis    fish           external
   usr time  106.21 millis  121.00 micros  106.09 millis
   sys time  331.32 millis   33.00 micros  331.29 millis

Executed in  436.84 millis    fish           external
   usr time  113.38 millis    0.00 micros  113.38 millis
   sys time  324.32 millis  226.00 micros  324.10 millis

Then I ran it with the eventfd ->write_iter() patch I posted:

Executed in  484.54 millis    fish           external
   usr time   93.19 millis  119.00 micros   93.07 millis
   sys time  391.35 millis   46.00 micros  391.30 millis

Executed in  485.45 millis    fish           external
   usr time   96.05 millis    0.00 micros   96.05 millis
   sys time  389.42 millis  216.00 micros  389.20 millis

Doing a quick profile, on the latter run with ->write_iter() we're
spending 8% of the time in _copy_from_iter(), and 4% in
new_sync_write(). That's obviously not there at all for the first case.
Both have about 4% in eventfd_write(). Non-iter case spends 1% in
copy_from_user().

Finally with your branch pulled in as well, iow using ->write_iter() for
eventfd and your iov changes:

Executed in  485.26 millis    fish           external
   usr time  103.09 millis   70.00 micros  103.03 millis
   sys time  382.18 millis   83.00 micros  382.09 millis

Executed in  485.16 millis    fish           external
   usr time  104.07 millis   69.00 micros  104.00 millis
   sys time  381.09 millis   94.00 micros  381.00 millis

and there's no real difference there. We're spending less time in
_copy_from_iter() (8% -> 6%) and less time in new_sync_write(), but
doesn't seem to manifest itself in reduced runtime.

-- 
Jens Axboe

