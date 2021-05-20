Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE6D38B94A
	for <lists+io-uring@lfdr.de>; Thu, 20 May 2021 23:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbhETWAF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 May 2021 18:00:05 -0400
Received: from out2.migadu.com ([188.165.223.204]:19712 "EHLO out2.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230382AbhETWAF (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 20 May 2021 18:00:05 -0400
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cmpwn.com; s=key1;
        t=1621547922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q6qeUd9eDw8W1FkBet3XVZ6msV9vtMtq3vn5ErBNykI=;
        b=cXZN+Y4tqPNgUr6QL9PXq+GPzgWjaUkMEZRR4piwa6FXFZBPhGWmuZ0fdkk3h0kTCnu9+O
        Vpax1QXWmlspHIkPUfTkhLDjPjzv6EdoJw3oQW55G5uDU0G43RL7IWFYF7BaEMVhVp4HUn
        L0RgctOvsIougqlhr4+eehCTSleJkDftqbufOcpe/yrs/816nFYxwwR9gx+3K2h/emVDZX
        t0lG+6SB+Xs6Ni145I5gVMLbeiQoPZLgjh2/kHVrL45sjThB8ATJheqZVTISzWJn9pSh3Q
        FdFGpVyUJB9u9eg3QAx9oKKOsp+BCLWHPlKfMHhS7SDBQBFoUe1W1wCJcwjg4Q==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Thu, 20 May 2021 17:58:41 -0400
Message-Id: <CBIERJ6XIKHG.2RR7X7MKTWV0F@taiga>
Subject: Re: Confusion regarding the use of OP_TIMEOUT
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   "Drew DeVault" <sir@cmpwn.com>
To:     "Pavel Begunkov" <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
References: <CBHHFOFELZZ3.C2MWHZF690NB@taiga>
 <740c1a20-f160-2ce4-708a-ecc0a8f33283@gmail.com>
In-Reply-To: <740c1a20-f160-2ce4-708a-ecc0a8f33283@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: sir@cmpwn.com
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu May 20, 2021 at 6:11 AM EDT, Pavel Begunkov wrote:
> > Essentially, I want the following:
> >=20
> > [operations...]
> > OP_TIMEOUT
> > [operations...]
> >=20
> > To be well-ordered, so that the second batch executes after the first.
> > To accomplish this, I've tried to submit the first operation of the
> > second batch with IO_DRAIN, which causes the CQE to be delayed, but
>
> ...causes request submission (i.e. execution) to be delayed to be
> exact, not CQE.

Er, right. But that's what I want, anyway.

> > ultimately it fails with EINTR instead of just waiting to execute.
>
> Does some request fails and you find such a CQE (which request?)?
> Or a syscall? submission or waiting?

So I have a test program which does the following:

1. Prep a write("hello world"), then a timeout, and a write("hello
   world"), in the SQ, in that order.
2. Submit all three
3. Process 3 SQEs, waiting if necessary, and display the result.

This prints "hello world", then waits 2 seconds (the timeout duration),
and then the final CQE shows EINTR as the result (and "hello world" is
not printed).

Here's an x86_64 binary which reproduces this:

https://l.sr.ht/ZQBh.test

Here's the code, though it's written in an as-of-yet unrelated
programming langauge, so not much help beyond illustrative purposes:

use errors;
use fmt;
use linux::io_uring::{flags};
use linux::io_uring;
use rt;
use strings;
use time;

export fn main() void =3D {
	let params =3D io_uring::params { ... };
	let ring =3D match (io_uring::setup(32, &params)) {
		ring: io_uring::io_uring =3D> ring,
		err: io_uring::error =3D> fmt::fatal(io_uring::strerror(err)),
	};
	defer io_uring::finish(&ring);

	let buf =3D strings::toutf8("Hello world!\n");
	let sqe =3D io_uring::must_get_sqe(&ring);
	io_uring::write(sqe, 1, buf: *[*]u8, len(buf));

	let ts =3D rt::timespec { ... };
	time::duration_to_timespec(time::SECOND * 2, &ts);
	let sqe =3D io_uring::must_get_sqe(&ring);
	io_uring::timeout(sqe, &ts, 0, 0);

	let sqe =3D io_uring::must_get_sqe(&ring);
	io_uring::write(sqe, 1, buf: *[*]u8, len(buf), flags::IO_DRAIN);

	io_uring::submit(&ring)!;

	for (let i =3D 0z; i < 3; i +=3D 1) {
		let cqe =3D match (io_uring::wait(&ring)) {
			err: io_uring::error =3D> fmt::fatal("Error: {}",
				io_uring::strerror(err)),
			cqe: *io_uring::cqe =3D> cqe,
		};
		defer io_uring::cqe_seen(&ring, cqe);

		let result =3D match (io_uring::result(cqe)) {
			err: io_uring::error =3D> match (err) {
				errors::timeout =3D> continue,
				* =3D> fmt::fatal("Error: {}",
					io_uring::strerror(err)),
			},
			r: int =3D> r,
		};
		fmt::errorfln("result: {} ({})", result, cqe.res)!;
	};
};
