Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC0E1F3E00
	for <lists+io-uring@lfdr.de>; Tue,  9 Jun 2020 16:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728905AbgFIOYR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Jun 2020 10:24:17 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:58157 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728601AbgFIOYQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Jun 2020 10:24:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591712653;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=RpR4db2BYUdmK1j0ocnwY36/XEkGSRK7q+SwrEA+exk=;
        b=TgiGUqab3QCZkytVljeE6tV8qBhQ82XXwSn1yX78Ef1liF2yvDw1x0pfCI20XtvJnJzbNK
        N1eBMLbiHh68cbNoGCJ6nTZpAkQQI2GoWaJv5X63qWqV/eu+7D2/VP1GRsqEfeb3r0LUM4
        FWSJOEFJeMFb09ze6LJGE4NN2GtVae0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-BLuYbAcqOFOukghPYmVnaw-1; Tue, 09 Jun 2020 10:24:11 -0400
X-MC-Unique: BLuYbAcqOFOukghPYmVnaw-1
Received: by mail-wr1-f69.google.com with SMTP id h6so8746359wrx.4
        for <io-uring@vger.kernel.org>; Tue, 09 Jun 2020 07:24:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=RpR4db2BYUdmK1j0ocnwY36/XEkGSRK7q+SwrEA+exk=;
        b=eDK/9AEsVBMiV0MwuVZb6B25vR3sANiZAq8ceVBD8B7U4dLLRgQgbR52HIRt3Ynl2I
         NdW0eh7wkwmRUMJEjLORenmls4QuxkYm68Dy2Zol3GUj+sqrvVxp8Kg0AngOE9k+JzjE
         efndVSzKGtDtTC88rYl64dA8Hjb1mEnnEVMMaa77bWuzQ9YBgs0+GppM0gXH1Sj92UJi
         d/iY3vO8i1N5g3mo88cG11CnQ1ozSM0b7QnkxGJIiWRTCwsRHdTymQnpMBsp3SyU21Qu
         qlrctiimIatfeHBovwumVWsMbSP+y/zGTjycaE7lMGwuWa6rO6hqOm0uGlnL4a+qF9Pq
         7Znw==
X-Gm-Message-State: AOAM533m702U9QhMXTI2gmamb5/G0vnNcOT5+GjCtOrkhHDfoecrvL68
        Vam6j9Xna21NaJbgDsA/voLAWFvND+9XEG4Eow8yoHm1bSWTLBS+maT9lRE1M1wRARTV/wHt5G/
        YvMIbnKj/4knF57tNP94=
X-Received: by 2002:adf:ed87:: with SMTP id c7mr4789074wro.108.1591712650531;
        Tue, 09 Jun 2020 07:24:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw7k0clUUUuo0NQ83yaXJdGTvNwA1q+8Od/NT0+Gd4O+ygFtZPfo/lB99jWrl5o+uVeAv0zqQ==
X-Received: by 2002:adf:ed87:: with SMTP id c7mr4789051wro.108.1591712650206;
        Tue, 09 Jun 2020 07:24:10 -0700 (PDT)
Received: from steredhat (host-79-49-207-108.retail.telecomitalia.it. [79.49.207.108])
        by smtp.gmail.com with ESMTPSA id e12sm3613514wro.52.2020.06.09.07.24.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 07:24:09 -0700 (PDT)
Date:   Tue, 9 Jun 2020 16:24:06 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC] io_uring: add restrictions to support untrusted applications
 and guests
Message-ID: <20200609142406.upuwpfmgqjeji4lc@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,
Stefan and I have a proposal to share with io_uring community.
Before implementing it we would like to discuss it to receive feedbacks and
to see if it could be accepted:

Adding restrictions to io_uring
=====================================
The io_uring API provides submission and completion queues for performing
asynchronous I/O operations. The queues are located in memory that is
accessible to both the host userspace application and the kernel, making it
possible to monitor for activity through polling instead of system calls. This
design offers good performance and this makes exposing io_uring to guests an
attractive idea for improving I/O performance in virtualization.

PoC and preliminary benchmarks
---------------------------
We realized a PoC, using QEMU and virtio-blk device, to share io_uring
CQ and SQ rings with the guest.
QEMU initializes io_uring, registers the device (NVMe) fd through
io_uring_register(2), and maps the rings in the guest memory.
The virtio-blk driver uses these rings to send requests instead of using
the standard virtqueues.

The PoC implements a pure polling solution where the application is polling
(IOPOLL enabled) in the guest and the sqpoll_kthread is polling in the host
(SQPOLL and IOPOLL enabled).

These are the encouraging results we obtained from this preliminary work;
we used fio (rw=randread bs=4k) to measure the kIOPS on a NVMe device:

- bare-metal
                                                       iodepth
  | fio ioengine                              |  1  |  8  |  16 |  32 |
  |-------------------------------------------|----:|----:|----:|----:|
  | io_uring (SQPOLL + IOPOLL)                | 119 | 550 | 581 | 585 |
  | io_uring (IOPOLL)                         | 122 | 502 | 519 | 538 |

- QEMU/KVM guest (aio=io_uring)
                                                       iodepth
  | virtio-blk            | fio ioengine      |  1  |  8  |  16 |  32 |
  |-----------------------|-------------------|----:|----:|----:|----:|
  | virtqueues            | io_uring (IOPOLL) |  27 | 144 | 209 | 266 |
  | virtqueues + iothread | io_uring (IOPOLL) |  73 | 264 | 306 | 312 |
  | io_uring passthrough  | io_uring (IOPOLL) | 104 | 532 | 577 | 585 |

  All guest experiments are using the QEMU io_uring backend with SQPOLL and
  IOPOLL enabled. The virtio-blk driver is modified to support blovk io_poll
  on both virtqueues and io_uring passthrough.

Before developing this proof-of-concept further we would like to discuss
io_uring changes required to restrict rings since this mechanism is a
prerequisite for real-world use cases where guests are untrusted.

Restrictions
------------
This document proposes io_uring API changes that safely allow untrusted
applications or guests to use io_uring. io_uring's existing security model is
that of kernel system call handler code. It is designed to reject invalid
inputs from host userspace applications. Supporting guests as io_uring API
clients adds a new trust domain with access to even fewer resources than host
userspace applications.

Guests do not have direct access to host userspace application file descriptors
or memory. The host userspace application, a Virtual Machine Monitor (VMM) such
as QEMU, grants access to a subset of its file descriptors and memory. The
allowed file descriptors are typically the disk image files belonging to the
guest. The memory is typically the virtual machine's RAM that the VMM has
allocated on behalf of the guest.

The following extensions to the io_uring API allow the host application to
grant access to some of its file descriptors.

These extensions are designed to be applicable to other use cases besides
untrusted guests and are not virtualization-specific. For example, the
restrictions can be used to allow only a subset of sqe operations available to
an application similar to seccomp syscall whitelisting.

An address translation and memory restriction mechanism would also be
necessary, but we can discuss this later.

The IOURING_REGISTER_RESTRICTIONS opcode
----------------------------------------
The new io_uring_register(2) IOURING_REGISTER_RESTRICTIONS opcode permanently
installs a feature whitelist on an io_ring_ctx. The io_ring_ctx can then be
passed to untrusted code with the knowledge that only operations present in the
whitelist can be executed.

The whitelist approach ensures that new features added to io_uring do not
accidentally become available when an existing application is launched on a
newer kernel version.

The IORING_REGISTER_RESTRICTIONS opcode takes an array of struct
io_uring_restriction elements that describe whitelisted features:

  #define IORING_REGISTER_RESTRICTIONS 11

  /* struct io_uring_restriction::opcode values */
  enum {
      /* Allow an io_uring_register(2) opcode */
      IORING_RESTRICTION_REGISTER_OP,

      /* Allow an sqe opcode */
      IORING_RESTRICTION_SQE_OP,

      /* Only allow fixed files */
      IORING_RESTRICTION_FIXED_FILES_ONLY,

      /* Only allow registered addresses and translate them */
      IORING_RESTRICTION_BUFFER_CHECK
  };

  struct io_uring_restriction {
      __u16 opcode;
      union {
          __u8 register_op; /* IORING_RESTRICTION_REGISTER_OP */
          __u8 sqe_op;      /* IORING_RESTRICTION_SQE_OP */
      };
      __u8 resv;
      __u32 resv2[3];
  };

This call can only be made once. Afterwards it is not possible to change
restrictions anymore. This prevents untrusted code from removing restrictions.

Limiting access to io_uring operations
--------------------------------------
The following example shows how to whitelist IORING_OP_READV, IORING_OP_WRITEV,
and IORING_OP_FSYNC:

  struct io_uring_restriction restrictions[] = {
      {
          .opcode = IORING_RESTRICTION_SQE_OP,
          .sqe_op = IORING_OP_READV,
      },
      {
          .opcode = IORING_RESTRICTION_SQE_OP,
          .sqe_op = IORING_OP_WRITEV,
      },
      {
          .opcode = IORING_RESTRICTION_SQE_OP,
          .sqe_op = IORING_OP_FSYNC,
      },
      ...
  };

  io_uring_register(ringfd, IORING_REGISTER_RESTRICTIONS,
                    restrictions, ARRAY_SIZE(restrictions));

Limiting access to file descriptors
-----------------------------------
The fixed files mechanism can be used to limit access to a set of file
descriptors:

  struct io_uring_restriction restrictions[] = {
      {
          .opcode = IORING_RESTRICTION_FIXED_FILES_ONLY,
      },
      ...
  };

  io_uring_register(ringfd, IORING_REGISTER_RESTRICTIONS,
                    restrictions, ARRAY_SIZE(restrictions));

Only requests with the sqe->flags IOSQE_FIXED_FILE bit set will be allowed.


Thanks for your feedback,
Stefano

