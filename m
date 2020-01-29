Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6CD514D432
	for <lists+io-uring@lfdr.de>; Thu, 30 Jan 2020 00:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgA2X6x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jan 2020 18:58:53 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39315 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbgA2X6x (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jan 2020 18:58:53 -0500
Received: by mail-pg1-f193.google.com with SMTP id 4so645302pgd.6
        for <io-uring@vger.kernel.org>; Wed, 29 Jan 2020 15:58:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=3hekRPcNusc1crrUWu1Wqig5+A5eyz6DuHgl0prb32Y=;
        b=iNJi4KomhffJpNuyKgwaZSgAhXJgHlsJDcHIlFvMUuGA6+pT+7f98SssXfe22LDhXP
         BUMkmBDfqI4KvSOh8usEHNnFN0uP/pxvrPJKBYVp+irA9iOGGngTwy1k139eMrXAzthJ
         QstE+wZ2rzB7z5XtX6SyYzPTILEs23x0Oj+hD+O1MpIUtnLbon8AujNckNRMulaRa88K
         YbloP4bW5PEXsoIPODj7y8jvkL+GD4G0KjdAr+W+pq6rqt3cdPOFqMQ7YIeIfrsBS6Ul
         JJtl9YAGPRJMa6Z3mNuvNvIRgaFtYR949qMkS58OEH6Rwng69PgPt6iWuuD/bmrPRYn5
         VELg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3hekRPcNusc1crrUWu1Wqig5+A5eyz6DuHgl0prb32Y=;
        b=gI/XCcF9RKst9AzCgF9nihvtfxa5Q01V3WW6PqDWozh64Ui9TfUXDttPGDE2NLvs/V
         gyZQu/qDORwuPJ3SAk17KrqGuXtkY6LFXvwwzjFkopjc0hjRGYDadoRIjg5d2eIUlWzT
         AdnrZB/Yn8qBi8HDQrs15P6EU3Nk7/pMxrcJZzbhmITJ0ZQMxlmOPggzlRoL74EtwOqV
         gQfxZ5n2v0KR4aQooKbjRN0sTKKJkXORpq8wljYGmOrY9zi5F46lfr58yoSW9DRD6LZm
         5Ss5QLpwxUVZvijeSUQn11yWQF1C7vnugssXz0Fv3feeVVGwRiyHTSY7U9wL5QnHXiLm
         12rw==
X-Gm-Message-State: APjAAAUHwVpUQK0Hg4LDM0NOIVok07QeIufPuAcpGVd0wV00mGbESSmy
        NpvPud8KsuG1QjC0CLIhgIDc5YhCHyc=
X-Google-Smtp-Source: APXvYqzIYJckblBN3Kx3SdutIGoVbkBjwee2O0p9tgtpKsYc2+7iiyEQc/H2aGOyp8BupbVa/TtrPw==
X-Received: by 2002:aa7:96c7:: with SMTP id h7mr2008115pfq.211.1580342332044;
        Wed, 29 Jan 2020 15:58:52 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id q25sm3941731pfg.41.2020.01.29.15.58.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2020 15:58:51 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix linked command file table usage
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <c2d0d637-85db-3500-f1ae-335bc1fec6c8@kernel.dk>
 <4a826524-4f77-2126-03e9-802c3567f73f@gmail.com>
 <828c41db-163e-c6db-5fdb-3f87246ac0ed@kernel.dk>
 <60df3f6c-7174-a306-47bd-92ca82e2c432@gmail.com>
 <eeae146a-1268-bab3-043b-dffe6dfb21d0@kernel.dk>
 <41b233d5-f8d7-5656-7bd4-72e3658a0653@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <171412c4-fc5b-04ca-44ac-de66e2795ff7@kernel.dk>
Date:   Wed, 29 Jan 2020 16:58:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <41b233d5-f8d7-5656-7bd4-72e3658a0653@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/29/20 4:38 PM, Pavel Begunkov wrote:
> On 30/01/2020 02:31, Jens Axboe wrote:
>> On 1/29/20 4:19 PM, Pavel Begunkov wrote:
>>> On 30/01/2020 01:44, Jens Axboe wrote:
>>>> On 1/29/20 3:37 PM, Pavel Begunkov wrote:
>>>>> FYI, for-next
>>>>>
>>>>> fs/io_uring.c: In function ‘io_epoll_ctl’:
>>>>> fs/io_uring.c:2661:22: error: ‘IO_WQ_WORK_NEEDS_FILES’ undeclared (first use in
>>>>> this function)
>>>>>  2661 |   req->work.flags |= IO_WQ_WORK_NEEDS_FILES;
>>>>>       |                      ^~~~~~~~~~~~~~~~~~~~~~
>>>>> fs/io_uring.c:2661:22: note: each undeclared identifier is reported only once
>>>>> for each function it appears in
>>>>> make[1]: *** [scripts/Makefile.build:266: fs/io_uring.o] Error 1
>>>>> make: *** [Makefile:1693: fs] Error 2
>>>>
>>>> Oops thanks, forgot that the epoll bits aren't in the 5.6 main branch
>>>> yet, but they are in for-next. I'll fix it up there, thanks.
>>>>
>>>
>>> Great. Also, it seems revert of ("io_uring: only allow submit from owning task
>>> ") didn't get into for-next nor for-5.6/io_uring-vfs.
>>
>> That's on purpose, didn't want to fold that in since it's already in
>> master. Once this goes out to Linus (tomorrow/Friday), then it'll
>> be resolved there.
> 
> I see, thanks

I know it's a little annoying for testing, but it keeps the mainline
history a bit cleaner. Hopefully it'll all be moot in a few days.

-- 
Jens Axboe

