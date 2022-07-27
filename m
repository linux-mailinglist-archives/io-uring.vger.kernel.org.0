Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC9A35832C3
	for <lists+io-uring@lfdr.de>; Wed, 27 Jul 2022 21:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234491AbiG0TE2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jul 2022 15:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234905AbiG0TEJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jul 2022 15:04:09 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16765F132
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 11:26:24 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id n13so9242561ilk.1
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 11:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=KLy6sg89SWcKGio3cGjohMLwLh0KPcbmsJFh3ZMAhtQ=;
        b=D0GkPwCljeC/ulLdtrJepiSULLQKdnLhWpO/ouDB6qkhVDCE+8KbyKn7xRS5dlAvxz
         SuI7gFjGqLohjYs7crUD3DOdHpSPTe0GBl/u6cXqQ1UIRv4/CuAPR5onB8k5SQk2OKan
         ANMoTPeixF95qyg9Cmew5iATDjNZdnhPNC5cspTrhG3L08XodfIoCtLdQcDx9d2Spdmy
         tKsiU7K1LMsiqwGTaCKCrRI3Wup6TfAqV5xIbnjFysKsxK6hG9MG0OgbVDG5Cg10QqQb
         1k667uTVz11FL1vu9AqxQYc9UebFaGMonUR4sCM2GtE7I94T07HNm9wXywwrXbdOUrTY
         wADw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KLy6sg89SWcKGio3cGjohMLwLh0KPcbmsJFh3ZMAhtQ=;
        b=vq0h8t53f1mtCVsCZ+HhCLmmoCWTcVFijHh/8xszbZulbILX2eBWaqtjdINsTEpe2T
         uURFnjfWRzkYjt4pSyX/daeqLoFcgEoLn0qM6aLCb+82USqVW6wRux40KEj1LwgMTL4N
         JP15mG7JZpgjB9GZzYNth7MgPFAJt9Ae1Z5HyCDum5DkiKy5HQ5xhhdSg4FfOvAgFw5m
         Pn4iyYUf8rAIVAimB3SWTpS+J0qS2m4Iwk46LlVgD220PFEZrZbtJgIQE3gsKINhMiMl
         lNLAv9KYllCIXhJJ7jeqvl/B03f9yPoK9vETgVfse2VxSGeMzE+tlTnCUViThbFVEmEQ
         C8Sw==
X-Gm-Message-State: AJIora9gVNhRrJCXfopJ1J9Kepg/n/d3QxL+iCLtqodU+nLRrdsrzKos
        vuRECF8VuIR4eORWNaYtrhqzlB7f2pTmsQ==
X-Google-Smtp-Source: AGRyM1t5Elww5LVbREZ9FKcxJAfikGW7gK+Tr9H8xNgOlkRPiIhSYJ62TVkg/pQfzNtRqHbohSW8Jw==
X-Received: by 2002:a05:6e02:1a0c:b0:2dc:8921:a8d9 with SMTP id s12-20020a056e021a0c00b002dc8921a8d9mr9438048ild.145.1658946383932;
        Wed, 27 Jul 2022 11:26:23 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s26-20020a02c51a000000b00339eedc7840sm8227115jam.94.2022.07.27.11.26.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jul 2022 11:26:23 -0700 (PDT)
Message-ID: <c24d40a8-37cb-6be3-7802-4d5ebda82430@kernel.dk>
Date:   Wed, 27 Jul 2022 12:26:22 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH liburing v2 4/5] test: add io_uring passthrough test
Content-Language: en-US
To:     Ankit Kumar <ankit.kumar@samsung.com>
Cc:     io-uring@vger.kernel.org, joshi.k@samsung.com
References: <20220726105230.12025-1-ankit.kumar@samsung.com>
 <CGME20220726105816epcas5p3365fed54f9ba20518dd8019a50c6c27c@epcas5p3.samsung.com>
 <20220726105230.12025-5-ankit.kumar@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220726105230.12025-5-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/26/22 4:52 AM, Ankit Kumar wrote:
> Add a way to test uring passthrough commands, which was added
> with 5.19 kernel. This requires nvme-ns character device (/dev/ngXnY)
> as filename argument. It runs a combination of read/write tests with
> sqthread poll, vectored and non-vectored commands, fixed I/O buffers.
> 
> Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
> ---
>  test/Makefile               |   1 +
>  test/io_uring_passthrough.c | 319 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 320 insertions(+)
>  create mode 100644 test/io_uring_passthrough.c
> 
> diff --git a/test/Makefile b/test/Makefile
> index a36ddb3..418c11c 100644
> --- a/test/Makefile
> +++ b/test/Makefile
> @@ -90,6 +90,7 @@ test_srcs := \
>  	io-cancel.c \
>  	iopoll.c \
>  	io_uring_enter.c \
> +	io_uring_passthrough.c \
>  	io_uring_register.c \
>  	io_uring_setup.c \
>  	lfs-openat.c \
> diff --git a/test/io_uring_passthrough.c b/test/io_uring_passthrough.c
> new file mode 100644
> index 0000000..2e2b806
> --- /dev/null
> +++ b/test/io_uring_passthrough.c
> @@ -0,0 +1,319 @@
> +/* SPDX-License-Identifier: MIT */
> +/*
> + * Description: basic read/write tests for io_uring passthrough commands
> + */
> +#include <errno.h>
> +#include <stdio.h>
> +#include <unistd.h>
> +#include <stdlib.h>
> +#include <string.h>
> +
> +#include "helpers.h"
> +#include "liburing.h"
> +#include "nvme.h"
> +
> +#define FILE_SIZE	(256 * 1024)
> +#define BS		8192
> +#define BUFFERS		(FILE_SIZE / BS)
> +
> +static struct iovec *vecs;
> +
> +/*
> + * Each offset in the file has the ((test_case / 2) * FILE_SIZE)
> + * + (offset / sizeof(int)) stored for every
> + * sizeof(int) address.
> + */
> +static int verify_buf(int tc, void *buf, off_t off)
> +{
> +	int i, u_in_buf = BS / sizeof(unsigned int);
> +	unsigned int *ptr;
> +
> +	off /= sizeof(unsigned int);
> +	off += (tc / 2) * FILE_SIZE;
> +	ptr = buf;
> +	for (i = 0; i < u_in_buf; i++) {
> +		if (off != *ptr) {
> +			fprintf(stderr, "Found %u, wanted %lu\n", *ptr, off);
> +			return 1;
> +		}
> +		ptr++;
> +		off++;
> +	}
> +
> +	return 0;
> +}
> +
> +static int fill_pattern(int tc)
> +{
> +	unsigned int val, *ptr;
> +	int i, j;
> +	int u_in_buf = BS / sizeof(val);
> +
> +	val = (tc / 2) * FILE_SIZE;
> +	for (i = 0; i < BUFFERS; i++) {
> +		ptr = vecs[i].iov_base;
> +		for (j = 0; j < u_in_buf; j++) {
> +			*ptr = val;
> +			val++;
> +			ptr++;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int __test_io(const char *file, struct io_uring *ring, int tc, int read,
> +		     int sqthread, int fixed, int nonvec)
> +{
> +	struct io_uring_sqe *sqe;
> +	struct io_uring_cqe *cqe;
> +	struct nvme_uring_cmd *cmd;
> +	int open_flags;
> +	int do_fixed;
> +	int i, ret, fd = -1;
> +	off_t offset;
> +	__u64 slba;
> +	__u32 nlb;
> +
> +#ifdef VERBOSE
> +	fprintf(stdout, "%s: start %d/%d/%d/%d: ", __FUNCTION__, read,
> +							sqthread, fixed,
> +							nonvec);
> +#endif
> +	if (read)
> +		open_flags = O_RDONLY;
> +	else
> +		open_flags = O_WRONLY;
> +
> +	if (fixed) {
> +		ret = t_register_buffers(ring, vecs, BUFFERS);
> +		if (ret == T_SETUP_SKIP)
> +			return 0;
> +		if (ret != T_SETUP_OK) {
> +			fprintf(stderr, "buffer reg failed: %d\n", ret);
> +			goto err;
> +		}
> +	}
> +
> +	fd = open(file, open_flags);
> +	if (fd < 0) {
> +		perror("file open");
> +		goto err;
> +	}
> +
> +	if (sqthread) {
> +		ret = io_uring_register_files(ring, &fd, 1);
> +		if (ret) {
> +			fprintf(stderr, "file reg failed: %d\n", ret);
> +			goto err;
> +		}
> +	}
> +
> +	if (!read)
> +		fill_pattern(tc);
> +
> +	offset = 0;
> +	for (i = 0; i < BUFFERS; i++) {
> +		sqe = io_uring_get_sqe(ring);
> +		if (!sqe) {
> +			fprintf(stderr, "sqe get failed\n");
> +			goto err;
> +		}
> +		if (read) {
> +			int use_fd = fd;
> +
> +			do_fixed = fixed;
> +
> +			if (sqthread)
> +				use_fd = 0;
> +			if (fixed && (i & 1))
> +				do_fixed = 0;
> +			if (do_fixed) {
> +				io_uring_prep_read_fixed(sqe, use_fd, vecs[i].iov_base,
> +								vecs[i].iov_len,
> +								offset, i);
> +				sqe->cmd_op = NVME_URING_CMD_IO;
> +			} else if (nonvec) {
> +				io_uring_prep_read(sqe, use_fd, vecs[i].iov_base,
> +							vecs[i].iov_len, offset);
> +				sqe->cmd_op = NVME_URING_CMD_IO;
> +			} else {
> +				io_uring_prep_readv(sqe, use_fd, &vecs[i], 1,
> +								offset);
> +				sqe->cmd_op = NVME_URING_CMD_IO_VEC;
> +			}
> +		} else {
> +			int use_fd = fd;
> +
> +			do_fixed = fixed;
> +
> +			if (sqthread)
> +				use_fd = 0;
> +			if (fixed && (i & 1))
> +				do_fixed = 0;
> +			if (do_fixed) {
> +				io_uring_prep_write_fixed(sqe, use_fd, vecs[i].iov_base,
> +								vecs[i].iov_len,
> +								offset, i);
> +				sqe->cmd_op = NVME_URING_CMD_IO;
> +			} else if (nonvec) {
> +				io_uring_prep_write(sqe, use_fd, vecs[i].iov_base,
> +							vecs[i].iov_len, offset);
> +				sqe->cmd_op = NVME_URING_CMD_IO;
> +			} else {
> +				io_uring_prep_writev(sqe, use_fd, &vecs[i], 1,
> +								offset);
> +				sqe->cmd_op = NVME_URING_CMD_IO_VEC;
> +			}
> +		}
> +		sqe->opcode = IORING_OP_URING_CMD;
> +		sqe->user_data = ((uint64_t)offset << 32) | i;
> +		if (sqthread)
> +			sqe->flags |= IOSQE_FIXED_FILE;
> +
> +		/* 80 bytes for NVMe uring passthrough command */
> +		cmd = (struct nvme_uring_cmd *)sqe->cmd;
> +		memset(cmd, 0, sizeof(struct nvme_uring_cmd));
> +
> +		cmd->opcode = read ? nvme_cmd_read : nvme_cmd_write;
> +
> +		slba = offset >> lba_shift;
> +		nlb = (BS >> lba_shift) - 1;
> +
> +		/* cdw10 and cdw11 represent starting lba */
> +		cmd->cdw10 = slba & 0xffffffff;
> +		cmd->cdw11 = slba >> 32;
> +		/* cdw12 represent number of lba's for read/write */
> +		cmd->cdw12 = nlb;
> +		if (do_fixed || nonvec) {
> +			cmd->addr = (__u64)(uintptr_t)vecs[i].iov_base;
> +			cmd->data_len = vecs[i].iov_len;
> +		} else {
> +			cmd->addr = (__u64)(uintptr_t)&vecs[i];
> +			cmd->data_len = 1;
> +		}
> +		cmd->nsid = nsid;
> +
> +		offset += BS;
> +	}
> +
> +	ret = io_uring_submit(ring);
> +	if (ret != BUFFERS) {
> +		fprintf(stderr, "submit got %d, wanted %d\n", ret, BUFFERS);
> +		goto err;
> +	}
> +
> +	for (i = 0; i < BUFFERS; i++) {
> +		ret = io_uring_wait_cqe(ring, &cqe);
> +		if (ret) {
> +			fprintf(stderr, "wait_cqe=%d\n", ret);
> +			goto err;
> +		}
> +		if (cqe->res != 0) {
> +			fprintf(stderr, "cqe res %d, wanted 0\n", cqe->res);
> +			goto err;
> +		}
> +		io_uring_cqe_seen(ring, cqe);
> +		if (read) {
> +			int index = cqe->user_data & 0xffffffff;
> +			void *buf = vecs[index].iov_base;
> +			off_t voff = cqe->user_data >> 32;
> +
> +			if (verify_buf(tc, buf, voff))
> +				goto err;
> +		}
> +	}
> +
> +	if (fixed) {
> +		ret = io_uring_unregister_buffers(ring);
> +		if (ret) {
> +			fprintf(stderr, "buffer unreg failed: %d\n", ret);
> +			goto err;
> +		}
> +	}
> +	if (sqthread) {
> +		ret = io_uring_unregister_files(ring);
> +		if (ret) {
> +			fprintf(stderr, "file unreg failed: %d\n", ret);
> +			goto err;
> +		}
> +	}
> +
> +	close(fd);
> +#ifdef VERBOSE
> +	fprintf(stdout, "PASS\n");
> +#endif
> +	return 0;
> +err:
> +#ifdef VERBOSE
> +	fprintf(stderr, "FAILED\n");
> +#endif
> +	if (fd != -1)
> +		close(fd);
> +	return 1;
> +}
> +
> +static int test_io(const char *file, int tc, int read, int sqthread,
> +		   int fixed, int nonvec)
> +{
> +	struct io_uring ring;
> +	int ret, ring_flags = 0;
> +
> +	ring_flags |= IORING_SETUP_SQE128;
> +	ring_flags |= IORING_SETUP_CQE32;
> +
> +	if (sqthread)
> +		ring_flags |= IORING_SETUP_SQPOLL;
> +
> +	ret = t_create_ring(64, &ring, ring_flags);
> +	if (ret == T_SETUP_SKIP)
> +		return 0;
> +	if (ret != T_SETUP_OK) {
> +		fprintf(stderr, "ring create failed: %d\n", ret);
> +		return 1;
> +	}
> +
> +	ret = __test_io(file, &ring, tc, read, sqthread, fixed, nonvec);
> +	io_uring_queue_exit(&ring);
> +
> +	return ret;
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	int i, ret;
> +	char *fname;
> +
> +	if (argc < 2) {
> +		printf("%s: requires NVMe character device\n", argv[0]);
> +		return T_EXIT_SKIP;
> +	}
> +
> +	fname = argv[1];
> +	ret = fio_nvme_get_info(fname);
> +
> +	if (ret) {
> +		fprintf(stderr, "failed to fetch device info: %d\n", ret);
> +		goto err;
> +	}

If we can't open the device, then we should probably turn this into a
SKIP rather than a FAIL?

Same for if the argument passed isn't actually an nvme device, it should
just skip the test in that case rather than print errors.

-- 
Jens Axboe

