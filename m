Return-Path: <io-uring+bounces-11156-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CB273CC98AF
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 22:04:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3A9263012962
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 21:04:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E172223D291;
	Wed, 17 Dec 2025 21:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=veygax.dev header.i=@veygax.dev header.b="AInOAUxa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-08.mail-europe.com (mail-08.mail-europe.com [57.129.93.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA041428F4;
	Wed, 17 Dec 2025 21:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.129.93.249
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766005459; cv=none; b=gjSPRYvs2H7BgkZxwOgERUlhD/GnFueB5mHa6DBWxC0B3Osh92JzzO4KIy+aC0POrKJ3UWptMYkOZXTDwIzXx4AIfdGO2RfB6O+czbVhYbdb+5o9GlUr+Pg11ONZ9qfn6rfjXoA1Zwi+79h9LCHE/gTtGCpyjmbU2BNUHkhJuLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766005459; c=relaxed/simple;
	bh=ZPLXm2K99A7RtmiIWEFeHTqvEnuRlehSehfYAx+Zb+4=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=tNe76gWZbfPzIPihgzzc8rw0Cugpdhb+0mVJo+hI9p5fQtdUM84lIH9jocr97akdm5+g7zprFqUdaMK56g+2Osqt8tMhYv99izw2LCHBRnjP2CsiJCamZ//hElw9jtO4LpyXt4L4MHUoWMuS0CruA8w8MiH7gCmbjTSD+BCwvcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=veygax.dev; spf=pass smtp.mailfrom=veygax.dev; dkim=pass (2048-bit key) header.d=veygax.dev header.i=@veygax.dev header.b=AInOAUxa; arc=none smtp.client-ip=57.129.93.249
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=veygax.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=veygax.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=veygax.dev;
	s=protonmail; t=1766005445; x=1766264645;
	bh=LiAJ8tvoT3NfQMGgnJ+xPyoBUWs+3tXHXSsb843k34I=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=AInOAUxa1uZ7Kx2dHiy+nRfAYZyOxoKDHJ0drPuWCw+m74y9UXMuYik2KHSBfsBk/
	 E3PIn6UXro/XJ4lzJ7kUj9kxohMwFFE8Kr5dWHM3p30Pxr2VmwtA05zKWr9xOkAXSp
	 4s927sfHYvL1+XctGfaTf/67qMzppiWgxa24GmIS3MaGJtMLsQlBVfKNKSXap3WxlF
	 2YDSJkW3cTbHvU8Lbif7L5EOIc/VCFwqsQsm2kJ+786V8yex4WQSMzIGNDTxmCscsW
	 9EuAzSsoPavwFV8ZDpYb/njDjEnTAKeRzS0qFXeowjjGmR5lPQAoD/lSWZ6sjg6Bzi
	 JaZ9++7Z9S7gQ==
Date: Wed, 17 Dec 2025 21:04:01 +0000
To: Jens Axboe <axboe@kernel.dk>, "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
From: veygax <veyga@veygax.dev>
Cc: Caleb Sander Mateos <csander@purestorage.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Evan Lambert <veyga@veygax.dev>
Subject: [PATCH] io_uring/rsrc: fix slab-out-of-bounds in io_buffer_register_bvec
Message-ID: <20251217210316.188157-3-veyga@veygax.dev>
Feedback-ID: 160365411:user:proton
X-Pm-Message-ID: 9509f2c41e1f2479f09f9bdceed84b90b0ad759b
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
function calculates the number of scatter-gather elements after megine
physically contiguous pages.

However, the subsequent loop uses rq_for_each_bvec() to populate the
array, which iterates over every individual bio_vec in the request,
regardless of physical contiguity.

If a request has multiple bio_vec entries that are physically
contiguous, blk_rq_nr_phys_segments() returns a value smaller than
the total number of bio_vecs. This leads to a slab-out-of-bounds write.

The path is reachable from userspace via the ublk driver when a server
issues a UBLK_IO_REGISTER_IO_BUF command. This requires the
UBLK_F_SUPPORT_ZERO_COPY flag which is protected by CAP_NET_ADMIN.

Fix this by calculating the total number of bio_vecs by iterating
over the request's bios and summing their bi_vcnt.

KASAN report:

[18:01:50] BUG: KASAN: slab-out-of-bounds in io_buffer_register_bvec+0x813/=
0xb80
[18:01:50] Write of size 8 at addr ffff88800223b238 by task kunit_try_catch=
/27
[18:01:50]
[18:01:50] CPU: 0 UID: 0 PID: 27 Comm: kunit_try_catch Tainted: G          =
       N  6.19.0-rc1-g346af1a0c65a-dirty #44 PREEMPT(none)
[18:01:50] Tainted: [N]=3DTEST
[18:01:50] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.1 =
11/11/2019
[18:01:50] Call Trace:
[18:01:50]  <TASK>
[18:01:50]  dump_stack_lvl+0x4d/0x70
[18:01:50]  print_report+0x151/0x4c0
[18:01:50]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
[18:01:50]  ? io_buffer_register_bvec+0x813/0xb80
[18:01:50]  kasan_report+0xec/0x120
[18:01:50]  ? io_buffer_register_bvec+0x813/0xb80
[18:01:50]  io_buffer_register_bvec+0x813/0xb80
[18:01:50]  io_buffer_register_bvec_overflow_test+0x4e6/0x9b0
[18:01:50]  ? __pfx_io_buffer_register_bvec_overflow_test+0x10/0x10
[18:01:50]  ? __pfx_pick_next_task_fair+0x10/0x10
[18:01:50]  ? _raw_spin_lock+0x7e/0xd0
[18:01:50]  ? finish_task_switch.isra.0+0x19a/0x650
[18:01:50]  ? __pfx_read_tsc+0x10/0x10
[18:01:50]  ? ktime_get_ts64+0x79/0x240
[18:01:50]  kunit_try_run_case+0x19b/0x2c0
[18:01:50]  ? __pfx_kunit_try_run_case+0x10/0x10
[18:01:50]  ? __pfx_kunit_generic_run_threadfn_adapter+0x10/0x10
[18:01:50]  kunit_generic_run_threadfn_adapter+0x80/0xf0
[18:01:50]  kthread+0x323/0x670
[18:01:50]  ? __pfx_kthread+0x10/0x10
[18:01:50]  ? __pfx__raw_spin_lock_irq+0x10/0x10
[18:01:50]  ? __pfx_kthread+0x10/0x10
[18:01:50]  ret_from_fork+0x329/0x420
[18:01:50]  ? __pfx_ret_from_fork+0x10/0x10
[18:01:50]  ? __switch_to+0xa0f/0xd40
[18:01:50]  ? __pfx_kthread+0x10/0x10
[18:01:50]  ret_from_fork_asm+0x1a/0x30
[18:01:50]  </TASK>
[18:01:50]
[18:01:50] Allocated by task 27:
[18:01:50]  kasan_save_stack+0x30/0x50
[18:01:50]  kasan_save_track+0x14/0x30
[18:01:50]  __kasan_kmalloc+0x7f/0x90
[18:01:50]  io_cache_alloc_new+0x35/0xc0
[18:01:50]  io_buffer_register_bvec+0x196/0xb80
[18:01:50]  io_buffer_register_bvec_overflow_test+0x4e6/0x9b0
[18:01:50]  kunit_try_run_case+0x19b/0x2c0
[18:01:50]  kunit_generic_run_threadfn_adapter+0x80/0xf0
[18:01:50]  kthread+0x323/0x670
[18:01:50]  ret_from_fork+0x329/0x420
[18:01:50]  ret_from_fork_asm+0x1a/0x30
[18:01:50]
[18:01:50] The buggy address belongs to the object at ffff88800223b000
[18:01:50]  which belongs to the cache kmalloc-1k of size 1024
[18:01:50] The buggy address is located 0 bytes to the right of
[18:01:50]  allocated 568-byte region [ffff88800223b000, ffff88800223b238)
[18:01:50]
[18:01:50] The buggy address belongs to the physical page:
[18:01:50] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 p=
fn:0x2238
[18:01:50] head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pin=
count:0
[18:01:50] flags: 0x4000000000000040(head|zone=3D1)
[18:01:50] page_type: f5(slab)
[18:01:50] raw: 4000000000000040 ffff888001041dc0 dead000000000122 00000000=
00000000
[18:01:50] raw: 0000000000000000 0000000080080008 00000000f5000000 00000000=
00000000
[18:01:50] head: 4000000000000040 ffff888001041dc0 dead000000000122 0000000=
000000000
[18:01:50] head: 0000000000000000 0000000080080008 00000000f5000000 0000000=
000000000
[18:01:50] head: 4000000000000002 ffffea0000088e01 00000000ffffffff 0000000=
0ffffffff
[18:01:50] head: 0000000000000000 0000000000000000 00000000ffffffff 0000000=
000000000
[18:01:50] page dumped because: kasan: bad access detected
[18:01:50]
[18:01:50] Memory state around the buggy address:
[18:01:50]  ffff88800223b100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00
[18:01:50]  ffff88800223b180: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00
[18:01:50] >ffff88800223b200: 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc =
fc
[18:01:50]                                         ^
[18:01:50]  ffff88800223b280: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc =
fc
[18:01:50]  ffff88800223b300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc =
fc
[18:01:50] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[18:01:50] Disabling lock debugging due to kernel taint

Fixes: 27cb27b6d5ea ("io_uring: add support for kernel registered bvecs")
Signed-off-by: Evan Lambert <veyga@veygax.dev>
---
 io_uring/rsrc.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index a63474b331bf..7602b71543e0 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -946,6 +946,7 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd, s=
truct request *rq,
 =09struct io_mapped_ubuf *imu;
 =09struct io_rsrc_node *node;
 =09struct bio_vec bv;
+=09struct bio *bio;
 =09unsigned int nr_bvecs =3D 0;
 =09int ret =3D 0;
=20
@@ -967,11 +968,10 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd,=
 struct request *rq,
 =09=09goto unlock;
 =09}
=20
-=09/*
-=09 * blk_rq_nr_phys_segments() may overestimate the number of bvecs
-=09 * but avoids needing to iterate over the bvecs
-=09 */
-=09imu =3D io_alloc_imu(ctx, blk_rq_nr_phys_segments(rq));
+=09__rq_for_each_bio(bio, rq)
+=09=09nr_bvecs +=3D bio->bi_vcnt;
+
+=09imu =3D io_alloc_imu(ctx, nr_bvecs);
 =09if (!imu) {
 =09=09kfree(node);
 =09=09ret =3D -ENOMEM;
@@ -988,6 +988,7 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd, s=
truct request *rq,
 =09imu->is_kbuf =3D true;
 =09imu->dir =3D 1 << rq_data_dir(rq);
=20
+=09nr_bvecs =3D 0;
 =09rq_for_each_bvec(bv, rq, rq_iter)
 =09=09imu->bvec[nr_bvecs++] =3D bv;
 =09imu->nr_bvecs =3D nr_bvecs;
--=20
2.52.0



