Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78832493B44
	for <lists+io-uring@lfdr.de>; Wed, 19 Jan 2022 14:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354869AbiASNmn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Jan 2022 08:42:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354863AbiASNmm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Jan 2022 08:42:42 -0500
X-Greylist: delayed 80929 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 19 Jan 2022 05:42:42 PST
Received: from mx-rz-3.rrze.uni-erlangen.de (mx-rz-3.rrze.uni-erlangen.de [IPv6:2001:638:a000:1025::16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF58C061574
        for <io-uring@vger.kernel.org>; Wed, 19 Jan 2022 05:42:42 -0800 (PST)
Received: from mx-rz-smart.rrze.uni-erlangen.de (mx-rz-smart.rrze.uni-erlangen.de [IPv6:2001:638:a000:1025::1e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mx-rz-3.rrze.uni-erlangen.de (Postfix) with ESMTPS id 4Jf6Jw5KpPz20X6;
        Wed, 19 Jan 2022 14:42:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fau.de; s=fau-2021;
        t=1642599760; bh=Tm86oUdeVyxouFf1xV77rnok9AMABMqL4ZiOz+OTwFQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From:To:CC:
         Subject;
        b=aw4LkUs7DJPlYiKW887is0q1R4jlt0gsfdrfeZih1oky5oFOc1AWYKutbcwViPoFF
         TXUXe/MmOtwfRghARhHeM1ABbSlnDeNqULunOTL67eJrhfbOTE2Eoj2ToywX9Pkoga
         /kZkaspq3o2WFDCk6GgL5CS2u+1gOKLxp0sR3THsxdRnOC4XZ0/OTsS3eWHmZ50MTu
         VYO/olR78BH5dMiNQNoaNQccPaJDsRnSFZA+IMY8Amw1Wdn2nqsa8nGYyH0kxawe7O
         FxVXFA7uAOp3pDx7JKHuQiJwm8kmrVEDOmkNNpuQmt9vWmo2/0MP3qGs9JLyHS2mzi
         0Fe1Rl875NxDQ==
X-Virus-Scanned: amavisd-new at boeck1.rrze.uni-erlangen.de (RRZE)
X-RRZE-Flag: Not-Spam
X-RRZE-Submit-IP: 2a02:8070:88c3:5000:7a2b:46ff:fe28:e01a
Received: from localhost (unknown [IPv6:2a02:8070:88c3:5000:7a2b:46ff:fe28:e01a])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: U2FsdGVkX1/z2bNooKGR/jZgD38WJnqwiSpU2iGKGNk=)
        by smtp-auth.uni-erlangen.de (Postfix) with ESMTPSA id 4Jf6Jm56SGz1xmv;
        Wed, 19 Jan 2022 14:42:32 +0100 (CET)
Date:   Wed, 19 Jan 2022 14:42:22 +0100
From:   Florian Fischer <florian.fl.fischer@fau.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Florian Schmaus <schmaus@cs.fau.de>, io-uring@vger.kernel.org
Subject: Re: Canceled read requests never completed
Message-ID: <20220119134222.5wx7wrnalhrerspu@pasture>
Mail-Followup-To: Jens Axboe <axboe@kernel.dk>,
        Florian Schmaus <schmaus@cs.fau.de>, io-uring@vger.kernel.org
References: <20220118151337.fac6cthvbnu7icoc@pasture>
 <81656a38-3628-e32f-1092-bacf7468a6bf@kernel.dk>
 <20220118200549.qybt7fgfqznscidx@pasture>
 <1ec0f92c-117e-d584-f456-036d41348332@kernel.dk>
 <21588bc9-592c-7793-c72a-498ba0db4937@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5umb42wqqmbyo7g5"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <21588bc9-592c-7793-c72a-498ba0db4937@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--5umb42wqqmbyo7g5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On 18.01.2022 19:32, Jens Axboe wrote:
> On 1/18/22 4:36 PM, Jens Axboe wrote:
> > On 1/18/22 1:05 PM, Florian Fischer wrote:
> >>>> After reading the io_uring_enter(2) man page a IORING_OP_ASYNC_CANCEL's return value of -EALREADY apparently
> >>>> may not cause the request to terminate. At least that is our interpretation of "…res field will contain -EALREADY.
> >>>> In this case, the request may or may not terminate."
> >>>
> >>> I took a look at this, and my theory is that the request cancelation
> >>> ends up happening right in between when the work item is moved between
> >>> the work list and to the worker itself. The way the async queue works,
> >>> the work item is sitting in a list until it gets assigned by a worker.
> >>> When that assignment happens, it's removed from the general work list
> >>> and then assigned to the worker itself. There's a small gap there where
> >>> the work cannot be found in the general list, and isn't yet findable in
> >>> the worker itself either.
> >>>
> >>> Do you always see -ENOENT from the cancel when you get the hang
> >>> condition?
> >>
> >> No we also and actually more commonly observe cancel returning
> >> -EALREADY and the canceled read request never gets completed.
> >>
> >> As shown in the log snippet I included below.
> > 
> > I think there are a couple of different cases here. Can you try the
> > below patch? It's against current -git.
> 
> Cleaned it up and split it into functional bits, end result is here:
> 
> https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-5.17

Thanks. I have build and tested your patches.

The most common error we observed (read -> read -> write -> 2x cancel)
is no longer reproducible and our originally test case works flawless :)

Nor could I reproduce any hangs with cancel returning -ENOENT.

But I still can reliably reproduce stuck threads when not incrementing the evfd
count and thus never completing reads due to available data to read.
(read -> read -> write (do not increment evfd count) -> 2x cancel)

I further reduced the attached C program to reproduce the above problem.
The code is also available now at our gitlab [1].

The following log output was created with a less 'minimal' version still including
log functionality:

  75 Collect write completion: 8
  75 Collect cancel read 1 completion: 0
  75 Collect cancel read 2 completion: -114
  75 Collect read 1 completion: -125
  75 Collect read 2 completion: -4

  75 Collect write completion: 8
  75 Collect cancel read 1 completion: 0
  75 Collect cancel read 2 completion: -114
  75 Collect read 1 completion: -125
  thread 75 stuck here

The scenario seams extremely artificial but non or less I think it should
work regardless of its usefulness.

Flo Fischer

[1]: https://gitlab.cs.fau.de/aj46ezos/io_uring-cancel/-/tree/minimal-write0

--5umb42wqqmbyo7g5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="io_uring-cancel.c"

/**
 * io_uring cancel miss reproducer
 * Copyright 2022 Florian Fischer <f.fischer@cs.fau.de>
 *
 * io_urings's IORING_OP_ASYNC_CANCEL sometimes does not cancel inflight requests.
 *
 * Tested systems:
 * - Xeon E7-4830 Debian 11
 *   - liburing 2.1
 *   - reproducable on: linux-block/io_uring-5.17
 *
 * Building the reproducer:
 *   $ gcc -Werror -Wall -g -O3 io_uring-cancel.c -o io_uring-cancel -pthread -luring
 *
 * Steps to reproduce on the above system:
 * 1. Compile the reproducer
 * 2. Run the reproducer in a loop
 *   $ for i in $(seq 100); do echo $i; ./io_uring-cancel; done
 *
 *   (I need < ~30 runs to reproduce a stuck thread with 96 threads)
 *
 * Explanation:
 * The reproducer opens #CPUs event file descriptors and starts #CPUs threads.
 * Each thread creates an io_uring and enters a loop.
 * In each iteration the thread submits a read request from evfds[thread_id].
 * Submits a second read request from evfds[(thread_id + 1) % #CPUs].
 * And issues a write request for evfds[(thread_id + 2) % #CPUs] but the write
 * request does not increase the eventfds count thus it will not complete any read.
 * The write request is awaited.
 * Then two cancel requests for the reads are submitted and the outstanding
 * requests are awaited.
 *
 * The reproducer gets stuck because a cancel request returning with -EALREADY
 * did not properly cancel the read the read request is never completed.
 *
 * WhenpPassing a non-zero value to the reproducer as write increment
 *   $ ./io_uring-cancel 1
 * I could not longer reproduce stuck threads.
 */
#define _GNU_SOURCE
#include <assert.h>
#include <err.h>
#include <errno.h>
#include <liburing.h>
#include <pthread.h>
#include <stdlib.h>
#include <sys/eventfd.h>
#include <sys/sysinfo.h>
#include <unistd.h>

#define IORING_ENTRIES 2
#define ITERATIONS 1000

_Thread_local size_t thread_id;

static pthread_t* threads;
static int* evfds;
static unsigned nthreads;
static unsigned write_increment = 0;

static struct io_uring_sqe* checked_get_sqe(struct io_uring* ring) {
	struct io_uring_sqe* sqe = io_uring_get_sqe(ring);
	assert(sqe);
	return sqe;
}

static void prep_evfd_read(struct io_uring* ring, int evfd, uint64_t* buf, uintptr_t tag) {
	struct io_uring_sqe* sqe = checked_get_sqe(ring);

	io_uring_prep_read(sqe, evfds[evfd], buf, sizeof(*buf), 0);
	io_uring_sqe_set_data(sqe, (void*)tag);
}

static void prep_evfd_write(struct io_uring* ring, int evfd, uint64_t* buf) {
	struct io_uring_sqe* sqe = checked_get_sqe(ring);

	io_uring_prep_write(sqe, evfds[evfd], buf, sizeof(*buf), 0);
}

static void prep_cancel(struct io_uring* ring, uintptr_t tag) {
	struct io_uring_sqe* sqe = checked_get_sqe(ring);

	io_uring_prep_cancel(sqe, (void*)tag, 0);
}

static void checked_submit_n(struct io_uring* ring, int n) {
	int res = io_uring_submit(ring);
	if (res < 0) err(EXIT_FAILURE, "io_uring_submit failed");
	if (res != n) errx(EXIT_FAILURE, "io_uring_submit submitted less sqes than preprared");
}

static void checked_submit_one(struct io_uring* ring) {
	checked_submit_n(ring, 1);
}

static void collect_n_completions(struct io_uring* ring, int n) {
	struct io_uring_cqe* cqe;
	for (int i = 0; i < n; ++i) {
		int res = io_uring_wait_cqe(ring, &cqe);
		if (res) err(EXIT_FAILURE, "io_uring_wait_cqe failed");
		io_uring_cqe_seen(ring, cqe);
	}
}

void* thread_func(void* arg) {
	thread_id = (uintptr_t)(arg);

	struct io_uring ring;
	int res = io_uring_queue_init(IORING_ENTRIES, &ring, 0);
	if (res) err(EXIT_FAILURE, "io_uring_queue_init failed");

	for (unsigned i = 0; i < ITERATIONS; ++i) {
		uint64_t rbuf = 0;
		uint64_t wbuf = write_increment;

		prep_evfd_read(&ring, thread_id, &rbuf, 1);
		checked_submit_one(&ring);

		prep_evfd_read(&ring, (thread_id + 1) % nthreads, &rbuf, 2);
		checked_submit_one(&ring);

		prep_evfd_write(&ring, (thread_id + 2) % nthreads, &wbuf);
		checked_submit_one(&ring);
		collect_n_completions(&ring, 1);


		prep_cancel(&ring, 1);
		prep_cancel(&ring, 2);
		checked_submit_n(&ring, 2);
		collect_n_completions(&ring, 4);
	}

	return NULL;
}

int main(int argc, char* argv[]) {
	if (argc > 1)
		write_increment = atoi(argv[1]);

	nthreads = get_nprocs();
	// nthreads = 10;
	evfds = malloc(sizeof(int) * nthreads);
	if (!evfds) err(EXIT_FAILURE, "malloc failed");

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

	exit(EXIT_SUCCESS);
}

--5umb42wqqmbyo7g5--
