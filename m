Return-Path: <io-uring+bounces-2813-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D97C7955490
	for <lists+io-uring@lfdr.de>; Sat, 17 Aug 2024 03:23:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91B172843A4
	for <lists+io-uring@lfdr.de>; Sat, 17 Aug 2024 01:23:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE60A2F44;
	Sat, 17 Aug 2024 01:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WAJdbsC4"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6A8256E
	for <io-uring@vger.kernel.org>; Sat, 17 Aug 2024 01:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723857816; cv=none; b=VmHJvlfUwNLJcQ4hZ3iZRhkT9+4w1bf6LNY5z5ALniSfbWl1VjszOuEK35ztimUvIvILo5WtfT2nP8xX42lcnYgFP6ScHOzTbuSWImvdlg7atrp8JtQijF0IS66HW92jh4IbsKZtyUrqDg7diL45570H54qfAa5j5Dz5PdnMeFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723857816; c=relaxed/simple;
	bh=+fWrwTyU+2noiMiALL8eIt4N3fnxWGUI54RtnNGlYlg=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:
	 MIME-Version:Content-Type; b=oYMQVF1uqeVcVY2pXUqQ4ONVpJd+TQUt4vnHRk9Aqt6SiTapfgg9xP6L879LLbCn6ITNzMbmGQczMDVIlaV5Fd7xom/y2SnP+PIrf3IcKUkNstu05QbK7d4yzjAohb5uVTrE7JbnMxp1FloQAtBRhfsOKDtWSVFl+TdK/0UHebI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WAJdbsC4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723857813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/2Wo5CGFHJ/czyPasK2o9nLOY/ZELRXYGTodo3tB/z4=;
	b=WAJdbsC4erh3nV9MPd4Cx51+jwd/IxSX2kg3uZRPuF+t+6Jtajh1y9FQpUsj6+/dXsUdkX
	eoxKqtR9ivZXvaHS0US2O0Mo9xbVRQ1upIHC2rfeF1U+bW2SqopGv4ie4bpLzEeTcxhsr2
	dAURX2CTlmBogukL+uITR4ewm1hhG7Q=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-627-RzbXjjYQPrCTWE2Mt_Rs8A-1; Fri,
 16 Aug 2024 21:23:31 -0400
X-MC-Unique: RzbXjjYQPrCTWE2Mt_Rs8A-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 983E51955BF9;
	Sat, 17 Aug 2024 01:23:30 +0000 (UTC)
Received: from segfault.usersys.redhat.com (unknown [10.22.8.235])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C493D3001FD6;
	Sat, 17 Aug 2024 01:23:28 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org,  Jens Axboe <axboe@kernel.dk>,  Pavel Begunkov
 <asml.silence@gmail.com>
Subject: Re: [PATCH v2] io_uring: add IORING_ENTER_NO_IOWAIT to not set
 in_iowait
References: <20240816223640.1140763-1-dw@davidwei.uk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Fri, 16 Aug 2024 21:23:26 -0400
In-Reply-To: <20240816223640.1140763-1-dw@davidwei.uk> (David Wei's message of
	"Fri, 16 Aug 2024 15:36:40 -0700")
Message-ID: <x49bk1s9c35.fsf@segfault.usersys.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Hi, David,

David Wei <dw@davidwei.uk> writes:

> io_uring sets current->in_iowait when waiting for completions, which
> achieves two things:
>
> 1. Proper accounting of the time as iowait time
> 2. Enable cpufreq optimisations, setting SCHED_CPUFREQ_IOWAIT on the rq
>
> For block IO this makes sense as high iowait can be indicative of
> issues.

It also let's you know that the system isn't truly idle.  IOW, it would
be doing some work if it didn't have to wait for I/O.  This was the
reason the metric was added (admins being confused about why their
system was showing up idle).

> But for network IO especially recv, the recv side does not control
> when the completions happen.
>
> Some user tooling attributes iowait time as CPU utilisation i.e. not

What user tooling are you talking about?  If it shows iowait as busy
time, the tooling is broken.  Please see my last mail on the subject:
  https://lore.kernel.org/io-uring/x49cz0hxdfa.fsf@segfault.boston.devel.redhat.com/

> idle, so high iowait time looks like high CPU util even though the task
> is not scheduled and the CPU is free to run other tasks. When doing
> network IO with e.g. the batch completion feature, the CPU may appear to
> have high utilisation.

Again, iowait is idle time.

> This patchset adds a IOURING_ENTER_NO_IOWAIT flag that can be set on
> enter. If set, then current->in_iowait is not set. By default this flag
> is not set to maintain existing behaviour i.e. in_iowait is always set.
> This is to prevent waiting for completions being accounted as CPU
> utilisation.
>
> Not setting in_iowait does mean that we also lose cpufreq optimisations
> above because in_iowait semantics couples 1 and 2 together. Eventually
> we will untangle the two so the optimisations can be enabled
> independently of the accounting.
>
> IORING_FEAT_IOWAIT_TOGGLE is returned in io_uring_create() to indicate
> support. This will be used by liburing to check for this feature.

If I receive a problem report where iowait time isn't accurate, I now
have to somehow figure out if an application is setting this flag.  This
sounds like a support headache, and I do wonder what the benefit is.
From what you've written, the justification for the patch is that some
userspace tooling misinterprets iowait.  Shouldn't we just fix that?

It may be that certain (all?) network functions, like recv, should not
be accounted as iowait.  However, I don't think the onus should be on
applications to tell the kernel about that--the kernel should just
figure that out on its own.

Am I alone in these opinions?

Cheers,
Jeff


>
> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
> v2:
>  - squash patches into one
>  - move no_iowait in struct io_wait_queue to the end
>  - always set iowq.no_iowait
>
> ---
>  include/uapi/linux/io_uring.h | 2 ++
>  io_uring/io_uring.c           | 7 ++++---
>  io_uring/io_uring.h           | 1 +
>  3 files changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 48c440edf674..3a94afa8665e 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -508,6 +508,7 @@ struct io_cqring_offsets {
>  #define IORING_ENTER_EXT_ARG		(1U << 3)
>  #define IORING_ENTER_REGISTERED_RING	(1U << 4)
>  #define IORING_ENTER_ABS_TIMER		(1U << 5)
> +#define IORING_ENTER_NO_IOWAIT		(1U << 6)
>  
>  /*
>   * Passed in for io_uring_setup(2). Copied back with updated info on success
> @@ -543,6 +544,7 @@ struct io_uring_params {
>  #define IORING_FEAT_LINKED_FILE		(1U << 12)
>  #define IORING_FEAT_REG_REG_RING	(1U << 13)
>  #define IORING_FEAT_RECVSEND_BUNDLE	(1U << 14)
> +#define IORING_FEAT_IOWAIT_TOGGLE	(1U << 15)
>  
>  /*
>   * io_uring_register(2) opcodes and arguments
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 20229e72b65c..5e75672525df 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -2372,7 +2372,7 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>  	 * can take into account that the task is waiting for IO - turns out
>  	 * to be important for low QD IO.
>  	 */
> -	if (current_pending_io())
> +	if (!iowq->no_iowait && current_pending_io())
>  		current->in_iowait = 1;
>  	ret = 0;
>  	if (iowq->timeout == KTIME_MAX)
> @@ -2414,6 +2414,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
>  	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
>  	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
>  	iowq.timeout = KTIME_MAX;
> +	iowq.no_iowait = flags & IORING_ENTER_NO_IOWAIT;
>  
>  	if (uts) {
>  		struct timespec64 ts;
> @@ -3155,7 +3156,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>  	if (unlikely(flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP |
>  			       IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG |
>  			       IORING_ENTER_REGISTERED_RING |
> -			       IORING_ENTER_ABS_TIMER)))
> +			       IORING_ENTER_ABS_TIMER | IORING_ENTER_NO_IOWAIT)))
>  		return -EINVAL;
>  
>  	/*
> @@ -3539,7 +3540,7 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
>  			IORING_FEAT_EXT_ARG | IORING_FEAT_NATIVE_WORKERS |
>  			IORING_FEAT_RSRC_TAGS | IORING_FEAT_CQE_SKIP |
>  			IORING_FEAT_LINKED_FILE | IORING_FEAT_REG_REG_RING |
> -			IORING_FEAT_RECVSEND_BUNDLE;
> +			IORING_FEAT_RECVSEND_BUNDLE | IORING_FEAT_IOWAIT_TOGGLE;
>  
>  	if (copy_to_user(params, p, sizeof(*p))) {
>  		ret = -EFAULT;
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index 9935819f12b7..426079a966ac 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -46,6 +46,7 @@ struct io_wait_queue {
>  	ktime_t napi_busy_poll_dt;
>  	bool napi_prefer_busy_poll;
>  #endif
> +	bool no_iowait;
>  };
>  
>  static inline bool io_should_wake(struct io_wait_queue *iowq)


