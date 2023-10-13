Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB1A27C88F9
	for <lists+io-uring@lfdr.de>; Fri, 13 Oct 2023 17:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbjJMPoI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Oct 2023 11:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232493AbjJMPoH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Oct 2023 11:44:07 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D832BD7
        for <io-uring@vger.kernel.org>; Fri, 13 Oct 2023 08:44:05 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id 3f1490d57ef6-d9a58f5f33dso2460428276.1
        for <io-uring@vger.kernel.org>; Fri, 13 Oct 2023 08:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1697211845; x=1697816645; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AJ1u8W8nJDs/3hnqsTsgMgJtZzTYy7L696nS2k9TLM0=;
        b=PgRFFLumPxwbWIaZ0cZ+u7f93r8cyEdMFKCcFKZ7XK/Gq4tVNjJzskfSkQhPN2oho0
         rBNu7fBjesogSt6MK0eb9w4UXSx+NRSqDQK2SkgA6/cgX9VR+4auv02Kwyrh2OiumqBG
         f/WHeGK+ac1EgukUq9rXSDKa6pU/L0H9BzQnhZeFFDwygcGKvr9SQW4+cJJMl681sUjf
         LaQmZ4Or5oMXc5b8c33oymRSACXwyZjAw7sRQ1HyrWnOsPpB/rbBGY8ZGQK07Dm4FiJh
         +nAkhUix0eEv0PmL/X8xnG6bdRMFcO2T+KS2DR13oN20Y6VpRq7xCnjoNI3/3QmR89Bf
         rD4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697211845; x=1697816645;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AJ1u8W8nJDs/3hnqsTsgMgJtZzTYy7L696nS2k9TLM0=;
        b=gaMGAH7odhtf2GNuf5aQezoSFqayXM8V5kGkJvzZyZcyQ/yWODsvJI5EloaZ74XIhx
         ZFrcC/s+xh+qoOEPvtfHPCbf0wpKkpSI+/GScWcYypLht3QRHNOTYDwqiRJJ3kHoRGrz
         +2xJTZukfkKlqqUhT2SgGFxnPzImJNe3oxofFYIkf2VENNuYoX6CxUaT44VlKcVXG+rj
         CXMUDRDlqiHTWpqbnrEZTr1a91PqwuHb+iigUBKFe79umDt5ipwQ4ypZbbA5NjU4tflr
         y66heiA25zY2he8kvkS4HoCOW+Kdp+uOh6EZbnVOC+uvtuMgnDGpvECqDFwBSrufsRIP
         taDQ==
X-Gm-Message-State: AOJu0YwTdgE5FwbFsTgPW0uEJIG21G00VdsnL4ni8wWMvJXp3PlmlvfV
        JpUr3TLYt1ru7Sfv4SvKw4WfA50sJJsBMMVj+iBI
X-Google-Smtp-Source: AGHT+IFwQ7EtyACxdJUfqpyZF/wUto1XaZssDLi7J8PLVjO2u/pmkdEdsxLsosxCWq/+ScwyHDhej2pl2Yir1JvfipA=
X-Received: by 2002:a25:26c6:0:b0:d9a:c827:28f with SMTP id
 m189-20020a2526c6000000b00d9ac827028fmr5191441ybm.62.1697211844952; Fri, 13
 Oct 2023 08:44:04 -0700 (PDT)
MIME-Version: 1.0
References: <20231012215518.GA4048@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <20231013-insofern-gegolten-75ca48b24cf5@brauner> <672d257e-e28f-42bc-8ac7-253d20fe187c@kernel.dk>
In-Reply-To: <672d257e-e28f-42bc-8ac7-253d20fe187c@kernel.dk>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 13 Oct 2023 11:43:54 -0400
Message-ID: <CAHC9VhQcSY9q=wVT7hOz9y=o3a67BVUnVGNotgAvE6vK7WAkBw@mail.gmail.com>
Subject: Re: [PATCH] audit,io_uring: io_uring openat triggers audit reference
 count underflow
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christian Brauner <brauner@kernel.org>,
        Dan Clash <daclash@linux.microsoft.com>, audit@vger.kernel.org,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dan.clash@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Oct 13, 2023 at 10:21=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote=
:
> On 10/13/23 2:24 AM, Christian Brauner wrote:
> > On Thu, Oct 12, 2023 at 02:55:18PM -0700, Dan Clash wrote:
> >> An io_uring openat operation can update an audit reference count
> >> from multiple threads resulting in the call trace below.
> >>
> >> A call to io_uring_submit() with a single openat op with a flag of
> >> IOSQE_ASYNC results in the following reference count updates.
> >>
> >> These first part of the system call performs two increments that do no=
t race.
> >>
> >> do_syscall_64()
> >>   __do_sys_io_uring_enter()
> >>     io_submit_sqes()
> >>       io_openat_prep()
> >>         __io_openat_prep()
> >>           getname()
> >>             getname_flags()       /* update 1 (increment) */
> >>               __audit_getname()   /* update 2 (increment) */
> >>
> >> The openat op is queued to an io_uring worker thread which starts the
> >> opportunity for a race.  The system call exit performs one decrement.
> >>
> >> do_syscall_64()
> >>   syscall_exit_to_user_mode()
> >>     syscall_exit_to_user_mode_prepare()
> >>       __audit_syscall_exit()
> >>         audit_reset_context()
> >>            putname()              /* update 3 (decrement) */
> >>
> >> The io_uring worker thread performs one increment and two decrements.
> >> These updates can race with the system call decrement.
> >>
> >> io_wqe_worker()
> >>   io_worker_handle_work()
> >>     io_wq_submit_work()
> >>       io_issue_sqe()
> >>         io_openat()
> >>           io_openat2()
> >>             do_filp_open()
> >>               path_openat()
> >>                 __audit_inode()   /* update 4 (increment) */
> >>             putname()             /* update 5 (decrement) */
> >>         __audit_uring_exit()
> >>           audit_reset_context()
> >>             putname()             /* update 6 (decrement) */
> >>
> >> The fix is to change the refcnt member of struct audit_names
> >> from int to atomic_t.
> >>
> >> kernel BUG at fs/namei.c:262!
> >> Call Trace:
> >> ...
> >>  ? putname+0x68/0x70
> >>  audit_reset_context.part.0.constprop.0+0xe1/0x300
> >>  __audit_uring_exit+0xda/0x1c0
> >>  io_issue_sqe+0x1f3/0x450
> >>  ? lock_timer_base+0x3b/0xd0
> >>  io_wq_submit_work+0x8d/0x2b0
> >>  ? __try_to_del_timer_sync+0x67/0xa0
> >>  io_worker_handle_work+0x17c/0x2b0
> >>  io_wqe_worker+0x10a/0x350
> >>
> >> Cc: <stable@vger.kernel.org>
> >> Link: https://lore.kernel.org/lkml/MW2PR2101MB1033FFF044A258F84AEAA584=
F1C9A@MW2PR2101MB1033.namprd21.prod.outlook.com/
> >> Fixes: 5bd2182d58e9 ("audit,io_uring,io-wq: add some basic audit suppo=
rt to io_uring")
> >> Signed-off-by: Dan Clash <daclash@linux.microsoft.com>
> >> ---
> >>  fs/namei.c         | 9 +++++----
> >>  include/linux/fs.h | 2 +-
> >>  kernel/auditsc.c   | 8 ++++----
> >>  3 files changed, 10 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/fs/namei.c b/fs/namei.c
> >> index 567ee547492b..94565bd7e73f 100644
> >> --- a/fs/namei.c
> >> +++ b/fs/namei.c
> >> @@ -188,7 +188,7 @@ getname_flags(const char __user *filename, int fla=
gs, int *empty)
> >>              }
> >>      }
> >>
> >> -    result->refcnt =3D 1;
> >> +    atomic_set(&result->refcnt, 1);
> >>      /* The empty path is special. */
> >>      if (unlikely(!len)) {
> >>              if (empty)
> >> @@ -249,7 +249,7 @@ getname_kernel(const char * filename)
> >>      memcpy((char *)result->name, filename, len);
> >>      result->uptr =3D NULL;
> >>      result->aname =3D NULL;
> >> -    result->refcnt =3D 1;
> >> +    atomic_set(&result->refcnt, 1);
> >>      audit_getname(result);
> >>
> >>      return result;
> >> @@ -261,9 +261,10 @@ void putname(struct filename *name)
> >>      if (IS_ERR(name))
> >>              return;
> >>
> >> -    BUG_ON(name->refcnt <=3D 0);
> >> +    if (WARN_ON_ONCE(!atomic_read(&name->refcnt)))
> >> +            return;
> >>
> >> -    if (--name->refcnt > 0)
> >> +    if (!atomic_dec_and_test(&name->refcnt))
> >>              return;
> >
> > Fine by me. I'd write this as:
> >
> > count =3D atomic_dec_if_positive(&name->refcnt);
> > if (WARN_ON_ONCE(unlikely(count < 0))
> >       return;
> > if (count > 0)
> >       return;
>
> Would be fine too, my suspicion was that most archs don't implement a
> primitive for that, and hence it might be more expensive than
> atomic_read()/atomic_dec_and_test() which do. But I haven't looked at
> the code generation. The dec_if_positive degenerates to a atomic cmpxchg
> for most cases.

I'm not too concerned, either approach works for me, the important bit
is moving to an atomic_t/refcount_t so we can protect ourselves
against the race.  The patch looks good to me and I'd like to get this
fix merged.

Dan, barring any further back-and-forth on the putname() change, I
would say to go ahead and make the change Christian suggested and
repost the patch.  Based on Jens comment above it seems safe to
preserve his 'Reviewed-by:' tag on the next revision.  Assuming there
are no objections posted in the meantime, I'll plan to merge the next
revision into the audit/stable-6.6 branch and get that up to Linus
(likely next week since it's Friday).

Thanks everyone!

--=20
paul-moore.com
