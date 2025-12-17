Return-Path: <io-uring+bounces-11158-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DC925CC9A12
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 22:50:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id DBDA6300BE57
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 21:50:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A86327602C;
	Wed, 17 Dec 2025 21:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=veygax.dev header.i=@veygax.dev header.b="afGamU5p"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-4320.protonmail.ch (mail-4320.protonmail.ch [185.70.43.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC08192590;
	Wed, 17 Dec 2025 21:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766008227; cv=none; b=HuLrNlbVQlh+klAZ25Rvt1ghF96p5mmeHJ7aGLbV+P4vZgC3jJCpiP+1cZFoVILP2misrMf7uK6oBmkY0F5aRnCaUiUgBLhkwkfCbudN/aoLb3MYvwBVUhM7eY/UzanzOnDMWqj3aSNVRTEU/ytHbqMC/U5lNXUzLnjCpPUNj4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766008227; c=relaxed/simple;
	bh=76YluT0w9am6/irkS8hBjeeRlVfEYmnbbk4sUwDT5Bk=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=HzZmSCBK33k10eJXD4Ob8Dpk/QDnYWX/1LURzzYhWxCwoAwwHZxV1QTK0dJW4GdgCL6bHWk3OUTY2V2KYbJ0lcUzmDTHGW/eTJQypP1MGYJ2OcN9k/i976ueVEDfuLtjCGG3qPzJ56ILa6c1edKYn3NbD/357noYE+bU9bQIr04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=veygax.dev; spf=pass smtp.mailfrom=veygax.dev; dkim=pass (2048-bit key) header.d=veygax.dev header.i=@veygax.dev header.b=afGamU5p; arc=none smtp.client-ip=185.70.43.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=veygax.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=veygax.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=veygax.dev;
	s=protonmail; t=1766008215; x=1766267415;
	bh=R7XpvjUVjzjUbieYR2nCuT4u1okRhaO1kBAyUeGZ0i8=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=afGamU5pbVFbE3TyKVHcuUs8jzwtOLzGr4eySKCFtDOR13KCTtf/NahWrk5nzA8xm
	 bmITW5GZm3Bblhm0R6OtyMSQCHEQhidx/RQupF1vSgMSADqP7Otks+BYSU+H9cqCCz
	 1rKvcLPQ/puq6Df6bg1uxEby8RtrZ5W7+eD/4pbWeXb0gNr/WFN6cFxTNaf72TFHxd
	 NuyNvFruVa0tqqX/Hf3rm3tQUd5nbaVVrAif3Dz6jwzrk3SLJM2MMUvg1ffWbZHwEd
	 M1sqRkkwdSPJ9UdvlDea7COUWWmaD61+5GdyEl2QE0dFg2M2LCxIxEzahZ0/7cuoCc
	 rnG08HP9WQjjA==
Date: Wed, 17 Dec 2025 21:50:13 +0000
To: Jens Axboe <axboe@kernel.dk>, "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
From: veygax <veyga@veygax.dev>
Cc: Caleb Sander Mateos <csander@purestorage.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Evan Lambert <veyga@veygax.dev>
Subject: [PATCH v2] io_uring/rsrc: fix slab-out-of-bounds in io_buffer_register_bvec
Message-ID: <20251217214753.218765-3-veyga@veygax.dev>
Feedback-ID: 160365411:user:proton
X-Pm-Message-ID: f1f58f7f608976851024a492ead2db5198ea5846
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

From: Evan Lambert <veyga@veygax.dev>

The function io_buffer_register_bvec() calculates the allocation size
for the io_mapped_ubuf based on blk_rq_nr_phys_segments(rq). This
function calculates the number of scatter-gather elements after merging
physically contiguous pages.

However, the subsequent loop uses rq_for_each_bvec() to populate the
array, which iterates over every individual bio_vec in the request,
regardless of physical contiguity.

If a request has multiple bio_vec entries that are physically
contiguous, blk_rq_nr_phys_segments() returns a value smaller than
the total number of bio_vecs. This leads to a slab-out-of-bounds write.

The path is reachable from userspace via the ublk driver when a server
issues a UBLK_IO_REGISTER_IO_BUF command. This requires the
UBLK_F_SUPPORT_ZERO_COPY flag which is protected by CAP_SYS_ADMIN.

Fix this by checking if the current bio_vec is physically contiguous
with the previous one. If they are contiguous, it extends the length of
the existing entry instead of writing a new one, ensuring the population
loop mirrors the segment merging done during allocation.

KASAN report:

BUG: KASAN: slab-out-of-bounds in io_buffer_register_bvec+0x813/0xb80
Write of size 8 at addr ffff88800223b238 by task kunit_try_catch/27
[...]
Call Trace:
 <TASK>
 dump_stack_lvl+0x4d/0x70
 print_report+0x151/0x4c0
 ? __pfx__raw_spin_lock_irqsave+0x10/0x10
 ? io_buffer_register_bvec+0x813/0xb80
 kasan_report+0xec/0x120
 ? io_buffer_register_bvec+0x813/0xb80
 io_buffer_register_bvec+0x813/0xb80
 io_buffer_register_bvec_overflow_test+0x4e6/0x9b0
 ? __pfx_io_buffer_register_bvec_overflow_test+0x10/0x10
 ? __pfx_pick_next_task_fair+0x10/0x10
 ? _raw_spin_lock+0x7e/0xd0
 ? finish_task_switch.isra.0+0x19a/0x650
 ? __pfx_read_tsc+0x10/0x10
 ? ktime_get_ts64+0x79/0x240
 kunit_try_run_case+0x19b/0x2c0
 ? __pfx_kunit_try_run_case+0x10/0x10
 ? __pfx_kunit_generic_run_threadfn_adapter+0x10/0x10
 kunit_generic_run_threadfn_adapter+0x80/0xf0
 kthread+0x323/0x670
 ? __pfx_kthread+0x10/0x10
 ? __pfx__raw_spin_lock_irq+0x10/0x10
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x329/0x420
 ? __pfx_ret_from_fork+0x10/0x10
 ? __switch_to+0xa0f/0xd40
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1a/0x30
 </TASK>

Fixes: 27cb27b6d5ea ("io_uring: add support for kernel registered bvecs")
Signed-off-by: Evan Lambert <veyga@veygax.dev>
---
Fixed the typos helpfully spotted by Caleb + added a new approach where
we check if the current bio_vec is physically contiguous with the
previous one. This stops the OOB write from occuring via my KUnit test.

 io_uring/rsrc.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index a63474b331bf..16259b75f363 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -988,8 +988,20 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd, =
struct request *rq,
 =09imu->is_kbuf =3D true;
 =09imu->dir =3D 1 << rq_data_dir(rq);
=20
-=09rq_for_each_bvec(bv, rq, rq_iter)
+=09nr_bvecs =3D 0;
+=09rq_for_each_bvec(bv, rq, rq_iter) {
+=09=09if (nr_bvecs > 0) {
+=09=09=09struct bio_vec *p =3D &imu->bvec[nr_bvecs - 1];
+
+=09=09=09if (page_to_phys(p->bv_page) + p->bv_offset + p->bv_len =3D=3D
+=09=09=09    page_to_phys(bv.bv_page) + bv.bv_offset &&
+=09=09=09    p->bv_len + bv.bv_len >=3D p->bv_len) {
+=09=09=09=09p->bv_len +=3D bv.bv_len;
+=09=09=09=09continue;
+=09=09=09}
+=09=09}
 =09=09imu->bvec[nr_bvecs++] =3D bv;
+=09}
 =09imu->nr_bvecs =3D nr_bvecs;
=20
 =09node->buf =3D imu;
--=20
2.52.0



