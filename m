Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C48981FAF43
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2020 13:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728640AbgFPLdZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Jun 2020 07:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728635AbgFPLdX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Jun 2020 07:33:23 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491D5C08C5C2
        for <io-uring@vger.kernel.org>; Tue, 16 Jun 2020 04:33:23 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id z9so23065014ljh.13
        for <io-uring@vger.kernel.org>; Tue, 16 Jun 2020 04:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xXpGsaf6/t1/UiE0oOHiYv8kEoRrgHAiW4t8lS6jlzI=;
        b=YDrEV/nYXcxcVf/hCmEXrPu/Jv6dEdPyFhitALAoFiI2z7ZHQfWeC8g5ofXWQ602nT
         a9/Ei3c57uxIGxnUYP1vqzxywcJrB58KgmavOfTYNSy9P2FIPdpvFoi9yr7XKRKp3JVw
         JfNBwfnEjlHelGGI4r0j9FsUZgOqVvVx+WMbNFX/3zXxSah7/+FdJsOHC61nzi4qK1k/
         h/fuAagUB1WYdifHftNn9dc1GrjHJenXrsZF12jF3rdEw2G1DU1Hl8JCFB9dHiNFnUlj
         m4MuoVlyED08uLrtyNXMH0FCIvIJRy6yWuya04K96n+vc39GoICEauhXPn5wrbFV6rsV
         2aoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xXpGsaf6/t1/UiE0oOHiYv8kEoRrgHAiW4t8lS6jlzI=;
        b=e0kFd9Up1exWRS/G29FmSzMlrLNUniMo5qrbdWZ9e6jRqM9ZK3iJEo5pHYBo+7dhaD
         KgsA4/j8Iqmo8T2JuQ076wTgUwDmFtanGQJNWGS9lrqH49HIbVO01Oc+6kQFbSia9WSl
         CET4Ei2xqm8BvhVfBCowIF8OQLew6wzwuNu3YpWg1qhoRxRpEDpT9DrbgKwgQ1TiU9SK
         eAH0TDA7tBVMsyXpwYBJG5uZ2o1ixwo58DBAdbi622kuG1dDt/QkOdfKtxE03eT5s3Lm
         bJYdPQ/LwZtYC9WnX9ovySD3fCYUNzspcSR2LgZU8QojPVO7WseXLhM9u8BcF35FIWjm
         zFIA==
X-Gm-Message-State: AOAM530Kxuxg1qL50mYJlfWUi8gZZaSdxeUf99hOqR0iaKnkVD17+c5y
        MdMIMtZb8X3dYSvnxBYnaUIMNH5GrhCydFEPdzzr6w==
X-Google-Smtp-Source: ABdhPJzv38zZQGodUB3dlEaatmrXMcxTNcgfAfArIu4PT76XlM3dr9hqgTduMg/QY76sLseMHYpJCp8XDSTJ2LIx/8U=
X-Received: by 2002:a2e:9a44:: with SMTP id k4mr1157571ljj.139.1592307201386;
 Tue, 16 Jun 2020 04:33:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200609142406.upuwpfmgqjeji4lc@steredhat> <CAG48ez3kdNKjif==MbX36cKNYDpZwEPMZaJQ1rrpXZZjGZwbKw@mail.gmail.com>
 <20200615133310.qwdmnctrir5zgube@steredhat> <f7f2841e-3dbb-377f-f8f8-826506a938a6@kernel.dk>
 <20200616091247.hdmxcrnlrrxih7my@steredhat>
In-Reply-To: <20200616091247.hdmxcrnlrrxih7my@steredhat>
From:   Jann Horn <jannh@google.com>
Date:   Tue, 16 Jun 2020 13:32:54 +0200
Message-ID: <CAG48ez2n5t7zkm7H_bPAcxz6KT25TrMp3sLZ3BhpMHaCQqcArQ@mail.gmail.com>
Subject: Re: [RFC] io_uring: add restrictions to support untrusted
 applications and guests
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Kees Cook <keescook@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Sargun Dhillon <sargun@sargun.me>,
        Aleksa Sarai <asarai@suse.de>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>,
        io-uring <io-uring@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jun 16, 2020 at 11:13 AM Stefano Garzarella <sgarzare@redhat.com> wrote:
> On Mon, Jun 15, 2020 at 11:00:25AM -0600, Jens Axboe wrote:
> > On 6/15/20 7:33 AM, Stefano Garzarella wrote:
> > > On Mon, Jun 15, 2020 at 11:04:06AM +0200, Jann Horn wrote:
> > >> +Kees, Christian, Sargun, Aleksa, kernel-hardening for their opinions
> > >> on seccomp-related aspects
> > >>
> > >> On Tue, Jun 9, 2020 at 4:24 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
> > >>> Hi Jens,
> > >>> Stefan and I have a proposal to share with io_uring community.
> > >>> Before implementing it we would like to discuss it to receive feedbacks and
> > >>> to see if it could be accepted:
> > >>>
> > >>> Adding restrictions to io_uring
> > >>> =====================================
> > >>> The io_uring API provides submission and completion queues for performing
> > >>> asynchronous I/O operations. The queues are located in memory that is
> > >>> accessible to both the host userspace application and the kernel, making it
> > >>> possible to monitor for activity through polling instead of system calls. This
> > >>> design offers good performance and this makes exposing io_uring to guests an
> > >>> attractive idea for improving I/O performance in virtualization.
> > >> [...]
> > >>> Restrictions
> > >>> ------------
> > >>> This document proposes io_uring API changes that safely allow untrusted
> > >>> applications or guests to use io_uring. io_uring's existing security model is
> > >>> that of kernel system call handler code. It is designed to reject invalid
> > >>> inputs from host userspace applications. Supporting guests as io_uring API
> > >>> clients adds a new trust domain with access to even fewer resources than host
> > >>> userspace applications.
> > >>>
> > >>> Guests do not have direct access to host userspace application file descriptors
> > >>> or memory. The host userspace application, a Virtual Machine Monitor (VMM) such
> > >>> as QEMU, grants access to a subset of its file descriptors and memory. The
> > >>> allowed file descriptors are typically the disk image files belonging to the
> > >>> guest. The memory is typically the virtual machine's RAM that the VMM has
> > >>> allocated on behalf of the guest.
> > >>>
> > >>> The following extensions to the io_uring API allow the host application to
> > >>> grant access to some of its file descriptors.
> > >>>
> > >>> These extensions are designed to be applicable to other use cases besides
> > >>> untrusted guests and are not virtualization-specific. For example, the
> > >>> restrictions can be used to allow only a subset of sqe operations available to
> > >>> an application similar to seccomp syscall whitelisting.
> > >>>
> > >>> An address translation and memory restriction mechanism would also be
> > >>> necessary, but we can discuss this later.
> > >>>
> > >>> The IOURING_REGISTER_RESTRICTIONS opcode
> > >>> ----------------------------------------
> > >>> The new io_uring_register(2) IOURING_REGISTER_RESTRICTIONS opcode permanently
> > >>> installs a feature whitelist on an io_ring_ctx. The io_ring_ctx can then be
> > >>> passed to untrusted code with the knowledge that only operations present in the
> > >>> whitelist can be executed.
> > >>
> > >> This approach of first creating a normal io_uring instance and then
> > >> installing restrictions separately in a second syscall means that it
> > >> won't be possible to use seccomp to restrict newly created io_uring
> > >> instances; code that should be subject to seccomp restrictions and
> > >> uring restrictions would only be able to use preexisting io_uring
> > >> instances that have already been configured by trusted code.
> > >>
> > >> So I think that from the seccomp perspective, it might be preferable
> > >> to set up these restrictions in the io_uring_setup() syscall. It might
> > >> also be a bit nicer from a code cleanliness perspective, since you
> > >> won't have to worry about concurrently changing restrictions.
> > >>
> > >
> > > Thank you for these details!
> > >
> > > It seems feasible to include the restrictions during io_uring_setup().
> > >
> > > The only doubt concerns the possibility of allowing the trusted code to
> > > do some operations, before passing queues to the untrusted code, for
> > > example registering file descriptors, buffers, eventfds, etc.
> > >
> > > To avoid this, I should include these operations in io_uring_setup(),
> > > adding some code that I wanted to avoid by reusing io_uring_register().
> > >
> > > If I add restrictions in io_uring_setup() and then add an operation to
> > > go into safe mode (e.g. a flag in io_uring_enter()), we would have the same
> > > problem, right?
> > >
> > > Just to be clear, I mean something like this:
> > >
> > >     /* params will include restrictions */
> > >     fd = io_uring_setup(entries, params);
> > >
> > >     /* trusted code */
> > >     io_uring_register_files(fd, ...);
> > >     io_uring_register_buffers(fd, ...);
> > >     io_uring_register_eventfd(fd, ...);
> > >
> > >     /* enable safe mode */
> > >     io_uring_enter(fd, ..., IORING_ENTER_ENABLE_RESTRICTIONS);
> > >
> > >
> > > Anyway, including a list of things to register in the 'params', passed
> > > to io_uring_setup(), should be feasible, if Jens agree :-)
> >
> > I wonder how best to deal with this, in terms of ring visibility vs
> > registering restrictions. We could potentially start the ring in a
> > disabled mode, if asked to. It'd still be visible in terms of having
> > the fd installed, but it'd just error requests. That'd leave you with
> > time to do the various setup routines needed before then flagging it
> > as enabled. My only worry on that would be adding overhead for doing
> > that. It'd be cheap enough to check for IORING_SETUP_DISABLED in
> > ctx->flags in io_uring_enter(), and return -EBADFD or something if
> > that's the case. That doesn't cover the SQPOLL case though, but maybe we
> > just don't start the sq thread if IORING_SETUP_DISABLED is set.
>
> It seems to me a very good approach and easy to implement. In this way
> we can reuse io_uring_register() without having to modify too much
> io_uring_setup().
>
> >
> > We'd need a way to clear IORING_SETUP_DISABLED through
> > io_uring_register(). When clearing, that could then start the sq thread
> > as well, when SQPOLL is set.
>
> Could we do it using io_uring_enter() since we have a flag field or
> do you think it's semantically incorrect?
>
> @Jann, do you think this could work with seccomp?

To clarify that I understood your proposal correctly: Is the idea to
have two types of mostly orthogonal restrictions; one type being
restrictions on the opcode (supplied in io_uring_setup() and enforced
immediately) and the other type being restrictions on
io_uring_register() (enabled via IORING_ENTER_ENABLE_RESTRICTIONS)?

That sounds fine to me. IORING_ENTER_ENABLE_RESTRICTIONS probably
isn't necessary for your usecase though, right? Or is the idea to use
that to suppress grace periods during setup in io_uring_register(), or
something like that?
