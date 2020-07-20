Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F31226878
	for <lists+io-uring@lfdr.de>; Mon, 20 Jul 2020 18:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388456AbgGTQTp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Jul 2020 12:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387794AbgGTQLY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Jul 2020 12:11:24 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB66C061794
        for <io-uring@vger.kernel.org>; Mon, 20 Jul 2020 09:11:23 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id q74so18221487iod.1
        for <io-uring@vger.kernel.org>; Mon, 20 Jul 2020 09:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=BYqUr1CXn/LWbIDpCFv95fWgX/X0sTMN+KIEoKgBT9g=;
        b=BQchVYHnt5hj8+P/O/cuHxnVgddKs3pyZkKWOh5J6SMY22W8AJIRR7krPhr7M7MXnj
         F/Ud8Kh7hO9fD5nZqhlkBEhQ1vbil0jhOjxHGgwDmlBVPKvjaDigBtOKE8QVJWWma3YK
         FlHwdEORKOaiKW9zaO6h4COzjoDdLYQxOyblL2GwPQrgn9ZTQ4+XuwbIbmW9g3p8aiDK
         tpIkINkuVtBf8AMJPqGcpNXTv0WxHFoefO2WZ4PV2+4aGmW2/TCD7g6HAsLmpsY9fyIa
         hP6f9DGDYQzeYc7FsKqwRQJDyJjZN+mGL4lS3RW7yn9+ECZVrmhW6XzvFHEGYjvXM8YX
         P6Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BYqUr1CXn/LWbIDpCFv95fWgX/X0sTMN+KIEoKgBT9g=;
        b=QpV8ky4Wj8uqLy8BnNrj4tiuW2YEtvG5BuNMA9FmwLeMfvjhqrhPUiL/LHxhTxkt1A
         9i7Q7qnZGKG4qzMjDbQ+DskzDnoXXD6dg9G//kmBAnumNeV5gBkP/wTvgNOHprWgjewo
         Yx3q05GgyN2TJI/X/EwCoDNLYZ85L/iryJZlEISbaozr5v5s/peEXJtDPVnQPy+MIEa/
         VuTeqrCxMbJLXJh/dhuLbilYip5UxczcSrIn+qY2pqISyxtcpdVIkOJ/V2CvU2D7aTuZ
         hLQw1F4b5ps856g3SDjvtUR+tbQOk+OzGBzd5bvxc2Bf0ir2zVX7vemv31X8Kx73NCpb
         GhAQ==
X-Gm-Message-State: AOAM530KlmZWJGxmG44J4A5RHCTDRTxQVJiU2VNE2wH5fws2VVQ457n8
        +dKYjdhYX3JVpbNPY3B7768FeA==
X-Google-Smtp-Source: ABdhPJxE9tIgYp1nGsXBaolEaOkucSVFotXZks2yPE9czV87tx+DxvBw0F4pZ4M+UPtq4KQzbX0BCA==
X-Received: by 2002:a02:694c:: with SMTP id e73mr27185708jac.17.1595261483087;
        Mon, 20 Jul 2020 09:11:23 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t7sm9034365iol.2.2020.07.20.09.11.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2020 09:11:22 -0700 (PDT)
Subject: Re: [PATCH 0/2] task_put batching
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1595021626.git.asml.silence@gmail.com>
 <cf209c59-547e-0a69-244d-7c1fec00a978@kernel.dk>
 <b01e7f2d-d9a6-5593-3afb-5008d96695c6@gmail.com>
 <a2aa8de0-a2d0-3381-3415-4b523c2b66a5@kernel.dk>
 <5b20b94d-13f7-66ee-610a-6f37ec8caa8d@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <35740763-8123-a0d7-3cc6-593c7fcc63e7@kernel.dk>
Date:   Mon, 20 Jul 2020 10:11:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5b20b94d-13f7-66ee-610a-6f37ec8caa8d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/20/20 10:06 AM, Pavel Begunkov wrote:
> On 20/07/2020 18:49, Jens Axboe wrote:
>> On 7/20/20 9:22 AM, Pavel Begunkov wrote:
>>> On 18/07/2020 17:37, Jens Axboe wrote:
>>>> On 7/18/20 2:32 AM, Pavel Begunkov wrote:
>>>>> For my a bit exaggerated test case perf continues to show high CPU
>>>>> cosumption by io_dismantle(), and so calling it io_iopoll_complete().
>>>>> Even though the patch doesn't yield throughput increase for my setup,
>>>>> probably because the effect is hidden behind polling, but it definitely
>>>>> improves relative percentage. And the difference should only grow with
>>>>> increasing number of CPUs. Another reason to have this is that atomics
>>>>> may affect other parallel tasks (e.g. which doesn't use io_uring)
>>>>>
>>>>> before:
>>>>> io_iopoll_complete: 5.29%
>>>>> io_dismantle_req:   2.16%
>>>>>
>>>>> after:
>>>>> io_iopoll_complete: 3.39%
>>>>> io_dismantle_req:   0.465%
>>>>
>>>> Still not seeing a win here, but it's clean and it _should_ work. For
>>>> some reason I end up getting the offset in task ref put growing the
>>>> fput_many(). Which doesn't (on the surface) make a lot of sense, but
>>>> may just mean that we have some weird side effects.
>>>
>>> It grows because the patch is garbage, the second condition is always false.
>>> See the diff. Could you please drop both patches?
>>
>> Hah, indeed. With this on top, it looks like it should in terms of
>> performance and profiles.
> 
> It just shows, that it doesn't really matters for a single-threaded app,
> as expected. Worth to throw some contention though. I'll think about
> finding some time to get/borrow a multi-threaded one.

But it kind of did here, ended up being mostly a wash in terms of perf
here as my testing reported. With the incremental applied, it's up a bit
over before the task put batching.

>> I can just fold this into the existing one, if you'd like.
> 
> Would be nice. I'm going to double-check the counter and re-measure anyway.
> BTW, how did you find it? A tool or a proc file would be awesome.

For this kind of testing, I just use t/io_uring out of fio. It's probably
the lowest overhead kind of tool:

# sudo taskset -c 0 t/io_uring -b512 -p1 /dev/nvme2n1

-- 
Jens Axboe

