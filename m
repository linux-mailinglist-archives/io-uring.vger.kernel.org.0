Return-Path: <io-uring+bounces-11120-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ABB18CC0EF5
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 05:46:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6CCA6303D68C
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:46:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A84A31329B;
	Tue, 16 Dec 2025 04:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VE0gbWz1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED0F3164D8
	for <io-uring@vger.kernel.org>; Tue, 16 Dec 2025 04:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765860386; cv=none; b=lTfkGLAUUdrELaCJfLcicjU0tivjHy0qhMVL1aqAl+2BbqqPVvzhXYQOuR/nYWGdwfWZHrUHrraM9k8jqbEtIDzT7yYpYiyvQadJDpefRVrLpOBSbjdZUaikhE3STa/jKbFkNQb8oXyLeOTa3+3y84uxoPnAeUGu/kPij8pDmbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765860386; c=relaxed/simple;
	bh=sW4Nr6FkfIfEVPEqiOiJTrrKVkxsrZdnD59BJqNQAxg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j1NSATRO0Bj1J2Ie3qN1BKT2JBixgxcWtlK94XNhebVfHphlhhlv1jnAcI1JbQgMh/lGFfrBwlkGW/lxco99hndJiVWcUS+RdKsq4ln8DS7rhKnhZDds8DmVavbjtXf9+NBbXOVcWIy7HIB+Iq3XGYDpnO307PlIiFqYd57uM4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VE0gbWz1; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4ee4c64190cso33317931cf.0
        for <io-uring@vger.kernel.org>; Mon, 15 Dec 2025 20:46:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765860378; x=1766465178; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tukzLV05cYlhxGySrI88ow1d/Bvba6twU6/779O+g7s=;
        b=VE0gbWz1a5jXvVVq0EoUuy1JIUnyIHQEHMEq6ht6g+AWYz5xWRcqyJsZ9zX55JtF3n
         ahAJmTEf4qqLfrQ57+Uebp/goUDFuB0mnY1lAE6stQKbutXMYoB32ksy0X/v8q1QB/F+
         BzIiqB4c8S3djLl/yh4nFwqGiG60DC8xdvCvkJL7Eh6yNBWoa+EMw1iuw0mwTGx3Wivx
         YGpjTwxOTJgetVPnc16z65mZaqU52zwvbYaitcN4IM9WUBKQObnc8VXiGuSPZPKy5dO8
         7bqeFzohVD1WXUo49X6ZOx26NcvFW0OlqaSXbTWskUBMYnDl6hZzf7jS1BUHU7vdcnDw
         Wz7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765860378; x=1766465178;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tukzLV05cYlhxGySrI88ow1d/Bvba6twU6/779O+g7s=;
        b=OSgYsUSosCzMjsLfU2efn/Tp+5kEYm1EiIfHwbJX1xPBzgx357esZ0LbhYQ+0JFo+G
         //Mrhpmrvv5GRy6UqZrEUzzPo1Ch5VHdssWHRmxp+OKKCS3RTfi63uyKby8u9y4BcRCS
         MQcNXdxVa04k4D0g2dE4a0Su4RamNvG83lmZyUOdHUDFGiYcrmjTL1G3/yX6Y/I+laN7
         JgwKeoym2lCMgevszzeW47D5jdDF5up3sBtbwrhAYDulBNgw/ewb0uS6O4w/nrYrV53z
         dkVKwhsB4O9LUavE06rp8aCcGpF2NLiO6Nb/P/+y6qOcMp53MjrUZMoChIbwSquXe5KQ
         Qv7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWymWeXTtPhQojnoNrFyTs35HfDtfzCYynPmQXA4/E6quYlaYAOGtTGp/jNd2LWfmYI01p6aY9+hw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+XeHBHmlCb7vziNJkpS7wvzCuLZ6jLdaY7ugHiMay8y7GMDef
	RRzEztZ2+R+epy1kiNC00kFQheEptNjDGFg60WkkQB9QEmoS4qMCirLw0hP4tGbipIzT/F6yH8b
	onAUiV1DSZDpCkSsrTchC+NVCQoBc/8Q=
X-Gm-Gg: AY/fxX67M6EB8Lr3T153+6bB2PEEs5mgz3FBwh/7/+SBtq4AcrZHegTVL/tq0xsiSJJ
	JvUlr1QMcbOSJ5r57EZUN2zki4OrRlaFLS8a12ISuF/1CM2MhHfEp/otOjW7hWxOhDHElORbkuj
	uOdjUZStNh/T230hmRUbv2glHyHF5Vww7FVT3usQHOKKO0auQ3yETDnJI0lxWwaZSgI+WUgLgVc
	5k/nrnJ4b9duhAmKh/NI9EPyWltn6XWL2NzAfsB4uvIqPXDm27HUacRGJsWLjGzYdKnnW3wHSUA
	/GUuckCxkBU=
X-Google-Smtp-Source: AGHT+IFeNJnv6wmdIIuh/u8cWvR/anhwiRBvHhn605sGqW99gsq4KME2LDZCCtIEqfK13ZD1nnZqAAOjCEeqhydq//M=
X-Received: by 2002:ac8:6a02:0:b0:4f3:4bbb:d5c9 with SMTP id
 d75a77b69052e-4f34bbbda12mr1342901cf.79.1765860378516; Mon, 15 Dec 2025
 20:46:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251215200909.3505001-1-csander@purestorage.com> <20251215200909.3505001-7-csander@purestorage.com>
In-Reply-To: <20251215200909.3505001-7-csander@purestorage.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 16 Dec 2025 12:46:07 +0800
X-Gm-Features: AQt7F2r8c2F_CKYYb-6ae0Z5HBdoS0w4qaIisrYCdji67G5qs5GHK3qdOsq6KQU
Message-ID: <CAJnrk1Zhku-_ayXqCisYOCWnDf31YDyiWWEHJeMU=BDYoQR9mA@mail.gmail.com>
Subject: Re: [PATCH v5 6/6] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 16, 2025 at 4:10=E2=80=AFAM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> io_ring_ctx's mutex uring_lock can be quite expensive in high-IOPS
> workloads. Even when only one thread pinned to a single CPU is accessing
> the io_ring_ctx, the atomic CASes required to lock and unlock the mutex
> are very hot instructions. The mutex's primary purpose is to prevent
> concurrent io_uring system calls on the same io_ring_ctx. However, there
> is already a flag IORING_SETUP_SINGLE_ISSUER that promises only one
> task will make io_uring_enter() and io_uring_register() system calls on
> the io_ring_ctx once it's enabled.
> So if the io_ring_ctx is setup with IORING_SETUP_SINGLE_ISSUER, skip the
> uring_lock mutex_lock() and mutex_unlock() on the submitter_task. On
> other tasks acquiring the ctx uring lock, use a task work item to
> suspend the submitter_task for the critical section.

Does this open the pathway to various data corruption issues since the
submitter task can be suspended while it's in the middle of executing
a section of logic that was previously protected by the mutex? With
this patch (if I'm understandng it correctly), there's now no
guarantee that the logic inside the mutexed section for
IORING_SETUP_SINGLE_ISSUER submitter tasks is "atomically bundled", so
if it gets suspended between two state changes that need to be atomic
/ bundled together, then I think the task that does the suspend would
now see corrupt state.

I did a quick grep and I think one example of this race shows up in
io_uring/rsrc.c for buffer cloning where if the src_ctx has
IORING_SETUP_SINGLE_ISSUER set and the cloning happens at the same
time the submitter task is unregistering the buffers, then this chain
of events happens:
* submitter task is executing the logic in io_sqe_buffers_unregister()
-> io_rsrc_data_free(), and frees data->nodes but data->nr is not yet
updated
* submitter task gets suspended through io_register_clone_buffers() ->
lock_two_rings() -> mutex_lock_nested(&ctx2->uring_lock, ...)
* after suspending the src ctx, -> io_clone_buffers() runs, which will
get the incorrect "nbufs =3D src_ctx->buf_table.nr;" value
* io_clone_buffers() calls io_rsrc_node_lookup() which will
dereference a NULL pointer

Thanks,
Joanne

> If the io_ring_ctx is IORING_SETUP_R_DISABLED (possible during
> io_uring_setup(), io_uring_register(), or io_uring exit), submitter_task
> may be set concurrently, so acquire the uring_lock before checking it.
> If submitter_task isn't set yet, the uring_lock suffices to provide
> mutual exclusion.
>
> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> Tested-by: syzbot@syzkaller.appspotmail.com
> ---
>  io_uring/io_uring.c |  12 +++++
>  io_uring/io_uring.h | 114 ++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 123 insertions(+), 3 deletions(-)
>

