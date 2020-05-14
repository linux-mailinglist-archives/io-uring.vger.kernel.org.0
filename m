Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2AFE1D356C
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2020 17:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgENPnY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 May 2020 11:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbgENPnY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 May 2020 11:43:24 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35143C061A0C
        for <io-uring@vger.kernel.org>; Thu, 14 May 2020 08:43:23 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id k19so1298727pll.9
        for <io-uring@vger.kernel.org>; Thu, 14 May 2020 08:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=OCQpS10JQrcVCte4c3jVqrW09BGJccTnUvGw01SchCI=;
        b=FiWnLCv2UAIYII0jpP+2AVus38Nx7dtYuXf3mVLecHUBjMZuqcTW1I8oBE6pQpm03t
         NcDnHL3CgBA8Gp3FIg/1/IoX2mrQXMXGZ+fPdFn028/BtceKiNv2geFGfU3YrZ9xx7/a
         uomuvI0T1yaXeG8sXPF9c6jhkhP8YDBHcZl0mjsJK97luLn1xV17UYC6GxITkVQx6Vw2
         rJ9aNRJE98B7FKBMvFaO1qJTsIV5ItWU70XY+dZW/TY+ImLOC7r8olpoehm5EQ/oU3Bu
         1lIctOw1muhZer3Vjs8RHuTXzwQQjNw8PWQR35qM03C9sXl+0AhI7LENs9OWVPinFSro
         1i/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OCQpS10JQrcVCte4c3jVqrW09BGJccTnUvGw01SchCI=;
        b=AErAs68EYIkqn92v+fO31Tq79VMnmoEsLemy8wHhB0kG7sVOQSSQGrva13W9gWwxTu
         9so+llO21cdRJ9jLmpzRvP/LUijcuseBFkyqLKaLB8iOi+nt0K64d6tAG+EQuxokA6PL
         YsQe9N5BE5LHMTMtDT/jHeWOf8qToyuVUbZak1Z91aSim6m5Tfq34OSWQ4++xlylYKIX
         SkG0nCr8HhsZGVdCiEWGEfUVJjU7rLKaVVsGhlrhl9vCA9qqIc3lsga6Wldww2LBGL9M
         XiikQAauWFqjShLTSRPmlm15QM8/KAqohp/z2/T3dwQFwQarZP/Mew2dcjEA6Ee2p4ur
         SFhg==
X-Gm-Message-State: AGi0Puax8poc77qTTPKse0nHctf7w1KSAgH8tbKB/p8+KS7f4sTyaUHQ
        leiZ2p9nPbJGsM3qgprSPZqyGxxxwE0=
X-Google-Smtp-Source: APiQypKPziX9bgRzBDaVh4jeQoDXvNsaZ/gT68met0/Y91J0lK7bw1UHG3lla3GAFCT9U2YwSR9OfA==
X-Received: by 2002:a17:90a:d0c3:: with SMTP id y3mr39999981pjw.25.1589471002346;
        Thu, 14 May 2020 08:43:22 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:85e7:ddeb:bb07:3741? ([2605:e000:100e:8c61:85e7:ddeb:bb07:3741])
        by smtp.gmail.com with ESMTPSA id a2sm2336742pgh.57.2020.05.14.08.43.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2020 08:43:21 -0700 (PDT)
Subject: Re: regression: fixed file hang
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>
References: <67435827-eb94-380c-cdca-aee69d773d4d@kernel.dk>
 <e183e1c4-8331-93c6-a8de-c9da31e6cd56@kernel.dk>
 <ac2b8f17-dd3e-c31f-d8a0-737774a2bb92@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <946f6af2-2daf-6209-55a8-57f25d3eba30@kernel.dk>
Date:   Thu, 14 May 2020 09:43:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <ac2b8f17-dd3e-c31f-d8a0-737774a2bb92@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/13/20 11:33 PM, Xiaoguang Wang wrote:
> hi,
> 
>> On 5/13/20 12:45 PM, Jens Axboe wrote:
>>> Hi Xiaoguang,
>>>
>>> Was doing some other testing today, and noticed a hang with fixed files.
>>> I did a bit of poor mans bisecting, and came up with this one:
>>>
>>> commit 0558955373023b08f638c9ede36741b0e4200f58
>>> Author: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>>> Date:   Tue Mar 31 14:05:18 2020 +0800
>>>
>>>      io_uring: refactor file register/unregister/update handling
>>>
>>> If I revert this one, the test completes fine.
>>>
>>> The case case is pretty simple, just run t/io_uring from the fio
>>> repo, default settings:
>>>
>>> [ fio] # t/io_uring /dev/nvme0n1p2
>>> Added file /dev/nvme0n1p2
>>> sq_ring ptr = 0x0x7fe1cb81f000
>>> sqes ptr    = 0x0x7fe1cb81d000
>>> cq_ring ptr = 0x0x7fe1cb81b000
>>> polled=1, fixedbufs=1, buffered=0 QD=128, sq_ring=128, cq_ring=256
>>> submitter=345
>>> IOPS=240096, IOS/call=32/31, inflight=91 (91)
>>> IOPS=249696, IOS/call=32/31, inflight=99 (99)
>>> ^CExiting on signal 2
>>>
>>> and ctrl-c it after a second or so. You'll then notice a kworker that
>>> is stuck in io_sqe_files_unregister(), here:
>>>
>>> 	/* wait for all refs nodes to complete */
>>> 	wait_for_completion(&data->done);
>>>
>>> I'll try and debug this a bit, and for some reason it doens't trigger
>>> with the liburing fixed file setup. Just wanted to throw this out there,
>>> so if you have cycles, please do take a look at it.
>>
>> https://lore.kernel.org/io-uring/015659db-626c-5a78-6746-081a45175f45@kernel.dk/T/#u
> Thanks for this fix, and sorry, it's my bad, I didn't cover this case
> when sending patches.  Can you share your test cases or test method
> when developing io_uring? Usually I just run test cases under
> liburing/test, seems it's not enough.

It really should be enough, the case that triggered this issue is the
combination of fixed files and polled IO. I'll need to add that to eg
test/read-write.c, which does a lot of combinations already.

The only issue is that polled IO only works on some files / devices.
I've been meaning to add a config file to the liburing regression tests,
so you can configure a device to use for testing. With an NVMe device in
there, we should be able to have full coverage.

-- 
Jens Axboe

