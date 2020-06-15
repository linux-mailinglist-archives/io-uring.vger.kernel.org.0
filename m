Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA3F1FA415
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2020 01:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbgFOX0j (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Jun 2020 19:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725960AbgFOX0i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Jun 2020 19:26:38 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12957C061A0E
        for <io-uring@vger.kernel.org>; Mon, 15 Jun 2020 16:26:38 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id i27so21230157ljb.12
        for <io-uring@vger.kernel.org>; Mon, 15 Jun 2020 16:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t36AfAxmVUPgFShxugWx8vpo7Nh3/W7qrT3GE6ix9Cw=;
        b=v6geb5iM6AHcjCpEZnHGSzpWg0GuVfHjaK68MaNpr+UGU6zR41cP8Y1jAAQ3lbEilz
         VlN8zU7ncNIKGy7DDFyPb/Yj8s2JKFfSEtczq6oK1znWXgRqulKDeortwlvoAhmwFXmg
         QmJA3c9gtahBDqLrkBiBKeaVQjgyVZI4O1cOwY8E4mVk0mQqkpkedKpROhIdk/MsNmiv
         T/J9mwsxBHzba/0pmSDxdj5nPHTYjkqdQ0HURBvm7puPYmZt7PqqchJYmyqdUt8HHiYp
         DQC2GJ07KRu5R6krZ0q7ZPBjU9bK3Q/qGBevJpIFgnaa9MTEZDQNSOy56uyOiBnodppU
         WmWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t36AfAxmVUPgFShxugWx8vpo7Nh3/W7qrT3GE6ix9Cw=;
        b=pKoG/8riI06EJOlShp3aJZV87ydNrL5rjHT6msqYM18sZSD2TEsijU20JQ7OCdcwjc
         wOp7OejbnNSirlVVMLRGKMPTMKl6kSIGWxjGvqscelvloD/Sal8qxM8VeNoiUcaxXtin
         RjHwrDLTCLcospm2kGCfg7+mam2f5ffR+0I+8y0oBsiglM5QZLhcFUR5dgWEYXpgKOVi
         HNQV8EftsG5aG+3Rn9OOHv1A1N/Z2z7z4dh2MVsdEUiby+N0OR132htFfxXEoG9ns8dF
         bdvYaXh2G0ceiY70rUVKbgSoaPN9zWRvwMAPEapEJO5EJLM4iTVLSDMJjMQ7NSbyTLi2
         Wblg==
X-Gm-Message-State: AOAM533XtiFZFm+WwcdJhY08yJjzqw0Up7XIqiLyfoW16dWzHQFb6gII
        iCC9ru1MCyWCgOv/DdL8iKQSiHxqSp+g5EDnrDphdQ==
X-Google-Smtp-Source: ABdhPJy4UCD34ksC6HjtziYgqG6/oUIJyz4mVdKKfo9S8Dn3XQi1qU2VgKJpOgYlopCK36rFQ+Eukt7xq4Ylp48oJyo=
X-Received: by 2002:a2e:7f02:: with SMTP id a2mr44239ljd.138.1592263595797;
 Mon, 15 Jun 2020 16:26:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200609142406.upuwpfmgqjeji4lc@steredhat> <CAG48ez3kdNKjif==MbX36cKNYDpZwEPMZaJQ1rrpXZZjGZwbKw@mail.gmail.com>
 <20200615220143.qrm4ffbkpaew4xdv@wittgenstein>
In-Reply-To: <20200615220143.qrm4ffbkpaew4xdv@wittgenstein>
From:   Jann Horn <jannh@google.com>
Date:   Tue, 16 Jun 2020 01:26:09 +0200
Message-ID: <CAG48ez17MLcj83JDOr6_GeQZ8orqL3EKHt6X=0wfr5RODVqqDA@mail.gmail.com>
Subject: Re: [RFC] io_uring: add restrictions to support untrusted
 applications and guests
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Sargun Dhillon <sargun@sargun.me>,
        Aleksa Sarai <asarai@suse.de>, Jens Axboe <axboe@kernel.dk>,
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

On Tue, Jun 16, 2020 at 12:01 AM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> On Mon, Jun 15, 2020 at 11:04:06AM +0200, Jann Horn wrote:
> > +Kees, Christian, Sargun, Aleksa, kernel-hardening for their opinions
> > on seccomp-related aspects
>
> Just fyi, I'm on holiday this week so my responses have some
> non-significant lag into early next week.
>
> >
> > On Tue, Jun 9, 2020 at 4:24 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
> > > Hi Jens,
> > > Stefan and I have a proposal to share with io_uring community.
> > > Before implementing it we would like to discuss it to receive feedbacks and
> > > to see if it could be accepted:
> > >
> > > Adding restrictions to io_uring
> > > =====================================
> > > The io_uring API provides submission and completion queues for performing
> > > asynchronous I/O operations. The queues are located in memory that is
> > > accessible to both the host userspace application and the kernel, making it
> > > possible to monitor for activity through polling instead of system calls. This
> > > design offers good performance and this makes exposing io_uring to guests an
> > > attractive idea for improving I/O performance in virtualization.
> > [...]
> > > Restrictions
> > > ------------
> > > This document proposes io_uring API changes that safely allow untrusted
> > > applications or guests to use io_uring. io_uring's existing security model is
> > > that of kernel system call handler code. It is designed to reject invalid
> > > inputs from host userspace applications. Supporting guests as io_uring API
> > > clients adds a new trust domain with access to even fewer resources than host
> > > userspace applications.
> > >
> > > Guests do not have direct access to host userspace application file descriptors
> > > or memory. The host userspace application, a Virtual Machine Monitor (VMM) such
> > > as QEMU, grants access to a subset of its file descriptors and memory. The
> > > allowed file descriptors are typically the disk image files belonging to the
> > > guest. The memory is typically the virtual machine's RAM that the VMM has
> > > allocated on behalf of the guest.
> > >
> > > The following extensions to the io_uring API allow the host application to
> > > grant access to some of its file descriptors.
> > >
> > > These extensions are designed to be applicable to other use cases besides
> > > untrusted guests and are not virtualization-specific. For example, the
> > > restrictions can be used to allow only a subset of sqe operations available to
> > > an application similar to seccomp syscall whitelisting.
> > >
> > > An address translation and memory restriction mechanism would also be
> > > necessary, but we can discuss this later.
> > >
> > > The IOURING_REGISTER_RESTRICTIONS opcode
> > > ----------------------------------------
> > > The new io_uring_register(2) IOURING_REGISTER_RESTRICTIONS opcode permanently
> > > installs a feature whitelist on an io_ring_ctx. The io_ring_ctx can then be
> > > passed to untrusted code with the knowledge that only operations present in the
> > > whitelist can be executed.
> >
> > This approach of first creating a normal io_uring instance and then
> > installing restrictions separately in a second syscall means that it
> > won't be possible to use seccomp to restrict newly created io_uring
> > instances; code that should be subject to seccomp restrictions and
> > uring restrictions would only be able to use preexisting io_uring
> > instances that have already been configured by trusted code.
> >
> > So I think that from the seccomp perspective, it might be preferable
> > to set up these restrictions in the io_uring_setup() syscall. It might
>
> So from what I can gather from this proposal, this would be a separate
> security model for io_uring? I'm not to thrilled about that tbh. (There's
> some discussion around extending seccomp - also at kernel summit.)
> But doing the whole restriction setup in io_uring_setup() would at least
> mean that if seccomp is extended to filter first-level pointers it could
> know about all the security restrictions that apply to this io_uring
> instance (Which I think you were getting at, Jann?).

Yeah.

> Hm, would it make sense that if a task has a seccomp filter installed
> that blocks openat syscalls that io_uring should automatically block
> openat() calls as well or is the expectation "just block all of io_uring
> if you're worried about that"?

I mean, if we could make that automagic, that'd be kinda neat; but I'm
slightly worried that an automated translation might end up being
slightly inaccurate. (But maybe that's acceptable?)
