Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4092633D399
	for <lists+io-uring@lfdr.de>; Tue, 16 Mar 2021 13:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhCPMQJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Mar 2021 08:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbhCPMPg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Mar 2021 08:15:36 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B73F2C06174A;
        Tue, 16 Mar 2021 05:15:33 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id w203-20020a1c49d40000b029010c706d0642so3728442wma.0;
        Tue, 16 Mar 2021 05:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XnSeD1ClBK6yFUlBTu3izdxWGDr36u22K7NkA3Yo+uU=;
        b=pnnGJRXh2qlKYmVSvw/dQ6bFybn8MvLwRNJgxORBOoVz6WxzBVc7qctC+4CnuWbfyd
         LvnKcuL2clDY1cTuuO6YyNrfGGO3aJXRwtQ9+m3Rylwyx6xg/KA/PgDuD2KsYPAOCmii
         Pc8o/GhYwJsxvL+oSH2h2INrL/lY01wjxUa0gXTPgA+PTgRJ7quCVk+7JJmA05UN/vv3
         1tJwmgdSGt1FHnllfn7U3ZjYP52kfkXoIEYvkXkLPh2pim4EJSJWKw++MZWaj+Cy506B
         L1g+t/nePCBE0iGzeWBSgV163aAslCewgPOXRi1VbbLZDGsIF+HGF9xmJA2lrIQfszG8
         YGlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=XnSeD1ClBK6yFUlBTu3izdxWGDr36u22K7NkA3Yo+uU=;
        b=sarxEofjM9VCh5HgSCHCoazg4HwSk18fFV9BCciwgbbVUCX/CPWPiSBjevseyJ3YN+
         BCLXt7t5BnvPPCkhfyMAXx8Za0THAGSMVD7gBgecOY/Wr/dkafJs787zLGRsbPNy7fNp
         GNBqNp+E2GpQ81EfqCc4yT8oVlYNFTf5D87hbMO0gaEdBYZ6okSL2r8sC0rDGpKi4/2a
         Kd2Mb4KGoNzchcbDOCsry/q8dZq0PsFFCle3wDLRPh/gr1wgCckXFd1jH/SRoxO7Lr7h
         aZ8M8SuCdB9ANYzjaQLKDRdPAgGwp4qhtiiCQXw+dcVkMDnMW3WptJKKKSVLD1/7KwAw
         QeZQ==
X-Gm-Message-State: AOAM533jt3LNU2gutilJIf+p7stLrJR2glwVI+Hhh/qzHVZGYlt0d8z7
        n43n55ZctMxhhHY0EVGLRpZftSXgNMN5aQ==
X-Google-Smtp-Source: ABdhPJwiudEbtAb5b7kbJbMlx9rRS/J/wYkRY7CvjLUxcHsDF85Mir59I5fvwCLRctlBEzt5jlRVjA==
X-Received: by 2002:a1c:7407:: with SMTP id p7mr4460329wmc.51.1615896932114;
        Tue, 16 Mar 2021 05:15:32 -0700 (PDT)
Received: from [192.168.8.161] ([148.252.132.232])
        by smtp.gmail.com with ESMTPSA id c131sm2956937wma.37.2021.03.16.05.15.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Mar 2021 05:15:31 -0700 (PDT)
To:     Jordy Zomer <jordy@pwning.systems>, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210315174425.2201225-1-jordy@pwning.systems>
 <65a85dd1-a9b0-30a1-13b9-559270f31264@gmail.com>
 <C9Y4IZVSXPB4.2JLCVAHTL4CCI@pwning.systems>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] Fix use-after-free in io_wqe_inc_running() due to wq
 already being free'd
Message-ID: <8a506aa2-eada-1d77-c2d7-f7599c5c8094@gmail.com>
Date:   Tue, 16 Mar 2021 12:11:33 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <C9Y4IZVSXPB4.2JLCVAHTL4CCI@pwning.systems>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 15/03/2021 18:08, Jordy Zomer wrote:
> Thank you for your response Pavel!

Thanks, doesn't trigger any problem for me in rc3+

commit 886d0137f104a440d9dfa1d16efc1db06c9a2c02
Author: Jens Axboe <axboe@kernel.dk>
Date:   Fri Mar 5 12:59:30 2021 -0700

    io-wq: fix race in freeing 'wq' and worker access


Maybe was fixed by it or some other commit. Can you confirm that it's
gone in rc3? or git://git.kernel.dk/linux-block io_uring-5.12

> 
> this is the report:
> 
> 	Syzkaller hit 'KASAN: use-after-free Write in io_wqe_inc_running' bug.
> 
> 	==================================================================
> 	BUG: KASAN: use-after-free in io_wqe_inc_running+0x82/0xb0
> 	Write of size 4 at addr ffff8881015ed058 by task iou-wrk-486/488
> 
> 	CPU: 1 PID: 488 Comm: iou-wrk-486 Not tainted 5.12.0-rc2 #1
> 	Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1 04/01/2014
> 	Call Trace:
> 	 dump_stack+0x103/0x183
> 	 print_address_description.constprop.0+0x1a/0x140
> 	 kasan_report.cold+0x7f/0x111
> 	 kasan_check_range+0x17c/0x1e0
> 	 io_wqe_inc_running+0x82/0xb0
> 	 io_wq_worker_running+0xb9/0xe0
> 	 schedule_timeout+0x487/0x730
> 	 io_wqe_worker+0x3be/0xc90
> 	 ret_from_fork+0x22/0x30
> 
> 	Allocated by task 486:
> 	 kasan_save_stack+0x1b/0x40
> 	 __kasan_kmalloc+0x99/0xc0
> 	 io_wq_create+0x6ad/0xc60
> 	 io_uring_alloc_task_context+0x1bd/0x6b0
> 	 io_uring_add_task_file+0x203/0x290
> 	 io_uring_setup+0x1372/0x26f0
> 	 do_syscall_64+0x33/0x40
> 	 entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> 	Freed by task 486:
> 	 kasan_save_stack+0x1b/0x40
> 	 kasan_set_track+0x1c/0x30
> 	 kasan_set_free_info+0x20/0x30
> 	 __kasan_slab_free+0x100/0x130
> 	 kfree+0xab/0x240
> 	 io_wq_put+0x15e/0x2f0
> 	 io_uring_clean_tctx+0x18b/0x220
> 	 __io_uring_files_cancel+0x151/0x1b0
> 	 do_exit+0x27f/0x2990
> 	 do_group_exit+0x113/0x340
> 	 __x64_sys_exit_group+0x3a/0x50
> 	 do_syscall_64+0x33/0x40
> 	 entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> 	The buggy address belongs to the object at ffff8881015ed000
> 	 which belongs to the cache kmalloc-1k of size 1024
> 	The buggy address is located 88 bytes inside of
> 	 1024-byte region [ffff8881015ed000, ffff8881015ed400)
> 	The buggy address belongs to the page:
> 	page:0000000021df10c3 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1015e8
> 	head:0000000021df10c3 order:3 compound_mapcount:0 compound_pincount:0
> 	flags: 0x200000000010200(slab|head)
> 	raw: 0200000000010200 dead000000000100 dead000000000122 ffff888100041dc0
> 	raw: 0000000000000000 0000000080100010 00000001ffffffff 0000000000000000
> 	page dumped because: kasan: bad access detected
> 
> 	Memory state around the buggy address:
> 	 ffff8881015ecf00: fc fc fc fc fc fc fc fc fc fc f fc fc fc fc fc
> 	 ffff8881015ecf80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> 	>ffff8881015ed000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> 							    ^
> 	 ffff8881015ed080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> 	 ffff8881015ed100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> 	==================================================================
> 
> 
> Apparently io_uring_clean_tctx() sets wq to NULL, therefore I thought it should be worth checking for.
> 
> Below you can find the reproducer:
> 
> 	#define _GNU_SOURCE 
> 
> 	#include <dirent.h>
> 	#include <endian.h>
> 	#include <errno.h>
> 	#include <fcntl.h>
> 	#include <signal.h>
> 	#include <stdarg.h>
> 	#include <stdbool.h>
> 	#include <stdint.h>
> 	#include <stdio.h>
> 	#include <stdlib.h>
> 	#include <string.h>
> 	#include <sys/mman.h>
> 	#include <sys/prctl.h>
> 	#include <sys/stat.h>
> 	#include <sys/syscall.h>
> 	#include <sys/types.h>
> 	#include <sys/wait.h>
> 	#include <time.h>
> 	#include <unistd.h>
> 
> 	static void sleep_ms(uint64_t ms)
> 	{
> 		usleep(ms * 1000);
> 	}
> 
> 	static uint64_t current_time_ms(void)
> 	{
> 		struct timespec ts;
> 		if (clock_gettime(CLOCK_MONOTONIC, &ts))
> 		exit(1);
> 		return (uint64_t)ts.tv_sec * 1000 + (uint64_t)ts.tv_nsec / 1000000;
> 	}
> 
> 	static bool write_file(const char* file, const char* what, ...)
> 	{
> 		char buf[1024];
> 		va_list args;
> 		va_start(args, what);
> 		vsnprintf(buf, sizeof(buf), what, args);
> 		va_end(args);
> 		buf[sizeof(buf) - 1] = 0;
> 		int len = strlen(buf);
> 		int fd = open(file, O_WRONLY | O_CLOEXEC);
> 		if (fd == -1)
> 			return false;
> 		if (write(fd, buf, len) != len) {
> 			int err = errno;
> 			close(fd);
> 			errno = err;
> 			return false;
> 		}
> 		close(fd);
> 		return true;
> 	}
> 
> 	#define SIZEOF_IO_URING_SQE 64
> 	#define SIZEOF_IO_URING_CQE 16
> 	#define SQ_HEAD_OFFSET 0
> 	#define SQ_TAIL_OFFSET 64
> 	#define SQ_RING_MASK_OFFSET 256
> 	#define SQ_RING_ENTRIES_OFFSET 264
> 	#define SQ_FLAGS_OFFSET 276
> 	#define SQ_DROPPED_OFFSET 272
> 	#define CQ_HEAD_OFFSET 128
> 	#define CQ_TAIL_OFFSET 192
> 	#define CQ_RING_MASK_OFFSET 260
> 	#define CQ_RING_ENTRIES_OFFSET 268
> 	#define CQ_RING_OVERFLOW_OFFSET 284
> 	#define CQ_FLAGS_OFFSET 280
> 	#define CQ_CQES_OFFSET 320
> 
> 	struct io_sqring_offsets {
> 		uint32_t head;
> 		uint32_t tail;
> 		uint32_t ring_mask;
> 		uint32_t ring_entries;
> 		uint32_t flags;
> 		uint32_t dropped;
> 		uint32_t array;
> 		uint32_t resv1;
> 		uint64_t resv2;
> 	};
> 
> 	struct io_cqring_offsets {
> 		uint32_t head;
> 		uint32_t tail;
> 		uint32_t ring_mask;
> 		uint32_t ring_entries;
> 		uint32_t overflow;
> 		uint32_t cqes;
> 		uint64_t resv[2];
> 	};
> 
> 	struct io_uring_params {
> 		uint32_t sq_entries;
> 		uint32_t cq_entries;
> 		uint32_t flags;
> 		uint32_t sq_thread_cpu;
> 		uint32_t sq_thread_idle;
> 		uint32_t features;
> 		uint32_t resv[4];
> 		struct io_sqring_offsets sq_off;
> 		struct io_cqring_offsets cq_off;
> 	};
> 
> 	#define IORING_OFF_SQ_RING 0
> 	#define IORING_OFF_SQES 0x10000000ULL
> 
> 	#define sys_io_uring_setup 425
> 	static long syz_io_uring_setup(volatile long a0, volatile long a1, volatile long a2, volatile long a3, volatile long a4, volatile long a5)
> 	{
> 		uint32_t entries = (uint32_t)a0;
> 		struct io_uring_params* setup_params = (struct io_uring_params*)a1;
> 		void* vma1 = (void*)a2;
> 		void* vma2 = (void*)a3;
> 		void** ring_ptr_out = (void**)a4;
> 		void** sqes_ptr_out = (void**)a5;
> 		uint32_t fd_io_uring = syscall(sys_io_uring_setup, entries, setup_params);
> 		uint32_t sq_ring_sz = setup_params->sq_off.array + setup_params->sq_entries * sizeof(uint32_t);
> 		uint32_t cq_ring_sz = setup_params->cq_off.cqes + setup_params->cq_entries * SIZEOF_IO_URING_CQE;
> 		uint32_t ring_sz = sq_ring_sz > cq_ring_sz ? sq_ring_sz : cq_ring_sz;
> 		*ring_ptr_out = mmap(vma1, ring_sz, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE | MAP_FIXED, fd_io_uring, IORING_OFF_SQ_RING);
> 		uint32_t sqes_sz = setup_params->sq_entries * SIZEOF_IO_URING_SQE;
> 		*sqes_ptr_out = mmap(vma2, sqes_sz, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE | MAP_FIXED, fd_io_uring, IORING_OFF_SQES);
> 		return fd_io_uring;
> 	}
> 
> 	static long syz_io_uring_submit(volatile long a0, volatile long a1, volatile long a2, volatile long a3)
> 	{
> 		char* ring_ptr = (char*)a0;
> 		char* sqes_ptr = (char*)a1;
> 		char* sqe = (char*)a2;
> 		uint32_t sqes_index = (uint32_t)a3;
> 		uint32_t sq_ring_entries = *(uint32_t*)(ring_ptr + SQ_RING_ENTRIES_OFFSET);
> 		uint32_t cq_ring_entries = *(uint32_t*)(ring_ptr + CQ_RING_ENTRIES_OFFSET);
> 		uint32_t sq_array_off = (CQ_CQES_OFFSET + cq_ring_entries * SIZEOF_IO_URING_CQE + 63) & ~63;
> 		if (sq_ring_entries)
> 			sqes_index %= sq_ring_entries;
> 		char* sqe_dest = sqes_ptr + sqes_index * SIZEOF_IO_URING_SQE;
> 		memcpy(sqe_dest, sqe, SIZEOF_IO_URING_SQE);
> 		uint32_t sq_ring_mask = *(uint32_t*)(ring_ptr + SQ_RING_MASK_OFFSET);
> 		uint32_t* sq_tail_ptr = (uint32_t*)(ring_ptr + SQ_TAIL_OFFSET);
> 		uint32_t sq_tail = *sq_tail_ptr & sq_ring_mask;
> 		uint32_t sq_tail_next = *sq_tail_ptr + 1;
> 		uint32_t* sq_array = (uint32_t*)(ring_ptr + sq_array_off);
> 		*(sq_array + sq_tail) = sqes_index;
> 		__atomic_store_n(sq_tail_ptr, sq_tail_next, __ATOMIC_RELEASE);
> 		return 0;
> 	}
> 
> 	static void kill_and_wait(int pid, int* status)
> 	{
> 		kill(-pid, SIGKILL);
> 		kill(pid, SIGKILL);
> 		for (int i = 0; i < 100; i++) {
> 			if (waitpid(-1, status, WNOHANG | __WALL) == pid)
> 				return;
> 			usleep(1000);
> 		}
> 		DIR* dir = opendir("/sys/fs/fuse/connections");
> 		if (dir) {
> 			for (;;) {
> 				struct dirent* ent = readdir(dir);
> 				if (!ent)
> 					break;
> 				if (strcmp(ent->d_name, ".") == 0 || strcmp(ent->d_name, "..") == 0)
> 					continue;
> 				char abort[300];
> 				snprintf(abort, sizeof(abort), "/sys/fs/fuse/connections/%s/abort", ent->d_name);
> 				int fd = open(abort, O_WRONLY);
> 				if (fd == -1) {
> 					continue;
> 				}
> 				if (write(fd, abort, 1) < 0) {
> 				}
> 				close(fd);
> 			}
> 			closedir(dir);
> 		} else {
> 		}
> 		while (waitpid(-1, status, __WALL) != pid) {
> 		}
> 	}
> 
> 	static void setup_test()
> 	{
> 		prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0);
> 		setpgrp();
> 		write_file("/proc/self/oom_score_adj", "1000");
> 	}
> 
> 	static void execute_one(void);
> 
> 	#define WAIT_FLAGS __WALL
> 
> 	static void loop(void)
> 	{
> 		int iter = 0;
> 		for (;; iter++) {
> 			int pid = fork();
> 			if (pid < 0)
> 		exit(1);
> 			if (pid == 0) {
> 				setup_test();
> 				execute_one();
> 				exit(0);
> 			}
> 			int status = 0;
> 			uint64_t start = current_time_ms();
> 			for (;;) {
> 				if (waitpid(-1, &status, WNOHANG | WAIT_FLAGS) == pid)
> 					break;
> 				sleep_ms(1);
> 			if (current_time_ms() - start < 5000) {
> 				continue;
> 			}
> 				kill_and_wait(pid, &status);
> 				break;
> 			}
> 		}
> 	}
> 
> 	#ifndef __NR_execveat
> 	#define __NR_execveat 322
> 	#endif
> 	#ifndef __NR_io_uring_enter
> 	#define __NR_io_uring_enter 426
> 	#endif
> 	#ifndef __NR_io_uring_register
> 	#define __NR_io_uring_register 427
> 	#endif
> 
> 	uint64_t r[3] = {0xffffffffffffffff, 0x0, 0x0};
> 
> 	void execute_one(void)
> 	{
> 			intptr_t res = 0;
> 	*(uint32_t*)0x20000004 = 0;
> 	*(uint32_t*)0x20000008 = 0;
> 	*(uint32_t*)0x2000000c = 0;
> 	*(uint32_t*)0x20000010 = 0;
> 	*(uint32_t*)0x20000018 = -1;
> 	*(uint32_t*)0x2000001c = 0;
> 	*(uint32_t*)0x20000020 = 0;
> 	*(uint32_t*)0x20000024 = 0;
> 		res = -1;
> 	res = syz_io_uring_setup(0x1e1b, 0x20000000, 0x200a0000, 0x20ffb000, 0x20000080, 0x200000c0);
> 		if (res != -1) {
> 			r[0] = res;
> 	r[1] = *(uint64_t*)0x20000080;
> 	r[2] = *(uint64_t*)0x200000c0;
> 		}
> 	*(uint8_t*)0x20000640 = 0x1e;
> 	*(uint8_t*)0x20000641 = 0;
> 	*(uint16_t*)0x20000642 = 0;
> 	*(uint32_t*)0x20000644 = r[0];
> 	*(uint64_t*)0x20000648 = 0;
> 	*(uint32_t*)0x20000650 = 0;
> 	*(uint32_t*)0x20000654 = -1;
> 	*(uint32_t*)0x20000658 = 0;
> 	*(uint32_t*)0x2000065c = 0;
> 	*(uint64_t*)0x20000660 = 0;
> 	*(uint16_t*)0x20000668 = 0;
> 	*(uint16_t*)0x2000066a = 0;
> 	*(uint32_t*)0x2000066c = r[0];
> 	*(uint64_t*)0x20000670 = 0;
> 	*(uint64_t*)0x20000678 = 0;
> 	syz_io_uring_submit(r[1], r[2], 0x20000640, 0);
> 		syscall(__NR_io_uring_enter, r[0], 0xfffffffe, 0, 0ul, 0ul, 0ul);
> 		syscall(__NR_io_uring_register, r[0], 0xaul, 0ul, 0);
> 	memcpy((void*)0x20000280, "./file1\000", 8);
> 		syscall(__NR_execveat, 0xffffff9c, 0x20000280ul, 0ul, 0ul, 0ul);
> 
> 	}
> 	int main(void)
> 	{
> 			syscall(__NR_mmap, 0x1ffff000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
> 		syscall(__NR_mmap, 0x20000000ul, 0x1000000ul, 7ul, 0x32ul, -1, 0ul);
> 		syscall(__NR_mmap, 0x21000000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
> 				loop();
> 		return 0;
> 	}
> 
> 
> Hope that helped!
> 
> Best Regards,
> 
> Jordy
> 
> On Mon Mar 15, 2021 at 6:58 PM CET, Pavel Begunkov wrote:
>> On 15/03/2021 17:44, Jordy Zomer wrote:
>>> My syzkaller instance reported a use-after-free bug in io_wqe_inc_running.
>>> I tried fixing this by checking if wq isn't NULL in io_wqe_worker.
>>> If it does; return an -EFAULT. This because create_io_worker() will clean-up the worker if there's an error.
>>>
>>> If you want I could send you the syzkaller reproducer and crash-logs :)
>>
>> Yes, please.
>>
>> Haven't looked up properly, but looks that wq==NULL should
>> never happen, so the fix is a bit racy.
>>
>>>
>>> Best Regards,
>>>
>>> Jordy Zomer
>>>
>>> Signed-off-by: Jordy Zomer <jordy@pwning.systems>
>>> ---
>>>  fs/io-wq.c | 4 ++++
>>>  1 file changed, 4 insertions(+)
>>>
>>> diff --git a/fs/io-wq.c b/fs/io-wq.c
>>> index 0ae9ecadf295..9ed92d88a088 100644
>>> --- a/fs/io-wq.c
>>> +++ b/fs/io-wq.c
>>> @@ -482,6 +482,10 @@ static int io_wqe_worker(void *data)
>>>  	char buf[TASK_COMM_LEN];
>>>  
>>>  	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
>>> +
>>> +	if (wq == NULL)
>>> +		return -EFAULT;
>>> +
>>>  	io_wqe_inc_running(worker);
>>>  
>>>  	sprintf(buf, "iou-wrk-%d", wq->task_pid);
>>>
>>
>> --
>> Pavel Begunkov
> 

-- 
Pavel Begunkov
