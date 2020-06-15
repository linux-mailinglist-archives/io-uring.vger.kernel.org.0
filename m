Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 256941F9DFA
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2020 19:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731139AbgFORAa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Jun 2020 13:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730377AbgFORA3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Jun 2020 13:00:29 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90DECC061A0E
        for <io-uring@vger.kernel.org>; Mon, 15 Jun 2020 10:00:28 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id n2so7022503pld.13
        for <io-uring@vger.kernel.org>; Mon, 15 Jun 2020 10:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OLDj84Vf2Ss3CuVG8EdpeZlmuGFVkaaeH3C9J5Xc5Bc=;
        b=D7/vpemZ134Hy2F2MsWvELrx79i0dwbyRMmbh/c++JsBNsfHrWHn6ix+6duSzfhWx7
         qNGo8XY24NuO9bSQ+jg3JAHTXH0iTOSD2dEPPoNt3/3Q5sWmP4X9/Latt007So2xiK6w
         dcevu25BEyQQJYbJZXCRNYnG+1gtdfXW9HYVkmMe//fxkEqn1/PY7TN0RvXr5T3/7Oyt
         o3jmABfIsxp+KxtK1pouEv40qo+T/rdH8RdFkuG0hkFVSFPVKaIcRNpg6b6gD0bf51K1
         a49YsUmbTHUJ0XISzhaPbuMQgQCFCto05DDzWIXk+On5NDpv4QmB/Vum/ALbTZTul7X3
         HiOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OLDj84Vf2Ss3CuVG8EdpeZlmuGFVkaaeH3C9J5Xc5Bc=;
        b=QXhSPlA0n5IKKPF2Td8S1srQK9QhvXHXZN5v1A52mY8KnnavdYZXMsf3VYZLQBRXZa
         5INm8/M7HJ83ZAHTKvwiH7UbEhgY/rdU0xmotIR2g2EkeLgvNI1/EupU+NsLWQGiFaMm
         bfCkpIJhTitNJCf94+pdsXhDGXjONlHfXk2tmjK8wvCoSuQvdmEpYYNvfCde76L4pIDD
         m8MDzmaAVFuY48xP69T61D7TW1rp0VVWr8k1Ql9l1fel7lJ/HYrkpY0gHJS9Uhn0MLg4
         roobGG1LyjEiMkYbNSpCzKsEsl8NdW/dYlCJmjYSQYFZB1nUO0rmWWR2Rn1FjEKXJOfv
         P07A==
X-Gm-Message-State: AOAM531GpRFKmtMJ0HVIcLNXp6CVkUcqXwQ4k4BSUeHnywqcEIi6ou07
        q62h3FtEelknLlwfSldy5e3vbQ==
X-Google-Smtp-Source: ABdhPJwY6m4VGHVURwtAfMzxZXrIApQH9lo2o827yDWAKxrUQHiEaorTUtS6dokTRo9IxGCGENBcFw==
X-Received: by 2002:a17:902:7008:: with SMTP id y8mr21928133plk.84.1592240427957;
        Mon, 15 Jun 2020 10:00:27 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 27sm93902pjg.19.2020.06.15.10.00.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2020 10:00:27 -0700 (PDT)
Subject: Re: [RFC] io_uring: add restrictions to support untrusted
 applications and guests
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Jann Horn <jannh@google.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Sargun Dhillon <sargun@sargun.me>,
        Aleksa Sarai <asarai@suse.de>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>,
        io-uring <io-uring@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>
References: <20200609142406.upuwpfmgqjeji4lc@steredhat>
 <CAG48ez3kdNKjif==MbX36cKNYDpZwEPMZaJQ1rrpXZZjGZwbKw@mail.gmail.com>
 <20200615133310.qwdmnctrir5zgube@steredhat>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f7f2841e-3dbb-377f-f8f8-826506a938a6@kernel.dk>
Date:   Mon, 15 Jun 2020 11:00:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200615133310.qwdmnctrir5zgube@steredhat>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/15/20 7:33 AM, Stefano Garzarella wrote:
> On Mon, Jun 15, 2020 at 11:04:06AM +0200, Jann Horn wrote:
>> +Kees, Christian, Sargun, Aleksa, kernel-hardening for their opinions
>> on seccomp-related aspects
>>
>> On Tue, Jun 9, 2020 at 4:24 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>>> Hi Jens,
>>> Stefan and I have a proposal to share with io_uring community.
>>> Before implementing it we would like to discuss it to receive feedbacks and
>>> to see if it could be accepted:
>>>
>>> Adding restrictions to io_uring
>>> =====================================
>>> The io_uring API provides submission and completion queues for performing
>>> asynchronous I/O operations. The queues are located in memory that is
>>> accessible to both the host userspace application and the kernel, making it
>>> possible to monitor for activity through polling instead of system calls. This
>>> design offers good performance and this makes exposing io_uring to guests an
>>> attractive idea for improving I/O performance in virtualization.
>> [...]
>>> Restrictions
>>> ------------
>>> This document proposes io_uring API changes that safely allow untrusted
>>> applications or guests to use io_uring. io_uring's existing security model is
>>> that of kernel system call handler code. It is designed to reject invalid
>>> inputs from host userspace applications. Supporting guests as io_uring API
>>> clients adds a new trust domain with access to even fewer resources than host
>>> userspace applications.
>>>
>>> Guests do not have direct access to host userspace application file descriptors
>>> or memory. The host userspace application, a Virtual Machine Monitor (VMM) such
>>> as QEMU, grants access to a subset of its file descriptors and memory. The
>>> allowed file descriptors are typically the disk image files belonging to the
>>> guest. The memory is typically the virtual machine's RAM that the VMM has
>>> allocated on behalf of the guest.
>>>
>>> The following extensions to the io_uring API allow the host application to
>>> grant access to some of its file descriptors.
>>>
>>> These extensions are designed to be applicable to other use cases besides
>>> untrusted guests and are not virtualization-specific. For example, the
>>> restrictions can be used to allow only a subset of sqe operations available to
>>> an application similar to seccomp syscall whitelisting.
>>>
>>> An address translation and memory restriction mechanism would also be
>>> necessary, but we can discuss this later.
>>>
>>> The IOURING_REGISTER_RESTRICTIONS opcode
>>> ----------------------------------------
>>> The new io_uring_register(2) IOURING_REGISTER_RESTRICTIONS opcode permanently
>>> installs a feature whitelist on an io_ring_ctx. The io_ring_ctx can then be
>>> passed to untrusted code with the knowledge that only operations present in the
>>> whitelist can be executed.
>>
>> This approach of first creating a normal io_uring instance and then
>> installing restrictions separately in a second syscall means that it
>> won't be possible to use seccomp to restrict newly created io_uring
>> instances; code that should be subject to seccomp restrictions and
>> uring restrictions would only be able to use preexisting io_uring
>> instances that have already been configured by trusted code.
>>
>> So I think that from the seccomp perspective, it might be preferable
>> to set up these restrictions in the io_uring_setup() syscall. It might
>> also be a bit nicer from a code cleanliness perspective, since you
>> won't have to worry about concurrently changing restrictions.
>>
> 
> Thank you for these details!
> 
> It seems feasible to include the restrictions during io_uring_setup().
> 
> The only doubt concerns the possibility of allowing the trusted code to
> do some operations, before passing queues to the untrusted code, for
> example registering file descriptors, buffers, eventfds, etc.
> 
> To avoid this, I should include these operations in io_uring_setup(),
> adding some code that I wanted to avoid by reusing io_uring_register().
> 
> If I add restrictions in io_uring_setup() and then add an operation to
> go into safe mode (e.g. a flag in io_uring_enter()), we would have the same
> problem, right?
> 
> Just to be clear, I mean something like this:
> 
>     /* params will include restrictions */
>     fd = io_uring_setup(entries, params);
> 
>     /* trusted code */
>     io_uring_register_files(fd, ...);
>     io_uring_register_buffers(fd, ...);
>     io_uring_register_eventfd(fd, ...);
> 
>     /* enable safe mode */
>     io_uring_enter(fd, ..., IORING_ENTER_ENABLE_RESTRICTIONS);
> 
> 
> Anyway, including a list of things to register in the 'params', passed
> to io_uring_setup(), should be feasible, if Jens agree :-)

I wonder how best to deal with this, in terms of ring visibility vs
registering restrictions. We could potentially start the ring in a
disabled mode, if asked to. It'd still be visible in terms of having
the fd installed, but it'd just error requests. That'd leave you with
time to do the various setup routines needed before then flagging it
as enabled. My only worry on that would be adding overhead for doing
that. It'd be cheap enough to check for IORING_SETUP_DISABLED in
ctx->flags in io_uring_enter(), and return -EBADFD or something if
that's the case. That doesn't cover the SQPOLL case though, but maybe we
just don't start the sq thread if IORING_SETUP_DISABLED is set.

We'd need a way to clear IORING_SETUP_DISABLED through
io_uring_register(). When clearing, that could then start the sq thread
as well, when SQPOLL is set.

-- 
Jens Axboe

