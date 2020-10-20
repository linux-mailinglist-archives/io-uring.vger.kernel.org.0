Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11C7D293E40
	for <lists+io-uring@lfdr.de>; Tue, 20 Oct 2020 16:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407899AbgJTOJl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Oct 2020 10:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407885AbgJTOJk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Oct 2020 10:09:40 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F8B4C061755
        for <io-uring@vger.kernel.org>; Tue, 20 Oct 2020 07:09:39 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id z2so2357588ilh.11
        for <io-uring@vger.kernel.org>; Tue, 20 Oct 2020 07:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=z6apaLgAfPn/20poXQOiWzOmdmD69x82XLAEsoo27GU=;
        b=y/Y8NEKeXkBKQOiP+Pid1SAj0ASVjHg4PRF7qhn8HstegcvYOu2oJmSLVNOV9Gc/E4
         7V26N/yiwSRCkwKq51e4vbboVLF5aHxSNtq9k3FODrph7OELvXCwvi4TLVlAFPkN9x2P
         P0bvDjbZGq3zpql+zV5IzGfea5bO88vyf/K3wvwngDJUrHBZtg6wx5UY7ppqaorVp1BH
         0rFC5vs697ftt5ZdaKeWpISCMxAuX/PfDX4RfYIi92a5sLD6QYVO5kbpsPLVpDzW9Nol
         q5JbGaKNTN0QsogO/o+fIWYPCfJSUm0/2eYFLqiYWolLe9xAhrWlHdbQ1XXfD1w9XH9p
         h06A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z6apaLgAfPn/20poXQOiWzOmdmD69x82XLAEsoo27GU=;
        b=WOVYBGS94LZlsTjA0YZHBOt/7k//KN1+OMHseh3GpdsZSBaxVTFskCtf4RnwgDMvql
         ecpw2W5puyThJybjDqlRUI1T9FJgUvKuSjVYndKcClhrEem1KZ03o6cfRIdy0U8/A8hL
         Ilb1x7yjyRrD0NIEVGCogojKJbrW2qCfZhKCJteQP5moIVZmBj6mK3Z/6DSb2EXToMVu
         WLLjeCiJomJMagawVOCLXsidq1Hrpws12D0zBVMMHdUiDUFf7lkr7ZHBYk0NHXgLNuOb
         W07uW2FMXHj3Kwxy1yMTBBxWdlpWAjjMkvFrHHgFakG+Jl3nWN57ThEo7c01hNkoNTNC
         WMTA==
X-Gm-Message-State: AOAM533k5Cld5LZjks3kF+Q1KNzn97Ia6t5l7JyqOCJmJIZDfUFN8OCn
        oNBwCirD1VSDcA2cjqFYwO+qGS1HXS6r5A==
X-Google-Smtp-Source: ABdhPJwxCk8ztbnjNY9+OgSNDOlodv11iXzH/2zCeI3XDvHjrIJaGN4/ddvKjb8P9u/Djx2kQ+Sf8A==
X-Received: by 2002:a05:6e02:c85:: with SMTP id b5mr2173143ile.187.1603202978623;
        Tue, 20 Oct 2020 07:09:38 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r12sm1999306ilm.28.2020.10.20.07.09.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2020 07:09:38 -0700 (PDT)
Subject: Re: [PATCH for-5.10] io_uring: remove req cancel in ->flush()
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <21aca47e03c82a06e4ea1140b328a86d04d1f422.1603122023.git.asml.silence@gmail.com>
 <ca4c9b80-78de-eae2-55cf-8d7c3f09ca80@kernel.dk>
 <1799a7cf-7443-7eff-37b1-b3bf3f352968@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d55aa3c1-7eb4-b3a4-4a34-41d566d5c559@kernel.dk>
Date:   Tue, 20 Oct 2020 08:09:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1799a7cf-7443-7eff-37b1-b3bf3f352968@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/19/20 5:40 PM, Pavel Begunkov wrote:
> On 19/10/2020 21:08, Jens Axboe wrote:
>> On 10/19/20 9:45 AM, Pavel Begunkov wrote:
>>> Every close(io_uring) causes cancellation of all inflight requests
>>> carrying ->files. That's not nice but was neccessary up until recently.
>>> Now task->files removal is handled in the core code, so that part of
>>> flush can be removed.
>>
>> It does change the behavior, but I'd wager that's safe. One minor
>> comment:
> 
> Right, but I would think that users are not happy that every close
> kills requests without apparent reasons.

To be fair, closing the ring fd is kind of unexpected and I would not
expect any real applications to do that. If they did, I would have
expected queries on why file table requests get canceled on close. Hence
I'm not too worried about anyone hitting any issues related to this
change, as the change is certainly one for the better.

>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 95d2bb7069c6..6536e24eb44e 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -8748,16 +8748,12 @@ void __io_uring_task_cancel(void)
>>>  
>>>  static int io_uring_flush(struct file *file, void *data)
>>>  {
>>> -	struct io_ring_ctx *ctx = file->private_data;
>>> +	bool exiting = !data;
>>>  
>>> -	/*
>>> -	 * If the task is going away, cancel work it may have pending
>>> -	 */
>>>  	if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
>>> -		data = NULL;
>>> +		exiting = true;
>>>  
>>> -	io_uring_cancel_task_requests(ctx, data);
>>> -	io_uring_attempt_task_drop(file, !data);
>>> +	io_uring_attempt_task_drop(file, exiting);
>>>  	return 0;
>>>  }
>>
>> Why not just keep the !data for task_drop? Would make the diff take
>> away just the hunk we're interested in. Even adding a comment would be
>> better, imho.
> 
> That would look cleaner, but I just left what already was there. TBH,
> I don't even entirely understand why exiting=!data. Looking up how
> exit_files() works, it passes down non-NULL files to
> put_files_struct() -> ... filp_close() -> f_op->flush().
> 
> I'm curious how does this filp_close(file, files=NULL) happens?

It doesn't, we just clear it internall to match all requests, not just
files backed ones.

> Moreover, if that's exit_files() which is interesting, then first
> it calls io_uring_cancel_task_requests(), which should remove all
> struct file from tctx->xa. I haven't tested it though.

Yep, further cleanups are certainly possible there.

I've queued this up, thanks.

-- 
Jens Axboe

