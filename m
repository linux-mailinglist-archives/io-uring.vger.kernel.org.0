Return-Path: <io-uring+bounces-3195-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF0F7979DDA
	for <lists+io-uring@lfdr.de>; Mon, 16 Sep 2024 11:07:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86801280FA3
	for <lists+io-uring@lfdr.de>; Mon, 16 Sep 2024 09:07:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F96D2D627;
	Mon, 16 Sep 2024 09:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="aDTDoKu1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7790413D2A9
	for <io-uring@vger.kernel.org>; Mon, 16 Sep 2024 09:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726477639; cv=none; b=hTGUj/+Txx2MDzRVL2+eui/yedyheX3S+gWpWhZ4ZJpAnMgYCP8qgIYBGtz5YeHfmHk20uBWT1J1BoWERqOVproWefXwQbE2TmR+TgdlJCDENjHoyS4O0HlatPJnUnmmvJdxOx+dB/yH1b4VrEVNPPeCMmb4XPm7CTO/xH2829U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726477639; c=relaxed/simple;
	bh=K0/bcpzPP/ik3qLF4f/iJ57AzCVqbutr7JeJGJ0025M=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=NqjtFd/WWkkuE30BaElwBSQa2P4a30yIeB+v89QnUicFIOj02pycDuTh6Q3nOGjD2rHd2OxXhB6QkXtZomFxAHWnyu9SeILTwJtVT9gqbzt3iEDPTqWNDlB7nKdAfE3p+cR2tCu8AUsZVhCeW2qI6resAGyhNAEmyq6SaDJrj1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=aDTDoKu1; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-2781cb2800eso2007797fac.1
        for <io-uring@vger.kernel.org>; Mon, 16 Sep 2024 02:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726477634; x=1727082434; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7iiSSlj3lK7wo/cwfO2uXkXxXhpRNKKpMDJkrbgkxEk=;
        b=aDTDoKu1vgL1280P2tYFNKxjPwOrzEhSh6n9LBgQ8K6NvZrGMfx4YQvyTmx51cmZJ6
         Qs2HIwb/XcPrGK6IT2uKaJxCIpkqGOdl3GmiJ8KvVsM+tG7vm5QDJQDUJ4/5EDGUMYX+
         SGbsB6vXAjSS1/bFiQXd8upp010UkthKYYB7cbyDk4rNBhqCyK8IESXvfdEYJ7KvgXQl
         ugHUwjNTajXyHjL8zR2hPeM/pEDgq3TgYTN31vGLJjkkLtexnwzR/eueIPfAod/dTSYb
         +OwZD/7NgtX7QZRAechfq838QqCiRjnNKPdkYQadivI5VPqeq6svOJQNl1R+gpMZOHX3
         51oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726477634; x=1727082434;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7iiSSlj3lK7wo/cwfO2uXkXxXhpRNKKpMDJkrbgkxEk=;
        b=s3fazgFT0wCh/xzbHS+CrIrS0TZ5vDVE2u/Znu1U7dTn7CfgnyTsBuoOG3fLr+7f6b
         /bBrdtY84e3NGfosOWcBvVI9nERIVlRB3NxC1xA+k3XM15/Q9MdbYrefx1LOcZ2B5ukI
         rNQL6WnHN+uT1Astf8RK9bX77k7k7vFRz70oXhJH6k5ryyCdO8Js34W+fttMLrFqHU1j
         Th/tkcO3OUQVWon5BoZtfz2bJrPOQboPQhblx0RcUaS537OgJUHLG1LFw0ieSzzUbPSg
         rS741I0xy9SvhzrLyvc61ezuQBaarOce5aRrnE7pretdKlmQLUbfsX9kv1JIigEWevez
         /doQ==
X-Gm-Message-State: AOJu0YwVw64WkO6LNx6NmvOn4aMj3JNkB/k/QPI8m8Af+npWY9o5n4nY
	a9KTV9qlXsMnhrv5u+ImSdc3ArAZy34oZ9W40uoykr+fiHgGfaACxrlMx+baKrZbBxXj82X0rRr
	2bQtPpg==
X-Google-Smtp-Source: AGHT+IGLZ53o7crsBSin7UzdsiKfUlWFIJJChxw5BKMG8AE7L0I+1kz918FC0g67guVVoU7b7qOTQg==
X-Received: by 2002:a05:6870:b487:b0:261:ab8:3de4 with SMTP id 586e51a60fabf-27c3f2c3d79mr7732776fac.15.1726477634255;
        Mon, 16 Sep 2024 02:07:14 -0700 (PDT)
Received: from ?IPV6:2600:380:6345:6937:6815:e2a7:e82c:fd22? ([2600:380:6345:6937:6815:e2a7:e82c:fd22])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-27c956732a3sm1482987fac.19.2024.09.16.02.07.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Sep 2024 02:07:12 -0700 (PDT)
Message-ID: <36b09a00-9f72-4ef2-8f73-79b2ba99b11c@kernel.dk>
Date: Mon, 16 Sep 2024 03:07:10 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/sqpoll: retain test for whether the CPU is valid
Cc: Felix Moessbauer <felix.moessbauer@siemens.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

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
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 272df9d00f45..7adfcf6818ff 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -465,6 +465,8 @@ __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
 			int cpu = p->sq_thread_cpu;
 
 			ret = -EINVAL;
+			if (cpu >= nr_cpu_ids || !cpu_online(cpu))
+				goto err_sqpoll;
 			cpuset_cpus_allowed(current, &allowed_mask);
 			if (!cpumask_test_cpu(cpu, &allowed_mask))
 				goto err_sqpoll;
-- 
Jens Axboe


