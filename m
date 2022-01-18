Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F72E492991
	for <lists+io-uring@lfdr.de>; Tue, 18 Jan 2022 16:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345597AbiARPVJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Jan 2022 10:21:09 -0500
Received: from mx-rz-3.rrze.uni-erlangen.de ([131.188.11.22]:43773 "EHLO
        mx-rz-3.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345512AbiARPVH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Jan 2022 10:21:07 -0500
X-Greylist: delayed 436 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Jan 2022 10:21:07 EST
Received: from mx-rz-smart.rrze.uni-erlangen.de (mx-rz-smart.rrze.uni-erlangen.de [IPv6:2001:638:a000:1025::1e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mx-rz-3.rrze.uni-erlangen.de (Postfix) with ESMTPS id 4JdXNY1K41z1xrg;
        Tue, 18 Jan 2022 16:13:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fau.de; s=fau-2021;
        t=1642518829; bh=4KZFqt1B/XwUjjxZgCvRWcnclOFL228nbnasON8Zvvc=;
        h=Date:From:To:Cc:Subject:From:To:CC:Subject;
        b=u5oT5rva7SmHCdua2gRhHo3DPs2+787jr8fOA3UtmC9GCnso0P1tZBU8uOXVTO2OC
         bqR8g78Dinuw2SpgPdnLo+6Xok2smmtJidZqB3h2MJebk6fPwOQROBvuBiNBMT7Iyd
         6NbFOt4OV6LAPUMyG0rAF/eapuYPltAHcK+RVKAvM5E8g7zGB9CMOvtciKyGNUUz/F
         z1sWRztPtiOizXHFKdYr9skIz17ItQEAwHBb9upYI5zIl8kyoKD54ffWlltVujDiuc
         ujA/1+ndBEBRn/FBy7HbpAhyp1a0ar7YkY2Q4RRcSu0bvsrl7SWWYXIkEMGgbYtWvI
         gQO7h3F15f3zg==
X-Virus-Scanned: amavisd-new at boeck5.rrze.uni-erlangen.de (RRZE)
X-RRZE-Flag: Not-Spam
X-RRZE-Submit-IP: 2a02:8070:88c3:5000:7a2b:46ff:fe28:e01a
Received: from localhost (unknown [IPv6:2a02:8070:88c3:5000:7a2b:46ff:fe28:e01a])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: U2FsdGVkX18MwE8mbQ6vpsRIg6s3eKA9Bsar5pJGguE=)
        by smtp-auth.uni-erlangen.de (Postfix) with ESMTPSA id 4JdXNT4tXYz1y3g;
        Tue, 18 Jan 2022 16:13:45 +0100 (CET)
Date:   Tue, 18 Jan 2022 16:13:37 +0100
From:   Florian Fischer <florian.fl.fischer@fau.de>
To:     io-uring@vger.kernel.org
Cc:     flow@cs.fau.de
Subject: Canceled read requests never completed
Message-ID: <20220118151337.fac6cthvbnu7icoc@pasture>
Mail-Followup-To: io-uring@vger.kernel.org, flow@cs.fau.de
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="eq5m47nxnoopecdh"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--eq5m47nxnoopecdh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hello,

during our research on entangling io_uring and parallel runtime systems one of our test
cases results in situations where an `IORING_OP_ASYNC_CANCEL` request can not find (-ENOENT)
or not cancel (EALREADY) a previously submitted read of an event file descriptor. 
However, the previously submitted read also never generates a CQE.
We now wonder if this is a bug in the kernel, or, at least in the case of EALRADY, works as intended.
Our current architecture expects that a request eventually creates a CQE when canceled.


# Reproducer pseudo-code:

create N eventfds
create N threads
  
thread_function:
  create thread-private io_uring queue pair
  for (i = 0, i < ITERATIONS, i++)
    submit read from eventfd n
    submit read from eventfd (n + 1) % N
    submit write to eventfd (n + 2) % N
    await completions until the write completion was reaped
    submit cancel requests for the two read requests
    await all outstanding requests (minus a possible already completed read request)
  
Note that:
- Each eventfd is read twice but only written once.
- The read requests are canceled independently of their state. 
- There are five io_uring requests per loop iteration


# Expectation

Each of the five submitted request should be completed:
* Write is always successful because writing to an eventfd only blocks
  if the counter reaches 0xfffffffffffffffe and we add only 1 in each iteration.
  Furthermore the read from the file descriptor resets the counter to 0.
* The cancel requests are always completed with different return values
  dependent on the state of the read request to cancel.
* The read requests should always be completed either because some data is available
  to read or because they are canceled.


# Observation:

Sometimes threads block in io_uring_enter forever because one read request
is never completed and the cancel of such read returned with -ENOENT or -EALREADY.

A C program to reproduce this situation is attached.
It contains the essence of the previously mentioned test case with instructions
how to compile and execute it.

The following log excerpt was generated using a version of the reproducer
where each write adds 0 to the eventfd count and thus not completing read requests.
This means all read request should be canceled and all cancel requests should either
return with 0 (the request was found and canceled) or -EALREADY the read is already
in execution and should be interrupted.

  0 Prepared read request (evfd: 0, tag: 1)
  0 Submitted 1 requests -> 1 inflight
  0 Prepared read request (evfd: 1, tag: 2)
  0 Submitted 1 requests -> 2 inflight
  0 Prepared write request (evfd: 2)
  0 Submitted 1 requests -> 3 inflight
  0 Collect write completion: 8
  0 Prepared cancel request for 1
  0 Prepared cancel request for 2
  0 Submitted 2 requests -> 4 inflight
  0 Collect read 1 completion: -125 - Operation canceled
  0 Collect cancel read 1 completion: 0
  0 Collect cancel read 2 completion: -2 - No such file or directory
  
Thread 0 blocks forever because the second read could not be
canceled (-ENOENT in the last line) but no completion is ever created for it.

The far more common situation with the reproducer and adding 1 to the eventfds in each loop
is that a request is not canceled and the cancel attempt returned with -EALREADY.
There is no progress because the writer has already finished its loop and the cancel
apparently does not really cancel the request.

  1 Starting iteration 996
  1 Prepared read request (evfd: 1, tag: 1)
  1 Submitted 1 requests -> 1 inflight
  1 Prepared read request (evfd: 2, tag: 2)
  1 Submitted 1 requests -> 2 inflight
  1 Prepared write request (evfd: 0)
  1 Submitted 1 requests -> 3 inflight
  1 Collect write completion: 8
  1 Prepared cancel request for read 1
  1 Prepared cancel request for read 2
  1 Submitted 2 requests -> 4 inflight
  1 Collect read 1 completion: -125 - Operation canceled
  1 Collect cancel read 1 completion: 0
  1 Collect cancel read 2 completion: -114 - Operation already in progress

After reading the io_uring_enter(2) man page a IORING_OP_ASYNC_CANCEL's return value of -EALREADY apparently
may not cause the request to terminate. At least that is our interpretation of "…res field will contain -EALREADY.
In this case, the request may or may not terminate."

I could reliably reproduce the behavior on different hardware, linux versions
from 5.9 to 5.16 as well as liburing versions 0.7 and 2.1.

With linux 5.6 I was not able to reproduce this cancel miss.

So is the situation we see intended behavior of the API or is it a faulty race in the
io_uring cancel code?
If it is intended then it becomes really hard to build reliable abstractions
using io_uring's cancellation.
We really like to have the invariant that a canceled io_uring operation eventually
generates a cqe, either completed or canceled/interrupted.

---
Florian Fischer      &  Florian Schmaus
f.fischer@cs.fau.de     flow@cs.fau.de

--eq5m47nxnoopecdh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="threaded_cancel_repro.c"

/** 
 * io_uring cancel miss reproducer
 * Copyright 2022 Florian Fischer <f.fischer@cs.fau.de>
 *
 * io_urings's IORING_OP_ASYNC_CANCEL sometimes does not cancel inflight requests.
 *
 * Tested systems:
 * - Ryzen 7 arch linux
 *  - liburing 2.1
 *  - reproducable on: 5.15.12, 5.16
 *
 * - Xeon E7-4830 Debian 11
 *   - liburing 0.7
 *   - reproducable on: 5.9, 5.15, 5.16
 *   - not reproducable on: 5.6
 * 
 * Building the reproducer with logging and debug symbols:
 *
 * gcc -Werror -Wall -O3 threaded_cancel_repro.c -o threaded_cancel_repro -pthread -luring
 *
 * Steps to reproduce on my system:
 * 1. Compile the reproducer
 * 2. Open reproducer with gdb using a memory mapped log file
 *    $ LOG_FILE=cancel.log gdb ./threaded_cancel_repro
 * 3. Disable pagination
 *    (gdb) set pagination off
 * 4. Run the reproducer
 *    (gdb) r
 * 5. Repeat the reproducer until it hangs (takes less than 1s on my system)
 *    (gdb) b exit
 *    (gdb) command
 *    > r
 *    > end
 *    (gdb) r
 * 6. Stop the execution with Ctrl + c
 * 7. Walk up the stack until we are in threaded_cancel_repro.c code
 *    (gdb) up
 * 8. Disable scheduling (just be to safe)
 *    (gdb) set scheduler-locking on
 * 9. Trim the log file
 *    (gdb) p lbuf_trim()
 * 10. Open the log file in a editor and search for 'res -2'
 *
 * Explanation:
 * The reproducer opens n (3) event file descriptors and starts n (3) threads.
 * Each thread creates an io_uring and enters a loop.
 * In each iteration the thread submits a read request from evfds[thread_id].
 * Submits a second read request from evfds[(thread_id + 1) % n].
 * And issues a write request for evfds[(thread_id + 2) % n].
 * The write request is awaited and possible read completions remembered.
 * Then two cancel requests for the reads are submitted and the outstanding
 * requests are awaited.
 *
 * The reproducer gets stuck because a cancel request returns with -2 (ENOENT) 
 * which means the request to cancel was not found but the actual request gets
 * never completed.
 * Or because a cancellation returned with -EALREADY did not properly cancel
 * the read and no more writes to the eventfd will happen and therefore the read
 * request is never completed.
 */
#define _GNU_SOURCE
#include <assert.h>
#include <err.h>
#include <errno.h>
#include <fcntl.h>
#include <liburing.h>
#include <pthread.h>
#include <stdarg.h>
#include <stdatomic.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/eventfd.h>
#include <sys/mman.h>
#include <sys/sysinfo.h>
#include <unistd.h>

#define UNUSED __attribute((unused))

#ifdef NDEBUG
#define POSSIBLY_UNUSED UNUSED
#else
#define POSSIBLY_UNUSED
#endif

/**
 * Forward declarations for the log functionality
 */
struct log_buf;
static void lbuf_init(const char* log_file);
static void lbuf_log(const char* msg);
static void lbuf_destroy();
static void log_to_lbuf(const char* msg) { lbuf_log(msg); }

static void log_with_printf(const char* msg) { printf(msg); }


POSSIBLY_UNUSED static const char* req_to_str(void* data);
POSSIBLY_UNUSED static char* prepare_log_msg(const char* fmt, ...);
static void(*log_func)(const char* msg) = log_with_printf;

#ifdef NDEBUG
#define LOG_COMPLETION(tag, res)
#else
#define LOG_COMPLETION(tag, res)                                             \
do {                                                                         \
	const char* req = req_to_str(tag);                                       \
	if ((res) >= 0) {                                                        \
		LOG("Collect %s completion: %d", req, (res));                        \
	} else {                                                                 \
		LOG("Collect %s completion: %d - %s", req, (res), strerror(-(res))); \
	}                                                                        \
} while(0);
#endif

#ifdef NDEBUG
#define LOG(...)
#else
#define LOG(fmt, ...)                                                     \
do {                                                                      \
	char* msg = prepare_log_msg("%3d " fmt "\n", thread_id, __VA_ARGS__); \
	log_func(msg);                                                        \
	free(msg);                                                            \
} while(0);
#endif

#define IORING_ENTRIES 16

#define CANCEL_MASK (1L << 63)
#define WRITE_TAG ((void*)0x42)

#define ITERATIONS 1000

_Thread_local size_t thread_id;

static pthread_t* threads;
static int* evfds;
static int nthreads;

static struct io_uring_sqe* checked_get_sqe(struct io_uring* ring) {
	struct io_uring_sqe* sqe = io_uring_get_sqe(ring);
	assert(sqe);
	return sqe;
}

static void prep_evfd_read(struct io_uring* ring, int evfd, uint64_t* buf, uintptr_t tag) {
	struct io_uring_sqe* sqe = checked_get_sqe(ring);

	io_uring_prep_read(sqe, evfds[evfd], buf, sizeof(*buf), 0);
	io_uring_sqe_set_data(sqe, (void*)tag);
	LOG("Prepared read request (evfd: %d, tag: %ld)", evfd, tag);
}

static void prep_evfd_write(struct io_uring* ring, int evfd, uint64_t* buf) {
	struct io_uring_sqe* sqe = checked_get_sqe(ring);

	io_uring_prep_write(sqe, evfds[evfd], buf, sizeof(*buf), 0);
	io_uring_sqe_set_data(sqe, WRITE_TAG);
	LOG("Prepared write request (evfd: %d)", evfd);
}

static void prep_cancel(struct io_uring* ring, uintptr_t tag) {
	struct io_uring_sqe* sqe = checked_get_sqe(ring);

	io_uring_prep_cancel(sqe, (void*)tag, 0);
	void* cancel_tag = (void*)(tag | CANCEL_MASK);
	io_uring_sqe_set_data(sqe, cancel_tag);
	LOG("Prepared cancel request for read %ld", tag);
}

static void checked_submit_n(struct io_uring* ring, int* inflight, int n) {
	int res = io_uring_submit(ring);
	if (res < 0) err(EXIT_FAILURE, "io_uring_submit failed");
	assert(res == n);
	*inflight = *inflight + n;
	LOG("Submitted %d requests -> %d inflight", n, *inflight);
}

static const char* req_to_str(void* data) {
	uintptr_t tag = (uintptr_t)data;
	switch(tag) {
	case (uintptr_t)WRITE_TAG:
		return "write";
	case 1:
		return "read 1";
	case 2:
		return "read 2";
	case 0x8000000000000001:
		return "cancel read 1";
	case 0x8000000000000002:
		return "cancel read 2";
	default:
		err(EXIT_FAILURE, "unknown tag encountered");
	}
}

static void checked_submit_one(struct io_uring* ring, int* inflight) {
	checked_submit_n(ring, inflight, 1);
}

static void collect_n_completions(struct io_uring* ring, int n) {
	struct io_uring_cqe* cqe;
	for (int i = 0; i < n; ++i) {
		int res = io_uring_wait_cqe(ring, &cqe);
		if (res) err(EXIT_FAILURE, "io_uring_wait_cqe failed");
		LOG_COMPLETION(io_uring_cqe_get_data(cqe), cqe->res);
		io_uring_cqe_seen(ring, cqe);
	}
}

void* thread_func(void* arg) {
	thread_id = (uintptr_t)(arg);

	struct io_uring ring;
	int res = io_uring_queue_init(IORING_ENTRIES, &ring, 0);
	if (res) err(EXIT_FAILURE, "io_uring_queue_init failed");

	for (unsigned i = 0; i < ITERATIONS; ++i) {
		uint64_t rbuf1 = 0;
		uint64_t rbuf2 = 0;
		uint64_t wbuf = 1;
		/* uint64_t wbuf = 0; */

		int inflight = 0;

		LOG("Starting iteration %u", i);
		prep_evfd_read(&ring, thread_id, &rbuf1, 1);
		checked_submit_one(&ring, &inflight);

		prep_evfd_read(&ring, (thread_id + 1) % nthreads, &rbuf2, 2);
		checked_submit_one(&ring, &inflight);

		prep_evfd_write(&ring, (thread_id + 2) % nthreads, &wbuf);
		checked_submit_one(&ring, &inflight);

		struct io_uring_cqe* cqe;
		void* data = NULL;
		// Await the write completion
		while (data != WRITE_TAG) {
			res = io_uring_wait_cqe(&ring, &cqe);
			if (res) err(EXIT_FAILURE, "io_uring_wait_cqe failed");

			data = io_uring_cqe_get_data(cqe);
			if (cqe->res < 0)
				errx(EXIT_FAILURE, "request with tag %p failed: %s", data,
				     strerror(-cqe->res));

			io_uring_cqe_seen(&ring, cqe);
			--inflight;
			LOG_COMPLETION(io_uring_cqe_get_data(cqe), cqe->res);
		}

		prep_cancel(&ring, 1);
		prep_cancel(&ring, 2);
		checked_submit_n(&ring, &inflight, 2);
		collect_n_completions(&ring, inflight);
	}

	return NULL;
}

int main() {
	nthreads = get_nprocs();
	/* nthreads = 3; */
	evfds = malloc(sizeof(int) * nthreads);
	if (!evfds) err(EXIT_FAILURE, "malloc failed");

	char *log_file = getenv("LOG_FILE");
	if (log_file) {
		lbuf_init(log_file);
		log_func = log_to_lbuf;
	}

	for (unsigned i = 0; i < nthreads; ++i) {
		evfds[i] = eventfd(0, 0);
		if(!evfds[i]) err(EXIT_FAILURE, "eventfd failed");
	}

	threads = malloc(sizeof(pthread_t) * nthreads);
	if (!threads) err(EXIT_FAILURE, "malloc failed");

	for (unsigned i = 0; i < nthreads; ++i) {
		errno = pthread_create(&threads[i], NULL, thread_func, (void*)(uintptr_t)i);
		if (errno) err(EXIT_FAILURE, "pthread_create failed");
	}

	for (unsigned i = 0; i < nthreads; ++i) {
		errno = pthread_join(threads[i], NULL);
		if (errno) err(EXIT_FAILURE, "pthread_join failed");
	}

	if (log_file)
		lbuf_destroy();

	exit(EXIT_SUCCESS);
}

/**
 * Logging code not relevant for the reproducer.
 * It is used to log as fast as possible to a memory mapped file.
 */

static char* prepare_log_msg(const char* fmt, ...) {
	va_list args;
	va_start(args, fmt);

	char* msg;
	if (vasprintf(&msg, fmt, args) == -1)
		err(EXIT_FAILURE, "vasprintf failed"); 

	va_end(args);
	return msg;
}

#define BUFFER_COUNT 3L
#define BUFFER_SIZE (1L << 30)

static struct log_buf {
	char* _Atomic bufs[BUFFER_COUNT];
	size_t _Atomic pos;
	int fd;
} lbuf;

static char* lbuf_get_buf(size_t pos) {
	return lbuf.bufs[(pos / BUFFER_SIZE) % BUFFER_COUNT];
}

void lbuf_log(const char* msg) {
	const size_t len = strlen(msg);
	const size_t start = atomic_fetch_add_explicit(&lbuf.pos, len, memory_order_relaxed);
	const size_t end = start + len - 1;
	char* buf = lbuf_get_buf(start);
	const size_t offset = start % BUFFER_SIZE;
	char* end_buf = lbuf_get_buf(end);

	// The message fits completely into the current buffer
	if (buf == end_buf) {
		memcpy(&buf[offset], msg, len);

		 // Are we still in the active buffer?
		if (offset > 0)
			return;

	// The message spans the active and the next buffer
	} else {
		const size_t left_in_active = BUFFER_SIZE - (start % BUFFER_SIZE);
		memcpy(&buf[offset], msg, left_in_active);
		memcpy(&end_buf[0], &msg[left_in_active], len - left_in_active);
	}

	// This is the first overflow there is no old buffer to remap
	if (start < BUFFER_SIZE * 2)
		return;

	// We are the first writing to the next buffer therefore we are responsible
	// to remap the old.

	// NOTE: This is NOT sound it is possible that other threads are still using the old
	// buffer. But with big enough BUFFER_SIZE it is likely that all threads are using
	// the current active buffer

	// Active buffer -> old buffer
	// Fresh buffer -> active buffer
	// Remap old buffer -> next fresh buffer

	// Remap the old buffer
	const size_t old_buf_idx = ((start / BUFFER_SIZE) - 1) % BUFFER_COUNT;
	char* old_buf = lbuf.bufs[old_buf_idx];

	// The buffer [0, BUFFER_SIZE) is the first active buffer
	// Therefore at bufPos = BUFFER_SIZE + 1 we are in the second active buffer
	const size_t nth_active = (end / BUFFER_SIZE) + 1;

	// Our log file has the size of all ever active buffers plus the new fresh one
	const off_t log_file_size = (off_t)((nth_active + 1) * BUFFER_SIZE);

	// Grow the log file
	if (ftruncate(lbuf.fd, log_file_size))
		err(EXIT_FAILURE, "growing log file failed");

	const off_t next_offset = (off_t)(nth_active * BUFFER_SIZE);
	void* mem = mmap(NULL, BUFFER_SIZE, PROT_WRITE, MAP_FILE | MAP_SHARED, lbuf.fd, next_offset);
	if (mem == MAP_FAILED)
		err(EXIT_FAILURE, "mmap of fresh buffer failed");

	lbuf.bufs[old_buf_idx] = (char*)(mem);

	if (munmap(old_buf, BUFFER_SIZE))
		err(EXIT_FAILURE, "munmap of replaced buffer failed");
}

void lbuf_init(const char* log_file) {
	lbuf.pos = 0;
	lbuf.fd = open(log_file,
	                O_RDWR | O_TRUNC | O_CREAT,
	                S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);

	if (lbuf.fd == -1)
		err(EXIT_FAILURE, "opening log file faield");

	for (size_t i = 0; i < BUFFER_COUNT; ++i) {
		const off_t off = (off_t)(i * BUFFER_SIZE);
		void* mem = mmap(NULL, BUFFER_SIZE, PROT_WRITE, MAP_FILE | MAP_SHARED, lbuf.fd, off);
		if (mem == MAP_FAILED)
			err(EXIT_FAILURE, "map ping log buffer failed");
		lbuf.bufs[i] = (char*)mem;
	}

	if (ftruncate(lbuf.fd, BUFFER_COUNT * BUFFER_SIZE))
		err(EXIT_FAILURE, "initial log file truncation failed");
}

void lbuf_trim() {
	const off_t final_pos = (off_t)(lbuf.pos);
	if (ftruncate(lbuf.fd, final_pos))
		err(EXIT_FAILURE, "truncating log buffer failed");
}

void lbuf_destroy() {
	lbuf_trim();

	for (unsigned i = 0; i < BUFFER_COUNT; ++i) {
		char* buf = lbuf.bufs[i];
		int ret = munmap(buf, BUFFER_SIZE);
		if (ret)
			err(EXIT_FAILURE, "unmapping log buffer failed");
	}

	close(lbuf.fd);
}

--eq5m47nxnoopecdh--
