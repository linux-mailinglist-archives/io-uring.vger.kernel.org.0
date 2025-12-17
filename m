Return-Path: <io-uring+bounces-11159-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 76581CC9CFE
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 00:36:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9DE463033DDA
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 23:36:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91BCB31D36A;
	Wed, 17 Dec 2025 23:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="S1IWJXuA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A497A212552
	for <io-uring@vger.kernel.org>; Wed, 17 Dec 2025 23:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766014600; cv=none; b=kwPmfpPQ/iKv+M0qXK2oJhmXcT0YlvRQD1Wl+nhVG8S/uclyEgQWQIDw3aCHjO3BXHo+WB22lnhK78PfIJlCb+6er3oerONR1YMSIBCBwEuAyfmiFGKL5MBj0hicjKpM/tw77ZibjKgZ4Nw65sR4AsI7RDOodePcCYiXEnEscPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766014600; c=relaxed/simple;
	bh=iNvcTW6a3+xD4HHLKdH9ZelW/xfNyvZUrTJFbD+cqiM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mkts21kcdlY/4PZrBaiVfnmX3NLmYzr0StF+vjTo29XmDm/NsezazplgpKFgX/4nLCTLpzleA5C4CtmnHAhwUpA5sVxvNDggJIFgYkdief2RkPAhb2lfmYpoD5VUSRcsaMfzdBzdKoGHBGQzizLxWRfQp5wSBjitjoGigvjFI9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=S1IWJXuA; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-bd2decde440so9380a12.0
        for <io-uring@vger.kernel.org>; Wed, 17 Dec 2025 15:36:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1766014598; x=1766619398; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t/93366TDBujwrKcxBlAqyoiyN1IlPuJv8viChO3ob4=;
        b=S1IWJXuAaCSgUiONo8nmS+OT7ncpY0mIORmzK9I9H38OOJwmH/vuxSs6mJBWj2G/RU
         wLLTdB7BopGnkKpeTFrkCVfGr0qifS3z5LvQYm+wEWVe/0yGppBcPHTQFW6kDuvN9G7W
         sRwC+JC0oiKKIGpx31t6Zig+FP/t/Z1p81mcQxv1ai+w32/QyqXRfIctBN6HweQtFH0a
         eiGJ6ZSs54TsUPu4H7kBqwZULBY8KTp36hH/huuLkJgpQXn5W/SKe1qUeIPyEWZ7a7TZ
         OCnuAvdheU+4Gw/ONw0+JT3kranSzDPIWqopvCVz2CudrlD7pX/yTL/VS+VWgy5yg7iU
         uE0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766014598; x=1766619398;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t/93366TDBujwrKcxBlAqyoiyN1IlPuJv8viChO3ob4=;
        b=jICGxlUo7/D9Ml+MZttTrtdpXPlAALYGd5XbVL8Q0DOigCerh2ipsaXzwQXfsXyCXG
         XlgBUi5XYBeWUoEOelpcylCzh6h+arO2o4f0IKjD9Vp48yTyMb/Cp2Fj9/5Hc/oeZIK8
         4v6lbL60IzV29i/odXFXDLP3jhhfiYSPRb8kes5iCHVnmMGQDifssJMPxbfrye3IuSXA
         /Gzw7dHD52iDsiZWB88Pp2EV47R55yxMUX2YFTrYomXerBZeegPQzUVCZZakTykMbJh6
         DumoYoIQudexi+YEsKJldFWP/qHMxq8EdTP5YibrUCMqoYrk04fnNniVmp6Y4ATL8mGz
         mvSA==
X-Forwarded-Encrypted: i=1; AJvYcCVM0tQMEz/V/qQQqbyar1g6R/yfMrXovvGIj0ijxdQ93f+kcf8ZufJWMvarCXpKyq0lLk19UihowQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YywmtsOvpN9Ba1p/pcCQk1DdUGuTVt+HuIci4C8BY3jFTfhWTxK
	g+35rgAtyXjk5GZhy8/jml1wex7xgPdcTj5ArdR/D4tkJ0e3tn1s0VxoWR0jexd3ORsKf10ARXj
	iAl9JCglF7VLYV1MG5MMk9dAwzSdWmpnFOtJxLnGrNA==
X-Gm-Gg: AY/fxX6Uk4yP6StXxpRXeMooV0oHBv1Yw/JK8jJgq3RP1Y8lPY7SpqQctpMLDu4h3LD
	FAhmG5U1+BBGX0PXc58DwVfaCIWV63GbbiwgMtT7eYRHquw/ij/SukSghwsYv4JaHh21dWCpbMI
	c+VbjfgMtLpvIHzQSqkuhMuuL4HWKoJrzX+/He3y2fR87OZ9ZEgoNmAK2Bxww7r2Lx78RbBnATx
	hXRF+rgaeoGM8VX2es/viJLTJD8aj2B6G7BAbfFIi4VQr06/YuWXd44wuTzqNXFhx8dpe5k
X-Google-Smtp-Source: AGHT+IGfPDy7bcJt6e/8Yo/IsYu+OqYoqLD+UeLLw7ceossP9+JKDmSJKRxbT7Zw9BTOxagomTQltnrU7/2wGjU/ZRU=
X-Received: by 2002:a05:7301:11a7:b0:2ae:6120:57c0 with SMTP id
 5a478bee46e88-2b0504f933bmr169869eec.3.1766014597734; Wed, 17 Dec 2025
 15:36:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251217214753.218765-3-veyga@veygax.dev>
In-Reply-To: <20251217214753.218765-3-veyga@veygax.dev>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Wed, 17 Dec 2025 15:36:26 -0800
X-Gm-Features: AQt7F2oq3BiNtET5isvVIeYoJgLdgUlQpFTIZXmkXMqwgxAV9VrE0lBnIjyaWzU
Message-ID: <CADUfDZpDkJd25pzX5KU-5XonHA=D0tUM8k6Th=OXAmjA9KTq+g@mail.gmail.com>
Subject: Re: [PATCH v2] io_uring/rsrc: fix slab-out-of-bounds in io_buffer_register_bvec
To: veygax <veyga@veygax.dev>
Cc: Jens Axboe <axboe@kernel.dk>, "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 17, 2025 at 1:50=E2=80=AFPM veygax <veyga@veygax.dev> wrote:
>
> From: Evan Lambert <veyga@veygax.dev>
>
> The function io_buffer_register_bvec() calculates the allocation size
> for the io_mapped_ubuf based on blk_rq_nr_phys_segments(rq). This
> function calculates the number of scatter-gather elements after merging
> physically contiguous pages.
>
> However, the subsequent loop uses rq_for_each_bvec() to populate the
> array, which iterates over every individual bio_vec in the request,
> regardless of physical contiguity.
>
> If a request has multiple bio_vec entries that are physically
> contiguous, blk_rq_nr_phys_segments() returns a value smaller than
> the total number of bio_vecs. This leads to a slab-out-of-bounds write.

It's still not clear to me that a real block layer request can contain
physically contiguous bvecs. How is the request being generated in
your KUnit test that hits this issue?

>
> The path is reachable from userspace via the ublk driver when a server
> issues a UBLK_IO_REGISTER_IO_BUF command. This requires the
> UBLK_F_SUPPORT_ZERO_COPY flag which is protected by CAP_SYS_ADMIN.
>
> Fix this by checking if the current bio_vec is physically contiguous
> with the previous one. If they are contiguous, it extends the length of
> the existing entry instead of writing a new one, ensuring the population
> loop mirrors the segment merging done during allocation.
>
> KASAN report:
>
> BUG: KASAN: slab-out-of-bounds in io_buffer_register_bvec+0x813/0xb80
> Write of size 8 at addr ffff88800223b238 by task kunit_try_catch/27
> [...]
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x4d/0x70
>  print_report+0x151/0x4c0
>  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
>  ? io_buffer_register_bvec+0x813/0xb80
>  kasan_report+0xec/0x120
>  ? io_buffer_register_bvec+0x813/0xb80
>  io_buffer_register_bvec+0x813/0xb80
>  io_buffer_register_bvec_overflow_test+0x4e6/0x9b0
>  ? __pfx_io_buffer_register_bvec_overflow_test+0x10/0x10
>  ? __pfx_pick_next_task_fair+0x10/0x10
>  ? _raw_spin_lock+0x7e/0xd0
>  ? finish_task_switch.isra.0+0x19a/0x650
>  ? __pfx_read_tsc+0x10/0x10
>  ? ktime_get_ts64+0x79/0x240
>  kunit_try_run_case+0x19b/0x2c0
>  ? __pfx_kunit_try_run_case+0x10/0x10
>  ? __pfx_kunit_generic_run_threadfn_adapter+0x10/0x10
>  kunit_generic_run_threadfn_adapter+0x80/0xf0
>  kthread+0x323/0x670
>  ? __pfx_kthread+0x10/0x10
>  ? __pfx__raw_spin_lock_irq+0x10/0x10
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork+0x329/0x420
>  ? __pfx_ret_from_fork+0x10/0x10
>  ? __switch_to+0xa0f/0xd40
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork_asm+0x1a/0x30
>  </TASK>
>
> Fixes: 27cb27b6d5ea ("io_uring: add support for kernel registered bvecs")
> Signed-off-by: Evan Lambert <veyga@veygax.dev>
> ---
> Fixed the typos helpfully spotted by Caleb + added a new approach where
> we check if the current bio_vec is physically contiguous with the
> previous one. This stops the OOB write from occuring via my KUnit test.
>
>  io_uring/rsrc.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index a63474b331bf..16259b75f363 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -988,8 +988,20 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd=
, struct request *rq,
>         imu->is_kbuf =3D true;
>         imu->dir =3D 1 << rq_data_dir(rq);
>
> -       rq_for_each_bvec(bv, rq, rq_iter)
> +       nr_bvecs =3D 0;
> +       rq_for_each_bvec(bv, rq, rq_iter) {
> +               if (nr_bvecs > 0) {
> +                       struct bio_vec *p =3D &imu->bvec[nr_bvecs - 1];
> +
> +                       if (page_to_phys(p->bv_page) + p->bv_offset + p->=
bv_len =3D=3D
> +                           page_to_phys(bv.bv_page) + bv.bv_offset &&
> +                           p->bv_len + bv.bv_len >=3D p->bv_len) {
> +                               p->bv_len +=3D bv.bv_len;
> +                               continue;
> +                       }
> +               }
>                 imu->bvec[nr_bvecs++] =3D bv;
> +       }
>         imu->nr_bvecs =3D nr_bvecs;
>
>         node->buf =3D imu;
> --
> 2.52.0
>
>

