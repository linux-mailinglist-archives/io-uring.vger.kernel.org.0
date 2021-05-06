Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 800B23758D5
	for <lists+io-uring@lfdr.de>; Thu,  6 May 2021 18:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236083AbhEFRAw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 May 2021 13:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235881AbhEFRAw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 May 2021 13:00:52 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A02C061574
        for <io-uring@vger.kernel.org>; Thu,  6 May 2021 09:59:53 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id l13so6359014wru.11
        for <io-uring@vger.kernel.org>; Thu, 06 May 2021 09:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=1DqeisAlwqf9HpPlgZy+6QaZnu5jrZkqLhdvm9xBFnA=;
        b=FdbxLuyOWLj6TtW6DABWKqdDcx9dyKNhAYIyhCDoqYuOKxJ3RpiF/qYDSo1pS9S9V1
         uROflavbdynb0Egbwjxbg7wfY8i4qcZZDjQO1lErLlNKdyKS7YvfaVHulRKg79i8919s
         4MPwnDjs8yFtuyGaTNRrjhnpSECh1nRipyWhIDA+6OXWHfxAwMKFI/IXOUFsX1adIa9s
         udPsQztK8sSVdj//NEVYCDD+upmVrkfEOf9v4OaKw8Wgxpf4EaXnRdlQATzrXuvodgRg
         6oC5o6ICemNVNVrJXFAfZ13wjT2hvXbk1ZySwGAMOTeL1E6uZiX9SpaB2G6+OwxXRX7v
         130w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1DqeisAlwqf9HpPlgZy+6QaZnu5jrZkqLhdvm9xBFnA=;
        b=Wiv3n+IjgSOuxKkIsTokj5O9JMptP6OeOCNGBg0SqPI2kFmHT4f48ndgkMuYkh/zeK
         i3Ymk2SNYwBPSZPMymwxbdstGB87Vmzid8tAc+5AtZ8Xk0LU4Re65UK9DezBcFaf9+wa
         MZI/E4IaifnXj+Sp7FpZ8O1LO8/Fjc7GWIDQCJjtB5u+mSTxjQ1zn9KNL8yWaJVLWfWk
         Mhhcp47aySOPAkow4w0JZRqXGKPVD5LkwIhLuAkvbfRHZvklPtxQyRIuOwUo3uPGurfp
         uwSjwoswxGzKcMgX4E/BsK8R8D/9CPU9q4+xbdimsmxEkvE8Vo2241edfmpi8zhor88E
         vHow==
X-Gm-Message-State: AOAM5339j8IFFK6PaxdJOvFDFV1q8Ypo6oIWuCQkHrJaqTWD6LZbh844
        J00PBNV/u4HDYLWtOpuhXm/4Yu07L00=
X-Google-Smtp-Source: ABdhPJx3+muqlMbeTS0RAEPt10onNLE2tmO0o3AyA7cLHiXiz+xUgPwLbi7S95BWNsZ+onpzFj5giw==
X-Received: by 2002:a5d:4d52:: with SMTP id a18mr6576019wru.45.1620320391399;
        Thu, 06 May 2021 09:59:51 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.215])
        by smtp.gmail.com with ESMTPSA id k10sm18786539wmf.0.2021.05.06.09.59.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 May 2021 09:59:51 -0700 (PDT)
Subject: Re: IORING_OP_POLL_ADD/IORING_OP_POLL_REMOVE questions
To:     Olivier Langlois <olivier@trillion01.com>,
        io-uring <io-uring@vger.kernel.org>
References: <8992f5f989808798ad2666b0a3ef8ae8d777b7de.camel@trillion01.com>
 <db4d01cc-9f58-c04d-d1b6-1208f8fb7220@gmail.com>
 <0a12170604cfcbce61259661f579fe5640cc7ffb.camel@trillion01.com>
 <7fa90154d1fbe1969383261539b7fbee20caad43.camel@trillion01.com>
 <2a4437a06ad910142d27d22d9e17a843dbd6d6fc.camel@trillion01.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <ff1f9ac3-51e6-2f1e-3f23-b0901d8d43fa@gmail.com>
Date:   Thu, 6 May 2021 17:59:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <2a4437a06ad910142d27d22d9e17a843dbd6d6fc.camel@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/6/21 4:46 PM, Olivier Langlois wrote:
> On Thu, 2021-05-06 at 04:42 -0400, Olivier Langlois wrote:
>> On Wed, 2021-05-05 at 23:17 -0400, Olivier Langlois wrote:
>>> Note that the poll remove sqe and the following poll add sqe don't
>>> have
>>> exactly the same user_data.
>>>
>>> I have this statement in between:
>>> /* increment generation counter to avoid handling old events */
>>>           ++anfds [fd].egen;
>>>
>>> poll remove cancel the previous poll add having gen 1 in its user
>>> data.
>>> the next poll add has it user_data storing gen var set to 2:
>>>
>>> 1 3 remove 85 1
>>> 1 3 add 85 2
>>>
>>> 85 gen 1 res -125
>>> 85 gen 1 res 4
>>>
>> Good news!
>>
>> I have used the io_uring tracepoints and they confirm that io_uring
>> works as expected:
>>
>> For the above printfs, I get the following perf traces:
>>
>>  11940.259 Execution SVC/134675 io_uring:io_uring_submit_sqe(ctx:
>> 0xffff9d3c4368c000, opcode: 7, force_nonblock: 1)
>>  11940.270 Execution SVC/134675 io_uring:io_uring_complete(ctx:
>> 0xffff9d3c4368c000, user_data: 4294967382, res: -125)
>>  11940.272 Execution SVC/134675 io_uring:io_uring_complete(ctx:
>> 0xffff9d3c4368c000)
>>  11940.275 Execution SVC/134675 io_uring:io_uring_file_get(ctx:
>> 0xffff9d3c4368c000, fd: 86)
>>  11940.277 Execution SVC/134675 io_uring:io_uring_submit_sqe(ctx:
>> 0xffff9d3c4368c000, opcode: 6, user_data: 4294967382, force_nonblock:
>> 1)
>>  11940.279 Execution SVC/134675 io_uring:io_uring_complete(ctx:
>> 0xffff9d3c4368c000, user_data: 4294967382, res: 4)
>>
>> So, it seems the compiler is playing games on me. It prints the correct
>> gen 2 value but is passing 1 to io_uring_sqe_set_data()...
>>
>> I'll try to turn optimization off to see if it helps.
>>
>> thx a lot again for your exceptional work!
>>
>>
> The more I fool around trying to find the problem, the more I think
> that my problem is somewhere in the liburing (v2.0) code because of a
> possibly missing memory barrier.
> 
> The function that I do use to submit the sqes is
> io_uring_wait_cqe_timeout().
> 
> My problem did appear when I did replace libev original boilerplate
> code for liburing (v2.0) used for filling and submitting the sqes.
> 
> Do you remember when you pointed out that I wasn't setting the
> user_data field for my poll remove request in:
> 
> io_uring_prep_poll_remove(sqe,
> iouring_build_user_data(IOURING_POLL, fd, anfds [fd].egen));
> //          io_uring_sqe_set_data(sqe,
> iouring_build_user_data(IOURING_POLL, fd, anfds [fd].egen));
> 
> ?
> 
> The last call to remove the non-existant 'add 85 2' is replied by
> ENOENT by io_uring and this was caught by an assert in my case
> IOURING_POLL cqe handler.
> 
>   iouring_decode_user_data(cqe->user_data, &type, &fd, &gen);
> 
>   switch (type) {
> 
> This is impossible to end up there because if you do not explicitly set
> user_data, io_uring_prep_rw() is setting it to 0.
> 
> In order for my assert to be hit, user_data would have to be set with
> the commented out io_uring_sqe_set_data(), and it happens to also be
> the value of the previously sent sqe user_data...
> 
> I did replace the code above with:
> 
> io_uring_prep_poll_remove(sqe,
> iouring_build_user_data(IOURING_POLL_ADD, fd, anfds [fd].egen));
> io_uring_sqe_set_data(sqe, iouring_build_user_data(IOURING_POLL_REMOVE,
> fd, anfds [fd].egen));
> 
> and my assert for cqe->res != -ENOENT has stopped being hit.
> 
> There is clearly something messing with the sqe user_data communication
> between user and kernel and I start to suspect that this might be
> somewhere inside io_uring_wait_cqe_timeout()...

What's your kernel? IORING_FEAT_EXT_ARG?

e.g. ring->features & IORING_FEAT_EXT_ARG

Because:

/*
 * Like io_uring_wait_cqe(), except it accepts a timeout value as well. Note
 * that an sqe is used internally to handle the timeout. For kernel doesn't
 * support IORING_FEAT_EXT_ARG, applications using this function must never
 * set sqe->user_data to LIBURING_UDATA_TIMEOUT!
 *
 * For kernels without IORING_FEAT_EXT_ARG (5.10 and older), if 'ts' is
 * specified, the application need not call io_uring_submit() before
 * calling this function, as we will do that on its behalf. From this it also
 * follows that this function isn't safe to use for applications that split SQ
 * and CQ handling between two threads and expect that to work without
 * synchronization, as this function manipulates both the SQ and CQ side.
 *
 * For kernels with IORING_FEAT_EXT_ARG, no implicit submission is done and
 * hence this function is safe to use for applications that split SQ and CQ
 * handling between two threads.
 */


-- 
Pavel Begunkov
