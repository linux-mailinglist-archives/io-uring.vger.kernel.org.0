Return-Path: <io-uring+bounces-7159-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2708BA6BD11
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 15:36:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 03D9F462DF9
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 14:34:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F7211D63DD;
	Fri, 21 Mar 2025 14:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SOzU+EH2"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5AEB17C219
	for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 14:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742567654; cv=none; b=Afx38/D1PYf1xVSgDVaORIG7xwpeARs/JQ6qhBeBDy3gI1ilRaW0QSqzbfqnXhpEUBKQc8V74A9hFKYru6LUdktOher/FSyVU44Dt82qPljt2L1DsoGidbj64T1wkTJF8STFEz1NAPsQXfymRqgMPissSHUrcX9cePYgslbEBdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742567654; c=relaxed/simple;
	bh=SbD6EDrQ2rMRpRgqoqY/WLRvvNJG1l6bqi95tj+fWZY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=YGwx+oBv+Khh9AeA5jeqyZ61esq1StZ8cOOywL4MdszCIsmOAB6v2qUhTQAhLZ8W63L1OHa3RHT6vy9zDyjG4YKqQurZDgy27l566fC57dUvQvuhm3Ld3lXRAVo6u/lg/A2TZBgGUDcThRFWNuJIaA2ROLfHXcIOK45LGbP33iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SOzU+EH2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742567649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=DaJYvjEf2ki/jjB1oGeAqye3GnRgmfkXyRtaulYg+20=;
	b=SOzU+EH2E7/sRchvoGWKcgvWZMPDL+pffpU5wnx02HDxXtHt1MOSQWmFVDNMhG11avmHo9
	G7egKAq6/1yRQ8exbV12NQxseiCrx4CVxd89r/XXDCojVhSPFNHE4m7yK0Q5igaRs1L7cf
	in/5xdn86Hq6RahrVZL2VZ+AuyvoGws=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-255-WLwyfcNLO4m-paVpzOV3Nw-1; Fri,
 21 Mar 2025 10:34:04 -0400
X-MC-Unique: WLwyfcNLO4m-paVpzOV3Nw-1
X-Mimecast-MFC-AGG-ID: WLwyfcNLO4m-paVpzOV3Nw_1742567643
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 67D0D190308B;
	Fri, 21 Mar 2025 14:34:03 +0000 (UTC)
Received: from fedora (unknown [10.72.120.2])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 61392180174E;
	Fri, 21 Mar 2025 14:33:58 +0000 (UTC)
Date: Fri, 21 Mar 2025 22:33:53 +0800
From: Ming Lei <ming.lei@redhat.com>
To: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: ming.lei@redhat.com
Subject: [bug] kernel panic when running ublk selftest on next-20250321
Message-ID: <Z9140ceHEytSh-sz@fedora>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Hello,

When running ublk selftest on today's next tree, the following kernel
panic is triggered immediately:

```
cd tools/testing/selftests/ublk/
make
./test_loop_01.sh
```

And not see this issue on next-0317.


ktest-40 login: [   35.406086] BUG: unable to handle page fault for address: fffffdf1ea10bc88
[   35.407360] #PF: supervisor read access in kernel mode
[   35.408259] #PF: error_code(0x0000) - not-present page
[   35.409138] PGD 0 P4D 0 
[   35.409596] Oops: Oops: 0000 [#1] SMP NOPTI
[   35.410620] CPU: 15 UID: 0 PID: 1661 Comm: kublk Not tainted 6.14.0-rc7_blk_dev-next-20250321+ #149 PREEMPT(full) 
[   35.412617] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-1.fc39 04/01/2014
[   35.414075] RIP: 0010:kfree+0x6f/0x300
[   35.414780] Code: 80 48 01 d8 0f 82 a1 02 00 00 48 c7 c2 00 00 00 80 48 2b 15 2b af a6 01 48 01 d0 48 c1 e8 0c 481
[   35.417874] RSP: 0018:ffffd0bbc358b880 EFLAGS: 00010282
[   35.418800] RAX: fffffdf1ea10bc80 RBX: fffffc35442f2740 RCX: ffff8d0bcc5e35a0
[   35.420100] RDX: 000072f4c0000000 RSI: ffffffff96a9f61a RDI: fffffc35442f2740
[   35.421372] RBP: ffffd0bbc358b8c8 R08: 0000000000000001 R09: 0000000000000014
[   35.422603] R10: 0000000000000001 R11: 0000000000000000 R12: ffff8d0bd18b60c0
[   35.423887] R13: 0000000000000000 R14: 00000000ffffffff R15: ffff8d0bcc5e2290
[   35.425166] FS:  00007fea81c526c0(0000) GS:ffff8d109219b000(0000) knlGS:0000000000000000
[   35.426568] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   35.427574] CR2: fffffdf1ea10bc88 CR3: 00000001083b6005 CR4: 0000000000772ef0
[   35.428714] PKRU: 55555554
[   35.429171] Call Trace:
[   35.429665]  <TASK>
[   35.430046]  ? __die_body.cold+0x19/0x29
[   35.430734]  ? page_fault_oops+0xc9/0x290
[   35.431442]  ? search_module_extables+0x44/0x60
[   35.432181]  ? kfree+0x6f/0x300
[   35.432707]  ? search_bpf_extables+0x5f/0x80
[   35.433405]  ? exc_page_fault+0x189/0x1a0
[   35.434083]  ? asm_exc_page_fault+0x26/0x30
[   35.434742]  ? io_vec_free+0x1a/0x30
[   35.435375]  ? kfree+0x6f/0x300
[   35.435885]  ? psi_group_change+0x13b/0x310
[   35.436578]  io_vec_free+0x1a/0x30
[   35.437163]  io_req_uring_cleanup+0xa6/0xb0
[   35.437836]  io_uring_cmd_done+0xca/0x1d0
[   35.438498]  io_handle_tw_list+0xe8/0xf0
[   35.439154]  tctx_task_work_run+0x51/0xe0
[   35.439917]  tctx_task_work+0x3a/0x60
[   35.440537]  task_work_run+0x59/0x90
[   35.441150]  io_run_task_work+0x4c/0x110
[   35.441816]  io_cqring_wait+0x36b/0x660
[   35.442503]  ? __pfx_io_wake_function+0x10/0x10
[   35.443259]  __do_sys_io_uring_enter+0x4f1/0x750
[   35.444023]  do_syscall_64+0x82/0x170
[   35.444644]  ? syscall_exit_to_user_mode+0x1d5/0x210
[   35.445939]  ? do_syscall_64+0x8e/0x170
[   35.446997]  ? __memcg_slab_post_alloc_hook+0x1f4/0x370
[   35.448272]  ? __kmalloc_noprof+0x456/0x490
[   35.449295]  ? io_cache_alloc_new+0x19/0x80
[   35.450432]  ? io_cache_alloc_new+0x19/0x80
[   35.451506]  ? io_cache_alloc_new+0x19/0x80
[   35.452602]  ? io_rsrc_node_alloc+0x5f/0x70
[   35.453613]  ? io_sqe_files_register+0x204/0x2f0
[   35.454719]  ? __do_sys_io_uring_register+0x129/0xa70
[   35.455901]  ? syscall_exit_to_user_mode+0x1d5/0x210
[   35.457036]  ? syscall_exit_to_user_mode+0x10/0x210
[   35.458236]  ? do_syscall_64+0x8e/0x170
[   35.459226]  ? handle_mm_fault+0x1b8/0x2c0
[   35.460319]  ? do_user_addr_fault+0x211/0x680
[   35.461399]  ? clear_bhb_loop+0x35/0x90
[   35.462373]  ? clear_bhb_loop+0x35/0x90
[   35.463315]  ? clear_bhb_loop+0x35/0x90
[   35.464281]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   35.465474] RIP: 0033:0x7fea8264b6fc
[   35.466422] Code: 0f b6 c0 48 8b 79 20 8b 3f 83 e7 01 44 0f 45 d0 41 83 ca 01 8b b9 cc 00 00 00 45 31 c0 41 b9 081
[   35.470085] RSP: 002b:00007fea81c51dc8 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
[   35.471641] RAX: ffffffffffffffda RBX: 000000003e33b4a8 RCX: 00007fea8264b6fc
[   35.473077] RDX: 0000000000000001 RSI: 0000000000000001 RDI: 0000000000000000
[   35.474524] RBP: 0000000000000080 R08: 0000000000000000 R09: 0000000000000008
[   35.475925] R10: 0000000000000011 R11: 0000000000000246 R12: 000000003e33b4a8
[   35.477837] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000020
[   35.479455]  </TASK>
[   35.480262] Modules linked in: ip6table_filter iptable_filter isofs intel_rapl_msr intel_rapl_common kvm_intel vfg
[   35.488958] Dumping ftrace buffer:
[   35.490009]    (ftrace buffer empty)
[   35.491043] CR2: fffffdf1ea10bc88
[   35.491946] ---[ end trace 0000000000000000 ]---
[   35.493618] RIP: 0010:kfree+0x6f/0x300
[   35.494707] Code: 80 48 01 d8 0f 82 a1 02 00 00 48 c7 c2 00 00 00 80 48 2b 15 2b af a6 01 48 01 d0 48 c1 e8 0c 481
[   35.498709] RSP: 0018:ffffd0bbc358b880 EFLAGS: 00010282
[   35.500093] RAX: fffffdf1ea10bc80 RBX: fffffc35442f2740 RCX: ffff8d0bcc5e35a0
[   35.501798] RDX: 000072f4c0000000 RSI: ffffffff96a9f61a RDI: fffffc35442f2740
[   35.503907] RBP: ffffd0bbc358b8c8 R08: 0000000000000001 R09: 0000000000000014
[   35.505605] R10: 0000000000000001 R11: 0000000000000000 R12: ffff8d0bd18b60c0
[   35.507362] R13: 0000000000000000 R14: 00000000ffffffff R15: ffff8d0bcc5e2290
[   35.509073] FS:  00007fea81c526c0(0000) GS:ffff8d109219b000(0000) knlGS:0000000000000000
[   35.511178] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   35.512891] CR2: fffffdf1ea10bc88 CR3: 00000001083b6005 CR4: 0000000000772ef0
[   35.514582] PKRU: 55555554
[   35.515538] Kernel panic - not syncing: Fatal exception
[   35.517350] Dumping ftrace buffer:
[   35.518403]    (ftrace buffer empty)
[   35.519900] Kernel Offset: 0x15000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbff)
[   35.522222] ---[ end Kernel panic - not syncing: Fatal exception ]---



Thanks,
Ming


