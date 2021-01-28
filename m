Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52DE4307847
	for <lists+io-uring@lfdr.de>; Thu, 28 Jan 2021 15:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbhA1Oix (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Jan 2021 09:38:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231393AbhA1Oir (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Jan 2021 09:38:47 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C15C061786
        for <io-uring@vger.kernel.org>; Thu, 28 Jan 2021 06:38:06 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id t29so4094353pfg.11
        for <io-uring@vger.kernel.org>; Thu, 28 Jan 2021 06:38:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+K9aRikhzkU/M83eoE775gCY9CV/6b9E2oecU5axx5g=;
        b=UMAxMG1FLhDbDsBf51QXNFGmn0mwp++nMNGqrEfynUCJ3cWwcCSGds0fZsfDoQcBak
         fsOVcl9etsXuKbnwhMZaLdlg4Yk13sr4vdMkubJLJ4PNmbcG0h1JAhdI8+5M9cz7Xi8D
         YLOnI+VT7aOwynM7CQhRpsjkkP3o2bSU0Go28TanqY25/coaBtUgo5t4X2jpI1g9Ce6w
         vivCVWOe1k+QAwpqX5tkcfXer2T9txbbdWncaalBy+TrL+oaiWfsWhxbuw53sZyVNibV
         w3YEc9V2PEX+gLzWSsQedWAzZDBW87S0K5flsI7JSdkqpG/9TMmwqoIlURSlPYxOmtYT
         yuKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+K9aRikhzkU/M83eoE775gCY9CV/6b9E2oecU5axx5g=;
        b=O7wJ2qFJYDv+7aMyGva0K3A4kqHOmNZUz+A1W7uMgzlZAUsMaEzrZ+F2FTPO+SxnGz
         ddZ3SfBCyJJzkOfMEOwXcQbyH9nfCtK0r9oeZcQEv3y0IuznOqUo/YJFJPWIhTcjzeUf
         GbU4jqzOJCODIeSeinSgS9o7mDAdamSQUOvT7JY513iIorhMrImbphhSwvpvgb9abPmi
         c/+jIhTDCQKLi1w2dHwYeEvYIcijc6ChxEEnTMaQNpMfvhc6FOR3uBTbpVRbYF9rg1hP
         /wDhy+oTtJPwgJyGhYh0V1k3FKkoeuZgOnCF20/lL8CecMXvBmh/yi2gOWhMyj1tPXkz
         KiKg==
X-Gm-Message-State: AOAM530Ggj8ijduL3CDskimpLRn1Wk2YwIrs056V5FtFa2DVZ48hfbsC
        fmcjza2JsAE/46bQjAwGPJSdZvP3IehxXQ==
X-Google-Smtp-Source: ABdhPJxoXLGAyp++HZF4CXIJUzkqE1H0ePUwPy8jBDvALyGIXU+gMp1KP4aQg31Mh8+DlsvT8IOp8w==
X-Received: by 2002:a63:e109:: with SMTP id z9mr16757589pgh.5.1611844685941;
        Thu, 28 Jan 2021 06:38:05 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id b62sm6249262pfg.58.2021.01.28.06.38.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 06:38:05 -0800 (PST)
Subject: Re: [RFC PATCH 0/4] Asynchronous passthrough ioctl
To:     Kanchan Joshi <joshiiitr@gmail.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>,
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
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2d37d0ca-5853-4bb6-1582-551b9044040c@kernel.dk>
Date:   Thu, 28 Jan 2021 07:38:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CA+1E3rJHHFyjwv7Kp32E9H-cf5ksh0pOHSVdGoTpktQrB8SE6A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/28/21 5:04 AM, Kanchan Joshi wrote:
> On Wed, Jan 27, 2021 at 9:32 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 27/01/2021 15:42, Pavel Begunkov wrote:
>>> On 27/01/2021 15:00, Kanchan Joshi wrote:
>>>> This RFC patchset adds asynchronous ioctl capability for NVMe devices.
>>>> Purpose of RFC is to get the feedback and optimize the path.
>>>>
>>>> At the uppermost io-uring layer, a new opcode IORING_OP_IOCTL_PT is
>>>> presented to user-space applications. Like regular-ioctl, it takes
>>>> ioctl opcode and an optional argument (ioctl-specific input/output
>>>> parameter). Unlike regular-ioctl, it is made to skip the block-layer
>>>> and reach directly to the underlying driver (nvme in the case of this
>>>> patchset). This path between io-uring and nvme is via a newly
>>>> introduced block-device operation "async_ioctl". This operation
>>>> expects io-uring to supply a callback function which can be used to
>>>> report completion at later stage.
>>>>
>>>> For a regular ioctl, NVMe driver submits the command to the device and
>>>> the submitter (task) is made to wait until completion arrives. For
>>>> async-ioctl, completion is decoupled from submission. Submitter goes
>>>> back to its business without waiting for nvme-completion. When
>>>> nvme-completion arrives, it informs io-uring via the registered
>>>> completion-handler. But some ioctls may require updating certain
>>>> ioctl-specific fields which can be accessed only in context of the
>>>> submitter task. For that reason, NVMe driver uses task-work infra for
>>>> that ioctl-specific update. Since task-work is not exported, it cannot
>>>> be referenced when nvme is compiled as a module. Therefore, one of the
>>>> patch exports task-work API.
>>>>
>>>> Here goes example of usage (pseudo-code).
>>>> Actual nvme-cli source, modified to issue all ioctls via this opcode
>>>> is present at-
>>>> https://github.com/joshkan/nvme-cli/commit/a008a733f24ab5593e7874cfbc69ee04e88068c5
>>>
>>> see https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-fops
>>>
>>> Looks like good time to bring that branch/discussion back
>>
>> a bit more context:
>> https://github.com/axboe/liburing/issues/270
> 
> Thanks, it looked good. It seems key differences (compared to
> uring-patch that I posted) are -
> 1. using file-operation instead of block-dev operation.

Right, it's meant to span wider than just block devices.

> 2. repurpose the sqe memory for ioctl-cmd. If an application does
> ioctl with <=40 bytes of cmd, it does not have to allocate ioctl-cmd.
> That's nifty. We still need to support passing larger-cmd (e.g.
> nvme-passthru ioctl takes 72 bytes) but that shouldn't get too
> difficult I suppose.

It's actually 48 bytes in the as-posted version, and I've bumped it to
56 bytes in the latest branch. So not quite enough for everything,
nothing ever will be, but should work for a lot of cases without
requiring per-command allocations just for the actual command.

> And for some ioctls, driver may still need to use task-work to update
> the user-space pointers (embedded in uring/ioctl cmd) during
> completion.
> 
> @Jens - will it be fine if I start looking at plumbing nvme-part of
> this series on top of your work?

Sure, go ahead. Just beware that things are still changing, so you might
have to adapt it a few times. It's still early days, but I do think
that's the way forward in providing controlled access to what is
basically async ioctls.

-- 
Jens Axboe

