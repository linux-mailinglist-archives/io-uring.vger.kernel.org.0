Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC4E42EE7B5
	for <lists+io-uring@lfdr.de>; Thu,  7 Jan 2021 22:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbhAGVlV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Jan 2021 16:41:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726929AbhAGVlU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Jan 2021 16:41:20 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1185FC0612F4
        for <io-uring@vger.kernel.org>; Thu,  7 Jan 2021 13:40:40 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id 190so6312745wmz.0
        for <io-uring@vger.kernel.org>; Thu, 07 Jan 2021 13:40:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0lk2U4ykJVWPyU1hySjiGmI5GR9PlboimuNul7/n7ww=;
        b=d31J7y/HGIVPTAHe0yJNWxXZcj2KBKHDTDZgiMIM5XwlwlZbCDbK/5YF08rR46jqXP
         Rw3/DRAtB8BFAapPv8yOhns07T3SrdoARJnIOZEmwvLm9+ONfmU0YGQDnfUWp4gCt3TD
         DmosiYLzkMRnZPHD8xkAsZhbKUzfnlXa5FhTEKmXf/nJJbNvxW6PuO+ddhM9nCN6d1ao
         MgaLCn1TVQYVliqkkFAnwJlOVDmaXO+DWmrTBbuGelAvvQ2WjrypABKf3CIvICAjGZjw
         rlOunMSom4VWk+BHV/ovj/1MaPo/4GSGgesd2R4wtLRSd5zwpH9NPAmXxF1T4IgZ3hIZ
         2rYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0lk2U4ykJVWPyU1hySjiGmI5GR9PlboimuNul7/n7ww=;
        b=DcwaRXqIs+Iu5Z2uRaMVmgZPg8VRM5iDTO3Le4mEu3UHwFr2mouaHZAhHrna/yk+F6
         ySNokux99flHCnKlzM+bCamUmT+cbTDnuafB6wcBMk0ezCXxNTcWCdgITfqi9x2jBsIl
         mWwB1X2I0VhdK94CHB+MBXP3i6+d7T+eR+zKgBaIMNpCDTamGeXIQ6aEC0n+3rbfmlhu
         a4vAQBX7/ja+l2kUvbefyDKdBOhj++WvPiqYTT2IlauTV7qb3XkWFFKyhNMpggoCRtZw
         5TUhY2bOqxWHLGLKQxinWwx5McjfMolUZ2EjrmibB5iXxu73stjWrq4hb3KmSCmO4OK8
         4v2g==
X-Gm-Message-State: AOAM531Xh4aRkji3Z3wrK2xehavIDhui5ZNc8g4zDn0BrZKxNcBqWWJL
        IA80A6uKPxT2Sp4ECwx6SCPtsZi7RQrlUw==
X-Google-Smtp-Source: ABdhPJxbinGKYOqvzOyq9lByLiry/x57zJgkqhwuDSlh8sCWMnrQarua+pXfihgXCIIvR/shjKsd2Q==
X-Received: by 2002:a7b:c8da:: with SMTP id f26mr399203wml.155.1610055638470;
        Thu, 07 Jan 2021 13:40:38 -0800 (PST)
Received: from [192.168.8.105] ([185.69.144.125])
        by smtp.gmail.com with ESMTPSA id f7sm15405470wmc.1.2021.01.07.13.40.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jan 2021 13:40:37 -0800 (PST)
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org
References: <1608314848-67329-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1608314848-67329-9-git-send-email-bijan.mottahedeh@oracle.com>
 <f0bff3b0-f27e-80fe-9a58-dfeb347a7e61@gmail.com>
 <c982a4ea-e39f-d8e0-1fc7-27086395ea9a@oracle.com>
 <66fd0092-2d03-02c0-fe1c-941c761a24f8@gmail.com>
 <20b6a902-4193-22fe-2cd7-569024648a26@oracle.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v3 08/13] io_uring: implement fixed buffers registration
 similar to fixed files
Message-ID: <5d14a511-34d2-1aa7-e902-ed4f0e6ded82@gmail.com>
Date:   Thu, 7 Jan 2021 21:37:06 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20b6a902-4193-22fe-2cd7-569024648a26@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 07/01/2021 21:21, Bijan Mottahedeh wrote:
> 
>>>> Because it's do quiesce, fixed read/write access buffers from asynchronous
>>>> contexts without synchronisation. That won't work anymore, so
>>>>
>>>> 1. either we save it in advance, that would require extra req_async
>>>> allocation for linked fixed rw
>>>>
>>>> 2. or synchronise whenever async. But that would mean that a request
>>>> may get and do IO on two different buffers, that's rotten.
>>>>
>>>> 3. do mixed -- lazy, but if do IO then alloc.
>>>>
>>>> 3.5 also "synchronise" there would mean uring_lock, that's not welcome,
>>>> but we can probably do rcu.
>>>
>>> Are you referring to a case where a fixed buffer request can be submitted from async context while those buffers are being unregistered, or something like that?
>>>
>>>> Let me think of a patch...
>>
>> The most convenient API would be [1], it selects a buffer during
>> submission, but allocates if needs to go async or for all linked
>> requests.
>>
>> [2] should be correct from the kernel perspective (no races), it
>> also solves doing IO on 2 different buffers, that's nasty (BTW,
>> [1] solves this problem naturally). However, a buffer might be
>> selected async, but the following can happen, and user should
>> wait for request completion before removing a buffer.
>>
>> 1. register buf id=0
>> 2. syscall io_uring_enter(submit=RW_FIXED,buf_id=0,IOSQE_ASYNC)
>> 3. unregister buffers
>> 4. the request may not find the buffer and fail.
>>
>> Not very convenient + can actually add overhead on the userspace
>> side, can be even some heavy synchronisation.
>>
>> uring_lock in [2] is not nice, but I think I can replace it
>> with rcu, probably can even help with sharing, but I need to
>> try to implement to be sure.
>>
>> So that's an open question what API to have.
>> Neither of diffs is tested.
>>
>> [1]
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 7e35283fc0b1..2171836a9ce3 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -826,6 +826,7 @@ static const struct io_op_def io_op_defs[] = {
>>           .needs_file        = 1,
>>           .unbound_nonreg_file    = 1,
>>           .pollin            = 1,
>> +        .needs_async_data    = 1,
>>           .plug            = 1,
>>           .async_size        = sizeof(struct io_async_rw),
>>           .work_flags        = IO_WQ_WORK_BLKCG | IO_WQ_WORK_MM,
>> @@ -835,6 +836,7 @@ static const struct io_op_def io_op_defs[] = {
>>           .hash_reg_file        = 1,
>>           .unbound_nonreg_file    = 1,
>>           .pollout        = 1,
>> +        .needs_async_data    = 1,
>>           .plug            = 1,
>>           .async_size        = sizeof(struct io_async_rw),
>>           .work_flags        = IO_WQ_WORK_BLKCG | IO_WQ_WORK_FSIZE |
>>
>>
>>
>> [2]
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 7e35283fc0b1..31560b879fb3 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -3148,7 +3148,12 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
>>       opcode = req->opcode;
>>       if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED) {
>>           *iovec = NULL;
>> -        return io_import_fixed(req, rw, iter);
>> +
>> +        io_ring_submit_lock(req->ctx, needs_lock);
>> +        lockdep_assert_held(&req->ctx->uring_lock);
>> +        ret = io_import_fixed(req, rw, iter);
>> +        io_ring_submit_unlock(req->ctx, needs_lock);
>> +        return ret;
>>       }
>>         /* buffer index only valid with fixed read/write, or buffer select  */
>> @@ -3638,7 +3643,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
>>   copy_iov:
>>           /* some cases will consume bytes even on error returns */
>>           iov_iter_revert(iter, io_size - iov_iter_count(iter));
>> -        ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
>> +        ret = io_setup_async_rw(req, iovec, inline_vecs, iter, true);
>>           if (!ret)
>>               return -EAGAIN;
>>       }
>>
>>
> 
> For my understanding, is [1] essentially about stashing the iovec for the fixed IO in an io_async_rw struct and referencing it in async context?

Yes, like that. It actually doesn't use iov but employs bvec, which
it gets from struct io_mapped_ubuf, and stores it inside iter.

> I don't understand how this prevents unregistering the buffer (described by the iovec) while the IO takes place.

The bvec itself is guaranteed to be alive during the whole lifetime
of the request, that's because of all that percpu_ref in nodes.
However, the table storing buffers (i.e. ctx->user_bufs) may be
overwritten.

reg/unreg/update happens with uring_lock held, as well as submission.
Hence if we always grab a buffer during submission it will be fine.

> 
> Taking a step back, what is the cost of keeping the quiesce for buffer registration operations?  It should not be a frequent operation even a heavy handed quiesce should not be a big issue?

It waits for __all__ inflight requests to complete and doesn't allow
submissions in the meantime (basically all io_uring_enter() attempts
will fail). +grace period.

It's pretty heavy, but worse is that it shuts down everything while
waiting. However, if an application is prepared for that and it's
really rare or done once, that should be ok.

-- 
Pavel Begunkov
