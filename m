Return-Path: <io-uring+bounces-1958-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CB288CE3B3
	for <lists+io-uring@lfdr.de>; Fri, 24 May 2024 11:46:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FF151C211B4
	for <lists+io-uring@lfdr.de>; Fri, 24 May 2024 09:46:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CA4B85920;
	Fri, 24 May 2024 09:46:12 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CD785628;
	Fri, 24 May 2024 09:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716543972; cv=none; b=fG3SxcMPfQOLMT2xr6EF4mcF3DWZKDZskvR3LNqdBQG/kEHYVvrYgthlg8h1TAdHtl2orPvjsIgOV6s285Nzp5SY9bG75ck6o7tKPz4kGfiHm4eoY/6d5istoQkIKlbXlQejmT5CX7MnjxG3XzlkWb1p8XkNkqScECoVwLy0KZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716543972; c=relaxed/simple;
	bh=+N+EYz71wbFiJ4KgpDPCd4YIYiKw+NRkaL/e/Xeqxxg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g2jTk3hhLYn9KixG4R9uqqwpF28BHOj7FbmGx1ovwsNzQudNHkzEKNzt9aeNh3vTS6TmxdEJ7CD1m9tHqgpy29fmQaiK6ljlM8LJqLhJcLTAb8HCe48Ujxby0vIbafazcJXt7ugK2ikNDYkl7b8BnUYyi7bgjY2NCsMAi6+ap5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Vm0Xd30MHz4f3k6B;
	Fri, 24 May 2024 17:45:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 4858C1A058E;
	Fri, 24 May 2024 17:45:59 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP2 (Coremail) with SMTP id Syh0CgCnyw7SYVBm8El_Nw--.32049S3;
	Fri, 24 May 2024 17:45:58 +0800 (CST)
Message-ID: <4b9986cf-003b-0ad2-75be-5745e979d36d@huaweicloud.com>
Date: Fri, 24 May 2024 17:45:54 +0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [bug report] WARNING: CPU: 2 PID: 3445306 at
 drivers/block/ublk_drv.c:2633 ublk_ctrl_start_recovery.constprop.0+0x74/0x180
To: Changhui Zhong <czhong@redhat.com>,
 Linux Block Devices <linux-block@vger.kernel.org>, io-uring@vger.kernel.org
Cc: Ming Lei <ming.lei@redhat.com>,
 "yangerkun@huawei.com" <yangerkun@huawei.com>,
 "yukuai (C)" <yukuai3@huawei.com>, "houtao1@huawei.com"
 <houtao1@huawei.com>, "yi.zhang@huawei.com" <yi.zhang@huawei.com>
References: <CAGVVp+UvLiS+bhNXV-h2icwX1dyybbYHeQUuH7RYqUvMQf6N3w@mail.gmail.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <CAGVVp+UvLiS+bhNXV-h2icwX1dyybbYHeQUuH7RYqUvMQf6N3w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgCnyw7SYVBm8El_Nw--.32049S3
X-Coremail-Antispam: 1UD129KBjvJXoW3CFy8CFykuFWUJFy3KF43trb_yoWDAw1Dpr
	18Jr47Gw48Jw15WF4UJw15J3WUtr4UAa4DXw17try8JF1UGrn8ZrnrGF4UJ34DGw48XFya
	ywn8Xw4ftFyUJaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l
	5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67
	AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07Al
	zVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFyl
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v2
	6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07
	UCXd8UUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2024/5/24 11:49, Changhui Zhong 写道:
> Hello,
> 
> I hit the kernel panic when running test ubdsrv  generic/005，
> please help check it and let me know if you need any info/testing for
> it, thanks.
> 
> repo:https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git
> branch:for-next
> commit: b785211c726fbe77ff559f0241aab8d3dadd9988
> 
> dmesg log：
> [ 7203.196155] ------------[ cut here ]------------
> [ 7203.200779] WARNING: CPU: 2 PID: 3445306 at
> drivers/block/ublk_drv.c:2633
> ublk_ctrl_start_recovery.constprop.0+0x74/0x180
> [ 7203.211732] Modules linked in: ext4 mbcache jbd2 raid10 raid1 raid0
> dm_raid raid456 async_raid6_recov async_memcpy async_pq async_xor xor
> async_tx raid6_pq loop nf_tables nfnetlink tls rpcsec_gss_krb5
> auth_rpcgss nfsv4 dns_resolver nfs lockd grace netfs rfkill sunrpc
> vfat fat dm_multipath intel_rapl_msr intel_rapl_common
> intel_uncore_frequency intel_uncore_frequency_common i10nm_edac nfit
> libnvdimm x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel
> ipmi_ssif kvm mgag200 dax_hmem iTCO_wdt i2c_algo_bit rapl
> iTCO_vendor_support cxl_acpi drm_shmem_helper intel_cstate cxl_core
> drm_kms_helper acpi_power_meter mei_me dcdbas dell_smbios i2c_i801
> intel_uncore einj isst_if_mmio isst_if_mbox_pci ipmi_si
> dell_wmi_descriptor wmi_bmof pcspkr mei i2c_smbus isst_if_common
> acpi_ipmi intel_vsec intel_pch_thermal ipmi_devintf ipmi_msghandler
> drm fuse xfs libcrc32c sd_mod t10_pi sg ahci libahci crct10dif_pclmul
> crc32_pclmul crc32c_intel libata tg3 ghash_clmulni_intel wmi dm_mirror
> dm_region_hash dm_log dm_mod
> [ 7203.211779]  [last unloaded: null_blk]
> [ 7203.303523] CPU: 2 PID: 3445306 Comm: iou-wrk-3445292 Not tainted 6.9.0+ #1
> [ 7203.310482] Hardware name: Dell Inc. PowerEdge R650xs/0PPTY2, BIOS
> 1.4.4 10/07/2021
> [ 7203.318135] RIP: 0010:ublk_ctrl_start_recovery.constprop.0+0x74/0x180
> [ 7203.324573] Code: 00 0f 84 9e 00 00 00 45 31 f6 bd ff ff ff ff 44
> 89 f3 41 0f af 5d 10 49 03 5d 08 48 8b 7b 10 48 85 ff 74 06 f6 47 2c
> 04 75 02 <0f> 0b 31 d2 4c 8d 47 28 89 e8 66 89 53 38 f0 0f c1 47 28 83
> f8 01
> [ 7203.343319] RSP: 0018:ff59ae67453ffce0 EFLAGS: 00010246
> [ 7203.348544] RAX: 0000000000000002 RBX: ff2fabb3b5682000 RCX: 0000000000000000
> [ 7203.355678] RDX: ff2fabb261e18000 RSI: ffffffffa324ee00 RDI: 0000000000000000
> [ 7203.362812] RBP: 00000000ffffffff R08: 0000000000000000 R09: ffffffffa36e33e0
> [ 7203.369943] R10: 0000000000000000 R11: 0000000000000000 R12: ff2fabb3ae44a468
> [ 7203.377078] R13: ff2fabb3ae44a000 R14: 0000000000000000 R15: ff2fabb3ce150080
> [ 7203.384210] FS:  00007fbed107c740(0000) GS:ff2fabb5af700000(0000)
> knlGS:0000000000000000
> [ 7203.392294] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 7203.398041] CR2: 00007f4428078584 CR3: 000000011baa0004 CR4: 0000000000771ef0
> [ 7203.405174] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 7203.412308] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 7203.419441] PKRU: 55555554
> [ 7203.422151] Call Trace:
> [ 7203.424605]  <TASK>
> [ 7203.426713]  ? __warn+0x7f/0x120
> [ 7203.429943]  ? ublk_ctrl_start_recovery.constprop.0+0x74/0x180
> [ 7203.435778]  ? report_bug+0x18a/0x1a0
> [ 7203.439445]  ? handle_bug+0x3c/0x70
> [ 7203.442943]  ? exc_invalid_op+0x14/0x70
> [ 7203.446782]  ? asm_exc_invalid_op+0x16/0x20
> [ 7203.450970]  ? ublk_ctrl_start_recovery.constprop.0+0x74/0x180
> [ 7203.456802]  ublk_ctrl_uring_cmd+0x4f7/0x6c0
> [ 7203.461075]  ? pick_next_task_idle+0x26/0x40
> [ 7203.465347]  io_uring_cmd+0x9a/0x1b0
> [ 7203.468929]  io_issue_sqe+0x193/0x3f0
> [ 7203.472602]  io_wq_submit_work+0x9b/0x390
> [ 7203.476613]  io_worker_handle_work+0x165/0x360
> [ 7203.481059]  io_wq_worker+0xcb/0x2f0
> [ 7203.484640]  ? finish_task_switch.isra.0+0x203/0x290
> [ 7203.489608]  ? finish_task_switch.isra.0+0x203/0x290
> [ 7203.494572]  ? __pfx_io_wq_worker+0x10/0x10
> [ 7203.498758]  ret_from_fork+0x2d/0x50
> [ 7203.502338]  ? __pfx_io_wq_worker+0x10/0x10
> [ 7203.506523]  ret_from_fork_asm+0x1a/0x30
> [ 7203.510451]  </TASK>
> [ 7203.512643] ---[ end trace 0000000000000000 ]---
> [ 7203.517263] BUG: kernel NULL pointer dereference, address: 0000000000000028
> [ 7203.524220] #PF: supervisor write access in kernel mode
> [ 7203.529445] #PF: error_code(0x0002) - not-present page
> [ 7203.534584] PGD 2761af067 P4D 442db4067 PUD 1727a2067 PMD 0
> [ 7203.540244] Oops: Oops: 0002 [#1] PREEMPT SMP NOPTI
> [ 7203.545123] CPU: 2 PID: 3445306 Comm: iou-wrk-3445292 Tainted: G
>      W          6.9.0+ #1
> [ 7203.553556] Hardware name: Dell Inc. PowerEdge R650xs/0PPTY2, BIOS
> 1.4.4 10/07/2021
> [ 7203.561208] RIP: 0010:ublk_ctrl_start_recovery.constprop.0+0x82/0x180
> [ 7203.567647] Code: ff 44 89 f3 41 0f af 5d 10 49 03 5d 08 48 8b 7b
> 10 48 85 ff 74 06 f6 47 2c 04 75 02 0f 0b 31 d2 4c 8d 47 28 89 e8 66
> 89 53 38 <f0> 0f c1 47 28 83 f8 01 0f 84 b5 00 00 00 85 c0 0f 8e b7 00
> 00 00
> [ 7203.586395] RSP: 0018:ff59ae67453ffce0 EFLAGS: 00010246
> [ 7203.591622] RAX: 00000000ffffffff RBX: ff2fabb3b5682000 RCX: 0000000000000000
> [ 7203.598755] RDX: 0000000000000000 RSI: ffffffffa324ee00 RDI: 0000000000000000
> [ 7203.605886] RBP: 00000000ffffffff R08: 0000000000000028 R09: ffffffffa36e33e0
> [ 7203.613020] R10: 0000000000000000 R11: 0000000000000000 R12: ff2fabb3ae44a468
> [ 7203.620153] R13: ff2fabb3ae44a000 R14: 0000000000000000 R15: ff2fabb3ce150080
> [ 7203.627284] FS:  00007fbed107c740(0000) GS:ff2fabb5af700000(0000)
> knlGS:0000000000000000
> [ 7203.635371] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 7203.641117] CR2: 0000000000000028 CR3: 000000011baa0004 CR4: 0000000000771ef0
> [ 7203.648248] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 7203.655383] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 7203.662514] PKRU: 55555554
> [ 7203.665227] Call Trace:
> [ 7203.667681]  <TASK>
> [ 7203.669785]  ? __die+0x20/0x70
> [ 7203.672845]  ? page_fault_oops+0x75/0x170
> [ 7203.676860]  ? exc_page_fault+0x64/0x140
> [ 7203.680785]  ? asm_exc_page_fault+0x22/0x30
> [ 7203.684969]  ? ublk_ctrl_start_recovery.constprop.0+0x82/0x180
> [ 7203.690804]  ublk_ctrl_uring_cmd+0x4f7/0x6c0
> [ 7203.695076]  ? pick_next_task_idle+0x26/0x40
> [ 7203.699350]  io_uring_cmd+0x9a/0x1b0
> [ 7203.702927]  io_issue_sqe+0x193/0x3f0
> [ 7203.706595]  io_wq_submit_work+0x9b/0x390
> [ 7203.710607]  io_worker_handle_work+0x165/0x360
> [ 7203.715054]  io_wq_worker+0xcb/0x2f0
> [ 7203.718633]  ? finish_task_switch.isra.0+0x203/0x290
> [ 7203.723597]  ? finish_task_switch.isra.0+0x203/0x290
> [ 7203.728564]  ? __pfx_io_wq_worker+0x10/0x10
> [ 7203.732749]  ret_from_fork+0x2d/0x50
> [ 7203.736330]  ? __pfx_io_wq_worker+0x10/0x10
> [ 7203.740514]  ret_from_fork_asm+0x1a/0x30
> [ 7203.744441]  </TASK>
> [ 7203.746634] Modules linked in: ext4 mbcache jbd2 raid10 raid1 raid0
> dm_raid raid456 async_raid6_recov async_memcpy async_pq async_xor xor
> async_tx raid6_pq loop nf_tables nfnetlink tls rpcsec_gss_krb5
> auth_rpcgss nfsv4 dns_resolver nfs lockd grace netfs rfkill sunrpc
> vfat fat dm_multipath intel_rapl_msr intel_rapl_common
> intel_uncore_frequency intel_uncore_frequency_common i10nm_edac nfit
> libnvdimm x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel
> ipmi_ssif kvm mgag200 dax_hmem iTCO_wdt i2c_algo_bit rapl
> iTCO_vendor_support cxl_acpi drm_shmem_helper intel_cstate cxl_core
> drm_kms_helper acpi_power_meter mei_me dcdbas dell_smbios i2c_i801
> intel_uncore einj isst_if_mmio isst_if_mbox_pci ipmi_si
> dell_wmi_descriptor wmi_bmof pcspkr mei i2c_smbus isst_if_common
> acpi_ipmi intel_vsec intel_pch_thermal ipmi_devintf ipmi_msghandler
> drm fuse xfs libcrc32c sd_mod t10_pi sg ahci libahci crct10dif_pclmul
> crc32_pclmul crc32c_intel libata tg3 ghash_clmulni_intel wmi dm_mirror
> dm_region_hash dm_log dm_mod
> [ 7203.746668]  [last unloaded: null_blk]
> [ 7203.838416] CR2: 0000000000000028
> [ 7203.841734] ---[ end trace 0000000000000000 ]---
> [ 7203.919227] RIP: 0010:ublk_ctrl_start_recovery.constprop.0+0x82/0x180
> [ 7203.925673] Code: ff 44 89 f3 41 0f af 5d 10 49 03 5d 08 48 8b 7b
> 10 48 85 ff 74 06 f6 47 2c 04 75 02 0f 0b 31 d2 4c 8d 47 28 89 e8 66
> 89 53 38 <f0> 0f c1 47 28 83 f8 01 0f 84 b5 00 00 00 85 c0 0f 8e b7 00
> 00 00
> [ 7203.944417] RSP: 0018:ff59ae67453ffce0 EFLAGS: 00010246
> [ 7203.949646] RAX: 00000000ffffffff RBX: ff2fabb3b5682000 RCX: 0000000000000000
> [ 7203.956778] RDX: 0000000000000000 RSI: ffffffffa324ee00 RDI: 0000000000000000
> [ 7203.963909] RBP: 00000000ffffffff R08: 0000000000000028 R09: ffffffffa36e33e0
> [ 7203.971042] R10: 0000000000000000 R11: 0000000000000000 R12: ff2fabb3ae44a468
> [ 7203.978174] R13: ff2fabb3ae44a000 R14: 0000000000000000 R15: ff2fabb3ce150080
> [ 7203.985307] FS:  00007fbed107c740(0000) GS:ff2fabb5af700000(0000)
> knlGS:0000000000000000
> [ 7203.993395] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 7203.999139] CR2: 0000000000000028 CR3: 000000011baa0004 CR4: 0000000000771ef0
> [ 7204.006274] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 7204.013405] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 7204.020537] PKRU: 55555554
> [ 7204.023250] Kernel panic - not syncing: Fatal exception
> [ 7204.028542] Kernel Offset: 0x20a00000 from 0xffffffff81000000
> (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> [ 7204.110552] ---[ end Kernel panic - not syncing: Fatal exception ]---
> 
> --
> Best Regards,
>       Changhui
> 
> 
> .

If ubq->ubq_daemon is NULL, WARN in ublk_queue_reinit() is triggered, and 
later NULL pointer dereference is triggered by:
   put_task_struct(ubq->ubq_daemon)

This issue might be triggered by two consecutive 
UBLK_CMD_START_USER_RECOVERY. I will try fix it soon.

-- 
Thanks,
Nan


