Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71AB72B4C84
	for <lists+io-uring@lfdr.de>; Mon, 16 Nov 2020 18:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732602AbgKPRTt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Nov 2020 12:19:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731546AbgKPRTs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Nov 2020 12:19:48 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643DCC0613CF
        for <io-uring@vger.kernel.org>; Mon, 16 Nov 2020 09:19:48 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id p19so341238wmg.0
        for <io-uring@vger.kernel.org>; Mon, 16 Nov 2020 09:19:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FsuMeccSqbcFvw+C2YiC9nvVun2JtksjBSxDOmLMLtc=;
        b=JF95AZhJOyoWvspGxqaZRHwVOKa9UA+qS7eEu5h/J7/jHSPmUb1BjFGGgidF4ARBKH
         yleGnrrwaa1e4YgkO4ywm+sj1ZpwPQCStLilY7UT+rJzgu/AHOta0BdDcRRgKcGO8U37
         w9zCa6iW5CqabxuGyl95rEUnIoEHETfU1xoeMcxLaq7rlHxOVPdaK3gHi6Yh+dZ0Q4Cl
         OszrlR4pFjlCevdmB/BGYVQ+kiVRg/rOJHQYyChYp58gtVN4KZJVFnZ/l+GGSDnK06FL
         wZBdwzuIq3a00DvaXc2yS3g28BZKa6BwGazjPTYYzkwnI9f8jyMlXq8FG8CJ9q1qs7K/
         y1ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FsuMeccSqbcFvw+C2YiC9nvVun2JtksjBSxDOmLMLtc=;
        b=juRCNriQ+z5fG10EFpiiUAMmT0f9j2XIIDqVNkfU4gLpK0BrcDSALNJFilZr5WMY9l
         OoumVIUgYs7F0BJvLU0B8TYn0syNIL4b3cHpwTcksFXBlDzzd+ktDU+t5en9zgq5+K/y
         moxqk6GMUBtqEsX4Z5SzfjoCEyi4SFpyxL/RMT4u76W0y5yCbIPmSRpoOmwzJgJtatO3
         VRRhmzkJGF5VKpvlK9SuFqw+wFMC4eMqXHDLuemj1Bw30gUzO83JRoxa5pVfecRagS22
         Y9AT4rTP/7Z9vqLE6TtQxnZ+ngQKC+QuIrcldHR/0c0T/PhfJgBaBVzl+GxgkNL+AWiU
         fFYg==
X-Gm-Message-State: AOAM533rqkKr58CwzkwHiqtGxx/+LrNdQAm1cxx+0t2vl1EJGovWEIn9
        Uh4zyHjVdfg7fMX8y0GBClVV3uroMFKOEA==
X-Google-Smtp-Source: ABdhPJy/srZDC+9dDKwBCGwDtR+cxWL3s4QFMcud9qlPbKtsdpu5EW6KwE+dsFmI+M9fduJXa4lvBQ==
X-Received: by 2002:a1c:3d44:: with SMTP id k65mr15787160wma.147.1605547186942;
        Mon, 16 Nov 2020 09:19:46 -0800 (PST)
Received: from [192.168.1.33] (host109-152-100-135.range109-152.btcentralplus.com. [109.152.100.135])
        by smtp.gmail.com with ESMTPSA id y16sm22541070wrt.25.2020.11.16.09.19.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 09:19:46 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <ce4f91e603b524b6425d68cf49c83c7d4fbd7d79.1605444955.git.asml.silence@gmail.com>
 <463ac36b-974d-f88c-d178-6e4d24fa4c93@kernel.dk>
 <6f58c74f-19d8-497b-e73e-8655a29601a8@gmail.com>
 <980e4479-5923-f776-e2d6-54e46014a0c7@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 1/1] io_uring: replace inflight_wait with tctx->wait
Message-ID: <7751bed7-2dc0-d72d-297f-de0c2e8fa5d9@gmail.com>
Date:   Mon, 16 Nov 2020 17:16:39 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <980e4479-5923-f776-e2d6-54e46014a0c7@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 16/11/2020 16:57, Jens Axboe wrote:
> On 11/16/20 9:48 AM, Pavel Begunkov wrote:
>> On 16/11/2020 16:33, Jens Axboe wrote:
>>> On 11/15/20 5:56 AM, Pavel Begunkov wrote:
>>>> As tasks now cancel only theirs requests, and inflight_wait is awaited
>>>> only in io_uring_cancel_files(), which should be called with ->in_idle
>>>> set, instead of keeping a separate inflight_wait use tctx->wait.
>>>>
>>>> That will add some spurious wakeups but actually is safer from point of
>>>> not hanging the task.
>>>>
>>>> e.g.
>>>> task1                   | IRQ
>>>>                         | *start* io_complete_rw_common(link)
>>>>                         |        link: req1 -> req2 -> req3(with files)
>>>> *cancel_files()         |
>>>> io_wq_cancel(), etc.    |
>>>>                         | put_req(link), adds to io-wq req2
>>>> schedule()              |
>>>>
>>>> So, task1 will never try to cancel req2 or req3. If req2 is
>>>> long-standing (e.g. read(empty_pipe)), this may hang.
>>>
>>> This looks like it's against 5.11, but also looks like we should add
>>> it for 5.10?
>>
>> Yeah, 5.10 completely slipped my mind, I'll resend
> 
> I applied it to 5.10, and fixed up the 5.11 side of things. So all good,
> just wanted to confirm.

Hmm, this won't work with 5.10, at least without

b7e7fb9960b03c ("io_uring: cancel only requests of current task")
https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.11/io_uring&id=b7e7fb9960b03ca07866b5c016ac3ce5373ef207

That's because tctx->wait is kicked only by requests of current task,
but 5.10 cancels everything with specified ->files, including owned
by other tasks.

-- 
Pavel Begunkov
