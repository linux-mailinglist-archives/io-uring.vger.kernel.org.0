Return-Path: <io-uring+bounces-12895-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2OJjBBzOy2luLwYAu9opvQ
	(envelope-from <io-uring+bounces-12895-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 15:37:32 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A66736A5C7
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 15:37:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 005763069323
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 13:32:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C682342535;
	Tue, 31 Mar 2026 13:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PGZYLf1W"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dy1-f193.google.com (mail-dy1-f193.google.com [74.125.82.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E7F32F765
	for <io-uring@vger.kernel.org>; Tue, 31 Mar 2026 13:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.193
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774963973; cv=pass; b=aYaYsVJ1XF8uTZub0zRcQrl3Sht77vV5KcUM4zhP/PmnW1Hnga8BuVHuQ1hat18rM1WB8qf+ZJVaoOFZJhavhfJBN51U0n5JGV1mpaJS3Dg8SKsYdXvqOCLNOLmNBCz1thhQIVnnMxRRR89Ikx/yntX62HcgfQkURcUAksEEi6Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774963973; c=relaxed/simple;
	bh=6cJag2KWWKrbIQPBgqW7xU/jNYZ1bufvG/sLviuFHwk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Hcx4AXFoSF30edjL76woNNDSMtWtdjiUFQFxJiXHomg0/OnWjziPI9mgDq8GRZ1kJMBYnbOy55z7sXOzGLTgeP28A84sMRrzuKqOnpijlGw9vHxmrmFRygaWs0chJ+SBi8qvZctPr1FRRnVuGJaR5fJCwdE/2xHNklQX0AhdxQg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PGZYLf1W; arc=pass smtp.client-ip=74.125.82.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dy1-f193.google.com with SMTP id 5a478bee46e88-2bdcf5970cdso3581858eec.0
        for <io-uring@vger.kernel.org>; Tue, 31 Mar 2026 06:32:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774963970; cv=none;
        d=google.com; s=arc-20240605;
        b=XE3Fajj2El0IjFjyxtMdCwtTH7dDJBdSutFOjuwlL/AtxHFptg2nnGPvw6wHLiwG0u
         /6m/i4D4gpA0c0p7q9cLDMwdsAIEfpsLlCqaS5lYlXBU2XI+CNPK8Ym4t/q0kiF3giTo
         7I5smJzpr9Qlkguy1Nb3OtNi3DoOiIwtWUOVm4WeiReqkVo15ab+1TUirijVaBjK7gEY
         MSUJ+jN15MAjgDE+vncSdh91frsF4eBnE4nbOMtajwRaHqL3MiZZx0RXGS6Pc9GxcdUF
         ocb1AE3SYmLTG3MGc8GaeiAjzscgR2R53GU6hWxVbY5vTbynQpwAxQipcXnTQ8AEBZ0H
         CbRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=gu+luKw5UUmknpEEn/Aw3CTxaxjdTTof2ifOnGB/XYg=;
        fh=WNWoUm0/l+2jiBiUkk3EDWDcJRMVLZhGb32vluMylvs=;
        b=iFoxgNlUyRBkrSn+/jCYvLGseAaT2+VMtWOB/zIeTZHBeRTVbmJrDfTZSgInt9QqU3
         e62zSYpthCg2K5xN4+pb4GhAIY9UxXuadbTZwBrG9M2FWXB/X2x4Q7EhKeSezvOserMG
         ENfS7FGSLdN13u08kAbgqh5iymmBGKiud4w9lEBK52YwfH945EOQGd9guOfgxXL4G3e9
         m4390HoaJgllAfDWQSK0c/vYtPTAZx1sVD9X7wm9+tKkb7xi6prITDQjgYMNi+HN97Yd
         5DydiKvJTZzHZVPwehvbtOd6wIC+PQl9d4plPIW7HZKO1LFQijw3+8W2bTaZ3ECvxv6u
         7QJA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774963970; x=1775568770; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gu+luKw5UUmknpEEn/Aw3CTxaxjdTTof2ifOnGB/XYg=;
        b=PGZYLf1W8Ri9Z1sIvCco58jCdXZ34jI1xKOFKcrXJCnaHKR8Bpmvdr3u5w53s2myMj
         YdBnCQZaBfD+Bcko9AFYcEUjpRUIW/x47EhucaKn+/aoGlI4Po9hMNBFpzwnQfgDgvIH
         +/9C9Y0uaMvkL8MlhF03+4Wqpf/v3b0Kd0TJtSDEaw+r5LRyNSmUdp3GA71/9IZdr3Aa
         MRpX2S/83AlGlXyESS0TMQTYMHkoy08IsLw965fXYiuwNu0TSQdUNHvpAGmEUFQckgJd
         M4L8ui/E/kc/9BwhvKOO71ONH1o+AXsh4REf1yuWAUD5Y6/Cwo/ByWQjWNzqSOE/goi5
         B8+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774963970; x=1775568770;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gu+luKw5UUmknpEEn/Aw3CTxaxjdTTof2ifOnGB/XYg=;
        b=T1rUYMel3/CcJVdZ3NXL9XDRvzWECEPFpRhA1z1vUCKc+xDsCZY5to21qil0+eaMqk
         tsIO6+vrkgTqoYoPMITlz+VAevzi3LFwqmsjWou+lmR9/w1Dpe3la1XBR6B8/dxe5FtN
         a86Ihz76MvFxhNf5u57C4BQATJfq2pUOT+4U7U+qXUg6vg+AcXRL1sLNK/e5x3pnBXsF
         Ur6OiEiAEzhMBZj0TUJmmdqiCSgy/CbZQngMAfxf5RjN7TOXuDgcSHSaTRbGP24YStqK
         mGMRyO+FO5TixnfL0h9JMVyQLWaykYiarAp6A4yn2SoeVSXG2hKMkcimrIpBDmEkxia7
         MPIw==
X-Gm-Message-State: AOJu0Yyb4wynrygePGungrwpGGZebY6r/J+eFWpIfmVKjJ/VbaCq7sqW
	ciEj8hGX5j9DUYNY9PPCq3YNStOkAoVOX6XtW2icKgFWebtkpvGH9niO+msz2PIWIDFFBfm2DKW
	kUsp967FIb2JsfTeqQRrmujovuzFxT2rw/L5r8idgwIKL7iE=
X-Gm-Gg: ATEYQzz1Fa/ASMtyVqCrQtIPmZrLuQt2vfpc5uh/7w+CDezdiPgFqfK2BS4IcieILi4
	7T/Dc/UPtPiHLxMdGuO+pARGPMTiX4P8b4nuw9A6amlLpXRriHqgQMvamU+5JXX8ffWSQseYUFo
	Y0neVyH3RoM6XcGH90FSCpaKSAtB7kxQFgmN73XsNB7XOH4BZip0G0/hNghEaBa5Y7VXLb8ctuX
	vjcx47jeK+w+fOs1/SXbyQPFtBm1wR3TMKNUeHMeYxK/hjiUXZzqGTw9m9z/o+8/WTqBqccT+xL
	gT2bzg==
X-Received: by 2002:a05:7301:6084:b0:2c5:704f:7142 with SMTP id
 5a478bee46e88-2c7bae4f73amr1602183eec.2.1774963970148; Tue, 31 Mar 2026
 06:32:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: antonius <bluedragonsec2023@gmail.com>
Date: Tue, 31 Mar 2026 20:32:32 +0700
X-Gm-Features: AQROBzCR1t1zyrk4A2yCWxZXSWuSYe-vDZwVLyMZZPkWU7Td1sF3idqTOXHC7zs
Message-ID: <CAK8a0jzF-zaO5ZmdOrmfuxrhXuKg5m5+RDuO7tNvtj=kUYbW7Q@mail.gmail.com>
Subject: =?UTF-8?Q?=5BBUG=5D_WARNING_in_io=5Fring=5Fexit=5Fwork_=28io=5Furing=2Ec=3A2187=29?=
	=?UTF-8?Q?_via_IORING=5FREGISTER=5FBPF=5FFILTER_=E2=80=94_confirmed_on_7=2E0=2Drc5_and?=
	=?UTF-8?Q?_rc6?=
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk, asml.silence@gmail.com, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: multipart/mixed; boundary="000000000000ee9778064e52009c"
X-Spamd-Result: default: False [2.04 / 15.00];
	MIME_BAD_ATTACHMENT(1.60)[c:text/x-csrc];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_BASE64_TEXT(0.10)[];
	MIME_GOOD(-0.10)[multipart/mixed,multipart/alternative,text/plain,text/x-csrc];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12895-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+,1:+,2:+,3:~,4:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[kernel.dk,gmail.com,vger.kernel.org,googlegroups.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_ATTACHMENT(0.00)[];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bluedragonsec2023@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[5];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid,bluedragonsec.com:email,bluedragonsec.com:url]
X-Rspamd-Queue-Id: 8A66736A5C7
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

--000000000000ee9778064e52009c
Content-Type: multipart/alternative; boundary="000000000000ee9776064e52009a"

--000000000000ee9776064e52009a
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

I am reporting a kernel WARNING discovered via Syzkaller fuzzing of Linux
7.0-rc5, targeting the new IORING_REGISTER_BPF_FILTER subsystem (new in
7.0).

The bug is confirmed on both 7.0-rc5 and 7.0-rc6. It is NOT fixed in rc6.
In rc6, the WARNING appears to have changed from WARN_ON to WARN_ON_ONCE
(fires only once per boot), which may explain why it was initially missed.

REPORTER
--------
Antonius / Blue Dragon Security
https://bluedragonsec.com
antonius@bluedragonsec.com

AFFECTED VERSIONS
-----------------
Confirmed: Linux 7.0.0-rc5 (QEMU, KASAN+KFENCE build, Syzkaller)
Confirmed: Linux 7.0.0-rc6 (QEMU, PREEMPT(lazy), PROVE_LOCKING build)
Not affected: kernels prior to 7.0 (IORING_REGISTER_BPF_FILTER is new in
7.0)
Status: NOT fixed in rc6

NOTE ON rc6 BEHAVIOR: The WARNING fires only once per boot in rc6
(WARN_ON_ONCE semantics), confirmed by:
  - trace hash "0000000000000000" in the dump
  - Silent on subsequent runs within same boot session
  - Fires again after reboot
Reset via: echo 0 > /sys/kernel/debug/clear_warn_once  (then retest)

CRASH OUTPUT =E2=80=94 rc6 (7.0.0-rc6, PREEMPT(lazy))
----------------------------------------------
  [ 1021.589216] ------------[ cut here ]------------
  [ 1021.589240] WARNING: io_uring/io_uring.c:2187
                 at io_ring_exit_work+0xbea/0xd4b, CPU#0: kworker/u4:1/14
  [ 1021.589298] CPU: 0 UID: 0 PID: 14 Comm: kworker/u4:1
                 Not tainted 7.0.0-rc6 #1 PREEMPT(lazy)
  [ 1021.589326] Workqueue: iou_exit io_ring_exit_work
  [ 1021.589346] RIP: 0010:io_ring_exit_work+0xbea/0xd4b
  [ 1021.589393] RAX: 0000000000000000 RBX: ffff88810e659778
  [ 1021.589432] R13: 0000000000000000 R14: ffff888115c64000
                 R15: dffffc0000000000
  [ 1021.589474] Call Trace:
  [ 1021.589487]   ? check_prev_add+0x333/0xd30    =E2=86=90 lockdep active
  [ 1021.589533]   ? __pfx_io_tctx_exit_cb+0x10/0x10
  [ 1021.589577]   process_one_work+0xa16/0x1900
  [ 1021.590019]   worker_thread+0x5eb/0xe50
  [ 1021.590084]   kthread+0x366/0x450
  [ 1021.590122]   ret_from_fork+0x660/0xa80
  [ 1021.590200]  </TASK>
  [ 1021.590280] ---[ end trace 0000000000000000 ]---

CRASH OUTPUT =E2=80=94 rc5 (7.0.0-rc5, PREEMPT(lazy), KASAN)
-----------------------------------------------------
  WARNING: io_uring/io_uring.c:2187
           at io_ring_exit_work+0xf84/0x1290
  Workqueue: iou_exit io_ring_exit_work
  R14: ffff88800c2e7000

COMPARISON rc5 vs rc6:
  - Bug location: IDENTICAL (io_uring.c:2187, same workqueue)
  - WARN type: rc5=3DWARN_ON (fires every time), rc6=3DWARN_ON_ONCE (once/b=
oot)
  - Function size: rc5=3D0x1290, rc6=3D0xd4b (refactoring occurred)
  - R14 non-null in both (ctx->bpf_filters still set during teardown)

REPRODUCER (3 syscalls, minimized by Syzkaller)
-----------------------------------------------
Requires: root / CAP_SYS_ADMIN

  # Step 1: Register BPF filter at task level (fd=3D-1)
  io_uring_register(-1, IORING_REGISTER_BPF_FILTER=3D0x25, &filter, 1)

  # Step 2: Create ring with DEFER_TASKRUN + R_DISABLED
  r0 =3D io_uring_setup(0x1bcf, {flags=3DIORING_SETUP_R_DISABLED|
       IORING_SETUP_SUBMIT_ALL|IORING_SETUP_SINGLE_ISSUER|
       IORING_SETUP_DEFER_TASKRUN, ...})

  # Step 3: Register restrictions (NULL arg)
  io_uring_register(r0, IORING_REGISTER_RESTRICTIONS=3D0xb, NULL, 2)

  # closing r0 triggers io_ring_exit_work =E2=86=92 WARNING at line 2187

BPF filter used: cmd_type=3D1, opcode=3D0x3d (BPF_JMP|BPF_JSET), flags=3D3,
  2 instructions: [{code=3D0x02,jt=3D0x26,jf=3D0x02,k=3D0},
{code=3D0x06,jt=3D0x5c,jf=3D0x06,k=3D5}]

Syzlang repro:
  io_uring_register$IORING_REGISTER_BPF_FILTER(0xffffffffffffffff, 0x25,
      &(0x7f0000002280)=3D{0x1, 0x0, 0x0, {0x3d, 0x3, 0x2, 0x0, '\x00',
      &(0x7f0000002300)=3D[{0x2, 0x26, 0x2}, {0x6, 0x5c, 0x6, 0x5}]}}, 0x1)
  r0 =3D io_uring_setup(0x1bcf, &(0x7f0000000000)=3D{0x8, 0x1, 0x30c0, 0x0,
      0x8000, 0x7, 0xffffffffffffffff, '\x00', ...})
  io_uring_register(r0, 0xb, 0x0, 0x2)

C reproducer attached.

REPRODUCE

sudo ./repro_io_ring_exit_work_loop


ANALYSIS
--------
The WARNING at io_uring.c:2187 fires inside io_ring_ctx_free() during ring
teardown via the iou_exit workqueue. Register R14 is non-null (pointing to
a live kernel object) at the WARN site in both rc5 and rc6, indicating that
ctx->bpf_filters is unexpectedly non-NULL when io_ring_ctx_free() asserts
it should be NULL.

Root cause hypothesis: When IORING_REGISTER_BPF_FILTER is called with
fd=3D-1 (task-level filter registration, new in Linux 7.0), and a ring is
subsequently created with IORING_SETUP_DEFER_TASKRUN, the ring inherits
the task-level BPF filter via
io_ctx_restriction_clone()/io_bpf_filter_clone().
During ring teardown in io_ring_ctx_free(), ctx->bpf_filters is not
properly nulled/freed, triggering the assertion.

The exact WARN_ON is in io_ring_ctx_free() at line 2187 =E2=80=94 likely
WARN_ON(ctx->bpf_filters) or similar check on the bpf_filters pointer.
The specific cleanup path in io_bpf_filter_clone() / io_bpf_filters_free()
interaction needs review.

CLASSIFICATION
--------------
CWE: CWE-459 (Incomplete Cleanup) =E2=80=94 ctx->bpf_filters not cleaned up
     properly on ring teardown when filter was inherited from task context
Impact: Memory leak (bpf_filters object leaked per ring close),
        assertion violation in io_ring_ctx_free()
Requires: root/CAP_SYS_ADMIN
No memory corruption (KASAN clean, no double-free detected)

DISCOVERY
---------
Found via Syzkaller fuzzing campaign targeting Linux 7.0-rc5 io_uring
BPF filter subsystem (Blue Dragon Security, March 2026).
No matching syzbot entry found for this specific call path
(IORING_REGISTER_BPF_FILTER with fd=3D-1 + DEFER_TASKRUN).

Reported-by: Antonius <antonius@bluedragonsec.com>
Blue Dragon Security =E2=80=94 https://bluedragonsec.com

--000000000000ee9776064e52009a
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello,<br><br>I am reporting a kernel WARNING discovered v=
ia Syzkaller fuzzing of Linux<br>7.0-rc5, targeting the new IORING_REGISTER=
_BPF_FILTER subsystem (new in 7.0).<br><br>The bug is confirmed on both 7.0=
-rc5 and 7.0-rc6. It is NOT fixed in rc6.<br>In rc6, the WARNING appears to=
 have changed from WARN_ON to WARN_ON_ONCE<br>(fires only once per boot), w=
hich may explain why it was initially missed.<br><br>REPORTER<br>--------<b=
r>Antonius / Blue Dragon Security<br><a href=3D"https://bluedragonsec.com">=
https://bluedragonsec.com</a><br><a href=3D"mailto:antonius@bluedragonsec.c=
om">antonius@bluedragonsec.com</a><br><br>AFFECTED VERSIONS<br>------------=
-----<br>Confirmed: Linux 7.0.0-rc5 (QEMU, KASAN+KFENCE build, Syzkaller)<b=
r>Confirmed: Linux 7.0.0-rc6 (QEMU, PREEMPT(lazy), PROVE_LOCKING build)<br>=
Not affected: kernels prior to 7.0 (IORING_REGISTER_BPF_FILTER is new in 7.=
0)<br>Status: NOT fixed in rc6<br><br>NOTE ON rc6 BEHAVIOR: The WARNING fir=
es only once per boot in rc6<br>(WARN_ON_ONCE semantics), confirmed by:<br>=
=C2=A0 - trace hash &quot;0000000000000000&quot; in the dump<br>=C2=A0 - Si=
lent on subsequent runs within same boot session<br>=C2=A0 - Fires again af=
ter reboot<br>Reset via: echo 0 &gt; /sys/kernel/debug/clear_warn_once =C2=
=A0(then retest)<br><br>CRASH OUTPUT =E2=80=94 rc6 (7.0.0-rc6, PREEMPT(lazy=
))<br>----------------------------------------------<br>=C2=A0 [ 1021.58921=
6] ------------[ cut here ]------------<br>=C2=A0 [ 1021.589240] WARNING: i=
o_uring/io_uring.c:2187<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0at io_ring_exit_work+0xbea/0xd4b, CPU#0: kworker/u4:1/14<br>=
=C2=A0 [ 1021.589298] CPU: 0 UID: 0 PID: 14 Comm: kworker/u4:1<br>=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Not tainted 7.0.0-rc=
6 #1 PREEMPT(lazy)<br>=C2=A0 [ 1021.589326] Workqueue: iou_exit io_ring_exi=
t_work<br>=C2=A0 [ 1021.589346] RIP: 0010:io_ring_exit_work+0xbea/0xd4b<br>=
=C2=A0 [ 1021.589393] RAX: 0000000000000000 RBX: ffff88810e659778<br>=C2=A0=
 [ 1021.589432] R13: 0000000000000000 R14: ffff888115c64000<br>=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0R15: dffffc0000000000<b=
r>=C2=A0 [ 1021.589474] Call Trace:<br>=C2=A0 [ 1021.589487] =C2=A0 ? check=
_prev_add+0x333/0xd30 =C2=A0 =C2=A0=E2=86=90 lockdep active<br>=C2=A0 [ 102=
1.589533] =C2=A0 ? __pfx_io_tctx_exit_cb+0x10/0x10<br>=C2=A0 [ 1021.589577]=
 =C2=A0 process_one_work+0xa16/0x1900<br>=C2=A0 [ 1021.590019] =C2=A0 worke=
r_thread+0x5eb/0xe50<br>=C2=A0 [ 1021.590084] =C2=A0 kthread+0x366/0x450<br=
>=C2=A0 [ 1021.590122] =C2=A0 ret_from_fork+0x660/0xa80<br>=C2=A0 [ 1021.59=
0200] =C2=A0&lt;/TASK&gt;<br>=C2=A0 [ 1021.590280] ---[ end trace 000000000=
0000000 ]---<br><br>CRASH OUTPUT =E2=80=94 rc5 (7.0.0-rc5, PREEMPT(lazy), K=
ASAN)<br>-----------------------------------------------------<br>=C2=A0 WA=
RNING: io_uring/io_uring.c:2187<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0at io_ring_exit_work+0xf84/0x1290<br>=C2=A0 Workqueue: iou_exit io_ring_=
exit_work<br>=C2=A0 R14: ffff88800c2e7000<br><br>COMPARISON rc5 vs rc6:<br>=
=C2=A0 - Bug location: IDENTICAL (io_uring.c:2187, same workqueue)<br>=C2=
=A0 - WARN type: rc5=3DWARN_ON (fires every time), rc6=3DWARN_ON_ONCE (once=
/boot)<br>=C2=A0 - Function size: rc5=3D0x1290, rc6=3D0xd4b (refactoring oc=
curred)<br>=C2=A0 - R14 non-null in both (ctx-&gt;bpf_filters still set dur=
ing teardown)<br><br>REPRODUCER (3 syscalls, minimized by Syzkaller)<br>---=
--------------------------------------------<br>Requires: root / CAP_SYS_AD=
MIN<br><br>=C2=A0 # Step 1: Register BPF filter at task level (fd=3D-1)<br>=
=C2=A0 io_uring_register(-1, IORING_REGISTER_BPF_FILTER=3D0x25, &amp;filter=
, 1)<br><br>=C2=A0 # Step 2: Create ring with DEFER_TASKRUN + R_DISABLED<br=
>=C2=A0 r0 =3D io_uring_setup(0x1bcf, {flags=3DIORING_SETUP_R_DISABLED|<br>=
=C2=A0 =C2=A0 =C2=A0 =C2=A0IORING_SETUP_SUBMIT_ALL|IORING_SETUP_SINGLE_ISSU=
ER|<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0IORING_SETUP_DEFER_TASKRUN, ...})<br><br>=
=C2=A0 # Step 3: Register restrictions (NULL arg)<br>=C2=A0 io_uring_regist=
er(r0, IORING_REGISTER_RESTRICTIONS=3D0xb, NULL, 2)<br><br>=C2=A0 # closing=
 r0 triggers io_ring_exit_work =E2=86=92 WARNING at line 2187<br><br>BPF fi=
lter used: cmd_type=3D1, opcode=3D0x3d (BPF_JMP|BPF_JSET), flags=3D3,<br>=
=C2=A0 2 instructions: [{code=3D0x02,jt=3D0x26,jf=3D0x02,k=3D0}, {code=3D0x=
06,jt=3D0x5c,jf=3D0x06,k=3D5}]<br><br>Syzlang repro:<br>=C2=A0 io_uring_reg=
ister$IORING_REGISTER_BPF_FILTER(0xffffffffffffffff, 0x25,<br>=C2=A0 =C2=A0=
 =C2=A0 &amp;(0x7f0000002280)=3D{0x1, 0x0, 0x0, {0x3d, 0x3, 0x2, 0x0, &#39;=
\x00&#39;,<br>=C2=A0 =C2=A0 =C2=A0 &amp;(0x7f0000002300)=3D[{0x2, 0x26, 0x2=
}, {0x6, 0x5c, 0x6, 0x5}]}}, 0x1)<br>=C2=A0 r0 =3D io_uring_setup(0x1bcf, &=
amp;(0x7f0000000000)=3D{0x8, 0x1, 0x30c0, 0x0,<br>=C2=A0 =C2=A0 =C2=A0 0x80=
00, 0x7, 0xffffffffffffffff, &#39;\x00&#39;, ...})<br>=C2=A0 io_uring_regis=
ter(r0, 0xb, 0x0, 0x2)<br><br><div>C reproducer attached.</div><div><br></d=
iv><div>REPRODUCE=C2=A0</div><div><br></div><div>sudo ./repro_io_ring_exit_=
work_loop</div><div><br></div><div></div><div><br></div><div>ANALYSIS</div>=
--------<br>The WARNING at io_uring.c:2187 fires inside io_ring_ctx_free() =
during ring<br>teardown via the iou_exit workqueue. Register R14 is non-nul=
l (pointing to<br>a live kernel object) at the WARN site in both rc5 and rc=
6, indicating that<br>ctx-&gt;bpf_filters is unexpectedly non-NULL when io_=
ring_ctx_free() asserts<br>it should be NULL.<br><br>Root cause hypothesis:=
 When IORING_REGISTER_BPF_FILTER is called with<br>fd=3D-1 (task-level filt=
er registration, new in Linux 7.0), and a ring is<br>subsequently created w=
ith IORING_SETUP_DEFER_TASKRUN, the ring inherits<br>the task-level BPF fil=
ter via io_ctx_restriction_clone()/io_bpf_filter_clone().<br>During ring te=
ardown in io_ring_ctx_free(), ctx-&gt;bpf_filters is not<br>properly nulled=
/freed, triggering the assertion.<br><br>The exact WARN_ON is in io_ring_ct=
x_free() at line 2187 =E2=80=94 likely<br>WARN_ON(ctx-&gt;bpf_filters) or s=
imilar check on the bpf_filters pointer.<br>The specific cleanup path in io=
_bpf_filter_clone() / io_bpf_filters_free()<br>interaction needs review.<br=
><br>CLASSIFICATION<br>--------------<br>CWE: CWE-459 (Incomplete Cleanup) =
=E2=80=94 ctx-&gt;bpf_filters not cleaned up<br>=C2=A0 =C2=A0 =C2=A0properl=
y on ring teardown when filter was inherited from task context<br>Impact: M=
emory leak (bpf_filters object leaked per ring close),<br>=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 assertion violation in io_ring_ctx_free()<br>Requires: root/CAP_=
SYS_ADMIN<br>No memory corruption (KASAN clean, no double-free detected)<br=
><br>DISCOVERY<br>---------<br>Found via Syzkaller fuzzing campaign targeti=
ng Linux 7.0-rc5 io_uring<br>BPF filter subsystem (Blue Dragon Security, Ma=
rch 2026).<br>No matching syzbot entry found for this specific call path<br=
>(IORING_REGISTER_BPF_FILTER with fd=3D-1 + DEFER_TASKRUN).<br><br>Reported=
-by: Antonius &lt;<a href=3D"mailto:antonius@bluedragonsec.com">antonius@bl=
uedragonsec.com</a>&gt;<br>Blue Dragon Security =E2=80=94 <a href=3D"https:=
//bluedragonsec.com">https://bluedragonsec.com</a><br><br></div>

--000000000000ee9776064e52009a--
--000000000000ee9778064e52009c
Content-Type: text/x-csrc; charset="US-ASCII"; name="repro_io_ring_exit_work_loop.c"
Content-Disposition: attachment; filename="repro_io_ring_exit_work_loop.c"
Content-Transfer-Encoding: base64
Content-ID: <f_mnenlt7m0>
X-Attachment-Id: f_mnenlt7m0

LyoKICogUmVwcm9kdWNlciB2MiAobG9vcCBtb2RlKTogV0FSTklORyBpbiBpb19yaW5nX2V4aXRf
d29yawogKiAKICogVW50dWsgbWVtdWRhaGthbiB0cmlnZ2VyaW5nIGJ1ZyBkaSBsYWI6CiAqIEph
bGFua2FuIGxvb3AgdW50dWsgbWVuaW5na2F0a2FuIHByb2JhYmlsaXRhcyB0cmlnZ2VyLgogKiAK
ICogRGlzY292ZXJlZCBieTogQW50b25pdXMgPGFudG9uaXVzQGJsdWVkcmFnb25zZWMuY29tPgog
KiBCbHVlIERyYWdvbiBTZWN1cml0eSAtIGJsdWVkcmFnb25zZWMuY29tCiAqCiAqIENvbXBpbGU6
IGdjYyAtbyByZXBybzIgcmVwcm9faW9fcmluZ19leGl0X3dvcmtfbG9vcC5jCiAqIFJ1bjogICAg
IC4vcmVwcm8yCiAqLwoKI2RlZmluZSBfR05VX1NPVVJDRQojaW5jbHVkZSA8c3RkaW8uaD4KI2lu
Y2x1ZGUgPHN0ZGxpYi5oPgojaW5jbHVkZSA8c3RyaW5nLmg+CiNpbmNsdWRlIDxzdGRpbnQuaD4K
I2luY2x1ZGUgPHVuaXN0ZC5oPgojaW5jbHVkZSA8c3lzL3N5c2NhbGwuaD4KI2luY2x1ZGUgPHN5
cy90eXBlcy5oPgojaW5jbHVkZSA8ZXJybm8uaD4KCiNpZm5kZWYgX19OUl9pb191cmluZ19zZXR1
cAojZGVmaW5lIF9fTlJfaW9fdXJpbmdfc2V0dXAgICAgNDI1CiNlbmRpZgojaWZuZGVmIF9fTlJf
aW9fdXJpbmdfcmVnaXN0ZXIKI2RlZmluZSBfX05SX2lvX3VyaW5nX3JlZ2lzdGVyIDQyNwojZW5k
aWYKCiNkZWZpbmUgSU9SSU5HX1NFVFVQX1JfRElTQUJMRUQgICAgICAoMVUgPDwgNikKI2RlZmlu
ZSBJT1JJTkdfU0VUVVBfU1VCTUlUX0FMTCAgICAgICgxVSA8PCA3KQojZGVmaW5lIElPUklOR19T
RVRVUF9TSU5HTEVfSVNTVUVSICAgKDFVIDw8IDEyKQojZGVmaW5lIElPUklOR19TRVRVUF9ERUZF
Ul9UQVNLUlVOICAgKDFVIDw8IDEzKQojZGVmaW5lIElPUklOR19SRUdJU1RFUl9SRVNUUklDVElP
TlMgMTEKI2RlZmluZSBJT1JJTkdfUkVHSVNURVJfQlBGX0ZJTFRFUiAgIDM3CgpzdHJ1Y3QgaW9f
dXJpbmdfcGFyYW1zIHsKICAgIHVpbnQzMl90IHNxX2VudHJpZXM7CiAgICB1aW50MzJfdCBjcV9l
bnRyaWVzOwogICAgdWludDMyX3QgZmxhZ3M7CiAgICB1aW50MzJfdCBzcV90aHJlYWRfY3B1Owog
ICAgdWludDMyX3Qgc3FfdGhyZWFkX2lkbGU7CiAgICB1aW50MzJfdCBmZWF0dXJlczsKICAgIHVp
bnQzMl90IHdxX2ZkOwogICAgdWludDhfdCAgcGFkWzg0XTsKfTsKCnN0cnVjdCBzb2NrX2ZpbHRl
cl9pbnNuIHsgdWludDE2X3QgY29kZTsgdWludDhfdCBqdCwgamY7IHVpbnQzMl90IGs7IH07Cgpz
dHJ1Y3QgaW9fdXJpbmdfYnBmX3JlZyB7CiAgICB1aW50MTZfdCBjbWRfdHlwZTsKICAgIHVpbnQx
Nl90IGNtZF9mbGFnczsKICAgIHVpbnQzMl90IHJlc3Y7CiAgICB1aW50MzJfdCBvcGNvZGU7CiAg
ICB1aW50MzJfdCBmbGFnczsKICAgIHVpbnQzMl90IGZpbHRlcl9sZW47CiAgICB1aW50OF90ICBw
ZHVfc2l6ZTsKICAgIHVpbnQ4X3QgIHJlc3YyWzNdOwogICAgdWludDY0X3QgZmlsdGVyX3B0cjsK
ICAgIHVpbnQ4X3QgIHJlc3YzWzQwXTsKfTsKCmludCBtYWluKHZvaWQpCnsKICAgIHN0cnVjdCBz
b2NrX2ZpbHRlcl9pbnNuIGluc25zWzJdID0gewogICAgICAgIHsweDAyLCAweDI2LCAweDAyLCAw
eDAwMDAwMDAwfSwKICAgICAgICB7MHgwNiwgMHg1YywgMHgwNiwgMHgwMDAwMDAwNX0sCiAgICB9
OwoKICAgIHN0cnVjdCBpb191cmluZ19icGZfcmVnIGJwZl9yZWcgPSB7CiAgICAgICAgLmNtZF90
eXBlICAgPSAxLAogICAgICAgIC5jbWRfZmxhZ3MgID0gMCwKICAgICAgICAucmVzdiAgICAgICA9
IDAsCiAgICAgICAgLm9wY29kZSAgICAgPSAweDNkLAogICAgICAgIC5mbGFncyAgICAgID0gMHgz
LAogICAgICAgIC5maWx0ZXJfbGVuID0gMiwKICAgICAgICAucGR1X3NpemUgICA9IDAsCiAgICAg
ICAgLmZpbHRlcl9wdHIgPSAodWludDY0X3QpKHVpbnRwdHJfdClpbnNucywKICAgIH07CiAgICBt
ZW1zZXQoYnBmX3JlZy5yZXN2MywgMCwgc2l6ZW9mKGJwZl9yZWcucmVzdjMpKTsKCiAgICBwcmlu
dGYoIlsqXSBpb19yaW5nX2V4aXRfd29yayByZXByb2R1Y2VyIChsb29wIG1vZGUpXG4iKTsKICAg
IHByaW50ZigiWypdIEl0ZXJhdGluZyB0byB0cmlnZ2VyIGFzeW5jIFdBUk5JTkcgaW4gd29ya3F1
ZXVlLi4uXG5cbiIpOwoKICAgIGZvciAoaW50IGkgPSAwOyBpIDwgMTA7IGkrKykgewogICAgICAg
IC8qIFN0ZXAgMTogQlBGX0ZJTFRFUiB3aXRoIGZkPS0xICovCiAgICAgICAgc3lzY2FsbChfX05S
X2lvX3VyaW5nX3JlZ2lzdGVyLCAobG9uZyktMSwgSU9SSU5HX1JFR0lTVEVSX0JQRl9GSUxURVIs
CiAgICAgICAgICAgICAgICAmYnBmX3JlZywgMSk7CgogICAgICAgIC8qIFN0ZXAgMjogaW9fdXJp
bmdfc2V0dXAgd2l0aCBERUZFUl9UQVNLUlVOIHwgUl9ESVNBQkxFRCAqLwogICAgICAgIHN0cnVj
dCBpb191cmluZ19wYXJhbXMgcCA9IHsKICAgICAgICAgICAgLnNxX2VudHJpZXMgICAgPSA4LAog
ICAgICAgICAgICAuY3FfZW50cmllcyAgICA9IDEsCiAgICAgICAgICAgIC5mbGFncyAgICAgICAg
ID0gSU9SSU5HX1NFVFVQX1JfRElTQUJMRUQgfCBJT1JJTkdfU0VUVVBfU1VCTUlUX0FMTCB8CiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgSU9SSU5HX1NFVFVQX1NJTkdMRV9JU1NVRVIgfCBJ
T1JJTkdfU0VUVVBfREVGRVJfVEFTS1JVTiwKICAgICAgICAgICAgLnNxX3RocmVhZF9pZGxlID0g
MHg4MDAwLAogICAgICAgICAgICAuZmVhdHVyZXMgICAgICA9IDcsCiAgICAgICAgICAgIC53cV9m
ZCAgICAgICAgID0gKHVpbnQzMl90KS0xLAogICAgICAgIH07CiAgICAgICAgaW50IGZkID0gKGlu
dClzeXNjYWxsKF9fTlJfaW9fdXJpbmdfc2V0dXAsIDB4MWJjZiwgJnApOwogICAgICAgIHByaW50
ZigiW2l0ZXIgJTJkXSBpb191cmluZ19zZXR1cCBmZD0lZFxuIiwgaSwgZmQpOwoKICAgICAgICBp
ZiAoZmQgPj0gMCkgewogICAgICAgICAgICAvKiBTdGVwIDM6IFJFU1RSSUNUSU9OUyB3aXRoIE5V
TEwgLSB0cmlnZ2VycyBpbmNvbnNpc3RlbmN5ICovCiAgICAgICAgICAgIHN5c2NhbGwoX19OUl9p
b191cmluZ19yZWdpc3RlciwgZmQsIElPUklOR19SRUdJU1RFUl9SRVNUUklDVElPTlMsIDAsIDIp
OwogICAgICAgICAgICAvKiBDbG9zZSB0cmlnZ2VycyBpb19yaW5nX2V4aXRfd29yayB3b3JrcXVl
dWUgKi8KICAgICAgICAgICAgY2xvc2UoZmQpOwogICAgICAgIH0KCiAgICAgICAgdXNsZWVwKDEw
MDAwMCk7IC8qIDEwMG1zIC0gbGV0IHdvcmtxdWV1ZSBwcm9jZXNzICovCiAgICB9CgogICAgcHJp
bnRmKCJcblsqXSBDaGVjayBkbWVzZyBmb3I6IFdBUk5JTkcgYXQgaW9fdXJpbmcvaW9fdXJpbmcu
YzoyMTg3XG4iKTsKICAgIHByaW50ZigiWypdIFdvcmtxdWV1ZTogaW91X2V4aXQgaW9fcmluZ19l
eGl0X3dvcmtcbiIpOwogICAgcmV0dXJuIDA7Cn0K
--000000000000ee9778064e52009c--

