Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBB94379BDC
	for <lists+io-uring@lfdr.de>; Tue, 11 May 2021 03:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbhEKBMO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 May 2021 21:12:14 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:2619 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbhEKBMN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 May 2021 21:12:13 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FfKZ01cgczklbx;
        Tue, 11 May 2021 09:08:56 +0800 (CST)
Received: from [10.174.177.210] (10.174.177.210) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Tue, 11 May 2021 09:11:04 +0800
Subject: Re: [PATCH 16/16] io_uring: return back safer resurrect
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, <io-uring@vger.kernel.org>
References: <cover.1618101759.git.asml.silence@gmail.com>
 <7a080c20f686d026efade810b116b72f88abaff9.1618101759.git.asml.silence@gmail.com>
 <2ac2c145-5e08-d1e3-ea13-83284a0f477a@huawei.com>
 <925d3206-b67b-f800-c41d-6167e30d3c9c@gmail.com>
From:   yangerkun <yangerkun@huawei.com>
Message-ID: <a8fbcb69-9fdc-32ac-4752-7e1016239702@huawei.com>
Date:   Tue, 11 May 2021 09:11:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <925d3206-b67b-f800-c41d-6167e30d3c9c@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.210]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



在 2021/5/10 17:15, Pavel Begunkov 写道:
> On 5/10/21 3:22 AM, yangerkun wrote:
>> 在 2021/4/11 8:46, Pavel Begunkov 写道:
>>> Revert of revert of "io_uring: wait potential ->release() on resurrect",
>>> which adds a helper for resurrect not racing completion reinit, as was
>>> removed because of a strange bug with no clear root or link to the
>>> patch.
>>>
>>> Was improved, instead of rcu_synchronize(), just wait_for_completion()
>>> because we're at 0 refs and it will happen very shortly. Specifically
>>> use non-interruptible version to ignore all pending signals that may
>>> have ended prior interruptible wait.
>>>
>>> This reverts commit cb5e1b81304e089ee3ca948db4d29f71902eb575.
>>>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>
>> I have a question. Compare with the logical before this patch. We need call reinit_completion(&ctx->ref_comp) to make sure the effective use of the ref_comp.
>>
>> Does we forget to do this? Or I miss something?
> If percpu_ref_tryget() there succeeds, it should have not called
> complete by design, otherwise it do complete once (+1 completion
> count) following with a single wait(-1 completion count), so +1 -1
> should return it back to zero. See how struct completion works,
> e.g. completion.rst, number of completions is counted inside.

Got it. Thanks for your explain!

> 
> btw, you have a strange mail encoding, apparently it's not Unicode

Yeah... I have change to Unicode!

Thanks,
Kun.
> 
