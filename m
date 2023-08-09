Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04A217762FF
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 16:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233935AbjHIOuB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 10:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233752AbjHIOuB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 10:50:01 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408082107
        for <io-uring@vger.kernel.org>; Wed,  9 Aug 2023 07:49:59 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-584243f84eeso79110777b3.0
        for <io-uring@vger.kernel.org>; Wed, 09 Aug 2023 07:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1691592598; x=1692197398;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CukD5gEv7v0vB/IpZcOsjBs6ZrQwHEdAXjUTqz1JxfU=;
        b=GZK3D/kdN5vwzK4nuaJmWVlmd3Vc0V+amg3bQLmnhAevhct8FDevPi8AHZMs5M11Se
         yKfb4wNDEC6NImhiWdYifr/LtaiB7fQOopFcEdzYJ8GKKZEr3BwrU59aGxzaBG9t7UgI
         IypqqfLDeovNtkQJAqlQlyW+hgmpWnrjixOaV3q/oZsev5Sv+WgX5Q70wltEiDAZVK2G
         J730GyVeQyf1rVhfiV+pBNt/+qwFZuPfHp6I4MRuFA4RwE0QPWIf1+O3bPVQbuxHhEWR
         7P/XxqtNIxp+BjYe27nLo2nszNbWuJT4KczpXdgTUNT+1uaAXAoA3XEZ+t/8OKK5tMZC
         JSXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691592598; x=1692197398;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CukD5gEv7v0vB/IpZcOsjBs6ZrQwHEdAXjUTqz1JxfU=;
        b=A54mWcphQn9fpzncfhpSgm1xUPbwsJAfmKRuCG1GfmbDuMxCkq2xj2Lq0pqQvCjQvu
         706VlLFrt3RnK2TPtOsXqHDsilfUCOnC9EWeIUuZlPuynnLwWGKToAGKyhCsRMHiUoLd
         f7yw9LPfiePYq0cpE6oJlRSYvMdJc1xMFTYkUfCJPf/S/nSLqw0/T2OVlqAB3hxEZlHE
         cQXHtGG+eNbLovwzI1U5UftMonbbVc1xY2Wb1uEbv95yyUhY8eZQBdvnQpmNXY9yirSB
         z8zHpp94J4UY1XFJMdvp22LWNuHQPhXCRdEN5tm6527qszL8ozDWFGdJ3u/mLTJMS8s0
         GBpg==
X-Gm-Message-State: AOJu0YwPU6+M/5xpDKV2c1Mtq8jOj53JyMHvdMYO90tyCh6WT+53ESwM
        Fa6jmqswWgzRcRzX4sw3FJ26R/FcfpE1ddZJzjzO
X-Google-Smtp-Source: AGHT+IH7hCb8h0oClaW9sIOSnHDNdPlIZHza4ZeYJg9Tf5MPGHsreOC8337g1w3nu2yMm1U4RKLa193R9rsQ8FlSWGs=
X-Received: by 2002:a0d:f942:0:b0:586:a199:91f1 with SMTP id
 j63-20020a0df942000000b00586a19991f1mr3329846ywf.24.1691592598300; Wed, 09
 Aug 2023 07:49:58 -0700 (PDT)
MIME-Version: 1.0
References: <20221107205754.2635439-1-cukie@google.com> <CAHC9VhTLBWkw2XzqdFx1LFVKDtaAL2pEfsmm+LEmS0OWM1mZgA@mail.gmail.com>
 <CABXk95ChjusTneWJgj5a58CZceZv0Ay-P-FwBcH2o4rO0g2Ggw@mail.gmail.com>
 <CAHC9VhRTWGuiMpJJiFrUpgsm7nQaNA-n1CYRMPS-24OLvzdA2A@mail.gmail.com>
 <54c8fd9c-0edd-7fea-fd7a-5618859b0827@semihalf.com> <CAHC9VhS9BXTUjcFy-URYhG=XSxBC+HsePbu01_xBGzM8sebCYQ@mail.gmail.com>
 <d2eaa3f8-cca6-2f51-ce98-30242c528b6f@semihalf.com>
In-Reply-To: <d2eaa3f8-cca6-2f51-ce98-30242c528b6f@semihalf.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 9 Aug 2023 10:49:47 -0400
Message-ID: <CAHC9VhQDAM8X-MV9ONckc2NBWDZrsMteanDo9_NS4SirdQAx=w@mail.gmail.com>
Subject: Re: [PATCH v1 0/2] Add LSM access controls for io_uring_setup
To:     Dmytro Maluka <dmy@semihalf.com>
Cc:     Jeffrey Vander Stoep <jeffv@google.com>,
        Gil Cukierman <cukie@google.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        Joel Granados <j.granados@samsung.com>,
        Jeff Xu <jeffxu@google.com>,
        Takaya Saeki <takayas@chromium.org>,
        Tomasz Nowicki <tn@semihalf.com>,
        Matteo Rizzo <matteorizzo@google.com>,
        Andres Freund <andres@anarazel.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 9, 2023 at 7:22=E2=80=AFAM Dmytro Maluka <dmy@semihalf.com> wro=
te:
> On 8/9/23 02:31, Paul Moore wrote:
> > On Tue, Aug 8, 2023 at 4:40=E2=80=AFPM Dmytro Maluka <dmy@semihalf.com>=
 wrote:
> >> On 11/10/22 22:04, Paul Moore wrote:
> >>> On Thu, Nov 10, 2022 at 12:54 PM Jeffrey Vander Stoep <jeffv@google.c=
om> wrote:
> >>>> On Mon, Nov 7, 2022 at 10:17 PM Paul Moore <paul@paul-moore.com> wro=
te:
> >>>>>
> >>>>> On Mon, Nov 7, 2022 at 3:58 PM Gil Cukierman <cukie@google.com> wro=
te:
> >>>>>>
> >>>>>> This patchset provides the changes required for controlling access=
 to
> >>>>>> the io_uring_setup system call by LSMs. It does this by adding a n=
ew
> >>>>>> hook to io_uring. It also provides the SELinux implementation for =
a new
> >>>>>> permission, io_uring { setup }, using the new hook.
> >>>>>>
> >>>>>> This is important because existing io_uring hooks only support lim=
iting
> >>>>>> the sharing of credentials and access to the sensitive uring_cmd f=
ile
> >>>>>> op. Users of LSMs may also want the ability to tightly control whi=
ch
> >>>>>> callers can retrieve an io_uring capable fd from the kernel, which=
 is
> >>>>>> needed for all subsequent io_uring operations.
> >>>>>
> >>>>> It isn't immediately obvious to me why simply obtaining a io_uring =
fd
> >>>>> from io_uring_setup() would present a problem, as the security
> >>>>> relevant operations that are possible with that io_uring fd *should=
*
> >>>>> still be controlled by other LSM hooks.  Can you help me understand
> >>>>> what security issue you are trying to resolve with this control?
> >>>>
> >>>> I think there are a few reasons why we want this particular hook.
> >>>>
> >>>> 1.  It aligns well with how other resources are managed by selinux
> >>>> where access to the resource is the first control point (e.g. "creat=
e"
> >>>> for files, sockets, or bpf_maps, "prog_load" for bpf programs, and
> >>>> "open" for perf_event) and then additional functionality or
> >>>> capabilities require additional permissions.
> >>>
> >>> [NOTE: there were two reply sections in your email, and while similar=
,
> >>> they were not identical; I've trimmed the other for the sake of
> >>> clarity]
> >>>
> >>> The resources you mention are all objects which contain some type of
> >>> information (either user data, configuration, or program
> >>> instructions), with the resulting fd being a handle to those objects.
> >>> In the case of io_uring the fd is a handle to the io_uring
> >>> interface/rings, which by itself does not contain any information
> >>> which is not already controlled by other permissions.
> >>>
> >>> I/O operations which transfer data between the io_uring buffers and
> >>> other system objects, e.g. IORING_OP_READV, are still subject to the
> >>> same file access controls as those done by the application using
> >>> syscalls.  Even the IORING_OP_OPENAT command goes through the standar=
d
> >>> VFS code path which means it will trigger the same access control
> >>> checks as an open*() done by the application normally.
> >>>
> >>> The 'interesting' scenarios are those where the io_uring operation
> >>> servicing credentials, aka personalities, differ from the task
> >>> controlling the io_uring.  However in those cases we have the new
> >>> io_uring controls to gate these delegated operations.  Passing an
> >>> io_uring fd is subject to the fd/use permission like any other fd.
> >>>
> >>> Although perhaps the most relevant to your request is the fact that
> >>> the io_uring inode is created using the new(ish) secure anon inode
> >>> interface which ensures that the creating task has permission to
> >>> create an io_uring.  This io_uring inode label also comes into play
> >>> when a task attempts to mmap() the io_uring rings, a critical part of
> >>> the io_uring API.
> >>>
> >>> If I'm missing something you believe to be important, please share th=
e details.
> >>>
> >>>> 2. It aligns well with how resources are managed on Android. We ofte=
n
> >>>> do not grant direct access to resources (like memory buffers).
> >>>
> >>> Accessing the io_uring buffers requires a task to mmap() the io_uring
> >>> fd which is controlled by the normal SELinux mmap() access controls.
> >>>
> >>>> 3. Attack surface management. One of the primary uses of selinux on
> >>>> Android is to assess and limit attack surface (e.g.
> >>>> https://twitter.com/jeffvanderstoep/status/1422771606309335043) . As
> >>>> io_uring vulnerabilities have made their way through our vulnerabili=
ty
> >>>> management system, it's become apparent that it's complicated to
> >>>> assess the impact. Is a use-after-free reachable? Creating
> >>>> proof-of-concept exploits takes a lot of time, and often functionali=
ty
> >>>> can be reached by multiple paths. How many of the known io_uring
> >>>> vulnerabilities would be gated by the existing checks? How many futu=
re
> >>>> ones will be gated by the existing checks? I don't know the answer t=
o
> >>>> either of these questions and it's not obvious. This hook makes that
> >>>> initial assessment simple and effective.
> >>>
> >>> It should be possible to deny access to io_uring via the anonymous
> >>> inode labels, the mmap() controls, and the fd/use permission.  If you
> >>> find a way to do meaningful work with an io_uring fd that can't be
> >>> controlled via an existing permission check please let me know.
> >>
> >> Thank you a lot for this explanation. However, IMHO we should not
> >> confuse 2 somewhat different problems here:
> >>
> >> - protecting io_uring related resources (file descriptors, memory
> >>   buffers) against unauthorized access
> >>
> >> - protecting the entire system against potential vulnerabilities in
> >>   io_uring
> >>
> >> And while I agree that the existing permission checks should be alread=
y
> >> sufficient for the former, I'm not quite sure they are sufficient for
> >> the latter.
> >
> > ...
> >
> >> I already have a PoC patch [3] adding such LSM hook. But before I try =
to
> >> submit it for upstream, I'd like to know your opinion on the whole ide=
a.
> >
> > First please explain how the existing LSM/SELinux control points are
> > not sufficient for restricting io_uring operations.  I'm looking for a
> > real program flow that is able to "do meaningful work with an io_uring
> > fd that can't be controlled via an existing permission check".
>
> As I said at the beginning of my reply, I agree with you that the
> existing LSM controls are sufficient for restricting io_uring I/O
> operations. That is not my concern here. The concern is: how to (and
> do we need to) restrict triggering execution of *any* io_uring code in
> kernel, *in addition to* restricting the actual io_uring operations.

If your concern is preventing *any* io_uring code from being executed,
I would suggest simply not enabling io_uring at build time.  If you
need to selectively enable io_uring for some subset of processes, you
will need to make use of one of the options you discussed previously,
e.g. a LSM, seccomp, etc.

From a LSM perspective, I don't believe we want to be in the business
of blocking entire kernel subsystems from execution, rather we want to
provide control points so that admins and users can have better, or
more granular control over the security relevant operations that take
place within the different kernel subsystems.

> In other words, "a real program doing a meaningful work with io_uring"
> in this case would mean "an exploit for a real vulnerability in io_uring
> code (in the current or any older kernel) which does not require an
> access to io_uring operations to be exploited". I don't claim that such
> vulnerabilities exist or are likely to be introduced in future kernels.
> But I'm neither an io_uring expert nor, more importantly, a security
> expert, so I cannot tell with confidence that they are not and we have
> nothing to worry about here. So I'm interested in your and others'
> opinion on that.

Once again, if you have serious concerns about the security or safety
of an individual kernel subsystem, your best option is to simply build
a kernel without that subsystem enabled.

--=20
paul-moore.com
