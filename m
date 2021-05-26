Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F459392180
	for <lists+io-uring@lfdr.de>; Wed, 26 May 2021 22:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbhEZUdH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 May 2021 16:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbhEZUdG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 May 2021 16:33:06 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88FFC061574;
        Wed, 26 May 2021 13:31:30 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id r12so2466809wrp.1;
        Wed, 26 May 2021 13:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:references:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cjX8sees6Hr6nm/jvfGu7kvMMVE0uao6tIcZ4xenbrs=;
        b=bpx9cKfSC4PRUxTewR7k4PbQekER2MvLpiW07SGz+TL0+kGeoLQKwL7aDvVpUQ+EDV
         DmObvHwfPJERo3u99jEHOM4SL0S9sUJkgYNdjVkowqNPCdKIXtskbQaEBl5CPZmYWDy3
         wuvdL4Ue3CnKKlIUxDIp1SpET9nrOAMmlLwjd/raxN0GODMhrl0QSVB6YBn/OGmi2Vsd
         0fZVRz2R1rtbGVp5K9QLdQDpxDsX5wpbtG++4Z1o14JvC6njskYsxFaOwqD217ByNglH
         Ny9Lt/LP7336CneF+p0PaEfvJrnkxwy3kz2+CGNW469CjUZZfUeAz1FnPCNy7RXvwQCW
         5YPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cjX8sees6Hr6nm/jvfGu7kvMMVE0uao6tIcZ4xenbrs=;
        b=SPb6qtcqDQocdkXmQHndaFKhFFWwvDAe0sUxJwGc/ViRIrqtzTolj4M4wE4+vlH3r2
         Vf1P8S6WkRl+wWV1/6fw6dccjwwNOSofXTfCuTNEQXHFLmi0XBm0/Qzdd0bgHNsFBazN
         HsziFanIeDO6N3YLAfu7eiUCxOMJZrWbKVv3CuW/sEP4cT1XZbmr3rFqYGYGlUsHJhzc
         kRlRSWq58sDezn/5Xw9GmjNrP9zYW+tgUI23ui5sdg1pabFrCQWj7TmizYDchKTj9szy
         4aSu1HIyw/CvUcszhabbECUtLkzS8zxKVpVgiZXqeOi3pR4L4Fva0M+CespZMSPCEvE2
         8BoQ==
X-Gm-Message-State: AOAM5330FoViiCj1MOCIxEwIkUw7eSZRJaR4kLaYLAlLnQ1oz/Fjf0xk
        RVGqo3325HHwYtb7Epj7UOc=
X-Google-Smtp-Source: ABdhPJy2e885zIwfZiu/bsp6LU3fuEXb9ew4HbB7SB6aBjc49+OHlS/71524ZRiLVxVpUJptfztp/A==
X-Received: by 2002:a05:6000:104a:: with SMTP id c10mr34780464wrx.45.1622061089518;
        Wed, 26 May 2021 13:31:29 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.236.10])
        by smtp.gmail.com with ESMTPSA id y20sm8795463wmi.0.2021.05.26.13.31.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 13:31:28 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
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
Subject: Re: [syzbot] KCSAN: data-race in __io_uring_cancel /
 io_uring_try_cancel_requests
Message-ID: <5cf2250a-c580-4dbf-5997-e987c7b71086@gmail.com>
Date:   Wed, 26 May 2021 21:31:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CANpmjNP1CKuoK82HCRYpDxDrvy4DgN9yVknfsxHSwfojx5Ttug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/26/21 5:36 PM, Marco Elver wrote:
> On Wed, 26 May 2021 at 18:29, Pavel Begunkov <asml.silence@gmail.com> wrote:
>> On 5/26/21 4:52 PM, Marco Elver wrote:
>>> Due to some moving around of code, the patch lost the actual fix (using
>>> atomically read io_wq) -- so here it is again ... hopefully as intended.
>>> :-)
>>
>> "fortify" damn it... It was synchronised with &ctx->uring_lock
>> before, see io_uring_try_cancel_iowq() and io_uring_del_tctx_node(),
>> so should not clear before *del_tctx_node()
> 
> Ah, so if I understand right, the property stated by the comment in
> io_uring_try_cancel_iowq() was broken, and your patch below would fix
> that, right?

"io_uring: fortify tctx/io_wq cleanup" broke it and the diff
should fix it.

>> The fix should just move it after this sync point. Will you send
>> it out as a patch?
> 
> Do you mean your move of write to io_wq goes on top of the patch I
> proposed? (If so, please also leave your Signed-of-by so I can squash
> it.)

No, only my diff, but you hinted on what has happened, so I would
prefer you to take care of patching. If you want of course.

To be entirely fair, assuming that aligned ptr
reads can't be torn, I don't see any _real_ problem. But surely
the report is very helpful and the current state is too wonky, so
should be patched.

TL;DR;
The synchronisation goes as this: it's usually used by the owner
task, and the owner task deletes it, so is mostly naturally
synchronised. An exception is a worker (not only) that accesses
it for cancellation purpose, but it uses it only under ->uring_lock,
so if removal is also taking the lock it should be fine. see
io_uring_del_tctx_node() locking.

> 
> So if I understand right, we do in fact have 2 problems:
> 1. the data race as I noted in my patch, and

Yes, and it deals with it

> 2. the fact that io_wq does not live long enough.

Nope, io_wq outlives them fine. 

> Did I get it right?
> 
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 7db6aaf31080..b76ba26b4c6c 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -9075,11 +9075,12 @@ static void io_uring_clean_tctx(struct io_uring_task *tctx)
>>         struct io_tctx_node *node;
>>         unsigned long index;
>>
>> -       tctx->io_wq = NULL;
>>         xa_for_each(&tctx->xa, index, node)
>>                 io_uring_del_tctx_node(index);
>> -       if (wq)
>> +       if (wq) {
>> +               tctx->io_wq = NULL;
>>                 io_wq_put_and_exit(wq);
>> +       }
>>  }
>>
>>  static s64 tctx_inflight(struct io_uring_task *tctx, bool tracked)

-- 
Pavel Begunkov


