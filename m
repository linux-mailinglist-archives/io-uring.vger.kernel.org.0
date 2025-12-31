Return-Path: <io-uring+bounces-11342-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A720CEBB28
	for <lists+io-uring@lfdr.de>; Wed, 31 Dec 2025 10:34:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 545DF300D480
	for <lists+io-uring@lfdr.de>; Wed, 31 Dec 2025 09:34:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4D492D7398;
	Wed, 31 Dec 2025 09:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BOeyzyVD"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B85280035
	for <io-uring@vger.kernel.org>; Wed, 31 Dec 2025 09:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767173654; cv=none; b=dp08qUI6uquo1sMrVC4k7vpEI7CFoaHO12igRck4WmnPDDEXO9iPRqlwKYPs7f7injzrLbuXmgZO7kXc7T+3UPHRBCOr9W3JzLflPeYN1rs/Drb9wEcmttnxNITgpnwGzuHgfcxe8J7AInhLc0+8+jJr7pL7OIiyvomBicB2YJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767173654; c=relaxed/simple;
	bh=ZTBN6Ks6RPzgOIC99/3QyXeR2nHJnhN3qNTtIMkI2zc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MbUr0KORjOCjbgYXD+k8Cy5qc7QKdIHxrnjZiUHIpvVQ5xQxfCFAf2uCq0JPZe1M3HdOIsdzjEsIh16GLY0nWqa6pL8IzgIgTmiT1NeVR+V8jLwhW3SOuxi4PrBUayNMGj8FSbFpenPDw67T5+8ep4BGTWDHhtpLmaodfo6yAEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BOeyzyVD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767173648;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GiDfzP+O+GxPhahuPtJTaFsO/s4Z62NsU2nblpEpX40=;
	b=BOeyzyVD0EYYE0Nrpbyi3YF1tUnAZ9Xu4+IEaa+cSXspx4EKvrNVoHOl8CGSZY42pIgu9+
	1gnO6FPlsQ9hWXht61UtISsOBF6EFXDowpoQWNh1XbTa7u+axxexjMWrclYbRqsuJddDZt
	SF06mdBQhxdCv/9+x1O8DWlUF/uQZDg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-128-gw372KTWOrKnlXjb7XP8yw-1; Wed,
 31 Dec 2025 04:34:07 -0500
X-MC-Unique: gw372KTWOrKnlXjb7XP8yw-1
X-Mimecast-MFC-AGG-ID: gw372KTWOrKnlXjb7XP8yw_1767173646
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D8137180035A;
	Wed, 31 Dec 2025 09:34:05 +0000 (UTC)
Received: from fedora (unknown [10.72.116.125])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C77E218004D8;
	Wed, 31 Dec 2025 09:34:01 +0000 (UTC)
Date: Wed, 31 Dec 2025 17:33:56 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	Akilesh Kailash <akailash@google.com>, bpf@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH 1/5] io_uring: prepare for extending io_uring with bpf
Message-ID: <aVTuBCzsEHGtss3G@fedora>
References: <20251104162123.1086035-1-ming.lei@redhat.com>
 <20251104162123.1086035-2-ming.lei@redhat.com>
 <CADUfDZoTWvDspuyLRsHXZRa3D__dffyAptF=BpaF+h6pREbPug@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZoTWvDspuyLRsHXZRa3D__dffyAptF=BpaF+h6pREbPug@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Tue, Dec 30, 2025 at 08:13:40PM -0500, Caleb Sander Mateos wrote:
> On Tue, Nov 4, 2025 at 8:22 AM Ming Lei <ming.lei@redhat.com> wrote:
> >
> > Add one bpf operation & related framework and prepare for extending io_uring
> > with bpf.
> >
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  include/uapi/linux/io_uring.h |  1 +
> >  init/Kconfig                  |  7 +++++++
> >  io_uring/Makefile             |  1 +
> >  io_uring/bpf.c                | 26 ++++++++++++++++++++++++++
> >  io_uring/opdef.c              | 10 ++++++++++
> >  io_uring/uring_bpf.h          | 26 ++++++++++++++++++++++++++
> >  6 files changed, 71 insertions(+)
> >  create mode 100644 io_uring/bpf.c
> >  create mode 100644 io_uring/uring_bpf.h
> >
> > diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> > index 04797a9b76bc..b167c1d4ce6e 100644
> > --- a/include/uapi/linux/io_uring.h
> > +++ b/include/uapi/linux/io_uring.h
> > @@ -303,6 +303,7 @@ enum io_uring_op {
> >         IORING_OP_PIPE,
> >         IORING_OP_NOP128,
> >         IORING_OP_URING_CMD128,
> > +       IORING_OP_BPF,
> >
> >         /* this goes last, obviously */
> >         IORING_OP_LAST,
> > diff --git a/init/Kconfig b/init/Kconfig
> > index cab3ad28ca49..14d566516643 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -1843,6 +1843,13 @@ config IO_URING
> >           applications to submit and complete IO through submission and
> >           completion rings that are shared between the kernel and application.
> >
> > +config IO_URING_BPF
> > +       bool "Enable IO uring bpf extension" if EXPERT
> > +       depends on IO_URING && BPF
> > +       help
> > +         This option enables bpf extension for the io_uring interface, so
> > +         application can define its own io_uring operation by bpf program.
> > +
> >  config GCOV_PROFILE_URING
> >         bool "Enable GCOV profiling on the io_uring subsystem"
> >         depends on IO_URING && GCOV_KERNEL
> > diff --git a/io_uring/Makefile b/io_uring/Makefile
> > index bc4e4a3fa0a5..35eeeaf64489 100644
> > --- a/io_uring/Makefile
> > +++ b/io_uring/Makefile
> > @@ -22,3 +22,4 @@ obj-$(CONFIG_NET_RX_BUSY_POLL)        += napi.o
> >  obj-$(CONFIG_NET) += net.o cmd_net.o
> >  obj-$(CONFIG_PROC_FS) += fdinfo.o
> >  obj-$(CONFIG_IO_URING_MOCK_FILE) += mock_file.o
> > +obj-$(CONFIG_IO_URING_BPF)     += bpf.o
> > diff --git a/io_uring/bpf.c b/io_uring/bpf.c
> > new file mode 100644
> > index 000000000000..8c47df13c7b5
> > --- /dev/null
> > +++ b/io_uring/bpf.c
> > @@ -0,0 +1,26 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright (c) 2024 Red Hat */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/errno.h>
> > +#include <uapi/linux/io_uring.h>
> > +#include "io_uring.h"
> > +#include "uring_bpf.h"
> > +
> > +int io_uring_bpf_issue(struct io_kiocb *req, unsigned int issue_flags)
> > +{
> > +       return -ECANCELED;
> > +}
> > +
> > +int io_uring_bpf_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> > +{
> > +       return -EOPNOTSUPP;
> > +}
> > +
> > +void io_uring_bpf_fail(struct io_kiocb *req)
> > +{
> > +}
> > +
> > +void io_uring_bpf_cleanup(struct io_kiocb *req)
> > +{
> > +}
> > diff --git a/io_uring/opdef.c b/io_uring/opdef.c
> > index df52d760240e..d93ee3d577d4 100644
> > --- a/io_uring/opdef.c
> > +++ b/io_uring/opdef.c
> > @@ -38,6 +38,7 @@
> >  #include "futex.h"
> >  #include "truncate.h"
> >  #include "zcrx.h"
> > +#include "uring_bpf.h"
> >
> >  static int io_no_issue(struct io_kiocb *req, unsigned int issue_flags)
> >  {
> > @@ -593,6 +594,10 @@ const struct io_issue_def io_issue_defs[] = {
> >                 .prep                   = io_uring_cmd_prep,
> >                 .issue                  = io_uring_cmd,
> >         },
> > +       [IORING_OP_BPF] = {
> > +               .prep                   = io_uring_bpf_prep,
> > +               .issue                  = io_uring_bpf_issue,
> 
> Should this set .prep = io_eopnotsupp_prep for !CONFIG_IO_URING_BPF
> and remove the stub implementations? That would be more consistent
> with the other opcodes when they are configured out, and ensure
> io_uring_op_supported(IORING_OP_BPF) returns false for
> !CONFIG_IO_URING_BPF.

Yeah, good point!


Thanks,
Ming


