Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0B4317055
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 20:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbhBJTh5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Feb 2021 14:37:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233119AbhBJThP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Feb 2021 14:37:15 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF3C1C061788
        for <io-uring@vger.kernel.org>; Wed, 10 Feb 2021 11:36:34 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id j11so2812247wmi.3
        for <io-uring@vger.kernel.org>; Wed, 10 Feb 2021 11:36:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2BBWPOADlaI9skyGqRhLCyu5YWKv1IKA4aGtM6CfFE8=;
        b=E6ujWdXbkChdBBzR5G31Lqp9Y+4IaHUXV79pkGd3H/5I78jbz9scWTrkDNg08ZsY3Z
         HkHBD1Y2IhxexpQSyefXa4cpoGWAdXQp5ZCR3jXsyUtEfvYjf9kwGBuYj+9u9pnGnie0
         qhqx/bsmhnfyCnAuvsl7rA46bGUQ84xXl5qaYZrUMOKSlDIZmUa53thENFcrUALdBe9G
         VfwbA/G4fIrJKkWnjDigZ3S4icliFYJnSAn7qQaSZ+IagUVgMQZbuWgnu1CKL694cH3h
         Zv9M75/t1IHyGOIJvrRBu9doF46BHOgYITQEYIa/xXWE79LzU1D7I/Da6oU3Ycm7X181
         a5YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=2BBWPOADlaI9skyGqRhLCyu5YWKv1IKA4aGtM6CfFE8=;
        b=OarUtU85IOThaYzuk2ouP5knCSyg3W2HLJmv6MQq+boltgCo5DDfLyUhmQ+AVuZG2j
         3+kvJnOeaI1LNCc1vaeRxDL8ak7JC7c2QdnqvvCucHOmP7ppqm7NNtQcF2p6DNjWTJ3O
         L8IJ19MWXcFeXT3piWdqziJZJN/s5CEMeKKd9bmxVNrQ6LBS5Gn/V6uJp4oo27ZFkmva
         991v1O4pi6OCc25hBZWluTIzGEZvfvZRgym/7AYf88GIFMGslepuUbx8zBH0Hw/JAmfh
         5XkZTFc3y3XixayFdXD2GGV/EK+KGyqtDE901CZGPKsJQG+4nAGVZdFxTuX3R6ZFJoGQ
         rduA==
X-Gm-Message-State: AOAM530MhrO2+9fn4EAxfaPF+9CiXh011G09flQBK73OQ42+kgwzL9GT
        Tpi+ZaL7SqoDkx/jMf9Ft4tTwY9xedBbMw==
X-Google-Smtp-Source: ABdhPJzFhBdWsxilTC+eOQ0oFlcvx2ht3NkoDEs1mAARUrXIPXPVcCHyuEi6l9rfoGW2KDpkgN1j3w==
X-Received: by 2002:a1c:f417:: with SMTP id z23mr533742wma.29.1612985793635;
        Wed, 10 Feb 2021 11:36:33 -0800 (PST)
Received: from [192.168.8.194] ([148.252.132.126])
        by smtp.gmail.com with ESMTPSA id h14sm3887677wmq.45.2021.02.10.11.36.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 11:36:33 -0800 (PST)
Subject: Re: CVE-2020-29373 reproducer fails on v5.11
To:     Petr Vorel <pvorel@suse.cz>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Nicolai Stange <nstange@suse.de>,
        Martin Doucha <mdoucha@suse.cz>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        ltp@lists.linux.it
References: <YCQvL8/DMNVLLuuf@pevik>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <b74d54ed-85ba-df4c-c114-fe11d50a3bce@gmail.com>
Date:   Wed, 10 Feb 2021 19:32:46 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <YCQvL8/DMNVLLuuf@pevik>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/02/2021 19:08, Petr Vorel wrote:
> Hi all,
> 
> I found that the reproducer for CVE-2020-29373 from Nicolai Stange (source attached),
> which was backported to LTP as io_uring02 by Martin Doucha [1] is failing since
> 10cad2c40dcb ("io_uring: don't take fs for recvmsg/sendmsg") from v5.11-rc1.

Thanks for letting us know, we need to revert it

> 
> io_uring02 failure:
> io_uring02.c:148: TFAIL: Write outside chroot succeeded.
> 
> The original reproducer (exits with 4) failure:
> error: cqe 255: res=16, but expected -ENOENT
> error: Test failed
> 
> Quoting Nicolai: This is likely to be a real issue with the kernel commit.
> The test tries to do a sendmsg() to an AF_UNIX socket outside
> a chroot. So the res=16 indicates that it was able to look it up and send 16
> bytes to it.
> 
> Then 907d1df30a51 ("io_uring: fix wqe->lock/completion_lock deadlock") from v5.11-rc6 causes
> different errors errors:
> io_uring02.c:161: TFAIL: Write outside chroot result not found
> io_uring02.c:164: TFAIL: Wrong number of entries in completion queue
> 
> According to Nicolai this could be a test bug (test tries to race io_uring into
> processing the sendmsg request asynchronously from a worker thread (where is
> the vulnerability). That was is a needed workaround due missing IOSQE_ASYNC on
> older kernels (< 5.5).
> 
> Tips and comments are welcome.
> 
> Kind regards,
> Petr
> 
> [1] https://github.com/linux-test-project/ltp/tree/master/testcases/kernel/syscalls/io_uring/io_uring02.c
> 
> /*
>  * repro-CVE-2020-29373 -- Reproducer for CVE-2020-29373.
>  *
>  * Copyright (c) 2021 SUSE
>  * Author: Nicolai Stange <nstange@suse.de>
>  *
>  * This program is free software; you can redistribute it and/or
>  * modify it under the terms of the GNU General Public License
>  * as published by the Free Software Foundation; either version 2
>  * of the License, or (at your option) any later version.
>  *
>  * This program is distributed in the hope that it will be useful,
>  * but WITHOUT ANY WARRANTY; without even the implied warranty of
>  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>  * GNU General Public License for more details.
>  *
>  * You should have received a copy of the GNU General Public License
>  * along with this program; if not, see <http://www.gnu.org/licenses/>.
>  */
> 
> #define _GNU_SOURCE
> #include <unistd.h>
> #include <syscall.h>
> #include <linux/io_uring.h>
> #include <stdio.h>
> #include <sys/mman.h>
> #include <sys/socket.h>
> #include <sys/un.h>
> #include <fcntl.h>
> #include <errno.h>
> #include <inttypes.h>
> #include <stdlib.h>
> #include <sys/types.h>
> #include <sys/wait.h>
> 
> static int io_uring_setup(__u32 entries, struct io_uring_params * p)
> {
> 	return (int)syscall(__NR_io_uring_setup, entries, p);
> }
> 
> static int io_uring_enter(unsigned int fd, __u32 to_submit,
> 			  __u32 min_complete, unsigned int flags ,
> 			  sigset_t * sig, size_t sigsz)
> {
> 	return (int)syscall(__NR_io_uring_enter, fd, to_submit,
> 			    min_complete, flags, sig, sigsz);
> }
> 
> /*
>  * This attempts to make the kernel issue a sendmsg() to
>  * path from io_uring's async io_sq_wq_submit_work().
>  *
>  * Unfortunately, IOSQE_ASYNC is available only from kernel version
>  * 5.6 onwards. To still force io_uring to process the request
>  * asynchronously from io_sq_wq_submit_work(), queue a couple of
>  * auxiliary requests all failing with EAGAIN before. This is
>  * implemented by writing repeatedly to an auxiliary O_NONBLOCK
>  * AF_UNIX socketpair with a small SO_SNDBUF.
>  */
> static int try_sendmsg_async(const char * const path)
> {
> 	int r, i, j;
> 
> 	int aux_sock[2];
> 	int snd_sock;
> 	int sockoptval;
> 	char sbuf[16] = { 0 };
> 	struct iovec siov = { .iov_base = &sbuf, .iov_len = sizeof(sbuf) };
> 	struct msghdr aux_msg = {
> 		.msg_name = NULL,
> 		.msg_namelen = 0,
> 		.msg_iov = &siov,
> 		.msg_iovlen = 1,
> 	};
> 	struct sockaddr_un addr = { 0 };
> 	struct msghdr msg = {
> 		.msg_name = &addr,
> 		.msg_namelen = sizeof(addr),
> 		.msg_iov = &siov,
> 		.msg_iovlen = 1,
> 	};
> 
> 	struct io_uring_params iour_params = { 0 };
> 	int iour_fd;
> 	void *iour_sqr_base;
> 	__u32 *iour_sqr_phead;
> 	__u32 *iour_sqr_ptail;
> 	__u32 *iour_sqr_pmask;
> 	__u32 *iour_sqr_parray;
> 	struct io_uring_sqe *iour_sqes;
> 	struct io_uring_sqe *iour_sqe;
> 	void *iour_cqr_base;
> 	__u32 *iour_cqr_phead;
> 	__u32 *iour_cqr_ptail;
> 	__u32 *iour_cqr_pmask;
> 	struct io_uring_cqe *iour_cqr_pcqes;
> 	__u32 iour_sqr_tail;
> 	__u32 iour_cqr_tail;
> 	__u32 n_cqes_seen;
> 
> 	r = socketpair(AF_UNIX, SOCK_DGRAM, 0, aux_sock);
> 	if (r < 0) {
> 		perror("socketpair()");
> 		return 1;
> 	}
> 
> 	sockoptval = 32 + sizeof(sbuf);
> 	r = setsockopt(aux_sock[1], SOL_SOCKET, SO_SNDBUF, &sockoptval,
> 		       sizeof(sockoptval));
> 	if (r < 0) {
> 		perror("setsockopt(SO_SNDBUF)");
> 		goto close_aux_sock;
> 	}
> 
> 	r = fcntl(aux_sock[1], F_SETFL, O_NONBLOCK);
> 	if (r < 0) {
> 		perror("fcntl(F_SETFL, O_NONBLOCK)");
> 		goto close_aux_sock;
> 	}
> 
> 	snd_sock = socket(AF_UNIX, SOCK_DGRAM, 0);
> 	if (snd_sock < 0) {
> 		perror("socket(AF_UNIX)");
> 		r = -1;
> 		goto close_aux_sock;
> 	}
> 
> 	addr.sun_family = AF_UNIX;
> 	strcpy(addr.sun_path, path);
> 
> 	iour_fd = io_uring_setup(512, &iour_params);
> 	if (iour_fd < 0) {
> 		perror("io_uring_setup()");
> 		r = -1;
> 		goto close_socks;
> 	}
> 
> 	iour_sqr_base = mmap(NULL,
> 			     (iour_params.sq_off.array +
> 			      iour_params.sq_entries * sizeof(__u32)),
> 			     PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE,
> 			     iour_fd, IORING_OFF_SQ_RING);
> 	if (iour_sqr_base == MAP_FAILED) {
> 		perror("mmap(IORING_OFF_SQ_RING)");
> 		r = -1;
> 		goto close_iour;
> 	}
> 
> 	iour_sqr_phead = iour_sqr_base + iour_params.sq_off.head;
> 	iour_sqr_ptail = iour_sqr_base + iour_params.sq_off.tail;
> 	iour_sqr_pmask = iour_sqr_base + iour_params.sq_off.ring_mask;
> 	iour_sqr_parray = iour_sqr_base + iour_params.sq_off.array;
> 
> 	iour_sqes = mmap(NULL,
> 			 iour_params.sq_entries * sizeof(struct io_uring_sqe),
> 			 PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE,
> 			 iour_fd, IORING_OFF_SQES);
> 	if (iour_sqes == MAP_FAILED) {
> 		perror("mmap(IORING_OFF_SQES)");
> 		r = -1;
> 		goto close_iour;
> 	}
> 
> 	iour_cqr_base =
> 		mmap(NULL,
> 		     (iour_params.cq_off.cqes +
> 		      iour_params.cq_entries * sizeof(struct io_uring_cqe)),
> 		     PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE,
> 		     iour_fd, IORING_OFF_CQ_RING);
> 	if (iour_cqr_base == MAP_FAILED) {
> 		perror("mmap(IORING_OFF_CQ_RING)");
> 		r = -1;
> 		goto close_iour;
> 	}
> 
> 	iour_cqr_phead = iour_cqr_base + iour_params.cq_off.head;
> 	iour_cqr_ptail = iour_cqr_base + iour_params.cq_off.tail;
> 	iour_cqr_pmask = iour_cqr_base + iour_params.cq_off.ring_mask;
> 	iour_cqr_pcqes = iour_cqr_base + iour_params.cq_off.cqes;
> 
> 	/*
> 	 * First add the auxiliary sqes supposed to fail
> 	 * with -EAGAIN ...
> 	 */
> 	iour_sqr_tail = *iour_sqr_ptail;
> 	for (i = 0, j = iour_sqr_tail; i < 255; ++i, ++j) {
> 		iour_sqe = &iour_sqes[i];
> 		*iour_sqe = (struct io_uring_sqe){0};
> 		iour_sqe->opcode = IORING_OP_SENDMSG;
> 		iour_sqe->flags = IOSQE_IO_DRAIN;
> 		iour_sqe->fd = aux_sock[1];
> 		iour_sqe->addr = (__u64)&aux_msg;
> 		iour_sqe->user_data = i;
> 		iour_sqr_parray[j & *iour_sqr_pmask] = i;
> 	}
> 
> 	/*
> 	 * ... followed by the actual one supposed
> 	 * to fail with -ENOENT.
> 	 */
> 	iour_sqe = &iour_sqes[255];
> 	*iour_sqe = (struct io_uring_sqe){0};
> 	iour_sqe->opcode = IORING_OP_SENDMSG;
> 	iour_sqe->flags = IOSQE_IO_DRAIN;
> 	iour_sqe->fd = snd_sock;
> 	iour_sqe->addr = (__u64)&msg;
> 	iour_sqe->user_data = 255;
> 	iour_sqr_parray[j & *iour_sqr_pmask] = 255;
> 
> 	iour_sqr_tail += 256;
> 	__atomic_store(iour_sqr_ptail, &iour_sqr_tail, __ATOMIC_RELEASE);
> 
> 	r = io_uring_enter(iour_fd, 256, 256, IORING_ENTER_GETEVENTS, NULL, 0);
> 	if (r < 0) {
> 		perror("io_uring_enter");
> 		goto close_iour;
> 	}
> 
> 	if (r != 256) {
> 		fprintf(stderr,
> 			"error: io_uring_enter(): unexpected return value\n");
> 		r = 1;
> 		goto close_iour;
> 	}
> 
> 	r = 0;
> 	n_cqes_seen = 0;
> 	__atomic_load(iour_cqr_ptail, &iour_cqr_tail, __ATOMIC_ACQUIRE);
> 	for(i = *iour_cqr_phead; i != iour_cqr_tail; ++i) {
> 		const struct io_uring_cqe *cqe;
> 
> 		cqe = &iour_cqr_pcqes[i & *iour_cqr_pmask];
> 		++n_cqes_seen;
> 
> 		if (cqe->user_data != 255) {
> 			if (cqe->res < 0 && cqe->res != -EAGAIN) {
> 				r = r < 2 ? 2 : r;
> 				fprintf(stderr,
> 					"error: cqe %" PRIu64 ": res=%" PRId32 "\n",
> 					cqe->user_data, cqe->res);
> 			}
> 		} else if (cqe->res != -ENOENT) {
> 			r = 3;
> 			fprintf(stderr,
> 				"error: cqe %" PRIu64 ": res=%" PRId32 ", but expected -ENOENT\n",
> 				cqe->user_data, cqe->res);
> 		}
> 	}
> 	__atomic_store(iour_cqr_ptail, &iour_cqr_tail, __ATOMIC_RELEASE);
> 
> 	if (n_cqes_seen != 256) {
> 		fprintf(stderr, "error: unexpected number of io_uring cqes\n");
> 		r = 4;
> 	}
> 
> close_iour:
> 	close(iour_fd);
> close_socks:
> 	close(snd_sock);
> close_aux_sock:
> 	close(aux_sock[0]);
> 	close(aux_sock[1]);
> 
> 	return r;
> }
> 
> 
> int main(int argc, char *argv[])
> {
> 	int r;
> 	char tmpdir[] = "/tmp/tmp.XXXXXX";
> 	int rcv_sock;
> 	struct sockaddr_un addr = { 0 };
> 	pid_t c;
> 	int wstatus;
> 
> 	if (!mkdtemp(tmpdir)) {
> 		perror("mkdtemp()");
> 		return 1;
> 	}
> 
> 	rcv_sock = socket(AF_UNIX, SOCK_DGRAM, 0);
> 	if (rcv_sock < 0) {
> 		perror("socket(AF_UNIX)");
> 		r = 1;
> 		goto rmtmpdir;
> 	}
> 
> 	addr.sun_family = AF_UNIX;
> 	snprintf(addr.sun_path, sizeof(addr.sun_path), "%s/sock", tmpdir);
> 
> 	r = bind(rcv_sock, (struct sockaddr *)&addr,
> 		 sizeof(addr));
> 	if (r < 0) {
> 		perror("bind()");
> 		close(rcv_sock);
> 		r = 1;
> 		goto rmtmpdir;
> 	}
> 
> 	c = fork();
> 	if (!c) {
> 		close(rcv_sock);
> 
> 		if (chroot(tmpdir)) {
> 			perror("chroot()");
> 			return 1;
> 		}
> 
> 		r = try_sendmsg_async(addr.sun_path);
> 		if (r < 0) {
> 			/* system call failure */
> 			r = 1;
> 		} else if (r) {
> 			/* test case failure */
> 			r += 1;
> 		}
> 
> 		return r;
> 	}
> 
> 	if (waitpid(c, &wstatus, 0) == (pid_t)-1) {
> 		perror("waitpid()");
> 		r = 1;
> 		goto rmsock;
> 	}
> 
> 	if (!WIFEXITED(wstatus)) {
> 		fprintf(stderr, "child got terminated\n");
> 		r = 1;
> 		goto rmsock;
> 	}
> 
> 	r = WEXITSTATUS(wstatus);
> 	if (r > 1)
> 		fprintf(stderr, "error: Test failed\n");
> 
> rmsock:
> 	close(rcv_sock);
> 	unlink(addr.sun_path);
> 
> rmtmpdir:
> 	rmdir(tmpdir);
> 
> 	return r;
> }
> 

-- 
Pavel Begunkov
