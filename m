Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D36228863
	for <lists+io-uring@lfdr.de>; Tue, 21 Jul 2020 20:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgGUSjZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jul 2020 14:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbgGUSjY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jul 2020 14:39:24 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CAF0C0619DA
        for <io-uring@vger.kernel.org>; Tue, 21 Jul 2020 11:39:24 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id x72so11147435pfc.6
        for <io-uring@vger.kernel.org>; Tue, 21 Jul 2020 11:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j123tjao84sCawAECklrlDQrmh9RZ45cJHgg6B+xpl0=;
        b=ATkzng+r1uo35unLIfNtsPpb5eVV4wK+rzAbIw4RBkY1/0DgAAEui5Jqs4BStBgH7+
         lLdXZheX+n0+7S3Wx5a4UurMmGWkaipPXonBn7uKIBM72y/0A+xK2fnwQMmaX+YMiL2k
         B70pTM6kPUyYOx20xLI6eDr26aFfZ828JhTxLQeoLymNRlT2nedn3FFvgSFD9CzgFFJu
         iAWiBImbxYoSu7O0tiBBYEZq8nPJHl1+oWySWoVzhwALjloG6vmu3DIrpPdXmChbmt8o
         lxPzlKKdl0QN48RDg9WoqxhQZI/LSMVZKTNzZVwWrDyGBDDzghuKYDBJTbyTUdjtlZ++
         Nw8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j123tjao84sCawAECklrlDQrmh9RZ45cJHgg6B+xpl0=;
        b=phrkfvd+rvgXX0kkYzz+Q9XJ6uBIHb+GPPrhRNLC1WjO/bTWoz8UoqQKiwBvcP+wvG
         CZK78UBL9eJYOXiYadbctPRj5H2jMBY3doQsyJuObnCXrBPEMk1tHQqENUgYAMtqooom
         HM4LDMdx5/FTcDF+JP1kfpO3t3KRmY1KpTrhgo7VaMDjGpbHQLpX0HSapntgh17CQDcz
         2UPwy+WBHViVR0woqzLqe7EUnQ2HdfuBT6c0TCQ0KNn+TGGJ3Vd0iaoiJ/hcEySq62n4
         CbNoBw0VX3yrewvLMxlVFcemA8X4voTj3jhskeHagmZEssfX/Xry+rWm/ZdTIkiNhtaY
         114w==
X-Gm-Message-State: AOAM532ehPvL6QBbZkd5Z/trLOMJsHKxx+1OdLJgCa4tkCQZ98elRIIo
        SsD+Kf51un6r5zRyET1IhV3MLw==
X-Google-Smtp-Source: ABdhPJyBnwfPCvzBusrVoqeAxNvrnuMvSEMtSfjfg2ovoTL09gpc8FDkjGYAUUauWvRkQD37SlD9ZQ==
X-Received: by 2002:a63:f04d:: with SMTP id s13mr23251957pgj.100.1595356763477;
        Tue, 21 Jul 2020 11:39:23 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id m19sm18875012pgd.13.2020.07.21.11.39.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2020 11:39:22 -0700 (PDT)
Subject: Re: strace of io_uring events?
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Andres Freund <andres@anarazel.de>,
        Stefano Garzarella <sgarzare@redhat.com>,
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
 <ba989463-c627-8af7-9234-4dc8ac4eea0e@kernel.dk>
 <CALCETrUvOuKZWiQeZhf9DXyjS4OQdyW+s1YMh+vwe605jBS3LQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <65ad6c17-37d0-da30-4121-43554ad8f51f@kernel.dk>
Date:   Tue, 21 Jul 2020 12:39:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CALCETrUvOuKZWiQeZhf9DXyjS4OQdyW+s1YMh+vwe605jBS3LQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/21/20 11:44 AM, Andy Lutomirski wrote:
> On Tue, Jul 21, 2020 at 10:30 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 7/21/20 11:23 AM, Andy Lutomirski wrote:
>>> On Tue, Jul 21, 2020 at 8:31 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 7/21/20 9:27 AM, Andy Lutomirski wrote:
>>>>> On Fri, Jul 17, 2020 at 1:02 AM Stefano Garzarella <sgarzare@redhat.com> wrote:
>>>>>>
>>>>>> On Thu, Jul 16, 2020 at 08:12:35AM -0700, Kees Cook wrote:
>>>>>>> On Thu, Jul 16, 2020 at 03:14:04PM +0200, Stefano Garzarella wrote:
>>>>>
>>>>>>> access (IIUC) is possible without actually calling any of the io_uring
>>>>>>> syscalls. Is that correct? A process would receive an fd (via SCM_RIGHTS,
>>>>>>> pidfd_getfd, or soon seccomp addfd), and then call mmap() on it to gain
>>>>>>> access to the SQ and CQ, and off it goes? (The only glitch I see is
>>>>>>> waking up the worker thread?)
>>>>>>
>>>>>> It is true only if the io_uring istance is created with SQPOLL flag (not the
>>>>>> default behaviour and it requires CAP_SYS_ADMIN). In this case the
>>>>>> kthread is created and you can also set an higher idle time for it, so
>>>>>> also the waking up syscall can be avoided.
>>>>>
>>>>> I stared at the io_uring code for a while, and I'm wondering if we're
>>>>> approaching this the wrong way. It seems to me that most of the
>>>>> complications here come from the fact that io_uring SQEs don't clearly
>>>>> belong to any particular security principle.  (We have struct creds,
>>>>> but we don't really have a task or mm.)  But I'm also not convinced
>>>>> that io_uring actually supports cross-mm submission except by accident
>>>>> -- as it stands, unless a user is very careful to only submit SQEs
>>>>> that don't use user pointers, the results will be unpredictable.
>>>>
>>>> How so?
>>>
>>> Unless I've missed something, either current->mm or sqo_mm will be
>>> used depending on which thread ends up doing the IO.  (And there might
>>> be similar issues with threads.)  Having the user memory references
>>> end up somewhere that is an implementation detail seems suboptimal.
>>
>> current->mm is always used from the entering task - obviously if done
>> synchronously, but also if it needs to go async. The only exception is a
>> setup with SQPOLL, in which case ctx->sqo_mm is the task that set up the
>> ring. SQPOLL requires root privileges to setup, and there's no task
>> entering the io_uring at all necessarily. It'll just submit sqes with
>> the credentials that are registered with the ring.
> 
> Really?  I admit I haven't fully followed how the code works, but it
> looks like anything that goes through the io_queue_async_work() path
> will use sqo_mm, and can't most requests that end up blocking end up
> there?  It looks like, even if SQPOLL is not set, the mm used will
> depend on whether the request ends up blocking and thus getting queued
> for later completion.
> 
> Or does some magic I missed make this a nonissue.

No, you are wrong. The logic works as I described it.

>> This is just one known use case, there may very well be others. Outside
>> of SQPOLL, which is special, I don't see a reason to restrict this.
>> Given that you may have a fuller understanding of it after the above
>> explanation, please clearly state what problem you're seeing that
>> warrants a change.
> 
> I see two fundamental issues:
> 
> 1. The above.  This may be less of an issue than it seems to me, but,
> if you submit io from outside sqo_mm, the mm that ends up being used
> depends on whether the IO is completed from io_uring_enter() or from
> the workqueue.  For something like Postgres, I guess this is okay
> because the memory is MAP_ANONYMOUS | MAP_SHARED and the pointers all
> point the same place regardless.

No that is incorrect. If you disregard SQPOLL, then the 'mm' is always
who submitted it.

> 2. If you create an io_uring and io_uring_enter() it from a different
> mm, it's unclear what seccomp is supposed to do.  (Or audit, for that
> matter.)  Which task did the IO?  Which mm did the IO?  Whose sandbox
> is supposed to be applied?

Also doesn't seem like a problem, if you understand the 'mm' logic
above. Unless SQPOLL is used, the entering tasks mm will be used.
There's no mixing of tasks and mm outside of that.

-- 
Jens Axboe

