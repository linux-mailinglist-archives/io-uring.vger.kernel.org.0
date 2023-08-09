Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8F1B774FD7
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 02:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbjHIAbb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Aug 2023 20:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbjHIAb3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Aug 2023 20:31:29 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FCBE1999
        for <io-uring@vger.kernel.org>; Tue,  8 Aug 2023 17:31:28 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-58969d4f1b6so21592567b3.2
        for <io-uring@vger.kernel.org>; Tue, 08 Aug 2023 17:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1691541088; x=1692145888;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qDPjBC8+GKfrwh/2j/isKz4xyOzDpusZBbPx7/KGwpQ=;
        b=F7iNzg3oXqm0eAO5nUB8lTtwbEWUlbHqvhTa2ynYo1WZ0Ka15pzvtEouj92CsE0YN6
         tZyHVibZmy3brYk7HDkuRjQKCVT7J/MM4/VKc/V2ariiOsxS63/odFeu0XEcVtm0gzVC
         aHMwKXneleogDweXHy37z8sH8RMMo3rhq+12/TjvWSyKRl5Ytnx8TXpq/dkkJrXzkeZU
         BaUWlM6Qi/ZtJZY8wkoj0kQxe6jRhWuEfMzurkfPND/s5wXTRxlWnk+Rixo8tBk+qguN
         4vXNGVd/qgFB/SECFGOIGMMB3lJeQmVfZVvoXC/ocUK+3V2y35+sv2dS7x5U8N0dmRG4
         9OBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691541088; x=1692145888;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qDPjBC8+GKfrwh/2j/isKz4xyOzDpusZBbPx7/KGwpQ=;
        b=VFXhiqsbR55p/Ht5oWkUDi8F1nLvoOvvJPvB+TPdn5wy69L5BdQudBn6ZugASaI4Xn
         i647TKdHMxJE3HtpJMGsttMHKH6TGQxk/+WJ03EIs5qGijJrhkCbmZG7XV5JESQDM0Lu
         OmWa4CqVumLdMzLwrZhIVtTIKN0cFNI4jZ7dTRh+DZrIEjC5eBL3fqdVASmUR5WvSnLx
         JPz0NRXO7rcI4d7HaGWgnpzJyUgGaxcvYELXSL1DEB+QIEHWNlC5F2wmcMFVbPQJ5S5N
         MJ5J2gJLzyo0PuPwwzPUTSyVaFvGd0zY1IQN51VKgiTdN7lIZGuC/S5PX/p0Glw8Atf3
         F6Ag==
X-Gm-Message-State: AOJu0YwlKxhQEPtZCXD/1hoGvvJD21mI0GEaWus29E3ZOifgIm0/Z8Uj
        YLgwcml8uiN+23sSRzpR4A+C2y+L0V9rYcZcTo5L
X-Google-Smtp-Source: AGHT+IGsUcXT2H3THGaY3XqaFr4AzJ9iyeNnN/443IuS45Eon7soBe+EuCmUx/rX+DbM9cXGUPrXETzkqiHIg7FxWu0=
X-Received: by 2002:a0d:d4cb:0:b0:57a:1863:755c with SMTP id
 w194-20020a0dd4cb000000b0057a1863755cmr1108881ywd.15.1691541087826; Tue, 08
 Aug 2023 17:31:27 -0700 (PDT)
MIME-Version: 1.0
References: <20221107205754.2635439-1-cukie@google.com> <CAHC9VhTLBWkw2XzqdFx1LFVKDtaAL2pEfsmm+LEmS0OWM1mZgA@mail.gmail.com>
 <CABXk95ChjusTneWJgj5a58CZceZv0Ay-P-FwBcH2o4rO0g2Ggw@mail.gmail.com>
 <CAHC9VhRTWGuiMpJJiFrUpgsm7nQaNA-n1CYRMPS-24OLvzdA2A@mail.gmail.com> <54c8fd9c-0edd-7fea-fd7a-5618859b0827@semihalf.com>
In-Reply-To: <54c8fd9c-0edd-7fea-fd7a-5618859b0827@semihalf.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 8 Aug 2023 20:31:17 -0400
Message-ID: <CAHC9VhS9BXTUjcFy-URYhG=XSxBC+HsePbu01_xBGzM8sebCYQ@mail.gmail.com>
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
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 8, 2023 at 4:40=E2=80=AFPM Dmytro Maluka <dmy@semihalf.com> wro=
te:
> On 11/10/22 22:04, Paul Moore wrote:
> > On Thu, Nov 10, 2022 at 12:54 PM Jeffrey Vander Stoep <jeffv@google.com=
> wrote:
> >> On Mon, Nov 7, 2022 at 10:17 PM Paul Moore <paul@paul-moore.com> wrote=
:
> >>>
> >>> On Mon, Nov 7, 2022 at 3:58 PM Gil Cukierman <cukie@google.com> wrote=
:
> >>>>
> >>>> This patchset provides the changes required for controlling access t=
o
> >>>> the io_uring_setup system call by LSMs. It does this by adding a new
> >>>> hook to io_uring. It also provides the SELinux implementation for a =
new
> >>>> permission, io_uring { setup }, using the new hook.
> >>>>
> >>>> This is important because existing io_uring hooks only support limit=
ing
> >>>> the sharing of credentials and access to the sensitive uring_cmd fil=
e
> >>>> op. Users of LSMs may also want the ability to tightly control which
> >>>> callers can retrieve an io_uring capable fd from the kernel, which i=
s
> >>>> needed for all subsequent io_uring operations.
> >>>
> >>> It isn't immediately obvious to me why simply obtaining a io_uring fd
> >>> from io_uring_setup() would present a problem, as the security
> >>> relevant operations that are possible with that io_uring fd *should*
> >>> still be controlled by other LSM hooks.  Can you help me understand
> >>> what security issue you are trying to resolve with this control?
> >>
> >> I think there are a few reasons why we want this particular hook.
> >>
> >> 1.  It aligns well with how other resources are managed by selinux
> >> where access to the resource is the first control point (e.g. "create"
> >> for files, sockets, or bpf_maps, "prog_load" for bpf programs, and
> >> "open" for perf_event) and then additional functionality or
> >> capabilities require additional permissions.
> >
> > [NOTE: there were two reply sections in your email, and while similar,
> > they were not identical; I've trimmed the other for the sake of
> > clarity]
> >
> > The resources you mention are all objects which contain some type of
> > information (either user data, configuration, or program
> > instructions), with the resulting fd being a handle to those objects.
> > In the case of io_uring the fd is a handle to the io_uring
> > interface/rings, which by itself does not contain any information
> > which is not already controlled by other permissions.
> >
> > I/O operations which transfer data between the io_uring buffers and
> > other system objects, e.g. IORING_OP_READV, are still subject to the
> > same file access controls as those done by the application using
> > syscalls.  Even the IORING_OP_OPENAT command goes through the standard
> > VFS code path which means it will trigger the same access control
> > checks as an open*() done by the application normally.
> >
> > The 'interesting' scenarios are those where the io_uring operation
> > servicing credentials, aka personalities, differ from the task
> > controlling the io_uring.  However in those cases we have the new
> > io_uring controls to gate these delegated operations.  Passing an
> > io_uring fd is subject to the fd/use permission like any other fd.
> >
> > Although perhaps the most relevant to your request is the fact that
> > the io_uring inode is created using the new(ish) secure anon inode
> > interface which ensures that the creating task has permission to
> > create an io_uring.  This io_uring inode label also comes into play
> > when a task attempts to mmap() the io_uring rings, a critical part of
> > the io_uring API.
> >
> > If I'm missing something you believe to be important, please share the =
details.
> >
> >> 2. It aligns well with how resources are managed on Android. We often
> >> do not grant direct access to resources (like memory buffers).
> >
> > Accessing the io_uring buffers requires a task to mmap() the io_uring
> > fd which is controlled by the normal SELinux mmap() access controls.
> >
> >> 3. Attack surface management. One of the primary uses of selinux on
> >> Android is to assess and limit attack surface (e.g.
> >> https://twitter.com/jeffvanderstoep/status/1422771606309335043) . As
> >> io_uring vulnerabilities have made their way through our vulnerability
> >> management system, it's become apparent that it's complicated to
> >> assess the impact. Is a use-after-free reachable? Creating
> >> proof-of-concept exploits takes a lot of time, and often functionality
> >> can be reached by multiple paths. How many of the known io_uring
> >> vulnerabilities would be gated by the existing checks? How many future
> >> ones will be gated by the existing checks? I don't know the answer to
> >> either of these questions and it's not obvious. This hook makes that
> >> initial assessment simple and effective.
> >
> > It should be possible to deny access to io_uring via the anonymous
> > inode labels, the mmap() controls, and the fd/use permission.  If you
> > find a way to do meaningful work with an io_uring fd that can't be
> > controlled via an existing permission check please let me know.
>
> Thank you a lot for this explanation. However, IMHO we should not
> confuse 2 somewhat different problems here:
>
> - protecting io_uring related resources (file descriptors, memory
>   buffers) against unauthorized access
>
> - protecting the entire system against potential vulnerabilities in
>   io_uring
>
> And while I agree that the existing permission checks should be already
> sufficient for the former, I'm not quite sure they are sufficient for
> the latter.

...

> I already have a PoC patch [3] adding such LSM hook. But before I try to
> submit it for upstream, I'd like to know your opinion on the whole idea.

First please explain how the existing LSM/SELinux control points are
not sufficient for restricting io_uring operations.  I'm looking for a
real program flow that is able to "do meaningful work with an io_uring
fd that can't be controlled via an existing permission check".

--=20
paul-moore.com
