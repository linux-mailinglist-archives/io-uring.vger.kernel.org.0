Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4F5131DE9C
	for <lists+io-uring@lfdr.de>; Wed, 17 Feb 2021 18:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbhBQRuu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Feb 2021 12:50:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:44886 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231766AbhBQRur (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 17 Feb 2021 12:50:47 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6C034B1BC;
        Wed, 17 Feb 2021 17:50:06 +0000 (UTC)
Date:   Wed, 17 Feb 2021 18:50:04 +0100
From:   Petr Vorel <pvorel@suse.cz>
To:     Martin Doucha <mdoucha@suse.cz>
Cc:     ltp@lists.linux.it, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, Nicolai Stange <nstange@suse.de>,
        Martin Doucha <mdoucha@suse.cz>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [LTP] [PATCH 2/2] syscalls/io_uring02: Use IOSQE_ASYNC when
 available
Message-ID: <YC1XTICmdoR54owE@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20210217120459.17500-1-mdoucha@suse.cz>
 <20210217120459.17500-2-mdoucha@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210217120459.17500-2-mdoucha@suse.cz>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Martin,

[ Cc: io_uring folks ]

thanks a lot for your fix. Working well, patchset merged.

Kind regards,
Petr

> Signed-off-by: Martin Doucha <mdoucha@suse.cz>
> ---
>  .../kernel/syscalls/io_uring/io_uring02.c     | 70 ++++++++++++++++---
>  1 file changed, 62 insertions(+), 8 deletions(-)

> diff --git a/testcases/kernel/syscalls/io_uring/io_uring02.c b/testcases/kernel/syscalls/io_uring/io_uring02.c
> index 08f4a1714..cd90fbdc3 100644
> --- a/testcases/kernel/syscalls/io_uring/io_uring02.c
> +++ b/testcases/kernel/syscalls/io_uring/io_uring02.c
> @@ -79,11 +79,11 @@ static void setup(void)
>  	SAFE_CHROOT(CHROOT_DIR);
>  }

> -static void run(void)
> +static void drain_fallback(void)
>  {
>  	uint32_t i, count, tail;
>  	int beef_found = 0;
> -	struct io_uring_sqe *sqe_ptr;
> +	struct io_uring_sqe *sqe_ptr = uring.sqr_entries;
>  	const struct io_uring_cqe *cqe_ptr;

>  	SAFE_SOCKETPAIR(AF_UNIX, SOCK_DGRAM, 0, sockpair);
> @@ -91,9 +91,6 @@ static void run(void)
>  		32+sizeof(buf));
>  	SAFE_FCNTL(sockpair[0], F_SETFL, O_NONBLOCK);

> -	SAFE_IO_URING_INIT(512, &params, &uring);
> -	sqe_ptr = uring.sqr_entries;
> -
>  	/* Add spam requests to force async processing of the real test */
>  	for (i = 0, tail = *uring.sqr_tail; i < 255; i++, tail++, sqe_ptr++) {
>  		memset(sqe_ptr, 0, sizeof(*sqe_ptr));
> @@ -150,7 +147,7 @@ static void run(void)
>  			tst_res(TFAIL | TTERRNO,
>  				"Write outside chroot failed unexpectedly");
>  		} else {
> -			tst_res(TPASS,
> +			tst_res(TPASS | TTERRNO,
>  				"Write outside chroot failed as expected");
>  		}
>  	}
> @@ -163,12 +160,69 @@ static void run(void)
>  	if (count)
>  		tst_res(TFAIL, "Wrong number of entries in completion queue");

> -	/* iteration cleanup */
> -	SAFE_IO_URING_CLOSE(&uring);
>  	SAFE_CLOSE(sockpair[0]);
>  	SAFE_CLOSE(sockpair[1]);
>  }

> +static void check_result(void)
> +{
> +	const struct io_uring_cqe *cqe_ptr;
> +
> +	cqe_ptr = uring.cqr_entries + (*uring.cqr_head & *uring.cqr_mask);
> +	++*uring.cqr_head;
> +	TST_ERR = -cqe_ptr->res;
> +
> +	if (cqe_ptr->user_data != BEEF_MARK) {
> +		tst_res(TFAIL, "Unexpected entry in completion queue");
> +		return;
> +	}
> +
> +	if (cqe_ptr->res == -EINVAL) {
> +		tst_res(TINFO, "IOSQE_ASYNC is not supported, using fallback");
> +		drain_fallback();
> +		return;
> +	}
> +
> +	tst_res(TINFO, "IOSQE_ASYNC is supported");
> +
> +	if (cqe_ptr->res >= 0) {
> +		tst_res(TFAIL, "Write outside chroot succeeded.");
> +		return;
> +	}
> +
> +	if (cqe_ptr->res != -ENOENT) {
> +		tst_res(TFAIL | TTERRNO,
> +			"Write outside chroot failed unexpectedly");
> +		return;
> +	}
> +
> +	tst_res(TPASS | TTERRNO, "Write outside chroot failed as expected");
> +}
> +
> +static void run(void)
> +{
> +	uint32_t tail;
> +	struct io_uring_sqe *sqe_ptr;
> +
> +	SAFE_IO_URING_INIT(512, &params, &uring);
> +	sqe_ptr = uring.sqr_entries;
> +	tail = *uring.sqr_tail;
> +
> +	memset(sqe_ptr, 0, sizeof(*sqe_ptr));
> +	sqe_ptr->opcode = IORING_OP_SENDMSG;
> +	sqe_ptr->flags = IOSQE_ASYNC;
> +	sqe_ptr->fd = sendsock;
> +	sqe_ptr->addr = (__u64)&beef_header;
> +	sqe_ptr->user_data = BEEF_MARK;
> +	uring.sqr_array[tail & *uring.sqr_mask] = 0;
> +	tail++;
> +
> +	__atomic_store(uring.sqr_tail, &tail, __ATOMIC_RELEASE);
> +	SAFE_IO_URING_ENTER(1, uring.fd, 1, 1, IORING_ENTER_GETEVENTS, NULL);
> +	check_result();
> +	SAFE_IO_URING_CLOSE(&uring);
> +}
> +
>  static void cleanup(void)
>  {
>  	if (uring.fd >= 0)
