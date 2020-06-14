Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF291F8993
	for <lists+io-uring@lfdr.de>; Sun, 14 Jun 2020 17:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbgFNPwf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 14 Jun 2020 11:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbgFNPwf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 14 Jun 2020 11:52:35 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E74A6C05BD43
        for <io-uring@vger.kernel.org>; Sun, 14 Jun 2020 08:52:33 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id k1so5658271pls.2
        for <io-uring@vger.kernel.org>; Sun, 14 Jun 2020 08:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TouUkFg/FHy2nyUUaR1tDwhIglitrb1TdRNmP/qgBCw=;
        b=0vzGm75IeQt9SAORs1QTUrYr6o8vgsq+BaiCfqGAFx9xqowYywxn4eZLzLW5gUFnha
         /T2R7REN+rjaK8VXqyHsJe8TUC3mPiZF4pA0OirFPpNPmJgz2fhp26S9COpWeh453t07
         VKBuUrJUkHml9Zfm6v3Zu4t+odBNB4FtNQiiqzEGiO3jU+WFC/ooMyV9uRg6t2knHiMl
         snU7hX1TuAx9wZs3HPxHPRuQgFQF2oK3Lk/9oRZhNO0o4hSsyZQJPkW/TzuohLVf9gI9
         3GGSQXcr0Jer90Fwu0EdkahSTwqQtgCs/pXO04lN3cYi6tcjfn00Aw2q9KwNKIFh77gy
         lGaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TouUkFg/FHy2nyUUaR1tDwhIglitrb1TdRNmP/qgBCw=;
        b=gg7he45tRu/lU9EVy3fG2Ad7xLSrh2Qu9ivS8saFo1thNAanU4xN9+slFIgpnqJqsC
         j1hj8YhroMljrE+qpKAr3Pqa+XmQoEgMWJ9ameZmroXIYvkCbARFAghSb62VtSK58U3B
         zdqj4l56X4rdxt7lRP2XNaKaFMc3yUUMYu/hiWZOuiKOGfg5zbTprV0xyaEasc2Be4RN
         0DPClx5qtZHRBqIpytE+0eSyAeh8lirOugp19bNu06RXjaQUFhC0D6WrW6K4DWRor36i
         uK2LrhWnyBsS9VCBD8pctx5FmFCh/N8eq0St43qvBkyLUlZ46J1XvMUsNhYQ2HtRgZGH
         yAhw==
X-Gm-Message-State: AOAM5338b8CvQQV+/UyziagP1nzDnZpMKGtbwZi+kEKpZWvvyftB7Y5W
        XjzD1ZtXtZtx/q9vNcn9qcPNRGXALTkQPA==
X-Google-Smtp-Source: ABdhPJzI5VRwXLels0h7tmfmSGRQi02F+qx3eTQIXbBZCFL8tUNm9IhJnLH6mWhwRRNE0yoJKxBg0g==
X-Received: by 2002:a17:90a:326a:: with SMTP id k97mr8151376pjb.158.1592149953322;
        Sun, 14 Jun 2020 08:52:33 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id y6sm11951512pfp.144.2020.06.14.08.52.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Jun 2020 08:52:32 -0700 (PDT)
Subject: Re: [RFC] io_uring: add restrictions to support untrusted
 applications and guests
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200609142406.upuwpfmgqjeji4lc@steredhat>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f96beb0a-415c-92fb-96f4-3902b613e9e4@kernel.dk>
Date:   Sun, 14 Jun 2020 09:52:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200609142406.upuwpfmgqjeji4lc@steredhat>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/9/20 8:24 AM, Stefano Garzarella wrote:
> Hi Jens,
> Stefan and I have a proposal to share with io_uring community.
> Before implementing it we would like to discuss it to receive feedbacks and
> to see if it could be accepted:
> 
> Adding restrictions to io_uring
> =====================================
> The io_uring API provides submission and completion queues for performing
> asynchronous I/O operations. The queues are located in memory that is
> accessible to both the host userspace application and the kernel, making it
> possible to monitor for activity through polling instead of system calls. This
> design offers good performance and this makes exposing io_uring to guests an
> attractive idea for improving I/O performance in virtualization.
> 
> PoC and preliminary benchmarks
> ---------------------------
> We realized a PoC, using QEMU and virtio-blk device, to share io_uring
> CQ and SQ rings with the guest.
> QEMU initializes io_uring, registers the device (NVMe) fd through
> io_uring_register(2), and maps the rings in the guest memory.
> The virtio-blk driver uses these rings to send requests instead of using
> the standard virtqueues.
> 
> The PoC implements a pure polling solution where the application is polling
> (IOPOLL enabled) in the guest and the sqpoll_kthread is polling in the host
> (SQPOLL and IOPOLL enabled).
> 
> These are the encouraging results we obtained from this preliminary work;
> we used fio (rw=randread bs=4k) to measure the kIOPS on a NVMe device:
> 
> - bare-metal
>                                                        iodepth
>   | fio ioengine                              |  1  |  8  |  16 |  32 |
>   |-------------------------------------------|----:|----:|----:|----:|
>   | io_uring (SQPOLL + IOPOLL)                | 119 | 550 | 581 | 585 |
>   | io_uring (IOPOLL)                         | 122 | 502 | 519 | 538 |
> 
> - QEMU/KVM guest (aio=io_uring)
>                                                        iodepth
>   | virtio-blk            | fio ioengine      |  1  |  8  |  16 |  32 |
>   |-----------------------|-------------------|----:|----:|----:|----:|
>   | virtqueues            | io_uring (IOPOLL) |  27 | 144 | 209 | 266 |
>   | virtqueues + iothread | io_uring (IOPOLL) |  73 | 264 | 306 | 312 |
>   | io_uring passthrough  | io_uring (IOPOLL) | 104 | 532 | 577 | 585 |
> 
>   All guest experiments are using the QEMU io_uring backend with SQPOLL and
>   IOPOLL enabled. The virtio-blk driver is modified to support blovk io_poll
>   on both virtqueues and io_uring passthrough.
> 
> Before developing this proof-of-concept further we would like to discuss
> io_uring changes required to restrict rings since this mechanism is a
> prerequisite for real-world use cases where guests are untrusted.
> 
> Restrictions
> ------------
> This document proposes io_uring API changes that safely allow untrusted
> applications or guests to use io_uring. io_uring's existing security model is
> that of kernel system call handler code. It is designed to reject invalid
> inputs from host userspace applications. Supporting guests as io_uring API
> clients adds a new trust domain with access to even fewer resources than host
> userspace applications.
> 
> Guests do not have direct access to host userspace application file descriptors
> or memory. The host userspace application, a Virtual Machine Monitor (VMM) such
> as QEMU, grants access to a subset of its file descriptors and memory. The
> allowed file descriptors are typically the disk image files belonging to the
> guest. The memory is typically the virtual machine's RAM that the VMM has
> allocated on behalf of the guest.
> 
> The following extensions to the io_uring API allow the host application to
> grant access to some of its file descriptors.
> 
> These extensions are designed to be applicable to other use cases besides
> untrusted guests and are not virtualization-specific. For example, the
> restrictions can be used to allow only a subset of sqe operations available to
> an application similar to seccomp syscall whitelisting.
> 
> An address translation and memory restriction mechanism would also be
> necessary, but we can discuss this later.
> 
> The IOURING_REGISTER_RESTRICTIONS opcode
> ----------------------------------------
> The new io_uring_register(2) IOURING_REGISTER_RESTRICTIONS opcode permanently
> installs a feature whitelist on an io_ring_ctx. The io_ring_ctx can then be
> passed to untrusted code with the knowledge that only operations present in the
> whitelist can be executed.
> 
> The whitelist approach ensures that new features added to io_uring do not
> accidentally become available when an existing application is launched on a
> newer kernel version.
> 
> The IORING_REGISTER_RESTRICTIONS opcode takes an array of struct
> io_uring_restriction elements that describe whitelisted features:
> 
>   #define IORING_REGISTER_RESTRICTIONS 11
> 
>   /* struct io_uring_restriction::opcode values */
>   enum {
>       /* Allow an io_uring_register(2) opcode */
>       IORING_RESTRICTION_REGISTER_OP,
> 
>       /* Allow an sqe opcode */
>       IORING_RESTRICTION_SQE_OP,
> 
>       /* Only allow fixed files */
>       IORING_RESTRICTION_FIXED_FILES_ONLY,
> 
>       /* Only allow registered addresses and translate them */
>       IORING_RESTRICTION_BUFFER_CHECK
>   };
> 
>   struct io_uring_restriction {
>       __u16 opcode;
>       union {
>           __u8 register_op; /* IORING_RESTRICTION_REGISTER_OP */
>           __u8 sqe_op;      /* IORING_RESTRICTION_SQE_OP */
>       };
>       __u8 resv;
>       __u32 resv2[3];
>   };
> 
> This call can only be made once. Afterwards it is not possible to change
> restrictions anymore. This prevents untrusted code from removing restrictions.
> 
> Limiting access to io_uring operations
> --------------------------------------
> The following example shows how to whitelist IORING_OP_READV, IORING_OP_WRITEV,
> and IORING_OP_FSYNC:
> 
>   struct io_uring_restriction restrictions[] = {
>       {
>           .opcode = IORING_RESTRICTION_SQE_OP,
>           .sqe_op = IORING_OP_READV,
>       },
>       {
>           .opcode = IORING_RESTRICTION_SQE_OP,
>           .sqe_op = IORING_OP_WRITEV,
>       },
>       {
>           .opcode = IORING_RESTRICTION_SQE_OP,
>           .sqe_op = IORING_OP_FSYNC,
>       },
>       ...
>   };
> 
>   io_uring_register(ringfd, IORING_REGISTER_RESTRICTIONS,
>                     restrictions, ARRAY_SIZE(restrictions));
> 
> Limiting access to file descriptors
> -----------------------------------
> The fixed files mechanism can be used to limit access to a set of file
> descriptors:
> 
>   struct io_uring_restriction restrictions[] = {
>       {
>           .opcode = IORING_RESTRICTION_FIXED_FILES_ONLY,
>       },
>       ...
>   };
> 
>   io_uring_register(ringfd, IORING_REGISTER_RESTRICTIONS,
>                     restrictions, ARRAY_SIZE(restrictions));
> 
> Only requests with the sqe->flags IOSQE_FIXED_FILE bit set will be allowed.

I don't think this sounds unreasonable, but I'd really like to see a
prototype hacked up before rendering any further opinions on it :-)

-- 
Jens Axboe

