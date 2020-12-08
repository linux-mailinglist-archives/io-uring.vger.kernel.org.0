Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C072D3501
	for <lists+io-uring@lfdr.de>; Tue,  8 Dec 2020 22:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729881AbgLHVLW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Dec 2020 16:11:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgLHVLW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Dec 2020 16:11:22 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41942C061282
        for <io-uring@vger.kernel.org>; Tue,  8 Dec 2020 13:10:08 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id t9so12467160ilf.2
        for <io-uring@vger.kernel.org>; Tue, 08 Dec 2020 13:10:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JXOt82PL9btJEji8+kSD+bo400/x3ZWSIbNQ7m/gSEw=;
        b=LW7M/ZgWwSV/+zOBFXsD2/FaWHRU0Lj/dL9waknW6qiUWJGKfkKo8Vv0rnbgRvycNu
         +E4mAQ1HiiuPW0eAOK7Ae6UBYI1Yn2+VwNtbGcC5XtAAdsc6ZnZS8Oug+lVq/X9bpcdP
         0b7uMFmtXpjCXnxon7x/BXgBvDRdE2fG9GurxfcmgmGN/CH9K15SN0fOpHH9uhUpc9ob
         /7Ippf1X5eNjkzsZYpxoZEchIcp1vx8zDaG7EUA8rHCbxRL624efxvBCxAFDoZU7OoH6
         Eh+jsf6+SyX5EZ5lKwGfi1unwrWHaGCrWS8uy4QN8Av8oaMuKnW5RgM1MDpSpqW/imAA
         9toQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JXOt82PL9btJEji8+kSD+bo400/x3ZWSIbNQ7m/gSEw=;
        b=ZqD/04WrY8Ha2SFyLwSv2QH2xRn74WmsT1DN9oSHvq/gAtlJeeoqAYyScF/RH5PXrg
         qMxzXVTO1KWayNmqB0bK1yNWCFghfUKF6SWaugAOL33D+NNbL9XeFSIAK2/iS0vVrfFg
         nNf5JaySMvHSQz+dzP1VkXML8poy6Y2hSB7RJqKC7JO4KkgVrx/BeqDvrXWbAZGrZWo9
         Qy+yMY9SjQ94RgxMjNxvt1ph3GgFsAJ4BG+4jrsDFpyiAAujAT6vOA50ol5ZC6JAbzbK
         GHm1qXNptLrm32dXpf5KRz88O94ZSOcEhRgW8FEIgJXtfFvR42z/fuoXzwOSj47B8wKZ
         1AfA==
X-Gm-Message-State: AOAM530wbjjsFUyKhqDjH5pYgUcFTJ7dbZvB1aukF7DhBqZp2ME5RlWr
        z4qi05mahE0cxbCwFV9IPmq5/gloNHz9JA==
X-Google-Smtp-Source: ABdhPJywSHNaEP2NOR3I+aMJMvyPpmTuyy+2engQV/bL401Fne2HZCkR4ueuSlaGtwH3P5ibxrG06Q==
X-Received: by 2002:a92:5e08:: with SMTP id s8mr28516243ilb.308.1607461806796;
        Tue, 08 Dec 2020 13:10:06 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p29sm11128236ill.13.2020.12.08.13.10.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 13:10:06 -0800 (PST)
Subject: Re: [PATCH 5.10 1/5] io_uring: always let io_iopoll_complete()
 complete polled io.
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     xiaoguang.wang@linux.alibaba.com,
        io-uring <io-uring@vger.kernel.org>
References: <cover.1607293068.git.asml.silence@gmail.com>
 <cf556b9b870c640690a1705c073fe955c01dab47.1607293068.git.asml.silence@gmail.com>
 <10e20bd3-b08f-98b8-f857-8b9a75a511dd@kernel.dk>
 <d9f677a4-1ac0-0e64-5c2a-497cac9dc8e5@gmail.com>
 <33b5783d-c238-b0da-38cf-974736c36056@kernel.dk>
 <89d04d6b-2f84-82af-9ee7-edeb69f2a5bb@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7514e884-ce01-380c-5c06-f2331a4906bf@kernel.dk>
Date:   Tue, 8 Dec 2020 14:10:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <89d04d6b-2f84-82af-9ee7-edeb69f2a5bb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/8/20 12:24 PM, Pavel Begunkov wrote:
> On 08/12/2020 19:17, Jens Axboe wrote:
>> On 12/8/20 12:12 PM, Pavel Begunkov wrote:
>>> On 07/12/2020 16:28, Jens Axboe wrote:
>>>> On Sun, Dec 6, 2020 at 3:26 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>>> From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>>>>>
>>>>> The reason is that once we got a non EAGAIN error in io_wq_submit_work(),
>>>>> we'll complete req by calling io_req_complete(), which will hold completion_lock
>>>>> to call io_commit_cqring(), but for polled io, io_iopoll_complete() won't
>>>>> hold completion_lock to call io_commit_cqring(), then there maybe concurrent
>>>>> access to ctx->defer_list, double free may happen.
>>>>>
>>>>> To fix this bug, we always let io_iopoll_complete() complete polled io.
>>>>
>>>> This patch is causing hangs with iopoll testing, if you end up getting
>>>> -EAGAIN on request submission. I've dropped it.
>>>
>>> I fail to understand without debugging how does it happen, especially since
>>> it shouldn't even get out of the while in io_wq_submit_work(). Is that
>>> something obvious I've missed?
>>
>> I didn't have time to look into it, and haven't yet, just reporting that
>> it very reliably fails (and under what conditions).
> 
> Yeah, I get it, asked just in case.
> I'll see what's going on if Xiaoguang wouldn't handle it before.

Should be trivial to reproduce on eg nvme by doing:

echo mq-deadline > /sys/block/nvme0n1/queue/scheduler
echo 2 > /sys/block/nvme0n1/queue/nr_requests

and then run test/iopoll on that device. I'll try and take a look
tomorrow unless someone beats me to it.

-- 
Jens Axboe

