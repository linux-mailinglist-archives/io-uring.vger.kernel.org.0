Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06B0B225390
	for <lists+io-uring@lfdr.de>; Sun, 19 Jul 2020 20:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726051AbgGSSuC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jul 2020 14:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgGSSuB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jul 2020 14:50:01 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651ACC0619D2
        for <io-uring@vger.kernel.org>; Sun, 19 Jul 2020 11:50:01 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id k5so8891844pjg.3
        for <io-uring@vger.kernel.org>; Sun, 19 Jul 2020 11:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=yTlqUATRnE0s63HzxpBA+rXzM19bio3RIJ19h/IAN0w=;
        b=guGUAbuiJXvkEbB26UjVB2UNjunVMknOn2H2tmq32Z86fZ6tx1x4i9tVqN3W7peDSD
         HRTBz9aTtXNWDZPEd6tQiLr0736NPOw31lxFDmtqSJC31wL4kv7EdbSIIxIURjO/9cwZ
         hKTT/4E8el1X4zx4ZE0o/0NKJMq88dy3aGY+O/6lN0OahAYYfmlmjceKPcZnMzTzq3er
         R1BHfbnxZozgsjgZXVAfVr2rnE/vjWtIdNO2u8YDRlPNGaUUj1BhKeR6cz5+fAlJN41d
         41AYp9lllvSfpSd1Iv5BrxHY8xNYf2u6X8ZiOQGbbXvPormD/+n6IBJj7kuGpk8/qwTY
         7o0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yTlqUATRnE0s63HzxpBA+rXzM19bio3RIJ19h/IAN0w=;
        b=ivQy1tF1Yo3wG1AvXq7jMIbdkymaNGn1y4S8YOTSr/Wsb8atxW34bfb9LbAHtnTov5
         ZtPY/amGxUg8TrjTY6xoOfiNTg6amNm4655V0BlIo/n+00KtBTMZVrwHzm3YtBIJXkaN
         kQV79eC+j8EUUVrl3tlmPzGYXv7lLt+7kC20zX+yRnhZZOHgCmI9QmpN5VS+HzbKBAUg
         3VwaG7EcmV7Qj6o55MhM5d69QUwQv6Dj+uVlyDJIFv0bh3H4Kivj/nKImKR8Hx66kipr
         FP2ZQiIRiLHoLpNGT6x+cE+1eGipcsBxZLZb7fWsmiDy3RAXkG5ylApB452RumZoxsid
         fGUA==
X-Gm-Message-State: AOAM533lPV17Gr9qp074XLLB5k3pVuccAgpy+ShqOWmrUxxlyRdKsjZB
        2c1WL/XPBJs8zRIrCv6fDcFZIg==
X-Google-Smtp-Source: ABdhPJza7g1BGieCKCFFSCefJRiiIlmYxTysMi/VtJNtoeCO73SF3ZZJrTB27B3e7fwJ81Sfw//uFg==
X-Received: by 2002:a17:902:2:: with SMTP id 2mr15507403pla.288.1595184600757;
        Sun, 19 Jul 2020 11:50:00 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id z11sm14109568pfk.46.2020.07.19.11.49.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jul 2020 11:49:59 -0700 (PDT)
Subject: Re: [PATCH 0/2] task_put batching
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1595021626.git.asml.silence@gmail.com>
 <cf209c59-547e-0a69-244d-7c1fec00a978@kernel.dk>
 <edd8e7e4-efcf-0af1-c5d6-104635b65eb3@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a2eaec48-8211-07e2-2d8a-edc8af755ebc@kernel.dk>
Date:   Sun, 19 Jul 2020 12:49:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <edd8e7e4-efcf-0af1-c5d6-104635b65eb3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/19/20 5:15 AM, Pavel Begunkov wrote:
> On 18/07/2020 17:37, Jens Axboe wrote:
>> On 7/18/20 2:32 AM, Pavel Begunkov wrote:
>>> For my a bit exaggerated test case perf continues to show high CPU
>>> cosumption by io_dismantle(), and so calling it io_iopoll_complete().
>>> Even though the patch doesn't yield throughput increase for my setup,
>>> probably because the effect is hidden behind polling, but it definitely
>>> improves relative percentage. And the difference should only grow with
>>> increasing number of CPUs. Another reason to have this is that atomics
>>> may affect other parallel tasks (e.g. which doesn't use io_uring)
>>>
>>> before:
>>> io_iopoll_complete: 5.29%
>>> io_dismantle_req:   2.16%
>>>
>>> after:
>>> io_iopoll_complete: 3.39%
>>> io_dismantle_req:   0.465%
>>
>> Still not seeing a win here, but it's clean and it _should_ work. For
> 
> Well, if this thing is useful, it'd be hard to quantify, because active
> polling would hide it. I think, it'd need to apply a lot of isolated

It should be very visible in my setup, as we're CPU limited, not device
limited. Hence it makes it very easy to show CPU gains, as they directly
translate into improved performance.

> pressure on cache synchronisation (e.g. spam with barriers), or try to
> create and measure an atomic heavy task pinned to another core. Don't
> worth the effort IMHO.
> `
> Just out of curiosity, let me ask how do you test it?
> - is it a VM?
> - how many cores and threads do you use?
> - how many io_uring instances you have? Per thread?
> - Is it all goes to a single NVMe SSD?

It's not a VM, it's a normal box. I'm using just one CPU, one thread,
and just one NVMe device. That's my goto test for seeing if we reclaimed
some CPU cycles.

-- 
Jens Axboe

