Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24A1F32D9CD
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 19:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbhCDS54 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 13:57:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235782AbhCDS5v (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 13:57:51 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C8CC0613DB
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 10:56:54 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id 18so36436034lff.6
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 10:56:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+VuMcJP/l7cFJ1HD0LWmVr3Ex6xmH2p3WC+15Irb8wc=;
        b=LGaf6+Il8Y63Z/6CvEx8ba6pezb3eHj4QTiI0rUwpzDtjpQqwCWnsfCAuIqb8btLua
         Vap9XQsLQkljueUYcWCMq0dlb5bgbZWnBf+yQO3bxiRvZGs2EWOeN/xOYD/QXnwA8i6W
         gktx2X0Hv1P+eUsPqU496zcFO+zsLriXA4oEg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+VuMcJP/l7cFJ1HD0LWmVr3Ex6xmH2p3WC+15Irb8wc=;
        b=j+R+YWHNnMfG5HzUjjOq4wCNUKK/L4R99RjMqwBT95swzZDKTKsHt7cxc1tJ2ncUwt
         rzNuZp577H1CK4/JuYhWPy/R/myL6MVxDagwuRIT6AqZ5hHT5rH1AM0iYKAwktJkM4qg
         yM7DGzKngo4k8Z5BFH2pZmy+N0qsMdouLwLorc9A8K7kGzC+VO7DpbMvxWMPQMCHv/HH
         n64EjZGa8MbZ5VJjbtIArm/LPwuQREayPlPRSQ/q2RX4DV8kEtAHE5wOHNO6c7tCX48+
         sxU+THOaWcYo1z50czgp1coaD2tJGC8Q8dlktkSHZClyKMuLJdy1BodnoGV3a3qC5wwV
         0q7A==
X-Gm-Message-State: AOAM531R1UoPyvrYgRgSh1We+CMrk/+Nvx8UMKrTGSSbV64tO4FaCtGW
        rwDHxoMCHTSqLc243RRpFA5GPfMYzafzlg==
X-Google-Smtp-Source: ABdhPJzg5VBJ1Qhmmcsli52DGzdjPwqWZnNUQSDTWXZy5sskXggDJpqS7wup9R99WQtOhppPDC/zfA==
X-Received: by 2002:a05:6512:3a8f:: with SMTP id q15mr2881554lfu.389.1614884212687;
        Thu, 04 Mar 2021 10:56:52 -0800 (PST)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id w25sm22540lfe.298.2021.03.04.10.56.51
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 10:56:52 -0800 (PST)
Received: by mail-lf1-f51.google.com with SMTP id p21so44951079lfu.11
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 10:56:51 -0800 (PST)
X-Received: by 2002:a05:6512:2287:: with SMTP id f7mr2971078lfu.40.1614884211640;
 Thu, 04 Mar 2021 10:56:51 -0800 (PST)
MIME-Version: 1.0
References: <20210219171010.281878-1-axboe@kernel.dk> <20210219171010.281878-10-axboe@kernel.dk>
 <85bc236d-94af-6878-928b-c69dbdcd46f9@samba.org> <d9704b9e-ae5e-0795-ba2e-029293f89616@kernel.dk>
 <a9f58269-b260-6281-4e83-43cb5e881d25@samba.org> <d3dfc422-8762-0078-bc80-989f1d71f006@samba.org>
 <32f1218b-49c3-eeb6-5866-3ec45acbc1c5@kernel.dk> <34857989-ff46-b2a7-9730-476636848acc@samba.org>
 <47c76a83-a449-3a65-5850-1d3dff4f3249@kernel.dk> <09579257-8d8e-8f25-6ceb-eea4f5596eb3@kernel.dk>
In-Reply-To: <09579257-8d8e-8f25-6ceb-eea4f5596eb3@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 4 Mar 2021 10:56:34 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgqJdq6GjydKoAb41K9QX5Q8XMLA2dPaM3a3xqQQa_ygg@mail.gmail.com>
Message-ID: <CAHk-=wgqJdq6GjydKoAb41K9QX5Q8XMLA2dPaM3a3xqQQa_ygg@mail.gmail.com>
Subject: Re: [PATCH 09/18] io-wq: fork worker threads from original task
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Mar 4, 2021 at 10:19 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> How about this - it moves the signal fiddling into the task
> itself, and leaves the parent alone. Also allows future cleanups
> of how we wait for thread creation.

Ugh, I think this is wrong.

You shouldn't usekernel_thread() at all, and you shouldn't need to set
the sigmask in the parent, only to have it copied to the child, and
then restore it in the parent.

You shouldn't have to have that silly extra scheduling rendezvous with
the completion, which forces two schedules (first a schedule to the
child to do what it wants to do, and then "complete()" there to wake
up the parent that is waiting for the completion.

The thing is, our internal thread creation functionality is already
written explicitly to not need any of this: the creation of a new
thread is a separate phase, and then you do some setup, and then you
actually tell the new thread "ok, go go go".

See the kernel_clone() function kernel/fork.c for the structure of this all.

You really should just do

 (a) copy_thread() to create a new child that is inactive and cannot yet run

 (b) do any setup in that new child (like setting the signal mask in
it, but also perhaps setting the PF_IO_WORKER flag etc)

 (c) actually say "go go go": wake_up_new_task(p);

and you're done. No completions, no "set temporary mask in parent to
be copied", no nothing like that.

And for the IO worker threads, you really don't want all the other
stuff that kernel_clone() does. You don't want the magic VFORK "wait
for the child to release the VM we gave it". You don't want the clone
ptrace setup, because you can't ptrace those IO workler threads
anyway. You might want a tracepoint, but you probably want a
_different_ tracepoint than the "normal clone" one. You don't want the
latent entropy addition, because honestly, the thing has no entropy to
add either.

So I think you really want to just add a new "create_io_thread()"
inside kernel/fork.c, which is a very cut-down and specialized version
of kernel_clone().

It's actually going to be _less_ code than what you have now, and it's
going to avoid all the problems with anmy half-way state or "set
parent state to something that gets copied and then undo the parent
state after the copy".

                   Linus
