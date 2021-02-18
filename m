Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96BFC31E6FB
	for <lists+io-uring@lfdr.de>; Thu, 18 Feb 2021 08:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbhBRHbb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Feb 2021 02:31:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbhBRH1H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Feb 2021 02:27:07 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9DB7C0613D6;
        Wed, 17 Feb 2021 23:25:58 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id o7so672111ils.2;
        Wed, 17 Feb 2021 23:25:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aRuJyoM+/xl5wMFj4NXGlzmwqBLns3FaELX5kXZfdm4=;
        b=GxVHp8Ql3rsy69zMtfuRDKTR3D0cu34Tsbg2DJB9Zd0+hIYgvtBY/Q4k1RvVhwcj4A
         bcaiLLI+P0Vt4hj+ZaaPopnKlyNRvqtSYpnum35nWFBT3yHgBo0yKTMlYDpFnljyQIno
         SrPEI9Pc7VLXKsby1ENT27g4a1VO6dOnnOl0PbPk6HU1eDlP/PWatx2aT5um+O7P25H2
         bYitxST5sWdODWXAzsTi5A4SCp4VCYEhCntpAz3q4skws8BFe+8ZQA8gWP6UKUbM6Q5T
         HTTW77C+Q8rhtL2bX01TKY2fmBiJgIjq6Z2XLCxHCNVxuwmDSUJGrVpWV1FwC0NuHJbS
         u03g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aRuJyoM+/xl5wMFj4NXGlzmwqBLns3FaELX5kXZfdm4=;
        b=Vn6b84sn3NDfwZrlrvRk8YrdfwKhJqzDX25VE0mzYaNEsxTcyKLGy+080TipZk/k3V
         NqXVpXylx0IHKjj3lJzhS2+5vXNwevxrulnzLinMhEUSBzP0SJCY811g7SEiJuhNwpu7
         1FJHERRFyOh0JaC52KWr70AFRGPJ+SaVi19o0I9y7nh3txfZTUuAKwv4Xle+B977cXvw
         S76yDLQ0rOynk/OVWb36rtR/zslRg+IVc/RozdHcBd9YZ72ke+H+p40hbKOl2uHz4Z44
         nIIeAyj7VAkndWvNdmjcb9q0Ifc9e2vir/pyrXZ8IC/NDwUQUNPEZXthBbOkpviJ/Vg1
         PM/g==
X-Gm-Message-State: AOAM530NdX03DfRMLkEwaSdFJaSEgWadM9z4R3nl51Vy8iBCsZILkoA1
        5hZhCyoFkUYdhUQLoEM1tDmC4H2f5BwGFbgg41k5xH2a+lc=
X-Google-Smtp-Source: ABdhPJxIn4LYLxJPU7j376W23DTY616a/Uymij664OLDburjHvoT0qNe5/BIaK8xPpJTN+NDTUw70NJ0k8UJaAxcwr4=
X-Received: by 2002:a92:1312:: with SMTP id 18mr2560685ilt.92.1613633158271;
 Wed, 17 Feb 2021 23:25:58 -0800 (PST)
MIME-Version: 1.0
References: <20210202082353.2152271-1-dkadashev@gmail.com>
In-Reply-To: <20210202082353.2152271-1-dkadashev@gmail.com>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Thu, 18 Feb 2021 14:25:47 +0700
Message-ID: <CAOKbgA7iBjF8x44G8JL86see10jBRo1ezABG8kT==DZHE1FKLg@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] io_uring: add mkdirat support
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Feb 2, 2021 at 3:24 PM Dmitry Kadashev <dkadashev@gmail.com> wrote:
>
> This adds mkdirat support to io_uring and is heavily based on recently
> added renameat() / unlinkat() support.
>
> The first patch is preparation with no functional changes, makes
> do_mkdirat accept struct filename pointer rather than the user string.
>
> The second one leverages that to implement mkdirat in io_uring.
>
> Based on for-5.11/io_uring.
>
> Changes since v1:
> - do not mess with struct filename's refcount in do_mkdirat, instead add
>   and use __filename_create() that does not drop the name on success;
>
> Dmitry Kadashev (2):
>   fs: make do_mkdirat() take struct filename
>   io_uring: add support for IORING_OP_MKDIRAT
>
>  fs/internal.h                 |  1 +
>  fs/io_uring.c                 | 58 +++++++++++++++++++++++++++++++++++
>  fs/namei.c                    | 25 +++++++++++----
>  include/uapi/linux/io_uring.h |  1 +
>  4 files changed, 79 insertions(+), 6 deletions(-)

Hi Jens,

Ping. I've tried reaching out to Al wrt the first patch, but that did not seem
to work. Is there a chance to get this into 5.12 at this point?

-- 
Dmitry Kadashev
