Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F4A2E697E
	for <lists+io-uring@lfdr.de>; Mon, 28 Dec 2020 17:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbgL1QzQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 28 Dec 2020 11:55:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43820 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728176AbgL1QzO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 28 Dec 2020 11:55:14 -0500
Received: from ip5f5af0a0.dynamic.kabel-deutschland.de ([95.90.240.160] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1ktvmv-0007PO-Qk; Mon, 28 Dec 2020 16:54:29 +0000
Date:   Mon, 28 Dec 2020 17:54:29 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Jens Axboe <axboe@kernel.dk>, hch@infradead.org
Cc:     willy@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org
Subject: Bug in __mmdrop() triggered by io-uring on v5.11-rc1
Message-ID: <20201228165429.c3v637xlqxt56fsv@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hey everyone,

The following oops can be triggered on a pristine v5.11-rc1 which I discovered
while rebasing my idmapped mount patchset onto v5.11-rc1:

[  577.716339][ T7216] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009)/LXD, BIOS 0.0.0 02/06/2015
[  577.718584][ T7216] Call Trace:
[  577.719357][ T7216]  dump_stack+0x10b/0x167
[  577.720505][ T7216]  panic+0x347/0x783
[  577.721588][ T7216]  ? print_oops_end_marker.cold+0x15/0x15
[  577.723502][ T7216]  ? __warn.cold+0x5/0x2f
[  577.725079][ T7216]  ? __mmdrop+0x30c/0x400
[  577.736066][ T7216]  __warn.cold+0x20/0x2f
[  577.745503][ T7216]  ? __mmdrop+0x30c/0x400
[  577.755101][ T7216]  report_bug+0x277/0x300

f2-vm login: [  577.764873][ T7216]  handle_bug+0x3c/0x60
[  577.773982][ T7216]  exc_invalid_op+0x18/0x50
[  577.786341][ T7216]  asm_exc_invalid_op+0x12/0x20
[  577.795500][ T7216] RIP: 0010:__mmdrop+0x30c/0x400
[  577.804426][ T7216] Code: 00 00 4c 89 ef e8 64 61 8c 02 eb 82 e8 dd 48 32 00 4c 89 e7 e8 35 97 2e 00 e9 70 ff ff ff e8 cb 48 32 00 0f 0b e8 c4 48 32 00 <0f> 0b e9 51 fd ff ff e8 b8 48 32 00 0f 0b e9 82 fd ff ff e8 ac 48
[  577.826526][ T7216] RSP: 0018:ffffc900073676d8 EFLAGS: 00010246
[  577.836448][ T7216] RAX: 0000000000000000 RBX: ffff88810d56d1c0 RCX: ffff88810d56d1c0
[  577.845860][ T7216] RDX: 0000000000000000 RSI: ffff88810d56d1c0 RDI: 0000000000000002
[  577.856896][ T7216] RBP: ffff888025244700 R08: ffffffff8141a4ec R09: ffffed1004a488ed
[  577.866712][ T7216] R10: ffff888025244763 R11: ffffed1004a488ec R12: ffff8880660b4c40
[  577.875736][ T7216] R13: ffff888013930000 R14: ffff888025244700 R15: 0000000000000001
[  577.889094][ T7216]  ? __mmdrop+0x30c/0x400
[  577.898466][ T7216]  ? __mmdrop+0x30c/0x400
[  577.907746][ T7216]  finish_task_switch+0x56f/0x8c0
[  577.917553][ T7216]  ? __switch_to+0x580/0x1060
[  577.926962][ T7216]  __schedule+0xa04/0x2310
[  577.937965][ T7216]  ? firmware_map_remove+0x1a1/0x1a1

f2-vm login: [  577.947035][ T7216]  ? try_to_wake_up+0x7f3/0x16e0
[  577.955799][ T7216]  ? preempt_schedule_thunk+0x16/0x18
[  577.964988][ T7216]  preempt_schedule_common+0x4a/0xc0
[  577.973670][ T7216]  preempt_schedule_thunk+0x16/0x18
[  577.985967][ T7216]  try_to_wake_up+0x9eb/0x16e0
[  577.994498][ T7216]  ? migrate_swap_stop+0x9d0/0x9d0
[  578.003265][ T7216]  ? rcu_read_lock_held+0xae/0xc0
[  578.012182][ T7216]  ? rcu_read_lock_sched_held+0xe0/0xe0
[  578.021280][ T7216]  io_wqe_wake_worker.isra.0+0x4ba/0x670
[  578.029857][ T7216]  ? io_wq_manager+0xc00/0xc00
[  578.041295][ T7216]  ? _raw_spin_unlock_irqrestore+0x46/0x50
[  578.050139][ T7216]  io_wqe_enqueue+0x212/0x980
[  578.058213][ T7216]  __io_queue_async_work+0x201/0x4a0
[  578.067518][ T7216]  io_queue_async_work+0x52/0x80
[  578.078327][ T7216]  __io_queue_sqe+0x986/0xe80
[  578.086615][ T7216]  ? io_uring_setup+0x3a90/0x3a90
[  578.094528][ T7216]  ? radix_tree_load_root+0x119/0x1b0
[  578.102598][ T7216]  ? io_async_task_func+0xa90/0xa90
[  578.110208][ T7216]  ? __sanitizer_cov_trace_pc+0x1e/0x50
[  578.120847][ T7216]  io_queue_sqe+0x5e3/0xc40
[  578.127950][ T7216]  io_submit_sqes+0x17ca/0x26f0
[  578.135559][ T7216]  ? io_queue_sqe+0xc40/0xc40
[  578.143129][ T7216]  ? __x64_sys_io_uring_enter+0xa10/0xf00
[  578.152183][ T7216]  ? xa_store+0x40/0x50
[  578.162501][ T7216]  ? mutex_lock_io_nested+0x12a0/0x12a0
[  578.170203][ T7216]  ? do_raw_spin_unlock+0x175/0x260
[  578.177874][ T7216]  ? _raw_spin_unlock+0x28/0x40
[  578.185560][ T7216]  ? xa_store+0x40/0x50
[  578.192755][ T7216]  __x64_sys_io_uring_enter+0xa1b/0xf00
[  578.201089][ T7216]  ? __io_uring_task_cancel+0x1e0/0x1e0
[  578.210378][ T7216]  ? __sanitizer_cov_trace_pc+0x1e/0x50
[  578.218401][ T7216]  ? __audit_syscall_entry+0x3fe/0x540
[  578.226264][ T7216]  do_syscall_64+0x31/0x70
[  578.234410][ T7216]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  578.244957][ T7216] RIP: 0033:0x7f5204b9c89d
[  578.252372][ T7216] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c3 f5 0c 00 f7 d8 64 89 01 48
[  578.272398][ T7216] RSP: 002b:00007ffd62bb14e8 EFLAGS: 00000212 ORIG_RAX: 00000000000001aa
[  578.280966][ T7216] RAX: ffffffffffffffda RBX: 00007ffd62bb1560 RCX: 00007f5204b9c89d
[  578.289068][ T7216] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000005
[  578.300693][ T7216] RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000008
[  578.308932][ T7216] R10: 0000000000000000 R11: 0000000000000212 R12: 0000000000000001
[  578.317255][ T7216] R13: 0000000000000000 R14: 00007ffd62bb1520 R15: 0000000000000000
[  578.328448][ T7216] Kernel Offset: disabled
[  578.544329][ T7216] Rebooting in 86400 seconds..

The following program should be able to trigger the bug taken from my
xfstest-suite:

#include <liburing.h>

#define log_stderr(format, ...)                                                         \
	fprintf(stderr, "%s: %d: %s - %m - " format "\n", __FILE__, __LINE__, __func__, \
		##__VA_ARGS__);

#define log_error_errno(__ret__, __errno__, format, ...)      \
	({                                                    \
		typeof(__ret__) __internal_ret__ = (__ret__); \
		errno = (__errno__);                          \
		log_stderr(format, ##__VA_ARGS__);            \
		__internal_ret__;                             \
	})


#define safe_close(fd)      \
	if (fd >= 0) {           \
		int _e_ = errno; \
		close(fd);       \
		errno = _e_;     \
		fd = -EBADF;     \
	}

#define die_errno(__errno__, format, ...)          \
	({                                         \
		errno = (__errno__);               \
		log_stderr(format, ##__VA_ARGS__); \
		exit(EXIT_FAILURE);                \
	})

#define die(format, ...) die_errno(errno, format, ##__VA_ARGS__)

#define FILE1 "file1"

static int io_uring_openat_with_creds(struct io_uring *ring, int dfd, const char *path, int cred_id,
				      bool with_link)
{
	struct io_uring_cqe *cqe;
	struct io_uring_sqe *sqe;
	int ret, i, to_submit = 1;

	if (with_link) {
		sqe = io_uring_get_sqe(ring);
		io_uring_prep_nop(sqe);
		sqe->flags |= IOSQE_IO_LINK;
		sqe->user_data = 1;
		to_submit++;
	}

	sqe = io_uring_get_sqe(ring);
	io_uring_prep_openat(sqe, dfd, path, O_RDONLY | O_CLOEXEC, 0);
	sqe->user_data = 2;

	if (cred_id != -1)
		sqe->personality = cred_id;

	ret = io_uring_submit(ring);
	if (ret != to_submit) {
		log_stderr("failure: io_uring_submit");
		goto out;
	}

	for (i = 0; i < to_submit; i++) {
		ret = io_uring_wait_cqe(ring, &cqe);
		if (ret < 0) {
			log_stderr("failure: io_uring_wait_cqe");
			goto out;
		}

		ret = cqe->res;
		io_uring_cqe_seen(ring, cqe);
	}
out:
	return ret;
}

static inline bool switch_ids(uid_t uid, gid_t gid)
{
	if (setgroups(0, NULL))
		return log_errno(false, "failure: setgroups");

	if (setresgid(gid, gid, gid))
		return log_errno(false, "failure: setresgid");

	if (setresuid(uid, uid, uid))
		return log_errno(false, "failure: setresuid");

	return true;
}

int wait_for_pid(pid_t pid)
{
	int status, ret;

again:
	ret = waitpid(pid, &status, 0);
	if (ret == -1) {
		if (errno == EINTR)
			goto again;

		return -1;
	}

	if (!WIFEXITED(status))
		return -1;

	return WEXITSTATUS(status);
}

static int io_uring(void)
{
	int fret = -1;
	int file1_fd = -EBADF;
	struct io_uring ring = {};
	int cred_id, ret;
	pid_t pid;

	ret = io_uring_queue_init(8, &ring, 0);
	if (ret)
		return log_error_errno(-1, -ret, "failure: io_uring_queue_init");

	ret = io_uring_register_personality(&ring);
	if (ret < 0)
		return 0; /* personalities not supported */
	cred_id = ret;

	/* create file only owner can open */
	file1_fd = openat(t_dir1_fd, FILE1, O_RDONLY | O_CREAT | O_EXCL | O_CLOEXEC, 0000);
	if (file1_fd < 0) {
		log_stderr("failure: openat");
		goto out;
	}
	if (fchown(file1_fd, 0, 0)) {
		log_stderr("failure: fchown");
		goto out;
	}
	if (fchmod(file1_fd, 0600)) {
		log_stderr("failure: fchmod");
		goto out;
	}
	safe_close(file1_fd);

	pid = fork();
	if (pid < 0) {
		log_stderr("failure: fork");
		goto out;
	}
	if (pid == 0) {
		/* Verify we can open it with our current credentials. */
		file1_fd = io_uring_openat_with_creds(&ring, t_dir1_fd, FILE1, -1, false);
		if (file1_fd < 0)
			die("failure: io_uring_open_file");

		exit(EXIT_SUCCESS);
	}
	if (wait_for_pid(pid)) {
		log_stderr("failure: wait_for_pid");
		goto out;
	}

	pid = fork();
	if (pid < 0) {
		log_stderr("failure: fork");
		goto out;
	}
	if (pid == 0) {
		if (!switch_ids(1000, 1000))
			die("failure: switch_ids");

		/* Verify we can't open it with our current credentials. */
		file1_fd = io_uring_openat_with_creds(&ring, t_dir1_fd, FILE1, -1, false);
		if (file1_fd >= 0)
			die("failure: io_uring_open_file");

		exit(EXIT_SUCCESS);
	}
	if (wait_for_pid(pid)) {
		log_stderr("failure: wait_for_pid");
		goto out;
	}

	pid = fork();
	if (pid < 0) {
		log_stderr("failure: fork");
		goto out;
	}
	if (pid == 0) {
		if (!switch_ids(1000, 1000))
			die("failure: switch_ids");

		/* Verify we can open it with the registered credentials. */
		file1_fd = io_uring_openat_with_creds(&ring, t_dir1_fd, FILE1, cred_id, false);
		if (file1_fd < 0)
			die("failure: io_uring_open_file");

		/*
		 * Verify we can open it with the registered credentials and as
		 * a link.
		 */
		file1_fd = io_uring_openat_with_creds(&ring, t_dir1_fd, FILE1, cred_id, true);
		if (file1_fd < 0)
			die("failure: io_uring_open_file");

		exit(EXIT_SUCCESS);
	}
	if (wait_for_pid(pid)) {
		log_stderr("failure: wait_for_pid");
		goto out;
	}

	fret = 0;
out:
	ret = io_uring_unregister_personality(&ring, cred_id);
	if (ret)
		log_stderr("failure: io_uring_unregister_personality");

	safe_close(file1_fd);

	return fret;
}

Thanks!
Christian
