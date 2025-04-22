Return-Path: <io-uring+bounces-7604-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D7A51A960EC
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 10:23:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF5903A93DE
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 08:22:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32D2F1F03DE;
	Tue, 22 Apr 2025 08:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lBP/svYt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8B41F03C5;
	Tue, 22 Apr 2025 08:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745310189; cv=none; b=FoL9FDuaKzFBTaJ180NdsX4wO42d1C+Op58La3z656EJNdgF7z4FR5UyjhmikZPrDvjkm6JaupqsOJ16Qyw41LQgQB2sVc56IsTSY8aQmVMhWEHLwhSBeHxd0XWMTCs8OMgSF8yGTRT2otThehbyoWjrVtS0P0hgSP35DnT856I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745310189; c=relaxed/simple;
	bh=2uP34/FeIpIk/Wcl1gOmNK8ZKfSeIZaiwifRRNPt/Ns=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WqoLAH4Q9qu0uWb7fVl8AO4w1O5J0Stp48qXb4SNXmNuIG2ppuXevCti1Z5bxGd9sjsP044hEaYBndlL7Xy+6MTCXSermkm4jQX5uzJPjDPbqlVNIEFmurirndpDr+ZHNxKwq8b9kSV0zy9Q+kBuZVxpE+eNPBrJRoULkmPg3nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lBP/svYt; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-604f0d27c24so2216160eaf.2;
        Tue, 22 Apr 2025 01:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745310186; x=1745914986; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Eib6UYFi1fJr++H9on8mAKz/kr5wlL2zyWlhpLauZLc=;
        b=lBP/svYtkb1z0ZLBuCJdxxpt8ndFmN6x0+Cm4nBos1hHoRw+EiNKFLsyR9VTvhjY7C
         RCCte8Z6ycudUM4YV4+nPipC46V3ppWwBuZGLdZzy+4M8M06UQVMgObMulSNxiKA+9TY
         bfm9lLbVqy0NiEw2AG0kGm/DdrEt/2apjOmrOVFgYr4GOkstawGbb2NYIypCH6nY020n
         DVAc9zsfwUmz3egTJb4jMsUUWySuBnHC33vofYE/7GhU2b0ed8zAd+39v7hnrPpghYHG
         +DmrSr1RynWr+/ANNuhDepSmctTBnhmBa72HSZgd8kme8iQKoOhwDBq5UpDZHCIzPppi
         etHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745310186; x=1745914986;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Eib6UYFi1fJr++H9on8mAKz/kr5wlL2zyWlhpLauZLc=;
        b=YcHzqbWq6hoAjfwVx2GeD2JDpQF6GW8JZnbpcYAbrPMf8tRnx1uze2NbCeEfIU0DPU
         W3ctGlTSSwIbFcKhAHYh2g9GpKOsRX5ekBwli2mWbR0VKkKGfq15Dq4Eral3L0USGNsX
         FHfNDWCTMhNGjFk9Gm2fPPsJ4/b8oQ7t6/t6ocE/jz5njg5KZjwhjh/cOPQxMQC//6lR
         qoceBwvWg2RyWregzxfdJ32qbD1gIGr7eqnWrnFMq7vQWGHHGvFTUms+aIBR8cdJwFA+
         XUe3sj99CPBSCYNwtk4ApmkgEtRLs116m7Gvz76Yl1cpMvWyJwiZZUkyOEpJ7WlXsT2T
         tTSw==
X-Forwarded-Encrypted: i=1; AJvYcCV5h5a38pC79u3Uz7FUkS74T6iU+kgYOC+hEhwv0L8D8IAaQZ/n2xW+7hQPc1ioZFb7QH8y/SVipE1u79bw@vger.kernel.org, AJvYcCXeOJKwLU+Q25in9laTb4CyKcXFYKVIBkttSSjK6SqREQ9O4IXb292TEYI5rl2YfwUhnk3PrHVIeg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxrUDDdGrlVnNYHgp77lLUp+fYhXmLXIhhiCm+rzfslF3fowH6U
	k0I/KAPmTDot+8TjQ3xtB792nLxPomt60SAr8RncYz/lR7RiXO9XxCPVWXbkYrvEanvcwwti2y+
	QjrdD6ITYL0LrtW0MUVzdIQ0z6uU=
X-Gm-Gg: ASbGncu6wUbTiA9UTllz7iKz2qqxXUH7FAeOH6VCrxWzUqHxcvZDQkBtvIKy4Xrg5P2
	5aEXvKnUOgLdoOzcCzLhUxia9Zc0YSF0GtC5X+NdQc+Uhr4GCJMtJXtd7S+p1wgaUbSwxbPFXjL
	BKc3Kas4IJpREnPyVs7189R1M=
X-Google-Smtp-Source: AGHT+IH73aeMXL7YPr7VbOhaDc7lZ6qCE8e7MFFs2JuKTrk1QSoj0Tr2ke5rvX4Jp7KqXTYvwKrnshZuvZZ1Nh9uScs=
X-Received: by 2002:a05:6871:2109:b0:29e:74a0:e03f with SMTP id
 586e51a60fabf-2d526d4efbcmr8286598fac.24.1745310186574; Tue, 22 Apr 2025
 01:23:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250422030153.1166445-1-qq282012236@gmail.com> <1c141101-035f-4ff6-a260-f31dca39fdc8@gmail.com>
In-Reply-To: <1c141101-035f-4ff6-a260-f31dca39fdc8@gmail.com>
From: =?UTF-8?B?5aec5pm65Lyf?= <qq282012236@gmail.com>
Date: Tue, 22 Apr 2025 16:22:52 +0800
X-Gm-Features: ATxdqUHsW549CjADjQkeF24dIy0oIJ_3wSQeFdmFn0yYeM8PaYZjnYbeZYtkTzQ
Message-ID: <CANHzP_tebha40yy=8rqeu9DMqfrS-veF3=rp76H8udDvs69rfA@mail.gmail.com>
Subject: Re: [PATCH] io_uring: Add new functions to handle user fault scenarios
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2025 at 3:59=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> On 4/22/25 04:01, Zhiwei Jiang wrote:
> ...
> > I tracked the address that triggered the fault and the related function
> > graph, as well as the wake-up side of the user fault, and discovered th=
is
> > : In the IOU worker, when fault in a user space page, this space is
> > associated with a userfault but does not sleep. This is because during
> > scheduling, the judgment in the IOU worker context leads to early retur=
n.
> > Meanwhile, the listener on the userfaultfd user side never performs a C=
OPY
> > to respond, causing the page table entry to remain empty. However, due =
to
> > the early return, it does not sleep and wait to be awakened as in a nor=
mal
> > user fault, thus continuously faulting at the same address,so CPU loop.
> >
> > Therefore, I believe it is necessary to specifically handle user faults=
 by
> > setting a new flag to allow schedule function to continue in such cases=
,
> > make sure the thread to sleep.Export the relevant functions and struct =
for
> > user fault.
>
> That's an interesting scenario. Not looking deeper into it, I don't see
> any callers to set_userfault_flag_for_ioworker(), and so there is no one
> to set IO_WORKER_F_FAULT. Is there a second patch patch I lost?
>
> --
> Pavel Begunkov
>
Sorry, the following changes haven't been submitted yet. I was planning
to submit them separately, thinking they belong to two different subsystems=
.
The other changes that haven't been submitted are as follows:
diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index d80f94346199..74bead069e85 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -32,6 +32,7 @@
 #include <linux/swapops.h>
 #include <linux/miscdevice.h>
 #include <linux/uio.h>
+#include "../io_uring/io-wq.h"

 static int sysctl_unprivileged_userfaultfd __read_mostly;

@@ -369,7 +370,10 @@ vm_fault_t handle_userfault(struct vm_fault *vmf,
unsigned long reason)
        vm_fault_t ret =3D VM_FAULT_SIGBUS;
        bool must_wait;
        unsigned int blocking_state;
+       struct io_worker *worker =3D current->worker_private;

+       if (worker)
+               set_userfault_flag_for_ioworker(worker);
        /*
         * We don't do userfault handling for the final child pid update
         * and when coredumping (faults triggered by get_dump_page()).
@@ -506,6 +510,9 @@ vm_fault_t handle_userfault(struct vm_fault *vmf,
unsigned long reason)

        __set_current_state(TASK_RUNNING);

+       if (worker)
+               clear_userfault_flag_for_ioworker(worker);
+
        /*
         * Here we race with the list_del; list_add in
         * userfaultfd_ctx_read(), however because we don't ever run

