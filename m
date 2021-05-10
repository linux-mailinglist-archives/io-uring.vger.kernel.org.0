Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5E7377F34
	for <lists+io-uring@lfdr.de>; Mon, 10 May 2021 11:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbhEJJRI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 May 2021 05:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhEJJRH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 May 2021 05:17:07 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D48D7C061574
        for <io-uring@vger.kernel.org>; Mon, 10 May 2021 02:16:02 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id z6so15802222wrm.4
        for <io-uring@vger.kernel.org>; Mon, 10 May 2021 02:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ZvdltVM9WAJ1ApCsimZ26I6Y6IGriY+siRlcR5xeXkE=;
        b=tMazllgO1H6nEBn/ibGplc/jwEddcHKWlIRM56m9qtjbb6vsMu61JOFrisCu92k0Ee
         JUhtSm7/KoLDJIu4FNXufzDpH+UCXHGsmaUnFv1CuGjoDlWI2mEJmtvKkf2JQpj4RvDk
         Qk0WMpK5OTMKdpJ93jjzePCr2//Ll44UKdj4q/8PKV6m74fV9H4RGTkC4mBB1LSx0NBR
         AHjBSyvusVEH3ntfXZ0Al6pH0t4WiQqgQxAUcvm4SlPl7vcL05BHh6kRhNQICSqjqWJX
         DUpne1AuarOd7wvGY32qOTicafWnnLOFjMSYyHGIxC2k+Bfuv2eygrz38GKllvcHg9Ar
         SrhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZvdltVM9WAJ1ApCsimZ26I6Y6IGriY+siRlcR5xeXkE=;
        b=G1lpq0MUx7N6NvyWBElHrSeFoCSTd06v3lt4+8w16O2vzfPq1C0wURfL6U9F0OQt4E
         C+oXF00tjjZBEe+Snl9ZmMOcI57Pk1HgMPYRjlsvbp7VAQ0Nvtjh0lNNjQMNuIUgP+Mb
         wCJuz95P26OOqUMHp9OwoFLDNTuHZHWuYdXFeqzC77lAFcPiUExo4GEUiyfmOYlOirtw
         g4k1v4siuEiWRqXxQPjXAE8tmmkSz6nlS8Qi67hGjSo5dWQtA0RqJB2xRkIUWrc5ux/z
         giG4xhC0HrOAHjKPc8cgPNks33s2ji4FY00tWR14CpK/FZ/FdqPvY84SITeA5Dxq3lhU
         4Xrw==
X-Gm-Message-State: AOAM531UV7qYpHbZD1mYaa/ED47dW46LFu4+/96rB1ijFkUd2hQkUx70
        7y/wRRHrQwfN2aR3MX0UHHImwxsLXkc=
X-Google-Smtp-Source: ABdhPJxCKExSX1C2nfHK/6smHunhRxATqSQON+HsVBBP/7AOuZTEYgfHbeNs9hKJ3oRUuqDpQx4b9w==
X-Received: by 2002:a05:6000:504:: with SMTP id a4mr30040985wrf.51.1620638161475;
        Mon, 10 May 2021 02:16:01 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.234.132])
        by smtp.gmail.com with ESMTPSA id e38sm23820450wmp.21.2021.05.10.02.16.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 May 2021 02:16:01 -0700 (PDT)
Subject: Re: [PATCH 16/16] io_uring: return back safer resurrect
To:     yangerkun <yangerkun@huawei.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
References: <cover.1618101759.git.asml.silence@gmail.com>
 <7a080c20f686d026efade810b116b72f88abaff9.1618101759.git.asml.silence@gmail.com>
 <2ac2c145-5e08-d1e3-ea13-83284a0f477a@huawei.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <925d3206-b67b-f800-c41d-6167e30d3c9c@gmail.com>
Date:   Mon, 10 May 2021 10:15:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <2ac2c145-5e08-d1e3-ea13-83284a0f477a@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/10/21 3:22 AM, yangerkun wrote:
> 在 2021/4/11 8:46, Pavel Begunkov 写道:
>> Revert of revert of "io_uring: wait potential ->release() on resurrect",
>> which adds a helper for resurrect not racing completion reinit, as was
>> removed because of a strange bug with no clear root or link to the
>> patch.
>>
>> Was improved, instead of rcu_synchronize(), just wait_for_completion()
>> because we're at 0 refs and it will happen very shortly. Specifically
>> use non-interruptible version to ignore all pending signals that may
>> have ended prior interruptible wait.
>>
>> This reverts commit cb5e1b81304e089ee3ca948db4d29f71902eb575.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> 
> I have a question. Compare with the logical before this patch. We need call reinit_completion(&ctx->ref_comp) to make sure the effective use of the ref_comp.
> 
> Does we forget to do this? Or I miss something?
If percpu_ref_tryget() there succeeds, it should have not called
complete by design, otherwise it do complete once (+1 completion
count) following with a single wait(-1 completion count), so +1 -1
should return it back to zero. See how struct completion works,
e.g. completion.rst, number of completions is counted inside.

btw, you have a strange mail encoding, apparently it's not Unicode

-- 
Pavel Begunkov
