Return-Path: <io-uring+bounces-7632-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 042A9A9734F
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 19:05:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C15003A8481
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 17:04:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE512293B55;
	Tue, 22 Apr 2025 17:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aAGYx/Ji"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2015D13C3F6;
	Tue, 22 Apr 2025 17:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745341508; cv=none; b=XRZkCVL5zC2TKhHmNTT8Y1TwULzX1rRF3BTAnY3o/swFTJPWPtG0i/NlgBaatt3c35uH8YHKEAghwh3CQJs8MvGcb5rSYqpocJOabr1AiOAspE5wYcYkFfxfTwRBMpjHRBEwlcJd9mevN+lZyYDSjw3fFY0GzQTPzyLzz+osY8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745341508; c=relaxed/simple;
	bh=3Q3d/Gv9jBswfdFw6M3g5pwF+WmxcoXuJH6NkkgYcwU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MhiyotNZYKV6a9JpIZiopNQp48b7u3WjHCkZK8ErpLVNExm2Y9ZaM2/MZT4vz8yfAPk9HAJ7ZAYWM54JgXIyyl0y72Wg82g5uVX3DsK1sltWrhiUjpZGEGQsgOWdWVUSuTu/Ax093FTRxktIAl1bnlFJkY+1txFeOUK+S7wUKdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aAGYx/Ji; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-3feaedb4085so2894001b6e.0;
        Tue, 22 Apr 2025 10:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745341506; x=1745946306; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+7WrLg4e9cY2VHcHtoBcoTJy6lszZ4yXJERHqcp7ExI=;
        b=aAGYx/JiQrAZ7di6UuFC8CYSdIzXve/qW1yDr7pwIVhMOFL8EN/Cv5Q+J0gSIhqtsp
         3fltBFAkflggywbhFcqmSX86ZJST514Dq/kX0Heb+oRKkJROEhabQfKUlo25kRlBKp+O
         bG/1JQ6bumbJHca1PkA2IGORKPJT/9oc4g8jgyGBg2kxgpwJoQzhJDjfNeqdm1m6ey1x
         3jbw1iCYmx8GGJD240h6bkd6zt+3lFZCclYqXjw5Tt+gUb8BrL4R9UYp7E5DD1jOuBCo
         cJwhJQiQIGCUrqPXb9KnBOfBolv3BUfk/NiMizYJgeEv/T1f/9iVfDzWWOBsoqD4E6i9
         0BjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745341506; x=1745946306;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+7WrLg4e9cY2VHcHtoBcoTJy6lszZ4yXJERHqcp7ExI=;
        b=BeZHDAYCiwiC2Cr9PBrbW894aFQsQ8AItuLijiVHSayZg/4uEACd0qRHn8g+4nNzH2
         X8cYpZqabmlrdDAzFQRO2S/O9kyIOs7WHyCGw/Ob+4P5Mi+lBShkpgIqvQBKXdqpM0K5
         XiOV5GHcfp+ad8yxUlUnFEx0/BgDX2N85JYdjorCT54BBGmgM0qojIv3sFyERRJSTuX3
         GMsYbbfW2aRphqAFlGr1j+nKJ5z9heBUTfLoZIV1sh1h+EYSt0u9AjiO9X/O7TB5Iv4q
         jJi1q4M4L5QvPFdN3q2WozumTpMyA3gNZYAM+AQjFIylghhZVi/Ah4I5+LbcgJKVIrTz
         itXg==
X-Forwarded-Encrypted: i=1; AJvYcCWlw4kK3/ScZI4CflnoPJtq1ujyNs3t/nKLN4NoVvu9zmAv6fWbJmdZCPMGzD+FxqPNRxAlwulMhA==@vger.kernel.org, AJvYcCX5cKz/lZxWQ4vjNcBvVi8Z5uYr7ae7mbOZQACed2lJ0GI8SfzqpuLH0X0i+rbtL0qZwKl9+oYooqqa2al0@vger.kernel.org, AJvYcCXkbDiATbRSJkmbBBLxUuBbivnRszuaI59TCLrwIXx9/0jHpsRDOoyCMVkt2E3ATCXfQ9UBAmUU66ari2TdoQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9MlVsfk+RzitctS9WeglHdq3HdCZiAh1Y8pMcTNW78yFegTDn
	5dzr4cLPwdi9sRfJu0n3Nnu+gHb69HMmnK2bcm6MStXPPtOBxs1QQG2PdBRYoSN6h58sfFi+uph
	ShdzvWSxDlLM7hQM31zZI43X2o+w=
X-Gm-Gg: ASbGnctyoLB03b+AICMvqpS1sNi2oiumJgWqTRjdp5jfRiI1ZMNjEFtMfj9xk3l+4U3
	Uzgn7rx5K0OCB2o/6lKBm20MWcttT9WHjTBKRYkW7wKoq9lo2B6U6q7KuFqGENf/tw1U/y9i7qc
	Sj5KTpqfRgjH/7TMWshJrKrJg=
X-Google-Smtp-Source: AGHT+IG5jwX6aVuobCSfbSvJJVwejcD1mwDTMTpKItoC292lr3eiPUL1ZrVtszaaUklSkLJkJnMb0yYQavR0xmtevIM=
X-Received: by 2002:a05:6871:bd07:b0:2d5:75eb:518f with SMTP id
 586e51a60fabf-2d575eb71e5mr4778772fac.2.1745341506113; Tue, 22 Apr 2025
 10:05:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250422162913.1242057-1-qq282012236@gmail.com>
 <20250422162913.1242057-2-qq282012236@gmail.com> <14195206-47b1-4483-996d-3315aa7c33aa@kernel.dk>
In-Reply-To: <14195206-47b1-4483-996d-3315aa7c33aa@kernel.dk>
From: =?UTF-8?B?5aec5pm65Lyf?= <qq282012236@gmail.com>
Date: Wed, 23 Apr 2025 01:04:53 +0800
X-Gm-Features: ATxdqUH2JFOvPlQAV9Hzfw7ZRpF8PKn7CsDp2ww7xDEp1szv9ceWdNCDqRVVWO4
Message-ID: <CANHzP_uW4+-M1yTg-GPdPzYWAmvqP5vh6+s1uBhrMZ3eBusLug@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] io_uring: Add new functions to handle user fault scenarios
To: Jens Axboe <axboe@kernel.dk>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, 
	akpm@linux-foundation.org, peterx@redhat.com, asml.silence@gmail.com, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 23, 2025 at 12:32=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote=
:
>
> On 4/22/25 10:29 AM, Zhiwei Jiang wrote:
> > diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
> > index d4fb2940e435..8567a9c819db 100644
> > --- a/io_uring/io-wq.h
> > +++ b/io_uring/io-wq.h
> > @@ -70,8 +70,10 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, =
work_cancel_fn *cancel,
> >                                       void *data, bool cancel_all);
> >
> >  #if defined(CONFIG_IO_WQ)
> > -extern void io_wq_worker_sleeping(struct task_struct *);
> > -extern void io_wq_worker_running(struct task_struct *);
> > +extern void io_wq_worker_sleeping(struct task_struct *tsk);
> > +extern void io_wq_worker_running(struct task_struct *tsk);
> > +extern void set_userfault_flag_for_ioworker(void);
> > +extern void clear_userfault_flag_for_ioworker(void);
> >  #else
> >  static inline void io_wq_worker_sleeping(struct task_struct *tsk)
> >  {
> > @@ -79,6 +81,12 @@ static inline void io_wq_worker_sleeping(struct task=
_struct *tsk)
> >  static inline void io_wq_worker_running(struct task_struct *tsk)
> >  {
> >  }
> > +static inline void set_userfault_flag_for_ioworker(void)
> > +{
> > +}
> > +static inline void clear_userfault_flag_for_ioworker(void)
> > +{
> > +}
> >  #endif
> >
> >  static inline bool io_wq_current_is_worker(void)
>
> This should go in include/linux/io_uring.h and then userfaultfd would
> not have to include io_uring private headers.
>
> But that's beside the point, like I said we still need to get to the
> bottom of what is going on here first, rather than try and paper around
> it. So please don't post more versions of this before we have that
> understanding.
>
> See previous emails on 6.8 and other kernel versions.
>
> --
> Jens Axboe
The issue did not involve creating new worker processes. Instead, the
existing IOU worker kernel threads (about a dozen) associated with the VM
process were fully utilizing CPU without writing data, caused by a fault
while reading user data pages in the fault_in_iov_iter_readable function
when pulling user memory into kernel space.

This issue occurs like during VM snapshot loading (which uses
userfaultfd for on-demand memory loading), while the task in the guest is
writing data to disk.

Normally, the VM first triggers a user fault to fill the page table.
So in the IOU worker thread, the page tables are already filled,
fault no chance happens when faulting in memory pages
in fault_in_iov_iter_readable.

I suspect that during snapshot loading, a memory access in the
VM triggers an async page fault handled by the kernel thread,
while the IOU worker's async kernel thread is also running.
Maybe If the IOU worker's thread is scheduled first.
I=E2=80=99m going to bed now.

