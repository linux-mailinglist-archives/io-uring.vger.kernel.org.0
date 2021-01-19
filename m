Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9232FC5BB
	for <lists+io-uring@lfdr.de>; Wed, 20 Jan 2021 01:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbhATAXg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jan 2021 19:23:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405893AbhASNns (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jan 2021 08:43:48 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C150BC061573
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 05:43:05 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id m4so19763835wrx.9
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 05:43:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Uchd353HHZlfs3qUxdFR/+VmIoW3EwZnXdbeEj9Twcg=;
        b=Yzk2I6yU3aL8RKJAdU+tk7t+xQXA6oPqr25U4zEj5XmS4D4aQMKw7qUdof+jJYYgB2
         xSqkf2qo4pKQI/G+WxiXIn2OxOwEcKiWtcJOSy/EkvMszQsKG08x5nLboU+yy2P3xq4T
         wQD5kIoKbecblybkmN5dVi/fxBXSWmB2HnRz8QYJFXqU5fuLQyvlAAl0m8PJiQA77Y1W
         8N9vCLCluAFKH0DTfcQ8titwombuxwsVqqXlZ+SvN/FmanVM2hQuBHDRNhKFarq3Bo1M
         RR0teyekYAJNcNYdqCjYBlQbJFdNK3iiUoRySRHcbnTomlVQe53IUZBm8CB7fb8KOwPB
         4l+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Uchd353HHZlfs3qUxdFR/+VmIoW3EwZnXdbeEj9Twcg=;
        b=VK/eTHvmSmenPLDEptZUVlZb/eZWXKBy52Fn5Gas63qve/IQlL9sXMOeYWHSMCQWm+
         MvWFEPOCI4dj87xZCHiqt37aL+nRNLcs6Dk7RuUFY6xv7uch8gNjRwlSvSFYS55tXkhv
         Wqqd1TqJh93bNhMQbJM8FVPH1x/kogKqs+umawJWHUR64zrv3kfCKXaoiNRnPNlIdJch
         vp8azDuJyOh3taiGLInpEhmxBMNk4iQ4dWDk5fcm+Nx286WNfGXLeKnsqhDeniPE5jx5
         FAK+LKPIJ2mUF8+xiwU/Yhg4IqbmszokoZJPoYLuNjdqJjUDlar/b/DDwmc5QNAW3Frd
         THTA==
X-Gm-Message-State: AOAM532fAjLmUbd07S5oK8DYeCc+0Ts1WFL9uj2buvCmXb+30qQEGVWx
        6WZkjgK0WfZ7ODsCthYEnv/HRVJpLopd7w==
X-Google-Smtp-Source: ABdhPJwJs1V9fq9O5eabfKN5h6vunRnWUjENDqETvkylNIRE+D6E0pGZU+W6RK3hw16tAw6r67N5hA==
X-Received: by 2002:a5d:6204:: with SMTP id y4mr4487222wru.48.1611063784197;
        Tue, 19 Jan 2021 05:43:04 -0800 (PST)
Received: from [192.168.8.134] ([85.255.234.152])
        by smtp.gmail.com with ESMTPSA id x128sm4873625wmb.29.2021.01.19.05.43.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jan 2021 05:43:03 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix NULL pointer dereference for async cancel
 close
To:     Joseph Qi <joseph.qi@linux.alibaba.com>,
        Joseph Qi <jiangqi903@gmail.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
References: <1610963424-27129-1-git-send-email-joseph.qi@linux.alibaba.com>
 <4f1a8b42-8440-0e9a-ca01-497ccd438b56@gmail.com>
 <ae6fa12a-155b-cf43-7702-b8bb5849a858@gmail.com>
 <58b25063-7047-e656-18df-c1240fab3f8d@linux.alibaba.com>
 <164dff2a-7f23-4baf-bcb5-975b1f5edf9b@gmail.com>
 <17125fd3-1d0e-1c71-374a-9a7a7382c8fc@gmail.com>
 <3572b340-ce74-765f-c6bd-0179b3756a1b@gmail.com>
 <f202d3da-0b84-9d35-5da6-d0b7f31d740d@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <e5e7ecd5-102d-dee5-857e-24d77d7075fc@gmail.com>
Date:   Tue, 19 Jan 2021 13:39:26 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <f202d3da-0b84-9d35-5da6-d0b7f31d740d@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 19/01/2021 13:12, Joseph Qi wrote:
> On 1/19/21 7:45 PM, Pavel Begunkov wrote:
>> On 19/01/2021 08:00, Joseph Qi wrote:
>>> On 1/19/21 10:38 AM, Pavel Begunkov wrote:
>>>> On 19/01/2021 01:58, Joseph Qi wrote:
>>>>>> Hmm, I hastened, for files we need IO_WQ_WORK_FILES,
>>>>>> +IO_WQ_WORK_BLKCG for same reasons. needs_file would make 
>>>>>> it to grab a struct file, that is wrong.
>>>>>> Probably worked out because it just grabbed fd=0/stdin.
>>>>>>
>>>>>
>>>>> I think IO_WQ_WORK_FILES can work since it will acquire
>>>>> files when initialize async cancel request.
>>>>
>>>> That the one controlling files in the first place, need_file
>>>> just happened to grab them submission.
>>>>
>>>>> Don't quite understand why we should have IO_WQ_WORK_BLKCG.
>>>>
>>>> Because it's set for IORING_OP_CLOSE, and similar situation
>>>> may happen but with async_cancel from io-wq.
>>>>
>>> So how about do switch and restore in io_run_cancel(), seems it can
>>> take care of direct request, sqthread and io-wq cases.
>>
>> It will get ugly pretty quickly, + this nesting of io-wq handlers
>> async_handler() -> io_close() is not great...
>>
>> I'm more inclined to skip them in io_wqe_cancel_pending_work()
>> to not execute inline. That may need to do some waiting on the
>> async_cancel side though to not change the semantics. Can you
>> try out this direction?
>>
> Sure, I'll try this way and send v2.

There may be a much better way, that's to remove IO_WQ_WORK_NO_CANCEL
and move -EAGAIN section of io_close() before close_fd_get_file(),
so not splitting it in 2 and not keeping it half-done.

IIRC, it was done this way because of historical reasons when we
didn't put more stuff around files, but may be wrong.
Jens, do you remember what it was?

-- 
Pavel Begunkov
