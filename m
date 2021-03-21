Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB8C34333D
	for <lists+io-uring@lfdr.de>; Sun, 21 Mar 2021 16:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbhCUPkZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Mar 2021 11:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbhCUPkO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Mar 2021 11:40:14 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B403C061574
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 08:40:14 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id n11so6995360pgm.12
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 08:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cSj4LvG+PL+eupZk/yxZhhmPk+3KBEqBV8K2BbUolG4=;
        b=KYshwrcu3AyE3tNU4VO8dcqQojtWeMPb4f1BV/G+muf9WUX/BBUc/WBs/zG+9qwRu4
         GxNpXPABZollLWQhsEQ0w/ybfytvsF1bMtyWabM8Z5Pd9WDrUk5bi+13rbFxRQkBnqQr
         qA9fB+TJNvHjDrPXapVqic7qESbZqW4HyEldw3qpptYvZYEvubUmVyHx3MycWTGxVVjY
         iCUpYPxbKrmilIv8ITWPSVItyMj8FOMPEo0/oGKpbhanWTH1xYWvlZ5Mr2BpIoe85/GJ
         xXRVFrkTO5+hzFZW484IdZjD92tbkcjoCjjEpASwmz3AAfW0x035Mvk3GGPDxK6QhOQG
         ZYCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cSj4LvG+PL+eupZk/yxZhhmPk+3KBEqBV8K2BbUolG4=;
        b=I7DUVmrXeHosY14BvWywrKqOcDy/2JYL6iQ+N6hn4VGrmiVJYqzuGjUoGV5/oKjf+W
         bmwGHst9ZyuYH/fwGtN2Eg4SLozyFFBFQ61g6MWvsp9EPcE8vNYptCIiQeNG+xg8uTGL
         zAUWFoXhV8+YYKB6ysjht4Gd7h1Tl54DmmeZBq/5iEGpyQruBhOPX0kLBWge2dDy5lMy
         v99vQXtQGLrvuzJwV/BwbrQQJzPrS+FEMql2ESvzL4hXmHKgq9/+LteEQ86BXyfAIbFH
         F95YvdqMXL1541BI8MLotgRYAOWmuyAW+x3Z/kFZaUJapNB7HsNhHlEHoZbTs0ht7r3D
         mKRg==
X-Gm-Message-State: AOAM532VNsBEd/f71XK5gYaFJTOcsWRQtyIhDD7/pDL2MMgSD8SAAPdf
        EyxH5sjFhjegSYaoLKwMHo2syIAaonH5jA==
X-Google-Smtp-Source: ABdhPJzkEljh7QTeleWw+cpe++zUJ3kSw3VX50bIm/uaYYsI7lE2HHrje0z7cXDC6hmhZKjU4u9KXw==
X-Received: by 2002:a05:6a00:138e:b029:204:422e:a87e with SMTP id t14-20020a056a00138eb0290204422ea87emr17837504pfg.24.1616341213914;
        Sun, 21 Mar 2021 08:40:13 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j92sm11120505pja.29.2021.03.21.08.40.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Mar 2021 08:40:13 -0700 (PDT)
Subject: Re: [PATCH 1/2] signal: don't allow sending any signals to
 PF_IO_WORKER threads
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Stefan Metzmacher <metze@samba.org>
References: <20210320153832.1033687-1-axboe@kernel.dk>
 <20210320153832.1033687-2-axboe@kernel.dk> <m1eeg9bxyi.fsf@fess.ebiederm.org>
 <CAHk-=wjLMy+J20ZSBec4iarw2NeSu5sWXm6wdMH59n-e0Qe06g@mail.gmail.com>
 <m1czvt8q0r.fsf@fess.ebiederm.org>
 <43f05d70-11a9-d59a-1eac-29adc8c53894@kernel.dk>
 <m18s6g5zhz.fsf@fess.ebiederm.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c95750c6-5e91-6c3a-550a-515eab5716eb@kernel.dk>
Date:   Sun, 21 Mar 2021 09:40:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <m18s6g5zhz.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/21/21 8:54 AM, Eric W. Biederman wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 3/20/21 3:38 PM, Eric W. Biederman wrote:
>>> Linus Torvalds <torvalds@linux-foundation.org> writes:
>>>
>>>> On Sat, Mar 20, 2021 at 9:19 AM Eric W. Biederman <ebiederm@xmission.com> wrote:
>>>>>
>>>>> The creds should be reasonably in-sync with the rest of the threads.
>>>>
>>>> It's not about credentials (despite the -EPERM).
>>>>
>>>> It's about the fact that kernel threads cannot handle signals, and
>>>> then get caught in endless loops of "if (sigpending()) return
>>>> -EAGAIN".
>>>>
>>>> For a normal user thread, that "return -EAGAIN" (or whatever) will end
>>>> up returning an error to user space - and before it does that, it will
>>>> go through the "oh, returning to user space, so handle signal" path.
>>>> Which will clear sigpending etc.
>>>>
>>>> A thread that never returns to user space fundamentally cannot handle
>>>> this. The sigpending() stays on forever, the signal never gets
>>>> handled, the thread can't do anything.
>>>>
>>>> So delivering a signal to a kernel thread fundamentally cannot work
>>>> (although we do have some threads that explicitly see "oh, if I was
>>>> killed, I will exit" - think things like in-kernel nfsd etc).
>>>
>>> I agree that getting a kernel thread to receive a signal is quite
>>> tricky.  But that is not what the patch affects.
>>>
>>> The patch covers the case when instead of specifying the pid of the
>>> process to kill(2) someone specifies the tid of a thread.  Which implies
>>> that type is PIDTYPE_TGID, and in turn the signal is being placed on the
>>> t->signal->shared_pending queue.  Not the thread specific t->pending
>>> queue.
>>>
>>> So my question is since the signal is delivered to the process as a
>>> whole why do we care if someone specifies the tid of a kernel thread,
>>> rather than the tid of a userspace thread?
>>
>> Right, that's what this first patch does, and in all honesty, it's not
>> required like the 2/2 patch is. I do think it makes it more consistent,
>> though - the threads don't take signals, period. Allowing delivery from
>> eg kill(2) and then pass it to the owning task of the io_uring is
>> somewhat counterintuitive, and differs from earlier kernels where there
>> was no relationsship between that owning task and the async worker
>> thread.
>>
>> That's why I think the patch DOES make sense. These threads may share a
>> personality with the owning task, but I don't think we should be able to
>> manipulate them from userspace at all. That includes SIGSTOP, of course,
>> but also regular signals.
>>
>> Hence I do think we should do something like this.
> 
> I agree about signals.  Especially because being able to use kill(2)
> with the tid of thread is a linuxism and a backwards compatibility thing
> from before we had CLONE_THREAD.
> 
> I think for kill(2) we should just return -ESRCH.
> 
> Thank you for providing the reasoning that is what I really saw missing
> in the patches.  The why.  And software is difficult to maintain without
> the why.

Thanks Eric, I'll change that patch to -ESRCH and augment the commit
message a bit.

-- 
Jens Axboe

