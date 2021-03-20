Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 783A734301B
	for <lists+io-uring@lfdr.de>; Sat, 20 Mar 2021 23:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbhCTWmZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Mar 2021 18:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbhCTWmM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Mar 2021 18:42:12 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19089C061762
        for <io-uring@vger.kernel.org>; Sat, 20 Mar 2021 15:42:12 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so8482346pjh.1
        for <io-uring@vger.kernel.org>; Sat, 20 Mar 2021 15:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CP6XWAgVpuegbTUMFWEzWCVzLKWLQ4kM5wh2fwuAa3k=;
        b=QCoTt0q8o50hCJ8UjJQemjoANIbbaJDpuwoPqbATB6EIz/Pc1vN3X3dOSSwWRYMSrc
         7cmtlIO7o/9ZmKite6RZZc4mmsKvit/GK4IFTFH4gZ623/ccyPh389sYimYUUWVpHsHG
         AwgQu2we0zKfZXoNLiqsJlAZqIzTTIc2c5QdNsk7SiD8ugQjuiFpUWKr3s7VegBr5X1A
         ktzseNUXTTtGnCN21Ai41CmbWirMAGVSK45KLItke2XKfLxCNi+w9kQwM01NmsRv4Vgx
         z5oJ3HJteK0zPWM6lQrgkWy8g2TOMDagQQ5YtNa1Q0uJuFt13UQkkaIhCU7PsfHrm1cG
         pPzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CP6XWAgVpuegbTUMFWEzWCVzLKWLQ4kM5wh2fwuAa3k=;
        b=HxIebIVCEHcn4B5j6DpSLhKeepg2J8jczg97srYwd9CrGiOlK0Ey8O46GcAHqzbFAl
         Ifc5KpOpGI/UBux2tu8OUisSvokLcxcMGmGbsPdLlKZPQCrgwCJGB92zl3ckAIKB57Eo
         Gdok/RiBgxkSvZR+7kX5glwZAvAgAAuyZ3XvVtruno08TIS0nFtGUDRceYwU2Ad7AWvk
         C3ZRRrtloc7O31NWjQPtkon4p5PHAmIk1ihb0C8h3qpTqlTGJjLWiNrV9sRLtr6AVZYh
         85xV9HUd9uW2AuY9iMkAXxfkONh7Zo4PfxJwGT58J4RtjJdoc/vGr7Tj6Os0Ot7Sj2l5
         KPVg==
X-Gm-Message-State: AOAM533MjTnFGdaazLDvX/TrIBgp7llU8bX1AGH5EcAbnwmK+xPmQ2E3
        yLfxaHL1bvNGAMTWsfrzMOso7Q==
X-Google-Smtp-Source: ABdhPJx0He7mkEzKdzieiot3buPG3NUDE5uB5sDIpiCJP0xJE8B/hnR/XxQxOQl9Z8opYTIIdHRlkA==
X-Received: by 2002:a17:90a:5898:: with SMTP id j24mr5336476pji.110.1616280131349;
        Sat, 20 Mar 2021 15:42:11 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id b9sm8679749pgn.42.2021.03.20.15.42.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Mar 2021 15:42:10 -0700 (PDT)
Subject: Re: [PATCH 1/2] signal: don't allow sending any signals to
 PF_IO_WORKER threads
To:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Stefan Metzmacher <metze@samba.org>
References: <20210320153832.1033687-1-axboe@kernel.dk>
 <20210320153832.1033687-2-axboe@kernel.dk> <m1eeg9bxyi.fsf@fess.ebiederm.org>
 <CAHk-=wjLMy+J20ZSBec4iarw2NeSu5sWXm6wdMH59n-e0Qe06g@mail.gmail.com>
 <m1czvt8q0r.fsf@fess.ebiederm.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <43f05d70-11a9-d59a-1eac-29adc8c53894@kernel.dk>
Date:   Sat, 20 Mar 2021 16:42:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <m1czvt8q0r.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/20/21 3:38 PM, Eric W. Biederman wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
> 
>> On Sat, Mar 20, 2021 at 9:19 AM Eric W. Biederman <ebiederm@xmission.com> wrote:
>>>
>>> The creds should be reasonably in-sync with the rest of the threads.
>>
>> It's not about credentials (despite the -EPERM).
>>
>> It's about the fact that kernel threads cannot handle signals, and
>> then get caught in endless loops of "if (sigpending()) return
>> -EAGAIN".
>>
>> For a normal user thread, that "return -EAGAIN" (or whatever) will end
>> up returning an error to user space - and before it does that, it will
>> go through the "oh, returning to user space, so handle signal" path.
>> Which will clear sigpending etc.
>>
>> A thread that never returns to user space fundamentally cannot handle
>> this. The sigpending() stays on forever, the signal never gets
>> handled, the thread can't do anything.
>>
>> So delivering a signal to a kernel thread fundamentally cannot work
>> (although we do have some threads that explicitly see "oh, if I was
>> killed, I will exit" - think things like in-kernel nfsd etc).
> 
> I agree that getting a kernel thread to receive a signal is quite
> tricky.  But that is not what the patch affects.
> 
> The patch covers the case when instead of specifying the pid of the
> process to kill(2) someone specifies the tid of a thread.  Which implies
> that type is PIDTYPE_TGID, and in turn the signal is being placed on the
> t->signal->shared_pending queue.  Not the thread specific t->pending
> queue.
> 
> So my question is since the signal is delivered to the process as a
> whole why do we care if someone specifies the tid of a kernel thread,
> rather than the tid of a userspace thread?

Right, that's what this first patch does, and in all honesty, it's not
required like the 2/2 patch is. I do think it makes it more consistent,
though - the threads don't take signals, period. Allowing delivery from
eg kill(2) and then pass it to the owning task of the io_uring is
somewhat counterintuitive, and differs from earlier kernels where there
was no relationsship between that owning task and the async worker
thread.

That's why I think the patch DOES make sense. These threads may share a
personality with the owning task, but I don't think we should be able to
manipulate them from userspace at all. That includes SIGSTOP, of course,
but also regular signals.

Hence I do think we should do something like this.

-- 
Jens Axboe

