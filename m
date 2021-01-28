Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB03C307C64
	for <lists+io-uring@lfdr.de>; Thu, 28 Jan 2021 18:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbhA1R1r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Jan 2021 12:27:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233089AbhA1RZ2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Jan 2021 12:25:28 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31851C06178B
        for <io-uring@vger.kernel.org>; Thu, 28 Jan 2021 09:24:48 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id e9so4727293pjj.0
        for <io-uring@vger.kernel.org>; Thu, 28 Jan 2021 09:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=k6KOw6TO5y2Bh+eL97C+VrKyBkEDWeKSo94qjJ/JXQc=;
        b=cSldyJVO7TOXIgus+kBTIbdd3giA793RvJ93NhNvoz1FzQ63s3CUEn865rFGh7uTqT
         TuWlu3nCyv1xm5OCaFUPfGwy6ezaduaTdCbwa6XVoqxaln8vYD+FeVALYfTJbnRjh4jb
         b2w7i+6z2m+2WU6cxo+WxQvKP/VhoQB2ouaUrS0zYyUm0Q4WCoZ1RGrOGZISbLeNcRO6
         Ojk3hQvV9NdgrJH+KY9KTufNj/lkj2yIvYGQJ/oQALjXTsQBMBPw3gcrkulZUdyr26EZ
         Jp4H6Jtb9G6bbCg8K4EgQt3n3PBxq5/NaKhJmeN+IZP++k7T0gxDA7m6nYtyYJ2OoIKI
         YLnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k6KOw6TO5y2Bh+eL97C+VrKyBkEDWeKSo94qjJ/JXQc=;
        b=h7vZJ3SzzG2xyeF2iVHImvBumA8g0P5z6Lkvb6BS51U5OQG8hhTWElOHWywHfFB0hC
         PHBTrfxuJhAy7j5fdMedR7eXxxe3CtRsbXQ4oSumZ9je1hxFn6fxxRMOLhrQf81B9TuG
         ++ydgFVfTUaJkXqoKYwt6qTQhpFDiwvDjrWp7dwGyY8NtdhtwiGdoDLjmtBJN9zR+mKB
         cOJcEUdeZE/M/SS/Gs6iI8EdFMAwJ2tG/za0Zgvlh4njVVv6zZBlY8UpbMP0ncLIi8Wt
         LrRnTkAVWjDDZt+9HrUgzY6GCcNmYeCNdyvf+i94d/O8QpiRPZs1yAwFjgCdLDnqvbon
         1d3w==
X-Gm-Message-State: AOAM530NNiQlec2icKqw8cWZDVs9+1ti6OIsMFzwTpb54MS8vOJ9OPoK
        g/rvQuyVx9IkuMcStP/5cW3Msg==
X-Google-Smtp-Source: ABdhPJysQVpQhoQlkD/frj1l6FrX3HY6nooq1GEcHiieSHhCQzb4baX4OI4a/K2auNWakmowOnOAOw==
X-Received: by 2002:a17:903:1cc:b029:de:98bb:d46d with SMTP id e12-20020a17090301ccb02900de98bbd46dmr350979plh.54.1611854687441;
        Thu, 28 Jan 2021 09:24:47 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id r194sm6392534pfr.168.2021.01.28.09.24.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 09:24:46 -0800 (PST)
Subject: Re: [RFC PATCH 0/4] Asynchronous passthrough ioctl
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>, sagi@grimberg.me,
        linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Selvakumar S <selvakuma.s1@samsung.com>
References: <CGME20210127150134epcas5p251fc1de3ff3581dd4c68b3fbe0b9dd91@epcas5p2.samsung.com>
 <20210127150029.13766-1-joshi.k@samsung.com>
 <489691ce-3b1e-30ce-9f72-d32389e33901@gmail.com>
 <a287bd9e-3474-83a4-e5c2-98df17214dc7@gmail.com>
 <CA+1E3rJHHFyjwv7Kp32E9H-cf5ksh0pOHSVdGoTpktQrB8SE6A@mail.gmail.com>
 <2d37d0ca-5853-4bb6-1582-551b9044040c@kernel.dk>
 <CA+1E3rKeqaLXBuvpMcjZ37XH9RqJHjPnTFObJj0T-u8K9Otw-w@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <dd0392a1-acfa-ef4d-5531-5f1dddc9efe7@kernel.dk>
Date:   Thu, 28 Jan 2021 10:24:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CA+1E3rKeqaLXBuvpMcjZ37XH9RqJHjPnTFObJj0T-u8K9Otw-w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/28/21 10:13 AM, Kanchan Joshi wrote:
> On Thu, Jan 28, 2021 at 8:08 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 1/28/21 5:04 AM, Kanchan Joshi wrote:
>>> On Wed, Jan 27, 2021 at 9:32 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>>
>>>> On 27/01/2021 15:42, Pavel Begunkov wrote:
>>>>> On 27/01/2021 15:00, Kanchan Joshi wrote:
>>>>>> This RFC patchset adds asynchronous ioctl capability for NVMe devices.
>>>>>> Purpose of RFC is to get the feedback and optimize the path.
>>>>>>
>>>>>> At the uppermost io-uring layer, a new opcode IORING_OP_IOCTL_PT is
>>>>>> presented to user-space applications. Like regular-ioctl, it takes
>>>>>> ioctl opcode and an optional argument (ioctl-specific input/output
>>>>>> parameter). Unlike regular-ioctl, it is made to skip the block-layer
>>>>>> and reach directly to the underlying driver (nvme in the case of this
>>>>>> patchset). This path between io-uring and nvme is via a newly
>>>>>> introduced block-device operation "async_ioctl". This operation
>>>>>> expects io-uring to supply a callback function which can be used to
>>>>>> report completion at later stage.
>>>>>>
>>>>>> For a regular ioctl, NVMe driver submits the command to the device and
>>>>>> the submitter (task) is made to wait until completion arrives. For
>>>>>> async-ioctl, completion is decoupled from submission. Submitter goes
>>>>>> back to its business without waiting for nvme-completion. When
>>>>>> nvme-completion arrives, it informs io-uring via the registered
>>>>>> completion-handler. But some ioctls may require updating certain
>>>>>> ioctl-specific fields which can be accessed only in context of the
>>>>>> submitter task. For that reason, NVMe driver uses task-work infra for
>>>>>> that ioctl-specific update. Since task-work is not exported, it cannot
>>>>>> be referenced when nvme is compiled as a module. Therefore, one of the
>>>>>> patch exports task-work API.
>>>>>>
>>>>>> Here goes example of usage (pseudo-code).
>>>>>> Actual nvme-cli source, modified to issue all ioctls via this opcode
>>>>>> is present at-
>>>>>> https://github.com/joshkan/nvme-cli/commit/a008a733f24ab5593e7874cfbc69ee04e88068c5
>>>>>
>>>>> see https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-fops
>>>>>
>>>>> Looks like good time to bring that branch/discussion back
>>>>
>>>> a bit more context:
>>>> https://github.com/axboe/liburing/issues/270
>>>
>>> Thanks, it looked good. It seems key differences (compared to
>>> uring-patch that I posted) are -
>>> 1. using file-operation instead of block-dev operation.
>>
>> Right, it's meant to span wider than just block devices.
>>
>>> 2. repurpose the sqe memory for ioctl-cmd. If an application does
>>> ioctl with <=40 bytes of cmd, it does not have to allocate ioctl-cmd.
>>> That's nifty. We still need to support passing larger-cmd (e.g.
>>> nvme-passthru ioctl takes 72 bytes) but that shouldn't get too
>>> difficult I suppose.
>>
>> It's actually 48 bytes in the as-posted version, and I've bumped it to
>> 56 bytes in the latest branch. So not quite enough for everything,
>> nothing ever will be, but should work for a lot of cases without
>> requiring per-command allocations just for the actual command.
> 
> Agreed. But if I got it right, you are open to support both in-the-sqe
> command (<= 56 bytes) and out-of-sqe command (> 56 bytes) with this
> interface.
> Driver processing the ioctl can fetch the cmd from user-space in one
> case (as it does now), and skips in another.

Your out-of-seq command would be none of io_urings business, outside of
the fact that we'd need to ensure it's stable if we need to postpone
it. So yes, that would be fine, it just means your actual command is
passed in as a pointer, and you would be responsible for copying it
in for execution

We're going to need something to handle postponing, and something
for ensuring that eg cancelations free the allocated memory.

>>> And for some ioctls, driver may still need to use task-work to update
>>> the user-space pointers (embedded in uring/ioctl cmd) during
>>> completion.
>>>
>>> @Jens - will it be fine if I start looking at plumbing nvme-part of
>>> this series on top of your work?
>>
>> Sure, go ahead. Just beware that things are still changing, so you might
>> have to adapt it a few times. It's still early days, but I do think
>> that's the way forward in providing controlled access to what is
>> basically async ioctls.
> 
> Sounds good, I will start with the latest branch that you posted. Thanks.

It's io_uring-fops.v2 for now, use that one.

-- 
Jens Axboe

