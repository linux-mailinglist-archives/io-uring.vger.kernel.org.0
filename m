Return-Path: <io-uring+bounces-10991-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B1F2ECAEC65
	for <lists+io-uring@lfdr.de>; Tue, 09 Dec 2025 04:09:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 296EA30281BB
	for <lists+io-uring@lfdr.de>; Tue,  9 Dec 2025 03:08:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E80F72DD60E;
	Tue,  9 Dec 2025 03:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wf5rUkJF"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8133B8D6A
	for <io-uring@vger.kernel.org>; Tue,  9 Dec 2025 03:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765249734; cv=none; b=jpdW+3q2jA3EgzNAoJ16ASqA3gPOxIJUag5i1tWeLuPkJiVFE9CqGinXf2sCsWaUhUr/Gmvz1hhmGZp/f2qTBzzjnetsFuetdO6eoiKW1GDAtj9lR1BhAh1OHgzwzD7ZGIrMKCmzrHMlIHjc1p4130MVfslsEjYpcRASLrKd/Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765249734; c=relaxed/simple;
	bh=sC6i1KJ1PNGNvyrOs04xpHhSDejYfgZbnn/h5pqJ1q0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=itrYFZvuvYl2ZeCC8pdn6JbyXsBCCZGx2AV3wMRWdwsxUJpJbs4pxqxWSZmq1d5j28PM5vaJme+zPOLe/5s9PufTHwXbnrb3t2D9aL+czg1NpfFNpxLuYvfPKayNy0idh6iMcK6gSOriUbZotVOhk69HKnM+PozEQl11LuVBUd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wf5rUkJF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765249731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kC4p4OA5IlaAoD+5KGx/pZrkzs7juElZ099W0/pls/M=;
	b=Wf5rUkJFNvosHfTw/r5l2/Q1y21tNit0Ahi/IjS//Ex23ssnp7R2fz022lya22MCN75Iep
	9BFXt1LSURBAzuPVHnK/WV8WuHFeh1ghTy1DVDxXfkcK2yqlRtA0dTI7Fh/V+QT+W1lxAq
	A2j7Izh9FWiRoI6oCXyTN1JmjisEyOU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-335-lTtql0uANkafMM_OyT65qw-1; Mon,
 08 Dec 2025 22:08:47 -0500
X-MC-Unique: lTtql0uANkafMM_OyT65qw-1
X-Mimecast-MFC-AGG-ID: lTtql0uANkafMM_OyT65qw_1765249726
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D49EC1800342;
	Tue,  9 Dec 2025 03:08:45 +0000 (UTC)
Received: from fedora (unknown [10.72.116.98])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 201E61800451;
	Tue,  9 Dec 2025 03:08:40 +0000 (UTC)
Date: Tue, 9 Dec 2025 11:08:36 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org, Akilesh Kailash <akailash@google.com>,
	bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH 3/5] io_uring: bpf: extend io_uring with bpf struct_ops
Message-ID: <aTeStJ9_Tu0i5_wH@fedora>
References: <20251104162123.1086035-1-ming.lei@redhat.com>
 <20251104162123.1086035-4-ming.lei@redhat.com>
 <94f94f0e-7086-4f44-a658-9cb3b5496faf@samba.org>
 <aRW6LfJi63X7wbPm@fedora>
 <05a37623-c78c-4a86-a9f3-c78ce133fa66@samba.org>
 <aRabTk29_v6p92mY@fedora>
 <CADUfDZqpTSihuYnTqUbtctrX4OGT7Szr-_wWb4xLgg11RcwYkA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZqpTSihuYnTqUbtctrX4OGT7Szr-_wWb4xLgg11RcwYkA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Mon, Dec 08, 2025 at 02:45:35PM -0800, Caleb Sander Mateos wrote:
> On Thu, Nov 13, 2025 at 7:00 PM Ming Lei <ming.lei@redhat.com> wrote:
> >
> > On Thu, Nov 13, 2025 at 12:19:33PM +0100, Stefan Metzmacher wrote:
> > > Am 13.11.25 um 11:59 schrieb Ming Lei:
> > > > On Thu, Nov 13, 2025 at 11:32:56AM +0100, Stefan Metzmacher wrote:
> > > > > Hi Ming,
> > > > >
> > > > > > io_uring can be extended with bpf struct_ops in the following ways:
> > > > > >
> > > > > > 1) add new io_uring operation from application
> > > > > > - one typical use case is for operating device zero-copy buffer, which
> > > > > > belongs to kernel, and not visible or too expensive to export to
> > > > > > userspace, such as supporting copy data from this buffer to userspace,
> > > > > > decompressing data to zero-copy buffer in Android case[1][2], or
> > > > > > checksum/decrypting.
> > > > > >
> > > > > > [1] https://lpc.events/event/18/contributions/1710/attachments/1440/3070/LPC2024_ublk_zero_copy.pdf
> > > > > >
> > > > > > 2) extend 64 byte SQE, since bpf map can be used to store IO data
> > > > > >      conveniently
> > > > > >
> > > > > > 3) communicate in IO chain, since bpf map can be shared among IOs,
> > > > > > when one bpf IO is completed, data can be written to IO chain wide
> > > > > > bpf map, then the following bpf IO can retrieve the data from this bpf
> > > > > > map, this way is more flexible than io_uring built-in buffer
> > > > > >
> > > > > > 4) pretty handy to inject error for test purpose
> > > > > >
> > > > > > bpf struct_ops is one very handy way to attach bpf prog with kernel, and
> > > > > > this patch simply wires existed io_uring operation callbacks with added
> > > > > > uring bpf struct_ops, so application can define its own uring bpf
> > > > > > operations.
> > > > >
> > > > > This sounds useful to me.
> > > > >
> > > > > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > > > > > ---
> > > > > >    include/uapi/linux/io_uring.h |   9 ++
> > > > > >    io_uring/bpf.c                | 271 +++++++++++++++++++++++++++++++++-
> > > > > >    io_uring/io_uring.c           |   1 +
> > > > > >    io_uring/io_uring.h           |   3 +-
> > > > > >    io_uring/uring_bpf.h          |  30 ++++
> > > > > >    5 files changed, 311 insertions(+), 3 deletions(-)
> > > > > >
> > > > > > diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> > > > > > index b8c49813b4e5..94d2050131ac 100644
> > > > > > --- a/include/uapi/linux/io_uring.h
> > > > > > +++ b/include/uapi/linux/io_uring.h
> > > > > > @@ -74,6 +74,7 @@ struct io_uring_sqe {
> > > > > >                 __u32           install_fd_flags;
> > > > > >                 __u32           nop_flags;
> > > > > >                 __u32           pipe_flags;
> > > > > > +               __u32           bpf_op_flags;
> > > > > >         };
> > > > > >         __u64   user_data;      /* data to be passed back at completion time */
> > > > > >         /* pack this to avoid bogus arm OABI complaints */
> > > > > > @@ -427,6 +428,13 @@ enum io_uring_op {
> > > > > >    #define IORING_RECVSEND_BUNDLE               (1U << 4)
> > > > > >    #define IORING_SEND_VECTORIZED               (1U << 5)
> > > > > > +/*
> > > > > > + * sqe->bpf_op_flags           top 8bits is for storing bpf op
> > > > > > + *                             The other 24bits are used for bpf prog
> > > > > > + */
> > > > > > +#define IORING_BPF_OP_BITS     (8)
> > > > > > +#define IORING_BPF_OP_SHIFT    (24)
> > > > > > +
> > > > > >    /*
> > > > > >     * cqe.res for IORING_CQE_F_NOTIF if
> > > > > >     * IORING_SEND_ZC_REPORT_USAGE was requested
> > > > > > @@ -631,6 +639,7 @@ struct io_uring_params {
> > > > > >    #define IORING_FEAT_MIN_TIMEOUT              (1U << 15)
> > > > > >    #define IORING_FEAT_RW_ATTR          (1U << 16)
> > > > > >    #define IORING_FEAT_NO_IOWAIT                (1U << 17)
> > > > > > +#define IORING_FEAT_BPF                        (1U << 18)
> > > > > >    /*
> > > > > >     * io_uring_register(2) opcodes and arguments
> > > > > > diff --git a/io_uring/bpf.c b/io_uring/bpf.c
> > > > > > index bb1e37d1e804..8227be6d5a10 100644
> > > > > > --- a/io_uring/bpf.c
> > > > > > +++ b/io_uring/bpf.c
> > > > > > @@ -4,28 +4,95 @@
> > > > > >    #include <linux/kernel.h>
> > > > > >    #include <linux/errno.h>
> > > > > >    #include <uapi/linux/io_uring.h>
> > > > > > +#include <linux/init.h>
> > > > > > +#include <linux/types.h>
> > > > > > +#include <linux/bpf_verifier.h>
> > > > > > +#include <linux/bpf.h>
> > > > > > +#include <linux/btf.h>
> > > > > > +#include <linux/btf_ids.h>
> > > > > > +#include <linux/filter.h>
> > > > > >    #include "io_uring.h"
> > > > > >    #include "uring_bpf.h"
> > > > > > +#define MAX_BPF_OPS_COUNT      (1 << IORING_BPF_OP_BITS)
> > > > > > +
> > > > > >    static DEFINE_MUTEX(uring_bpf_ctx_lock);
> > > > > >    static LIST_HEAD(uring_bpf_ctx_list);
> > > > > > +DEFINE_STATIC_SRCU(uring_bpf_srcu);
> > > > > > +static struct uring_bpf_ops bpf_ops[MAX_BPF_OPS_COUNT];
> > > > >
> > > > > This indicates to me that the whole system with all applications in all namespaces
> > > > > need to coordinate in order to use these 256 ops?
> > > >
> > > > So far there is only 62 in-tree io_uring operation defined, I feel 256
> > > > should be enough.
> > > >
> > > > > I think in order to have something useful, this should be per
> > > > > struct io_ring_ctx and each application should be able to load
> > > > > its own bpf programs.
> > > >
> > > > per-ctx requirement looks reasonable, and it shouldn't be hard to
> > > > support.
> > > >
> > > > >
> > > > > Something that uses bpf_prog_get_type() based on a bpf_fd
> > > > > like SIOCKCMATTACH in net/kcm/kcmsock.c.
> > > >
> > > > I considered per-ctx prog before, one drawback is the prog can't be shared
> > > > among io_ring_ctx, which could waste memory. In my ublk case, there can be
> > > > lots of devices sharing same bpf prog.
> > >
> > > Can't the ublk instances coordinate and use the same bpf_fd?
> > > new instances could request it via a unix socket and SCM_RIGHTS
> > > from a long running loading process. On the other hand do they
> > > really want to share?
> >
> > struct_ops is typically registered once, used everywhere, such as
> > sched_ext and socket example.
> >
> > This patch follows this usage, so every io_uring application can access it like the
> > in-kernel operations.
> >
> > I can understand the requirement for per-io-ring-ctx struct_ops, which
> > won't cause conflict among different applications.
> >
> > For example, ublk/raid5, there are 100 such devices, each device is created in dedicated
> > process and uses its own io-uring, so 100 same struct_ops prog are registered in memory.
> > Given struct_ops prog is registered as per-io-ring-ctx, it may not be shared by `bpf_fd`, IMO.
> 
> I agree with Stefan that a global IORING_OP_BPF op to BPF program
> mapping will be difficult to coordinate between processes. For
> example, consider two different ublk server programs that each want to
> use a different BPF program. Ideally, each should be an independent
> program and not need to know the op ids used by the other.

Each processes can query free slots by checking `bpftool struc_ops`.

> On the other hand, a multithreaded process may have multiple
> io_ring_ctxs and want to use the same IORING_OP_BPF ops with all of
> them. So a process-level mapping seems to make the most sense. And
> that's exactly the mapping level that we would get from using the BPF
> program file descriptor to specify the IORING_OP_BPF op. Additionally,
> as Stefan points out, the IORING_OP_BPF program could be shared with
> another process by sending the file descriptor using SCM_RIGHTS. And

io_uring FD doesn't support SCM_RIGHTS.

If one privileged process sends bpf prog FD via SCM_RIGHTS, that means
this privileged process may be allowed to register any IORING_OP_BPF program,
sounds like `CONFIG_BPF_UNPRIV_DEFAULT_OFF == n`. Probably it is fine
if we just expose 'struct uring_bpf_data' and not expose `struct io_kiocb`
to bpf prog.

Another ways is to register global struct_ops prog in the following way:

- the 1st 256 progs are stored in plain array, which can be for really
  global/generic progs

- the others(256 ~ 65535) progs are stored in xarray, processes can lookup
  free slots and use them in dynamic allocation way.

I'd suggest to start with global register, which is easy to use, and extend
to per-uring-ctx struct_ops in future.


Thanks,
Ming


