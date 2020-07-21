Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDF822875B
	for <lists+io-uring@lfdr.de>; Tue, 21 Jul 2020 19:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730099AbgGURax (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jul 2020 13:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728600AbgGURav (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jul 2020 13:30:51 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D5DC061794
        for <io-uring@vger.kernel.org>; Tue, 21 Jul 2020 10:30:51 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id l6so10547269plt.7
        for <io-uring@vger.kernel.org>; Tue, 21 Jul 2020 10:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FNQIJCVAC3yI/wr26dwokn0jJTFgNgY2vwaGhgZ5gaY=;
        b=PSAZpj+5RJKFTM7bx8Q/4LWFVdRFzFHHoTUfuS9SVVQCJ8H3AkyqANKbqBw6iOkMaj
         AmxER0sxZkxc7lGfntuLZTSSGZLcOHEKrfY0eZBrDuCSJi1XeSyiqUnaPmESbnGP27Sm
         fkMtFal2/RwqCcu4OrvPI/yJWTy94/H+qDzIRCU15+w0St2mG0/1qKVpqqAKzph1ZSLV
         pB0g2bIIiKQLnR2hu7gKtcVTwvrV+264yvuhXKOf21aQWVm3T/hEBYOjslzS5DTvwEZf
         QoF/7WPN/MkfRRlp78IC4Iln5eRqXgAq0K+HaIALve3ZS6EKjl6VX+kKWb1B6I37Owxw
         OR+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FNQIJCVAC3yI/wr26dwokn0jJTFgNgY2vwaGhgZ5gaY=;
        b=VdtiZpX+Vyo10/lDSeccsosdVMwJ7Ef9lpZYbpMkdLk3XwS1/zT17YkAsKPfbxdC4p
         Yk3qmheGPXRG72cjavtF/Gvkar9CBZUp6yfAgXBgj715/E8CZl2jUv3KEhBfqE2b83zB
         V5oyuscASSMMd/MLSvsLvdig/MCWz9SbT13BLX9+kyG4U8TqSoINQcm++Alr1UckG6O2
         0QPCA4mAyi/ifMKNKI2Tq6xhu1ZTLpJOfV6R3qCbZEQAylQmCafmdQCVDnj3tIiehmoq
         BORpl6ftN4YEUPBhpffkLLKXtmpuLJJ2Gpac4GCPoPd7NK75kYhGe87S47uQ0RXSYywT
         zApg==
X-Gm-Message-State: AOAM5322r5RxKqANfhj9JMUcNNo09sunjGndpMSvJcgGsXHsUMAnLXGJ
        JwTMu2ks2ICpiCt6hzm4p53d4w==
X-Google-Smtp-Source: ABdhPJzcj29KWKlxnYEdr/MPQipQ5RFeCFmVu/mUj60wPEXGtRzZ9kj+sYYx3h55pyqc99w7Oo33QA==
X-Received: by 2002:a17:902:7d8b:: with SMTP id a11mr22926231plm.72.1595352651200;
        Tue, 21 Jul 2020 10:30:51 -0700 (PDT)
Received: from ?IPv6:2600:380:7525:2b73:480a:82a8:5615:8a89? ([2600:380:7525:2b73:480a:82a8:5615:8a89])
        by smtp.gmail.com with ESMTPSA id c23sm20894196pfo.32.2020.07.21.10.30.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2020 10:30:50 -0700 (PDT)
Subject: Re: strace of io_uring events?
To:     Andy Lutomirski <luto@kernel.org>,
        Andres Freund <andres@anarazel.de>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Kees Cook <keescook@chromium.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Matthew Wilcox <willy@infradead.org>,
        Jann Horn <jannh@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        strace-devel@lists.strace.io, io-uring@vger.kernel.org,
        Linux API <linux-api@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
References: <CAJfpegu3EwbBFTSJiPhm7eMyTK2MzijLUp1gcboOo3meMF_+Qg@mail.gmail.com>
 <D9FAB37B-D059-4137-A115-616237D78640@amacapital.net>
 <20200715171130.GG12769@casper.infradead.org>
 <7c09f6af-653f-db3f-2378-02dca2bc07f7@gmail.com>
 <CAJfpegt9=p4uo5U2GXqc-rwqOESzZCWAkGMRTY1r8H6fuXx96g@mail.gmail.com>
 <48cc7eea-5b28-a584-a66c-4eed3fac5e76@gmail.com>
 <202007151511.2AA7718@keescook> <20200716131404.bnzsaarooumrp3kx@steredhat>
 <202007160751.ED56C55@keescook>
 <20200717080157.ezxapv7pscbqykhl@steredhat.lan>
 <CALCETrXSPdiVCgh3h=q7w9RyiKnp-=8jOHoFHX=an0cWqK7bzQ@mail.gmail.com>
 <39a3378a-f8f3-6706-98c8-be7017e64ddb@kernel.dk>
 <CALCETrXAxFzuRB5EJZR7bbgfrEcNc=9_E7wwhPaZ3YGJ1=DZ0w@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ba989463-c627-8af7-9234-4dc8ac4eea0e@kernel.dk>
Date:   Tue, 21 Jul 2020 11:30:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CALCETrXAxFzuRB5EJZR7bbgfrEcNc=9_E7wwhPaZ3YGJ1=DZ0w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/21/20 11:23 AM, Andy Lutomirski wrote:
> On Tue, Jul 21, 2020 at 8:31 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 7/21/20 9:27 AM, Andy Lutomirski wrote:
>>> On Fri, Jul 17, 2020 at 1:02 AM Stefano Garzarella <sgarzare@redhat.com> wrote:
>>>>
>>>> On Thu, Jul 16, 2020 at 08:12:35AM -0700, Kees Cook wrote:
>>>>> On Thu, Jul 16, 2020 at 03:14:04PM +0200, Stefano Garzarella wrote:
>>>
>>>>> access (IIUC) is possible without actually calling any of the io_uring
>>>>> syscalls. Is that correct? A process would receive an fd (via SCM_RIGHTS,
>>>>> pidfd_getfd, or soon seccomp addfd), and then call mmap() on it to gain
>>>>> access to the SQ and CQ, and off it goes? (The only glitch I see is
>>>>> waking up the worker thread?)
>>>>
>>>> It is true only if the io_uring istance is created with SQPOLL flag (not the
>>>> default behaviour and it requires CAP_SYS_ADMIN). In this case the
>>>> kthread is created and you can also set an higher idle time for it, so
>>>> also the waking up syscall can be avoided.
>>>
>>> I stared at the io_uring code for a while, and I'm wondering if we're
>>> approaching this the wrong way. It seems to me that most of the
>>> complications here come from the fact that io_uring SQEs don't clearly
>>> belong to any particular security principle.  (We have struct creds,
>>> but we don't really have a task or mm.)  But I'm also not convinced
>>> that io_uring actually supports cross-mm submission except by accident
>>> -- as it stands, unless a user is very careful to only submit SQEs
>>> that don't use user pointers, the results will be unpredictable.
>>
>> How so?
> 
> Unless I've missed something, either current->mm or sqo_mm will be
> used depending on which thread ends up doing the IO.  (And there might
> be similar issues with threads.)  Having the user memory references
> end up somewhere that is an implementation detail seems suboptimal.

current->mm is always used from the entering task - obviously if done
synchronously, but also if it needs to go async. The only exception is a
setup with SQPOLL, in which case ctx->sqo_mm is the task that set up the
ring. SQPOLL requires root privileges to setup, and there's no task
entering the io_uring at all necessarily. It'll just submit sqes with
the credentials that are registered with the ring.

>>> Perhaps we can get away with this:
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 74bc4a04befa..92266f869174 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -7660,6 +7660,20 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int,
>>> fd, u32, to_submit,
>>>      if (!percpu_ref_tryget(&ctx->refs))
>>>          goto out_fput;
>>>
>>> +    if (unlikely(current->mm != ctx->sqo_mm)) {
>>> +        /*
>>> +         * The mm used to process SQEs will be current->mm or
>>> +         * ctx->sqo_mm depending on which submission path is used.
>>> +         * It's also unclear who is responsible for an SQE submitted
>>> +         * out-of-process from a security and auditing perspective.
>>> +         *
>>> +         * Until a real usecase emerges and there are clear semantics
>>> +         * for out-of-process submission, disallow it.
>>> +         */
>>> +        ret = -EACCES;
>>> +        goto out;
>>> +    }
>>> +
>>>      /*
>>>       * For SQ polling, the thread will do all submissions and completions.
>>>       * Just return the requested submit count, and wake the thread if
>>
>> That'll break postgres that already uses this, also see:
>>
>> commit 73e08e711d9c1d79fae01daed4b0e1fee5f8a275
>> Author: Jens Axboe <axboe@kernel.dk>
>> Date:   Sun Jan 26 09:53:12 2020 -0700
>>
>>     Revert "io_uring: only allow submit from owning task"
>>
>> So no, we can't do that.
>>
> 
> Yikes, I missed that.
> 
> Andres, how final is your Postgres branch?  I'm wondering if we could
> get away with requiring a special flag when creating an io_uring to
> indicate that you intend to submit IO from outside the creating mm.
> 
> Even if we can't make this change, we could plausibly get away with
> tying seccomp-style filtering to sqo_mm.  IOW we'd look up a
> hypothetical sqo_mm->io_uring_filters to filter SQEs even when
> submitted from a different mm.

This is just one known use case, there may very well be others. Outside
of SQPOLL, which is special, I don't see a reason to restrict this.
Given that you may have a fuller understanding of it after the above
explanation, please clearly state what problem you're seeing that
warrants a change.

-- 
Jens Axboe

