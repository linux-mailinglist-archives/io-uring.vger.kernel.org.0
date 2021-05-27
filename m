Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8101D392B6A
	for <lists+io-uring@lfdr.de>; Thu, 27 May 2021 12:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235913AbhE0KH0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 May 2021 06:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235768AbhE0KHZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 May 2021 06:07:25 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F24C061574;
        Thu, 27 May 2021 03:05:52 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id j9so177496edt.6;
        Thu, 27 May 2021 03:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HX+kpA5gMZQ5BR/1NSzuMycFlWy7P9N8A5R/UBbt+0k=;
        b=fNneRmLCPqS8cuKTTrYn2VmM/n3IR2EBZ3vcVapqtfM7C1ezAVmp0WBJ4uDbwC8YF7
         3DA48gUvv2ixZTv8Y4IuXEpJygAj9y0UsUny/EeIeVsfLkzLhZNUns4zdlohfyhBKIQ3
         pAIpzXc5sOoGhKHCcv7CeRmyItM5ZpBiqlETkNdWVIwMQW0caGaE83KiAV1/KQOMFYiB
         8DZ5ew7HOsVtgCNqmYYD8Sy6KEOPRaZH/3FKlpISLIuEcBB1Ew8F5bEsYPlVDVPP1UJy
         EsLeiTU8nUNWbE4Zfn2CB3asyUQPuO25i0PB39cQODAGfGVTYmmg5perpinwZfDmfJWC
         gNEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HX+kpA5gMZQ5BR/1NSzuMycFlWy7P9N8A5R/UBbt+0k=;
        b=Ha85uauLfz18zckK1aBo1Y8c6qhKxUSJoSiDmviyULX2h8s4qtqUjuKYHuOe5l7E8x
         O1qtSKLDzil9ubsu9jxG8eseHDw94fKXA69SDTpuoq9IlTbV++AbCreVBxwiuE3bPWwm
         RtbUCR3bpIkC7pMD/KIaThySZzo4954cqAFAuVdUESY9w/g3b6Qcz/VT555RP7aeO3NX
         A9PLRDi1wv0lv+2pp+ZFBbphUOkmFly4yNvIfLAU9zf6/0bDb82R4uj+fsiyETzwdUur
         9/RFFHuCW4MTyawzhYLZzBypq1caXnm/iKJ7qUE0HDd+iZ9qySPAfNbgi672AiGJvBMp
         LVMA==
X-Gm-Message-State: AOAM530bL4WFevdqsZiPUY2I7cpb+n0M3wUODx765Vb3yHMSXpMEk/h9
        y4ZkEZOB1+AoAuoG0hKQFGE+IyPUNzDOFA==
X-Google-Smtp-Source: ABdhPJysG91NzmXlFzQDZAckH9VcWIRO7LyY4xWMGr4ASkfvBQ3TRvi1RcdI10JfaX2fjs/qAPbQtg==
X-Received: by 2002:a05:6402:1601:: with SMTP id f1mr3188675edv.383.1622109951561;
        Thu, 27 May 2021 03:05:51 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2090? ([2620:10d:c093:600::2:9bd8])
        by smtp.gmail.com with ESMTPSA id i19sm829036eds.65.2021.05.27.03.05.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 03:05:51 -0700 (PDT)
Subject: Re: [syzbot] KCSAN: data-race in __io_uring_cancel /
 io_uring_try_cancel_requests
To:     Marco Elver <elver@google.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot <syzbot+73554e2258b7b8bf0bbf@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Dmitry Vyukov <dvyukov@google.com>
References: <000000000000fa9f7005c33d83b9@google.com>
 <YK5tyZNAFc8dh6ke@elver.google.com> <YK5uygiCGlmgQLKE@elver.google.com>
 <b5cff8b6-bd9c-9cbe-4f5f-52552d19ca48@gmail.com>
 <CANpmjNP1CKuoK82HCRYpDxDrvy4DgN9yVknfsxHSwfojx5Ttug@mail.gmail.com>
 <5cf2250a-c580-4dbf-5997-e987c7b71086@gmail.com>
 <YK9nMgamPsr9YsoY@elver.google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <3dac0367-5a42-fdc5-f103-b508a692d130@gmail.com>
Date:   Thu, 27 May 2021 11:05:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YK9nMgamPsr9YsoY@elver.google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/27/21 10:32 AM, Marco Elver wrote:
> On Wed, May 26, 2021 at 09:31PM +0100, Pavel Begunkov wrote:
>> On 5/26/21 5:36 PM, Marco Elver wrote:
>>> On Wed, 26 May 2021 at 18:29, Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>> On 5/26/21 4:52 PM, Marco Elver wrote:
>>>>> Due to some moving around of code, the patch lost the actual fix (using
>>>>> atomically read io_wq) -- so here it is again ... hopefully as intended.
>>>>> :-)
>>>>
>>>> "fortify" damn it... It was synchronised with &ctx->uring_lock
>>>> before, see io_uring_try_cancel_iowq() and io_uring_del_tctx_node(),
>>>> so should not clear before *del_tctx_node()
>>>
>>> Ah, so if I understand right, the property stated by the comment in
>>> io_uring_try_cancel_iowq() was broken, and your patch below would fix
>>> that, right?
>>
>> "io_uring: fortify tctx/io_wq cleanup" broke it and the diff
>> should fix it.
>>
>>>> The fix should just move it after this sync point. Will you send
>>>> it out as a patch?
>>>
>>> Do you mean your move of write to io_wq goes on top of the patch I
>>> proposed? (If so, please also leave your Signed-of-by so I can squash
>>> it.)
>>
>> No, only my diff, but you hinted on what has happened, so I would
>> prefer you to take care of patching. If you want of course.
>>
>> To be entirely fair, assuming that aligned ptr
>> reads can't be torn, I don't see any _real_ problem. But surely
>> the report is very helpful and the current state is too wonky, so
>> should be patched.
> 
> In the current version, it is a problem if we end up with a double-read,
> as it is in the current C code. The compiler might of course optimize
> it into 1 read into a register.

Absolutely agree on that

> Tangent: I avoid reasoning in terms of compiler optimizations where
> I can. :-) It's is a slippery slope if the code in question isn't
> tolerant to data races by design (examples are stats counting, or other
> heuristics -- in the case here that's certainly not the case).
> Therefore, my wish is that we really ought to resolve as many data races
> as we can (+ mark intentional ones appropriately). Also, so that we're
> left with only the interesting cases like in the case here.  (More
> background if you're interested: https://lwn.net/Articles/816850/)
> 
> The problem here, however, has a nicer resolution as you suggested.
> 
>> TL;DR;
>> The synchronisation goes as this: it's usually used by the owner
>> task, and the owner task deletes it, so is mostly naturally
>> synchronised. An exception is a worker (not only) that accesses
>> it for cancellation purpose, but it uses it only under ->uring_lock,
>> so if removal is also taking the lock it should be fine. see
>> io_uring_del_tctx_node() locking.
> 
> Did you mean io_uring_del_task_file()? There is no
> io_uring_del_tctx_node().

Ah, yes, that's from patches I sent for next.

-- 
Pavel Begunkov
