Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3345B2D346C
	for <lists+io-uring@lfdr.de>; Tue,  8 Dec 2020 21:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729572AbgLHUkz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Dec 2020 15:40:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729571AbgLHUky (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Dec 2020 15:40:54 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 358E1C0613D6
        for <io-uring@vger.kernel.org>; Tue,  8 Dec 2020 12:40:14 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id 3so3503676wmg.4
        for <io-uring@vger.kernel.org>; Tue, 08 Dec 2020 12:40:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wgR6HmUWsqSh5iPS6e9irir1Uz5eGFpBK+sCJcu0rXc=;
        b=uf3OZUHNOglIIHClQxdCR7QylgDLxmlX6PfQngxPSjceMzBMXTAhFIpS2CPf3JftHM
         b3wzAt1ld9lJiwdlALmXtd4iKulDQEnVCpFNyps2eB8bNMF3qejKPJKLmXQHXjOBzblU
         rWRKs7fFcECpRVirsp4Xzd10WfI7aug0t2LYJ/wig9lgjdil3Ug4g6yEqsBkFOhMdS1d
         oTTVNZXvY4zNzARI+0M+W9PVsva45gE5cKxQfIN8J7/gfjCG785CF15xf43t2seMzWfk
         dq3BXngZ/38kT4fwhXVN/AortTyArvDvAnU3D95JaVRPvGCiOsKT/io2VpLI9AWbFkoF
         tM2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=wgR6HmUWsqSh5iPS6e9irir1Uz5eGFpBK+sCJcu0rXc=;
        b=p3ZvOm7ONTnmMVmu7wehQ+MaEReQdkS0Ou2S58UFR02RTSKpMQ8iPotjzvB0tvpb8Q
         0z+nUXTt93CiILGLDemftPikfTquk5dzKwsrW6gsSkSpHbG9KkEtoAHeCaqJtlNkTWsO
         kX+TveB+DLqYxIUQ9G7m0C7xb/aZGTDTgVgyDjMnOwFzeXEYEFF+qpcEoHerCrIQ72js
         1ktyICWi7aEx7gkrawtb1ZDhV+vLlUCOju+pk/CBZ4PIgMZDb0S8jhA8u0Dn83YkoRaD
         U411nlGKNspJ1CwV6ghrXk6cbg+bnAvg0VYpLZOBXYtLga65sJP3pmBu4HzXx2Pv7n9L
         fJXA==
X-Gm-Message-State: AOAM530BhpwC3F8bmhTrsjFf4xbXEBDgQSkFKg7+YT1LlYaxdZ6DXAAO
        SiKihfVUx1TZ6Pp2ZNSYq4OMtqvLLbaYOQ==
X-Google-Smtp-Source: ABdhPJwP4uOvja47XynvA9YIr9ZhaGwcge0o3z0lIoaXMK1y4A+Auo9qtjV75/hgdNydWefI+96sNw==
X-Received: by 2002:a1c:80c3:: with SMTP id b186mr5121575wmd.20.1607455657475;
        Tue, 08 Dec 2020 11:27:37 -0800 (PST)
Received: from [192.168.8.116] ([85.255.233.156])
        by smtp.gmail.com with ESMTPSA id z140sm5782511wmc.30.2020.12.08.11.27.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 11:27:36 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>
Cc:     xiaoguang.wang@linux.alibaba.com,
        io-uring <io-uring@vger.kernel.org>
References: <cover.1607293068.git.asml.silence@gmail.com>
 <cf556b9b870c640690a1705c073fe955c01dab47.1607293068.git.asml.silence@gmail.com>
 <10e20bd3-b08f-98b8-f857-8b9a75a511dd@kernel.dk>
 <d9f677a4-1ac0-0e64-5c2a-497cac9dc8e5@gmail.com>
 <33b5783d-c238-b0da-38cf-974736c36056@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 5.10 1/5] io_uring: always let io_iopoll_complete()
 complete polled io.
Message-ID: <89d04d6b-2f84-82af-9ee7-edeb69f2a5bb@gmail.com>
Date:   Tue, 8 Dec 2020 19:24:20 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <33b5783d-c238-b0da-38cf-974736c36056@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 08/12/2020 19:17, Jens Axboe wrote:
> On 12/8/20 12:12 PM, Pavel Begunkov wrote:
>> On 07/12/2020 16:28, Jens Axboe wrote:
>>> On Sun, Dec 6, 2020 at 3:26 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>> From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>>>>
>>>> The reason is that once we got a non EAGAIN error in io_wq_submit_work(),
>>>> we'll complete req by calling io_req_complete(), which will hold completion_lock
>>>> to call io_commit_cqring(), but for polled io, io_iopoll_complete() won't
>>>> hold completion_lock to call io_commit_cqring(), then there maybe concurrent
>>>> access to ctx->defer_list, double free may happen.
>>>>
>>>> To fix this bug, we always let io_iopoll_complete() complete polled io.
>>>
>>> This patch is causing hangs with iopoll testing, if you end up getting
>>> -EAGAIN on request submission. I've dropped it.
>>
>> I fail to understand without debugging how does it happen, especially since
>> it shouldn't even get out of the while in io_wq_submit_work(). Is that
>> something obvious I've missed?
> 
> I didn't have time to look into it, and haven't yet, just reporting that
> it very reliably fails (and under what conditions).

Yeah, I get it, asked just in case.
I'll see what's going on if Xiaoguang wouldn't handle it before.

-- 
Pavel Begunkov
