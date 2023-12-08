Return-Path: <io-uring+bounces-259-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 35FDE809A17
	for <lists+io-uring@lfdr.de>; Fri,  8 Dec 2023 04:13:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EB59FB20E30
	for <lists+io-uring@lfdr.de>; Fri,  8 Dec 2023 03:13:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B06192103;
	Fri,  8 Dec 2023 03:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="r/t3ZvMM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F34B2D54
	for <io-uring@vger.kernel.org>; Thu,  7 Dec 2023 19:13:22 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1d2eea4af93so107315ad.1
        for <io-uring@vger.kernel.org>; Thu, 07 Dec 2023 19:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1702005201; x=1702610001; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s3yscnzXnY+UQs5G5cZuGVlsNUO/lseHjIK1RnwG1fA=;
        b=r/t3ZvMMZKtn0i8j2uN/SEn2BVA4M4hGrjGtNiwnKBJ3RClWKJQ28Hy+Cap6F6RBKI
         afT8V8JeTRhI7EDZc1ToSSFWUYDWQkdhuX72iaA/4bk0QP6xP4ksL/+HeFHhO6qO1UFR
         qD4DdHwUtKZu3Yb9rVNieyTpR6/AMJHQKUvzvzRhMAjyBgkbNvcTgVZfod5gOtaWPsnf
         TTHMlSGbhWPG+4qd8bQPRaaClmHL6YqHSBf3d8hGGPXOjIID4b7prBjBJ3NkFOTU1WLu
         peWAvjpK4e/+OSUz/YkmEFEjeHHGMvOfrQqFOuN9N5qS3AdHLNHBLieTXRu0LgbPQUlx
         yYMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702005201; x=1702610001;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s3yscnzXnY+UQs5G5cZuGVlsNUO/lseHjIK1RnwG1fA=;
        b=Ag0+6OjLtPST9lgLvY24+ZMiSRekWSH5nBRjplft8uX2KZKUHsIhWZ4lHHoTtGnD90
         7AzeGOr+JxHKHSnFBDG5z8c7YugR+fE8JmwGMa2Iw2BEp0prS5EAlR20nD3I4zQW8ofh
         46x7M6UqM5A+yVaSuXLmGhtkz30RiknWNSJj78+v5gzqWlEdod1vmuxQTqFQtxk8w3LT
         MHd1iMb5vS/n4lJsrN/ctpfRKd9pfheXUA+s9jfK9lGvkO9f26+/HB2/PxTkMZP4e+ia
         Y/dVT08YlcknIjsMmhrUe7BoT1j/uYm8k/q/e5yjUcnzMJrG3u/oFve3sk1GEnziF6oA
         +2+g==
X-Gm-Message-State: AOJu0YyfBHfzLAItZAEliSdu8hSO7/3VhGRGm3vOg/2wUMOYXBJBCPuY
	axRpq3GjYEck+A5GlVpXTxDVr/IaLcFVixAy/WOuvA==
X-Google-Smtp-Source: AGHT+IFvAElZdW9V28QHUUzv8uqir+1yX+W9OY24IsLkVS6Uj/9tMMSsGBvpUHs2Xwkg0KkKm1gleQ==
X-Received: by 2002:a17:902:ea03:b0:1d0:56b9:3730 with SMTP id s3-20020a170902ea0300b001d056b93730mr6914725plg.5.1702005201573;
        Thu, 07 Dec 2023 19:13:21 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id d11-20020a170902c18b00b001bc6e6069a6sm547842pld.122.2023.12.07.19.13.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Dec 2023 19:13:20 -0800 (PST)
Message-ID: <f50fd0de-cd3a-4012-8ce3-67596dbb0eeb@kernel.dk>
Date: Thu, 7 Dec 2023 20:13:20 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/openclose: add support for
 IORING_OP_FIXED_FD_INSTALL
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
To: io-uring <io-uring@vger.kernel.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>,
 Christian Brauner <brauner@kernel.org>
References: <df0e24ff-f3a0-4818-8282-2a4e03b7b5a6@kernel.dk>
In-Reply-To: <df0e24ff-f3a0-4818-8282-2a4e03b7b5a6@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Here's a sample test case showing the various transformations and
testing validity.

/* SPDX-License-Identifier: MIT */
/*
 * Description: test installing a direct descriptor into the regular
 *		file table
 *
 */
#include <errno.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>

#include "liburing.h"
#include "helpers.h"

static int no_fd_install;

static void io_uring_prep_fixed_fd_install(struct io_uring_sqe *sqe, int fd)
{
	memset(sqe, 0, sizeof(*sqe));
	sqe->opcode = IORING_OP_FIXED_FD_INSTALL;
	sqe->fd = fd;
}

int main(int argc, char *argv[])
{
	struct io_uring_sqe *sqe;
	struct io_uring_cqe *cqe;
	struct io_uring ring;
	int ret, fds[2];
	char buf[32];

	if (argc > 1)
		return T_EXIT_SKIP;

	ret = io_uring_queue_init(1, &ring, 0);
	if (ret) {
		fprintf(stderr, "ring setup failed: %d\n", ret);
		return T_EXIT_FAIL;
	}

	if (pipe(fds) < 0) {
		perror("pipe");
		return T_EXIT_FAIL;
	}

	/* register read side */
	ret = io_uring_register_files(&ring, &fds[0], 1);
	if (ret) {
		fprintf(stderr, "failed register files %d\n", ret);
		return T_EXIT_FAIL;
	}

	/* close normal descriptor */
	close(fds[0]);

	/* normal read should fail */
	ret = read(fds[0], buf, 1);
	if (ret != -1) {
		fprintf(stderr, "unexpected read ret %d\n", ret);
		return T_EXIT_FAIL;
	}
	if (errno != EBADF) {
		fprintf(stderr, "unexpected read failure %d\n", errno);
		return T_EXIT_FAIL;
	}

	/* verify we can read the data */
	sqe = io_uring_get_sqe(&ring);
	io_uring_prep_read(sqe, 0, buf, sizeof(buf), 0);
	sqe->flags = IOSQE_FIXED_FILE;
	io_uring_submit(&ring);

	/* put some data in the pipe */
	write(fds[1], "Hello", 5);

	ret = io_uring_wait_cqe(&ring, &cqe);
	if (ret) {
		fprintf(stderr, "wait cqe %d\n", ret);
		return T_EXIT_FAIL;
	}
	if (cqe->res != 5) {
		fprintf(stderr, "weird pipe read ret %d\n", cqe->res);
		return T_EXIT_FAIL;
	}
	io_uring_cqe_seen(&ring, cqe);

	/* fixed pipe read worked, now re-install as a regular fd */
	sqe = io_uring_get_sqe(&ring);
	io_uring_prep_fixed_fd_install(sqe, 0);
	sqe->flags = IOSQE_FIXED_FILE;
	io_uring_submit(&ring);

	ret = io_uring_wait_cqe(&ring, &cqe);
	if (ret) {
		fprintf(stderr, "wait cqe %d\n", ret);
		return T_EXIT_FAIL;
	}
	if (cqe->res == -EINVAL) {
		no_fd_install = 1;
		return T_EXIT_SKIP;
	}
	if (cqe->res < 0) {
		fprintf(stderr, "failed install fd: %d\n", cqe->res);
		return T_EXIT_FAIL;
	}
	/* stash new pipe read side fd in old spot */
	fds[0] = cqe->res;
	io_uring_cqe_seen(&ring, cqe);

	write(fds[1], "Hello", 5);

	/* normal pipe read should now work with new fd */
	ret = read(fds[0], buf, sizeof(buf));
	if (ret != 5) {
		fprintf(stderr, "unexpected read ret %d\n", ret);
		return T_EXIT_FAIL;
	}

	/* close fixed file */
	sqe = io_uring_get_sqe(&ring);
	io_uring_prep_close_direct(sqe, 0);
	io_uring_submit(&ring);

	ret = io_uring_wait_cqe(&ring, &cqe);
	if (ret) {
		fprintf(stderr, "wait cqe %d\n", ret);
		return T_EXIT_FAIL;
	}
	if (cqe->res) {
		fprintf(stderr, "close fixed fd %d\n", cqe->res);
		return T_EXIT_FAIL;
	}
	io_uring_cqe_seen(&ring, cqe);

	write(fds[1], "Hello", 5);

	/* normal pipe read should still work with new fd */
	ret = read(fds[0], buf, sizeof(buf));
	if (ret != 5) {
		fprintf(stderr, "unexpected read ret %d\n", ret);
		return T_EXIT_FAIL;
	}

	/* fixed fd pipe read should now fail */
	sqe = io_uring_get_sqe(&ring);
	io_uring_prep_read(sqe, 0, buf, sizeof(buf), 0);
	sqe->flags = IOSQE_FIXED_FILE;
	io_uring_submit(&ring);

	/* put some data in the pipe */
	write(fds[1], "Hello", 5);

	ret = io_uring_wait_cqe(&ring, &cqe);
	if (ret) {
		fprintf(stderr, "wait cqe %d\n", ret);
		return T_EXIT_FAIL;
	}
	if (cqe->res != -EBADF) {
		fprintf(stderr, "weird pipe read ret %d\n", cqe->res);
		return T_EXIT_FAIL;
	}
	io_uring_cqe_seen(&ring, cqe);

	return T_EXIT_PASS;
}

-- 
Jens Axboe


