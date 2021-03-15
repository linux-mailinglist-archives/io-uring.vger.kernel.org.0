Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF2E733C542
	for <lists+io-uring@lfdr.de>; Mon, 15 Mar 2021 19:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232402AbhCOSIT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Mon, 15 Mar 2021 14:08:19 -0400
Received: from h2.fbrelay.privateemail.com ([131.153.2.43]:40993 "EHLO
        h2.fbrelay.privateemail.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232081AbhCOSIH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Mar 2021 14:08:07 -0400
Received: from MTA-07-4.privateemail.com (mta-07.privateemail.com [198.54.127.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by h1.fbrelay.privateemail.com (Postfix) with ESMTPS id 9FB7B81819;
        Mon, 15 Mar 2021 14:08:06 -0400 (EDT)
Received: from MTA-07.privateemail.com (localhost [127.0.0.1])
        by MTA-07.privateemail.com (Postfix) with ESMTP id B00C0600C5;
        Mon, 15 Mar 2021 14:08:05 -0400 (EDT)
Received: from localhost (unknown [10.20.151.211])
        by MTA-07.privateemail.com (Postfix) with ESMTPA id C25D960066;
        Mon, 15 Mar 2021 14:08:04 -0400 (EDT)
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 15 Mar 2021 19:08:03 +0100
Message-Id: <C9Y4IZVSXPB4.2JLCVAHTL4CCI@pwning.systems>
Cc:     <io-uring@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix use-after-free in io_wqe_inc_running() due to wq
 already being free'd
From:   "Jordy Zomer" <jordy@pwning.systems>
To:     "Pavel Begunkov" <asml.silence@gmail.com>, <axboe@kernel.dk>
References: <20210315174425.2201225-1-jordy@pwning.systems>
 <65a85dd1-a9b0-30a1-13b9-559270f31264@gmail.com>
In-Reply-To: <65a85dd1-a9b0-30a1-13b9-559270f31264@gmail.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Thank you for your response Pavel!


this is the report:

	Syzkaller hit 'KASAN: use-after-free Write in io_wqe_inc_running' bug.

	==================================================================
	BUG: KASAN: use-after-free in io_wqe_inc_running+0x82/0xb0
	Write of size 4 at addr ffff8881015ed058 by task iou-wrk-486/488

	CPU: 1 PID: 488 Comm: iou-wrk-486 Not tainted 5.12.0-rc2 #1
	Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1 04/01/2014
	Call Trace:
	 dump_stack+0x103/0x183
	 print_address_description.constprop.0+0x1a/0x140
	 kasan_report.cold+0x7f/0x111
	 kasan_check_range+0x17c/0x1e0
	 io_wqe_inc_running+0x82/0xb0
	 io_wq_worker_running+0xb9/0xe0
	 schedule_timeout+0x487/0x730
	 io_wqe_worker+0x3be/0xc90
	 ret_from_fork+0x22/0x30

	Allocated by task 486:
	 kasan_save_stack+0x1b/0x40
	 __kasan_kmalloc+0x99/0xc0
	 io_wq_create+0x6ad/0xc60
	 io_uring_alloc_task_context+0x1bd/0x6b0
	 io_uring_add_task_file+0x203/0x290
	 io_uring_setup+0x1372/0x26f0
	 do_syscall_64+0x33/0x40
	 entry_SYSCALL_64_after_hwframe+0x44/0xae

	Freed by task 486:
	 kasan_save_stack+0x1b/0x40
	 kasan_set_track+0x1c/0x30
	 kasan_set_free_info+0x20/0x30
	 __kasan_slab_free+0x100/0x130
	 kfree+0xab/0x240
	 io_wq_put+0x15e/0x2f0
	 io_uring_clean_tctx+0x18b/0x220
	 __io_uring_files_cancel+0x151/0x1b0
	 do_exit+0x27f/0x2990
	 do_group_exit+0x113/0x340
	 __x64_sys_exit_group+0x3a/0x50
	 do_syscall_64+0x33/0x40
	 entry_SYSCALL_64_after_hwframe+0x44/0xae

	The buggy address belongs to the object at ffff8881015ed000
	 which belongs to the cache kmalloc-1k of size 1024
	The buggy address is located 88 bytes inside of
	 1024-byte region [ffff8881015ed000, ffff8881015ed400)
	The buggy address belongs to the page:
	page:0000000021df10c3 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1015e8
	head:0000000021df10c3 order:3 compound_mapcount:0 compound_pincount:0
	flags: 0x200000000010200(slab|head)
	raw: 0200000000010200 dead000000000100 dead000000000122 ffff888100041dc0
	raw: 0000000000000000 0000000080100010 00000001ffffffff 0000000000000000
	page dumped because: kasan: bad access detected

	Memory state around the buggy address:
	 ffff8881015ecf00: fc fc fc fc fc fc fc fc fc fc f fc fc fc fc fc
	 ffff8881015ecf80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
	>ffff8881015ed000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
							    ^
	 ffff8881015ed080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
	 ffff8881015ed100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
	==================================================================


Apparently io_uring_clean_tctx() sets wq to NULL, therefore I thought it should be worth checking for.

Below you can find the reproducer:

	#define _GNU_SOURCE 

	#include <dirent.h>
	#include <endian.h>
	#include <errno.h>
	#include <fcntl.h>
	#include <signal.h>
	#include <stdarg.h>
	#include <stdbool.h>
	#include <stdint.h>
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include <sys/mman.h>
	#include <sys/prctl.h>
	#include <sys/stat.h>
	#include <sys/syscall.h>
	#include <sys/types.h>
	#include <sys/wait.h>
	#include <time.h>
	#include <unistd.h>

	static void sleep_ms(uint64_t ms)
	{
		usleep(ms * 1000);
	}

	static uint64_t current_time_ms(void)
	{
		struct timespec ts;
		if (clock_gettime(CLOCK_MONOTONIC, &ts))
		exit(1);
		return (uint64_t)ts.tv_sec * 1000 + (uint64_t)ts.tv_nsec / 1000000;
	}

	static bool write_file(const char* file, const char* what, ...)
	{
		char buf[1024];
		va_list args;
		va_start(args, what);
		vsnprintf(buf, sizeof(buf), what, args);
		va_end(args);
		buf[sizeof(buf) - 1] = 0;
		int len = strlen(buf);
		int fd = open(file, O_WRONLY | O_CLOEXEC);
		if (fd == -1)
			return false;
		if (write(fd, buf, len) != len) {
			int err = errno;
			close(fd);
			errno = err;
			return false;
		}
		close(fd);
		return true;
	}

	#define SIZEOF_IO_URING_SQE 64
	#define SIZEOF_IO_URING_CQE 16
	#define SQ_HEAD_OFFSET 0
	#define SQ_TAIL_OFFSET 64
	#define SQ_RING_MASK_OFFSET 256
	#define SQ_RING_ENTRIES_OFFSET 264
	#define SQ_FLAGS_OFFSET 276
	#define SQ_DROPPED_OFFSET 272
	#define CQ_HEAD_OFFSET 128
	#define CQ_TAIL_OFFSET 192
	#define CQ_RING_MASK_OFFSET 260
	#define CQ_RING_ENTRIES_OFFSET 268
	#define CQ_RING_OVERFLOW_OFFSET 284
	#define CQ_FLAGS_OFFSET 280
	#define CQ_CQES_OFFSET 320

	struct io_sqring_offsets {
		uint32_t head;
		uint32_t tail;
		uint32_t ring_mask;
		uint32_t ring_entries;
		uint32_t flags;
		uint32_t dropped;
		uint32_t array;
		uint32_t resv1;
		uint64_t resv2;
	};

	struct io_cqring_offsets {
		uint32_t head;
		uint32_t tail;
		uint32_t ring_mask;
		uint32_t ring_entries;
		uint32_t overflow;
		uint32_t cqes;
		uint64_t resv[2];
	};

	struct io_uring_params {
		uint32_t sq_entries;
		uint32_t cq_entries;
		uint32_t flags;
		uint32_t sq_thread_cpu;
		uint32_t sq_thread_idle;
		uint32_t features;
		uint32_t resv[4];
		struct io_sqring_offsets sq_off;
		struct io_cqring_offsets cq_off;
	};

	#define IORING_OFF_SQ_RING 0
	#define IORING_OFF_SQES 0x10000000ULL

	#define sys_io_uring_setup 425
	static long syz_io_uring_setup(volatile long a0, volatile long a1, volatile long a2, volatile long a3, volatile long a4, volatile long a5)
	{
		uint32_t entries = (uint32_t)a0;
		struct io_uring_params* setup_params = (struct io_uring_params*)a1;
		void* vma1 = (void*)a2;
		void* vma2 = (void*)a3;
		void** ring_ptr_out = (void**)a4;
		void** sqes_ptr_out = (void**)a5;
		uint32_t fd_io_uring = syscall(sys_io_uring_setup, entries, setup_params);
		uint32_t sq_ring_sz = setup_params->sq_off.array + setup_params->sq_entries * sizeof(uint32_t);
		uint32_t cq_ring_sz = setup_params->cq_off.cqes + setup_params->cq_entries * SIZEOF_IO_URING_CQE;
		uint32_t ring_sz = sq_ring_sz > cq_ring_sz ? sq_ring_sz : cq_ring_sz;
		*ring_ptr_out = mmap(vma1, ring_sz, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE | MAP_FIXED, fd_io_uring, IORING_OFF_SQ_RING);
		uint32_t sqes_sz = setup_params->sq_entries * SIZEOF_IO_URING_SQE;
		*sqes_ptr_out = mmap(vma2, sqes_sz, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE | MAP_FIXED, fd_io_uring, IORING_OFF_SQES);
		return fd_io_uring;
	}

	static long syz_io_uring_submit(volatile long a0, volatile long a1, volatile long a2, volatile long a3)
	{
		char* ring_ptr = (char*)a0;
		char* sqes_ptr = (char*)a1;
		char* sqe = (char*)a2;
		uint32_t sqes_index = (uint32_t)a3;
		uint32_t sq_ring_entries = *(uint32_t*)(ring_ptr + SQ_RING_ENTRIES_OFFSET);
		uint32_t cq_ring_entries = *(uint32_t*)(ring_ptr + CQ_RING_ENTRIES_OFFSET);
		uint32_t sq_array_off = (CQ_CQES_OFFSET + cq_ring_entries * SIZEOF_IO_URING_CQE + 63) & ~63;
		if (sq_ring_entries)
			sqes_index %= sq_ring_entries;
		char* sqe_dest = sqes_ptr + sqes_index * SIZEOF_IO_URING_SQE;
		memcpy(sqe_dest, sqe, SIZEOF_IO_URING_SQE);
		uint32_t sq_ring_mask = *(uint32_t*)(ring_ptr + SQ_RING_MASK_OFFSET);
		uint32_t* sq_tail_ptr = (uint32_t*)(ring_ptr + SQ_TAIL_OFFSET);
		uint32_t sq_tail = *sq_tail_ptr & sq_ring_mask;
		uint32_t sq_tail_next = *sq_tail_ptr + 1;
		uint32_t* sq_array = (uint32_t*)(ring_ptr + sq_array_off);
		*(sq_array + sq_tail) = sqes_index;
		__atomic_store_n(sq_tail_ptr, sq_tail_next, __ATOMIC_RELEASE);
		return 0;
	}

	static void kill_and_wait(int pid, int* status)
	{
		kill(-pid, SIGKILL);
		kill(pid, SIGKILL);
		for (int i = 0; i < 100; i++) {
			if (waitpid(-1, status, WNOHANG | __WALL) == pid)
				return;
			usleep(1000);
		}
		DIR* dir = opendir("/sys/fs/fuse/connections");
		if (dir) {
			for (;;) {
				struct dirent* ent = readdir(dir);
				if (!ent)
					break;
				if (strcmp(ent->d_name, ".") == 0 || strcmp(ent->d_name, "..") == 0)
					continue;
				char abort[300];
				snprintf(abort, sizeof(abort), "/sys/fs/fuse/connections/%s/abort", ent->d_name);
				int fd = open(abort, O_WRONLY);
				if (fd == -1) {
					continue;
				}
				if (write(fd, abort, 1) < 0) {
				}
				close(fd);
			}
			closedir(dir);
		} else {
		}
		while (waitpid(-1, status, __WALL) != pid) {
		}
	}

	static void setup_test()
	{
		prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0);
		setpgrp();
		write_file("/proc/self/oom_score_adj", "1000");
	}

	static void execute_one(void);

	#define WAIT_FLAGS __WALL

	static void loop(void)
	{
		int iter = 0;
		for (;; iter++) {
			int pid = fork();
			if (pid < 0)
		exit(1);
			if (pid == 0) {
				setup_test();
				execute_one();
				exit(0);
			}
			int status = 0;
			uint64_t start = current_time_ms();
			for (;;) {
				if (waitpid(-1, &status, WNOHANG | WAIT_FLAGS) == pid)
					break;
				sleep_ms(1);
			if (current_time_ms() - start < 5000) {
				continue;
			}
				kill_and_wait(pid, &status);
				break;
			}
		}
	}

	#ifndef __NR_execveat
	#define __NR_execveat 322
	#endif
	#ifndef __NR_io_uring_enter
	#define __NR_io_uring_enter 426
	#endif
	#ifndef __NR_io_uring_register
	#define __NR_io_uring_register 427
	#endif

	uint64_t r[3] = {0xffffffffffffffff, 0x0, 0x0};

	void execute_one(void)
	{
			intptr_t res = 0;
	*(uint32_t*)0x20000004 = 0;
	*(uint32_t*)0x20000008 = 0;
	*(uint32_t*)0x2000000c = 0;
	*(uint32_t*)0x20000010 = 0;
	*(uint32_t*)0x20000018 = -1;
	*(uint32_t*)0x2000001c = 0;
	*(uint32_t*)0x20000020 = 0;
	*(uint32_t*)0x20000024 = 0;
		res = -1;
	res = syz_io_uring_setup(0x1e1b, 0x20000000, 0x200a0000, 0x20ffb000, 0x20000080, 0x200000c0);
		if (res != -1) {
			r[0] = res;
	r[1] = *(uint64_t*)0x20000080;
	r[2] = *(uint64_t*)0x200000c0;
		}
	*(uint8_t*)0x20000640 = 0x1e;
	*(uint8_t*)0x20000641 = 0;
	*(uint16_t*)0x20000642 = 0;
	*(uint32_t*)0x20000644 = r[0];
	*(uint64_t*)0x20000648 = 0;
	*(uint32_t*)0x20000650 = 0;
	*(uint32_t*)0x20000654 = -1;
	*(uint32_t*)0x20000658 = 0;
	*(uint32_t*)0x2000065c = 0;
	*(uint64_t*)0x20000660 = 0;
	*(uint16_t*)0x20000668 = 0;
	*(uint16_t*)0x2000066a = 0;
	*(uint32_t*)0x2000066c = r[0];
	*(uint64_t*)0x20000670 = 0;
	*(uint64_t*)0x20000678 = 0;
	syz_io_uring_submit(r[1], r[2], 0x20000640, 0);
		syscall(__NR_io_uring_enter, r[0], 0xfffffffe, 0, 0ul, 0ul, 0ul);
		syscall(__NR_io_uring_register, r[0], 0xaul, 0ul, 0);
	memcpy((void*)0x20000280, "./file1\000", 8);
		syscall(__NR_execveat, 0xffffff9c, 0x20000280ul, 0ul, 0ul, 0ul);

	}
	int main(void)
	{
			syscall(__NR_mmap, 0x1ffff000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
		syscall(__NR_mmap, 0x20000000ul, 0x1000000ul, 7ul, 0x32ul, -1, 0ul);
		syscall(__NR_mmap, 0x21000000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
				loop();
		return 0;
	}


Hope that helped!

Best Regards,

Jordy

On Mon Mar 15, 2021 at 6:58 PM CET, Pavel Begunkov wrote:
> On 15/03/2021 17:44, Jordy Zomer wrote:
> > My syzkaller instance reported a use-after-free bug in io_wqe_inc_running.
> > I tried fixing this by checking if wq isn't NULL in io_wqe_worker.
> > If it does; return an -EFAULT. This because create_io_worker() will clean-up the worker if there's an error.
> > 
> > If you want I could send you the syzkaller reproducer and crash-logs :)
>
> Yes, please.
>
> Haven't looked up properly, but looks that wq==NULL should
> never happen, so the fix is a bit racy.
>
> > 
> > Best Regards,
> > 
> > Jordy Zomer
> > 
> > Signed-off-by: Jordy Zomer <jordy@pwning.systems>
> > ---
> >  fs/io-wq.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/fs/io-wq.c b/fs/io-wq.c
> > index 0ae9ecadf295..9ed92d88a088 100644
> > --- a/fs/io-wq.c
> > +++ b/fs/io-wq.c
> > @@ -482,6 +482,10 @@ static int io_wqe_worker(void *data)
> >  	char buf[TASK_COMM_LEN];
> >  
> >  	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
> > +
> > +	if (wq == NULL)
> > +		return -EFAULT;
> > +
> >  	io_wqe_inc_running(worker);
> >  
> >  	sprintf(buf, "iou-wrk-%d", wq->task_pid);
> > 
>
> --
> Pavel Begunkov

