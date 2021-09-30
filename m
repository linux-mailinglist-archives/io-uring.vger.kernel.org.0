Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E3D41D5BC
	for <lists+io-uring@lfdr.de>; Thu, 30 Sep 2021 10:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348546AbhI3Ixi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Sep 2021 04:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348505AbhI3Ixi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Sep 2021 04:53:38 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CC0C06176A
        for <io-uring@vger.kernel.org>; Thu, 30 Sep 2021 01:51:55 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id v127so3989366wme.5
        for <io-uring@vger.kernel.org>; Thu, 30 Sep 2021 01:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QE2tX2TgNletR60E4iTdGkDNr8Kaqo8ED4meEvGS2dg=;
        b=KoImmKr6IQNGlPMzVlWPWNhFzzBVesLhSlw8tvjYMci1Fe7rGcogioNk+4D6pLbK08
         76w9HYgRi3uroGlyJ3cZF89VSPSAeg4Jw2yvxf36pycsmucZU9sOOuKciactXgcZ6kta
         KRuByMpMj8UXNeHFIZrBNoJfEn37LZxJBkU15nzH8xtH86myKoxPRrFCRa/zgMkiBQr2
         XD5w+wo4gkOfdi2+GuDWW8m+4LVi3qzWStFHdnNam7s904P40L0UE1JqEhGnzRKaCEGG
         6sfK/Eu12XwqPGcw6YyXyFuL/E/bsTnWWkog6RUsu3oNMM4IY+psX7OmR+vd9rVaAuUU
         Xkuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QE2tX2TgNletR60E4iTdGkDNr8Kaqo8ED4meEvGS2dg=;
        b=US8ljRtsqcbvdomgGDu+KWr+jACQ8STKX8Wgm08N1OR7pj9KsYfYX1iQPEL1/wNTb+
         IRhTdD8IU1g5729c2PAs5Juwx6IDE1zcvpupcx+ozoLiiQgNmvvfhYZ6aZM4H6mCdvbT
         eaCFfjk8xENJb3xmxsPlVCfKBNuPddeBVPCCrUXb+gnjwL6Xhm5ZgsBHo+cC2oNz/O26
         dCmiiCPgR1NTSpGyORvGtwfs7COARu+WdF6OFKTJDZG7v//zGAfFLugARI9fsEeSRheC
         7oPGi4y4RFW3Lo7iKBUnDN/doQQbczw0ORKJ1s+jrDs0KB6JwsMx1UqkVMAm/+XSANWi
         hxvg==
X-Gm-Message-State: AOAM530Fyh0qDY+s2EF4ahVLE6G1zbi9CrvRC+UFaJbrJBNITTpydMFJ
        n5Xc5hthJeasHMmJzwnn6hpyxrWaFkE=
X-Google-Smtp-Source: ABdhPJwn89XhwvaXrXxbKdZNcVYIUjhu8zdjUzuJuOHzO5jlLpXXEPHUhAgZtfrwdnRGUdLWeBpv9A==
X-Received: by 2002:a05:600c:4e93:: with SMTP id f19mr14532359wmq.185.1632991914593;
        Thu, 30 Sep 2021 01:51:54 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.40])
        by smtp.gmail.com with ESMTPSA id v17sm2484244wro.34.2021.09.30.01.51.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 01:51:54 -0700 (PDT)
Subject: Re: [PATCH RFC 5.13 1/2] io_uring: add support for ns granularity of
 io_sq_thread_idle
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619616748-17149-1-git-send-email-haoxu@linux.alibaba.com>
 <1619616748-17149-2-git-send-email-haoxu@linux.alibaba.com>
 <7136bf4f-089f-25d5-eaf8-1f55b946c005@gmail.com>
 <51308ac4-03b7-0f66-7f26-8678807195ca@linux.alibaba.com>
 <96ef70e8-7abf-d820-3cca-0f8aedc969d8@gmail.com>
 <0d781b5f-3d2d-5ad4-9ad3-8fabc994313a@linux.alibaba.com>
 <11c738b2-8024-1870-d54b-79e89c5bea54@gmail.com>
 <10358b7e-9eb3-290f-34b6-5f257e98bcb9@linux.alibaba.com>
 <f9c93212-1bc9-5025-f96d-510bbde84e21@gmail.com>
 <5af509fe-b9f7-7913-defd-4d32d4f98f4e@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <02ea256c-bdb5-2fba-d9a3-da04236586a5@gmail.com>
Date:   Thu, 30 Sep 2021 09:51:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <5af509fe-b9f7-7913-defd-4d32d4f98f4e@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/29/21 1:13 PM, Hao Xu wrote:
> 在 2021/9/29 下午7:37, Pavel Begunkov 写道:
>> On 9/29/21 10:24 AM, Hao Xu wrote:
>>> 在 2021/9/28 下午6:51, Pavel Begunkov 写道:
>>>> On 9/26/21 11:00 AM, Hao Xu wrote:
>> [...]
>>>>> I'm gonna pick this one up again, currently this patch
>>>>> with ktime_get_ns() works good on our productions. This
>>>>> patch makes the latency a bit higher than before, but
>>>>> still lower than aio.
>>>>> I haven't gotten a faster alternate for ktime_get_ns(),
>>>>> any hints?
>>>>
>>>> Good, I'd suggest to look through Documentation/core-api/timekeeping.rst
>>>> In particular coarse variants may be of interest.
>>>> https://www.kernel.org/doc/html/latest/core-api/timekeeping.html#coarse-and-fast-ns-access
>>>>
>>> The coarse functions seems to be like jiffies, because they use the last
>>> timer tick(from the explanation in that doc, it seems the timer tick is
>>> in the same frequency as jiffies update). So I believe it is just
>>> another format of jiffies which is low accurate.
>>
>> I haven't looked into the details, but it seems that unlike jiffies for
>> the coarse mode 10ms (or whatever) is the worst case, but it _may_ be
> Maybe I'm wrong, but for jiffies, 10ms uis also the worst case, no?
> (say HZ = 100, then jiffies updated by 1 every 10ms)

I'm speculating, but it sounds it's updated on every call to ktime_ns()
in the system, so if someone else calls ktime_ns() every 1us, than the
resolution will be 1us, where with jiffies the update interval is strictly
10ms when HZ=100. May be not true, need to see the code.


>> much better on average and feasible for your case, but can't predict
>> if that's really the case in a real system and what will be the
>> relative error comparing to normal ktime_ns().
>>
> 

-- 
Pavel Begunkov
