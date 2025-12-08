Return-Path: <io-uring+bounces-10989-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C5D58CAE5AC
	for <lists+io-uring@lfdr.de>; Mon, 08 Dec 2025 23:46:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8275930253F5
	for <lists+io-uring@lfdr.de>; Mon,  8 Dec 2025 22:45:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 293CD2FBDF2;
	Mon,  8 Dec 2025 22:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="KIPlUo3z"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526582BEC4E
	for <io-uring@vger.kernel.org>; Mon,  8 Dec 2025 22:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765233950; cv=none; b=KVqJGNtXyoyT0qRcCTNyy5VWnFvI/hgC+ZwFyuWC5qvIxV0gYqMcXVmyQ5Cq2N1hQZwgBN1dkaFNYhVb8YATnl7ptjrXsBBmq8FR0BKThMjZl1J1Yv7HMTt/EtOuEF/HK0bjJkVsF+qOtiw6NzHFyK10bEPo2l+wZNUV3hn8PFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765233950; c=relaxed/simple;
	bh=VFeZzew3wgU3lnQXtHo0aCDQL4wEBDLOCuXv4A6jDIs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L3ReSARBMLh5qcvtI5cc7k3QEqVtyxVKTBhv4/g9I8lgnFinGGKZv+OpeZXecxUk08s4nr9fvmOAtIA3Nt2TqT4LTKwI38mU9DJqLXWE72d8uQT+PFnOPqBd0OtkBzZcg0xqpSW7dqEIpf8s40cFAczfPPITVTqSb9fMUSpsOvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=KIPlUo3z; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-bda175a2013so545442a12.3
        for <io-uring@vger.kernel.org>; Mon, 08 Dec 2025 14:45:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1765233947; x=1765838747; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=saoX2yZ96AIA3oGqO7CACdTr6VxjaneFvI1/wcG9YMg=;
        b=KIPlUo3znV8lVLASmnKPusdQaLUIx+ANetX94CJghL/77jG2oLko1YgOeE+5wPPEOv
         zdv2RyJy5eCXPgrnU2ux1mRQKEmQmDjFWjeothyJKmxurJaGWpOHmW6O2Cw4HeP9Y7ll
         FaLxQMm5z6ENbl3EsNBtIOaYv1yb2K491fC0DvFZ12H/l53Uijxd2PPs9e6o7AAQPRJK
         JmTxjGUyEcr90+YXrbctc799J79lniHdLpXkvbeC+lVVQtnqd8FHjWyWWLKGlL2H407R
         PQ4dY/7/ri3sdMjUtPA2eBUFZPvRBBjH+h0YCZYW0MZKGBHr8wd350z0p1P3Izakjac4
         MwYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765233947; x=1765838747;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=saoX2yZ96AIA3oGqO7CACdTr6VxjaneFvI1/wcG9YMg=;
        b=cIP+rQWddmpZv/qbm9wbNiE5k2WiiVTKUSbCz4kawZSRiywGX3SSKKYvdxwhXVBlko
         ceBY7usfLMPbM4r2ANfvSGycmlWtMnCIp5ke84jEPgjwX27DqK0/Lgp2nHjpp2q2ZKle
         HdmBav+mcMsLuKOmT4Y6B2v2xXQBlwk9lLgmcO2wbBA2LMZieVeTi7MXHrDcI8awG5Fv
         BWXqoqbtHqZJanvssg3gRJn5/Cqe+pb3jUC7kjcHIqdiOW9Wg33haKRoqfbq4trivTMJ
         9L/MhlIlXehwHpxQUfDIdaF+arjf4t1p7MCMHYldB/YkQJP3w1IyQLoZ/PS+ZtL272eF
         WZuw==
X-Forwarded-Encrypted: i=1; AJvYcCXDMWb9uVMzZfD1BWQKFQwaLHEBM0JAnt6Zd86dAZl7WZQs5m089w+asDZzaQxQhMAPNdyvjKuqZA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0m6sW0tAwCs59j8024T/Y2K6GsYJ7dTZLlaU09NnImttjfi+4
	wy7ERVAxZlLUO7AGtaaNvVF8crH1lxbsiHmOrARP4UWF9D4tVxAR5ZTk6QyCu5vYiPVNJ9CfPwC
	/fQiN3/fMHeYNKCe/m/z13DQy5TJ1HiO0nZ4q+xabGQ==
X-Gm-Gg: ASbGncv0cwoRCWQoqmeIzNNDchpclIpQYkk04OlsntcNnQ4H1lXBYnMdukcw3VJgviY
	Q8vjZV2NciNe8xUF84IJG+9e2OvtUGueCn618LHls7C80HRSbyitUN4AGP0PeOf6U0o9JjIHveq
	lBW4n19KzgNA2+nd8fpUtBN9pGLssrATZIiQi8tqTYlKjf6r4z31bEUUQ3dwDSoxMHjjtsXlixJ
	zhtRpeW2U3cOJM6+MddSBGm8gXpp4fdz+EK57GMpO5IPOi3a2WunC19XaJWfMmnJJ0V+Hwx
X-Google-Smtp-Source: AGHT+IEH8vn0YkufwzP5KoioqcF+B+bfSkDJPKAiwQyXImDOUGGYU9z5zZ1EKUPSoOSNHlemuG0HXEO0nxWEW/DuCOY=
X-Received: by 2002:a05:7022:4295:b0:11a:5cb2:24a0 with SMTP id
 a92af1059eb24-11f22ac22dcmr314098c88.1.1765233947177; Mon, 08 Dec 2025
 14:45:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251104162123.1086035-1-ming.lei@redhat.com> <20251104162123.1086035-4-ming.lei@redhat.com>
 <94f94f0e-7086-4f44-a658-9cb3b5496faf@samba.org> <aRW6LfJi63X7wbPm@fedora>
 <05a37623-c78c-4a86-a9f3-c78ce133fa66@samba.org> <aRabTk29_v6p92mY@fedora>
In-Reply-To: <aRabTk29_v6p92mY@fedora>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 8 Dec 2025 14:45:35 -0800
X-Gm-Features: AQt7F2pSGWKWoB5ss4CT1dXU8m8wS_nB9lSMim5BYVLvyxvdvk7Knc4ySzLZnQg
Message-ID: <CADUfDZqpTSihuYnTqUbtctrX4OGT7Szr-_wWb4xLgg11RcwYkA@mail.gmail.com>
Subject: Re: [PATCH 3/5] io_uring: bpf: extend io_uring with bpf struct_ops
To: Ming Lei <ming.lei@redhat.com>
Cc: Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	Akilesh Kailash <akailash@google.com>, bpf@vger.kernel.org, 
	Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2025 at 7:00=E2=80=AFPM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> On Thu, Nov 13, 2025 at 12:19:33PM +0100, Stefan Metzmacher wrote:
> > Am 13.11.25 um 11:59 schrieb Ming Lei:
> > > On Thu, Nov 13, 2025 at 11:32:56AM +0100, Stefan Metzmacher wrote:
> > > > Hi Ming,
> > > >
> > > > > io_uring can be extended with bpf struct_ops in the following way=
s:
> > > > >
> > > > > 1) add new io_uring operation from application
> > > > > - one typical use case is for operating device zero-copy buffer, =
which
> > > > > belongs to kernel, and not visible or too expensive to export to
> > > > > userspace, such as supporting copy data from this buffer to users=
pace,
> > > > > decompressing data to zero-copy buffer in Android case[1][2], or
> > > > > checksum/decrypting.
> > > > >
> > > > > [1] https://lpc.events/event/18/contributions/1710/attachments/14=
40/3070/LPC2024_ublk_zero_copy.pdf
> > > > >
> > > > > 2) extend 64 byte SQE, since bpf map can be used to store IO data
> > > > >      conveniently
> > > > >
> > > > > 3) communicate in IO chain, since bpf map can be shared among IOs=
,
> > > > > when one bpf IO is completed, data can be written to IO chain wid=
e
> > > > > bpf map, then the following bpf IO can retrieve the data from thi=
s bpf
> > > > > map, this way is more flexible than io_uring built-in buffer
> > > > >
> > > > > 4) pretty handy to inject error for test purpose
> > > > >
> > > > > bpf struct_ops is one very handy way to attach bpf prog with kern=
el, and
> > > > > this patch simply wires existed io_uring operation callbacks with=
 added
> > > > > uring bpf struct_ops, so application can define its own uring bpf
> > > > > operations.
> > > >
> > > > This sounds useful to me.
> > > >
> > > > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > > > > ---
> > > > >    include/uapi/linux/io_uring.h |   9 ++
> > > > >    io_uring/bpf.c                | 271 ++++++++++++++++++++++++++=
+++++++-
> > > > >    io_uring/io_uring.c           |   1 +
> > > > >    io_uring/io_uring.h           |   3 +-
> > > > >    io_uring/uring_bpf.h          |  30 ++++
> > > > >    5 files changed, 311 insertions(+), 3 deletions(-)
> > > > >
> > > > > diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/i=
o_uring.h
> > > > > index b8c49813b4e5..94d2050131ac 100644
> > > > > --- a/include/uapi/linux/io_uring.h
> > > > > +++ b/include/uapi/linux/io_uring.h
> > > > > @@ -74,6 +74,7 @@ struct io_uring_sqe {
> > > > >                 __u32           install_fd_flags;
> > > > >                 __u32           nop_flags;
> > > > >                 __u32           pipe_flags;
> > > > > +               __u32           bpf_op_flags;
> > > > >         };
> > > > >         __u64   user_data;      /* data to be passed back at comp=
letion time */
> > > > >         /* pack this to avoid bogus arm OABI complaints */
> > > > > @@ -427,6 +428,13 @@ enum io_uring_op {
> > > > >    #define IORING_RECVSEND_BUNDLE               (1U << 4)
> > > > >    #define IORING_SEND_VECTORIZED               (1U << 5)
> > > > > +/*
> > > > > + * sqe->bpf_op_flags           top 8bits is for storing bpf op
> > > > > + *                             The other 24bits are used for bpf=
 prog
> > > > > + */
> > > > > +#define IORING_BPF_OP_BITS     (8)
> > > > > +#define IORING_BPF_OP_SHIFT    (24)
> > > > > +
> > > > >    /*
> > > > >     * cqe.res for IORING_CQE_F_NOTIF if
> > > > >     * IORING_SEND_ZC_REPORT_USAGE was requested
> > > > > @@ -631,6 +639,7 @@ struct io_uring_params {
> > > > >    #define IORING_FEAT_MIN_TIMEOUT              (1U << 15)
> > > > >    #define IORING_FEAT_RW_ATTR          (1U << 16)
> > > > >    #define IORING_FEAT_NO_IOWAIT                (1U << 17)
> > > > > +#define IORING_FEAT_BPF                        (1U << 18)
> > > > >    /*
> > > > >     * io_uring_register(2) opcodes and arguments
> > > > > diff --git a/io_uring/bpf.c b/io_uring/bpf.c
> > > > > index bb1e37d1e804..8227be6d5a10 100644
> > > > > --- a/io_uring/bpf.c
> > > > > +++ b/io_uring/bpf.c
> > > > > @@ -4,28 +4,95 @@
> > > > >    #include <linux/kernel.h>
> > > > >    #include <linux/errno.h>
> > > > >    #include <uapi/linux/io_uring.h>
> > > > > +#include <linux/init.h>
> > > > > +#include <linux/types.h>
> > > > > +#include <linux/bpf_verifier.h>
> > > > > +#include <linux/bpf.h>
> > > > > +#include <linux/btf.h>
> > > > > +#include <linux/btf_ids.h>
> > > > > +#include <linux/filter.h>
> > > > >    #include "io_uring.h"
> > > > >    #include "uring_bpf.h"
> > > > > +#define MAX_BPF_OPS_COUNT      (1 << IORING_BPF_OP_BITS)
> > > > > +
> > > > >    static DEFINE_MUTEX(uring_bpf_ctx_lock);
> > > > >    static LIST_HEAD(uring_bpf_ctx_list);
> > > > > +DEFINE_STATIC_SRCU(uring_bpf_srcu);
> > > > > +static struct uring_bpf_ops bpf_ops[MAX_BPF_OPS_COUNT];
> > > >
> > > > This indicates to me that the whole system with all applications in=
 all namespaces
> > > > need to coordinate in order to use these 256 ops?
> > >
> > > So far there is only 62 in-tree io_uring operation defined, I feel 25=
6
> > > should be enough.
> > >
> > > > I think in order to have something useful, this should be per
> > > > struct io_ring_ctx and each application should be able to load
> > > > its own bpf programs.
> > >
> > > per-ctx requirement looks reasonable, and it shouldn't be hard to
> > > support.
> > >
> > > >
> > > > Something that uses bpf_prog_get_type() based on a bpf_fd
> > > > like SIOCKCMATTACH in net/kcm/kcmsock.c.
> > >
> > > I considered per-ctx prog before, one drawback is the prog can't be s=
hared
> > > among io_ring_ctx, which could waste memory. In my ublk case, there c=
an be
> > > lots of devices sharing same bpf prog.
> >
> > Can't the ublk instances coordinate and use the same bpf_fd?
> > new instances could request it via a unix socket and SCM_RIGHTS
> > from a long running loading process. On the other hand do they
> > really want to share?
>
> struct_ops is typically registered once, used everywhere, such as
> sched_ext and socket example.
>
> This patch follows this usage, so every io_uring application can access i=
t like the
> in-kernel operations.
>
> I can understand the requirement for per-io-ring-ctx struct_ops, which
> won't cause conflict among different applications.
>
> For example, ublk/raid5, there are 100 such devices, each device is creat=
ed in dedicated
> process and uses its own io-uring, so 100 same struct_ops prog are regist=
ered in memory.
> Given struct_ops prog is registered as per-io-ring-ctx, it may not be sha=
red by `bpf_fd`, IMO.

I agree with Stefan that a global IORING_OP_BPF op to BPF program
mapping will be difficult to coordinate between processes. For
example, consider two different ublk server programs that each want to
use a different BPF program. Ideally, each should be an independent
program and not need to know the op ids used by the other.
On the other hand, a multithreaded process may have multiple
io_ring_ctxs and want to use the same IORING_OP_BPF ops with all of
them. So a process-level mapping seems to make the most sense. And
that's exactly the mapping level that we would get from using the BPF
program file descriptor to specify the IORING_OP_BPF op. Additionally,
as Stefan points out, the IORING_OP_BPF program could be shared with
another process by sending the file descriptor using SCM_RIGHTS. And
the file descriptor lookup overhead could be avoided in the I/O path
using io_uring's existing support for registered files.

Best,
Caleb

>
> >
> > I don't know much about bpf in details, so I'm wondering in your
> > example from
> > https://github.com/ming1/liburing/commit/625b69ddde15ad80e078c684ba166f=
49c1174fa4
> >
> > Would memory_map be global in the whole system or would
> > each loaded instance of the program have it's own instance of memory_ma=
p?
>
> bpf map is global.
>
> At default, each loaded prog owns the map, but it may be exported for
> others by pinning the map.
>
> It is easy to verify by writing test code in tools/testing/selftests/
>
> But I am not an bpf expert...
>
> Thanks,
> Ming
>

