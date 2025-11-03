Return-Path: <io-uring+bounces-10342-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 3767EC2E0F8
	for <lists+io-uring@lfdr.de>; Mon, 03 Nov 2025 21:48:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 503144E13A0
	for <lists+io-uring@lfdr.de>; Mon,  3 Nov 2025 20:47:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE3D5218AB9;
	Mon,  3 Nov 2025 20:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="frnItTGW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C9E23ABB0
	for <io-uring@vger.kernel.org>; Mon,  3 Nov 2025 20:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762202872; cv=none; b=gXwY6M+cD3cZjL0KVWTPRbMxCBqY7kHoQF13LiScMwWbfs5IyqJmo8jzTVyd3xfrfwyLkUtjTq4dQpNqgZSYXctFPBLkKIU2sHUYdeW2usMNY5DBTY8Jm1Uuva1GKr+YWf1XbeiBj+UzXuPoKUYRza9cD7mKfwtiGdhiJdowTys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762202872; c=relaxed/simple;
	bh=a+vN09clVIm5tcOtX8Gar8O7sWSsGJBH8NFznjlbuLw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EoVffGbTcGwIKugWdXZ0Zqh41xFchpA06SxKrzvk+7uKoFuXTD7SjqTaSRf8r9sX9rguaGBfYU1DQfXd6zzMzg3KpjLCg3dDMx4dfwq0q8gw8L29lCMLObsib6RCRAeNULL9RCLEOekg8AD7nwpY4Wc0EoYnUifJNIos9K7hi8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=frnItTGW; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-340bb45e37cso699653a91.3
        for <io-uring@vger.kernel.org>; Mon, 03 Nov 2025 12:47:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1762202870; x=1762807670; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z+i+icE8IiyClGUVbQkBzxyTYknJ8/f/9xuIDF0CulI=;
        b=frnItTGWBoCkkJM13i5I2O93bpMuEk2yfFL/hhn2wgUCDdit3uF+Ya+mwLvf1cptKA
         NdLfPXPxU7+xOyQfNOHNBRO2O88vnkM8wg0D+bEOWObAietBKXQ/YpWgS6PRj9XakEXF
         0uU5t9fktMIuIvPfoDfJ8tvHAr7MtqipnpmghWD5LSoyiPn3tjoOSmkBvUS7uxQF6j+p
         MtwETHdsG2SGDS+uHqej3Yp1O6hYpJSj+Q/Itfx3mpXcbQ0M+WRNzAXmuf16fzVX1VeR
         v3DApY9vOAfqcebzpmOKls2k+T2OD2YONoO55vMBU096S3BF04Fx3W79qiRC/kUTl06V
         fQiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762202870; x=1762807670;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z+i+icE8IiyClGUVbQkBzxyTYknJ8/f/9xuIDF0CulI=;
        b=q9KOYEak4C5mr5Y+ZU9vV2HeE3C8t+XLYqxcRFAr/pWt+MmBcIv/TfuIYFVIhkKXyd
         331SJV+aBQYm9/8CM4b0pDP8n3xAA91JmkIJdhHIoyLslrJBofbgcsjINmwCdq2cKgGc
         XwPWRWK6qtuKik4ZVHnxfn/YqXRuFDB2pB26iENjivGm9RkwMazussgNT4U7x55eGe2Y
         Jmuv5ApiQCWg05VTO0Tsjf1AYYH1WYctePiGxlR6G8YeU4AYJluLJr46d960UctXUDAz
         tNj/sjo3ZunM0L6jAexlVn0JAohFntJFyYLWSpRw9j1ZV4YF+XW84N9VBMlY9R3BUNLG
         bOiA==
X-Forwarded-Encrypted: i=1; AJvYcCUyZqUZZkBxVvA2Icvh51HsULB+5VSTRFV0atBxRU8ejXnKrDDkn2OkUUMH8Vl8B5IX53a/jBH3OA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwVs/F0dvLiaaRbikHxdCoWIWV3xdvhlFnQuXmvh7hfBIL3k1N/
	bL5ACaji13Tg6ZyNDItjEJDLqGgy2DgzBMYmDxetH3zOy6TeUAkF8tIwpxhp73GmFIfL/A53TmZ
	+vJXnmt72UBVofQBsqn3gdd9E4RZzLCDWPcxBl2TcSQ==
X-Gm-Gg: ASbGnctdG4dRdvy7Ndznnz0hazxw9FsLBdJhs3IGaFX1JWnJluuaxLkMUKEBbIN1mR7
	4QidPGD1Dl/n3t9QjnrGZ3LEJpU2HxuZe1seJsDytUZj00hDzilojlAqUEpoFq9vzG3MF8lK7Hd
	YDTGqSE0FZsL01ysDvSqmgABClPzb0FMwKify1BEX/3Q/FvHbRdZkLW99CZEuzA8yqDq3JfzyRj
	uclcEiZ+NWcs4nDuMTGk2drVPWgKjPfNDuTpIClx0a9MEA7pKdSas7kmMglBs7UYy3oF5sHXgPg
	xLoAl+QU/5zFzqm0EPPFrDlFUYA2
X-Google-Smtp-Source: AGHT+IH9W5Yz0Du9VH7KHBKlBV6mxFdT8/2W8B6DMI8gR86YbjrXYjVZeItEyfgxJbcb8qFJyg3Aepo7OAlVmh7HvH8=
X-Received: by 2002:a17:902:f684:b0:294:ec58:1d23 with SMTP id
 d9443c01a7336-2951a3a3eecmr89081495ad.3.1762202870213; Mon, 03 Nov 2025
 12:47:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250904170902.2624135-1-csander@purestorage.com>
 <175742490970.76494.10067269818248850302.b4-ty@kernel.dk> <fe312d71-c546-4250-a730-79c23a92e028@gmail.com>
 <5d41be18-d8a4-4060-aa04-8b9d03731586@kernel.dk>
In-Reply-To: <5d41be18-d8a4-4060-aa04-8b9d03731586@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 3 Nov 2025 12:47:38 -0800
X-Gm-Features: AWmQ_bmchfvPvbc6j7bPb8NZmMiCt-7TsMmgFjMHSv2mTVxvDRP5RDGTV2htgSY
Message-ID: <CADUfDZqHbfAQXG8j2W_GZrxFbYSQQeo9sYdzMEYLQTsuCR+4=A@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2025 at 8:36=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 9/10/25 5:57 AM, Pavel Begunkov wrote:
> > On 9/9/25 14:35, Jens Axboe wrote:
> >>
> >> On Thu, 04 Sep 2025 11:08:57 -0600, Caleb Sander Mateos wrote:
> >>> As far as I can tell, setting IORING_SETUP_SINGLE_ISSUER when creatin=
g
> >>> an io_uring doesn't actually enable any additional optimizations (asi=
de
> >>> from being a requirement for IORING_SETUP_DEFER_TASKRUN). This series
> >>> leverages IORING_SETUP_SINGLE_ISSUER's guarantee that only one task
> >>> submits SQEs to skip taking the uring_lock mutex in the submission an=
d
> >>> task work paths.
> >>>
> >>> [...]
> >>
> >> Applied, thanks!
> >>
> >> [1/5] io_uring: don't include filetable.h in io_uring.h
> >>        commit: 5d4c52bfa8cdc1dc1ff701246e662be3f43a3fe1
> >> [2/5] io_uring/rsrc: respect submitter_task in io_register_clone_buffe=
rs()
> >>        commit: 2f076a453f75de691a081c89bce31b530153d53b
> >> [3/5] io_uring: clear IORING_SETUP_SINGLE_ISSUER for IORING_SETUP_SQPO=
LL
> >>        commit: 6f5a203998fcf43df1d43f60657d264d1918cdcd
> >> [4/5] io_uring: factor out uring_lock helpers
> >>        commit: 7940a4f3394a6af801af3f2bcd1d491a71a7631d
> >> [5/5] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
> >>        commit: 4cc292a0faf1f0755935aebc9b288ce578d0ced2
> >
> > FWIW, from a glance that should be quite broken, there is a bunch of
> > bits protected from parallel use by the lock. I described this
> > optimisation few years back around when first introduced SINGLE_ISSUER
> > and the DEFER_TASKRUN locking model, but to this day think it's not
> > worth it as it'll be a major pain for any future changes. It would've
> > been more feasible if links wasn't a thing. Though, none of it is
> > my problem anymore, and I'm not insisting.
>
> Hmm yes, was actually pondering this last night as well and was going
> to take a closer look today as I have a flight coming up. I'll leave
> them in there for now just to see if syzbot finds anything, and take
> that closer look and see if it's salvageable for now or if we just need
> a new revised take on this.

Is the concern the various IO_URING_F_UNLOCKED contexts (e.g. io_uring
worker threads) relying on uring_lock to synchronize access to the
io_ring_ctx with submitter_task? I think it would be possible to
provide mutual exclusion in those contexts using a task work item to
suspend submitter_task. When submitter_task picks up the task work, it
can unblock the thread running in IO_URING_F_UNLOCKED context, which
can then take the uring_lock as usual. Once it releases the
uring_lock, it can unblock submitter_task.
This approach could certainly add latency to taking uring_lock in
IO_URING_F_UNLOCKED contexts, though I don't expect that is very
common in applications using io_uring. We could certainly add a new
setup flag to avoid changing the behavior for existing
IORING_SETUP_SINGLE_ISSUER users. What are your thoughts on this
approach?

Thanks,
Caleb

