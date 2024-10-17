Return-Path: <io-uring+bounces-3772-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A92D59A216D
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 13:51:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F54A2892ED
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 11:51:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 658421DA113;
	Thu, 17 Oct 2024 11:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=felix.moessbauer@siemens.com header.b="LJ0um/nV"
X-Original-To: io-uring@vger.kernel.org
Received: from mta-65-227.siemens.flowmailer.net (mta-65-227.siemens.flowmailer.net [185.136.65.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335F31D4173
	for <io-uring@vger.kernel.org>; Thu, 17 Oct 2024 11:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.136.65.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729165873; cv=none; b=l+mSSi6R409Sio2L88S1+Z+bEFyIZCE9yOPOvSbhAp2SIy+xdLlHPNJTVeQU+YeJI9baQ+g5pAVuKp/NePFDIIJu7tbI9c7CNQ2olnVu4I+C+nCbAMLXYSO7cN88N7Bc+kupSYIEtjo1Jsn/jpFIM8GJ4nfHDQkP0guxfhgCHdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729165873; c=relaxed/simple;
	bh=BvlT8Bj1/037cUewa0hHnmYjbLsPmkVCgq+QJY1rApo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EwJPyR22M94P4vyqC4CDb0yo7dz6r5GZ2Cj8ob/HotKX+nt8DxeaismgbbFSMajgIZBzUu83sNVG6qLdFD5MSMeVtsMt3BOHYBPqUhkO551RoOS1viTeA2xnBHg5fj88OYjYezQp4fd7hZBDuEBp7Hi3wLBX8dwY02IZl+g22Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=rts-flowmailer.siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=felix.moessbauer@siemens.com header.b=LJ0um/nV; arc=none smtp.client-ip=185.136.65.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rts-flowmailer.siemens.com
Received: by mta-65-227.siemens.flowmailer.net with ESMTPSA id 20241017115100f1b3860b606210027a
        for <io-uring@vger.kernel.org>;
        Thu, 17 Oct 2024 13:51:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; s=fm1;
 d=siemens.com; i=felix.moessbauer@siemens.com;
 h=Date:From:Subject:To:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Cc:References:In-Reply-To;
 bh=xehMTjjkfTLF9mI9dDqz4sbMLUpydX86XmxXhzZ/5JE=;
 b=LJ0um/nVIFDxccPSxh9QB8166XGVgff29EnyLaOIarw3ANc1VQZ63WY3BC12AnEeQ9pJr0
 TL9V5Dk6mXkLamyytfJI/88pLMtj5uNPFlEoJiJE5hAyrpTDF7FVslwz6uFR6UvVehCA26fT
 eDmZyOukPXe91cHZTIyK8LSCQzqyvlh+QGqb94vPxtmcK4kcTSJ/yNkcl2OW+ZLsdQy6AoKX
 Vj6+lya8AAPQBbPnko5je8flI5ahlXvJ8Wyi/1gWDxt4/KvLepaXv1Y+Rmhp3PlL09Zsp8dx
 bx8EszO/0wgvBJym3Dceg3P+FHCGPhuzhwet05WhIcloQSiexivUKsMw==;
From: Felix Moessbauer <felix.moessbauer@siemens.com>
To: stable@vger.kernel.org
Cc: io-uring@vger.kernel.org,
	axboe@kernel.dk,
	gregkh@linuxfoundation.org,
	kernel test robot <oliver.sang@intel.com>,
	Felix Moessbauer <felix.moessbauer@siemens.com>
Subject: [PATCH 5.10 5.15 2/3] io_uring/sqpoll: retain test for whether the CPU is valid
Date: Thu, 17 Oct 2024 13:50:28 +0200
Message-Id: <20241017115029.178246-2-felix.moessbauer@siemens.com>
In-Reply-To: <20241017115029.178246-1-felix.moessbauer@siemens.com>
References: <20241017115029.178246-1-felix.moessbauer@siemens.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Flowmailer-Platform: Siemens
Feedback-ID: 519:519-1321639:519-21489:flowmailer

From: Jens Axboe <axboe@kernel.dk>

commit a09c17240bdf2e9fa6d0591afa9448b59785f7d4 upstream.

A recent commit ensured that SQPOLL cannot be setup with a CPU that
isn't in the current tasks cpuset, but it also dropped testing whether
the CPU is valid in the first place. Without that, if a task passes in
a CPU value that is too high, the following KASAN splat can get
triggered:

BUG: KASAN: stack-out-of-bounds in io_sq_offload_create+0x858/0xaa4
Read of size 8 at addr ffff800089bc7b90 by task wq-aff.t/1391

CPU: 4 UID: 1000 PID: 1391 Comm: wq-aff.t Not tainted 6.11.0-rc7-00227-g371c468f4db6 #7080
Hardware name: linux,dummy-virt (DT)
Call trace:
 dump_backtrace.part.0+0xcc/0xe0
 show_stack+0x14/0x1c
 dump_stack_lvl+0x58/0x74
 print_report+0x16c/0x4c8
 kasan_report+0x9c/0xe4
 __asan_report_load8_noabort+0x1c/0x24
 io_sq_offload_create+0x858/0xaa4
 io_uring_setup+0x1394/0x17c4
 __arm64_sys_io_uring_setup+0x6c/0x180
 invoke_syscall+0x6c/0x260
 el0_svc_common.constprop.0+0x158/0x224
 do_el0_svc+0x3c/0x5c
 el0_svc+0x34/0x70
 el0t_64_sync_handler+0x118/0x124
 el0t_64_sync+0x168/0x16c

The buggy address belongs to stack of task wq-aff.t/1391
 and is located at offset 48 in frame:
 io_sq_offload_create+0x0/0xaa4

This frame has 1 object:
 [32, 40) 'allowed_mask'

The buggy address belongs to the virtual mapping at
 [ffff800089bc0000, ffff800089bc9000) created by:
 kernel_clone+0x124/0x7e0

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff0000d740af80 pfn:0x11740a
memcg:ffff0000c2706f02
flags: 0xbffe00000000000(node=0|zone=2|lastcpupid=0x1fff)
raw: 0bffe00000000000 0000000000000000 dead000000000122 0000000000000000
raw: ffff0000d740af80 0000000000000000 00000001ffffffff ffff0000c2706f02
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff800089bc7a80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff800089bc7b00: 00 00 00 00 00 00 00 00 00 00 00 00 f1 f1 f1 f1
>ffff800089bc7b80: 00 f3 f3 f3 00 00 00 00 00 00 00 00 00 00 00 00
                         ^
 ffff800089bc7c00: 00 00 00 00 00 00 00 00 00 00 00 00 f1 f1 f1 f1
 ffff800089bc7c80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 f3

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202409161632.cbeeca0d-lkp@intel.com
Fixes: f011c9cf04c0 ("io_uring/sqpoll: do not allow pinning outside of cpuset")
Tested-by: Felix Moessbauer <felix.moessbauer@siemens.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Felix Moessbauer <felix.moessbauer@siemens.com>
---
 io_uring/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6b6fd244233f8..a260852a0490c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -8751,6 +8751,8 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 			int cpu = p->sq_thread_cpu;
 
 			ret = -EINVAL;
+			if (cpu >= nr_cpu_ids || !cpu_online(cpu))
+				goto err_sqpoll;
 			cpuset_cpus_allowed(current, &allowed_mask);
 			if (!cpumask_test_cpu(cpu, &allowed_mask))
 				goto err_sqpoll;
-- 
2.39.5


