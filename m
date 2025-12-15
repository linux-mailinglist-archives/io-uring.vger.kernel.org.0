Return-Path: <io-uring+bounces-11043-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 60154CBEEC4
	for <lists+io-uring@lfdr.de>; Mon, 15 Dec 2025 17:35:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 847A030402FC
	for <lists+io-uring@lfdr.de>; Mon, 15 Dec 2025 16:30:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B481A31A04D;
	Mon, 15 Dec 2025 16:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="be9vqe9x"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA1330AD0A
	for <io-uring@vger.kernel.org>; Mon, 15 Dec 2025 16:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765816201; cv=none; b=DiWJI939lMzpBqs0Zj1t06MgX1yjdH4jJs+8pCbMsC9dgAEMc228KuO9LaiMT4UertdNJVR201eJeBMn+1vEt3+trk41o/8qxb5RNd8mAs2tcZBrzlxMS18T4Yvw7qSDeTeuRTVQJ1XQmEDOlfTB7KKHgEt27NaZMUIA5HA7h9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765816201; c=relaxed/simple;
	bh=gzFaKW0r+MznzjZXt7sK0QP5+rfSeN7amZUvN2wBorE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gUph9Xi4lgn21UpAC61hn6Oj9UJJOPk9YprraVn74RFYx8GmgLdAZ/wXqHKU1C3WZ2xR0uB+qMkACXtAReu5tNX0Vjd/IZGuWUGg9h5ojLMNNb7xTPFEz5x50Mns8gjTv9PId72gOe2LoMNOU6nPWe5tGfyIio3HLxNShwvAlPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=be9vqe9x; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2a0a8c2e822so5321235ad.1
        for <io-uring@vger.kernel.org>; Mon, 15 Dec 2025 08:29:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1765816199; x=1766420999; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gzFaKW0r+MznzjZXt7sK0QP5+rfSeN7amZUvN2wBorE=;
        b=be9vqe9xfklyAz5mSOok5rGstr39joIS7NItxLdUCjGVTas/ISpWLEvJlau/NAFa4s
         /Fh+aqav4LutwDozHtERkspE26y0tneGQQSKdhdZ+92ungVhKzXiLgUMp/axVSwmJH6y
         oWZujzg4kZsPf1za2/wGbezPZrlbgKqMhRpZf8YviAQHZ2T7OAGXnWzWnCD5N8Iwksqe
         oSSWORhbpGMxOI232CE371cjBKwRwcnf4emQkOYFSPTp4miOlG/79UvvZ1Jm76rR2WUv
         E+rylg8SXX64w7xli7bDrR/32A1OWeQ1Z0obEqmdCEPYkt2y0twlJiGNbbo5QWfZvYCW
         uSBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765816199; x=1766420999;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gzFaKW0r+MznzjZXt7sK0QP5+rfSeN7amZUvN2wBorE=;
        b=VOJVMYiaELkUW8RGisI1qSXqwfz7SZOhFRoIwIMPQXG9m8eRsdQe6IjBfg9gXhRCZ+
         FflUEqQSap1LS4GyNsdTvWguJg8YLsX5nu762ASnoUBlacDVcGKcd5X0jKnZLPR1wjeO
         Cw9Lln7TsCMP6HSdZRP/xib1dMD1srNUGNElmyF6Vqm6N+lb1t3kVUm/hb+NARUlcb0+
         Sm2KMhZlrrp7+iM4DQnpukhN1d93vtUzBuTcWhefMiVnnsPDw8iDlo8puziAxAtwFyQ0
         wDYgCBov1gYtXaSMciDiJhiAhAMarXF3zlL2hJnVbDw8cypyAXvGunzAFyCDBWCIHNU3
         LhNw==
X-Forwarded-Encrypted: i=1; AJvYcCU35LASO+HMc8xxXFY/AgObtrJKuUkRqdRU4Sj06adA4M3yau0TBj+A6Ls0XsZxWMfJHXMtOPqLlQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzUub336x5/RNx2n2C3dCzJLDKngz8chVj1jq8hElfR7IuhcCHd
	PmfT3rARj+Wqv2quB5GwwTX9HIEFKc7JszAi/C52H65ecPTHe28rjbGawCyrTmpFAOE0vc9RrOe
	Z0q3DwJ8CNcG/uHl2y4Ymkst09ypwKQfnGMA/qvOYHDgtiI0+Vh+X
X-Gm-Gg: AY/fxX6eeOEgWM6QN0X+3QZnHXsVtB7KfBeVvf4Ofp4n7reYV1TxaTpKbsVL2Y1yRAA
	726qrS+FKWuTelVrzGGa+L6smVDrM/6LzWgfJ941WocyCGfJMR1VeTWhYp8QpN+lF9UEat0D+q+
	cqWv6QnKjZ5bra4XwVWFguwMEzmrcI6C8wLIuVGY25PxxuMnoPDfCyItgWSZyuOdNcorl++OzFn
	fv2osu6jAVk7rw9ROU4CnBarHZXtVO5t7TiypwrCEHt3DPxawrhr1slJyR/vQ08NCP/bLgw
X-Google-Smtp-Source: AGHT+IGgYern0hLjPwa0i+GDKjSgUN7lhp4NHYpEbJGQ/cqLiOO2GtTksnx/la40ixX0Y0cB0FNo5dSLWxJiH0/rVmQ=
X-Received: by 2002:a05:7022:7e84:b0:11e:3e9:3e98 with SMTP id
 a92af1059eb24-11f34c4b85dmr4290985c88.7.1765816198395; Mon, 15 Dec 2025
 08:29:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251202164121.3612929-1-csander@purestorage.com>
 <20251202164121.3612929-2-csander@purestorage.com> <CAJnrk1ZGCKdM_jK9QEbd25ikEQT7sCviaoqA6Rv_m1JjOTuEOw@mail.gmail.com>
In-Reply-To: <CAJnrk1ZGCKdM_jK9QEbd25ikEQT7sCviaoqA6Rv_m1JjOTuEOw@mail.gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 15 Dec 2025 08:29:45 -0800
X-Gm-Features: AQt7F2rtv-Zz6Pr8Q1AUh5oe3997eBZm5T7A7_uO6z4GjBJuhX6c5jlz0p_GScc
Message-ID: <CADUfDZrdhNzoEjHCcFrLUQ00Lj2xkwLiSdq4ky737LVQzzVaDg@mail.gmail.com>
Subject: Re: [PATCH v4 1/5] io_uring: use release-acquire ordering for IORING_SETUP_R_DISABLED
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 15, 2025 at 3:31=E2=80=AFAM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> On Wed, Dec 3, 2025 at 12:41=E2=80=AFAM Caleb Sander Mateos
> <csander@purestorage.com> wrote:
> >
> > io_uring_enter() and io_msg_ring() read ctx->flags and
> > ctx->submitter_task without holding the ctx's uring_lock. This means
> > they may race with the assignment to ctx->submitter_task and the
> > clearing of IORING_SETUP_R_DISABLED from ctx->flags in
> > io_register_enable_rings(). Ensure the correct ordering of the
> > ctx->flags and ctx->submitter_task memory accesses by storing to
> > ctx->flags using release ordering and loading it using acquire ordering=
.
> >
> > Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> > Fixes: 7e84e1c7566a ("io_uring: allow disabling rings during the creati=
on")
>
> This LGTM. But should the fixes be commit 7cae596bc31f ("io_uring:
> register single issuer task at creation")? AFAICT, that's the commit
> that introduces the ctx->submitter_task assignment in
> io_register_enable_rings() that causes the memory reordering issue
> with the unlocked read in io_uring_add_tctx_node(). I don't see this
> issue in 7e84e1c7566a.

Yes, that looks correct to me. Thanks for taking a look.

--Caleb

