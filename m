Return-Path: <io-uring+bounces-11898-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4JLpBzSFc2kDxAAAu9opvQ
	(envelope-from <io-uring+bounces-11898-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 23 Jan 2026 15:27:00 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 04E807708C
	for <lists+io-uring@lfdr.de>; Fri, 23 Jan 2026 15:26:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B7641300D0F3
	for <lists+io-uring@lfdr.de>; Fri, 23 Jan 2026 14:26:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A29A330F93C;
	Fri, 23 Jan 2026 14:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q//mcBVk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com [209.85.221.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B754F32695C
	for <io-uring@vger.kernel.org>; Fri, 23 Jan 2026 14:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769178407; cv=none; b=gla9NEVlHHsd8Q8B0E3aEIhrBkKXioDka8KqglZq6piztD48seFzYrL3mtjH7OPnsc+lZzIS79M003dLs4m1rqOopnjQoAvFxs2m336iR7n8rRxTQvHqylCUPST/rvhIjhcvWwmPKP8Hnf6Um1LJxneke4YC+NxZMwxyWBT66w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769178407; c=relaxed/simple;
	bh=oVRjf5DSaNOmd6L06vLJkwwbWvK7/9jyIhoDqGEmMxM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=jFO2Jwj6y+5KTCdHrrt/ZFjXhQWKbJ7C/Kan2KrEmtXqPZLKIyvD9JdPhvpu99FZe6k6Oi56VL1GzM1qqtQJVZTbpVtEmxhntPH9spCYMohohy1GYi0tSIko+Fd+h9A9tPu8fF3icr+j8mqXgF2zyMT49mLE8WDDZBflo/QSmDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q//mcBVk; arc=none smtp.client-ip=209.85.221.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f67.google.com with SMTP id ffacd0b85a97d-435903c4040so1461658f8f.3
        for <io-uring@vger.kernel.org>; Fri, 23 Jan 2026 06:26:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769178404; x=1769783204; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=65qAhjbi6/d7Yz1zhQH0phXY9Xh8ELxAIecmKd0lbOI=;
        b=Q//mcBVke8doRk7amzIKsOBGITmsJ5rG+cnawfGRJlFrqkWmQ6G5eNwGweTB01WKkt
         80G6jgYZUTVCWl086L42vIunkgkWcygAPBebNv+LVyxK0KSp3cr61Jv4/YY4RSMFfDfT
         U77phsOfMwDovaa/C7VBOekM4cGhIzouQXd5DjuFHE4muxrOh+0P/uRuxayt1WdJ8k9s
         eHLjdaiulrMEcLC5tAVp6ImgbeKrL4+xg8UlKZ6r/8ilan2wriQ16eAKqh3ogNVQ4irw
         rVMEN843UrY/XVwtwitOaJMpds8fRZloPDIOPewvwQrv9C52EGh/g55D1W/HFz7JTZDe
         ySIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769178404; x=1769783204;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=65qAhjbi6/d7Yz1zhQH0phXY9Xh8ELxAIecmKd0lbOI=;
        b=eghL+2iJRjjd/VOhrpRNzEQ692m33wwymLM9NvHsI8Q33KU6QHgBUv29ejrJAj1QF1
         ylbACuMrpwkOjYOId7NDOutN0+UY5K/qNEJXVuNrSdhhYslCGIb+2w/eYn5J0DMfkvsR
         MUwtBeAJdI02H25dTLGjuUdkFMFSrCv4jMJj9Ano+gECx/S4bR6bkGPcrvcFWAbGUwVf
         4wlPwQ9dPFElvBN50IISzMBm4JDTE/gmODUDCSKguS4sdkL2LtWz0RZ9i3vj3cf1xpS+
         xa+RqeIlQbHQnd+bRHzFQnkHJvG4a6+7VoP0FMarp+UAZX3ASWcrBY1GrFvUG5xnG97Z
         XXAw==
X-Gm-Message-State: AOJu0Yz0WPAL6uTPeflxOuSKmwjR3GvzZiXEfzF0YKenZNCJpyvMnK52
	aBg3HJAV2Gc1eNlylG/YhCAscmg+ITwxToLOp1Pn5EUalz798EnKco3n
X-Gm-Gg: AZuq6aKe7O22Ii5WQjt1tZZoag6OeQvAvq96iKg/ZdYq63U3b6omm89s2v8zg9JWmqJ
	JT3+ldRbP8KtM7xrMfsB8BOOvBU5YD949cPYYDQxMJxSI90LHvR3cpPOqXwBGs0sI8l5+UIInUO
	W+OnFckr5dZVEm08+t7YvLIQISmw2Izqxwwg3OVmhk9WiWL8OZTIDjzPY05uNt3Y97Oe0vrjxh/
	jndA9RFDIBddZswrZ9w1w0cdijkT611xvgXgeD0cJQsvvsSI1VNcC5qyPTsCodLnXJW7kkGTLMR
	HSZIc0dMEZNXA+4iILhyErXL6txx6sS8MOK6RP4C6MkbBaeK4OaIdO5fc4Ax+jiLWrBPb5/9eLH
	iT/Tp+PEAYr7VTkkQrAbzBmo8U5UhwtK6tAK9D6aihHCDVqD4L4kYcKD1BkUJ/BIi9+6UYbaY7l
	jIFT1LNiHd4CEDZDEUf5K2/8tUjVX4/FAf/7Ij2iB3847TI2Mw4/ppQBAA/6E9i9Zo9qWR3ANjJ
	rqDZz+NN/K3OW3Aoj2Ff80Ww0PHZzpZTndBgJ8VM2vySH8=
X-Received: by 2002:a05:600c:64c6:b0:47e:de23:dd6f with SMTP id 5b1f17b1804b1-48050d6aebfmr30668265e9.12.1769178403579;
        Fri, 23 Jan 2026 06:26:43 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:1951])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4804703b5b4sm147732635e9.5.2026.01.23.06.26.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jan 2026 06:26:43 -0800 (PST)
Message-ID: <596bc7ac-3d24-43a7-9e7e-e59189525ebc@gmail.com>
Date: Fri, 23 Jan 2026 14:26:39 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/rsrc: fix RLIMIT_MEMLOCK bypass by removing
 cross-buffer accounting
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Yuhao Jiang <danisjiang@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260119071039.2113739-1-danisjiang@gmail.com>
 <bc2e8ec1-8809-4603-9519-788cfff2ae12@kernel.dk>
 <CAHYQsXTHfRKBuTDYWus9r5jDLO2WLBeopt4_bGH_vVm=0z7mWw@mail.gmail.com>
 <2919f3c5-2510-4e97-ab7f-c9eef1c76a69@kernel.dk>
 <CAHYQsXQK4nKu+fcni71__=V241RN=QxUHrvNQMQtPMzeL_z=BA@mail.gmail.com>
 <d8d28435-2a89-4b25-925e-14fdb346839b@gmail.com>
 <8c6a9114-82e9-416e-804b-ffaa7a679ab7@kernel.dk>
 <2be71481-ac35-4ff2-b6a9-a7568f81f728@gmail.com>
 <2fcf583a-f521-4e8d-9a89-0985681ca85b@kernel.dk>
 <d2fc2ff2-98d9-49f8-af95-968100174d55@gmail.com>
 <3b7e6088-7d92-4d5c-96c7-f8c0e2cc7745@kernel.dk>
 <efe080c9-5176-4fa1-9f65-5be44074779e@gmail.com>
Content-Language: en-US
In-Reply-To: <efe080c9-5176-4fa1-9f65-5be44074779e@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-11898-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 04E807708C
X-Rspamd-Action: no action

On 1/22/26 21:51, Pavel Begunkov wrote:
...
>>>> I already briefly touched on that earlier, for sure not going to be of
>>>> any practical concern.
>>>
>>> Modest 16 GB can give 1M entries. Assuming 50ns-100ns per entry for the
>>> xarray business, that's 50-100ms. It's all serialised, so multiply by
>>> the number of CPUs/threads, e.g. 10-100, that's 0.5-10s. Account sky
>>> high spinlock contention, and it jumps again, and there can be more
>>> memory / CPUs / numa nodes. Not saying that it's worse than the
>>> current O(n^2), I have a test program that borderline hangs the
>>> system.
>>
>> It's definitely not worse than the existing system, which is why I don't
>> think it's a big deal. Nobody has ever complained about time to register
>> buffers. It's inherently a slow path, and quite slow at that depending
>> on the use case. Out of curiosity, I ran some stilly testing on
>> registering 16GB of memory, with 1..32 threads. Each will do 16GB, so
>> 512GB registered in total for the 32 case. Before is the current kernel,
>> after is with per-user xarray accounting:
>>
>> before
>>
>> nthreads 1:      646 msec
>> nthreads 2:      888 msec
>> nthreads 4:      864 msec
>> nthreads 8:     1450 msec
>> nthreads 16:    2890 msec
>> nthreads 32:    4410 msec
>>
>> after
>>
>> nthreads 1:      650 msec
>> nthreads 2:      888 msec
>> nthreads 4:      892 msec
>> nthreads 8:     1270 msec
>> nthreads 16:    2430 msec
>> nthreads 32:    4160 msec
>>
>> This includes both registering buffers, cloning all of them to another
>> ring, and unregistering times, and nowhere is locking scalability an
>> issue for the xarray manipulation. The box has 32 nodes and 512 CPUs. So
>> no, I strongly believe this isn't an issue.
>>
>> IOW, accurate accounting is cheaper than the stuff we have now. None of
>> them are super cheap. Does it matter? I really don't think so, or people
>> would've complained already. The only complaint I got on these kinds of
>> things was for cloning, which did get fixed up some releases ago.
> 
> You need compound pages
> 
> always > /sys/kernel/mm/transparent_hugepage/hugepages-16kB/enabled
> 
> And use update() instead of register() as accounting dedup for
> registration is broken-disabled. For the current kernel:
> 
> Single threaded:
> 1x1G: 7.5s
> 2x1G: 45s
> 4x1G: 190s
> 
> 16x should be ~3000s, not going to run it. Uninterruptible and no
> cond_resched, so spawn NR_CPUS threads and the system is completely
> unresponsive (I guess it depends on the preemption mode).
The program is below for reference, but it's trivial. THP setting
is done inside for convenience. There are ways to make the runtime
even worse, but that should be enough.


#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include "liburing.h"

#define NUM_THREADS 1
#define BUFFER_SIZE (1024UL * 1024 * 1024)
#define MAX_IOVS 64

static int num_iovs = 1;
static void *buffer;
static pthread_barrier_t barrier;

static void *thread_func(void *arg)
{
	struct io_uring ring;
	struct iovec iov[MAX_IOVS];
	int th_idx = (long)arg;
	int ret, i;

	for (i = 0; i < MAX_IOVS; i++) {
		iov[i].iov_base = buffer + i * BUFFER_SIZE;
		iov[i].iov_len  = BUFFER_SIZE;
	}

	ret = io_uring_queue_init(8, &ring, 0);
	if (ret) {
		fprintf(stderr, "ring init failed: %i\n", ret);
		return NULL;
	}

	ret = io_uring_register_buffers_sparse(&ring, MAX_IOVS);
	if (ret < 0) {
		fprintf(stderr, "reg sparse failed\n");
		return NULL;
	}

	pthread_barrier_wait(&barrier);

	ret = io_uring_register_buffers_update_tag(&ring, 0, iov, NULL, num_iovs);
	if (ret < 0)
		fprintf(stderr, "buffer update failed: %i\n", ret);

	printf("thread %i finished\n", th_idx);
	io_uring_queue_exit(&ring);
	return NULL;
}

int main(int argc, char **argv)
{
	pthread_t threads[NUM_THREADS];
	int sys_fd;
	int ret;

	if (argc != 2) {
		fprintf(stderr, "invalid number of arguments\n");
		return 1;
	}
	num_iovs = strtoul(argv[1], NULL, 0);
	printf("register %i GB, num threads %i\n", num_iovs, NUM_THREADS);

	// always > /sys/kernel/mm/transparent_hugepage/hugepages-16kB/enabled
	sys_fd = open("/sys/kernel/mm/transparent_hugepage/hugepages-16kB/enabled", O_RDWR);
	if (sys_fd < 0) {
		fprintf(stderr, "thp sys open failed %i\n", errno);
		return 1;
	}

	const char str[] = "always";
	ret = write(sys_fd, str, sizeof(str));
	if (ret != sizeof(str)) {
		fprintf(stderr, "thp sys write failed %i\n", errno);
		return 1;
	}

	buffer = aligned_alloc(64 * 1024, BUFFER_SIZE * num_iovs);
	if (!buffer) {
		fprintf(stderr, "allocation failed\n");
		return 1;
	}
	memset(buffer, 0, BUFFER_SIZE * num_iovs);

	pthread_barrier_init(&barrier, NULL, NUM_THREADS);
	for (long i = 0; i < NUM_THREADS; i++) {
		ret = pthread_create(&threads[i], NULL, thread_func, (void *)i);
		if (ret) {
			fprintf(stderr, "pthread_create failed for thread %ld\n", i);
			return 1;
		}
	}

	for (int i = 0; i < NUM_THREADS; i++)
		pthread_join(threads[i], NULL);
	pthread_barrier_destroy(&barrier);
	free(buffer);
	return 0;
}

