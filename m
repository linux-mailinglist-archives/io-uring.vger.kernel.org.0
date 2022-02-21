Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A1A4BE2BB
	for <lists+io-uring@lfdr.de>; Mon, 21 Feb 2022 18:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233598AbiBUQ3a (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Feb 2022 11:29:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232835AbiBUQ33 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Feb 2022 11:29:29 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE40A13F0A
        for <io-uring@vger.kernel.org>; Mon, 21 Feb 2022 08:29:05 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id t4-20020a17090a3b4400b001bc40b548f9so2820519pjf.0
        for <io-uring@vger.kernel.org>; Mon, 21 Feb 2022 08:29:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZZJCle+XtrPPNQAsQYSJf5gpArMqUOfJLxowkd/X8ww=;
        b=cDo8O1J3leZmgFGyw7M9oSyqIrypUEWkDTi4GNlvHkrwQIssGj1z+Fhg0QxiUQhL1M
         nsma/3ea3VaF+50hJ7BNv8jnnFMSuFjrFDzd0OAke39lrw9wpOX+5Vx3a2Ipfb8bdvfm
         3BGyuuCuCcSDHh4HwsoNpkofLlyVHhkXXkZgCKbAycEy4FazwqC99mXgLH9JNyZ/0QTb
         HSd7JDwazGjwB8CsYxgZhcGa40hG3mEn3+SUk0ahvZOpbZ19P6pqLMcmIxStHalf/xij
         WBrVUlcmTzAZXtcobLxrzHIt4adNR1WbtZrZmzXZ38bi+uytHMIRBP+UZMEzqb3Z2q1N
         FqGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZZJCle+XtrPPNQAsQYSJf5gpArMqUOfJLxowkd/X8ww=;
        b=6/p8a6ryYDXISnulZa+TfOPtjf/PsuToAADs2cHQPqfsUMVBX1CGNDJAGN+xRZnfWX
         b980bvepBmbwTqvVEHgwLvG9cE3odyxqOOVrHdoxbZFmYxRTHB5yuKjXh3vVg2p+7h5d
         I0h1Woc52EsXSkFE+c4oHY6mf6gT7B1rZVcrTLP3DZrkcng2AEH3l1ZZyM5a/jYg82R/
         dOVDT50I5gmhV9yVG8fFh9T7pnq2rCeyXBUduzvc6EOU/q2Xt7s6A/jCjMdmla/yQMYk
         2DBODViiDqQ4728xw2jONV3J4Rle7TkX1RT/OX99Cx+I6aBHXoV2FJS7Q4e/YmXrAkXa
         urzQ==
X-Gm-Message-State: AOAM530CjVJkWdQvTB250ZlKlECp8q2HQ7xyWgSVqO4FzCkxw+q1tE21
        drOX5Oqw9/1xCg34bcFhESuKDA==
X-Google-Smtp-Source: ABdhPJxBMCKi/tMLG/TAS2Sd8MaP1CsQMbgC7+M7/IzvHsv7u2cbhrJXFxePC/7I0cUTAsDddkXykg==
X-Received: by 2002:a17:90a:7109:b0:1b9:ae85:9a3a with SMTP id h9-20020a17090a710900b001b9ae859a3amr22123414pjk.230.1645460945093;
        Mon, 21 Feb 2022 08:29:05 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id k13sm14639871pfc.176.2022.02.21.08.29.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 08:29:04 -0800 (PST)
Message-ID: <15a14ee8-8dd2-95db-1375-78796caac219@kernel.dk>
Date:   Mon, 21 Feb 2022 09:29:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v2 liburing] Test consistent file position updates
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     kernel-team@fb.com
References: <20220221141835.636567-1-dylany@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220221141835.636567-1-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/21/22 7:18 AM, Dylan Yudaken wrote:
> read(2)/write(2) and friends support sequential reads without giving an
> explicit offset. The result of these should leave the file with an
> incremented offset.
> 
> Add tests for both read and write to check that io_uring behaves
> consistently in these scenarios. Expect that if you queue many
> reads/writes, and set the IOSQE_IO_LINK flag, that they will behave
> similarly to calling read(2)/write(2) in sequence.
> 
> Set IOSQE_ASYNC as well in a set of tests. This exacerbates the problem by
> forcing work to happen in different threads to submission.
> 
> Also add tests for not setting IOSQE_IO_LINK, but allow the file offset to
> progress past the end of the file.

A few style and test output comments below.

> diff --git a/test/fpos.c b/test/fpos.c
> new file mode 100644
> index 0000000..2c6c139
> --- /dev/null
> +++ b/test/fpos.c
> @@ -0,0 +1,270 @@
> +/* SPDX-License-Identifier: MIT */
> +/*
> + * Description: test io_uring fpos handling
> + *
> + */
> +#include <errno.h>
> +#include <stdio.h>
> +#include <unistd.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <fcntl.h>
> +#include <assert.h>
> +
> +#include "helpers.h"
> +#include "liburing.h"
> +
> +#define FILE_SIZE 10000
> +#define QUEUE_SIZE 4096

Seems huge? 

> +static int
> +test_read(struct io_uring *ring, bool async, bool link, int blocksize)

liburing and the kernel tend to use:

static int test_read(struct io_uring *ring, bool async, bool link,
		     int blocksize)
{
}

if we go over 80 chars, with the reasoning being that a grep will show
you the return type at least.

> +{
> +	int ret, fd, i;
> +	bool done = false;
> +	struct io_uring_sqe *sqe;
> +	struct io_uring_cqe *cqe;
> +	loff_t current, expected = 0;
> +	int count_ok;
> +	int count_0 = 0, count_1 = 0;
> +	unsigned char buff[QUEUE_SIZE * blocksize];
> +	unsigned char reordered[QUEUE_SIZE * blocksize];
> +
> +	create_file(".test_read", FILE_SIZE);
> +	fd = open(".test_read", O_RDONLY);
> +	unlink(".test_read");
> +	assert(fd >= 0);
> +
> +	while (!done) {
> +		for (i = 0; i < QUEUE_SIZE; ++i) {
> +			sqe = io_uring_get_sqe(ring);
> +			if (!sqe) {
> +				fprintf(stderr, "no sqe\n");
> +				return -1;
> +			}
> +			io_uring_prep_read(sqe, fd,
> +					buff + i * blocksize,
> +					blocksize, -1);
> +			sqe->user_data = i;
> +			if (async)
> +				sqe->flags |= IOSQE_ASYNC;
> +			if (link && i != QUEUE_SIZE - 1)
> +				sqe->flags |= IOSQE_IO_LINK;
> +		}
> +		ret = io_uring_submit_and_wait(ring, QUEUE_SIZE);
> +		if (ret != QUEUE_SIZE) {
> +			fprintf(stderr, "submit failed: %d\n", ret);
> +			return 1;
> +		}
> +		count_ok  = 0;
> +		for (i = 0; i < QUEUE_SIZE; ++i) {
> +			int res;
> +
> +			ret = io_uring_peek_cqe(ring, &cqe);
> +			if (ret) {
> +				fprintf(stderr, "peek failed: %d\n", ret);
> +				return ret;
> +			}
> +			assert(cqe->user_data < QUEUE_SIZE);
> +			memcpy(reordered + count_ok
> +				, buff + cqe->user_data * blocksize
> +				, blocksize);

			memcpy(reordered + count_ok,
				buff + cqe->user_data * blocksize, blocksize);

> +static int
> +test_write(struct io_uring *ring, bool async, bool link, int blocksize)
> +{
> +	int ret, fd, i;
> +	struct io_uring_sqe *sqe;
> +	struct io_uring_cqe *cqe;
> +	bool fail = false;
> +	loff_t current;
> +	char data[blocksize+1];
> +	char readbuff[QUEUE_SIZE*blocksize+1];
> +
> +	fd = open(".test_write", O_RDWR | O_CREAT, 0644);
> +	unlink(".test_write");
> +	assert(fd >= 0);
> +
> +	for(i = 0; i < blocksize; i++) {
> +		data[i] = 'A' + i;
> +	}
> +	data[blocksize] = '\0';
> +
> +	for (i = 0; i < QUEUE_SIZE; ++i) {
> +		sqe = io_uring_get_sqe(ring);
> +		if (!sqe) {
> +			fprintf(stderr, "no sqe\n");
> +			return -1;
> +		}
> +		io_uring_prep_write(sqe, fd, data + (i % blocksize), 1, -1);
> +		sqe->user_data = 1;
> +		if (async)
> +			sqe->flags |= IOSQE_ASYNC;
> +		if (link && i != QUEUE_SIZE - 1)
> +			sqe->flags |= IOSQE_IO_LINK;
> +	}
> +	ret = io_uring_submit_and_wait(ring, QUEUE_SIZE);
> +	if (ret != QUEUE_SIZE) {
> +		fprintf(stderr, "submit failed: %d\n", ret);
> +		return 1;
> +	}
> +	for (i = 0; i < QUEUE_SIZE; ++i) {
> +		int res;
> +
> +		ret = io_uring_peek_cqe(ring, &cqe);
> +		res = cqe->res;
> +		if (ret) {
> +			fprintf(stderr, "peek failed: %d\n", ret);
> +			return ret;
> +		}
> +		io_uring_cqe_seen(ring, cqe);
> +		if (!fail && res != 1) {
> +			fprintf(stderr, "bad result %d\n", res);
> +			fail = true;
> +		}
> +	}
> +	current = lseek(fd, 0, SEEK_CUR);
> +	if (current != QUEUE_SIZE) {
> +		fprintf(stderr,
> +			"f_pos incorrect, expected %ld have %d\n",
> +			current,
> +			QUEUE_SIZE);
> +		fail = true;

		fprintf(stderr, "f_pos incorrect, expected %ld have %d\n",
				current, QUEUE_SIZE);

> +int main(int argc, char *argv[])
> +{
> +	struct io_uring ring;
> +	int ret;
> +	int failed = 0;
> +	int blocksizes[] = {1, 8, 15, 0};
> +
> +	if (argc > 1)
> +		return 0;
> +
> +	ret = io_uring_queue_init(QUEUE_SIZE, &ring, 0);
> +	if (ret) {
> +		fprintf(stderr, "ring setup failed\n");
> +		return 1;
> +	}
> +
> +	for (int *blocksize = blocksizes; *blocksize; blocksize++) {
> +	for (int async = 0; async < 2; async++) {
> +	for (int link = 0; link < 2; link++) {
> +	for (int write = 0; write < 2; write++) {
> +		fprintf(stderr, "*********\n");
> +		ret = write
> +			? test_write(&ring, !!async, !!link, *blocksize)
> +			: test_read(&ring, !!async, !!link, *blocksize);
> +		fprintf(stderr, "test %s async=%d link=%d blocksize=%d:\t%s\n",
> +			write ? "write":"read",
> +			async, link,
> +			*blocksize,
> +			ret ? "failed" : "passed");

The normal procedure for tests and printing output is:

- Be silent on success, otherwise it's just noise to look over when
  doing runs. There are some ancient tests that don't honor this, but
  generally the rest of them do.

- If one test fails, stop further tests.

> +	}
> +	}
> +	}

Indentation is wonky here.

-- 
Jens Axboe

