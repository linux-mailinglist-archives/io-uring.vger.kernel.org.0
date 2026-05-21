Return-Path: <io-uring+bounces-13475-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iDwYKHexDmr6AwYAu9opvQ
	(envelope-from <io-uring+bounces-13475-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 21 May 2026 09:17:11 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F2F1D59FF85
	for <lists+io-uring@lfdr.de>; Thu, 21 May 2026 09:17:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3D01B306F1A8
	for <lists+io-uring@lfdr.de>; Thu, 21 May 2026 07:14:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76A5F383991;
	Thu, 21 May 2026 07:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="q8W/AIMj"
X-Original-To: io-uring@vger.kernel.org
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DF837A4B8
	for <io-uring@vger.kernel.org>; Thu, 21 May 2026 07:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779347698; cv=none; b=LR9G27oyhlYWtpQ7D0VYTgazBIjY69htXy4+T3Cw7wh/8MbeC4Xfhd/XGI6StCi698Z9GFIZe3sZSrf5UcYRitxaoD+dc5tICAEpwa5mx2v8CvSfIJtW6a+yt/HTjcO/6l1FdThA9urT9v2rOprG9HLu1aMPu2ciwhfWXbMmDaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779347698; c=relaxed/simple;
	bh=vQ6hPTS68OS3nX2v8Rw/7yWV2oNe2570m1cKTrx/Hfs=;
	h=To:Cc:Subject:Mime-Version:References:In-Reply-To:Message-Id:From:
	 Content-Type:Date; b=CqBqDDMp1VG1GCsUoliYhvlp5A6pKUoHECBXO5cRNa7hlpfa4b0M1Y5BM596geMRqHhSsEuSD6ozpgn4oN3bEh6mgj5IFjTAazlwv4L054JtA8q42JHQ00u0SiaU6umG8ASIBv9nOww1zod4m20wCar9Xgh5WV4z2KGAlmSa8o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=q8W/AIMj; arc=none smtp.client-ip=209.127.230.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1779347690; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=vQ6hPTS68OS3nX2v8Rw/7yWV2oNe2570m1cKTrx/Hfs=;
 b=q8W/AIMjRbfR5x8HIN8Ys2BzrArgLVYG0v6q43ALtWYV3Vfka3C2lcpBEn/86GhoNkkWcG
 4eDUIaWPRKf6Bzh2RScz0YhMBz0/s0VZcQEcUD6yRWJ/0Wfak/O2lr1y/hcn5Ju8k+qb3s
 OXSMuDWBZNljhiIYGcAQIHS1Ls/gWrsB45JVnlXt1+EhFVheAVgJdVvZML9NlsrZwsp/UM
 dxtHnLKJlJommllP6ceK4QN9p/8S5saWlC37KWAKuo0MOwhtRt5awBBjE+g/teMt2lqN4e
 xtOSzjxLMCkwJC6psVUB0//eCHjF7I1CVUisEbJFtkphLxU/gt6kXOJGb5olPQ==
To: "Gabriel Krisman Bertazi" <krisman@suse.de>
Cc: <axboe@kernel.dk>, <io-uring@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <peterz@infradead.org>, 
	<rostedt@goodmis.org>
Subject: Re: [PATCH] io_uring/io-wq: avoid repeated task_work scans during teardown
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+16a0eb0e8+bc9c1c+vger.kernel.org+changfengnan@bytedance.com>
References: <20260520031221.83210-1-changfengnan@bytedance.com>
	<87wlwynqkb.fsf@mailhost.krisman.be>
In-Reply-To: <87wlwynqkb.fsf@mailhost.krisman.be>
Message-Id: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.dd07dd75.597d.4fe1.9704.f241d9f3e7f5@bytedance.com>
From: "changfengnan" <changfengnan@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 21 May 2026 15:14:44 +0800
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[bytedance.com,quarantine];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[bytedance.com:s=2212171451];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13475-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[bytedance.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[changfengnan@bytedance.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,suse.de:email,infradead.org:email,kernel.dk:email]
X-Rspamd-Queue-Id: F2F1D59FF85
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr


> From: "Gabriel Krisman Bertazi"<krisman@suse.de>
> Date:=C2=A0 Wed, May 20, 2026, 21:45
> Subject:=C2=A0 Re: [PATCH] io_uring/io-wq: avoid repeated task_work scans=
 during teardown
> To: "Fengnan Chang"<changfengnan@bytedance.com>
> Cc: <axboe@kernel.dk>, <io-uring@vger.kernel.org>, <linux-kernel@vger.ker=
nel.org>, <peterz@infradead.org>, <rostedt@goodmis.org>
> "Fengnan Chang" <changfengnan@bytedance.com> writes:
>=C2=A0
> > We hit hard-lockup reports from iou-wrk threads stuck in
>=C2=A0
> It seems like a soft-lockup instead no? =C2=A0From your description,
> eventually it solves itself, the task is just uninterruptible while
> contending on the spinlock.
hard-lockup, here is the log:

May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229430][=C2=A0 C138] watch=
dog: CPU138: Watchdog detected hard LOCKUP on cpu 138
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229435][=C2=A0 C138] Modul=
es linked in: binfmt_misc(E) msr(E) nft_compat(E) x_tables(E) ip_set_hash_n=
et(E) ip_set(E) nf_tables(E) nfnetlink(E) bonding(E) i10nm_edac(E) skx_edac=
_common(E) nfit(E) edac_core(E) intel_rapl_msr(E) intel_rapl_common(E) inte=
l_uncore_frequency(E) intel_uncore_frequency_common(E) x86_pkg_temp_thermal=
(E) intel_powerclamp(E) coretemp(E) btrfs(E) ast(E) qat_4xxx(E) snd_pcm(E) =
kvm_intel(E) drm_client_lib(E) libblake2b(E) tpm_tis(E) snd_timer(E) drm_sh=
mem_helper(E) tpm_tis_core(E) intel_qat(E) snd(E) cxl_acpi(E) pmt_telemetry=
(E) kvm(E) crc8(E) drm_kms_helper(E) iTCO_wdt(E) tpm(E) raid6_pq(E) cxl_pme=
m(E) soundcore(E) isst_if_mmio(E) pmt_discovery(E) isst_if_mbox_pci(E) auth=
enc(E) irqbypass(E) aesni_intel(E) gf128mul(E) rapl(E) intel_cstate(E) inte=
l_uncore(E) libnvdimm(E) mei_me(E) pmt_class(E) rng_core(E) dax_hmem(E) pcs=
pkr(E) efi_pstore(E) drm(E) zstd_compress(E) xor(E) i2c_i801(E) idxd(E) bnx=
t_en(E) mei(E) isst_if_common(E) intel_vsec(E) idxd_bus(E) i2c_smbus(E) i2c=
_ismt(E) wmi(E) aead(E) i2c_algo_bit(E)
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229527][=C2=A0 C138]=C2=A0=
 acpi_power_meter(E) button(E) joydev(E) evdev(E) hid_generic(E) usbhid(E) =
hid(E) acpi_ipmi(E) ipmi_si(E) ipmi_devintf(E) ipmi_msghandler(E) efivarfs(=
E) autofs4(E) xhci_pci(E) xhci_hcd(E) nvme(E) usbcore(E) usb_common(E) nvme=
_core(E)
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229553][=C2=A0 C138] irq e=
vent stamp: 47578
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229555][=C2=A0 C138] hardi=
rqs last=C2=A0 enabled at (47577): [<ffffffffa4c49fc9>] _raw_spin_unlock_ir=
qrestore+0x39/0x60
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229561][=C2=A0 C138] hardi=
rqs last disabled at (47578): [<ffffffffa4c49cd7>] _raw_spin_lock_irqsave+0=
x67/0x70
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229566][=C2=A0 C138] softi=
rqs last=C2=A0 enabled at (45744): [<ffffffffa21f88c7>] handle_softirqs+0x5=
77/0x840
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229571][=C2=A0 C138] softi=
rqs last disabled at (45739): [<ffffffffa21f9726>] irq_exit_rcu+0xe6/0x280
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229576][=C2=A0 C138] CPU: =
138 UID: 0 PID: 34918 Comm: iowq-exit-stres Kdump: loaded Tainted: G S =C2=
=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 EL =C2=A0 =C2=A0=C2=A0 7.1.0-rc3-debug-iomap=
+ #99 PREEMPT(lazy)=C2=A0
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229583][=C2=A0 C138] Taint=
ed: [S]=3DCPU_OUT_OF_SPEC, [E]=3DUNSIGNED_MODULE, [L]=3DSOFTLOCKUP
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229585][=C2=A0 C138] Hardw=
are name: Inventec G220-B6/Yichun MLB, BIOS 03.01.02.04.02 10/30/2023
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229587][=C2=A0 C138] RIP: =
0010:native_queued_spin_lock_slowpath+0x55d/0xc90
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229592][=C2=A0 C138] Code:=
 c0 75 3f 48 8b 8d 30 ff ff ff 48 b8 00 00 00 00 00 fc ff df 48 89 ca 83 e1=
 07 48 c1 ea 03 49 89 cd 48 01 c2 41 83 c5 03 f3 90 <0f> b6 02 41 38 c5 7c =
08 84 c0 0f 85 9c 05 00 00 41 8b 47 08 85 c0
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229596][=C2=A0 C138] RSP: =
0018:ff110085599f7598 EFLAGS: 00000046
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229599][=C2=A0 C138] RAX: =
0000000000000000 RBX: ff110085599f7658 RCX: 0000000000000000
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229602][=C2=A0 C138] RDX: =
ffe21c0bcffe7ab9 RSI: 1ffffffff4b0d54e RDI: ffffffffa586aa70
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229604][=C2=A0 C138] RBP: =
ff110085599f7680 R08: ffe21c10ab340157 R09: ffe21c10ab340157
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229607][=C2=A0 C138] R10: =
ffe21c10ab340156 R11: ff11008559a00ab3 R12: 00000000022c0000
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229610][=C2=A0 C138] R13: =
0000000000000003 R14: ff11008559a00ab0 R15: ff11005e7ff3d5c0
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229613][=C2=A0 C138] FS:=
=C2=A0 00007fa81d48e500(0000) GS:ff11005ed9544000(0000) knlGS:0000000000000=
000
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229615][=C2=A0 C138] CS:=
=C2=A0 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229618][=C2=A0 C138] CR2: =
0000000032f88000 CR3: 0000008432d9f003 CR4: 0000000000f73ef0
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229621][=C2=A0 C138] PKRU:=
 55555554
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229622][=C2=A0 C138] Call =
Trace:
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229624][=C2=A0 C138]=C2=A0=
 <TASK>
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229627][=C2=A0 C138]=C2=A0=
 ? __pfx_native_queued_spin_lock_slowpath+0x10/0x10
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229632][=C2=A0 C138]=C2=A0=
 ? ring_buffer_unlock_commit+0x130/0x570
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229638][=C2=A0 C138]=C2=A0=
 ? io_worker_cancel_cb+0x100/0x100
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229647][=C2=A0 C138]=C2=A0=
 do_raw_spin_lock+0x1e5/0x2a0
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229652][=C2=A0 C138]=C2=A0=
 ? __pfx_do_raw_spin_lock+0x10/0x10
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229656][=C2=A0 C138]=C2=A0=
 ? __pfx_function_trace_call+0x10/0x10
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229661][=C2=A0 C138]=C2=A0=
 ? _raw_spin_lock_irqsave+0x67/0x70
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229666][=C2=A0 C138]=C2=A0=
 ? __pfx_io_task_work_match+0x10/0x10
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229671][=C2=A0 C138]=C2=A0=
 _raw_spin_lock_irqsave+0x52/0x70
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229674][=C2=A0 C138]=C2=A0=
 ? task_work_cancel_match+0xf4/0x260
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229680][=C2=A0 C138]=C2=A0=
 task_work_cancel_match+0xf4/0x260
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229686][=C2=A0 C138]=C2=A0=
 ? __pfx_task_work_cancel_match+0x10/0x10
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229691][=C2=A0 C138]=C2=A0=
 ? __pfx_io_task_work_match+0x10/0x10
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229696][=C2=A0 C138]=C2=A0=
 ? task_work_cancel_match+0x9/0x260
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229700][=C2=A0 C138]=C2=A0=
 ? find_held_lock+0x35/0xb0
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229707][=C2=A0 C138]=C2=A0=
 io_wq_cancel_tw_create+0x82/0xc0
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229713][=C2=A0 C138]=C2=A0=
 io_wq_put_and_exit+0xdd/0x770
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229717][=C2=A0 C138]=C2=A0=
 ? xa_find_after+0x1c1/0x330
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229723][=C2=A0 C138]=C2=A0=
 ? __pfx_io_wq_put_and_exit+0x10/0x10
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229729][=C2=A0 C138]=C2=A0=
 ? io_uring_del_tctx_node+0x2ce/0x3c0
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229737][=C2=A0 C138]=C2=A0=
 io_uring_clean_tctx+0x125/0x1b0
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229742][=C2=A0 C138]=C2=A0=
 ? __pfx_io_uring_clean_tctx+0x10/0x10
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229746][=C2=A0 C138]=C2=A0=
 ? lock_is_held_type+0xa7/0x120
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229751][=C2=A0 C138]=C2=A0=
 ? __kasan_check_write+0x18/0x20
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229758][=C2=A0 C138]=C2=A0=
 io_uring_cancel_generic+0x5cb/0xe70
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229764][=C2=A0 C138]=C2=A0=
 ? __lock_acquire+0xc71/0x1ea0
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229769][=C2=A0 C138]=C2=A0=
 ? __pfx_io_uring_cancel_generic+0x10/0x10
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229776][=C2=A0 C138]=C2=A0=
 ? __kasan_check_write+0x18/0x20
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229780][=C2=A0 C138]=C2=A0=
 ? do_raw_spin_lock+0x130/0x2a0
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229785][=C2=A0 C138]=C2=A0=
 ? __pfx_autoremove_wake_function+0x10/0x10
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229791][=C2=A0 C138]=C2=A0=
 ? _raw_spin_unlock_irq+0x2b/0x50
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229794][=C2=A0 C138]=C2=A0=
 ? trace_hardirqs_on+0x2e/0x1a0
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229800][=C2=A0 C138]=C2=A0=
 __io_uring_cancel+0x1f/0x30
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229804][=C2=A0 C138]=C2=A0=
 do_exit+0x366/0x34e0
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229810][=C2=A0 C138]=C2=A0=
 ? lock_is_held_type+0xa7/0x120
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229814][=C2=A0 C138]=C2=A0=
 ? lock_is_held_type+0xa7/0x120
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229819][=C2=A0 C138]=C2=A0=
 ? __pfx_do_exit+0x10/0x10
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229824][=C2=A0 C138]=C2=A0=
 ? _raw_spin_unlock_irq+0x2b/0x50
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229827][=C2=A0 C138]=C2=A0=
 ? trace_hardirqs_on+0x2e/0x1a0
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229831][=C2=A0 C138]=C2=A0=
 ? __kasan_check_read+0x15/0x20
May 19 11:20:41 n154-134-017 kernel: [=C2=A0 672.229837][=C2=A0 C138]=C2=A0=
 do_group_exit+0xbf/0x260
>=C2=A0
> > + */
> > +struct callback_head *
> > +task_work_cancel_match_all(struct task_struct *task,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 bool (*match)(struct callback_head *, void *data),
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 void *data)
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct callback_head **pprev =3D &task->ta=
sk_works;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct callback_head *work, *next;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct callback_head *head =3D NULL, **tai=
l =3D &head;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long flags;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (likely(!task_work_pending(task)))
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0raw_spin_lock_irqsave(&task->pi_lock, flag=
s);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0work =3D READ_ONCE(*pprev);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0while (work && work !=3D &work_exited) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0next =3D READ_=
ONCE(work->next);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!match(wor=
k, data)) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0pprev =3D &work->next;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0work =3D next;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0continue;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!try_cmpxc=
hg(pprev, &work, next))
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0continue;
>=C2=A0
>=C2=A0
> IIUC, you could ignore the cmpxchg here because the following loop
> iteration on the caller would catch it and retry. =C2=A0In this case, it =
no
> retry in io_wq_cancel_tw_create, which looks weird. =C2=A0Did I miss some=
thing?

There is no need retry in io_wq_cancel_tw_create.
In the main teardown path, IO_WQ_BIT_EXIT has already been set by the
time io_wq_cancel_tw_create()=C2=A0 is called.=C2=A0
As a result, the workqueue is already in the exit state, and normal worker
creation is no longer allowed to proceed.
However, due to a concurrency window, a small number of late create_work
items may still get queued after exit has begun.=C2=A0
These late arrivals are not handled by an outer retry loop; instead, they a=
re
cleaned up by the post-add exit check in io_queue_worker_create() , which
calls io_wq_cancel_tw_create() again if needed.
Therefore, calling task_work_cancel_match_all() only once does not miss any
Work that must be canceled during the overall teardown process.
>=C2=A0
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0work->next =3D=
 NULL;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*tail =3D work=
;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tail =3D &work=
->next;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0work =3D next;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0raw_spin_unlock_irqrestore(&task->pi_lock,=
 flags);
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0return head;
> > +}
> > +
> > =C2=A0static bool task_work_func_match(struct callback_head *cb, void *=
data)
> > =C2=A0{
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return cb->func =3D=3D data;
>=C2=A0
> --=C2=A0
> Gabriel Krisman Bertazi
>=C2=A0

