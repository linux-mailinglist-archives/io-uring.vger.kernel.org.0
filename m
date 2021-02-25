Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05D31324EAF
	for <lists+io-uring@lfdr.de>; Thu, 25 Feb 2021 12:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbhBYK7u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Feb 2021 05:59:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbhBYK7s (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Feb 2021 05:59:48 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7485BC061574
        for <io-uring@vger.kernel.org>; Thu, 25 Feb 2021 02:59:08 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id t15so4772284wrx.13
        for <io-uring@vger.kernel.org>; Thu, 25 Feb 2021 02:59:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=faJHMUZgoQbGy2VaIidkE5EiRYYgl3kci1TLPNAWQLE=;
        b=S9qvd2mQWdnb0vk2J9VQlz5vFqA/5R1bDcsPONfNZxuw5dzGmyyYgnl4LJBvgqAxx4
         nmhRRzSSZUSwUj/P7K8xQ4+e9EOg+HZWquHtlniEoqlfN9rN4V/kwk8wkl9JsF0K6o1i
         3yk3k5djlBn1bulyFzv1LVHeoIErq0QbFI5p64413HetO8Bsn+BCDS8R2Zs38cvMTjSG
         MbuQceQZmONEwRgV9PBvGUHuIAlYtvQpUU8q2mwelctepKd6e29plrsXHKTcmKPGkEqw
         5ISM7R8tFc0C6trvzXgVMhya6qccm+xMNj+lc+nuEO6jKt5uuAHikl9g1C43wpr4OZHH
         3a9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=faJHMUZgoQbGy2VaIidkE5EiRYYgl3kci1TLPNAWQLE=;
        b=eddOS94FJjWDz1IuHbkGUX/n05Tw05s0GeWQyyrxcJG3Xl7iCdwm2sRHf3GcCInbIR
         I+860QcwZ4K6Bw08A01blqHiC7lZPGmOtrXHoLwOwqN5y1DRWXV7Rqnt4QATgakc6SJ7
         GLofYxxnz5ayhkfyJqF0XyVw2M5Uzyipn+LI/OYuT965utBPNxcgDWfYOJvYqS8ZuVAT
         efF11YUfCZLZxr9DICYHrxV1e+7Q8i/CwhMZa3lHfKTK0Hj/+ViyXPU1RaRXuME+YcCd
         9ZlwsT8M/fD/krWBGS/W6QYqf8rD+VnTrGvRZh+0FiplkF4LVgNth56SOfkkx5rBHK3/
         bPoQ==
X-Gm-Message-State: AOAM532ePzCimrL/bXt9jew8l8wSoI7vdAd5gLbWB4ObUjFWejj25IaD
        njbdrb2SBihOJqspvd9vR8oc4Y21RskgkA==
X-Google-Smtp-Source: ABdhPJyvkfOXM6sbqrzjcTsz5Fg19DPxoZ18pP0tWo95UoUbQOx+YBOWqx15PBVwXKDSjIGDH0ZiSQ==
X-Received: by 2002:adf:c587:: with SMTP id m7mr833392wrg.369.1614250747259;
        Thu, 25 Feb 2021 02:59:07 -0800 (PST)
Received: from [192.168.8.165] ([148.252.129.28])
        by smtp.gmail.com with ESMTPSA id d65sm7813448wmc.34.2021.02.25.02.59.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Feb 2021 02:59:06 -0800 (PST)
To:     Hao Xu <haoxu@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
References: <20210206150006.1945-1-xiaoguang.wang@linux.alibaba.com>
 <e4220bf0-2d60-cdd8-c738-cf48236073fa@gmail.com>
 <1b6ec862-cb5b-eea1-d640-c39d4c87315c@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] io_uring: don't issue reqs in iopoll mode when ctx is
 dying
Message-ID: <80bee547-1baf-e2da-d0f0-5572491a77c8@gmail.com>
Date:   Thu, 25 Feb 2021 10:55:15 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1b6ec862-cb5b-eea1-d640-c39d4c87315c@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 24/02/2021 12:42, Hao Xu wrote:
> 在 2021/2/8 上午1:30, Pavel Begunkov 写道:
>> On 06/02/2021 15:00, Xiaoguang Wang wrote:
>> Looks as you say, but the patch doesn't solve the issue completely.
>> 1. We must not do io_queue_async_work() under a different task context,
>> because of it potentially uses a different set of resources. So, I just
> Hi Pavel,
> I've some questions.
>  - Why would the resources be potentially different? My understanding is the tasks which can share a uring instance must be in the same process, so they have same context(files, mm etc.)

"task" and "process" are pretty synonyms in this context, as well as
struct task. And they can have different files/mm, e.g. io_uring works
across fork.

>  - Assume 1 is true, why don't we just do something like this:
>        req->work.identity = req->task->io_uring->identity;
>    since req->task points to the original context

Because there is more to be done to that, see grab_identity or something,
and it may be racy to do. As mentioned, identity will cease to exist with
Jens' patches, and in any case we can punt to task_work.

> 
>> thought that it would be better to punt it to the right task context
>> via task_work. But...
>>
>> 2. ...iovec import from io_resubmit_prep() might happen after submit ends,
>> i.e. when iovec was freed in userspace. And that's not great at all.
> I didn't get it why here we need to import iovec. My understanding is OPs(such as readv writev) which need imoport iovec already did that in the first inline IO, what do I omit? 

Nope, it may skip copying them. e.g. see -EIOCBQUEUED path of io_read().

> And if it is neccessary, how do we ensure the iovec wasn't freed in userspace at the reissuing time?

We should not import_iovec() for reissue after we left submit, and
that's exactly the problem happening with IOPOLL.

For __io_complete_rw(), Jens tells that it returns -EAGAIN IFF it
called the callback from the submission, correct me if I'm wrong.
I have never checked it myself, though

-- 
Pavel Begunkov
