Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312A02E0955
	for <lists+io-uring@lfdr.de>; Tue, 22 Dec 2020 12:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgLVLHC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Dec 2020 06:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbgLVLHB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Dec 2020 06:07:01 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8025AC0613D6
        for <io-uring@vger.kernel.org>; Tue, 22 Dec 2020 03:06:21 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id 2so11641948ilg.9
        for <io-uring@vger.kernel.org>; Tue, 22 Dec 2020 03:06:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bLIMS4rBdJdNNszmiJcs2ep//79V8zKYrEnOR4UvTI0=;
        b=mXZx60bUHvRt/sAH45BM1cjKyrcRg/OjSnpN2301cc63jY3ARl/LJx9SvlrnkP+9jI
         7jgTKubmQhOOjhJMpTOwLkp/vwAXs2zvnm7gZyFne77HksHLQI7Mg3W+JBPf1g9BGd7x
         b5MscPo3YmHRi3gwLAplhItv2BkfG6EXkm40aJGtxv/DW5XSqUNwxUoVwqCCj+p6tc+5
         nYw0hF1v0vdKbnGlhCKFX1FiTUXxVUeYYGcHqg10lGFTsmbupPU/luW6tXJFDY7NaufY
         js/H3nTFIbhBBGV9j0uuX2Oqj7Y8Ag9pIZzxD1PX0km8W/casX69bpnohz1IpilaYHQA
         +vOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bLIMS4rBdJdNNszmiJcs2ep//79V8zKYrEnOR4UvTI0=;
        b=VViWWj+nwhfrXTACiue4uLl09ZGNNM1+o6NurKcg9iN8RRyaApXpa0S92YMDIg9Yrh
         W4aQoBdtD97Qxy+gT+wLOdBrgCGI5lpBCSC5n0hiwqirJh/Wu16sXHXdrzzL68VYzdDW
         1OKMy8w7Vv74wcaTAapaGuDwF5CIwcHY0Yf7xDEJEu8R+jJ9X6oDX/qYQcFXH5EX/Qsd
         WW8+vqt16g12jmA1UgpoyoSEKLOz7CnDO6hfUoWp5RK5il8E1uCaRPg5eNz14Oflceyy
         8KoPjyGF/M8wagWyPCc4m3lcJvXO1vNdYft/CUG19oPEbZXrXapWWKy5OJekOtS09ezc
         RA1A==
X-Gm-Message-State: AOAM53216pUvhPrSvhfhvERrXSDRRdoBMvOlIbcB3R+mcGq5PpvA6wz8
        /0CXLA4NzwBkDODbclUEg+tNcPTP9MhuF6C58js=
X-Google-Smtp-Source: ABdhPJz1PVQCCSKQTQ7tJSuuDIBO0uQXi4ghKPnYUW5VenY2cg8LVlCqxpPbzh770k54ZGGdZwA9I8FkwEWIDue7o/E=
X-Received: by 2002:a92:84c1:: with SMTP id y62mr20109422ilk.191.1608635180755;
 Tue, 22 Dec 2020 03:06:20 -0800 (PST)
MIME-Version: 1.0
References: <4dc9c74b-249d-117c-debf-4bb9e0df2988@kernel.dk>
 <2B352D6C-4CA2-4B09-8751-D7BB8159072D@googlemail.com> <d9205a43-ebd7-9412-afc6-71fdcf517a32@kernel.dk>
 <CAAss7+ps4xC785yMjXC6u8NiH9PCCQQoPiH+AhZT7nMX7Q_uEw@mail.gmail.com>
 <0fe708e2-086b-94a8-def4-e4ebd6e0b709@kernel.dk> <614f8422-3e0e-25b9-4cc2-4f1c07705ab0@kernel.dk>
 <986c85af-bb77-60d4-8739-49b662554157@gmail.com> <e88403ad-e272-2028-4d7a-789086e12d8b@kernel.dk>
 <2e968c77-912d-6ae1-7000-5e34eb978ab5@gmail.com> <CAOKbgA5YD_MxY-RqJzP7eqdkqrnQCgjRin7w29QtszHaCJqwrg@mail.gmail.com>
 <CAOKbgA7TyscndB7nn409NsFfoJriipHG80fgh=7SRESbiguNAg@mail.gmail.com>
 <58bd0583-5135-56a1-23e2-971df835824c@gmail.com> <da4f2ac2-e9e0-b0c2-1f0a-be650f68b173@gmail.com>
 <CAOKbgA7shBKAnVKXQxd6PadiZi0O7UZZBZ6rHnr3HnuDdtx3ng@mail.gmail.com>
In-Reply-To: <CAOKbgA7shBKAnVKXQxd6PadiZi0O7UZZBZ6rHnr3HnuDdtx3ng@mail.gmail.com>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Tue, 22 Dec 2020 18:06:09 +0700
Message-ID: <CAOKbgA5xZSpMWGfDpetXqVck4fvC9xkmKuWYV8nrpOBqPmCfAQ@mail.gmail.com>
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Josef <josef.grieb@gmail.com>,
        Norman Maurer <norman.maurer@googlemail.com>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Dec 22, 2020 at 6:04 PM Dmitry Kadashev <dkadashev@gmail.com> wrote:
>
> On Tue, Dec 22, 2020 at 11:11 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
> >
> > On 22/12/2020 03:35, Pavel Begunkov wrote:
> > > On 21/12/2020 11:00, Dmitry Kadashev wrote:
> > > [snip]
> > >>> We do not share rings between processes. Our rings are accessible from different
> > >>> threads (under locks), but nothing fancy.
> > >>>
> > >>>> In other words, if you kill all your io_uring applications, does it
> > >>>> go back to normal?
> > >>>
> > >>> I'm pretty sure it does not, the only fix is to reboot the box. But I'll find an
> > >>> affected box and double check just in case.
> > >
> > > I can't spot any misaccounting, but I wonder if it can be that your memory is
> > > getting fragmented enough to be unable make an allocation of 16 __contiguous__
> > > pages, i.e. sizeof(sqe) * 1024
> > >
> > > That's how it's allocated internally:
> > >
> > > static void *io_mem_alloc(size_t size)
> > > {
> > >       gfp_t gfp_flags = GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP |
> > >                               __GFP_NORETRY;
> > >
> > >       return (void *) __get_free_pages(gfp_flags, get_order(size));
> > > }
> > >
> > > What about smaller rings? Can you check io_uring of what SQ size it can allocate?
> > > That can be a different program, e.g. modify a bit liburing/test/nop.
> >
> > Even better to allocate N smaller rings, where N = 1024 / SQ_size
> >
> > static int try_size(int sq_size)
> > {
> >         int ret = 0, i, n = 1024 / sq_size;
> >         static struct io_uring rings[128];
> >
> >         for (i = 0; i < n; ++i) {
> >                 if (io_uring_queue_init(sq_size, &rings[i], 0) < 0) {
> >                         ret = -1;
> >                         break;
> >                 }
> >         }
> >         for (i -= 1; i >= 0; i--)
> >                 io_uring_queue_exit(&rings[i]);
> >         return ret;
> > }
> >
> > int main()
> > {
> >         int size;
> >
> >         for (size = 1024; size >= 2; size /= 2) {
> >                 if (!try_size(size)) {
> >                         printf("max size %i\n", size);
> >                         return 0;
> >                 }
> >         }
> >
> >         printf("can't allocate %i\n", size);
> >         return 0;
> > }
>
> Unfortunately I've rebooted the box I've used for tests yesterday, so I can't
> try this there. Also I was not able to come up with an isolated reproducer for
> this yet.
>
> The good news is I've found a relatively easy way to provoke this on a test VM
> using our software. Our app runs with "admin" user perms (plus some
> capabilities), it bumps RLIMIT_MEMLOCK to infinity on start. I've also created
> an user called 'ioutest' to run the check for ring sizes using a different user.
>
> I've modified the test program slightly, to show the number of rings
> successfully
> created on each iteration and the actual error message (to debug a problem I was
> having with it, but I've kept this after that). Here is the output:
>
> # sudo -u admin bash -c 'ulimit -a' | grep locked
> max locked memory       (kbytes, -l) 1024
>
> # sudo -u ioutest bash -c 'ulimit -a' | grep locked
> max locked memory       (kbytes, -l) 1024
>
> # sudo -u admin ./iou-test1
> Failed after 0 rings with 1024 size: Cannot allocate memory
> Failed after 0 rings with 512 size: Cannot allocate memory
> Failed after 0 rings with 256 size: Cannot allocate memory
> Failed after 0 rings with 128 size: Cannot allocate memory
> Failed after 0 rings with 64 size: Cannot allocate memory
> Failed after 0 rings with 32 size: Cannot allocate memory
> Failed after 0 rings with 16 size: Cannot allocate memory
> Failed after 0 rings with 8 size: Cannot allocate memory
> Failed after 0 rings with 4 size: Cannot allocate memory
> Failed after 0 rings with 2 size: Cannot allocate memory
> can't allocate 1
>
> # sudo -u ioutest ./iou-test1
> max size 1024
>
> # ps ax | grep wq
>     8 ?        I<     0:00 [mm_percpu_wq]
>   121 ?        I<     0:00 [tpm_dev_wq]
>   124 ?        I<     0:00 [devfreq_wq]
> 20593 pts/1    S+     0:00 grep --color=auto wq

This was on kernel 5.6.7, I'm going to try this on 5.10.1 now.

-- 
Dmitry Kadashev
