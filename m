Return-Path: <io-uring+bounces-8457-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 040AEAE5BE3
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 07:38:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12E773BF4A0
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 05:37:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3548E1ACEC7;
	Tue, 24 Jun 2025 05:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KqNRoHYX"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94A526ACB
	for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 05:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750743495; cv=none; b=bnaeu+dsB4aJ+yTDnspmnfxO/PzB49K+BFCQ4oUrAjklbpIXC1YjgmX4tAC5vsA3oPSvSAKwlAZCbQH8Wf16J85U/MkHahGGE4pC8oxlJA6+DDNgDib4w56N9yUDI8auulRkvQmUhcYtrj7F9U7hETIr0MWdfJ3kB2rrKmBzxFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750743495; c=relaxed/simple;
	bh=34Wr0HUpfN5WnCByilj+fzSOuNVCKBNGvugmjEXR0ME=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=DxpEveEh1VbbLlFiw/tRI5Te/bjvL5tp0TYmRSkh8oVCI9zGi8nC6UfMXHz7iCzS8TbSAfRe5yQvtLmwIQRopcIenPVt+ynNXcl2DulcI5G9O3SxTnc1w4hpA6hbJWZcJo7tu/0LZW8OlBwIw++E2ifyqwnSR+Bnds5/MKKhNxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KqNRoHYX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750743491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=Gj7v0EzSE54puVcty6Z2zd4QiKWO/cW2pQMoTgnlbAE=;
	b=KqNRoHYXMh3aHQW83j1ecSIRFYT5kvA7cB8JjIqS47vQ0l/Guz9aTstWxlt/QrSSvUNoq/
	WOuR9B/LIUgArqNDOH8SOVt1A/yMKE4iclSfm9vWO0zOQYBzMMkHPy9MQ0w0zjjVPyDrej
	NM5jv3+Q21DhN5inaDw0V6I2dFEhCnU=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-292-8qpDJ4K2OXe63IGJxHCn0g-1; Tue, 24 Jun 2025 01:38:09 -0400
X-MC-Unique: 8qpDJ4K2OXe63IGJxHCn0g-1
X-Mimecast-MFC-AGG-ID: 8qpDJ4K2OXe63IGJxHCn0g_1750743489
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-31366819969so86312a91.0
        for <io-uring@vger.kernel.org>; Mon, 23 Jun 2025 22:38:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750743488; x=1751348288;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Gj7v0EzSE54puVcty6Z2zd4QiKWO/cW2pQMoTgnlbAE=;
        b=iygXMU9WHGxcxe1MHRc55WI+fodtpw8/TQHYS/m96QXAdDuNqvhe7384yxDKUoJPjZ
         Ytz5wEQ1dNOlh3BixRkQjv0/yBL0EdBbaisxDlH6UfUllIMGbDji2Iz7vyhXNMQApuax
         ef/htKs3I/T22u+IFWx4EWiNzHJ/3xhbljgx+9plBTTGVoo73CUxzARJAkf+vh4Etvw4
         g5G2pwbnkrVKDn0O70vykr4cqCcUT6KpOSpSGlMgfm7+HrRVdaXTMWv9d/HdPxWJyCBF
         hvvG9Vu4l1ffosJ0yYO8N2hr+PtxILbPXmTQb6wRwwg5trtqTeE7Efmxs3kGYScruZuO
         lprg==
X-Forwarded-Encrypted: i=1; AJvYcCWV2z3sP0frFpK7TxCln7VPRXOrJiCI1BiijMPusRoqVvZJ+PrG6xe2fls3jZniIGq/JpzwiU87AA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwGV9BW+Ho8Cy8tJ2GuLfmMd49eOrgZRo26MuXUutGfIvKdM+lX
	iAJmmdyuuL71PDsAzUoobkGgZRjq8ouRGDlF2ApQc6K7Go/nlbxJB/9uA3qA+umoGM+/4T4QOJF
	O5SQDY5RBD9RO1kf9Jypj4aCpGLwlTQ9VYcZOCq8bbnJfxFzznFcbAtHaR+0Km/by5y1+BcdvA4
	IGDkrw2HK9rDrxRw9bMAXZxSE5iyvkDmIzJ1HOsFDbcQRd+A==
X-Gm-Gg: ASbGncuJM/MuehWcoC9PWF3fGLU/xDzyEy+qO9uFjCbqKiQRziDKpyzaKryzq4OGgL4
	sHTpE7n35xsWeIUi3JogxmEAFL9frWfUfNnAn0Ji2wNKGnNJMHMso4CaMTj+Hgz8XZ5qaGHS1q2
	ZXKX+4
X-Received: by 2002:a17:90b:1cc3:b0:312:f263:954a with SMTP id 98e67ed59e1d1-3159d628fdamr23503314a91.5.1750743488355;
        Mon, 23 Jun 2025 22:38:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IECXECgK7AYAPqLxvSunTMpyxztTHQn/LbX3ud0zX0YurbTmbHFXJPyBGAwKO5j+pyNBeUF3Tawu3XK+zuQqGY=
X-Received: by 2002:a17:90b:1cc3:b0:312:f263:954a with SMTP id
 98e67ed59e1d1-3159d628fdamr23503293a91.5.1750743487971; Mon, 23 Jun 2025
 22:38:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Changhui Zhong <czhong@redhat.com>
Date: Tue, 24 Jun 2025 13:37:55 +0800
X-Gm-Features: Ac12FXxr5lUmpv_6WuJ94elPxN8KeTSUxjegjD9Lu1lLeGCOKVrpm6irBLF69Z8
Message-ID: <CAGVVp+UFKKb4ydw1+zWX9Bre6vt9TUFt9FY2qOx0LMv+8VaVoA@mail.gmail.com>
Subject: [bug report] WARNING: CPU: 3 PID: 175811 at io_uring/io_uring.c:2921 io_ring_exit_work+0x155/0x288
To: Linux Block Devices <linux-block@vger.kernel.org>, io-uring@vger.kernel.org
Cc: Ming Lei <ming.lei@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Hello,

the following warnning info was triggered by ubdsrv  generic/004 tests,
please help check and let me know if you need any info/test, thanks.

repo: https://github.com/torvalds/linux.git
branch: master
INFO: HEAD of cloned kernel
commit 86731a2a651e58953fc949573895f2fa6d456841
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Jun 22 13:30:08 2025 -0700

    Linux 6.16-rc3


reproducer:
# echo 0 > /proc/sys/kernel/io_uring_disabled
# modprobe ublk_drv
# for i in {0..30};do make test T=generic; done

dmesg log:
[61128.578684] running generic/004
[61133.356428] blk_print_req_error: 525 callbacks suppressed
[61133.356435] I/O error, dev ublkb0, sector 230760 op 0x0:(READ)
flags 0x0 phys_seg 3 prio class 0
[61133.372322] I/O error, dev ublkb0, sector 233744 op 0x1:(WRITE)
flags 0x8800 phys_seg 1 prio class 0
[61133.382529] I/O error, dev ublkb0, sector 230384 op 0x0:(READ)
flags 0x0 phys_seg 2 prio class 0
[61133.392341] I/O error, dev ublkb0, sector 233752 op 0x1:(WRITE)
flags 0x8800 phys_seg 1 prio class 0
[61133.402540] I/O error, dev ublkb0, sector 230400 op 0x0:(READ)
flags 0x0 phys_seg 6 prio class 0
[61133.412354] I/O error, dev ublkb0, sector 233760 op 0x1:(WRITE)
flags 0x8800 phys_seg 1 prio class 0
[61133.422556] I/O error, dev ublkb0, sector 230448 op 0x0:(READ)
flags 0x0 phys_seg 3 prio class 0
[61133.432370] I/O error, dev ublkb0, sector 233768 op 0x1:(WRITE)
flags 0x8800 phys_seg 2 prio class 0
[61133.442571] I/O error, dev ublkb0, sector 233816 op 0x1:(WRITE)
flags 0x8800 phys_seg 2 prio class 0
[61133.452773] I/O error, dev ublkb0, sector 230568 op 0x0:(READ)
flags 0x0 phys_seg 2 prio class 0
[61133.474450] buffer_io_error: 2 callbacks suppressed
[61133.474456] Buffer I/O error on dev ublkb0, logical block 0, async page read
[61133.487907] Buffer I/O error on dev ublkb0, logical block 0, async page read
[61133.495823] Buffer I/O error on dev ublkb0, logical block 0, async page read
[61133.503706] Buffer I/O error on dev ublkb0, logical block 0, async page read
[61133.511584] Buffer I/O error on dev ublkb0, logical block 0, async page read
[61133.519459] Buffer I/O error on dev ublkb0, logical block 0, async page read
[61135.776566] Buffer I/O error on dev ublkb0, logical block 0, async page read
[61135.784574] Buffer I/O error on dev ublkb0, logical block 0, async page read
[61135.792489] Buffer I/O error on dev ublkb0, logical block 0, async page read
[61135.800385] Buffer I/O error on dev ublkb0, logical block 0, async page read
[-- MARK -- Tue Jun 24 05:10:00 2025]
[61140.252443] blk_print_req_error: 761 callbacks suppressed
[61140.252450] I/O error, dev ublkb0, sector 229072 op 0x0:(READ)
flags 0x0 phys_seg 1 prio class 0
[61140.268331] I/O error, dev ublkb0, sector 229192 op 0x0:(READ)
flags 0x0 phys_seg 2 prio class 0
[61140.278151] I/O error, dev ublkb0, sector 228992 op 0x0:(READ)
flags 0x0 phys_seg 2 prio class 0
[61140.287963] I/O error, dev ublkb0, sector 229344 op 0x0:(READ)
flags 0x0 phys_seg 3 prio class 0
[61140.297777] I/O error, dev ublkb0, sector 229080 op 0x1:(WRITE)
flags 0x8800 phys_seg 1 prio class 0
[61140.307977] I/O error, dev ublkb0, sector 229080 op 0x0:(READ)
flags 0x0 phys_seg 1 prio class 0
[61140.317793] I/O error, dev ublkb0, sector 229008 op 0x0:(READ)
flags 0x0 phys_seg 2 prio class 0
[61140.327604] I/O error, dev ublkb0, sector 229208 op 0x0:(READ)
flags 0x0 phys_seg 4 prio class 0
[61140.337419] I/O error, dev ublkb0, sector 229208 op 0x1:(WRITE)
flags 0x8800 phys_seg 6 prio class 0
[61140.347636] I/O error, dev ublkb0, sector 229088 op 0x1:(WRITE)
flags 0x8800 phys_seg 1 prio class 0
[61140.368546] buffer_io_error: 8 callbacks suppressed
[61140.368550] Buffer I/O error on dev ublkb0, logical block 0, async page read
[61140.381994] Buffer I/O error on dev ublkb0, logical block 0, async page read
[61140.389904] Buffer I/O error on dev ublkb0, logical block 0, async page read
[61140.397794] Buffer I/O error on dev ublkb0, logical block 0, async page read
[61140.405676] Buffer I/O error on dev ublkb0, logical block 0, async page read
[61140.413552] Buffer I/O error on dev ublkb0, logical block 0, async page read
[-- MARK -- Tue Jun 24 05:15:00 2025]
[61449.365065] ------------[ cut here ]------------
[61449.370245] WARNING: CPU: 3 PID: 175811 at io_uring/io_uring.c:2921
io_ring_exit_work+0x155/0x288
[61449.380178] Modules linked in: ublk_drv rpcsec_gss_krb5 auth_rpcgss
nfsv4 dns_resolver nfs lockd grace nfs_localio netfs sunrpc rfkill
intel_rapl_msr intel_rapl_common intel_uncore_frequency
intel_uncore_frequency_common i10nm_edac skx_edac_common nfit
libnvdimm x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm
irqbypass dax_hmem rapl cxl_acpi cxl_port intel_cstate ipmi_ssif
cdc_ether iTCO_wdt cxl_core iTCO_vendor_support usbnet mgag200 mii
intel_uncore tg3 ioatdma einj i2c_i801 pcspkr intel_th_gth
isst_if_mbox_pci mei_me isst_if_mmio i2c_algo_bit acpi_power_meter
intel_th_pci mei i2c_smbus isst_if_common intel_vsec intel_th
intel_pch_thermal dca ipmi_si acpi_ipmi ipmi_devintf ipmi_msghandler
acpi_pad sg fuse loop dm_multipath nfnetlink xfs sd_mod ahci libahci
libata ghash_clmulni_intel wmi dm_mirror dm_region_hash dm_log dm_mod
[last unloaded: ublk_drv]
[61449.465875] CPU: 3 UID: 0 PID: 175811 Comm: kworker/u96:2 Tainted:
G S                  6.16.0-rc3 #1 PREEMPT(voluntary)
[61449.478116] Tainted: [S]=CPU_OUT_OF_SPEC
[61449.482501] Hardware name: Lenovo ThinkSystem SR650 V2/7Z73CTO1WW,
BIOS AFE118M-1.32 06/29/2022
[61449.492218] Workqueue: iou_exit io_ring_exit_work
[61449.497476] RIP: 0010:io_ring_exit_work+0x155/0x288
[61449.502929] Code: e8 00 76 6f 00 4c 89 f7 e8 68 d2 6e 00 4c 89 e7
e8 a0 e9 ff ff 31 c9 48 89 4c 24 10 48 8b 05 a2 0e 9e 01 48 39 44 24
08 79 08 <0f> 0b 41 bd 60 ea 00 00 48 8d 7b 30 4c 89 ee e8 b7 d1 e4 00
48 85
[61449.523892] RSP: 0018:ff8b5fc9cd4b3db0 EFLAGS: 00010297
[61449.529732] RAX: 0000000103a50f19 RBX: ff43740b38f6f410 RCX: 0000000000000000
[61449.537702] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ff43740b38f6f040
[61449.545673] RBP: ff8b5fc9cd4b3e40 R08: ff43740a80400790 R09: ffffffffa42588e0
[61449.553645] R10: 0000000000000000 R11: 0000000000000000 R12: ff43740b38f6f000
[61449.561615] R13: 0000000000000032 R14: 0000000000000000 R15: ff43740b38f6f040
[61449.569588] FS:  0000000000000000(0000) GS:ff43740e0a985000(0000)
knlGS:0000000000000000
[61449.578627] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[61449.585045] CR2: 00007fbc9c500790 CR3: 00000002ce024002 CR4: 0000000000773ef0
[61449.593017] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[61449.600993] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[61449.608964] PKRU: 55555554
[61449.611989] Call Trace:
[61449.614724]  <TASK>
[61449.617070]  process_one_work+0x188/0x340
[61449.621556]  worker_thread+0x257/0x3a0
[61449.625747]  ? __pfx_worker_thread+0x10/0x10
[61449.630519]  kthread+0xfc/0x240
[61449.634031]  ? __pfx_kthread+0x10/0x10
[61449.638221]  ? __pfx_kthread+0x10/0x10
[61449.642412]  ret_from_fork+0xed/0x110
[61449.646507]  ? __pfx_kthread+0x10/0x10
[61449.650696]  ret_from_fork_asm+0x1a/0x30
[61449.655084]  </TASK>
[61449.657526] ---[ end trace 0000000000000000 ]---
[61730.255363] running generic/005
[61732.466565] blk_print_req_error: 397 callbacks suppressed
[61732.466573] I/O error, dev ublkb1, sector 2094968 op 0x1:(WRITE)
flags 0x8800 phys_seg 1 prio class 0


Best Regards,
Changhui


