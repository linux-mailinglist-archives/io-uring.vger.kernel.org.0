Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A08C36BF72
	for <lists+io-uring@lfdr.de>; Tue, 27 Apr 2021 08:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhD0Gth (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Apr 2021 02:49:37 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:46908 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229923AbhD0Gth (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Apr 2021 02:49:37 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UWyY9Ib_1619506132;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UWyY9Ib_1619506132)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 27 Apr 2021 14:48:52 +0800
Subject: Re: [PATCH v2] add tests for drain io with multishot reqs
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1618298439-136286-1-git-send-email-haoxu@linux.alibaba.com>
 <1618298628-137451-1-git-send-email-haoxu@linux.alibaba.com>
 <53c24fe3-5d2a-2173-2bae-955f8459b7cc@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <2a976a28-df04-eb87-e484-a66473a08918@linux.alibaba.com>
Date:   Tue, 27 Apr 2021 14:48:52 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <53c24fe3-5d2a-2173-2bae-955f8459b7cc@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/4/14 下午6:48, Pavel Begunkov 写道:
> On 13/04/2021 08:23, Hao Xu wrote:
>> Add a simple test for drain io with multishot reqs. A generic one as
>> well, which randomly generates sqes for testing. The later will cover
>> most cases.
> 
> Great job crafting tests and patches. It's a fix, so ok to get it in
> later RCs, so I'll take a look but in a week (if Jens won't take it
> earlier).
> 
ping..
>>
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
>>   src/include/liburing/io_uring.h |  15 ++
>>   test/Makefile                   |   2 +
>>   test/multicqes_drain.c          | 380 ++++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 397 insertions(+)
>>   create mode 100644 test/multicqes_drain.c
>>
>> diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
>> index d3d166e57be8..eed991d08655 100644
>> --- a/src/include/liburing/io_uring.h
>> +++ b/src/include/liburing/io_uring.h
>> @@ -165,6 +165,21 @@ enum {
>>   #define SPLICE_F_FD_IN_FIXED	(1U << 31) /* the last bit of __u32 */
>>   
>>   /*
>> + * POLL_ADD flags. Note that since sqe->poll_events is the flag space, the
>> + * command flags for POLL_ADD are stored in sqe->len.
>> + *
>> + * IORING_POLL_ADD_MULTI        Multishot poll. Sets IORING_CQE_F_MORE if
>> + *                              the poll handler will continue to report
>> + *                              CQEs on behalf of the same SQE.
>> + *
>> + * IORING_POLL_UPDATE           Update existing poll request, matching
>> + *                              sqe->addr as the old user_data field.
>> + */
>> +#define IORING_POLL_ADD_MULTI   (1U << 0)
>> +#define IORING_POLL_UPDATE_EVENTS       (1U << 1)
>> +#define IORING_POLL_UPDATE_USER_DATA    (1U << 2)
>> +
>> +/*
>>    * IO completion data structure (Completion Queue Entry)
>>    */
>>   struct io_uring_cqe {
>> diff --git a/test/Makefile b/test/Makefile
>> index 210571c22b40..5ffad0309914 100644
>> --- a/test/Makefile
>> +++ b/test/Makefile
>> @@ -66,6 +66,7 @@ test_targets += \
>>   	link-timeout \
>>   	link_drain \
>>   	madvise \
>> +	multicqes_drain \
>>   	nop \
>>   	nop-all-sizes \
>>   	open-close \
>> @@ -202,6 +203,7 @@ test_srcs := \
>>   	link.c \
>>   	link_drain.c \
>>   	madvise.c \
>> +	multicqes_drain.c \
>>   	nop-all-sizes.c \
>>   	nop.c \
>>   	open-close.c \
>> diff --git a/test/multicqes_drain.c b/test/multicqes_drain.c
>> new file mode 100644
>> index 000000000000..4f657e5c444a
>> --- /dev/null
>> +++ b/test/multicqes_drain.c
>> @@ -0,0 +1,380 @@
>> +/* SPDX-License-Identifier: MIT */
>> +/*
>> + * Description: generic tests for  io_uring drain io
>> + *
>> + * The main idea is to randomly generate different type of sqe to
>> + * challenge the drain logic. There are some restrictions for the
>> + * generated sqes, details in io_uring maillist:
>> + * https://lore.kernel.org/io-uring/39a49b4c-27c2-1035-b250-51daeccaab9b@linux.alibaba.com/
>> + *
>> + */
>> +#include <errno.h>
>> +#include <stdio.h>
>> +#include <unistd.h>
>> +#include <stdlib.h>
>> +#include <string.h>
>> +#include <time.h>
>> +#include <sys/poll.h>
>> +
>> +#include "liburing.h"
>> +
>> +enum {
>> +	multi,
>> +	single,
>> +	nop,
>> +	cancel,
>> +	op_last,
>> +};
>> +
>> +struct sqe_info {
>> +	__u8 op;
>> +	unsigned flags;
>> +};
>> +
>> +#define max_entry 50
>> +
>> +/*
>> + * sqe_flags: combination of sqe flags
>> + * multi_sqes: record the user_data/index of all the multishot sqes
>> + * cnt: how many entries there are in multi_sqes
>> + * we can leverage multi_sqes array for cancellation: we randomly pick
>> + * up an entry in multi_sqes when form a cancellation sqe.
>> + * multi_cap: limitation of number of multishot sqes
>> + */
>> +const unsigned sqe_flags[4] = {0, IOSQE_IO_LINK, IOSQE_IO_DRAIN,
>> +	IOSQE_IO_LINK | IOSQE_IO_DRAIN};
>> +int multi_sqes[max_entry], cnt = 0;
>> +int multi_cap = max_entry / 5;
>> +
>> +int write_pipe(int pipe, char *str)
>> +{
>> +	int ret;
>> +	do {
>> +		errno = 0;
>> +		ret = write(pipe, str, 3);
>> +	} while (ret == -1 && errno == EINTR);
>> +	return ret;
>> +}
>> +
>> +void read_pipe(int pipe)
>> +{
>> +	char str[4] = {0};
>> +
>> +	read(pipe, &str, 3);
>> +}
>> +
>> +int trigger_event(int p[])
>> +{
>> +	int ret;
>> +	if ((ret = write_pipe(p[1], "foo")) != 3) {
>> +		fprintf(stderr, "bad write return %d\n", ret);
>> +		return 1;
>> +	}
>> +	read_pipe(p[0]);
>> +	return 0;
>> +}
>> +
>> +void io_uring_sqe_prep(int op, struct io_uring_sqe *sqe, unsigned sqe_flags, int arg)
>> +{
>> +	switch (op) {
>> +		case multi:
>> +			io_uring_prep_poll_add(sqe, arg, POLLIN);
>> +			sqe->len |= IORING_POLL_ADD_MULTI;
>> +			break;
>> +		case single:
>> +			io_uring_prep_poll_add(sqe, arg, POLLIN);
>> +			break;
>> +		case nop:
>> +			io_uring_prep_nop(sqe);
>> +			break;
>> +		case cancel:
>> +			io_uring_prep_poll_remove(sqe, (void *)(long)arg);
>> +			break;
>> +	}
>> +	sqe->flags = sqe_flags;
>> +}
>> +
>> +__u8 generate_flags(int sqe_op)
>> +{
>> +	__u8 flags = 0;
>> +	/*
>> +	 * drain sqe must be put after multishot sqes cancelled
>> +	 */
>> +	do {
>> +		flags = sqe_flags[rand() % 4];
>> +	} while ((flags & IOSQE_IO_DRAIN) && cnt);
>> +
>> +	/*
>> +	 * cancel req cannot have drain or link flag
>> +	 */
>> +	if (sqe_op == cancel) {
>> +		flags &= ~(IOSQE_IO_DRAIN | IOSQE_IO_LINK);
>> +	}
>> +	/*
>> +	 * avoid below case:
>> +	 * sqe0(multishot, link)->sqe1(nop, link)->sqe2(nop)->sqe3(cancel_sqe0)
>> +	 * sqe3 may excute before sqe0 so that sqe0 isn't cancelled
>> +	 */
>> +	if (sqe_op == multi)
>> +		flags &= ~IOSQE_IO_LINK;
>> +
>> +	return flags;
>> +
>> +}
>> +
>> +/*
>> + * function to generate opcode of a sqe
>> + * several restrictions here:
>> + * - cancel all the previous multishot sqes as soon as possible when
>> + *   we reach high watermark.
>> + * - ensure there is some multishot sqe when generating a cancel sqe
>> + * - ensure a cancel/multshot sqe is not in a linkchain
>> + * - ensure number of multishot sqes doesn't exceed multi_cap
>> + * - don't generate multishot sqes after high watermark
>> + */
>> +int generate_opcode(int i, int pre_flags)
>> +{
>> +	int sqe_op;
>> +	int high_watermark = max_entry - max_entry / 5;
>> +	bool retry0 = false, retry1 = false, retry2 = false;
>> +
>> +	if ((i >= high_watermark) && cnt) {
>> +		sqe_op = cancel;
>> +	} else {
>> +		do {
>> +			sqe_op = rand() % op_last;
>> +			retry0 = (sqe_op == cancel) && (!cnt || (pre_flags & IOSQE_IO_LINK));
>> +			retry1 = (sqe_op == multi) && ((multi_cap - 1 < 0) || i >= high_watermark);
>> +			retry2 = (sqe_op == multi) && (pre_flags & IOSQE_IO_LINK);
>> +		} while (retry0 || retry1 || retry2);
>> +	}
>> +
>> +	if (sqe_op == multi)
>> +		multi_cap--;
>> +	return sqe_op;
>> +}
>> +
>> +inline void add_multishot_sqe(int index)
>> +{
>> +	multi_sqes[cnt++] = index;
>> +}
>> +
>> +int remove_multishot_sqe()
>> +{
>> +	int ret;
>> +
>> +	int rem_index = rand() % cnt;
>> +	ret = multi_sqes[rem_index];
>> +	multi_sqes[rem_index] = multi_sqes[cnt - 1];
>> +	cnt--;
>> +
>> +	return ret;
>> +}
>> +
>> +static int test_generic_drain(struct io_uring *ring)
>> +{
>> +	struct io_uring_cqe *cqe;
>> +	struct io_uring_sqe *sqe[max_entry];
>> +	struct sqe_info si[max_entry];
>> +	int cqe_data[max_entry << 1], cqe_res[max_entry << 1];
>> +	int i, j, ret, arg = 0;
>> +	int pipes[max_entry][2];
>> +	int pre_flags = 0;
>> +
>> +	for (i = 0; i < max_entry; i++) {
>> +		if (pipe(pipes[i]) != 0) {
>> +			perror("pipe");
>> +			return 1;
>> +		}
>> +	}
>> +
>> +	srand((unsigned)time(NULL));
>> +	for (i = 0; i < max_entry; i++) {
>> +		sqe[i] = io_uring_get_sqe(ring);
>> +		if (!sqe[i]) {
>> +			printf("get sqe failed\n");
>> +			goto err;
>> +		}
>> +
>> +		int sqe_op = generate_opcode(i, pre_flags);
>> +		__u8 flags = generate_flags(sqe_op);
>> +
>> +		if (sqe_op == cancel)
>> +			arg = remove_multishot_sqe();
>> +		if (sqe_op == multi || sqe_op == single)
>> +			arg = pipes[i][0];
>> +		io_uring_sqe_prep(sqe_op, sqe[i], flags, arg);
>> +		sqe[i]->user_data = i;
>> +		si[i].op = sqe_op;
>> +		si[i].flags = flags;
>> +		pre_flags = flags;
>> +		if (sqe_op == multi)
>> +			add_multishot_sqe(i);
>> +	}
>> +
>> +	ret = io_uring_submit(ring);
>> +	if (ret < 0) {
>> +		printf("sqe submit failed\n");
>> +		goto err;
>> +	} else if (ret < max_entry) {
>> +		printf("Submitted only %d\n", ret);
>> +		goto err;
>> +	}
>> +
>> +	sleep(4);
>> +	// TODO: randomize event triggerring order
>> +	for (i = 0; i < max_entry; i++) {
>> +		if (si[i].op != multi && si[i].op != single)
>> +			continue;
>> +
>> +		if (trigger_event(pipes[i]))
>> +			goto err;
>> +	}
>> +	sleep(5);
>> +	i = 0;
>> +	while (!io_uring_peek_cqe(ring, &cqe)) {
>> +		cqe_data[i] = cqe->user_data;
>> +		cqe_res[i++] = cqe->res;
>> +		io_uring_cqe_seen(ring, cqe);
>> +	}
>> +
>> +	/*
>> +	 * compl_bits is a bit map to record completions.
>> +	 * eg. sqe[0], sqe[1], sqe[2] fully completed
>> +	 * then compl_bits is 000...00111b
>> +	 *
>> +	 */
>> +	unsigned long long compl_bits = 0;
>> +	for (j = 0; j < i; j++) {
>> +		int index = cqe_data[j];
>> +		if ((si[index].flags & IOSQE_IO_DRAIN) && index) {
>> +			if ((~compl_bits) & ((1ULL << index) - 1)) {
>> +				printf("drain failed\n");
>> +				goto err;
>> +			}
>> +		}
>> +		/*
>> +		 * for multishot sqes, record them only when it is cancelled
>> +		 */
>> +		if ((si[index].op != multi) || (cqe_res[j] == -ECANCELED))
>> +			compl_bits |= (1ULL << index);
>> +	}
>> +
>> +	return 0;
>> +err:
>> +	return 1;
>> +}
>> +
>> +static int test_simple_drain(struct io_uring *ring)
>> +{
>> +	struct io_uring_cqe *cqe;
>> +	struct io_uring_sqe *sqe[2];
>> +	int i, ret;
>> +	int pipe1[2], pipe2[2];
>> +
>> +	if (pipe(pipe1) != 0 || pipe(pipe2) != 0) {
>> +		perror("pipe");
>> +		return 1;
>> +	}
>> +
>> +	for (i = 0; i < 2; i++) {
>> +		sqe[i] = io_uring_get_sqe(ring);
>> +		if (!sqe[i]) {
>> +			printf("get sqe failed\n");
>> +			goto err;
>> +		}
>> +	}
>> +
>> +	io_uring_prep_poll_add(sqe[0], pipe1[0], POLLIN);
>> +	sqe[0]->len |= IORING_POLL_ADD_MULTI;
>> +	sqe[0]->user_data = 0;
>> +	io_uring_prep_poll_add(sqe[1], pipe2[0], POLLIN);
>> +	sqe[1]->user_data = 1;
>> +
>> +	ret = io_uring_submit(ring);
>> +	if (ret < 0) {
>> +		printf("sqe submit failed\n");
>> +		goto err;
>> +	} else if (ret < 2) {
>> +		printf("Submitted only %d\n", ret);
>> +		goto err;
>> +	}
>> +
>> +	for (i = 0; i < 2; i++) {
>> +		if (trigger_event(pipe1))
>> +			goto err;
>> +	}
>> +	if (trigger_event(pipe2))
>> +			goto err;
>> +
>> +	for (i = 0; i < 2; i++) {
>> +		sqe[i] = io_uring_get_sqe(ring);
>> +		if (!sqe[i]) {
>> +			printf("get sqe failed\n");
>> +			goto err;
>> +		}
>> +	}
>> +
>> +	io_uring_prep_poll_remove(sqe[0], 0);
>> +	sqe[0]->user_data = 2;
>> +	io_uring_prep_nop(sqe[1]);
>> +	sqe[1]->flags |= IOSQE_IO_DRAIN;
>> +	sqe[1]->user_data = 3;
>> +
>> +	ret = io_uring_submit(ring);
>> +	if (ret < 0) {
>> +		printf("sqe submit failed\n");
>> +		goto err;
>> +	} else if (ret < 2) {
>> +		printf("Submitted only %d\n", ret);
>> +		goto err;
>> +	}
>> +
>> +
>> +	for (i = 0; i < 6; i++) {
>> +		ret = io_uring_wait_cqe(ring, &cqe);
>> +		if (ret < 0) {
>> +			printf("wait completion %d\n", ret);
>> +			goto err;
>> +		}
>> +		io_uring_cqe_seen(ring, cqe);
>> +		if ((i == 5) && (cqe->user_data != 3))
>> +			goto err;
>> +	}
>> +
>> +	return 0;
>> +err:
>> +	return 1;
>> +}
>> +
>> +int main(int argc, char *argv[])
>> +{
>> +	struct io_uring ring;
>> +	int i, ret;
>> +
>> +	if (argc > 1)
>> +		return 0;
>> +
>> +	ret = io_uring_queue_init(1024, &ring, 0);
>> +	if (ret) {
>> +		printf("ring setup failed\n");
>> +		return 1;
>> +	}
>> +
>> +	for (i = 0; i < 5; i++) {
>> +		ret = test_simple_drain(&ring);
>> +		if (ret) {
>> +			fprintf(stderr, "test_simple_drain failed\n");
>> +			break;
>> +		}
>> +	}
>> +
>> +	for (i = 0; i < 5; i++) {
>> +		ret = test_generic_drain(&ring);
>> +		if (ret) {
>> +			fprintf(stderr, "test_generic_drain failed\n");
>> +			break;
>> +		}
>> +	}
>> +	return ret;
>> +}
>>
> 

