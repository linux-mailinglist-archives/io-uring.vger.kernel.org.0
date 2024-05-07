Return-Path: <io-uring+bounces-1798-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABFCB8BE018
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 12:49:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 638CC28D831
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 10:49:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EA72150997;
	Tue,  7 May 2024 10:44:58 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E49C14F9EA;
	Tue,  7 May 2024 10:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715078698; cv=none; b=dcPdcoKLHkT6c5+6w9BqQv/L9yJz1I35H/pUhgF/nflZg29Q/wcve17GgE7Bt8xmCZwTV6yvDPHbw9VnHAZmrJR1KKzvWBBEUVfq3xXzf4tGW0ygMkzVVi7XgQUS0uYfS9EzYrnu1sRzG7fhI4cLTyB9NAPEAxSMMilw3GP5SLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715078698; c=relaxed/simple;
	bh=zN9YI3Ms1m+wOhz90UWcvVrsHIm3ci6x0/cMI4eFQzw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NV2V6fLgCggE89WKelU9Fp4zG0x5fcJuiV+sQi/kNXtqWKx5AIRvSAkI2jQbq9Fd/rpEExY45J+FPpXPH4L3bfvOvBb7lpKufkzQbLl7SzBPzE4Ht1qTjcR5tqLzURSwS5KZSfQmQvmACJ5Dno9KAKEqYGZj1t0931nPE0QdWp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a59a9d66a51so658494466b.2;
        Tue, 07 May 2024 03:44:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715078695; x=1715683495;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uFLVyObYwZS1gZ7qbdqFPVtvRdltbw/jeqQRl9Dx2qY=;
        b=OWsSGy6xdvvvgpjeOp7beUCDq5+bywTWFvtH6Bj2/nE2FV7Xz7MEU2dzYpAyorT4j8
         /21Tt4TuSHQq3ydQ9KgUA3SA3GqG96F4sGygCI2UVnSfromgnUJw0kRjgWmLwFtMqH1e
         l5jlcnAU7PNZFIgbOdBdedWmqQc2hroJfzPab7QhcAnMgDyEI2NLWPtv+fB8HNj8gjr/
         7b6ViyEo4FWAvgN6Iutmv4+YMdbCbA8OU+Urvdv+x04yrDs/E1xOYuy4wmN3jZub0Xgr
         QpssbfnGtaFW27tkKVUQVvzm7GsH6N3xgPJmvLl5wSYrlqN2dWZRBVt/oyfSbYO1zhc7
         xJaA==
X-Forwarded-Encrypted: i=1; AJvYcCV/SF85fwVCHmTlPwgoxyFnjHHknZ6dZUOS7rjGIli4wPzTeJzNb83PmviOmzylsTJLwHrbAnrwxYvl4/rJM+JvtzQR2eb6g8RNFwRV/gDW6HqHIvN9ZhHSMmTvZzNRNvBjYp9+pI4=
X-Gm-Message-State: AOJu0YzDRXkWXE9tLh1UcjovtHflKsEna/Vq7G5Hdyl7gnNIT09RhmcL
	/k5A2PSNBWfTcDj2KffIGE4Sqw/BYRLFXlfyHSS9ftRVxOqDB6k0
X-Google-Smtp-Source: AGHT+IEgOlItaygfRGKmFqtrO1k0j+VPxNvNH039tMrrtzq2Q7B6PNbgov4CV5STMXV1l6ARN6uh/A==
X-Received: by 2002:a17:906:81d8:b0:a59:cd46:fe89 with SMTP id e24-20020a17090681d800b00a59cd46fe89mr3517514ejx.59.1715078694526;
        Tue, 07 May 2024 03:44:54 -0700 (PDT)
Received: from gmail.com (fwdproxy-lla-116.fbsv.net. [2a03:2880:30ff:74::face:b00c])
        by smtp.gmail.com with ESMTPSA id p14-20020a170906604e00b00a58a3238522sm6249014ejj.207.2024.05.07.03.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 May 2024 03:44:54 -0700 (PDT)
Date: Tue, 7 May 2024 03:44:52 -0700
From: Breno Leitao <leitao@debian.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, leit@meta.com,
	"open list:IO_URING" <io-uring@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] io_uring/io-wq: Use set_bit() and test_bit() at
 worker->flags
Message-ID: <ZjoGJH1CEk+f+U7n@gmail.com>
References: <20240503173711.2211911-1-leitao@debian.org>
 <d05aa530-f0f5-4ec2-91ae-b193ae644395@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d05aa530-f0f5-4ec2-91ae-b193ae644395@kernel.dk>

On Fri, May 03, 2024 at 12:32:38PM -0600, Jens Axboe wrote:
> On 5/3/24 11:37 AM, Breno Leitao wrote:
> > Utilize set_bit() and test_bit() on worker->flags within io_uring/io-wq
> > to address potential data races.
> > 
> > The structure io_worker->flags may be accessed through parallel data
> > paths, leading to concurrency issues. When KCSAN is enabled, it reveals
> > data races occurring in io_worker_handle_work and
> > io_wq_activate_free_worker functions.
> > 
> > 	 BUG: KCSAN: data-race in io_worker_handle_work / io_wq_activate_free_worker
> > 	 write to 0xffff8885c4246404 of 4 bytes by task 49071 on cpu 28:
> > 	 io_worker_handle_work (io_uring/io-wq.c:434 io_uring/io-wq.c:569)
> > 	 io_wq_worker (io_uring/io-wq.c:?)
> > <snip>
> > 
> > 	 read to 0xffff8885c4246404 of 4 bytes by task 49024 on cpu 5:
> > 	 io_wq_activate_free_worker (io_uring/io-wq.c:? io_uring/io-wq.c:285)
> > 	 io_wq_enqueue (io_uring/io-wq.c:947)
> > 	 io_queue_iowq (io_uring/io_uring.c:524)
> > 	 io_req_task_submit (io_uring/io_uring.c:1511)
> > 	 io_handle_tw_list (io_uring/io_uring.c:1198)
> > 
> > Line numbers against commit 18daea77cca6 ("Merge tag 'for-linus' of
> > git://git.kernel.org/pub/scm/virt/kvm/kvm").
> > 
> > These races involve writes and reads to the same memory location by
> > different tasks running on different CPUs. To mitigate this, refactor
> > the code to use atomic operations such as set_bit(), test_bit(), and
> > clear_bit() instead of basic "and" and "or" operations. This ensures
> > thread-safe manipulation of worker flags.
> 
> Looks good, a few comments for v2:
> 
> > diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
> > index 522196dfb0ff..6712d70d1f18 100644
> > --- a/io_uring/io-wq.c
> > +++ b/io_uring/io-wq.c
> > @@ -44,7 +44,7 @@ enum {
> >   */
> >  struct io_worker {
> >  	refcount_t ref;
> > -	unsigned flags;
> > +	unsigned long flags;
> >  	struct hlist_nulls_node nulls_node;
> >  	struct list_head all_list;
> >  	struct task_struct *task;
> 
> This now creates a hole in the struct, maybe move 'lock' up after ref so
> that it gets filled and the current hole after 'lock' gets removed as
> well?

I am not sure I can see it. From my tests, we got the same hole, and the
struct size is the same. This is what I got with the change:


	struct io_worker {
		refcount_t                 ref;                  /*     0     4 */

		/* XXX 4 bytes hole, try to pack */

		raw_spinlock_t             lock;                 /*     8    64 */
		/* --- cacheline 1 boundary (64 bytes) was 8 bytes ago --- */
<snip>

		/* size: 336, cachelines: 6, members: 14 */
		/* sum members: 328, holes: 2, sum holes: 8 */
		/* forced alignments: 2, forced holes: 1, sum forced holes: 4 */
		/* last cacheline: 16 bytes */
	} __attribute__((__aligned__(8)));


This is what this current patch returns:

	struct io_worker {
		refcount_t                 ref;                  /*     0     4 */

		/* XXX 4 bytes hole, try to pack */

		long unsigned int          flags;                /*     8     8 */
	<snip>

		/* size: 336, cachelines: 6, members: 14 */
		/* sum members: 328, holes: 2, sum holes: 8 */
		/* forced alignments: 2, forced holes: 1, sum forced holes: 4 */
		/* last cacheline: 16 bytes */
	} __attribute__((__aligned__(8)));



A possible suggestion is to move `create_index` after `ref. Then we can
get a more packed structure:

	struct io_worker {
		refcount_t                 ref;                  /*     0     4 */
		int                        create_index;         /*     4     4 */
		long unsigned int          flags;                /*     8     8 */
		struct hlist_nulls_node    nulls_node;           /*    16    16 */
		struct list_head           all_list;             /*    32    16 */
		struct task_struct *       task;                 /*    48     8 */
		struct io_wq *             wq;                   /*    56     8 */
		/* --- cacheline 1 boundary (64 bytes) --- */
		struct io_wq_work *        cur_work;             /*    64     8 */
		struct io_wq_work *        next_work;            /*    72     8 */
		raw_spinlock_t             lock;                 /*    80    64 */
		/* --- cacheline 2 boundary (128 bytes) was 16 bytes ago --- */
		struct completion          ref_done;             /*   144    88 */
		/* --- cacheline 3 boundary (192 bytes) was 40 bytes ago --- */
		long unsigned int          create_state;         /*   232     8 */
		struct callback_head       create_work __attribute__((__aligned__(8))); /*   240    16 */
		/* --- cacheline 4 boundary (256 bytes) --- */
		union {
			struct callback_head rcu __attribute__((__aligned__(8))); /*   256    16 */
			struct work_struct work;                 /*   256    72 */
		} __attribute__((__aligned__(8)));               /*   256    72 */

		/* size: 328, cachelines: 6, members: 14 */
		/* forced alignments: 2 */
		/* last cacheline: 8 bytes */
	} __attribute__((__aligned__(8)));

How does it sound?

> And then I'd renumber the flags, they take bit offsets, not
> masks/values. Otherwise it's a bit confusing for someone reading the
> code, using masks with test/set bit functions.

Good point. What about something like?

	enum {
		IO_WORKER_F_UP          = 0,    /* up and active */
		IO_WORKER_F_RUNNING     = 1,    /* account as running */
		IO_WORKER_F_FREE        = 2,    /* worker on free list */
		IO_WORKER_F_BOUND       = 3,    /* is doing bounded work */
	};


Since we are now using WRITE_ONCE() in io_wq_worker, I am wondering if
this is what we want to do?

	WRITE_ONCE(worker->flags, (IO_WORKER_F_UP| IO_WORKER_F_RUNNING) << 1);

Thanks

