Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8093731A688
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 22:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbhBLVHy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Feb 2021 16:07:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231731AbhBLVHs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Feb 2021 16:07:48 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E831DC061574
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 13:07:07 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id g10so885249wrx.1
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 13:07:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pg1BkuPrbfd18fqyZpBd/KhweFR9SeT087f4mgUF+rU=;
        b=jFUq+7kEzfrtcM1dpD4ryIF82ZLDdc+domyOB3JyTdgVKWAX3eIFTGkxgd4+hjIxbP
         /fEBUzV7vIxy08cJFXb3UdicdEvAaY6CvVKbySMaPZ8IYXwqgv36hKATjcJO1pj0lqvC
         kV+ojMvcB3BSc+5x+JzJd8s/8uPYirsyRfmfR/IkH4DBuXBwOPz45egjooICq9HMfSPZ
         ZWF8z+yyIZHLC8OvfPwDtObu3rwPVPbdwUNmaKrC0+jEeB7seXJpoDACi9qZW7KFN2pc
         oYynkK0vwAHreurhazuje1HeLf9HpBhAcX5aIlH1ojk4d28nHKLIq1QRpHmcAudPi/XV
         kkdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=pg1BkuPrbfd18fqyZpBd/KhweFR9SeT087f4mgUF+rU=;
        b=a89W4BYL8NtnO++JMBH0WP7cxyTp90V+EZt+seU7CDSOdPbaKJ7iQr7UgnRwtonizX
         QcC9feQd7ur3dvETONrkSGvnn7nKYYeeWDbZRPQldqqH2hTar0XB1/uhitUm5QXNHeTy
         guYUTtxgPQDF/R3tKK/R5YpGtQ7QED2E0zN8ds3WrIC4TKYow+bi10EaX+U+ndy5Iak1
         QAJT/04Bph4jxvbVKskVjjmhBjd/YMHWK23iG6kP6Nyz842VLYC2h2bwL5aAKdO34Y1f
         PeN7Q4m21HQOZTWMRZhD/P3sAtTpGSnFuhEdYmfmMVrLBcajmhb5RDSob7cWNpOOebqH
         emCg==
X-Gm-Message-State: AOAM532LfehhlYPwGI8m8rC+sWr1+LFpJO/oaqQU9LkBsvufmU8N7m3g
        0E2qBn/+3PS785X8i7OfcRmS6vqseS92Gg==
X-Google-Smtp-Source: ABdhPJzfadkkziQcal7vdCW5bYeL6a78aJMkwTayTdecC4xJJ2vGzRUfpqvV6f55v7e5KRmRkiqFKg==
X-Received: by 2002:adf:f54c:: with SMTP id j12mr5456136wrp.175.1613164026712;
        Fri, 12 Feb 2021 13:07:06 -0800 (PST)
Received: from [192.168.8.115] ([185.69.144.228])
        by smtp.gmail.com with ESMTPSA id s10sm12316085wrm.5.2021.02.12.13.07.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 13:07:06 -0800 (PST)
Subject: Re: [PATCH liburing] a test for CVE-2020-29373 (AF_UNIX path
 resolution)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Petr Vorel <pvorel@suse.cz>
References: <43f46a40dbc37bebf78f14d7738d5195dbb64460.1613163628.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <53d0db2d-2692-887f-2eb1-947ef0713518@gmail.com>
Date:   Fri, 12 Feb 2021 21:03:19 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <43f46a40dbc37bebf78f14d7738d5195dbb64460.1613163628.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/02/2021 21:02, Pavel Begunkov wrote:
> Add a regression test for CVE-2020-29373 where io-wq do path resolution
> issuing sendmsg, but doesn't have proper fs set up.

Jens, what about licenses? The original test is GPLv2

> 
> Reported-by: Petr Vorel <pvorel@suse.cz>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  test/Makefile         |   2 +
>  test/sendmsg_fs_cve.c | 193 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 195 insertions(+)
>  create mode 100644 test/sendmsg_fs_cve.c
> 
> diff --git a/test/Makefile b/test/Makefile
> index 157ff95..7751eff 100644
> --- a/test/Makefile
> +++ b/test/Makefile
> @@ -111,6 +111,7 @@ test_targets += \
>  	timeout-overflow \
>  	unlink \
>  	wakeup-hang \
> +	sendmsg_fs_cve \
>  	# EOL
>  
>  all_targets += $(test_targets)
> @@ -238,6 +239,7 @@ test_srcs := \
>  	timeout.c \
>  	unlink.c \
>  	wakeup-hang.c \
> +	sendmsg_fs_cve.c \
>  	# EOL
>  
>  test_objs := $(patsubst %.c,%.ol,$(patsubst %.cc,%.ol,$(test_srcs)))
> diff --git a/test/sendmsg_fs_cve.c b/test/sendmsg_fs_cve.c
> new file mode 100644
> index 0000000..85f271b
> --- /dev/null
> +++ b/test/sendmsg_fs_cve.c
> @@ -0,0 +1,193 @@
> +/*
> + * repro-CVE-2020-29373 -- Reproducer for CVE-2020-29373.
> + *
> + * Copyright (c) 2021 SUSE
> + * Author: Nicolai Stange <nstange@suse.de>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <unistd.h>
> +#include <syscall.h>
> +#include <stdio.h>
> +#include <sys/mman.h>
> +#include <sys/socket.h>
> +#include <sys/un.h>
> +#include <fcntl.h>
> +#include <errno.h>
> +#include <inttypes.h>
> +#include <stdlib.h>
> +#include <sys/types.h>
> +#include <sys/wait.h>
> +#include "liburing.h"
> +
> +/*
> + * This attempts to make the kernel issue a sendmsg() to
> + * path from io_uring's async io_sq_wq_submit_work().
> + *
> + * Unfortunately, IOSQE_ASYNC is available only from kernel version
> + * 5.6 onwards. To still force io_uring to process the request
> + * asynchronously from io_sq_wq_submit_work(), queue a couple of
> + * auxiliary requests all failing with EAGAIN before. This is
> + * implemented by writing repeatedly to an auxiliary O_NONBLOCK
> + * AF_UNIX socketpair with a small SO_SNDBUF.
> + */
> +static int try_sendmsg_async(const char * const path)
> +{
> +	int snd_sock, r;
> +	struct io_uring ring;
> +	char sbuf[16] = {};
> +	struct iovec siov = { .iov_base = &sbuf, .iov_len = sizeof(sbuf) };
> +	struct sockaddr_un addr = {};
> +	struct msghdr msg = {
> +		.msg_name = &addr,
> +		.msg_namelen = sizeof(addr),
> +		.msg_iov = &siov,
> +		.msg_iovlen = 1,
> +	};
> +	struct io_uring_cqe *cqe;
> +	struct io_uring_sqe *sqe;
> +
> +	snd_sock = socket(AF_UNIX, SOCK_DGRAM, 0);
> +	if (snd_sock < 0) {
> +		perror("socket(AF_UNIX)");
> +		return -1;
> +	}
> +
> +	addr.sun_family = AF_UNIX;
> +	strcpy(addr.sun_path, path);
> +
> +	r = io_uring_queue_init(512, &ring, 0);
> +	if (r < 0) {
> +		fprintf(stderr, "ring setup failed: %d\n", r);
> +		goto close_iour;
> +	}
> +
> +	sqe = io_uring_get_sqe(&ring);
> +	if (!sqe) {
> +		fprintf(stderr, "get sqe failed\n");
> +		r = -EFAULT;
> +		goto close_iour;
> +	}
> +
> +	/* the actual one supposed to fail with -ENOENT. */
> +	io_uring_prep_sendmsg(sqe, snd_sock, &msg, 0);
> +	sqe->flags = IOSQE_ASYNC;
> +	sqe->user_data = 255;
> +
> +	r = io_uring_submit(&ring);
> +	if (r != 1) {
> +		fprintf(stderr, "sqe submit failed: %d\n", r);
> +		r = -EFAULT;
> +		goto close_iour;
> +	}
> +
> +	r = io_uring_wait_cqe(&ring, &cqe);
> +	if (r < 0) {
> +		fprintf(stderr, "wait completion %d\n", r);
> +		r = -EFAULT;
> +		goto close_iour;
> +	}
> +	if (cqe->user_data != 255) {
> +		fprintf(stderr, "user data %d\n", r);
> +		r = -EFAULT;
> +		goto close_iour;
> +	}
> +	if (cqe->res != -ENOENT) {
> +		r = 3;
> +		fprintf(stderr,
> +			"error: cqe %i: res=%i, but expected -ENOENT\n",
> +			(int)cqe->user_data, (int)cqe->res);
> +	}
> +	io_uring_cqe_seen(&ring, cqe);
> +
> +close_iour:
> +	io_uring_queue_exit(&ring);
> +	close(snd_sock);
> +	return r;
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	int r;
> +	char tmpdir[] = "/tmp/tmp.XXXXXX";
> +	int rcv_sock;
> +	struct sockaddr_un addr = {};
> +	pid_t c;
> +	int wstatus;
> +
> +	if (!mkdtemp(tmpdir)) {
> +		perror("mkdtemp()");
> +		return 1;
> +	}
> +
> +	rcv_sock = socket(AF_UNIX, SOCK_DGRAM, 0);
> +	if (rcv_sock < 0) {
> +		perror("socket(AF_UNIX)");
> +		r = 1;
> +		goto rmtmpdir;
> +	}
> +
> +	addr.sun_family = AF_UNIX;
> +	snprintf(addr.sun_path, sizeof(addr.sun_path), "%s/sock", tmpdir);
> +
> +	r = bind(rcv_sock, (struct sockaddr *)&addr,
> +		 sizeof(addr));
> +	if (r < 0) {
> +		perror("bind()");
> +		close(rcv_sock);
> +		r = 1;
> +		goto rmtmpdir;
> +	}
> +
> +	c = fork();
> +	if (!c) {
> +		close(rcv_sock);
> +
> +		if (chroot(tmpdir)) {
> +			perror("chroot()");
> +			return 1;
> +		}
> +
> +		r = try_sendmsg_async(addr.sun_path);
> +		if (r < 0) {
> +			/* system call failure */
> +			r = 1;
> +		} else if (r) {
> +			/* test case failure */
> +			r += 1;
> +		}
> +		return r;
> +	}
> +
> +	if (waitpid(c, &wstatus, 0) == (pid_t)-1) {
> +		perror("waitpid()");
> +		r = 1;
> +		goto rmsock;
> +	}
> +	if (!WIFEXITED(wstatus)) {
> +		fprintf(stderr, "child got terminated\n");
> +		r = 1;
> +		goto rmsock;
> +	}
> +	r = WEXITSTATUS(wstatus);
> +	if (r)
> +		fprintf(stderr, "error: Test failed\n");
> +rmsock:
> +	close(rcv_sock);
> +	unlink(addr.sun_path);
> +rmtmpdir:
> +	rmdir(tmpdir);
> +	return r;
> +}
> 

-- 
Pavel Begunkov
