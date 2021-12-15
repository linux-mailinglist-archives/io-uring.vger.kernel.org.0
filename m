Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1F59475794
	for <lists+io-uring@lfdr.de>; Wed, 15 Dec 2021 12:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhLOLQM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Dec 2021 06:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbhLOLQM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Dec 2021 06:16:12 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0511EC061574;
        Wed, 15 Dec 2021 03:16:12 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id y12so72529402eda.12;
        Wed, 15 Dec 2021 03:16:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9qaklPVKFzvTFgZTwuUrIQAjTcRyeM4Eo39SaoXC8Ks=;
        b=PrZ9I+Yi/ltjeuqWP2Xmj/qgv10jr/j0pgi+Cq/gqCTXMolGJb+WZJMs97TF0WnLsP
         c7002xlHIUOuIy6FqQ2nIuu8pjPleYRXk+fuEh11Ixxeap6qPVoz+RFYDVHIvUBl6urb
         n1SpU2UTDAPH8E0jqQcMG/b4+qd42PCQhJD1w9WxA/1HHs8sgfga00zlaf0ymshGngAu
         sCoy0Q6mpsHlaA3FNkfvBzeecdc9bORQDH30wWzSXXjXD0ZZ7Oa03Mrw0cwiRUaqgIbF
         Pt8qe0CzNsP8Fw/GI5uSm9MIa1SSO+V01A1M9niPt/A89sAG6RZO7Xk9YuHCUkXnaZur
         Xvow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9qaklPVKFzvTFgZTwuUrIQAjTcRyeM4Eo39SaoXC8Ks=;
        b=fggKMxRM3KPQlNWc6bF80K769K8pA2VwQpgdqQ7yUxJfQ5u4SXCXaBmQ6OcJE0K+vq
         vkgJhGp2pxMiMJrVn2E9UYX2e6Z1O6yuJ0E08AgMPX1l3fynYFFi2w4x0529a7JJiX9O
         lXRqpR830FwY1cPhQxy8lpRPIK5CnUqq7aGeSavt37vjobJbK89aU8naH2tRvB47h7xr
         y61xInvq3sG9k4c0RQv4BPEpoUROUwMU3IlXQRB6xVRjYqk4tgWhcaqVCVTk6J9A4gIg
         vqjCsZHVOs46MdtZb1ha2XyS6Pb0pVEspGbpFGhE+nP6YPqHS6fHsPqw35DUFXzXO4v1
         6OxQ==
X-Gm-Message-State: AOAM530oYS0xtZVcNR2V9LH1sUg9jQmUt4spfqpjp2ohCcafS/vKDdP0
        3Mn+YnA5IR/QynryeeX1Hlo=
X-Google-Smtp-Source: ABdhPJwqQB0kXP0SuRef0ikzosU/2sL77tTg3xJCLEjTacehJDcWY6RBmtiFtxzNhyAqAfaZFi42Pg==
X-Received: by 2002:a17:907:7242:: with SMTP id ds2mr10127804ejc.269.1639566970599;
        Wed, 15 Dec 2021 03:16:10 -0800 (PST)
Received: from [192.168.8.198] ([148.252.129.75])
        by smtp.gmail.com with ESMTPSA id sd2sm611503ejc.22.2021.12.15.03.16.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 03:16:10 -0800 (PST)
Message-ID: <c7131961-23de-8bf4-7773-efffe9b8d294@gmail.com>
Date:   Wed, 15 Dec 2021 11:16:04 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [syzbot] KASAN: stack-out-of-bounds Read in iov_iter_revert
Content-Language: en-US
To:     Lee Jones <lee.jones@linaro.org>, Jens Axboe <axboe@kernel.dk>
Cc:     syzbot <syzbot+9671693590ef5aad8953@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <6f7d4c1d-f923-3ab1-c525-45316b973c72@gmail.com>
 <00000000000047f3b805c962affb@google.com> <YYLAYvFU+9cnu+4H@google.com>
 <0b4a5ff8-12e5-3cc7-8971-49e576444c9a@gmail.com>
 <dd122760-5f87-10b1-e50d-388c2631c01a@kernel.dk>
 <YYp4rC4M/oh8fgr7@google.com> <YbmiIpQKfrLClsKV@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <YbmiIpQKfrLClsKV@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/15/21 08:06, Lee Jones wrote:
> On Tue, 09 Nov 2021, Lee Jones wrote:
> 
>> On Mon, 08 Nov 2021, Jens Axboe wrote:
>>> On 11/8/21 8:29 AM, Pavel Begunkov wrote:
>>>> On 11/3/21 17:01, Lee Jones wrote:
>>>>> Good afternoon Pavel,
>>>>>
>>>>>> syzbot has tested the proposed patch and the reproducer did not trigger any issue:
>>>>>>
>>>>>> Reported-and-tested-by: syzbot+9671693590ef5aad8953@syzkaller.appspotmail.com
>>>>>>
>>>>>> Tested on:
>>>>>>
>>>>>> commit:         bff2c168 io_uring: don't retry with truncated iter
>>>>>> git tree:       https://github.com/isilence/linux.git truncate
>>>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=730106bfb5bf8ace
>>>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=9671693590ef5aad8953
>>>>>> compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.1
>>>>>>
>>>>>> Note: testing is done by a robot and is best-effort only.
>>>>>
>>>>> As you can see in the 'dashboard link' above this bug also affects
>>>>> android-5-10 which is currently based on v5.10.75.
>>>>>
>>>>> I see that the back-port of this patch failed in v5.10.y:
>>>>>
>>>>>     https://lore.kernel.org/stable/163152589512611@kroah.com/
>>>>>
>>>>> And after solving the build-error by back-porting both:
>>>>>
>>>>>     2112ff5ce0c11 iov_iter: track truncated size
>>>>>     89c2b3b749182 io_uring: reexpand under-reexpanded iters
>>>>>
>>>>> I now see execution tripping the WARN() in iov_iter_revert():
>>>>>
>>>>>     if (WARN_ON(unroll > MAX_RW_COUNT))
>>>>>         return
>>>>>
>>>>> Am I missing any additional patches required to fix stable/v5.10.y?
>>>>
>>>> Is it the same syz test? There was a couple more patches for
>>>> IORING_SETUP_IOPOLL, but strange if that's not the case.
>>>>
>>>>
>>>> fwiw, Jens decided to replace it with another mechanism shortly
>>>> after, so it may be a better idea to backport those. Jens,
>>>> what do you think?
>>>>
>>>>
>>>> commit 8fb0f47a9d7acf620d0fd97831b69da9bc5e22ed
>>>> Author: Jens Axboe <axboe@kernel.dk>
>>>> Date:   Fri Sep 10 11:18:36 2021 -0600
>>>>
>>>>       iov_iter: add helper to save iov_iter state
>>>>
>>>> commit cd65869512ab5668a5d16f789bc4da1319c435c4
>>>> Author: Jens Axboe <axboe@kernel.dk>
>>>> Date:   Fri Sep 10 11:19:14 2021 -0600
>>>>
>>>>       io_uring: use iov_iter state save/restore helpers
>>>
>>> Yes, I think backporting based on the save/restore setup is the
>>> sanest way by far.
>>
>> Would you be kind enough to attempt to send these patches to Stable?
>>
>> When I tried to back-port them, the second one gave me trouble.  And
>> without the in depth knowledge of the driver/subsystem that you guys
>> have, I found it almost impossible to resolve all of the conflicts:
> 
> Any movement on this chaps?
> 
> Not sure I am able to do this back-port without your help.

Apologies, slipped from my attention, we'll backport it,
and thanks for the reminder


-- 
Pavel Begunkov
