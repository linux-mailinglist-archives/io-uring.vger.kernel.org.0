Return-Path: <io-uring+bounces-6033-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DFBF0A18883
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2025 00:45:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D1DE16B1A0
	for <lists+io-uring@lfdr.de>; Tue, 21 Jan 2025 23:45:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E2711F869F;
	Tue, 21 Jan 2025 23:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QeSrQ8p8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9C41F03CC
	for <io-uring@vger.kernel.org>; Tue, 21 Jan 2025 23:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737503131; cv=none; b=hJ/ZTCP3j/yqqpXF/YNS68OblXujW1jfvGLygADOqn9Jy4Fp+mO+9sKaD5iEvJGoKCiurn6QwK7e1NhDFB/bAVew4e/6hXbd00/PxNbr7cl6pGc+RQgZiVO/+GKVUqXlT0ZqKSElJQyRYhMNau56ofZbTa5SzuXbegQeDEzxm2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737503131; c=relaxed/simple;
	bh=APHSxtxj96aGR9btsWOuxVZUecd0viVei1vCVB1nDac=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JIDxXz2v1DGEsiSAn9rt0jVFBIB8gOE1b3bUxqr6ds7eLQVz5HLiqyG/yzDjpqW0u8wERT/AiJ/+U0SHcall9TXl6PIY7gzl4uMduhsGQPP2oUzM7voFknzNdXqhk4TGZVv/LdiRZid1j+rJfHULsR0XxBbQ3KjPuuY2HWip8TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QeSrQ8p8; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5d3e638e1b4so1790a12.1
        for <io-uring@vger.kernel.org>; Tue, 21 Jan 2025 15:45:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737503128; x=1738107928; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=APHSxtxj96aGR9btsWOuxVZUecd0viVei1vCVB1nDac=;
        b=QeSrQ8p83sDxtwCysGxZDN+H/okesYjHdaRGohoHwvOOsSoYGR8Z47bMlrj1iPghGa
         nvdbn27RQUIMzhkf8E1IQE3lDGVf7UrePgOBnT+384cl6TmUJi/mz66DXNj4qV5y8rDv
         f5pTnqoQ4rs0UjX9/+tt1/S/hBhU1oM8WbtsRoDwHJil440Ff0sCID6UDigou6iqIpzK
         4yktGlyMYwOUMLbboCZZehPuY7/xHTvt7z66M8cND4YHAPMtXWn2EjmNvSCNrndIN4fv
         bGj76tvGD2l3dAY+ps/NFl8a1llcX5aBO/g3tGUT3UCyAVGt7JfD24hnyGGlf17uO/WV
         V2EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737503128; x=1738107928;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=APHSxtxj96aGR9btsWOuxVZUecd0viVei1vCVB1nDac=;
        b=GfV76sMBHCRXkn3zB6VUJycWZEA3Tss+R1jVDCcQuEJKy8zrOpdpR8/DWrLSGzEBN8
         CHz0LFEjs3TB3p4urcrH8Bkfu9mczLbYd/DcHVjUgRwa53JGyA1Levax9juvr7X/QXpy
         2hkbo4VrxRMM2OBC8jUyLP5uOX6c/0jGXfNQaeF3+WMYhW6/s3HGG2JxVGCnE7lWuiXo
         bsgX9C5Lk3r0wRrAi9vIGNh6kiqnRAi/8NjP5HD6MFw2abZotjaDeDdIHPXHbSVh8qV7
         xElahKoY9bfto94Eaye/CfYe+TGtRU2R0e5TuTiFCCBUmRwHtSWxAECthKFg7qfoBt5t
         plaw==
X-Gm-Message-State: AOJu0YzWmVGqC42wqMLC7Fm7/pywCT30Cp8YXKgJo8dpieTvEHxQU1cj
	GYxLucPLXfRNnnZZdJB9BWBQ7gr5r51K+Aef92VahGcyhS64Up95iT5NHBMQs54k4ATVFLV2Iu8
	YNaKH2hOIEMMQgSEG1NTMq54JZ9oTRJKjP+JULLVwCDYgkCK/v4fyKnw=
X-Gm-Gg: ASbGncuXxuDwRAJopzzP1/LxXUHr7WHuyYLTPA55zjyb2HV5gzL7bypuwCvVh76ima5
	x94a0qpBdyx5feWjuvPnrJ0KeJCxwen5Dq+yFN4kOoyikTHtiGF6ps3aAQdr2yyYdUmGhgG5Oqm
	0cFFw=
X-Google-Smtp-Source: AGHT+IEGZHjxK3jMFTyEg5ik3esOU5Q8Ng2WVr8PxzQQvK/m+rMgbJnvIGKxF7UBAc5gUu98foyf8q2MsOL1w7xyoqs=
X-Received: by 2002:a50:a458:0:b0:5db:e72d:b084 with SMTP id
 4fb4d7f45d1cf-5dbf2f87f0fmr40232a12.0.1737503127518; Tue, 21 Jan 2025
 15:45:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAG48ez2k5+SpsvWm_Ryj8_F0vHZjYEgJLKa1M2pNpLEoj-0yRg@mail.gmail.com>
In-Reply-To: <CAG48ez2k5+SpsvWm_Ryj8_F0vHZjYEgJLKa1M2pNpLEoj-0yRg@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Wed, 22 Jan 2025 00:44:51 +0100
X-Gm-Features: AbW1kvaZrnZaOHCZOyodmMohmKg1PGe-BBZBHVy1kR-nGt4Ayo1MbcjWCUpDcjE
Message-ID: <CAG48ez0C1ZKBDi+n9J=FDFKHN7UhQF371AkefCNNqoYMONhxGw@mail.gmail.com>
Subject: Re: io_msg_remote_post() sets up dangling pointer (but it is never accessed)?
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 22, 2025 at 12:41=E2=80=AFAM Jann Horn <jannh@google.com> wrote=
:
> I think the following statement in io_msg_remote_post():
>
> req->tctx =3D READ_ONCE(ctx->submitter_task->io_uring);
>
> sets req->tctx to a pointer that may immediately become dangling if
> the ctx->submitter_task concurrently goes through execve() including
> the call path:
>
> begin_new_exec -> io_uring_task_cancel -> __io_uring_cancel(true) ->
> io_uring_cancel_generic(true, ...) -> __io_uring_free()
>
> However, I can't find any codepath that can actually dereference the
> req->tctx of such a ring message; and I did some quick test under
> KASAN, and that also did not reveal any issue.
>
> I think the current code is probably fine, but it would be nice if we
> could avoid having a potentially dangling pointer here. Can we NULL
> out the req->tctx in io_msg_remote_post(), or is that actually used
> for some pointer comparison or such?

This seems to have been the case since commit
b6f58a3f4aa8dba424356c7a69388a81f4459300 ("io_uring: move struct
io_kiocb from task_struct to io_uring_task").

