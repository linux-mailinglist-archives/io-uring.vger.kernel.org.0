Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0A1C3D8363
	for <lists+io-uring@lfdr.de>; Wed, 28 Jul 2021 00:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232336AbhG0Wqw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Jul 2021 18:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232314AbhG0Wqw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Jul 2021 18:46:52 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19572C061757
        for <io-uring@vger.kernel.org>; Tue, 27 Jul 2021 15:46:51 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id ca5so2161515pjb.5
        for <io-uring@vger.kernel.org>; Tue, 27 Jul 2021 15:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cPJjrHcFC0UWl7adeUhoxVy2DiSKG6WYwPhs/wJlyws=;
        b=HI/dCIwMfD9w2kdQ+LNIRF5VGykoAaMoLkc5RkJhZq+5HO9/GH0VJm3e587ywPOISg
         FNaA7GahM/QWYnhEqi+HaHdlOFzceqJvOYTsSN81NVrjphyj01P38Pw4mInTfVtT0cDg
         cZgAycmu6kkEsO3TCwjjbDWp+5j9KopTIm+MtcTecRdMH7bj9cB8Dm2vk0VlOVGM85jx
         5S+sCQdNd7bFJ7/1yQVkSVKOGhrYOhBMpG5ctBGC7WalRHYfqDeZ39QyihOowGgNiJAK
         En/Z8PeV5V6JORmuzlDZ/fFkd8dWH9v8xlvWdzeLTZpPO+2o5d9ofexoNTg52VhlHfsf
         tobg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cPJjrHcFC0UWl7adeUhoxVy2DiSKG6WYwPhs/wJlyws=;
        b=bwUlt9ybiMCv/x7PBSAiNEo6gRYsrdvdzJTXB/m2MabxHKPp+R3hVqc/SYUKa73fUb
         RLprZGBjHCHnuLaoBrzNUatmkiSEmPOwX62bKBDtyuy3KX1WsSWDjYbUv0W4MCi2lm90
         tiY4tnWUDvWzmu2Kys/1bbgrOfBiXtxOX0+OHr19NRtVBI8kABq81yq6dHxJ2aeiqvng
         X2A05KTZPS+jm1mriMKpaMfRXTgs1ud9kr6ZZQvOehWrXND1aaMpOuuMAG4Sw3FSmZwV
         dL7LD7IPY3CtrzsCGZ9Lqhz41yVQkNwWp+E2jARpZI1G5KK+6cWIWcCww5OT+XXBNV5X
         xR/Q==
X-Gm-Message-State: AOAM530pT/WoWMyE4A0pM2B/AyCi4Vz/AA8Fnjo3kHKBAeC3xKbb3p5X
        Y1Nwy41Vtdrrt9gGbv1R4BfPIA==
X-Google-Smtp-Source: ABdhPJwnhPBENaaunmF6rbb3AeEDH5dRyJq1OgjF77a1P3xMBZGgUZIDhpmXJpJZWHfY4aKev0wj8g==
X-Received: by 2002:a17:90a:fef:: with SMTP id 102mr6256195pjz.148.1627426010606;
        Tue, 27 Jul 2021 15:46:50 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id e35sm4001780pjk.28.2021.07.27.15.46.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jul 2021 15:46:49 -0700 (PDT)
Subject: Re: [PATCH io_uring-5.14 v2] io_uring: remove double poll wait entry
 for pure poll
To:     Hao Xu <haoxu@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210723092227.137526-1-haoxu@linux.alibaba.com>
 <c628d5bc-ee34-bf43-c7bc-5b52cf983cb1@gmail.com>
 <824dcbe0-34da-a075-12eb-ce7529f3e3f7@linux.alibaba.com>
 <28ce8b3d-e9d2-2fed-e73c-fb09913eea78@gmail.com>
 <a5321436-9ba5-5f07-6081-4567f9469631@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <85703a7e-40cd-1f80-9ca4-9c0a2f665e45@kernel.dk>
Date:   Tue, 27 Jul 2021 16:46:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a5321436-9ba5-5f07-6081-4567f9469631@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/26/21 8:39 AM, Hao Xu wrote:
> 在 2021/7/26 下午8:40, Pavel Begunkov 写道:
>> On 7/24/21 5:48 AM, Hao Xu wrote:
>>> 在 2021/7/23 下午10:31, Pavel Begunkov 写道:
>>>> On 7/23/21 10:22 AM, Hao Xu wrote:
>>>>> For pure poll requests, we should remove the double poll wait entry.
>>>>> And io_poll_remove_double() is good enough for it compared with
>>>>> io_poll_remove_waitqs().
>>>>
>>>> 5.14 in the subject hints me that it's a fix. Is it?
>>>> Can you add what it fixes or expand on why it's better?
>>> Hi Pavel, I found that for poll_add() requests, it doesn't remove the
>>> double poll wait entry when it's done, neither after vfs_poll() or in
>>> the poll completion handler. The patch is mainly to fix it.
>>
>> Ok, sounds good. Please resend with updated description, and
>> let's add some tags.
>>
>> Fixes: 88e41cf928a6 ("io_uring: add multishot mode for IORING_OP_POLL_ADD")
>> Cc: stable@vger.kernel.org # 5.13+
>>
>> Also, I'd prefer the commit title to make more clear that it's a
>> fix. E.g. "io_uring: fix poll requests leaking second poll entries".
>>
>> Btw, seems it should fix hangs in ./poll-mshot-update
> Sure，I'll send v3 soon, sorry for my unprofessionalism..

Are you going to send out v3?

-- 
Jens Axboe

