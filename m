Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E91402A021C
	for <lists+io-uring@lfdr.de>; Fri, 30 Oct 2020 11:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgJ3KGn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Oct 2020 06:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgJ3KGn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Oct 2020 06:06:43 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D49BC0613D2
        for <io-uring@vger.kernel.org>; Fri, 30 Oct 2020 03:06:43 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id w5so2489660qvn.12
        for <io-uring@vger.kernel.org>; Fri, 30 Oct 2020 03:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tELbhXfQariElQPBOqAGKxNGlZL8E/ZXdebHFJy/Swk=;
        b=dELZIPtiqtXpHQ7fjyuo6GNNLMPs9DWb1SMjCY5eGwM76MPPy2eDyZ83N4PcOAIdw4
         azxWdm/nMgQB+vwbL7e+vM6rC8RxvpnG8J0HI2DVrPTRokppZTH1IRHAaNNtdbJ4e0fl
         QTjg0w+zCa3J9iS69rMs9evPg5HihkvUxD4Gjqi5UdZzKfYHq3qWqGxmzlkLTAmQ4yO8
         2/lSCoVhAhMykIiGXz2yfbE0KeBjUBSU/4mPnf76/PzSPtX3LigZ4+mYrLTFUNo2W1sY
         huVfAUajc8PLsdlzL+Zec2BKncYiE/5Gp8Um1ls03omFXuz23v8lQvEhHYlf5mRRJTI6
         B9Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tELbhXfQariElQPBOqAGKxNGlZL8E/ZXdebHFJy/Swk=;
        b=R2SrfE+fW8CV2h1zYgcpAF7OOx8llgJ9hSBa8sDVRiANIlZVS9h2+8vF5M/57LQvHT
         ajd0ecTIJnNx50QpTWy5n5lPVl3KRf5J2JbZ7TZ7nzquXX9URdfZ4JVT1pr3eF42HMPF
         rsXI51XutDw2w8OiuZxEzzoOE07Wms3jVvHfKYZLR8m9T4p3OKMa/qIF8U/18ooWtZeS
         UuuAmF9m31CuBQKPuRK3l2yx8SzLN8NPpPcxpeyMYWfjXT24IEmQnGzVmnT4x8G3YSi5
         9xtFqoTfn5wwaWJS2biegVyEBBa9EdUs92WeOExrF/DnzGQLW2sg9ERONwel9nrGPZNw
         NayA==
X-Gm-Message-State: AOAM530Fl57Ka9zBmqJBQZ4pPvxlX9nzL2Gqhg7yNS6/PVRPMvYoN2Ju
        aDAfHgiV9I6iaFVI/iv/EIUYwISlwdKtHMFF+IMTBw==
X-Google-Smtp-Source: ABdhPJwc1+7TcV9MSi+z6TcWtLeHmWbO58lYC2oSiF2SxLlKXLntRRFRSM9/doT/IR40mAYb6sLnwqstaBc+DrKnU/M=
X-Received: by 2002:ad4:414d:: with SMTP id z13mr8680267qvp.37.1604052402013;
 Fri, 30 Oct 2020 03:06:42 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000030a45905aedd879d@google.com> <20200909134317.19732-1-hdanton@sina.com>
 <4d55d988-d45e-ba36-fed7-342e0a6ab16e@kernel.dk> <20200909153235.joqj6hjyxug3wtwv@steredhat>
In-Reply-To: <20200909153235.joqj6hjyxug3wtwv@steredhat>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 30 Oct 2020 11:06:30 +0100
Message-ID: <CACT4Y+ZpzjQgFCaOD00oP17sFcsFNvFyShY-ydoJGQnGEKri1w@mail.gmail.com>
Subject: Re: INFO: task hung in io_sq_thread_stop
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+3c23789ea938faaef049@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Sep 9, 2020 at 5:32 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> On Wed, Sep 09, 2020 at 08:05:33AM -0600, Jens Axboe wrote:
> > On 9/9/20 7:43 AM, Hillf Danton wrote:
> > >
> > > On Wed, 9 Sep 2020 12:03:55 +0200 Stefano Garzarella wrote:
> > >> On Wed, Sep 09, 2020 at 01:49:22AM -0700, syzbot wrote:
> > >>> Hello,
> > >>>
> > >>> syzbot found the following issue on:
> > >>>
> > >>> HEAD commit:    dff9f829 Add linux-next specific files for 20200908
> > >>> git tree:       linux-next
> > >>> console output: https://syzkaller.appspot.com/x/log.txt?x=112f880d900000
> > >>> kernel config:  https://syzkaller.appspot.com/x/.config?x=37b3426c77bda44c
> > >>> dashboard link: https://syzkaller.appspot.com/bug?extid=3c23789ea938faaef049
> > >>> compiler:       gcc (GCC) 10.1.0-syz 20200507
> > >>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17c082a5900000
> > >>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1474f5f9900000
> > >>>
> > >>> Bisection is inconclusive: the first bad commit could be any of:
> > >>>
> > >>> d730b1a2 io_uring: add IOURING_REGISTER_RESTRICTIONS opcode
> > >>> 7ec3d1dd io_uring: allow disabling rings during the creation
> > >>
> > >> I'm not sure it is related, but while rebasing I forgot to update the
> > >> right label in the error path.
> > >>
> > >> Since the check of ring state is after the increase of ctx refcount, we
> > >> need to decrease it jumping to 'out' label instead of 'out_fput':
> > >
> > > I think we need to fix 6a7bb9ff5744 ("io_uring: remove need for
> > > sqd->ctx_lock in io_sq_thread()") because the syzbot report
> > > indicates the io_sq_thread has to wake up the kworker before
> > > scheduling, and in turn the kworker has the chance to unpark it.
> > >
> > > Below is the minimum walkaround I can have because it can't
> > > ensure the parker will be waken in every case.
> > >
> > > --- a/fs/io_uring.c
> > > +++ b/fs/io_uring.c
> > > @@ -6834,6 +6834,10 @@ static int io_sq_thread(void *data)
> > >                     io_sq_thread_drop_mm();
> > >             }
> > >
> > > +           if (kthread_should_park()) {
> > > +                   /* wake up parker before scheduling */
> > > +                   continue;
> > > +           }
> > >             if (ret & SQT_SPIN) {
> > >                     io_run_task_work();
> > >                     cond_resched();
> > >
> >
> > I think this should go in the slow path:
> >
> >
> > diff --git a/fs/io_uring.c b/fs/io_uring.c
> > index 652cc53432d4..1c4fa2a0fd82 100644
> > --- a/fs/io_uring.c
> > +++ b/fs/io_uring.c
> > @@ -6839,6 +6839,8 @@ static int io_sq_thread(void *data)
> >               } else if (ret == SQT_IDLE) {
> >                       list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
> >                               io_ring_set_wakeup_flag(ctx);
> > +                     if (kthread_should_park())
> > +                             continue;
> >                       schedule();
> >                       start_jiffies = jiffies;
> >               }
> >
>
> Yes, I agree since only in this case the kthread is not rescheduled.
>
> Thanks both for the fix :-)
> Feel free to add my R-b:
>
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

What happened with this fix?
The bug is marked as fixed with commit "io_uring: don't sleep schedule
in SQPOLL thread if we need to park":
https://syzkaller.appspot.com/bug?id=d0cf0b29fc5520a8987b28f1a7b63264ae02535e
But such commit cannot be found in any tree.
