Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B091FB61C
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2020 17:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728919AbgFPP0g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Jun 2020 11:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728917AbgFPP0g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Jun 2020 11:26:36 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D6EC061573
        for <io-uring@vger.kernel.org>; Tue, 16 Jun 2020 08:26:35 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 10so9650985pfx.8
        for <io-uring@vger.kernel.org>; Tue, 16 Jun 2020 08:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=J55Yrg8VYzY4+wtj/Uv5g1sQPpUZEQ1qQJiBJy8F1Vw=;
        b=ScXiocFCM5KN9GGXxl0vObK+ejCxA6xVsGZPKNQ+ryqY3Jvi31PyHkuwz0Rrr2YD9a
         BoxB7Kna4b072h7rZRctDWTRPmkvc8bMj9qY0whYmIq0f3k54OvlwYfDE3ezNa+e5o0z
         uU5N2MewUe6VjabfCEby+ro5yrYF1/RYX/RXIwB9a/X1ePRBcUxa8QUZq+gXMDOvicL/
         PC1amgfEh44RnI3ZjeSOaPVROnO0V4Q9/xwM/MPWlZmte2CmkVl8UUB3JMKrtqiQngQ/
         YQGKL6QWG//9IRy57BHOD+bUa2NcE5sl4+yfuYncd10bJhmpoHa9OrTvLMxh4CDQyPj6
         /j0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J55Yrg8VYzY4+wtj/Uv5g1sQPpUZEQ1qQJiBJy8F1Vw=;
        b=K1DsjW5XkP7W6yAgWtyUMPghqfNFjpDArcgiWLBqrpyiOO+aS6IXP0YDy4E88GJsYv
         jkqvzXamtBUZ9wO7M6k2IfFq1y2eMxOYtP397LiZC+odunMRB7rqmBrzpy3qQcxyIXKI
         0/5E0LeVg44iqw+QIloDxfl1AEls5ij/xIKDJTsqAmVhgkGQKcZab48aOc3SXUQgYmPI
         6gbGLRbl/stBtBLu7jL0zgD6pHJYHCwpoR0GZAcOKbyuG7TZznBIHA0BVCgMir6a6GfP
         QxzHkXHjCmI1hP2hUYq4GkCQIFUe3iAX1C1aswTZrSrA4VT6n7Gz07uoapcaZHz0Ry7S
         eufg==
X-Gm-Message-State: AOAM531wLUYSdcO/Tam85eQg7EmirVYevjAuT1xuaFUt2qzdnRswcKdv
        zY0RtmG/zqgAZYNmiWi35/lohw==
X-Google-Smtp-Source: ABdhPJxwjVMSe24dxFtfwQkcGPlFq0g48BFEg5rx42dbXBbl70ZAVFthn5j92OenIA18sx0vejCOtw==
X-Received: by 2002:a63:580c:: with SMTP id m12mr2442156pgb.446.1592321194136;
        Tue, 16 Jun 2020 08:26:34 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id m14sm2897821pjv.12.2020.06.16.08.26.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jun 2020 08:26:33 -0700 (PDT)
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
 <f7f2841e-3dbb-377f-f8f8-826506a938a6@kernel.dk>
 <20200616091247.hdmxcrnlrrxih7my@steredhat>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9483bbde-b1de-93b1-a239-4ba3613a63e5@kernel.dk>
Date:   Tue, 16 Jun 2020 09:26:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200616091247.hdmxcrnlrrxih7my@steredhat>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/16/20 3:12 AM, Stefano Garzarella wrote:
> On Mon, Jun 15, 2020 at 11:00:25AM -0600, Jens Axboe wrote:
>> On 6/15/20 7:33 AM, Stefano Garzarella wrote:
>>> On Mon, Jun 15, 2020 at 11:04:06AM +0200, Jann Horn wrote:
>>>> +Kees, Christian, Sargun, Aleksa, kernel-hardening for their opinions
>>>> on seccomp-related aspects
>>>>
>>>> On Tue, Jun 9, 2020 at 4:24 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>>>>> Hi Jens,
>>>>> Stefan and I have a proposal to share with io_uring community.
>>>>> Before implementing it we would like to discuss it to receive feedbacks and
>>>>> to see if it could be accepted:
>>>>>
>>>>> Adding restrictions to io_uring
>>>>> =====================================
>>>>> The io_uring API provides submission and completion queues for performing
>>>>> asynchronous I/O operations. The queues are located in memory that is
>>>>> accessible to both the host userspace application and the kernel, making it
>>>>> possible to monitor for activity through polling instead of system calls. This
>>>>> design offers good performance and this makes exposing io_uring to guests an
>>>>> attractive idea for improving I/O performance in virtualization.
>>>> [...]
>>>>> Restrictions
>>>>> ------------
>>>>> This document proposes io_uring API changes that safely allow untrusted
>>>>> applications or guests to use io_uring. io_uring's existing security model is
>>>>> that of kernel system call handler code. It is designed to reject invalid
>>>>> inputs from host userspace applications. Supporting guests as io_uring API
>>>>> clients adds a new trust domain with access to even fewer resources than host
>>>>> userspace applications.
>>>>>
>>>>> Guests do not have direct access to host userspace application file descriptors
>>>>> or memory. The host userspace application, a Virtual Machine Monitor (VMM) such
>>>>> as QEMU, grants access to a subset of its file descriptors and memory. The
>>>>> allowed file descriptors are typically the disk image files belonging to the
>>>>> guest. The memory is typically the virtual machine's RAM that the VMM has
>>>>> allocated on behalf of the guest.
>>>>>
>>>>> The following extensions to the io_uring API allow the host application to
>>>>> grant access to some of its file descriptors.
>>>>>
>>>>> These extensions are designed to be applicable to other use cases besides
>>>>> untrusted guests and are not virtualization-specific. For example, the
>>>>> restrictions can be used to allow only a subset of sqe operations available to
>>>>> an application similar to seccomp syscall whitelisting.
>>>>>
>>>>> An address translation and memory restriction mechanism would also be
>>>>> necessary, but we can discuss this later.
>>>>>
>>>>> The IOURING_REGISTER_RESTRICTIONS opcode
>>>>> ----------------------------------------
>>>>> The new io_uring_register(2) IOURING_REGISTER_RESTRICTIONS opcode permanently
>>>>> installs a feature whitelist on an io_ring_ctx. The io_ring_ctx can then be
>>>>> passed to untrusted code with the knowledge that only operations present in the
>>>>> whitelist can be executed.
>>>>
>>>> This approach of first creating a normal io_uring instance and then
>>>> installing restrictions separately in a second syscall means that it
>>>> won't be possible to use seccomp to restrict newly created io_uring
>>>> instances; code that should be subject to seccomp restrictions and
>>>> uring restrictions would only be able to use preexisting io_uring
>>>> instances that have already been configured by trusted code.
>>>>
>>>> So I think that from the seccomp perspective, it might be preferable
>>>> to set up these restrictions in the io_uring_setup() syscall. It might
>>>> also be a bit nicer from a code cleanliness perspective, since you
>>>> won't have to worry about concurrently changing restrictions.
>>>>
>>>
>>> Thank you for these details!
>>>
>>> It seems feasible to include the restrictions during io_uring_setup().
>>>
>>> The only doubt concerns the possibility of allowing the trusted code to
>>> do some operations, before passing queues to the untrusted code, for
>>> example registering file descriptors, buffers, eventfds, etc.
>>>
>>> To avoid this, I should include these operations in io_uring_setup(),
>>> adding some code that I wanted to avoid by reusing io_uring_register().
>>>
>>> If I add restrictions in io_uring_setup() and then add an operation to
>>> go into safe mode (e.g. a flag in io_uring_enter()), we would have the same
>>> problem, right?
>>>
>>> Just to be clear, I mean something like this:
>>>
>>>     /* params will include restrictions */
>>>     fd = io_uring_setup(entries, params);
>>>
>>>     /* trusted code */
>>>     io_uring_register_files(fd, ...);
>>>     io_uring_register_buffers(fd, ...);
>>>     io_uring_register_eventfd(fd, ...);
>>>
>>>     /* enable safe mode */
>>>     io_uring_enter(fd, ..., IORING_ENTER_ENABLE_RESTRICTIONS);
>>>
>>>
>>> Anyway, including a list of things to register in the 'params', passed
>>> to io_uring_setup(), should be feasible, if Jens agree :-)
>>
>> I wonder how best to deal with this, in terms of ring visibility vs
>> registering restrictions. We could potentially start the ring in a
>> disabled mode, if asked to. It'd still be visible in terms of having
>> the fd installed, but it'd just error requests. That'd leave you with
>> time to do the various setup routines needed before then flagging it
>> as enabled. My only worry on that would be adding overhead for doing
>> that. It'd be cheap enough to check for IORING_SETUP_DISABLED in
>> ctx->flags in io_uring_enter(), and return -EBADFD or something if
>> that's the case. That doesn't cover the SQPOLL case though, but maybe we
>> just don't start the sq thread if IORING_SETUP_DISABLED is set.
> 
> It seems to me a very good approach and easy to implement. In this way
> we can reuse io_uring_register() without having to modify too much
> io_uring_setup().

Right

>> We'd need a way to clear IORING_SETUP_DISABLED through
>> io_uring_register(). When clearing, that could then start the sq thread
>> as well, when SQPOLL is set.
> 
> Could we do it using io_uring_enter() since we have a flag field or
> do you think it's semantically incorrect?

Either way is probably fine, I gravitated towards io_uring_register()
since any io_uring_enter() should fail if the ring is disabled. But I
guess it's fine to allow the "enable" operation through io_uring_enter.
Keep in mind that io_uring_enter is the hottest path, where
io_uring_register is not nearly as hot and we can allow ourselves a bit
more flexibility there.

In summary, I'd be fine with io_uring_enter if it's slim and lean, still
leaning towards doing it in io_uring_register as it seems like a more
natural fit.

-- 
Jens Axboe

