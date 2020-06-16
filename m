Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8981FAC0D
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2020 11:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbgFPJM7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Jun 2020 05:12:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50993 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725901AbgFPJM6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Jun 2020 05:12:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592298776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KpFMwGKnCWLslGz1ShbrW/qNgT9EYfVeEgEKH929dV8=;
        b=XyNypN9lLlgnPFGZfwmo0Fl6xJHxq+iBo+VsniagHJgm0FwB6Ri0pTP7MRmu3X1MAP3bb6
        XsFI21yZpiM9+YFrC/PduMI/UQoSJCHb72qZPxKshgdWAUJhd5o303BzXWFHe0KtmF0uC8
        J5XZr7/ra74rTfJxEARplOuiMZfhLRQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-_N-egZkMOfuNMEAhg8Intg-1; Tue, 16 Jun 2020 05:12:53 -0400
X-MC-Unique: _N-egZkMOfuNMEAhg8Intg-1
Received: by mail-wr1-f72.google.com with SMTP id c14so8025145wrm.15
        for <io-uring@vger.kernel.org>; Tue, 16 Jun 2020 02:12:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KpFMwGKnCWLslGz1ShbrW/qNgT9EYfVeEgEKH929dV8=;
        b=i/WtnJ2VVIrZcHjuaZEtjW1gwWL52IhEnoL2KIcZvB8ExkG0aJtTfEBCIXa2B5xWfi
         IQLNch+fcsTXhXUWagZF3+BDq9Xij6QaDcxxNKEJyXiH3BOYdGTckv3mfsZpCx96LtjR
         gwicY5S5zy43OckHTT1ege7hCBZrOMuAXavNPX2Aclx+69XXUXAfGF2aE0hgE6qKjCs3
         ES2YtTEMarzebIFqORNgJzuSvU/M0tzyLycGnYZTqaSfnw/eRPupJBsgrg64MgbK0cuC
         uPdpnYjKWkPYE2EatvDru9D8MhvZJRK9tnLtnrOYjAC3FlCo1nR7PTZeahkAxD5oZTH9
         dLeQ==
X-Gm-Message-State: AOAM531cATT06Sxm+ra4sZrPDOmFZnrp1DLOIBjTB065JjAAXdz0vd/7
        aSKhc9jayD+0nzfC34hvw/+yIaT0ZphSqgRSrPaq+wNeNP2ZMTarn/ZV6TonfHZ6E00oPOcLtil
        AURyHjaG0rKFbP70Fu20=
X-Received: by 2002:adf:ff83:: with SMTP id j3mr1991780wrr.264.1592298772685;
        Tue, 16 Jun 2020 02:12:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwvcIpIFWszxHkde+5PP2e7SeEMAmFeepnBsxqv+e10s0vJo2qksi76vif4CocolLtCn1yXTA==
X-Received: by 2002:adf:ff83:: with SMTP id j3mr1991750wrr.264.1592298772376;
        Tue, 16 Jun 2020 02:12:52 -0700 (PDT)
Received: from steredhat ([5.180.207.22])
        by smtp.gmail.com with ESMTPSA id u7sm28820594wrm.23.2020.06.16.02.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 02:12:51 -0700 (PDT)
Date:   Tue, 16 Jun 2020 11:12:47 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, Jann Horn <jannh@google.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Sargun Dhillon <sargun@sargun.me>,
        Aleksa Sarai <asarai@suse.de>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>,
        io-uring <io-uring@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [RFC] io_uring: add restrictions to support untrusted
 applications and guests
Message-ID: <20200616091247.hdmxcrnlrrxih7my@steredhat>
References: <20200609142406.upuwpfmgqjeji4lc@steredhat>
 <CAG48ez3kdNKjif==MbX36cKNYDpZwEPMZaJQ1rrpXZZjGZwbKw@mail.gmail.com>
 <20200615133310.qwdmnctrir5zgube@steredhat>
 <f7f2841e-3dbb-377f-f8f8-826506a938a6@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7f2841e-3dbb-377f-f8f8-826506a938a6@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jun 15, 2020 at 11:00:25AM -0600, Jens Axboe wrote:
> On 6/15/20 7:33 AM, Stefano Garzarella wrote:
> > On Mon, Jun 15, 2020 at 11:04:06AM +0200, Jann Horn wrote:
> >> +Kees, Christian, Sargun, Aleksa, kernel-hardening for their opinions
> >> on seccomp-related aspects
> >>
> >> On Tue, Jun 9, 2020 at 4:24 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
> >>> Hi Jens,
> >>> Stefan and I have a proposal to share with io_uring community.
> >>> Before implementing it we would like to discuss it to receive feedbacks and
> >>> to see if it could be accepted:
> >>>
> >>> Adding restrictions to io_uring
> >>> =====================================
> >>> The io_uring API provides submission and completion queues for performing
> >>> asynchronous I/O operations. The queues are located in memory that is
> >>> accessible to both the host userspace application and the kernel, making it
> >>> possible to monitor for activity through polling instead of system calls. This
> >>> design offers good performance and this makes exposing io_uring to guests an
> >>> attractive idea for improving I/O performance in virtualization.
> >> [...]
> >>> Restrictions
> >>> ------------
> >>> This document proposes io_uring API changes that safely allow untrusted
> >>> applications or guests to use io_uring. io_uring's existing security model is
> >>> that of kernel system call handler code. It is designed to reject invalid
> >>> inputs from host userspace applications. Supporting guests as io_uring API
> >>> clients adds a new trust domain with access to even fewer resources than host
> >>> userspace applications.
> >>>
> >>> Guests do not have direct access to host userspace application file descriptors
> >>> or memory. The host userspace application, a Virtual Machine Monitor (VMM) such
> >>> as QEMU, grants access to a subset of its file descriptors and memory. The
> >>> allowed file descriptors are typically the disk image files belonging to the
> >>> guest. The memory is typically the virtual machine's RAM that the VMM has
> >>> allocated on behalf of the guest.
> >>>
> >>> The following extensions to the io_uring API allow the host application to
> >>> grant access to some of its file descriptors.
> >>>
> >>> These extensions are designed to be applicable to other use cases besides
> >>> untrusted guests and are not virtualization-specific. For example, the
> >>> restrictions can be used to allow only a subset of sqe operations available to
> >>> an application similar to seccomp syscall whitelisting.
> >>>
> >>> An address translation and memory restriction mechanism would also be
> >>> necessary, but we can discuss this later.
> >>>
> >>> The IOURING_REGISTER_RESTRICTIONS opcode
> >>> ----------------------------------------
> >>> The new io_uring_register(2) IOURING_REGISTER_RESTRICTIONS opcode permanently
> >>> installs a feature whitelist on an io_ring_ctx. The io_ring_ctx can then be
> >>> passed to untrusted code with the knowledge that only operations present in the
> >>> whitelist can be executed.
> >>
> >> This approach of first creating a normal io_uring instance and then
> >> installing restrictions separately in a second syscall means that it
> >> won't be possible to use seccomp to restrict newly created io_uring
> >> instances; code that should be subject to seccomp restrictions and
> >> uring restrictions would only be able to use preexisting io_uring
> >> instances that have already been configured by trusted code.
> >>
> >> So I think that from the seccomp perspective, it might be preferable
> >> to set up these restrictions in the io_uring_setup() syscall. It might
> >> also be a bit nicer from a code cleanliness perspective, since you
> >> won't have to worry about concurrently changing restrictions.
> >>
> > 
> > Thank you for these details!
> > 
> > It seems feasible to include the restrictions during io_uring_setup().
> > 
> > The only doubt concerns the possibility of allowing the trusted code to
> > do some operations, before passing queues to the untrusted code, for
> > example registering file descriptors, buffers, eventfds, etc.
> > 
> > To avoid this, I should include these operations in io_uring_setup(),
> > adding some code that I wanted to avoid by reusing io_uring_register().
> > 
> > If I add restrictions in io_uring_setup() and then add an operation to
> > go into safe mode (e.g. a flag in io_uring_enter()), we would have the same
> > problem, right?
> > 
> > Just to be clear, I mean something like this:
> > 
> >     /* params will include restrictions */
> >     fd = io_uring_setup(entries, params);
> > 
> >     /* trusted code */
> >     io_uring_register_files(fd, ...);
> >     io_uring_register_buffers(fd, ...);
> >     io_uring_register_eventfd(fd, ...);
> > 
> >     /* enable safe mode */
> >     io_uring_enter(fd, ..., IORING_ENTER_ENABLE_RESTRICTIONS);
> > 
> > 
> > Anyway, including a list of things to register in the 'params', passed
> > to io_uring_setup(), should be feasible, if Jens agree :-)
> 
> I wonder how best to deal with this, in terms of ring visibility vs
> registering restrictions. We could potentially start the ring in a
> disabled mode, if asked to. It'd still be visible in terms of having
> the fd installed, but it'd just error requests. That'd leave you with
> time to do the various setup routines needed before then flagging it
> as enabled. My only worry on that would be adding overhead for doing
> that. It'd be cheap enough to check for IORING_SETUP_DISABLED in
> ctx->flags in io_uring_enter(), and return -EBADFD or something if
> that's the case. That doesn't cover the SQPOLL case though, but maybe we
> just don't start the sq thread if IORING_SETUP_DISABLED is set.

It seems to me a very good approach and easy to implement. In this way
we can reuse io_uring_register() without having to modify too much
io_uring_setup().

> 
> We'd need a way to clear IORING_SETUP_DISABLED through
> io_uring_register(). When clearing, that could then start the sq thread
> as well, when SQPOLL is set.

Could we do it using io_uring_enter() since we have a flag field or
do you think it's semantically incorrect?

@Jann, do you think this could work with seccomp?

Thanks,
Stefano

