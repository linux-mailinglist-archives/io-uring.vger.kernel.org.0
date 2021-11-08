Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7025044989F
	for <lists+io-uring@lfdr.de>; Mon,  8 Nov 2021 16:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236037AbhKHPoi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Nov 2021 10:44:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236257AbhKHPoi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Nov 2021 10:44:38 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC681C061570
        for <io-uring@vger.kernel.org>; Mon,  8 Nov 2021 07:41:53 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id h12-20020a056830034c00b0055c8458126fso7201817ote.0
        for <io-uring@vger.kernel.org>; Mon, 08 Nov 2021 07:41:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jfU5ZJRd8za3mOVIavSGK5Blg+rFCUkBl4miYhn8eGc=;
        b=LqG6x657XXMGoTc7QYvHfP4ahE4g47et+f7FffakwpwY5cFARILuCNmdiTwPVThIfj
         OLfiuEleM1diosomva7XpXvvyaTIPjbVWEQUfLshVp/+LcjgAyiRdwb+ZTxtOPYBOOAE
         +Zma9+iFjJduSOV4SVma0ng/v9KO7HLEA09//ierw96VAmerP0kmjExrfmv5PG9SYcQS
         bssEePeGxVeXGVeEwZWPegwUtqTtfZ1xWK/LzTjItvJM9lIymvoujqZS7Ap1H4WmaEKO
         jSoUGPM3rbOUuAys+0J3iKS0l2KeHwRHvVtDIkE5x3RSClP2j8JNHJkGqWHpAzhpUm+4
         /AGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jfU5ZJRd8za3mOVIavSGK5Blg+rFCUkBl4miYhn8eGc=;
        b=3ALrLu6ncx+RYllNpnfeE+vhMcer0EeKWyCWAa9nRKUg7AkS2ywUXNl+lgoAtInPWL
         FDfaFGfOVKqFx5V4oH7R/r0Xh49kH7mUVblaPN1eXK/F9tK5JklxVKh/N/1IHcfKPl20
         C25oZ2SjK4DK7+YVsvvihdbIsRZBrymdz7KEO6IaIO/APdAyCWqDc27nh6nt1Y8j8unt
         MWBMemokytl0GxtESShCCSRDG68MIgRqFXI9RfPCHGqvleu1hnt7dXCmW4+pDUoAKK/V
         tfgsJSir/eYWPjrcpGfnF77b+JWJIU4GuIEP131siDFvHf86CaswHyAoXM+O5ubklBy6
         KQzA==
X-Gm-Message-State: AOAM5304F8/fw5CA239nJ2T236Ets4nRsK9a5QM0+MHxQ5opWMB8qGl6
        z1IPPg/1+bID0H8d8dqAkbPVfw==
X-Google-Smtp-Source: ABdhPJx5LteWXnLHtxP6I1EP8bPIIGoTOvY+4FgRdcybIceE1tD1wWzGGRg4bxzbbuF8bfmvtYtdLQ==
X-Received: by 2002:a05:6830:1e57:: with SMTP id e23mr586267otj.16.1636386113269;
        Mon, 08 Nov 2021 07:41:53 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id q9sm991366oti.32.2021.11.08.07.41.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 07:41:52 -0800 (PST)
Subject: Re: [syzbot] KASAN: stack-out-of-bounds Read in iov_iter_revert
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        syzbot <syzbot+9671693590ef5aad8953@syzkaller.appspotmail.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <6f7d4c1d-f923-3ab1-c525-45316b973c72@gmail.com>
 <00000000000047f3b805c962affb@google.com> <YYLAYvFU+9cnu+4H@google.com>
 <0b4a5ff8-12e5-3cc7-8971-49e576444c9a@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <dd122760-5f87-10b1-e50d-388c2631c01a@kernel.dk>
Date:   Mon, 8 Nov 2021 08:41:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0b4a5ff8-12e5-3cc7-8971-49e576444c9a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/8/21 8:29 AM, Pavel Begunkov wrote:
> On 11/3/21 17:01, Lee Jones wrote:
>> Good afternoon Pavel,
>>
>>> syzbot has tested the proposed patch and the reproducer did not trigger any issue:
>>>
>>> Reported-and-tested-by: syzbot+9671693590ef5aad8953@syzkaller.appspotmail.com
>>>
>>> Tested on:
>>>
>>> commit:         bff2c168 io_uring: don't retry with truncated iter
>>> git tree:       https://github.com/isilence/linux.git truncate
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=730106bfb5bf8ace
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=9671693590ef5aad8953
>>> compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.1
>>>
>>> Note: testing is done by a robot and is best-effort only.
>>
>> As you can see in the 'dashboard link' above this bug also affects
>> android-5-10 which is currently based on v5.10.75.
>>
>> I see that the back-port of this patch failed in v5.10.y:
>>
>>    https://lore.kernel.org/stable/163152589512611@kroah.com/
>>
>> And after solving the build-error by back-porting both:
>>
>>    2112ff5ce0c11 iov_iter: track truncated size
>>    89c2b3b749182 io_uring: reexpand under-reexpanded iters
>>
>> I now see execution tripping the WARN() in iov_iter_revert():
>>
>>    if (WARN_ON(unroll > MAX_RW_COUNT))
>>        return
>>
>> Am I missing any additional patches required to fix stable/v5.10.y?
> 
> Is it the same syz test? There was a couple more patches for
> IORING_SETUP_IOPOLL, but strange if that's not the case.
> 
> 
> fwiw, Jens decided to replace it with another mechanism shortly
> after, so it may be a better idea to backport those. Jens,
> what do you think?
> 
> 
> commit 8fb0f47a9d7acf620d0fd97831b69da9bc5e22ed
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Fri Sep 10 11:18:36 2021 -0600
> 
>      iov_iter: add helper to save iov_iter state
> 
> commit cd65869512ab5668a5d16f789bc4da1319c435c4
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Fri Sep 10 11:19:14 2021 -0600
> 
>      io_uring: use iov_iter state save/restore helpers

Yes, I think backporting based on the save/restore setup is the
sanest way by far.

-- 
Jens Axboe

