Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C0C2FBA8B
	for <lists+io-uring@lfdr.de>; Tue, 19 Jan 2021 15:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389336AbhASOyn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jan 2021 09:54:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391922AbhASLtc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jan 2021 06:49:32 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334E3C061573
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 03:48:52 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id m4so19412305wrx.9
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 03:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KeW9VeCv9dIB5z2kRa8WnPPaCUYPz9tCJsIVEMMeVwM=;
        b=u09gQE3LiWV+rFjvBOt5ExQcTYPqCtsIzeIWOgpy2mG6gtbMDmPdqSoDL9k7rfp+T8
         VdnQ0GJrRA6YCGq0fKcDvOUsxJ+dKq7LE+RCnC5XAIjtwBniVRJV9QEtGhvdQmlU+tIr
         p6yYxCe+Nm9IYPpi59rqWEHw9l/K/4CM08rMb36Nn8P7k+ANUexL0vPPfPXG+HkIiEK3
         Kw4qK3Gu5TgNoy/y0CEzjOHLfC30Bp/weQPVuXwzDC3Cs98i+dJ2Zxo822OVNDGbq7Qm
         UxMtdG8jqsbkaAgeoMlJnqu2M6sxkyVZy+39T8RwifZmeYNHAl1PChnAVp7XFOz/lJ8S
         38Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=KeW9VeCv9dIB5z2kRa8WnPPaCUYPz9tCJsIVEMMeVwM=;
        b=HbORzlLXLCJ/7p5ie8aIFKR2A/DUv+1NQdwXXvp0rUFkIdgCLZgZkEwqVDoedQyruv
         IuJ7AtrUjn5K3cV1qVWO3KDUbWgyUFdbACAyhsKC7mqR8A2kozyQzArzjW/lmHWWA2m/
         yzj3lCnW0oj3M35oL76Na4PlqcgulBhlz/QqVktn7hWK/WUbRjy2e3PRKOZQktn/kaD0
         B76ns4cSu23DMrNXT6NOLuErXCLaSd2QQsC6jvBMP/+pTbsSj49HD46OQwy7XIB1XCW0
         Z4WMtcVBd1D+ImrjVzC36EvzLedSSdqZ3KIrYHy7i9MNLUr5dNiQoo7GiZS32uPy6IcC
         wxBQ==
X-Gm-Message-State: AOAM531ta4SOiR7/Qy91r7cbAKFO1FYctEX+NpY3tWIU56kFYfe1fBXU
        tKsOyd0GQoy6sBO3QltSqoY=
X-Google-Smtp-Source: ABdhPJx1yiH9Mnkgi0naumFKFbiyA46pzi95uuCMeU8jYA91SJ+6intvdvmtkG1DfeL9Oky6bzoYMw==
X-Received: by 2002:a5d:5049:: with SMTP id h9mr4133039wrt.404.1611056930967;
        Tue, 19 Jan 2021 03:48:50 -0800 (PST)
Received: from [192.168.8.133] ([85.255.234.152])
        by smtp.gmail.com with ESMTPSA id d13sm35584192wrx.93.2021.01.19.03.48.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jan 2021 03:48:50 -0800 (PST)
To:     Joseph Qi <jiangqi903@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
References: <1610963424-27129-1-git-send-email-joseph.qi@linux.alibaba.com>
 <4f1a8b42-8440-0e9a-ca01-497ccd438b56@gmail.com>
 <ae6fa12a-155b-cf43-7702-b8bb5849a858@gmail.com>
 <58b25063-7047-e656-18df-c1240fab3f8d@linux.alibaba.com>
 <164dff2a-7f23-4baf-bcb5-975b1f5edf9b@gmail.com>
 <17125fd3-1d0e-1c71-374a-9a7a7382c8fc@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] io_uring: fix NULL pointer dereference for async cancel
 close
Message-ID: <3572b340-ce74-765f-c6bd-0179b3756a1b@gmail.com>
Date:   Tue, 19 Jan 2021 11:45:13 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <17125fd3-1d0e-1c71-374a-9a7a7382c8fc@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 19/01/2021 08:00, Joseph Qi wrote:
> 
> 
> On 1/19/21 10:38 AM, Pavel Begunkov wrote:
>> On 19/01/2021 01:58, Joseph Qi wrote:
>>>> Hmm, I hastened, for files we need IO_WQ_WORK_FILES,
>>>> +IO_WQ_WORK_BLKCG for same reasons. needs_file would make 
>>>> it to grab a struct file, that is wrong.
>>>> Probably worked out because it just grabbed fd=0/stdin.
>>>>
>>>
>>> I think IO_WQ_WORK_FILES can work since it will acquire
>>> files when initialize async cancel request.
>>
>> That the one controlling files in the first place, need_file
>> just happened to grab them submission.
>>
>>> Don't quite understand why we should have IO_WQ_WORK_BLKCG.
>>
>> Because it's set for IORING_OP_CLOSE, and similar situation
>> may happen but with async_cancel from io-wq.
>>
> So how about do switch and restore in io_run_cancel(), seems it can
> take care of direct request, sqthread and io-wq cases.

It will get ugly pretty quickly, + this nesting of io-wq handlers
async_handler() -> io_close() is not great...

I'm more inclined to skip them in io_wqe_cancel_pending_work()
to not execute inline. That may need to do some waiting on the
async_cancel side though to not change the semantics. Can you
try out this direction?


> 
>> Actually, it's even nastier than that, and neither of io_op_def
>> flags would work because for io-wq case you can end up doing
>> close() with different from original files. I'll think how it
>> can be done tomorrow.
>>

-- 
Pavel Begunkov
