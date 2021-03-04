Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACCDD32DA3E
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 20:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233617AbhCDTTr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 14:19:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232942AbhCDTTm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 14:19:42 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C540C061574
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 11:19:02 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id b5so15770839ilq.10
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 11:19:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8E8xJBv0v2nEozSn/5VobTf9WaZf+XapKbzgWOIGRPQ=;
        b=VaEkCh79esv2dTg02WPN3LlLsEujjkIaJPcOuQfPbq1ZllNEImrB5gyGroTnec1jcU
         FqtrPo2uOP3QdzdvDXzDxtMv7B862d9n/IaHgnFNcYclsPTCE19WovTwgjA2FRKG6J/V
         JL2+yF7crACJGuab/VXJuRXh3Dl5SjDtMiJ5B+FZPyu9hDpJfeduc3xRijwc0hMWhKGQ
         N/WuN7Ep0jbWOckG8ZckOksZ9se+1TN/h/vnkmCJWabc6C9U/Dpw4xowHXN5yCx4bgAl
         C/ppxzb4RodQ49WRr7aadSUjS22aE1p0W67ZJFLsJekB70GUqwLC3wCl7yleNTGcSUyk
         q6kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8E8xJBv0v2nEozSn/5VobTf9WaZf+XapKbzgWOIGRPQ=;
        b=IMvmTPFbLSG7KJmwbsS2VjDYQAJCaA2uOjA3glW50TkjA/uSgMwLy3FAmEfIq5cpnX
         4eyo4f5tVfaclUBY6InO2HbXFuaZoV6CVvD8yiY0Xt5pourMMJueOgkpb0ykUMkWSIu1
         z32JIuCRdCzGIasX2Iqk6rNKsTXktzaN4PLvqlokjy0LCURByyIsWuSnqxvDC4H/HowM
         q/cYkTevHqs9Ql5QzCwqLBVHDd6IGV5fQgQiVBbgz30z3tcnITzsYMps0BBKmoauVCCu
         8kC6ncuodlTz4AyJOLMuMYNNxdrFARo3Ha8vl3osnjgyDdN7+9e/Aixdm7XTPnG+WcoJ
         aYWA==
X-Gm-Message-State: AOAM533dOQ+HhMlLwMuulUEgRqU4kH5HCDYg7zTeilhcgsGt5BnNDFrS
        6hMU1T3y2l4QnrxS3ULBHG+Fjg==
X-Google-Smtp-Source: ABdhPJyC1X/hAhzCPbnrlRlPxmgGCv2t7d6GGpKBYHcfPH2jsLxbA4V3O99kjXqav4PvrkGhJjvxKw==
X-Received: by 2002:a92:ce05:: with SMTP id b5mr5183990ilo.170.1614885541970;
        Thu, 04 Mar 2021 11:19:01 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id m15sm184001ilh.6.2021.03.04.11.19.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 11:19:01 -0800 (PST)
Subject: Re: [PATCH 09/18] io-wq: fork worker threads from original task
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <20210219171010.281878-1-axboe@kernel.dk>
 <20210219171010.281878-10-axboe@kernel.dk>
 <85bc236d-94af-6878-928b-c69dbdcd46f9@samba.org>
 <d9704b9e-ae5e-0795-ba2e-029293f89616@kernel.dk>
 <a9f58269-b260-6281-4e83-43cb5e881d25@samba.org>
 <d3dfc422-8762-0078-bc80-989f1d71f006@samba.org>
 <32f1218b-49c3-eeb6-5866-3ec45acbc1c5@kernel.dk>
 <34857989-ff46-b2a7-9730-476636848acc@samba.org>
 <47c76a83-a449-3a65-5850-1d3dff4f3249@kernel.dk>
 <09579257-8d8e-8f25-6ceb-eea4f5596eb3@kernel.dk>
 <CAHk-=wgqJdq6GjydKoAb41K9QX5Q8XMLA2dPaM3a3xqQQa_ygg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f42dcb4e-5044-33ed-9563-c91b9f8b7e64@kernel.dk>
Date:   Thu, 4 Mar 2021 12:19:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wgqJdq6GjydKoAb41K9QX5Q8XMLA2dPaM3a3xqQQa_ygg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/4/21 11:56 AM, Linus Torvalds wrote:
> On Thu, Mar 4, 2021 at 10:19 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> How about this - it moves the signal fiddling into the task
>> itself, and leaves the parent alone. Also allows future cleanups
>> of how we wait for thread creation.
> 
> Ugh, I think this is wrong.
> 
> You shouldn't usekernel_thread() at all, and you shouldn't need to set
> the sigmask in the parent, only to have it copied to the child, and
> then restore it in the parent.
> 
> You shouldn't have to have that silly extra scheduling rendezvous with
> the completion, which forces two schedules (first a schedule to the
> child to do what it wants to do, and then "complete()" there to wake
> up the parent that is waiting for the completion.
> 
> The thing is, our internal thread creation functionality is already
> written explicitly to not need any of this: the creation of a new
> thread is a separate phase, and then you do some setup, and then you
> actually tell the new thread "ok, go go go".
> 
> See the kernel_clone() function kernel/fork.c for the structure of this all.
> 
> You really should just do
> 
>  (a) copy_thread() to create a new child that is inactive and cannot yet run
> 
>  (b) do any setup in that new child (like setting the signal mask in
> it, but also perhaps setting the PF_IO_WORKER flag etc)
> 
>  (c) actually say "go go go": wake_up_new_task(p);
> 
> and you're done. No completions, no "set temporary mask in parent to
> be copied", no nothing like that.
> 
> And for the IO worker threads, you really don't want all the other
> stuff that kernel_clone() does. You don't want the magic VFORK "wait
> for the child to release the VM we gave it". You don't want the clone
> ptrace setup, because you can't ptrace those IO workler threads
> anyway. You might want a tracepoint, but you probably want a
> _different_ tracepoint than the "normal clone" one. You don't want the
> latent entropy addition, because honestly, the thing has no entropy to
> add either.
> 
> So I think you really want to just add a new "create_io_thread()"
> inside kernel/fork.c, which is a very cut-down and specialized version
> of kernel_clone().
> 
> It's actually going to be _less_ code than what you have now, and it's
> going to avoid all the problems with anmy half-way state or "set
> parent state to something that gets copied and then undo the parent
> state after the copy".

Took a quick look at this, and I agree that's _much_ better. In fact, it
boils down to just calling copy_process() and then having the caller do
wake_up_new_task(). So not sure if it's worth adding an
create_io_thread() helper, or just make copy_process() available
instead. This is ignoring the trace point for now...

I'll try and spin this up, should be pretty trivial and indeed remove
even more code and useless wait_for_completion+complete slowdowns...

-- 
Jens Axboe

