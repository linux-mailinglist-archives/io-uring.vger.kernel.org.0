Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400D8233555
	for <lists+io-uring@lfdr.de>; Thu, 30 Jul 2020 17:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbgG3P2M (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jul 2020 11:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgG3P2L (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jul 2020 11:28:11 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB3BC061574
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 08:28:11 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id d18so28637308ion.0
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 08:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8jVoi6AWRWaySKq/Z1wuxDTaOTt1Y7QgccSLt54IWfc=;
        b=ZKunuK+bgRqulQJyQ/52V0Tfub2LItE2A1kONAgrGXJH/dEeKBLgS9ODX7XMedo4O1
         vNdfk98mVrH+q8ODYtwwFJGj4Mb6tsSdwBVEegA4VOrER4ac6mM+EHsMUf7HOUm+k9eL
         7xhQLMayRDmyxlM/BH4qdGyABE7i/UMkaqrJ5MSusqEhG0imNV3MMyZlUaihwyf4MMZy
         7bJDdJmH76rneXhLVawBR0pukePIa9yksHEe2S2cQMgO+rW1n3eTQV6V0DCMyAH3vtBc
         AW1z6N7UocM4SQlgJGtuBF6d3CLqAJqVAULIGqapsYW0PDNSnFbJur+tI9N/t9v0sUiq
         OGnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8jVoi6AWRWaySKq/Z1wuxDTaOTt1Y7QgccSLt54IWfc=;
        b=RLaalSy2rtOKcuZvk2UtzWUqyxFngrakUbTE357gR0KCKYZDb6g0DA6S4gqPs91Fz2
         NaPmYofEu/DI/Q4mO+IznionRAAJQBBJ2l+GP/HYvD3BA/qddbOgw8YtnhJjv7xDzP8i
         vn3iW/KHYu/TWT300Rl+K/myvWA6RkTHOxjqN4iK2n4RR3Kvw6Rv/YCMBv02uR5tVbJy
         MEDK0xgaQKKyKFuoFv2FPiJgsMqTZX/TtLvn/hYIk3b3La0kRS78tZlzjf4HaLugrJqc
         +diPifbN/KrtP4ySejeO/YROZg4pWms7Nqa9WS2jFum3yV8qr3cJzZo5Zof5nNev6CZ4
         cxOw==
X-Gm-Message-State: AOAM530FDrP19EI4g6BREUexVJUD4FfkogJo8UQ6gPrmGBu1ZsflTYNF
        TmN2oVakbt0n4RPmdT1HaEq329d09nU=
X-Google-Smtp-Source: ABdhPJyw9cEq0+24YPRIVk7Rjs4W+mG3iMm65ftVv2sSJ2zRsq6VgaT0iunrkphhYtqvNamHfSy0GQ==
X-Received: by 2002:a6b:ce01:: with SMTP id p1mr38278694iob.19.1596122890837;
        Thu, 30 Jul 2020 08:28:10 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id n10sm2794967iom.21.2020.07.30.08.28.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2020 08:28:10 -0700 (PDT)
Subject: Re: [PATCH liburing 1/2] io_uring_enter: add timeout support
To:     Jiufei Xue <jiufei.xue@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org
References: <1596017415-39101-1-git-send-email-jiufei.xue@linux.alibaba.com>
 <1596017415-39101-2-git-send-email-jiufei.xue@linux.alibaba.com>
 <0f6cdf31-fbec-d447-989d-969bb936838a@kernel.dk>
 <0002bd2c-1375-2b95-fe98-41ee0895141e@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <252c29a9-9fb4-a61f-6899-129fd04db4a0@kernel.dk>
Date:   Thu, 30 Jul 2020 09:28:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0002bd2c-1375-2b95-fe98-41ee0895141e@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/29/20 8:32 PM, Jiufei Xue wrote:
> Hi Jens,
> 
> On 2020/7/30 上午1:51, Jens Axboe wrote:
>> On 7/29/20 4:10 AM, Jiufei Xue wrote:
>>> Kernel can handle timeout when feature IORING_FEAT_GETEVENTS_TIMEOUT
>>> supported. Add two new interfaces: io_uring_wait_cqes2(),
>>> io_uring_wait_cqe_timeout2() for applications to use this feature.
>>
>> Why add new new interfaces, when the old ones already pass in the
>> timeout? Surely they could just use this new feature, instead of the
>> internal timeout, if it's available?
>>
> Applications use the old one may not call io_uring_submit() because
> io_uring_wait_cqes() will do it. So I considered to add a new one.

Not sure I see how that's a problem - previously, you could not do that
either, if you were doing separate submit/complete threads. So this
doesn't really add any new restrictions. The app can check for the
feature flag to see if it's safe to do so now.

>>> diff --git a/src/include/liburing.h b/src/include/liburing.h
>>> index 0505a4f..6176a63 100644
>>> --- a/src/include/liburing.h
>>> +++ b/src/include/liburing.h
>>> @@ -56,6 +56,7 @@ struct io_uring {
>>>  	struct io_uring_sq sq;
>>>  	struct io_uring_cq cq;
>>>  	unsigned flags;
>>> +	unsigned features;
>>>  	int ring_fd;
>>>  };
>>
>> This breaks the API, as it changes the size of the ring...
>>
> Oh, yes, I haven't considering that before. So could I add this feature
> bit to io_uring.flags. Any suggestion?

Either that, or we add this (and add pad that we can use later) and just
say that for the next release you have to re-compile against the lib.
That will break existing applications, unless they are recompiled... But
it might not be a bad idea to do so, just so we can pad io_uring out a
little bit to provide for future flexibility.

-- 
Jens Axboe

