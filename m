Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD59135F1C1
	for <lists+io-uring@lfdr.de>; Wed, 14 Apr 2021 12:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234546AbhDNKx0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Apr 2021 06:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234300AbhDNKx0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Apr 2021 06:53:26 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE6CC061756
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 03:53:03 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id q123-20020a1c43810000b029012c7d852459so2377568wma.0
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 03:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tYHXkVzeOtxIGD/qm7ciiOabdmN2P2nuUfWoT7Nk93E=;
        b=K1a5VRc5A1iUZcRLpQYheQhwnM12F9CBHas0jPJyA0pS5Mth0tE/5/x2muZKSuVC1C
         OfbC/1F2aNESOSUSYLHS5VQOjnIJtuNwFCER3yuYIeTY6MC5JMaHPvfD4rncyR3uCXZt
         k66T+czr47PFGOPBXeLtbVu7yPlNrJNuWYhmUPF/Ban5yy0jQft+K/PM1shYyxXoUv6C
         ojSD/E7zRq8D4gsoJ8hze1ZjAEJFNtP8UuACpCZdT/6kROENdymdmo+WaaKVuYn9tBS1
         ttCXHlOxtvTg99JutworTgaV1JKsLa+l0jKN+qzRKVG3TUC1sK5Z7yNksKuG7jJYnA5V
         +Ksg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=tYHXkVzeOtxIGD/qm7ciiOabdmN2P2nuUfWoT7Nk93E=;
        b=FYiBkM06EjRGwrv2DZl55SaLwOTZx2JXg3IlehwEWnjjkyhFdX8VxiUx+kZlW9Ic9A
         mb/t/BURJN9Lnfi6O8MDKZ+4DpOdCrk0iKMcoTBxUBIjo0vqrqeAEh4ApMmnZrS/47ol
         VJYS/dOI8mzKvvJTKW745nvJ4dgd4G+aOHlc383UCQCrsST6ANxefB3XiYGmn7uLTblp
         6Sc7mzV7ueARYEumFOcY8pHYIxcrX/A8YApwZ0OPISqp7bVav1cX6PpwVPoqpe0j5Yuh
         c6A3RXB9JNYsqvX4fa3Edht+8FYiUdKqkMq+UMsXV9VeRgR/ZZzA7Yz3MNW91lXEk0Jz
         QDeA==
X-Gm-Message-State: AOAM531gx1QHnwLG2TJ+/8261hb6Z6TiGs5O8ZYvJfd4QPALEWGD2MHH
        rGYwWFs5p+kZcYfJQzxEm4WNrWXNiOlzcQ==
X-Google-Smtp-Source: ABdhPJyxHWbGuWF1lMOMB/56yH/55ePe9YOtrsY/lRgACkRLT9h3xIzUpeqrjVzY9u7boIhfQxi7ig==
X-Received: by 2002:a05:600c:4142:: with SMTP id h2mr2429537wmm.87.1618397582066;
        Wed, 14 Apr 2021 03:53:02 -0700 (PDT)
Received: from [192.168.8.185] ([148.252.128.163])
        by smtp.gmail.com with ESMTPSA id l24sm5061489wmc.4.2021.04.14.03.53.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Apr 2021 03:53:01 -0700 (PDT)
Subject: Re: [PATCH v2] add tests for drain io with multishot reqs
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1618298439-136286-1-git-send-email-haoxu@linux.alibaba.com>
 <1618298628-137451-1-git-send-email-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <53c24fe3-5d2a-2173-2bae-955f8459b7cc@gmail.com>
Date:   Wed, 14 Apr 2021 11:48:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1618298628-137451-1-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 13/04/2021 08:23, Hao Xu wrote:
> Add a simple test for drain io with multishot reqs. A generic one as
> well, which randomly generates sqes for testing. The later will cover
> most cases.

Great job crafting tests and patches. It's a fix, so ok to get it in
later RCs, so I'll take a look but in a week (if Jens won't take it
earlier).

> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>  src/include/liburing/io_uring.h |  15 ++
>  test/Makefile                   |   2 +
>  test/multicqes_drain.c          | 380 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 397 insertions(+)
>  create mode 100644 test/multicqes_drain.c
> 
> diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
> index d3d166e57be8..eed991d08655 100644
> --- a/src/include/liburing/io_uring.h
> +++ b/src/include/liburing/io_uring.h
> @@ -165,6 +165,21 @@ enum {
>  #define SPLICE_F_FD_IN_FIXED	(1U << 31) /* the last bit of __u32 */
>  
>  /*
> + * POLL_ADD flags. Note that since sqe->poll_events is the flag space, the
> + * command flags for POLL_ADD are stored in sqe->len.
> + *
> + * IORING_POLL_ADD_MULTI        Multishot poll. Sets IORING_CQE_F_MORE if
> + *                              the poll handler will continue to report
> + *                              CQEs on behalf of the same SQE.
> + *
> + * IORING_POLL_UPDATE           Update existing poll request, matching
> + *                              sqe->addr as the old user_data field.
> + */
> +#define IORING_POLL_ADD_MULTI   (1U << 0)
> +#define IORING_POLL_UPDATE_EVENTS       (1U << 1)
> +#define IORING_POLL_UPDATE_USER_DATA    (1U << 2)
> +
> +/*
>   * IO completion data structure (Completion Queue Entry)
>   */
>  struct io_uring_cqe {
> diff --git a/test/Makefile b/test/Makefile
> index 210571c22b40..5ffad0309914 100644
> --- a/test/Makefile
> +++ b/test/Makefile
> @@ -66,6 +66,7 @@ test_targets += \
>  	link-timeout \
>  	link_drain \
>  	madvise \
> +	multicqes_drain \
>  	nop \
>  	nop-all-sizes \
>  	open-close \
> @@ -202,6 +203,7 @@ test_srcs := \
>  	link.c \
>  	link_drain.c \
>  	madvise.c \
> +	multicqes_drain.c \
>  	nop-all-sizes.c \
>  	nop.c \
>  	open-close.c \
> diff --git a/test/multicqes_drain.c b/test/multicqes_drain.c
> new file mode 100644
> index 000000000000..4f657e5c444a
> --- /dev/null
> +++ b/test/multicqes_drain.c
> @@ -0,0 +1,380 @@
> +/* SPDX-License-Identifier: MIT */
> +/*
> + * Description: generic tests for  io_uring drain io
> + *
> + * The main idea is to randomly generate different type of sqe to
> + * challenge the drain logic. There are some restrictions for the
> + * generated sqes, details in io_uring maillist:
> + * https://lore.kernel.org/io-uring/39a49b4c-27c2-1035-b250-51daeccaab9b@linux.alibaba.com/
> + *
> + */
> +#include <errno.h>
> +#include <stdio.h>
> +#include <unistd.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <time.h>
> +#include <sys/poll.h>
> +
> +#include "liburing.h"
> +
> +enum {
> +	multi,
> +	single,
> +	nop,
> +	cancel,
> +	op_last,
> +};
> +
> +struct sqe_info {
> +	__u8 op;
> +	unsigned flags;
> +};
> +
> +#define max_entry 50
> +
> +/*
> + * sqe_flags: combination of sqe flags
> + * multi_sqes: record the user_data/index of all the multishot sqes
> + * cnt: how many entries there are in multi_sqes
> + * we can leverage multi_sqes array for cancellation: we randomly pick
> + * up an entry in multi_sqes when form a cancellation sqe.
> + * multi_cap: limitation of number of multishot sqes
> + */
> +const unsigned sqe_flags[4] = {0, IOSQE_IO_LINK, IOSQE_IO_DRAIN,
> +	IOSQE_IO_LINK | IOSQE_IO_DRAIN};
> +int multi_sqes[max_entry], cnt = 0;
> +int multi_cap = max_entry / 5;
> +
> +int write_pipe(int pipe, char *str)
> +{
> +	int ret;
> +	do {
> +		errno = 0;
> +		ret = write(pipe, str, 3);
> +	} while (ret == -1 && errno == EINTR);
> +	return ret;
> +}
> +
> +void read_pipe(int pipe)
> +{
> +	char str[4] = {0};
> +
> +	read(pipe, &str, 3);
> +}
> +
> +int trigger_event(int p[])
> +{
> +	int ret;
> +	if ((ret = write_pipe(p[1], "foo")) != 3) {
> +		fprintf(stderr, "bad write return %d\n", ret);
> +		return 1;
> +	}
> +	read_pipe(p[0]);
> +	return 0;
> +}
> +
> +void io_uring_sqe_prep(int op, struct io_uring_sqe *sqe, unsigned sqe_flags, int arg)
> +{
> +	switch (op) {
> +		case multi:
> +			io_uring_prep_poll_add(sqe, arg, POLLIN);
> +			sqe->len |= IORING_POLL_ADD_MULTI;
> +			break;
> +		case single:
> +			io_uring_prep_poll_add(sqe, arg, POLLIN);
> +			break;
> +		case nop:
> +			io_uring_prep_nop(sqe);
> +			break;
> +		case cancel:
> +			io_uring_prep_poll_remove(sqe, (void *)(long)arg);
> +			break;
> +	}
> +	sqe->flags = sqe_flags;
> +}
> +
> +__u8 generate_flags(int sqe_op)
> +{
> +	__u8 flags = 0;
> +	/*
> +	 * drain sqe must be put after multishot sqes cancelled
> +	 */
> +	do {
> +		flags = sqe_flags[rand() % 4];
> +	} while ((flags & IOSQE_IO_DRAIN) && cnt);
> +
> +	/*
> +	 * cancel req cannot have drain or link flag
> +	 */
> +	if (sqe_op == cancel) {
> +		flags &= ~(IOSQE_IO_DRAIN | IOSQE_IO_LINK);
> +	}
> +	/*
> +	 * avoid below case:
> +	 * sqe0(multishot, link)->sqe1(nop, link)->sqe2(nop)->sqe3(cancel_sqe0)
> +	 * sqe3 may excute before sqe0 so that sqe0 isn't cancelled
> +	 */
> +	if (sqe_op == multi)
> +		flags &= ~IOSQE_IO_LINK;
> +
> +	return flags;
> +
> +}
> +
> +/*
> + * function to generate opcode of a sqe
> + * several restrictions here:
> + * - cancel all the previous multishot sqes as soon as possible when
> + *   we reach high watermark.
> + * - ensure there is some multishot sqe when generating a cancel sqe
> + * - ensure a cancel/multshot sqe is not in a linkchain
> + * - ensure number of multishot sqes doesn't exceed multi_cap
> + * - don't generate multishot sqes after high watermark
> + */
> +int generate_opcode(int i, int pre_flags)
> +{
> +	int sqe_op;
> +	int high_watermark = max_entry - max_entry / 5;
> +	bool retry0 = false, retry1 = false, retry2 = false;
> +
> +	if ((i >= high_watermark) && cnt) {
> +		sqe_op = cancel;
> +	} else {
> +		do {
> +			sqe_op = rand() % op_last;
> +			retry0 = (sqe_op == cancel) && (!cnt || (pre_flags & IOSQE_IO_LINK));
> +			retry1 = (sqe_op == multi) && ((multi_cap - 1 < 0) || i >= high_watermark);
> +			retry2 = (sqe_op == multi) && (pre_flags & IOSQE_IO_LINK);
> +		} while (retry0 || retry1 || retry2);
> +	}
> +
> +	if (sqe_op == multi)
> +		multi_cap--;
> +	return sqe_op;
> +}
> +
> +inline void add_multishot_sqe(int index)
> +{
> +	multi_sqes[cnt++] = index;
> +}
> +
> +int remove_multishot_sqe()
> +{
> +	int ret;
> +
> +	int rem_index = rand() % cnt;
> +	ret = multi_sqes[rem_index];
> +	multi_sqes[rem_index] = multi_sqes[cnt - 1];
> +	cnt--;
> +
> +	return ret;
> +}
> +
> +static int test_generic_drain(struct io_uring *ring)
> +{
> +	struct io_uring_cqe *cqe;
> +	struct io_uring_sqe *sqe[max_entry];
> +	struct sqe_info si[max_entry];
> +	int cqe_data[max_entry << 1], cqe_res[max_entry << 1];
> +	int i, j, ret, arg = 0;
> +	int pipes[max_entry][2];
> +	int pre_flags = 0;
> +
> +	for (i = 0; i < max_entry; i++) {
> +		if (pipe(pipes[i]) != 0) {
> +			perror("pipe");
> +			return 1;
> +		}
> +	}
> +
> +	srand((unsigned)time(NULL));
> +	for (i = 0; i < max_entry; i++) {
> +		sqe[i] = io_uring_get_sqe(ring);
> +		if (!sqe[i]) {
> +			printf("get sqe failed\n");
> +			goto err;
> +		}
> +
> +		int sqe_op = generate_opcode(i, pre_flags);
> +		__u8 flags = generate_flags(sqe_op);
> +
> +		if (sqe_op == cancel)
> +			arg = remove_multishot_sqe();
> +		if (sqe_op == multi || sqe_op == single)
> +			arg = pipes[i][0];
> +		io_uring_sqe_prep(sqe_op, sqe[i], flags, arg);
> +		sqe[i]->user_data = i;
> +		si[i].op = sqe_op;
> +		si[i].flags = flags;
> +		pre_flags = flags;
> +		if (sqe_op == multi)
> +			add_multishot_sqe(i);
> +	}
> +
> +	ret = io_uring_submit(ring);
> +	if (ret < 0) {
> +		printf("sqe submit failed\n");
> +		goto err;
> +	} else if (ret < max_entry) {
> +		printf("Submitted only %d\n", ret);
> +		goto err;
> +	}
> +
> +	sleep(4);
> +	// TODO: randomize event triggerring order
> +	for (i = 0; i < max_entry; i++) {
> +		if (si[i].op != multi && si[i].op != single)
> +			continue;
> +
> +		if (trigger_event(pipes[i]))
> +			goto err;
> +	}
> +	sleep(5);
> +	i = 0;
> +	while (!io_uring_peek_cqe(ring, &cqe)) {
> +		cqe_data[i] = cqe->user_data;
> +		cqe_res[i++] = cqe->res;
> +		io_uring_cqe_seen(ring, cqe);
> +	}
> +
> +	/*
> +	 * compl_bits is a bit map to record completions.
> +	 * eg. sqe[0], sqe[1], sqe[2] fully completed
> +	 * then compl_bits is 000...00111b
> +	 * 
> +	 */
> +	unsigned long long compl_bits = 0;
> +	for (j = 0; j < i; j++) {
> +		int index = cqe_data[j];
> +		if ((si[index].flags & IOSQE_IO_DRAIN) && index) {
> +			if ((~compl_bits) & ((1ULL << index) - 1)) {
> +				printf("drain failed\n");
> +				goto err;
> +			}
> +		}
> +		/*
> +		 * for multishot sqes, record them only when it is cancelled
> +		 */
> +		if ((si[index].op != multi) || (cqe_res[j] == -ECANCELED))
> +			compl_bits |= (1ULL << index);
> +	}
> +
> +	return 0;
> +err:
> +	return 1;
> +}
> +
> +static int test_simple_drain(struct io_uring *ring)
> +{
> +	struct io_uring_cqe *cqe;
> +	struct io_uring_sqe *sqe[2];
> +	int i, ret;
> +	int pipe1[2], pipe2[2];
> +
> +	if (pipe(pipe1) != 0 || pipe(pipe2) != 0) {
> +		perror("pipe");
> +		return 1;
> +	}
> +
> +	for (i = 0; i < 2; i++) {
> +		sqe[i] = io_uring_get_sqe(ring);
> +		if (!sqe[i]) {
> +			printf("get sqe failed\n");
> +			goto err;
> +		}
> +	}
> +
> +	io_uring_prep_poll_add(sqe[0], pipe1[0], POLLIN);
> +	sqe[0]->len |= IORING_POLL_ADD_MULTI;
> +	sqe[0]->user_data = 0;
> +	io_uring_prep_poll_add(sqe[1], pipe2[0], POLLIN);
> +	sqe[1]->user_data = 1;
> +
> +	ret = io_uring_submit(ring);
> +	if (ret < 0) {
> +		printf("sqe submit failed\n");
> +		goto err;
> +	} else if (ret < 2) {
> +		printf("Submitted only %d\n", ret);
> +		goto err;
> +	}
> +
> +	for (i = 0; i < 2; i++) {
> +		if (trigger_event(pipe1))
> +			goto err;
> +	}
> +	if (trigger_event(pipe2))
> +			goto err;
> +
> +	for (i = 0; i < 2; i++) {
> +		sqe[i] = io_uring_get_sqe(ring);
> +		if (!sqe[i]) {
> +			printf("get sqe failed\n");
> +			goto err;
> +		}
> +	}
> +
> +	io_uring_prep_poll_remove(sqe[0], 0);
> +	sqe[0]->user_data = 2;
> +	io_uring_prep_nop(sqe[1]);
> +	sqe[1]->flags |= IOSQE_IO_DRAIN;
> +	sqe[1]->user_data = 3;
> +
> +	ret = io_uring_submit(ring);
> +	if (ret < 0) {
> +		printf("sqe submit failed\n");
> +		goto err;
> +	} else if (ret < 2) {
> +		printf("Submitted only %d\n", ret);
> +		goto err;
> +	}
> +
> +
> +	for (i = 0; i < 6; i++) {
> +		ret = io_uring_wait_cqe(ring, &cqe);
> +		if (ret < 0) {
> +			printf("wait completion %d\n", ret);
> +			goto err;
> +		}
> +		io_uring_cqe_seen(ring, cqe);
> +		if ((i == 5) && (cqe->user_data != 3))
> +			goto err;
> +	}
> +
> +	return 0;
> +err:
> +	return 1;
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	struct io_uring ring;
> +	int i, ret;
> +
> +	if (argc > 1)
> +		return 0;
> +
> +	ret = io_uring_queue_init(1024, &ring, 0);
> +	if (ret) {
> +		printf("ring setup failed\n");
> +		return 1;
> +	}
> +
> +	for (i = 0; i < 5; i++) {
> +		ret = test_simple_drain(&ring);
> +		if (ret) {
> +			fprintf(stderr, "test_simple_drain failed\n");
> +			break;
> +		}
> +	}
> +
> +	for (i = 0; i < 5; i++) {
> +		ret = test_generic_drain(&ring);
> +		if (ret) {
> +			fprintf(stderr, "test_generic_drain failed\n");
> +			break;
> +		}
> +	}
> +	return ret;
> +}
> 

-- 
Pavel Begunkov
