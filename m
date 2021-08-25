Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04903F6D27
	for <lists+io-uring@lfdr.de>; Wed, 25 Aug 2021 03:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbhHYBh0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 Aug 2021 21:37:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56771 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233819AbhHYBhZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 Aug 2021 21:37:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629855400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K/QH1TK6tCziUw51bqNuTgtiY8ygbB4AK87qF3HpCi0=;
        b=ORJq2nYWkJt8SUHfWHTTH1kppOeyjgE+tSuyiuvNIuTri8YM9fZ9cgGO6filPAh6xZm6AW
        nKQ+PgyCnKl2RtHd4ID/1XH3GZoYNMMgl/cf5ZAOIFZ+SsXNlZU1uAHPquozQuD/lnTPp7
        0njLAF+lUdIeC3dmJeE2OLOKfsnVHIM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-cfs0YrKVP-aqeZRuWa4X9Q-1; Tue, 24 Aug 2021 21:36:36 -0400
X-MC-Unique: cfs0YrKVP-aqeZRuWa4X9Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 506DD18C8C0D;
        Wed, 25 Aug 2021 01:36:35 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.3.128.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2034210074FD;
        Wed, 25 Aug 2021 01:36:21 +0000 (UTC)
Date:   Tue, 24 Aug 2021 21:36:19 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [RFC PATCH v2 0/9] Add LSM access controls and auditing to
 io_uring
Message-ID: <20210825013619.GD490529@madcap2.tricolour.ca>
References: <162871480969.63873.9434591871437326374.stgit@olly>
 <20210824205724.GB490529@madcap2.tricolour.ca>
 <CAHC9VhRoHYG8247SvNgxHe8YCduoMi_oEvZqhyYH=faZUAC=CQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhRoHYG8247SvNgxHe8YCduoMi_oEvZqhyYH=faZUAC=CQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2021-08-24 18:27, Paul Moore wrote:
> On Tue, Aug 24, 2021 at 4:57 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > Thanks for the tests.  I have a bunch of userspace patches to add to the
> > last set I posted and these tests will help exercise them.  I also have
> > one more kernel patch to post...  I'll dive back into that now.  I had
> > wanted to post them before now but got distracted with AUDIT_TRIM
> > breakage.
> 
> If it helps, last week I started working on a little test tool for the
> audit-testsuite and selinux-testsuite (see attached).  It may not be
> final, but I don't expect too many changes to it before I post the
> test suite patches; it is definitely usable now.  It's inspired by the
> previous tests, but it uses a much more test suite friendly fork/exec
> model for testing the sharing of io_urings across process boundaries.
> 
> Would you mind sharing your latest userspace patches, if not publicly
> I would be okay with privately off-list; I'm putting together the test
> suite patches this week and it would be good to make sure I'm using
> your latest take on the userspace changes.

I intend to publish them but they need squashing and some documentation
first.  And a run through with io_uring specific tests would be good to
catch anything obvious...

> Also, what is the kernel patch?  Did you find a bug or is this some
> new functionality you think might be useful?  Both can be important,
> but the bug is *really* important; even if you don't have a fix for
> that, just a description of the problem would be good.

It was a very small patch that I realize I had already talked about and
you justified not including sessionid along with auid.  That was
addressed in a reply tacked on to your v1 patchset just now.

> paul moore

> /*
>  * io_uring test tool to exercise LSM/SELinux and audit kernel code paths
>  * Author: Paul Moore <paul@paul-moore.com>
>  *
>  * Copyright 2021 Microsoft Corporation
>  *
>  * At the time this code was written the best, and most current, source of info
>  * on io_uring seemed to be the liburing sources themselves (link below).  The
>  * code below is based on the lessons learned from looking at the liburing
>  * code.
>  *
>  * -> https://github.com/axboe/liburing
>  *
>  * The liburing LICENSE file contains the following:
>  *
>  * Copyright 2020 Jens Axboe
>  *
>  * Permission is hereby granted, free of charge, to any person obtaining a copy
>  * of this software and associated documentation files (the "Software"), to
>  * deal in the Software without restriction, including without limitation the
>  * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
>  * sell copies of the Software, and to permit persons to whom the Software is
>  * furnished to do so, subject to the following conditions:
>  *
>  *  The above copyright notice and this permission notice shall be included in
>  *  all copies or substantial portions of the Software.
>  *
>  *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>  *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>  *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
>  *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
>  *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
>  *  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
>  *  DEALINGS IN THE SOFTWARE.
>  *
>  */
> 
> /*
>  * BUILDING:
>  *
>  * gcc -o <binary> -g -O0 -luring -lrt <source>
>  *
>  * RUNNING:
>  *
>  * The program can be run using the following command lines:
>  *
>  *  % prog sqpoll
>  * ... this invocation runs the io_uring SQPOLL test.
>  *
>  *  % prog t1
>  * ... this invocation runs the parent/child io_uring sharing test.
>  *
>  *  % prog t1 <domain>
>  * ... this invocation runs the parent/child io_uring sharing test with the
>  * child process run in the specified SELinux domain.
>  *
>  */
> 
> #include <stdlib.h>
> #include <stdio.h>
> #include <errno.h>
> #include <string.h>
> #include <fcntl.h>
> #include <unistd.h>
> #include <sys/mman.h>
> #include <sys/stat.h>
> #include <sys/wait.h>
> 
> #include <liburing.h>
> 
> struct urt_config {
> 	struct io_uring ring;
> 	struct io_uring_params ring_params;
> 	int ring_creds;
> };
> 
> #define URING_ENTRIES				8
> #define URING_SHM_NAME				"/iouring_test_4"
> 
> int selinux_state = -1;
> #define SELINUX_CTX_MAX				512
> char selinux_ctx[SELINUX_CTX_MAX] = "\0";
> 
> /**
>  * Display an error message and exit
>  * @param msg the error message
>  *
>  * Output @msg to stderr and exit with errno as the exit value.
>  */
> void fatal(const char *msg)
> {
> 	const char *str = (msg ? msg : "unknown");
> 
> 	if (!errno) {
> 		errno = 1;
> 		fprintf(stderr, "%s: unknown error\n", msg);
> 	} else
> 		perror(str);
> 
> 	if (errno < 0)
> 		exit(-errno);
> 	exit(errno);
> }
> 
> /**
>  * Determine if SELinux is enabled and set the internal state
>  *
>  * Attempt to read from /proc/self/attr/current and determine if SELinux is
>  * enabled, store the current context/domain in @selinux_ctx if SELinux is
>  * enabled.  We avoid using the libselinux API in order to increase portability
>  * and make it easier for other LSMs to adopt this test.
>  */
> int selinux_enabled(void)
> {
> 	int fd = -1;
> 	ssize_t ctx_len;
> 	char ctx[SELINUX_CTX_MAX];
> 
> 	if (selinux_state >= 0)
> 		return selinux_state;
> 
> 	/* attempt to get the current context */
> 	fd = open("/proc/self/attr/current", O_RDONLY);
> 	if (fd < 0)
> 		goto err;
> 	ctx_len = read(fd, ctx, SELINUX_CTX_MAX - 1);
> 	if (ctx_len <= 0)
> 		goto err;
> 	close(fd);
> 
> 	/* save the current context */
> 	ctx[ctx_len] = '\0';
> 	strcpy(selinux_ctx, ctx);
> 
> 	selinux_state = 1;
> 	return selinux_state;
> 
> err:
> 	if (fd >= 0)
> 		close(fd);
> 
> 	selinux_state = 0;
> 	return selinux_state;
> }
> 
> /**
>  * Return the current SELinux domain or "DISABLED" if SELinux is not enabled
>  *
>  * The returned string should not be free()'d.
>  */
> const char *selinux_current(void)
> {
> 	int rc;
> 
> 	rc = selinux_enabled();
> 	if (!rc)
> 		return "DISABLED";
> 
> 	return selinux_ctx;
> }
> 
> /**
>  * Set the SELinux domain for the next exec()'d process
>  * @param ctx the SELinux domain
>  *
>  * This is similar to the setexeccon() libselinux API but we do it manually to
>  * help increase portability and make it easier for other LSMs to adopt this
>  * test.
>  */
> int selinux_exec(const char *ctx)
> {
> 	int fd = -1;
> 	ssize_t len;
> 
> 	if (!ctx)
> 		return -EINVAL;
> 
> 	fd = open("/proc/self/attr/exec", O_WRONLY);
> 	if (fd < 0)
> 		return -errno;
> 	len = write(fd, ctx, strlen(ctx) + 1);
> 	close(fd);
> 
> 	return len;
> }
> 
> /**
>  * Setup the io_uring
>  * @param ring the io_uring pointer
>  * @param params the io_uring parameters
>  * @param creds pointer to the current process' registered io_uring personality
>  *
>  * Create a new io_uring using @params and return it in @ring with the
>  * registered personality returned in @creds.  Returns 0 on success, negative
>  * values on failure.
>  */
> int uring_setup(struct io_uring *ring,
> 		struct io_uring_params *params, int *creds)
> {
> 	int rc;
> 
> 	/* call into liburing to do the setup heavy lifting */
> 	rc = io_uring_queue_init_params(URING_ENTRIES, ring, params);
> 	if (rc < 0)
> 		fatal("io_uring_queue_init_params");
> 
> 	/* register our creds/personality */
> 	rc = io_uring_register_personality(ring);
> 	if (rc < 0)
> 		fatal("io_uring_register_personality()");
> 	*creds = rc;
> 	rc = 0;
> 
> 	printf(">>> io_uring created; fd = %d, personality = %d\n",
> 	       ring->ring_fd, *creds);
> 
> 	return rc;
> }
> 
> /**
>  * Import an existing io_uring based on the given file descriptor
>  * @param fd the io_uring's file descriptor
>  * @param ring the io_uring pointer
>  * @param params the io_uring parameters
>  *
>  * This function takes an io_uring file descriptor in @fd as well as the
>  * io_uring parameters in @params and creates a valid io_uring in @ring.
>  * Returns 0 on success, negative values on failure.
>  */
> int uring_import(int fd, struct io_uring *ring, struct io_uring_params *params)
> {
> 	int rc;
> 
> 	memset(ring, 0, sizeof(*ring));
> 	ring->flags = params->flags;
> 	ring->features = params->features;
> 	ring->ring_fd = fd;
> 
> 	ring->sq.ring_sz = params->sq_off.array +
> 			   params->sq_entries * sizeof(unsigned);
> 	ring->cq.ring_sz = params->cq_off.cqes +
> 			   params->cq_entries * sizeof(struct io_uring_cqe);
> 
> 	ring->sq.ring_ptr = mmap(NULL, ring->sq.ring_sz, PROT_READ | PROT_WRITE,
> 				 MAP_SHARED | MAP_POPULATE, fd,
> 				 IORING_OFF_SQ_RING);
> 	if (ring->sq.ring_ptr == MAP_FAILED)
> 		fatal("import mmap(ring)");
> 
> 	ring->cq.ring_ptr = mmap(0, ring->cq.ring_sz, PROT_READ | PROT_WRITE,
> 				 MAP_SHARED | MAP_POPULATE,
> 				 fd, IORING_OFF_CQ_RING);
> 	if (ring->cq.ring_ptr == MAP_FAILED) {
> 		ring->cq.ring_ptr = NULL;
> 		goto err;
> 	}
> 
> 	ring->sq.khead = ring->sq.ring_ptr + params->sq_off.head;
> 	ring->sq.ktail = ring->sq.ring_ptr + params->sq_off.tail;
> 	ring->sq.kring_mask = ring->sq.ring_ptr + params->sq_off.ring_mask;
> 	ring->sq.kring_entries = ring->sq.ring_ptr +
> 				 params->sq_off.ring_entries;
> 	ring->sq.kflags = ring->sq.ring_ptr + params->sq_off.flags;
> 	ring->sq.kdropped = ring->sq.ring_ptr + params->sq_off.dropped;
> 	ring->sq.array = ring->sq.ring_ptr + params->sq_off.array;
> 
> 	ring->sq.sqes = mmap(NULL,
> 			     params->sq_entries * sizeof(struct io_uring_sqe),
> 			     PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE,
> 			     fd, IORING_OFF_SQES);
> 	if (ring->sq.sqes == MAP_FAILED)
> 		goto err;
> 
> 	ring->cq.khead = ring->cq.ring_ptr + params->cq_off.head;
> 	ring->cq.ktail = ring->cq.ring_ptr + params->cq_off.tail;
> 	ring->cq.kring_mask = ring->cq.ring_ptr + params->cq_off.ring_mask;
> 	ring->cq.kring_entries = ring->cq.ring_ptr +
> 				 params->cq_off.ring_entries;
> 	ring->cq.koverflow = ring->cq.ring_ptr + params->cq_off.overflow;
> 	ring->cq.cqes = ring->cq.ring_ptr + params->cq_off.cqes;
> 	if (params->cq_off.flags)
> 		ring->cq.kflags = ring->cq.ring_ptr + params->cq_off.flags;
> 
> 	return 0;
> 
> err:
> 	if (ring->sq.ring_ptr)
> 		munmap(ring->sq.ring_ptr, ring->sq.ring_sz);
> 	if (ring->cq.ring_ptr);
> 		munmap(ring->cq.ring_ptr, ring->cq.ring_sz);
> 	fatal("import mmap");
> }
> 
> void uring_shutdown(struct io_uring *ring)
> {
> 	if (!ring)
> 		return;
> 	io_uring_queue_exit(ring);
> }
> 
> /**
>  * An io_uring test
>  * @param ring the io_uring pointer
>  * @param personality the registered personality to use or 0
>  * @param path the file path to use for the test
>  *
>  * This function executes an io_uring test, see the function body for more
>  * details.  Returns 0 on success, negative values on failure.
>  */
> int uring_op_a(struct io_uring *ring, int personality, const char *path)
> {
> 
> #define __OP_A_BSIZE		512
> #define __OP_A_STR		"Lorem ipsum dolor sit amet.\n"
> 
> 	int rc;
> 	int fds[1];
> 	char buf1[__OP_A_BSIZE];
> 	char buf2[__OP_A_BSIZE];
> 	struct io_uring_sqe *sqe;
> 	struct io_uring_cqe *cqe;
> 	int str_sz = strlen(__OP_A_STR);
> 
> 	memset(buf1, 0, __OP_A_BSIZE);
> 	memset(buf2, 0, __OP_A_BSIZE);
> 	strncpy(buf1, __OP_A_STR, str_sz);
> 
> 	if (personality > 0)
> 		printf(">>> io_uring ops using personality = %d\n",
> 		       personality);
> 
> 	/*
> 	 * open
> 	 */
> 
> 	sqe = io_uring_get_sqe(ring);
> 	if (!sqe)
> 		fatal("io_uring_get_sqe(open)");
> 	io_uring_prep_openat(sqe, AT_FDCWD, path,
> 			     O_RDWR | O_TRUNC | O_CREAT, 0644);
> 	if (personality > 0)
> 		sqe->personality = personality;
> 
> 	rc = io_uring_submit(ring);
> 	if (rc < 0)
> 		fatal("io_uring_submit(open)");
> 
> 	rc = io_uring_wait_cqe(ring, &cqe);
> 	fds[0] = cqe->res;
> 	if (rc < 0)
> 		fatal("io_uring_wait_cqe(open)");
> 	if (fds[0] < 0)
> 		fatal("uring_open");
> 	io_uring_cqe_seen(ring, cqe);
> 
> 	rc = io_uring_register_files(ring, fds, 1);
> 	if(rc)
> 		fatal("io_uring_register_files");
> 
> 	printf(">>> io_uring open(): OK\n");
> 
> 	/*
> 	 * write
> 	 */
> 
> 	sqe = io_uring_get_sqe(ring);
> 	if (!sqe)
> 		fatal("io_uring_get_sqe(write1)");
> 	io_uring_prep_write(sqe, 0, buf1, str_sz, 0);
> 	io_uring_sqe_set_flags(sqe, IOSQE_FIXED_FILE);
> 	if (personality > 0)
> 		sqe->personality = personality;
> 
> 	rc = io_uring_submit(ring);
> 	if (rc < 0)
> 		fatal("io_uring_submit(write)");
> 
> 	rc = io_uring_wait_cqe(ring, &cqe);
> 	if (rc < 0)
> 		fatal("io_uring_wait_cqe(write)");
> 	if (cqe->res < 0)
> 		fatal("uring_write");
> 	if (cqe->res != str_sz)
> 		fatal("uring_write(length)");
> 	io_uring_cqe_seen(ring, cqe);
> 
> 	printf(">>> io_uring write(): OK\n");
> 
> 	/*
> 	 * read
> 	 */
> 
> 	sqe = io_uring_get_sqe(ring);
> 	if (!sqe)
> 		fatal("io_uring_get_sqe(read1)");
> 	io_uring_prep_read(sqe, 0, buf2,__OP_A_BSIZE, 0);
> 	io_uring_sqe_set_flags(sqe, IOSQE_FIXED_FILE);
> 	if (personality > 0)
> 		sqe->personality = personality;
> 
> 	rc = io_uring_submit(ring);
> 	if (rc < 0)
> 		fatal("io_uring_submit(read)");
> 
> 	rc = io_uring_wait_cqe(ring, &cqe);
> 	if (rc < 0)
> 		fatal("io_uring_wait_cqe(read)");
> 	if (cqe->res < 0)
> 		fatal("uring_read");
> 	if (cqe->res != str_sz)
> 		fatal("uring_read(length)");
> 	io_uring_cqe_seen(ring, cqe);
> 
> 	if (strncmp(buf1, buf2, str_sz))
> 		fatal("strncmp(buf1,buf2)");
> 
> 	printf(">>> io_uring read(): OK\n");
> 
> 	/*
> 	 * close
> 	 */
> 
> 	sqe = io_uring_get_sqe(ring);
> 	if (!sqe)
> 		fatal("io_uring_get_sqe(close)");
> 	io_uring_prep_close(sqe, 0);
> 	if (personality > 0)
> 		sqe->personality = personality;
> 
> 	rc = io_uring_submit(ring);
> 	if (rc < 0)
> 		fatal("io_uring_submit(close)");
> 
> 	rc = io_uring_wait_cqe(ring, &cqe);
> 	if (rc < 0)
> 		fatal("io_uring_wait_cqe(close)");
> 	if (cqe->res < 0)
> 		fatal("uring_close");
> 	io_uring_cqe_seen(ring, cqe);
> 
> 	rc = io_uring_unregister_files(ring);
> 	if (rc < 0)
> 		fatal("io_uring_unregister_files");
> 
> 	printf(">>> io_uring close(): OK\n");
> 
> 	return 0;
> }
> 
> /**
>  * The main entrypoint to the test program
>  * @param argc number of command line options
>  * @param argv the command line options array
>  */
> int main(int argc, char *argv[])
> {
> 	int rc = 1;
> 	int ring_shm_fd;
> 	struct io_uring ring_storage, *ring;
> 	struct urt_config *cfg_p;
> 
> 	enum { TST_UNKNOWN,
> 	       TST_SQPOLL,
> 	       TST_T1_PARENT, TST_T1_CHILD } tst_method;
> 
> 	/* parse the command line and do some sanity checks */
> 	tst_method = TST_UNKNOWN;
> 	if (argc >= 2) {
> 		if (!strcmp(argv[1], "sqpoll"))
> 			tst_method = TST_SQPOLL;
> 		else if (!strcmp(argv[1], "t1") ||
> 			 !strcmp(argv[1], "t1_parent"))
> 			tst_method = TST_T1_PARENT;
> 		else if (!strcmp(argv[1], "t1_child"))
> 			tst_method = TST_T1_CHILD;
> 	}
> 	if (tst_method == TST_UNKNOWN) {
> 		fprintf(stderr, "usage: %s <method> ... \n", argv[0]);
> 		exit(EINVAL);
> 	}
> 
> 	/* simple header */
> 	printf(">>> running as PID = %d\n", getpid());
> 	printf(">>> LSM/SELinux = %s\n", selinux_current());
> 
> 	/*
> 	 * test setup (if necessary)
> 	 */
> 	if (tst_method == TST_SQPOLL || tst_method == TST_T1_PARENT) {
> 		 /* create an io_uring and prepare it for optional sharing */
> 		int flags;
> 
> 		/* create a shm segment to hold the io_uring info */
> 		ring_shm_fd = shm_open(URING_SHM_NAME, O_CREAT | O_RDWR,
> 				       S_IRUSR | S_IWUSR);
> 		if (ring_shm_fd < 0)
> 			fatal("shm_open(create)");
> 
> 		rc = ftruncate(ring_shm_fd, sizeof(struct urt_config));
> 		if (rc < 0)
> 			fatal("ftruncate(shm)");
> 
> 		cfg_p = mmap(NULL, sizeof(*cfg_p), PROT_READ | PROT_WRITE,
> 			     MAP_SHARED, ring_shm_fd, 0);
> 		if (!cfg_p)
> 			fatal("mmap(shm)");
> 
> 		/* create the io_uring */
> 		memset(&cfg_p->ring, 0, sizeof(cfg_p->ring));
> 		memset(&cfg_p->ring_params, 0, sizeof(cfg_p->ring_params));
> 		if (tst_method == TST_SQPOLL)
> 			cfg_p->ring_params.flags |= IORING_SETUP_SQPOLL;
> 		rc = uring_setup(&cfg_p->ring, &cfg_p->ring_params,
> 				 &cfg_p->ring_creds);
> 		if (rc)
> 			fatal("uring_setup");
> 		ring = &cfg_p->ring;
> 
> 		/* explicitly clear FD_CLOEXEC on the io_uring */
> 		flags = fcntl(cfg_p->ring.ring_fd, F_GETFD, 0);
> 		if (flags < 0)
> 			fatal("fcntl(ring_shm_fd,getfd)");
> 		flags &= ~FD_CLOEXEC;
> 		rc = fcntl(cfg_p->ring.ring_fd, F_SETFD, flags);
> 		if (rc)
> 			fatal("fcntl(ring_shm_fd,setfd)");
> 	} else if (tst_method = TST_T1_CHILD) {
> 		/* import a previously created and shared io_uring */
> 
> 		/* open the existing shm segment with the io_uring info */
> 		ring_shm_fd = shm_open(URING_SHM_NAME, O_RDWR, 0);
> 		if (ring_shm_fd < 0)
> 			fatal("shm_open(existing)");
> 		cfg_p = mmap(NULL, sizeof(*cfg_p), PROT_READ | PROT_WRITE,
> 			     MAP_SHARED, ring_shm_fd, 0);
> 		if (!cfg_p)
> 			fatal("mmap(shm)");
> 
> 		/* import the io_uring */
> 		ring = &ring_storage;
> 		rc = uring_import(cfg_p->ring.ring_fd,
> 				  ring, &cfg_p->ring_params);
> 		if (rc < 0)
> 			fatal("uring_import");
> 	}
> 
> 	/*
> 	 * fork/exec a child process (if necessary)
> 	 */
> 	if (tst_method == TST_T1_PARENT) {
> 		pid_t pid;
> 
> 		/* set the ctx for the next exec */
> 		if (argc >= 3) {
> 			printf(">>> set LSM/SELinux exec: %s\n",
> 			       (selinux_exec(argv[2]) > 0 ? "OK" : "FAILED"));
> 		}
> 
> 		/* fork/exec */
> 		pid = fork();
> 		if (!pid) {
> 			/* start the child */
> 			rc = execl(argv[0], argv[0], "t1_child", (char *)NULL);
> 			if (rc < 0)
> 				fatal("exec");
> 		} else {
> 			/* wait for the child to exit */
> 			int status;
> 			waitpid(pid, &status, 0);
> 			if (WIFEXITED(status))
> 				rc = WEXITSTATUS(status);
> 		}
> 	}
> 
> 	/*
> 	 * run test(s)
> 	 */
> 	if (tst_method == TST_SQPOLL || tst_method == TST_T1_CHILD) {
> 		rc = uring_op_a(ring, cfg_p->ring_creds, "/tmp/iouring.4.txt");
> 		if (rc < 0)
> 			fatal("uring_op_a(\"/tmp/iouring.4.txt\")");
> 	}
> 
> 	/*
> 	 * cleanup
> 	 */
> 	if (tst_method == TST_SQPOLL || tst_method == TST_T1_PARENT) {
> 		printf(">>> shutdown\n");
> 		uring_shutdown(&cfg_p->ring);
> 		shm_unlink(URING_SHM_NAME);
> 	} else if (tst_method == TST_T1_CHILD) {
> 		shm_unlink(URING_SHM_NAME);
> 	}
> 
> 	return rc;
> }


- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

