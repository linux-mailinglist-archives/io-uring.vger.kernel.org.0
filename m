Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 870F32DE7FE
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 18:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbgLRRXj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 12:23:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727787AbgLRRXj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 12:23:39 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C58C0617A7
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 09:22:58 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id x12so1732372plr.10
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 09:22:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B/lMqkE8GrwRamTRXutWwusWFXlsvlOEI4TzF3UshQA=;
        b=x0n/07r07Se6cpzKAuenDK6y3ZJEdgXrt4b/JFv2w/hndxTdYhh5666qZ1JmVQek7B
         qb64E1WVHTX9L/06FsBmF1Crgv7yWdTXiWqhUO7QRbuPxMpHTqc+VyJx0xuZZpohdCf5
         fi+gq+Egvgk686UWKEh2EATT/LdT9i8g/sLPTjJ6+r7TmkJ/siTDs0118S861myZSbXZ
         7A/CBcUUvwC+esrTUGaZEhHDXWfoTfZumRG++oSiuglZGitrp+9NDmXbetftD6mGW6aX
         qgOSA34FGuOKe2IIb54Qyhhr5Db4XWF7GJ1HuPhhxJPDkjiBzS0k2EbYLAU2TAypQI3b
         C2xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B/lMqkE8GrwRamTRXutWwusWFXlsvlOEI4TzF3UshQA=;
        b=iHA3Mnmo1uaqts0lDk34UXCqHrDCvOLVPRggAsdoU1eVSKYclBt0ZOSYzwBElKbloW
         upUcHvTMmnX+BAiAtJmDNEQiW2Db8ZXzcjM0yyLOWnlXjMjd6y1y2nnd5Ee+Yg0KNuxX
         hfrewxmtfbjitoYW3RZLGIvIDA9pC5P2AU0WiFot2bdBWULqfIz5U+ZFNB/mwinnpsaa
         uX8LlSl57+lATTMF/JDpXtpMkAnCJQ9sFedO4K+6/t05NOFwQyeyOlK9ERohBfdKcRvW
         JWVM2/KmV6ZjVhMlpfnRDoFZK/H+A+39bAnkuD2Z+8VUyZbe4/ePEFrGH3bm5rf2GEC4
         uWCw==
X-Gm-Message-State: AOAM532LkI4OrWJzMUc7DJVCgOqa7RLQ55EcwRYXcKW5Kog8e503efwB
        WyLumzfA0kdvT5+nO62jeb3Qannl6JqPnA==
X-Google-Smtp-Source: ABdhPJzjCdubIVRanXbkO259qqCWGm7whymSmbFSlLel5PYV9gDXBn0T61GNX7EUcr0g7rd2k8s21g==
X-Received: by 2002:a17:902:7c92:b029:dc:1425:e5af with SMTP id y18-20020a1709027c92b02900dc1425e5afmr5421627pll.3.1608312177910;
        Fri, 18 Dec 2020 09:22:57 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id l8sm7756893pjt.32.2020.12.18.09.22.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Dec 2020 09:22:57 -0800 (PST)
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
To:     Dmitry Kadashev <dkadashev@gmail.com>,
        Victor Stewart <v@nametag.social>
Cc:     Josef <josef.grieb@gmail.com>,
        Norman Maurer <norman.maurer@googlemail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <CAOKbgA66u15F+_LArHZFRuXU9KAiq_K0Ky2EnFSh6vRv23UzSw@mail.gmail.com>
 <8910B0D3-6C84-448E-8295-3F87CFFB2E77@googlemail.com>
 <CAOKbgA4V5aGLbotXz4Zn-7z8yOP5Jy_gTkpwk3jDSNyVTRCtkg@mail.gmail.com>
 <CAOKbgA5X7WWQ4LWN4hXt8Rc5qQOOG24tTyxsKos7KO1ybOeC1w@mail.gmail.com>
 <CAAss7+owve47-D9SzLpzeCiPAOjKxhc5D2ZY-aQw5WOCvQA5wA@mail.gmail.com>
 <CAOKbgA7ojpGPMEc0vSGhhbyP3nE84pXUf=1E0OY4AQYsm+qgwA@mail.gmail.com>
 <CAM1kxwhfFvoV_SNyJkH3wPnhKpJGQ1DZ98rRobbrtTrszufsCA@mail.gmail.com>
 <CAOKbgA5g5=eC11JTUtZbZUbFj6rLmS+aVH_C4anB13pBZG+BMA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6f951d4f-9503-e214-50d3-405d96ae536e@kernel.dk>
Date:   Fri, 18 Dec 2020 10:22:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAOKbgA5g5=eC11JTUtZbZUbFj6rLmS+aVH_C4anB13pBZG+BMA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/18/20 2:20 AM, Dmitry Kadashev wrote:
> On Thu, Dec 17, 2020 at 8:43 PM Victor Stewart <v@nametag.social> wrote:
>>
>> On Thu, Dec 17, 2020 at 11:12 AM Dmitry Kadashev <dkadashev@gmail.com> wrote:
>>>
>>> On Thu, Dec 17, 2020 at 5:38 PM Josef <josef.grieb@gmail.com> wrote:
>>>>
>>>>>> That is curious. This ticket mentions Shmem though, and in our case it does
>>>>  > not look suspicious at all. E.g. on a box that has the problem at the moment:
>>>>  > Shmem:  41856 kB. The box has 256GB of RAM.
>>>>  >
>>>>  > But I'd (given my lack of knowledge) expect the issues to be related anyway.
>>>>
>>>> what about mapped? mapped is pretty high 1GB on my machine, I'm still
>>>> reproduce that in C...however the user process is killed but not the
>>>> io_wq_worker kernel processes, that's also the reason why the server
>>>> socket still listening(even if the user process is killed), the bug
>>>> only occurs(in netty) with a high number of operations and using
>>>> eventfd_write to unblock io_uring_enter(IORING_ENTER_GETEVENTS)
>>>>
>>>> (tested on kernel 5.9 and 5.10)
>>>
>>> Stats from another box with this problem (still 256G of RAM):
>>>
>>> Mlocked:           17096 kB
>>> Mapped:           171480 kB
>>> Shmem:             41880 kB
>>>
>>> Does not look suspicious at a glance. Number of io_wq* processes is 23-31.
>>>
>>> Uptime is 27 days, 24 rings per process, process was restarted 4 times, 3 out of
>>> these four the old instance was killed with SIGKILL. On the last process start
>>> 18 rings failed to initialize, but after that 6 more were initialized
>>> successfully. It was before the old instance was killed. Maybe it's related to
>>> the load and number of io-wq processes, e.g. some of them exited and a few more
>>> rings were initialized successfully.
>>
>> have you tried using IORING_SETUP_ATTACH_WQ?
>>
>> https://lkml.org/lkml/2020/1/27/763
> 
> No, I have not, but while using that might help to slow down progression of the
> issue, it won't fix it - at least if I understand correctly. The problem is not
> that those rings can't be created at all - there is no problem with that on a
> freshly booted box, but rather that after some (potentially abrupt) owning
> process terminations under load kernel gets into a state where - eventually - no
> new rings can be created at all. Not a single one. In the above example the
> issue just haven't progressed far enough yet.
> 
> In other words, there seems to be a leak / accounting problem in the io_uring
> code that is triggered by abrupt process termination under load (just no
> io_uring_queue_exit?) - this is not a usage problem.

Right, I don't think that's related at all. Might be a good idea in general
depending on your use case, but it won't really have any bearing on the
particular issue at hand.

-- 
Jens Axboe

