Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA9B3E8558
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 23:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233968AbhHJVdy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 17:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233792AbhHJVdx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 17:33:53 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01E0C061765;
        Tue, 10 Aug 2021 14:33:30 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id h24-20020a1ccc180000b029022e0571d1a0so471242wmb.5;
        Tue, 10 Aug 2021 14:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DzwMjTW+ta0tsVW5xQVnGvx2kSdGFVU4IVXb6iVUJt8=;
        b=G0Bkx9v7i/C3jmLEn7HQHUa4GmDZLSRJH05ysgnyhMVwczV8vEzvrfQlrLV9ffx2zE
         JBX47i+3gOn1/9mUSqumvZfffFWgrsXfHNlYQ2lUyfAsp8xJnzB7i4yfP8V2e4TKFb+W
         9xaFg/6dkFbzuv1Ekca2JVGWfl53LekZ3x1Tg5V6zeGo7s1wq8tVhhrdwyLFUyy/dseH
         gLlvWrX36sN+LMA786JXFdWx08ABJ0elMSjQAiz8ePL1oaxYyh0JZuBDxAw+tgFGdV+g
         ScNPDYlhlEfyQFRWbw8HoqPXltBv0hkurHr0DvaSiSA35NEEjJSsDEcaNJcgb+isO9Aa
         x7DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DzwMjTW+ta0tsVW5xQVnGvx2kSdGFVU4IVXb6iVUJt8=;
        b=fYxv0b3u0Jfszidu845+5S5uoNvybSrf917z8iBjacq1HCsEp069Vy7sgeJak+xiyR
         g1zLKkD8T4FWn6lb1G2ps9dFlcWYjIP45+s7sBZo7ewtAu0Kn4GH+WIeMxsCNtWlku3U
         OWFAQS94TVhLkYZl+UbTFRktgyLe5nvMGJKDWWmdNpoIS33JLsV0r82NTCi2wgbbcfqO
         lnJj24EL91b2ydO1UuFs1BTwnOO/rNTXdTcfa2bOklc42LP8otKJ/bh5FaWekCQMNCHN
         hj7oSwhNpFOHgC5xB9nbWk+aqWKep+jOthqjGM5ye//OOMLM/a2N6WvkPZo7SSf84C2l
         0x/g==
X-Gm-Message-State: AOAM530Wo16khtl5skHH9G+dgVa1UobP1d9B4f72wO0qMAk7e53wK6Av
        9tnxBRR1u7MhHWVMAWXM1flIkmsdxJ4=
X-Google-Smtp-Source: ABdhPJwwa20bO+CvlEiRMOaD8Y5J68iBoMAuQlc3lluouzaZUYyrqQLS4EDluQsEMIp/+/UBnxyu5g==
X-Received: by 2002:a7b:c8c6:: with SMTP id f6mr6568522wml.44.1628631209374;
        Tue, 10 Aug 2021 14:33:29 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id b20sm4241397wmj.20.2021.08.10.14.33.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 14:33:29 -0700 (PDT)
To:     Nadav Amit <nadav.amit@gmail.com>,
        Olivier Langlois <olivier@trillion01.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20210808001342.964634-1-namit@vmware.com>
 <20210808001342.964634-2-namit@vmware.com>
 <fdd54421f4d4e825152192e327c838d035352945.camel@trillion01.com>
 <A4DC14BA-74CA-41DB-BE08-D7B693C11AE0@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 1/2] io_uring: clear TIF_NOTIFY_SIGNAL when running task
 work
Message-ID: <bbd25a42-eac0-a8f9-0e54-3c8c8e9894fd@gmail.com>
Date:   Tue, 10 Aug 2021 22:32:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <A4DC14BA-74CA-41DB-BE08-D7B693C11AE0@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/10/21 9:28 AM, Nadav Amit wrote:
>> On Aug 9, 2021, at 2:48 PM, Olivier Langlois <olivier@trillion01.com> wrote:
>> On Sat, 2021-08-07 at 17:13 -0700, Nadav Amit wrote:
>>> From: Nadav Amit <namit@vmware.com>
>>>
>>> When using SQPOLL, the submission queue polling thread calls
>>> task_work_run() to run queued work. However, when work is added with
>>> TWA_SIGNAL - as done by io_uring itself - the TIF_NOTIFY_SIGNAL remains
>>> set afterwards and is never cleared.
>>>
>>> Consequently, when the submission queue polling thread checks whether
>>> signal_pending(), it may always find a pending signal, if
>>> task_work_add() was ever called before.
>>>
>>> The impact of this bug might be different on different kernel versions.
>>> It appears that on 5.14 it would only cause unnecessary calculation and
>>> prevent the polling thread from sleeping. On 5.13, where the bug was
>>> found, it stops the polling thread from finding newly submitted work.
>>>
>>> Instead of task_work_run(), use tracehook_notify_signal() that clears
>>> TIF_NOTIFY_SIGNAL. Test for TIF_NOTIFY_SIGNAL in addition to
>>> current->task_works to avoid a race in which task_works is cleared but
>>> the TIF_NOTIFY_SIGNAL is set.
>>
>> thx a lot for this patch!
>>
>> This explains what I am seeing here:
>> https://lore.kernel.org/io-uring/4d93d0600e4a9590a48d320c5a7dd4c54d66f095.camel@trillion01.com/
>>
>> I was under the impression that task_work_run() was clearing
>> TIF_NOTIFY_SIGNAL.
>>
>> your patch made me realize that it does not…
> 
> Happy it could help.
> 
> Unfortunately, there seems to be yet another issue (unless my code
> somehow caused it). It seems that when SQPOLL is used, there are cases
> in which we get stuck in io_uring_cancel_sqpoll() when tctx_inflight()
> never goes down to zero.
> 
> Debugging... (while also trying to make some progress with my code)

It's most likely because a request has been lost (mis-refcounted).
Let us know if you need any help. Would be great to solve it for 5.14.
quick tips: 

1) if not already, try out Jens' 5.14 branch
git://git.kernel.dk/linux-block io_uring-5.14

2) try to characterise the io_uring use pattern. Poll requests?
Read/write requests? Send/recv? Filesystem vs bdev vs sockets?

If easily reproducible, you can match io_alloc_req() with it
getting into io_dismantle_req();

-- 
Pavel Begunkov
