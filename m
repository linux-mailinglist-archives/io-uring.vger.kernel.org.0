Return-Path: <io-uring+bounces-8458-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B7C9AE5C1D
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 07:54:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AA2501B6688C
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 05:54:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6ED622FDFF;
	Tue, 24 Jun 2025 05:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c5P7D8kg"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229B120EB
	for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 05:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750744448; cv=none; b=KTUNZorzmSuuDjbuZctfEc6jDwXjz8nksTgnVHbx1M/guQTyO2hyai47M17UG7M/9tx9f32VtYDwOzIAdIGMZ+Daw8Sk3mDI6ySLHCMo7jr091DxfFDkB42tSlh08AD9zoJkLiPeLdbPXT4C578KX/vepJe3UWGnn+QCIkAy6u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750744448; c=relaxed/simple;
	bh=wlAB5NDAdD+QkQfIQ9BTPcth0W54hvF1QoH3dhn3NUM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AzLWKB74A5lowzZ/msUZrvF/HyBkys/gfntU5cnrEGdMnCItW2aa6y9rwHR5TopYiki89FI4oDs6G8yxUkWLDwlijN0n5/PzILTOI5vsVug/ibzDfUPPA2CBpq2Wo1CtIe1BkNUCuH8VCAHMuIjna3kO0lf4WZVaR1WJaHwd7sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c5P7D8kg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750744445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ldTJ++NY09AF8FWS17VLHNa6AyTSeOZ6LGzIrEiIzT4=;
	b=c5P7D8kg7jAfWAYh4Cvs81OLayTM0b+IcSkhRP8q9cIWGycOfRmpFU/Wmg4N4k2Y+mqTbn
	xyDCmIRR2SINXYOkthSUewyj2xLe0X+eovIDmXbPubcPmSsIaJZ1XFxjXoQtJhXvydk+xi
	w5y9LROvDTK2i6zEFRgIGQ1nnWeWjuI=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-297-d50zHg_CMF6uh5bJOw2MLA-1; Tue, 24 Jun 2025 01:54:01 -0400
X-MC-Unique: d50zHg_CMF6uh5bJOw2MLA-1
X-Mimecast-MFC-AGG-ID: d50zHg_CMF6uh5bJOw2MLA_1750744441
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-235e3f93687so77420935ad.2
        for <io-uring@vger.kernel.org>; Mon, 23 Jun 2025 22:54:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750744440; x=1751349240;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ldTJ++NY09AF8FWS17VLHNa6AyTSeOZ6LGzIrEiIzT4=;
        b=STeWnskwaRVdAYxc0kw5G8JR9k8agTHSXWN0rAmpASbuOxteU1c0lkTFPJAC8SzTar
         EAzw7o5PjkuYurw+OR/AilcXr2BqRNzOBWKsGuypSS2kepFywWhStNRLE7dZIxOv1XOF
         2zGyf8s23mxWNMWxSGCuKCxYBzbY1vqAAYohEmUCYgMeosh636YW6V/7YvJIJcd8rcIm
         tYc3vZvdiyBzSMiKZX6WKRLa322qvNWFctnNmraeBxWyZv0K2K/wdS+i7os8NJMkq8ra
         C2DSzRzDQdodDBvBNS18VIiJmKjwDRkw8aCl0R4UmFmnMhLIHaFZBDpQb89Z+4mq/ww+
         owzw==
X-Forwarded-Encrypted: i=1; AJvYcCVwiwDEGWtTArSvT+m0RJ7/gpw68IbfFTsS1WZYdnrTzQYedvkEq1kgpOnjTSZAuPfJlnEmNrpy7A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2nffGmhUSwrzebCocihzJHFJ+hOwX02eu9zelSAAVkpyHqacO
	BLke4L58IYWGtxll9RkS1ee8H35mNkpRLxuLsn359MgTXhjImiqjJAn6gdGGVv/N7W/tBceTUM0
	qVHDCvA1bPOOBd2Rj787XVC5/f9nywKEex74i2YdLGAli0Qlmuqc96YwzJAN8cqKBXiUfSq+hgI
	XS52iIYXM/1GHLmSF9OpsgprgTYP5oMNbBHmc=
X-Gm-Gg: ASbGncu3v08pSJ+NErtjPzbd9Rx17ETcFQd9wFcS0amA6oCWO7knIfFPG9F4UiDIiyF
	fyDgFyY3zKDL2yEFtLemy9kGBRQRbGSqQUWw9xLiJvguVBVbudprv4H2FGjQcjmB2hmtcugwZu5
	rbExFG
X-Received: by 2002:a17:902:f652:b0:235:be0:db53 with SMTP id d9443c01a7336-237d9bf5707mr246655215ad.51.1750744440542;
        Mon, 23 Jun 2025 22:54:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFcFjni5MgH7eh9xiqRF53hG3zQb1/n2bkMLTONyk80NI8w7PYPpFKKuGKh8LWgpUHhIPF/srIFJzu7LgSvRyk=
X-Received: by 2002:a17:902:f652:b0:235:be0:db53 with SMTP id
 d9443c01a7336-237d9bf5707mr246654925ad.51.1750744440096; Mon, 23 Jun 2025
 22:54:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGVVp+UFKKb4ydw1+zWX9Bre6vt9TUFt9FY2qOx0LMv+8VaVoA@mail.gmail.com>
In-Reply-To: <CAGVVp+UFKKb4ydw1+zWX9Bre6vt9TUFt9FY2qOx0LMv+8VaVoA@mail.gmail.com>
From: Changhui Zhong <czhong@redhat.com>
Date: Tue, 24 Jun 2025 13:53:47 +0800
X-Gm-Features: Ac12FXymQQrL_cpI5Z0_j62nFEpCTL6e0re7dkIY5CEG-J6ZlIVj0IjSgaorAMM
Message-ID: <CAGVVp+UMOVUqAyRFBpCUxHxsuxpoTr8w7cOX-QcgwC9GabW9ww@mail.gmail.com>
Subject: Re: [bug report] WARNING: CPU: 3 PID: 175811 at io_uring/io_uring.c:2921
 io_ring_exit_work+0x155/0x288
To: Linux Block Devices <linux-block@vger.kernel.org>, io-uring@vger.kernel.org
Cc: Ming Lei <ming.lei@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 24, 2025 at 1:37=E2=80=AFPM Changhui Zhong <czhong@redhat.com> =
wrote:
>
> Hello,
>
> the following warnning info was triggered by ubdsrv  generic/004 tests,
> please help check and let me know if you need any info/test, thanks.
>
> repo: https://github.com/torvalds/linux.git
> branch: master
> INFO: HEAD of cloned kernel
> commit 86731a2a651e58953fc949573895f2fa6d456841
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Sun Jun 22 13:30:08 2025 -0700
>
>     Linux 6.16-rc3
>
>
> reproducer:
> # echo 0 > /proc/sys/kernel/io_uring_disabled
> # modprobe ublk_drv
> # for i in {0..30};do make test T=3Dgeneric; done
>
> dmesg log:
> [61128.578684] running generic/004
> [61133.356428] blk_print_req_error: 525 callbacks suppressed
> [61133.356435] I/O error, dev ublkb0, sector 230760 op 0x0:(READ)
> flags 0x0 phys_seg 3 prio class 0
> [61133.372322] I/O error, dev ublkb0, sector 233744 op 0x1:(WRITE)
> flags 0x8800 phys_seg 1 prio class 0
> [61133.382529] I/O error, dev ublkb0, sector 230384 op 0x0:(READ)
> flags 0x0 phys_seg 2 prio class 0
> [61133.392341] I/O error, dev ublkb0, sector 233752 op 0x1:(WRITE)
> flags 0x8800 phys_seg 1 prio class 0
> [61133.402540] I/O error, dev ublkb0, sector 230400 op 0x0:(READ)
> flags 0x0 phys_seg 6 prio class 0
> [61133.412354] I/O error, dev ublkb0, sector 233760 op 0x1:(WRITE)
> flags 0x8800 phys_seg 1 prio class 0
> [61133.422556] I/O error, dev ublkb0, sector 230448 op 0x0:(READ)
> flags 0x0 phys_seg 3 prio class 0
> [61133.432370] I/O error, dev ublkb0, sector 233768 op 0x1:(WRITE)
> flags 0x8800 phys_seg 2 prio class 0
> [61133.442571] I/O error, dev ublkb0, sector 233816 op 0x1:(WRITE)
> flags 0x8800 phys_seg 2 prio class 0
> [61133.452773] I/O error, dev ublkb0, sector 230568 op 0x0:(READ)
> flags 0x0 phys_seg 2 prio class 0
> [61133.474450] buffer_io_error: 2 callbacks suppressed
> [61133.474456] Buffer I/O error on dev ublkb0, logical block 0, async pag=
e read
> [61133.487907] Buffer I/O error on dev ublkb0, logical block 0, async pag=
e read
> [61133.495823] Buffer I/O error on dev ublkb0, logical block 0, async pag=
e read
> [61133.503706] Buffer I/O error on dev ublkb0, logical block 0, async pag=
e read
> [61133.511584] Buffer I/O error on dev ublkb0, logical block 0, async pag=
e read
> [61133.519459] Buffer I/O error on dev ublkb0, logical block 0, async pag=
e read
> [61135.776566] Buffer I/O error on dev ublkb0, logical block 0, async pag=
e read
> [61135.784574] Buffer I/O error on dev ublkb0, logical block 0, async pag=
e read
> [61135.792489] Buffer I/O error on dev ublkb0, logical block 0, async pag=
e read
> [61135.800385] Buffer I/O error on dev ublkb0, logical block 0, async pag=
e read
> [-- MARK -- Tue Jun 24 05:10:00 2025]
> [61140.252443] blk_print_req_error: 761 callbacks suppressed
> [61140.252450] I/O error, dev ublkb0, sector 229072 op 0x0:(READ)
> flags 0x0 phys_seg 1 prio class 0
> [61140.268331] I/O error, dev ublkb0, sector 229192 op 0x0:(READ)
> flags 0x0 phys_seg 2 prio class 0
> [61140.278151] I/O error, dev ublkb0, sector 228992 op 0x0:(READ)
> flags 0x0 phys_seg 2 prio class 0
> [61140.287963] I/O error, dev ublkb0, sector 229344 op 0x0:(READ)
> flags 0x0 phys_seg 3 prio class 0
> [61140.297777] I/O error, dev ublkb0, sector 229080 op 0x1:(WRITE)
> flags 0x8800 phys_seg 1 prio class 0
> [61140.307977] I/O error, dev ublkb0, sector 229080 op 0x0:(READ)
> flags 0x0 phys_seg 1 prio class 0
> [61140.317793] I/O error, dev ublkb0, sector 229008 op 0x0:(READ)
> flags 0x0 phys_seg 2 prio class 0
> [61140.327604] I/O error, dev ublkb0, sector 229208 op 0x0:(READ)
> flags 0x0 phys_seg 4 prio class 0
> [61140.337419] I/O error, dev ublkb0, sector 229208 op 0x1:(WRITE)
> flags 0x8800 phys_seg 6 prio class 0
> [61140.347636] I/O error, dev ublkb0, sector 229088 op 0x1:(WRITE)
> flags 0x8800 phys_seg 1 prio class 0
> [61140.368546] buffer_io_error: 8 callbacks suppressed
> [61140.368550] Buffer I/O error on dev ublkb0, logical block 0, async pag=
e read
> [61140.381994] Buffer I/O error on dev ublkb0, logical block 0, async pag=
e read
> [61140.389904] Buffer I/O error on dev ublkb0, logical block 0, async pag=
e read
> [61140.397794] Buffer I/O error on dev ublkb0, logical block 0, async pag=
e read
> [61140.405676] Buffer I/O error on dev ublkb0, logical block 0, async pag=
e read
> [61140.413552] Buffer I/O error on dev ublkb0, logical block 0, async pag=
e read
> [-- MARK -- Tue Jun 24 05:15:00 2025]
> [61449.365065] ------------[ cut here ]------------
> [61449.370245] WARNING: CPU: 3 PID: 175811 at io_uring/io_uring.c:2921
> io_ring_exit_work+0x155/0x288
> [61449.380178] Modules linked in: ublk_drv rpcsec_gss_krb5 auth_rpcgss
> nfsv4 dns_resolver nfs lockd grace nfs_localio netfs sunrpc rfkill
> intel_rapl_msr intel_rapl_common intel_uncore_frequency
> intel_uncore_frequency_common i10nm_edac skx_edac_common nfit
> libnvdimm x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm
> irqbypass dax_hmem rapl cxl_acpi cxl_port intel_cstate ipmi_ssif
> cdc_ether iTCO_wdt cxl_core iTCO_vendor_support usbnet mgag200 mii
> intel_uncore tg3 ioatdma einj i2c_i801 pcspkr intel_th_gth
> isst_if_mbox_pci mei_me isst_if_mmio i2c_algo_bit acpi_power_meter
> intel_th_pci mei i2c_smbus isst_if_common intel_vsec intel_th
> intel_pch_thermal dca ipmi_si acpi_ipmi ipmi_devintf ipmi_msghandler
> acpi_pad sg fuse loop dm_multipath nfnetlink xfs sd_mod ahci libahci
> libata ghash_clmulni_intel wmi dm_mirror dm_region_hash dm_log dm_mod
> [last unloaded: ublk_drv]
> [61449.465875] CPU: 3 UID: 0 PID: 175811 Comm: kworker/u96:2 Tainted:
> G S                  6.16.0-rc3 #1 PREEMPT(voluntary)
> [61449.478116] Tainted: [S]=3DCPU_OUT_OF_SPEC
> [61449.482501] Hardware name: Lenovo ThinkSystem SR650 V2/7Z73CTO1WW,
> BIOS AFE118M-1.32 06/29/2022
> [61449.492218] Workqueue: iou_exit io_ring_exit_work
> [61449.497476] RIP: 0010:io_ring_exit_work+0x155/0x288
> [61449.502929] Code: e8 00 76 6f 00 4c 89 f7 e8 68 d2 6e 00 4c 89 e7
> e8 a0 e9 ff ff 31 c9 48 89 4c 24 10 48 8b 05 a2 0e 9e 01 48 39 44 24
> 08 79 08 <0f> 0b 41 bd 60 ea 00 00 48 8d 7b 30 4c 89 ee e8 b7 d1 e4 00
> 48 85
> [61449.523892] RSP: 0018:ff8b5fc9cd4b3db0 EFLAGS: 00010297
> [61449.529732] RAX: 0000000103a50f19 RBX: ff43740b38f6f410 RCX: 000000000=
0000000
> [61449.537702] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ff43740b3=
8f6f040
> [61449.545673] RBP: ff8b5fc9cd4b3e40 R08: ff43740a80400790 R09: ffffffffa=
42588e0
> [61449.553645] R10: 0000000000000000 R11: 0000000000000000 R12: ff43740b3=
8f6f000
> [61449.561615] R13: 0000000000000032 R14: 0000000000000000 R15: ff43740b3=
8f6f040
> [61449.569588] FS:  0000000000000000(0000) GS:ff43740e0a985000(0000)
> knlGS:0000000000000000
> [61449.578627] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [61449.585045] CR2: 00007fbc9c500790 CR3: 00000002ce024002 CR4: 000000000=
0773ef0
> [61449.593017] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
> [61449.600993] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000000000=
0000400
> [61449.608964] PKRU: 55555554
> [61449.611989] Call Trace:
> [61449.614724]  <TASK>
> [61449.617070]  process_one_work+0x188/0x340
> [61449.621556]  worker_thread+0x257/0x3a0
> [61449.625747]  ? __pfx_worker_thread+0x10/0x10
> [61449.630519]  kthread+0xfc/0x240
> [61449.634031]  ? __pfx_kthread+0x10/0x10
> [61449.638221]  ? __pfx_kthread+0x10/0x10
> [61449.642412]  ret_from_fork+0xed/0x110
> [61449.646507]  ? __pfx_kthread+0x10/0x10
> [61449.650696]  ret_from_fork_asm+0x1a/0x30
> [61449.655084]  </TASK>
> [61449.657526] ---[ end trace 0000000000000000 ]---
> [61730.255363] running generic/005
> [61732.466565] blk_print_req_error: 397 callbacks suppressed
> [61732.466573] I/O error, dev ublkb1, sector 2094968 op 0x1:(WRITE)
> flags 0x8800 phys_seg 1 prio class 0
>
>
> Best Regards,
> Changhui

looks this is a timeout warning, the io_ring's exit worker process
execution time exceeds the expected timeout threshold

(gdb) l *(io_ring_exit_work+0x155)
0xffffffff81228b25 is in io_ring_exit_work (io_uring/io_uring.c:2921).
2916                            io_sq_thread_unpark(sqd);
2917                    }
2918
2919                    io_req_caches_free(ctx);
2920
2921                    if (WARN_ON_ONCE(time_after(jiffies, timeout))) {
2922                            /* there is little hope left, don't
run it too often */
2923                            interval =3D HZ * 60;
2924                    }
2925                    /*
(gdb)


