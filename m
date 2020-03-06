Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76E3B17C1F2
	for <lists+io-uring@lfdr.de>; Fri,  6 Mar 2020 16:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbgCFPgu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Mar 2020 10:36:50 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:35159 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727137AbgCFPgu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Mar 2020 10:36:50 -0500
Received: by mail-oi1-f193.google.com with SMTP id c1so2939342oiy.2
        for <io-uring@vger.kernel.org>; Fri, 06 Mar 2020 07:36:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aIS3j9BcsIx1974rQkdX3Sq/wS4nhMN+kP4/ppiopJQ=;
        b=pdzfVkRpdhCdinsJQyA2PpGXMwl9diPaAtQ+q5PW7umYSE8oOsh+l4A7IkWmbd5V30
         FVXy2Y5U+5S7vPuSIkuWSXFTasDAGkFOEf1jlNfn2DSNAz37CkwOZZ/So73T1EpJeKsy
         Z0uixE4WN+DrWt9CriO18kAzqHWWy3qebwSLleITjbms4v81y6Jq9tZRtNWNGYmEaX/Z
         n7tiP8mwgfqQ9F+kl4DnTqxA0TRHNrnQuFlfAL0kPfG5fBhEkkidL3UXquSbhYhIeo5X
         kYpplD1y0KZNmODQs8TfxBxhueX2QCEv381klgHQxcoaX9sY/bszhuiSfVzkR1xt66XO
         wEQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aIS3j9BcsIx1974rQkdX3Sq/wS4nhMN+kP4/ppiopJQ=;
        b=f6TJ5oIED4pJuN8F9xDIR8Tbb1p4jW1JECag24S9wzTFhLhcY7ppo8RSRfawvrBtcu
         JY6ACIvge0OiBonIF7ucA7jSL+KpeoxBEN8feJlmUGUqPUfxdbdeFSgK61Ejo3+n/Epe
         LMUNRZNlvxiAIavIONFyV/oEvJgevBfFA9Y5KSFuHg0Yfkp0EpMrpmD5Z5lB2id0uuxi
         7YNFdCZqvmnNX7JGwlnxdNMa0HjDBttqeUTw4m8Eq6j8kczWLdOCO6GX1PjD8ol0bl/5
         xJkWxSQGBbjkfUNgxBHHVuL2gOYN7i8EorkwN2acOeDrhV4LR8lCB1aPtoD3asIk5GiW
         cKBw==
X-Gm-Message-State: ANhLgQ3k5ImeGEIx1XS5EmAdYVHnp2OdpJU6t36vYRqEgV3DKXHWYa3D
        j7P0y/C8ZV62yZ6snOoPOtwGgbweTNNJgK9zBCmgcA==
X-Google-Smtp-Source: ADFU+vvgF4FhHryXSvnABcW3w8OiD7DynVdUdHWARYq/viqNv1B+cG0awG7CYgS9jYS7UtPoQdF/YFo5AlaEqpOqD50=
X-Received: by 2002:a05:6808:8d0:: with SMTP id k16mr3048626oij.68.1583509007480;
 Fri, 06 Mar 2020 07:36:47 -0800 (PST)
MIME-Version: 1.0
References: <00000000000067c6df059df7f9f5@google.com> <CACT4Y+ZVLs7O84qixsvFqk_Nur1WOaCU81RiCwDf3wOqvHB-ag@mail.gmail.com>
 <3f805e51-1db7-3e57-c9a3-15a20699ea54@kernel.dk> <CAG48ez3DUAraFL1+agBX=1JVxzh_e2GR=UpX5JUaoyi+1gQ=6w@mail.gmail.com>
 <075e7fbe-aeec-cb7d-9338-8eb4e1576293@kernel.dk>
In-Reply-To: <075e7fbe-aeec-cb7d-9338-8eb4e1576293@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 6 Mar 2020 16:36:20 +0100
Message-ID: <CAG48ez07bD4sr5hpDhUKe2g5ETk0iYb6PCWqyofPuJbXz1z+hw@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in percpu_ref_switch_to_atomic_rcu
To:     Jens Axboe <axboe@kernel.dk>,
        "Paul E . McKenney" <paulmck@kernel.org>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+e017e49c39ab484ac87a@syzkaller.appspotmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>, tony.luck@intel.com,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Mar 6, 2020 at 4:34 PM Jens Axboe <axboe@kernel.dk> wrote:
> On 3/6/20 7:57 AM, Jann Horn wrote:
> > +paulmck
> >
> > On Wed, Mar 4, 2020 at 3:40 PM Jens Axboe <axboe@kernel.dk> wrote:
> >> On 3/4/20 12:59 AM, Dmitry Vyukov wrote:
> >>> On Fri, Feb 7, 2020 at 9:14 AM syzbot
> >>> <syzbot+e017e49c39ab484ac87a@syzkaller.appspotmail.com> wrote:
> >>>>
> >>>> Hello,
> >>>>
> >>>> syzbot found the following crash on:
> >>>>
> >>>> HEAD commit:    4c7d00cc Merge tag 'pwm/for-5.6-rc1' of git://git.kernel.o..
> >>>> git tree:       upstream
> >>>> console output: https://syzkaller.appspot.com/x/log.txt?x=12fec785e00000
> >>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=e162021ddededa72
> >>>> dashboard link: https://syzkaller.appspot.com/bug?extid=e017e49c39ab484ac87a
> >>>> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> >>>>
> >>>> Unfortunately, I don't have any reproducer for this crash yet.
> >>>>
> >>>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> >>>> Reported-by: syzbot+e017e49c39ab484ac87a@syzkaller.appspotmail.com
> >>>
> >>> +io_uring maintainers
> >>>
> >>> Here is a repro:
> >>> https://gist.githubusercontent.com/dvyukov/6b340beab6483a036f4186e7378882ce/raw/cd1922185516453c201df8eded1d4b006a6d6a3a/gistfile1.txt
> >>
> >> I've queued up a fix for this:
> >>
> >> https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.6&id=9875fe3dc4b8cff1f1b440fb925054a5124403c3
> >
> > I believe that this fix relies on call_rcu() having FIFO ordering; but
> > <https://www.kernel.org/doc/Documentation/RCU/Design/Memory-Ordering/Tree-RCU-Memory-Ordering.html#Callback%20Registry>
> > says:
> >
> > | call_rcu() normally acts only on CPU-local state[...] It simply
> > enqueues the rcu_head structure on a per-CPU list,
> >
> > Is this fix really correct?
>
> That's a good point, there's a potentially stronger guarantee we need
> here that isn't "nobody is inside an RCU critical section", but rather
> that we're depending on a previous call_rcu() to have happened. Hence I
> think you are right - it'll shrink the window drastically, since the
> previous callback is already queued up, but it's not a full close.
>
> Hmm...

You could potentially hack up the semantics you want by doing a
call_rcu() whose callback does another call_rcu(), or something like
that - but I'd like to hear paulmck's opinion on this first.
