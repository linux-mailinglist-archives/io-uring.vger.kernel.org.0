Return-Path: <io-uring+bounces-11157-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 45799CC9988
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 22:23:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8CB17303BE9E
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 21:23:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EA3630F922;
	Wed, 17 Dec 2025 21:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="NEF2mpFX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728462494FE
	for <io-uring@vger.kernel.org>; Wed, 17 Dec 2025 21:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766006583; cv=none; b=ZqHgEYGc6unpVGOgtHYyv9a30xp2Rph87T7nyF1i/UTyudxeB6htR+xZMP5XupAA0CGWOddEBSOpSTtj0gBiLZlbekl/RtNIlftSy4W5vA8q360AFJVXBd6qG+c3g1uSvJNggwcjrsqVYbCz3/96d743+H/K46ViZlytgbz78rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766006583; c=relaxed/simple;
	bh=GUHKzvYW5MOSKAb+QbqGjh/scitEP9+inafmSbploe0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qy1aI8BFilXCTBq96B3XffkN16yVxZ4c5LeWloJteP70Bgebp172S3ocdE0O99exIQNiYpXnZN+uRSgAHeLMmGMIs1OthD/KCqgVx33EXneNM0TDZ3qzC9jZh6pCmv4b4I1NweK/UtPKspDauQyyJL9qNNH8Erc82pK3AA5ngHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=NEF2mpFX; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2a07fb1527cso11595895ad.3
        for <io-uring@vger.kernel.org>; Wed, 17 Dec 2025 13:23:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1766006581; x=1766611381; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b00kv3eYwiHloHb7q4QPMYPl9WPp7wOogsxKpXwwmss=;
        b=NEF2mpFXTuIydp3gtrAsgdDCfh7HL50uyUnByyb/p3RrcLIhZ+LgRD9E/tFyA07g17
         lpZ2zgFoqB5XirvXhdFYljzZyqNHlGIkrWFEjGNChXfCI52QG7pJcVGbuvsuqmaE0hF1
         eBXRdVUZw+YARey6H7DlrFTL0H0uaHOu+QAP6JmuEZT6PrS0c9n97Pw/r9GGRIYoAN9M
         2WSzv7D3YIlAMEDAxfN1pQB24UAPtsiMiWdn7udoo2cZAq7d9WaZy4mcg0Th+MlHi2Ai
         q3A++AAI6Zpp419jih74bs9gL8xH1GOoqmOvtLD8QZgHp6beSgQ5qftusWgcJDZa9NVl
         5QFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766006581; x=1766611381;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b00kv3eYwiHloHb7q4QPMYPl9WPp7wOogsxKpXwwmss=;
        b=tB1HpDpRsZYrVlQGYRX00v60nJ7S9FU+kpPA9U+lbMmF4X5hNICTwTcx6DuEAEoZ1w
         7o+olw5lZWNlOFcNqFto7EeY3AGfiviS6OF4VoLUymfRjG9P+qDtVMMMM06rPPo/gJBn
         rkYdE4yAJ7H32vuoacfAkqlM3w8w4DoFgm8ssvZAV3OR1NCAYyFJ0hdb2v0UsCqe70+4
         fHVgPs71VBXrkRpVdOj1/V8VBrbGwagUSEyFan5d2Cbo2J1WsOXz4sfWnUxPF3sScp+g
         9umd2j28LGmHCuT7V2S2PMSJ7S1XrivA6QU7HAXNLJqHI0gJuuu6OrmIX0hMr2wvuCiJ
         S5BA==
X-Forwarded-Encrypted: i=1; AJvYcCXLaboq8kPStChZ74aA9AXYKeGIS2M5jYxq74/1+ZAnGkSku4a/pZUUS1TMzKPDZF5eXz5EsVj+dg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwUdr3y8daIGovPLHo+n11/fuggEGkGrCaYIfGtWSaVTEnyf6Gk
	rQDYJozWcdO2oTn7HLc1w6MqFKCQYo1gu0DWrkXtMrmom4Lmwg7J8z8dr9pgh5viD8ilimlPQaw
	Foa7KrrQ+D6NFW6axrQb5a9Aby8S8Hijs5Odvh6YHWg==
X-Gm-Gg: AY/fxX4SilexPBJmNnsFKXTesjcqMRGa2wrYaFEc0mXGfOZpqUsrF/7xoXyiSjQyqCN
	KQfZ2Be4sPx7PePSKDjcr8PWtahTDeMgPmL1Yi4LWlsZOflQQtq48GFycoMZtGWQfdNebgE691L
	WgqGatecF+NJ9uIsmF0++sihfgD4Xew0dt8Y2h/2XZShqCxCevWzgdT7H7zrOlBSL42U6iZRn4Z
	v7zQwnzh2qSOhcO2ABT/e6xNkewiSOWQ55Mp4RVDYQguTdYCE/psO0gRQ4bo6XYnHJ3aXNfO+Vj
	rnZRytI=
X-Google-Smtp-Source: AGHT+IFZhctX2EpYjFE77/VRMsGmlqqMmVuJmhJHItVu5Ttx1NQzSZfmQUhntaux6fx3Pav+6B7khgBdNzt0aymVfbc=
X-Received: by 2002:a05:701b:291c:b0:11b:98e8:624e with SMTP id
 a92af1059eb24-12062885582mr2399c88.4.1766006580465; Wed, 17 Dec 2025 13:23:00
 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251217210316.188157-3-veyga@veygax.dev>
In-Reply-To: <20251217210316.188157-3-veyga@veygax.dev>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Wed, 17 Dec 2025 13:22:48 -0800
X-Gm-Features: AQt7F2qr1YbLdu2EOjFucwzCHk1ZSa3kp-HsBmhmuRHtFDhZ1apgzgMFj6uETmM
Message-ID: <CADUfDZrcbU5ABbLs6SBCHjKwfGtAnpcMtJaLQc7BTKNbG4RJ0A@mail.gmail.com>
Subject: Re: [PATCH] io_uring/rsrc: fix slab-out-of-bounds in io_buffer_register_bvec
To: veygax <veyga@veygax.dev>
Cc: Jens Axboe <axboe@kernel.dk>, "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 17, 2025 at 1:04=E2=80=AFPM veygax <veyga@veygax.dev> wrote:
>
> From: Evan Lambert <veyga@veygax.dev>
>
> The function io_buffer_register_bvec() calculates the allocation size
> for the io_mapped_ubuf based on blk_rq_nr_phys_segments(rq). This
> function calculates the number of scatter-gather elements after megine

"merging"?

> physically contiguous pages.
>
> However, the subsequent loop uses rq_for_each_bvec() to populate the
> array, which iterates over every individual bio_vec in the request,
> regardless of physical contiguity.

Hmm, I would have thought that physically contiguous bio_vecs would
have been merged by the block layer? But that's definitely beyond my
expertise.

>
> If a request has multiple bio_vec entries that are physically
> contiguous, blk_rq_nr_phys_segments() returns a value smaller than
> the total number of bio_vecs. This leads to a slab-out-of-bounds write.
>
> The path is reachable from userspace via the ublk driver when a server
> issues a UBLK_IO_REGISTER_IO_BUF command. This requires the
> UBLK_F_SUPPORT_ZERO_COPY flag which is protected by CAP_NET_ADMIN.

"CAP_SYS_ADMIN"?

>
> Fix this by calculating the total number of bio_vecs by iterating
> over the request's bios and summing their bi_vcnt.
>
> KASAN report:
>
> [18:01:50] BUG: KASAN: slab-out-of-bounds in io_buffer_register_bvec+0x81=
3/0xb80
> [18:01:50] Write of size 8 at addr ffff88800223b238 by task kunit_try_cat=
ch/27
> [18:01:50]
> [18:01:50] CPU: 0 UID: 0 PID: 27 Comm: kunit_try_catch Tainted: G        =
         N  6.19.0-rc1-g346af1a0c65a-dirty #44 PREEMPT(none)
> [18:01:50] Tainted: [N]=3DTEST
> [18:01:50] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.=
1 11/11/2019
> [18:01:50] Call Trace:
> [18:01:50]  <TASK>
> [18:01:50]  dump_stack_lvl+0x4d/0x70
> [18:01:50]  print_report+0x151/0x4c0
> [18:01:50]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
> [18:01:50]  ? io_buffer_register_bvec+0x813/0xb80
> [18:01:50]  kasan_report+0xec/0x120
> [18:01:50]  ? io_buffer_register_bvec+0x813/0xb80
> [18:01:50]  io_buffer_register_bvec+0x813/0xb80
> [18:01:50]  io_buffer_register_bvec_overflow_test+0x4e6/0x9b0
> [18:01:50]  ? __pfx_io_buffer_register_bvec_overflow_test+0x10/0x10
> [18:01:50]  ? __pfx_pick_next_task_fair+0x10/0x10
> [18:01:50]  ? _raw_spin_lock+0x7e/0xd0
> [18:01:50]  ? finish_task_switch.isra.0+0x19a/0x650
> [18:01:50]  ? __pfx_read_tsc+0x10/0x10
> [18:01:50]  ? ktime_get_ts64+0x79/0x240
> [18:01:50]  kunit_try_run_case+0x19b/0x2c0

This doesn't look like an actual ublk zero-copy buffer registration.
Where does the struct request come from?

> [18:01:50]  ? __pfx_kunit_try_run_case+0x10/0x10
> [18:01:50]  ? __pfx_kunit_generic_run_threadfn_adapter+0x10/0x10
> [18:01:50]  kunit_generic_run_threadfn_adapter+0x80/0xf0
> [18:01:50]  kthread+0x323/0x670
> [18:01:50]  ? __pfx_kthread+0x10/0x10
> [18:01:50]  ? __pfx__raw_spin_lock_irq+0x10/0x10
> [18:01:50]  ? __pfx_kthread+0x10/0x10
> [18:01:50]  ret_from_fork+0x329/0x420
> [18:01:50]  ? __pfx_ret_from_fork+0x10/0x10
> [18:01:50]  ? __switch_to+0xa0f/0xd40
> [18:01:50]  ? __pfx_kthread+0x10/0x10
> [18:01:50]  ret_from_fork_asm+0x1a/0x30
> [18:01:50]  </TASK>
> [18:01:50]
> [18:01:50] Allocated by task 27:
> [18:01:50]  kasan_save_stack+0x30/0x50
> [18:01:50]  kasan_save_track+0x14/0x30
> [18:01:50]  __kasan_kmalloc+0x7f/0x90
> [18:01:50]  io_cache_alloc_new+0x35/0xc0
> [18:01:50]  io_buffer_register_bvec+0x196/0xb80
> [18:01:50]  io_buffer_register_bvec_overflow_test+0x4e6/0x9b0
> [18:01:50]  kunit_try_run_case+0x19b/0x2c0
> [18:01:50]  kunit_generic_run_threadfn_adapter+0x80/0xf0
> [18:01:50]  kthread+0x323/0x670
> [18:01:50]  ret_from_fork+0x329/0x420
> [18:01:50]  ret_from_fork_asm+0x1a/0x30
> [18:01:50]
> [18:01:50] The buggy address belongs to the object at ffff88800223b000
> [18:01:50]  which belongs to the cache kmalloc-1k of size 1024
> [18:01:50] The buggy address is located 0 bytes to the right of
> [18:01:50]  allocated 568-byte region [ffff88800223b000, ffff88800223b238=
)
> [18:01:50]
> [18:01:50] The buggy address belongs to the physical page:
> [18:01:50] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0=
 pfn:0x2238
> [18:01:50] head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 p=
incount:0
> [18:01:50] flags: 0x4000000000000040(head|zone=3D1)
> [18:01:50] page_type: f5(slab)
> [18:01:50] raw: 4000000000000040 ffff888001041dc0 dead000000000122 000000=
0000000000
> [18:01:50] raw: 0000000000000000 0000000080080008 00000000f5000000 000000=
0000000000
> [18:01:50] head: 4000000000000040 ffff888001041dc0 dead000000000122 00000=
00000000000
> [18:01:50] head: 0000000000000000 0000000080080008 00000000f5000000 00000=
00000000000
> [18:01:50] head: 4000000000000002 ffffea0000088e01 00000000ffffffff 00000=
000ffffffff
> [18:01:50] head: 0000000000000000 0000000000000000 00000000ffffffff 00000=
00000000000
> [18:01:50] page dumped because: kasan: bad access detected
> [18:01:50]
> [18:01:50] Memory state around the buggy address:
> [18:01:50]  ffff88800223b100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0=
0 00
> [18:01:50]  ffff88800223b180: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0=
0 00
> [18:01:50] >ffff88800223b200: 00 00 00 00 00 00 00 fc fc fc fc fc fc fc f=
c fc
> [18:01:50]                                         ^
> [18:01:50]  ffff88800223b280: fc fc fc fc fc fc fc fc fc fc fc fc fc fc f=
c fc
> [18:01:50]  ffff88800223b300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc f=
c fc
> [18:01:50] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [18:01:50] Disabling lock debugging due to kernel taint
>
> Fixes: 27cb27b6d5ea ("io_uring: add support for kernel registered bvecs")
> Signed-off-by: Evan Lambert <veyga@veygax.dev>
> ---
>  io_uring/rsrc.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index a63474b331bf..7602b71543e0 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -946,6 +946,7 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd,=
 struct request *rq,
>         struct io_mapped_ubuf *imu;
>         struct io_rsrc_node *node;
>         struct bio_vec bv;
> +       struct bio *bio;
>         unsigned int nr_bvecs =3D 0;
>         int ret =3D 0;
>
> @@ -967,11 +968,10 @@ int io_buffer_register_bvec(struct io_uring_cmd *cm=
d, struct request *rq,
>                 goto unlock;
>         }
>
> -       /*
> -        * blk_rq_nr_phys_segments() may overestimate the number of bvecs
> -        * but avoids needing to iterate over the bvecs
> -        */
> -       imu =3D io_alloc_imu(ctx, blk_rq_nr_phys_segments(rq));
> +       __rq_for_each_bio(bio, rq)
> +               nr_bvecs +=3D bio->bi_vcnt;
> +
> +       imu =3D io_alloc_imu(ctx, nr_bvecs);
>         if (!imu) {
>                 kfree(node);
>                 ret =3D -ENOMEM;
> @@ -988,6 +988,7 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd,=
 struct request *rq,
>         imu->is_kbuf =3D true;
>         imu->dir =3D 1 << rq_data_dir(rq);
>
> +       nr_bvecs =3D 0;
>         rq_for_each_bvec(bv, rq, rq_iter)
>                 imu->bvec[nr_bvecs++] =3D bv;

Could alternatively check for mergability with the previous bvec here.
That would avoid needing to allocate extra memory for physically
contiguous bvecs.

Best,
Caleb

>         imu->nr_bvecs =3D nr_bvecs;
> --
> 2.52.0
>
>

