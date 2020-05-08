Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B128D1CB2AC
	for <lists+io-uring@lfdr.de>; Fri,  8 May 2020 17:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgEHPS6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 May 2020 11:18:58 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:42377 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726627AbgEHPS6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 May 2020 11:18:58 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07425;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0TxxWMi9_1588951132;
Received: from 30.39.209.69(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TxxWMi9_1588951132)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 08 May 2020 23:18:52 +0800
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        joseph qi <joseph.qi@linux.alibaba.com>,
        Jiufei Xue <jiufei.xue@linux.alibaba.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: Is io_uring framework becoming bloated gradually? and introduces
 performace regression
Message-ID: <6132351e-75e6-9d4d-781b-d6a183d87846@linux.alibaba.com>
Date:   Fri, 8 May 2020 23:18:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------4041E5BA18E45843CC2908E9"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a multi-part message in MIME format.
--------------4041E5BA18E45843CC2908E9
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit

hi,

This issue was found when I tested IORING_FEAT_FAST_POLL feature, with the newest
upstream codes, indeed I find that io_uring's performace improvement is not obvious
compared to epoll in my test environment, most of the time they are similar.
Test cases basically comes from:
   https://github.com/frevib/io_uring-echo-server/blob/io-uring-feat-fast-poll/benchmarks/benchmarks.md.
In above url, the author's test results shows that io_uring will get a big performace
improvement compared to epoll. I'm still looking into why I don't get the big improvement,
currently don't know why, but I find some obvious regression issue.

I wrote a simple tool based io_uring nop operation to evaluate io_uring framework in
v5.1 and 5.7.0-rc4+(jens's io_uring-5.7 branch), I see a obvious performace regression:
v5.1 kernel:
     $sudo taskset -c 60 ./io_uring_nop_stress -r 300 # run 300 seconds
     total ios: 1832524960
     IOPS:      6108416
5.7.0-rc4+
     $sudo taskset -c 60 ./io_uring_nop_stress -r 300
     total ios: 1597672304
     IOPS:      5325574
it's about 12% performance regression.

Using perf can see many performance bottlenecks, for example, io_submit_sqes is one.
For now, I did't make many analysis yet, just have a look at io_submit_sqes(), there
are many assignment operations in io_init_req(), but I'm not sure whether they are all
needed when req is not needed to be punt to io-wq, for example,
     INIT_IO_WORK(&req->work, io_wq_submit_work); # a whole struct assignment
from perf annotate tool, it's an expensive operation, I think reqs that use fast poll
feature use task-work function, so the INIT_IO_WORK maybe not necessary.

Above is just one issue, what I worry is that whether io_uring is becoming more bloated
gradually, and will not that better to aio. In https://kernel.dk/io_uring.pdf, it says
that io_uring will eliminate 104 bytes copy compared to aio, but see currenct
io_init_req(), io_uring maybe copy more, introducing more overhead? Or does we need to
carefully re-design struct io_kiocb, to reduce overhead as soon as possible.


Regards,
Xiaoguang Wang

--------------4041E5BA18E45843CC2908E9
Content-Type: text/plain; charset=UTF-8;
 name="io_uring_nop_stress.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="io_uring_nop_stress.c"

/*
 * Description: run various io_uring nop tests
 * xiaoguang.wang@linux.alibaba.com
 *
 */
#include <errno.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>

#include "liburing.h"

static char *myprog;
static int batch_count = 16;
static int force_async = 0;
static int runtime = 30;
static unsigned long long ios;
static volatile int stop = 0;

static int test_nop(struct io_uring *ring)
{
	struct io_uring_cqe *cqe;
	struct io_uring_sqe *sqe;
	int i, ret;

	for (i = 0; i < batch_count; i++) {
		sqe = io_uring_get_sqe(ring);
		if (!sqe) {
			fprintf(stderr, "get sqe failed\n");
			goto err;
		}
		io_uring_prep_nop(sqe);
		if (force_async)
			sqe->flags |= IOSQE_ASYNC;
	}

	ret = io_uring_submit(ring);
	if (ret <= 0) {
		fprintf(stderr, "sqe submit failed: %d\n", ret);
		goto err;
	}

	for (i = 0; i < batch_count; i++) {
		ret = io_uring_wait_cqe(ring, &cqe);
		if (ret < 0) {
			fprintf(stderr, "wait completion %d\n", ret);
			goto err;
		}
		io_uring_cqe_seen(ring, cqe);
	}
	ios += batch_count;
	return 0;
err:
	return 1;
}

static void usage(void)
{
	printf("Usage: %s -H   or\n", myprog);
	printf("       %s [-b batch][-a][-r runtime]\n", myprog);
	printf("   -b  batch    submission batch count, default 16\n");
	printf("   -r  runtime  run time, default 30\n");
	printf("   -a           force asynchronous submission\n");
	printf("   -H           prints usage and exits\n");
}

static void alarm_handler(int signum)
{
	(void)signum;
	stop = 1;
}

int main(int argc, char *argv[])
{
	struct io_uring ring;
	struct sigaction sa;
	int ret, c;
	const char *opts = "b:ar:";

	myprog = argv[0];
	while ((c = getopt(argc, argv, opts)) != -1) {
		switch (c) {
		case 'b':
			batch_count = atoi(optarg);
			break;
                case 'a':
			force_async = 1;
			break;
                case 'r':
			runtime = atoi(optarg);
			break;
		case 'H':
			usage();
			exit(1);
		}
	}

	if (!batch_count) {
		fprintf(stderr, "batch count should be greater than 0\n");
		exit(1);
	}

	if (!runtime) {
		printf("run time is zero, are you sure?\n");
		return 0;
	}

	memset(&sa, 0, sizeof(sa));
	sa.sa_handler = alarm_handler;
	sigemptyset(&sa.sa_mask);
	ret = sigaction(SIGALRM, &sa, NULL);
	if (ret < 0) {
		fprintf(stderr, "sigaction failed: %s", strerror(errno));
		exit(1);
	}
	alarm(runtime);

	ret = io_uring_queue_init(batch_count, &ring, 0);
	if (ret) {
		fprintf(stderr, "ring setup failed: %d\n", ret);
		return 1;
	}

	while (!stop) {
		ret = test_nop(&ring);
		if (ret) {
			fprintf(stderr, "test_nop failed\n");
			return ret;
		}
	}
	printf("total ios: %llu\n", ios);
	printf("IOPS:      %llu\n", ios / runtime);

	return 0;
}

--------------4041E5BA18E45843CC2908E9--
