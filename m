Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74A57402053
	for <lists+io-uring@lfdr.de>; Mon,  6 Sep 2021 21:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242746AbhIFTKz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Sep 2021 15:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233110AbhIFTKy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Sep 2021 15:10:54 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF63C061575
        for <io-uring@vger.kernel.org>; Mon,  6 Sep 2021 12:09:49 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id u15-20020a05600c19cf00b002f6445b8f55so591527wmq.0
        for <io-uring@vger.kernel.org>; Mon, 06 Sep 2021 12:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rdezSk6QE6Kto0alFMBEKLrCmjr3r5BqaN6o3TH0bpA=;
        b=gK30TrT2v9lWw6QfKtuJK3CDtJOMHZPWy746YGz/r+T02vWLrXR2ffRwXP/I2wRa+W
         QMgxLvKag8lQtVv5ItCg89JS/93PwltnJsW/FPW2ZcgSUVZqAYtrnPRNhfPY/qb00CSQ
         M2Xn7iBfmG4iIetbb42aWsOA6GKYiYva++NXETr14RSo8/SVWM+iEIv/hCN0uwCRUppU
         voBUEdkAGOdOGZHwg+rJhGc1mhRyWpQ7JIYBNZTRk6LqAR2k0vRPYJtMc1MC3Vpi1y/V
         wxd6Qv8x7jtWiWu4QdlwvvknZFZPmN9PPW01bMuY6HCOwKIYSBRlaGb5QP/Adb+urip9
         GELg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rdezSk6QE6Kto0alFMBEKLrCmjr3r5BqaN6o3TH0bpA=;
        b=IA/ZP7RUS370AuJPTmuzKlzJW8hyZmoYmwKRFEzODnUEOyrFyek0MaXVLkdCt7Dgz7
         MUnph0nKpKonS6ho5jGN23sfNJ7aYq4HJC/oLmuB7Bi4Rau5FadAoBKVnAKRtewmvfO8
         hnQvWotSs16oK4Mr8c+WWJi91pQ8YwS6HN3mMBCCyHpXAEn+uQXZiPXw1UhdHEbL+jnI
         9bDKu0dcj3thb+FwEax2JOL3o+KHMCoLF7B3sTazSKlkmcsnfuvgVUuAm1nvdI8UGird
         37GLldrt7pLdbaqb3YU3/EkXqq1u/IWzVK+sEgkf3EfEMshevFY7J4uzyHGntoAzinmd
         JA/Q==
X-Gm-Message-State: AOAM530I1wDOMnvr5D91fgYYAlCFY4LOUtA1ZRgJLyTJauv1rv0CYxvq
        daEM683EM11c4ju2TxvjA1U=
X-Google-Smtp-Source: ABdhPJyu7Kb5Badvnv+aJoH3QwuMWam0p08Cf1Lnco5t6VJq7lFgydCxZi3rF3iZk8wpOf1HkCXShw==
X-Received: by 2002:a05:600c:3209:: with SMTP id r9mr541174wmp.106.1630955388275;
        Mon, 06 Sep 2021 12:09:48 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.4])
        by smtp.gmail.com with ESMTPSA id h11sm10267314wrx.9.2021.09.06.12.09.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 12:09:47 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210903110049.132958-1-haoxu@linux.alibaba.com>
 <20210903110049.132958-5-haoxu@linux.alibaba.com>
 <b3ea4817-98d9-def8-d75e-9758ca7d1c33@gmail.com>
 <8f3046d9-d678-f755-e7af-a0e5040699ca@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 4/6] io_uring: let fast poll support multishot
Message-ID: <45ccd2d3-267c-16df-c4be-c4530f50db86@gmail.com>
Date:   Mon, 6 Sep 2021 20:09:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <8f3046d9-d678-f755-e7af-a0e5040699ca@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/6/21 6:40 PM, Hao Xu wrote:
> 在 2021/9/6 下午11:56, Pavel Begunkov 写道:
>> On 9/3/21 12:00 PM, Hao Xu wrote:
>>> For operations like accept, multishot is a useful feature, since we can
>>> reduce a number of accept sqe. Let's integrate it to fast poll, it may
>>> be good for other operations in the future.
>>
>> __io_arm_poll_handler()         |
>>    -> vfs_poll()                 |
>>                                  | io_async_task_func() // post CQE
>>                                  | ...
>>                                  | do_apoll_rewait();
>>    -> continues after vfs_poll(),|
>>       removing poll->head of     |
>>       the second poll attempt.   |
>>
>>
> Sorry.. a little bit confused by this case, would you mind explain a bit
> more..is the right part a system-workqueue context? and is
> do_apoll_rewait() io_poll_rewait() function?

I meant in a broad sense. If your patches make lifetime of an accept
request to be like:

accept() -> arm_apoll() -> apoll_func() -> accept() -> ...
    -> ... (repeat many times)

then do_apoll_rewait() is the second accept in the scheme.

If not, and it's

accept() -> arm_poll() -> apoll_func() -> apoll_func() ->
 ... -> ?

Then that "do_apoll_rewait()" should have been second and
other apoll_func()s.

So, it's rather a thing to look after, but not a particular
bug.


>> One of the reasons for forbidding multiple apoll's is that it
>> might be racy. I haven't looked into this implementation, but
>> we should check if there will be problems from that.
>>
>> FWIW, putting aside this patchset, the poll/apoll is not in
>> the best shape and can use some refactoring.
>>
>>
[...]

-- 
Pavel Begunkov
