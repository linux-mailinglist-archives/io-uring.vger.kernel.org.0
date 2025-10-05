Return-Path: <io-uring+bounces-9894-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 38252BBCCB8
	for <lists+io-uring@lfdr.de>; Sun, 05 Oct 2025 23:54:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DDF2A3B4A1E
	for <lists+io-uring@lfdr.de>; Sun,  5 Oct 2025 21:54:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D83DD19F43A;
	Sun,  5 Oct 2025 21:54:40 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from vultr155 (pcfhrsolutions.pyu.ca [155.138.137.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B36B2A1CF
	for <io-uring@vger.kernel.org>; Sun,  5 Oct 2025 21:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=155.138.137.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759701280; cv=none; b=fxU311yiZKFXhL9IsDPqEeTLOnf/L0d4Xm4cCH0kBBJKso1zwH65oGVxT7ZTtfZUfbqbnbt8TIh3oVf5tAGkefTlxusWpZaShIhS4uMkcYOgXbMZTsKCe1WvCc6z4jgPxcA76JMyfNYffE3SCGpoIqw2vQ71tTmCHF4KGFzcgH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759701280; c=relaxed/simple;
	bh=p2Is+wz3FZOQicLw8KBgVLfktDYm9ucnhpzH1p15rgQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a9x5O0z4FE7B4d0q6e40b4UWobU6jsDSvI6Qcyr+FZaECmn9ZIGMD0Ad1bzXlfn2VlsB8iPL0TeGHM4Oxj1LwkJ24zNfww8dQFZASE4BFAXaozNT+5bVZThOhJNLOC3A5lTz4nw+C/hA4+T7mwfDqa4Peduxcs2X7eX8PGygLDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=beta.pyu.ca; spf=pass smtp.mailfrom=beta.pyu.ca; arc=none smtp.client-ip=155.138.137.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=beta.pyu.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=beta.pyu.ca
Received: by vultr155 (Postfix, from userid 1001)
	id 805D2140681; Sun,  5 Oct 2025 17:54:37 -0400 (EDT)
Date: Sun, 5 Oct 2025 17:54:37 -0400
From: Jacob Thompson <jacobT@beta.pyu.ca>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: "hange-folder>?" <toggle-mailboxes@vultr155.smtp.subspace.kernel.org>
Subject: Re: CQE repeats the first item?
Message-ID: <20251005215437.GA973@vultr155>
References: <20251005202115.78998140681@vultr155>
 <ef3a1c2c-f356-4b17-b0bd-2c81acde1462@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <ef3a1c2c-f356-4b17-b0bd-2c81acde1462@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Oct 05, 2025 at 02:56:05PM -0600, Jens Axboe wrote:
> On 10/5/25 2:21 PM, Jacob Thompson wrote:
> > I'm doing something wrong and I wanted to know if anyone knows what I
> > did wrong from the description I'm using syscalls to call
> > io_uring_setup and io_uring_enter. I managed to submit 1 item without
> > an issue but any more gets me the first item over and over again. In
> > my test I did a memset -1 on cqes and sqes, I memset 0 the first ten
> > sqes with different user_data (0x1234 + i), and I used the opcode
> > IORING_OP_NOP. I called "io_uring_enter(fd, 10, 0,
> > IORING_ENTER_SQ_WAKEUP, 0)" and looked at the cq. Item 11 has the
> > user_data as '18446744073709551615' which is correct, but the first 10
> > all has user_data be 0x1234 which is weird AF since only one item has
> > that user_data and I submited 10 I considered maybe the debugger was
> > giving me incorrect values so I tried printing the user data in a
> > loop, I have no idea why the first one repeats 10 times. I only called
> > enter once
> > 
> > Id is 4660
> > Id is 4660
> > Id is 4660
> > Id is 4660
> > Id is 4660
> > Id is 4660
> > Id is 4660
> > Id is 4660
> > Id is 4660
> > Id is 4660
> > Id is 18446744073709551615
> 
> You're presumably not updating your side of the CQ ring correctly, see
> what liburing does when you call io_uring_cqe_seen(). If that's not it,
> then you're probably mishandling something else and an example would be
> useful as otherwise I'd just be guessing. There's really not much to go
> from in this report.
> 
> -- 
> Jens Axboe

I tried reproducing it in a smaller file. Assume I did everything wrong but somehow I seem to get results and they're not correct.

The codebase I'd like to use this in has very little activity (could go seconds without a single syscall), then execute a few hundreds-thousand (which I like to be async).
SQPOLL sounds like the one best for my usecase. You can see I updated the sq tail before enter and I used IORING_ENTER_SQ_WAKEUP + slept for a second.
The sq tail isn't zero which means I have results? and you can see its 10 of the same user_data

cq head is 0 enter result was 10
1234 0
1234 0
1234 0
1234 0
1234 0
1234 0
1234 0
1234 0
1234 0
1234 0
FFFFFFFF -1


--liOOAslEiF7prFVr
Content-Type: text/x-c++src; charset=us-ascii
Content-Disposition: attachment; filename="test.cpp"

#include <unistd.h>
#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/syscall.h>
#include <linux/io_uring.h>

int io_uring_setup(unsigned entries, io_uring_params*params) { return syscall(__NR_io_uring_setup, entries, params); }
int io_uring_enter(int ring_fd, unsigned int to_submit, unsigned int min_complete, unsigned int flags, void*sig) { return (int) syscall(__NR_io_uring_enter, ring_fd, to_submit, min_complete, flags, 0); }

typedef int* IntPtr;
#define X(NAME) NAME = (int*)(p+params.sq_off.NAME)
struct sqinfo
{
	IntPtr head, tail, ring_mask, ring_entries, flags, dropped;
	int*array;
	void set(char*p, io_uring_params&params) { X(head); X(tail); X(ring_mask); X(ring_entries); X(flags); X(dropped); array = (int*)(p+params.sq_off.array); }
};
#undef X
#define X(NAME) NAME = (int*)(p+params.cq_off.NAME)
struct cqinfo
{
	IntPtr head, tail, ring_mask, ring_entries, overflow, flags;
	io_uring_cqe*cqes;
	void set(char*p, io_uring_params&params) { X(head); X(tail); X(ring_mask); X(ring_entries); X(overflow); X(flags); cqes = (io_uring_cqe*)(p+params.cq_off.cqes); }
};
#undef X


int main(int argc, char*argv[])
{
	int queue_size = 256;
	io_uring_params param{}; // zero init
	param.flags = IORING_SETUP_SQPOLL;
	int ringFD = io_uring_setup(queue_size, &param);
	assert(ringFD>0);
	assert(param.features & IORING_FEAT_SINGLE_MMAP);
	auto base_length = param.sq_off.array + param.sq_entries*4;
	char *base = (char*) mmap(0, base_length, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, ringFD, IORING_OFF_SQ_RING);
	assert(base != MAP_FAILED);
	auto sqes = (io_uring_sqe*)mmap(0, param.sq_entries * sizeof(io_uring_sqe), PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, ringFD, IORING_OFF_SQES);
	assert(sqes != MAP_FAILED);

	cqinfo cq;
	sqinfo sq;

	cq.set(base, param);
	sq.set(base, param);
	for(int i=0; i<*sq.ring_entries; i++) {
		memset(sqes+i, -1, sizeof(io_uring_sqe));
	}
	for(int i=0; i<*cq.ring_entries; i++) {
		memset(cq.cqes+i, -1, sizeof(io_uring_cqe));
	}


	// Take 10 items
	assert(*sq.tail == 0);
	auto p = &sqes[0];
	memset(p, 0, sizeof(io_uring_sqe)*10);
	for(int i=0; i<10; i++) {
		sqes[i].opcode = IORING_OP_NOP;
		sqes[i].user_data = 0x1234+i;
	}

	__atomic_store_n(sq.tail, 10, __ATOMIC_RELEASE);

	//int res = io_uring_enter(ringFD, 10, 10, IORING_ENTER_SQ_WAIT, 0);
	int res = io_uring_enter(ringFD, 10, 10, IORING_ENTER_SQ_WAKEUP, 0);

	sleep(1);
	printf("cq tail is %d enter result was %d\n", __atomic_load_n(cq.tail, __ATOMIC_ACQUIRE), res);

	for(int i=0; i<11; i++) {
		printf("%X %d\n", cq.cqes[i].user_data, cq.cqes[i].res);
	}
	return 0;
}

--liOOAslEiF7prFVr--

