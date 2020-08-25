Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBBE251C2F
	for <lists+io-uring@lfdr.de>; Tue, 25 Aug 2020 17:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgHYPVL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Aug 2020 11:21:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34953 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727114AbgHYPVJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Aug 2020 11:21:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598368867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/ww29tGGGCJNK0uYcOWj2E3kj6GiHCX868VNsZmxKCg=;
        b=edaS1/tqE0gcBr6a/jTkhPqjwAhwkPWawqr3MKdzjVV9G+HdTCFr5Mr/gi2xQVa9W+EKZ9
        n7fD2fosUx8/v/+Rj5uxC3N25wuWI6ahnsAxQmrnvIGmTGDBUjt877UfxxFEdW8XSY8mMR
        N51Lt+ebG9cZR8pYeGPGfrxVpoJk65k=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-3PTkMtytNd-R12saFSUUTw-1; Tue, 25 Aug 2020 11:20:49 -0400
X-MC-Unique: 3PTkMtytNd-R12saFSUUTw-1
Received: by mail-wr1-f72.google.com with SMTP id j2so5281450wrr.14
        for <io-uring@vger.kernel.org>; Tue, 25 Aug 2020 08:20:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/ww29tGGGCJNK0uYcOWj2E3kj6GiHCX868VNsZmxKCg=;
        b=Eo9PICTUnTu0W3PJX1hJ0inxAPV/0lMh4k6tqcA6N/rOs2bQEVIHHyIiBkfxgC4ZOT
         KnP/D8h19tXNk/S5HD99pOvgPS01lE2BeNiqtX4DpCryMXigO62MkZzCLzcQ5pN3J2SV
         sd+34dUBl69GEwkUpGFMIRKNu+2/U9XUUOkYtVnBaNC6jmJZwCTfBbxxKUKs0vxM5d6f
         3rZGsDtvG6n4faSxziUJ4PECFwB9e1s4btY5NaL2RdV2mN28soX+nUEnh2H05lAGaXE/
         GJqHxJ8SWws5gK0kozC2oMEcxlAxnWAfvjEL4TYbYqaHAJHoVPpO1DV5ztxcbZn4MQ5z
         LSnw==
X-Gm-Message-State: AOAM531QELPfmoD+Iiak0sOzsymhLivQQX9UgXnIijkeWfpPlb/EmXdz
        A7Bp/hzwcaHsTjRgk8uhigt2r0KAdar42nPZh3bPOrf2kMHttRXFvAB5JI4a06XS++469gvIbBp
        0mZQkw9eOrjwQcP8Bx+o=
X-Received: by 2002:adf:f149:: with SMTP id y9mr10788356wro.93.1598368848124;
        Tue, 25 Aug 2020 08:20:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFcOj3KLiVhLrb5kKPj9J8yKhtonxgeHvdnpuzUycgw3vzeJpSYbKYVTAeVF3IvMjryZZqFg==
X-Received: by 2002:adf:f149:: with SMTP id y9mr10788321wro.93.1598368847815;
        Tue, 25 Aug 2020 08:20:47 -0700 (PDT)
Received: from steredhat (host-79-51-197-141.retail.telecomitalia.it. [79.51.197.141])
        by smtp.gmail.com with ESMTPSA id v20sm3575043wra.72.2020.08.25.08.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 08:20:47 -0700 (PDT)
Date:   Tue, 25 Aug 2020 17:20:44 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Jann Horn <jannh@google.com>, Jeff Moyer <jmoyer@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Sargun Dhillon <sargun@sargun.me>,
        Kees Cook <keescook@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        Aleksa Sarai <asarai@suse.de>,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH v4 0/3] io_uring: add restrictions to support untrusted
 applications and guests
Message-ID: <CAGxU2F55zzMzc043P88TWJNr2poUTVwrRmu86qyh0uM-8gimng@mail.gmail.com>
References: <20200813153254.93731-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200813153254.93731-1-sgarzare@redhat.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,
this is a gentle ping.

I'll respin, using memdup_user() for restriction registration.
I'd like to get some feedback to see if I should change anything else.

Do you think it's in good shape?

Thanks,
Stefano

On Thu, Aug 13, 2020 at 5:34 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> v4:
>  - rebased on top of io_uring-5.9
>  - fixed io_uring_enter() exit path when ring is disabled
>
> v3: https://lore.kernel.org/io-uring/20200728160101.48554-1-sgarzare@redhat.c=
> om/
> RFC v2: https://lore.kernel.org/io-uring/20200716124833.93667-1-sgarzare@redh=
> at.com
> RFC v1: https://lore.kernel.org/io-uring/20200710141945.129329-1-sgarzare@red=
> hat.com
>
> Following the proposal that I send about restrictions [1], I wrote this series
> to add restrictions in io_uring.
>
> I also wrote helpers in liburing and a test case (test/register-restrictions.=
> c)
> available in this repository:
> https://github.com/stefano-garzarella/liburing (branch: io_uring_restrictions)
>
> Just to recap the proposal, the idea is to add some restrictions to the
> operations (sqe opcode and flags, register opcode) to safely allow untrusted
> applications or guests to use io_uring queues.
>
> The first patch changes io_uring_register(2) opcodes into an enumeration to
> keep track of the last opcode available.
>
> The second patch adds IOURING_REGISTER_RESTRICTIONS opcode and the code to
> handle restrictions.
>
> The third patch adds IORING_SETUP_R_DISABLED flag to start the rings disabled,
> allowing the user to register restrictions, buffers, files, before to start
> processing SQEs.
>
> Comments and suggestions are very welcome.
>
> Thank you in advance,
> Stefano
>
> [1] https://lore.kernel.org/io-uring/20200609142406.upuwpfmgqjeji4lc@steredha=
> t/
>
> Stefano Garzarella (3):
>   io_uring: use an enumeration for io_uring_register(2) opcodes
>   io_uring: add IOURING_REGISTER_RESTRICTIONS opcode
>   io_uring: allow disabling rings during the creation
>
>  fs/io_uring.c                 | 160 ++++++++++++++++++++++++++++++++--
>  include/uapi/linux/io_uring.h |  60 ++++++++++---
>  2 files changed, 203 insertions(+), 17 deletions(-)
>
> --=20
> 2.26.2
>

