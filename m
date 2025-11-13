Return-Path: <io-uring+bounces-10587-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 47694C57275
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 12:23:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 668C33B17FA
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 11:19:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB1532D7813;
	Thu, 13 Nov 2025 11:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="JNwz+Q3K"
X-Original-To: io-uring@vger.kernel.org
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DC1207A20;
	Thu, 13 Nov 2025 11:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763032778; cv=none; b=WOuDniqnrEJlhMVm6hg3xgxLRaPv78uA2eQMwny9rsMv+acmXqBa5qzc55uohcpJSXArWK1CvwmCQ9IK28mVxOXl3l839Xqe/N5kDU/Z5fPDevbCUkbWxYkEY9IKCGChSox5aGUzRmgQzKSFyIlcNqOTt9IUsTXXdfTXgOkclhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763032778; c=relaxed/simple;
	bh=1BA0qGcTC9HLsasXGE9EAwBRoUKjKOmVZ0fWU+i/pDk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TN23UJwncIqkugmHFBpYQ2oUaVK6LsdvesaSrq0n9uOWhWYb+NRfLb0EDXWwqs4nA8fIyvaSHZ4H46rzFu3gXqMTRG8AUgYYKCJzuc2F9Ky7Z/08m6+vKbzMA5Ii7QSjARB9+q221lvj1/Os/FxCAhMz6p/W/BMZfc3HqTflRCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=JNwz+Q3K; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=MjQfLvu/KtASAd5uKnK8YtGVX5qN/NhGDnJltU+QqcQ=; b=JNwz+Q3KcIW2f6w0/PCKLCbUeZ
	kOF3FMprhC8ozhkKHRVIjElZ/sv1l1RSk0GeGFizXgS8aNTj1TlhgcDZZL9302tS76AZUGghP8lUo
	JEISYSjYUGvFHviPGxw62XSZissO8OO4SO2THOI0HFAK8oDah8WrsYRoJ3a6OtfIu6atkEEMCsIjw
	9dp9kaQmgbVkm59rKafROZUHmg3SirNy0LcRrj6e7sS5Y2tOlAUscC5fjV1LHt3rLAJ3+98AHUeWx
	YoXZn///c2vS3tvGzlp+cZFYY/mQ/TS9wEb4raNlvkdDnL+brzuT7zCjXajbG2fLmOcQSgKyjLRmB
	MPazf70No0ixJPidh7j3BOoBla3U0C8eVKninim9AeaWQ3LUlShb+Dc9NkaZ0b88WftBCmJtpY4ET
	gBnFWiHzXpayHxYxlUDWsUCDxk8OfpCbAUzCJjpZQ3bCbfUARCE1EuozS0HqdXzjT78MZRq7tXcXK
	1oUWJYy2RIBxillSc02WlLzm;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vJVMU-00DtWT-0D;
	Thu, 13 Nov 2025 11:19:34 +0000
Message-ID: <05a37623-c78c-4a86-a9f3-c78ce133fa66@samba.org>
Date: Thu, 13 Nov 2025 12:19:33 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] io_uring: bpf: extend io_uring with bpf struct_ops
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 Caleb Sander Mateos <csander@purestorage.com>,
 Akilesh Kailash <akailash@google.com>, bpf@vger.kernel.org,
 Alexei Starovoitov <ast@kernel.org>
References: <20251104162123.1086035-1-ming.lei@redhat.com>
 <20251104162123.1086035-4-ming.lei@redhat.com>
 <94f94f0e-7086-4f44-a658-9cb3b5496faf@samba.org> <aRW6LfJi63X7wbPm@fedora>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <aRW6LfJi63X7wbPm@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 13.11.25 um 11:59 schrieb Ming Lei:
> On Thu, Nov 13, 2025 at 11:32:56AM +0100, Stefan Metzmacher wrote:
>> Hi Ming,
>>
>>> io_uring can be extended with bpf struct_ops in the following ways:
>>>
>>> 1) add new io_uring operation from application
>>> - one typical use case is for operating device zero-copy buffer, which
>>> belongs to kernel, and not visible or too expensive to export to
>>> userspace, such as supporting copy data from this buffer to userspace,
>>> decompressing data to zero-copy buffer in Android case[1][2], or
>>> checksum/decrypting.
>>>
>>> [1] https://lpc.events/event/18/contributions/1710/attachments/1440/3070/LPC2024_ublk_zero_copy.pdf
>>>
>>> 2) extend 64 byte SQE, since bpf map can be used to store IO data
>>>      conveniently
>>>
>>> 3) communicate in IO chain, since bpf map can be shared among IOs,
>>> when one bpf IO is completed, data can be written to IO chain wide
>>> bpf map, then the following bpf IO can retrieve the data from this bpf
>>> map, this way is more flexible than io_uring built-in buffer
>>>
>>> 4) pretty handy to inject error for test purpose
>>>
>>> bpf struct_ops is one very handy way to attach bpf prog with kernel, and
>>> this patch simply wires existed io_uring operation callbacks with added
>>> uring bpf struct_ops, so application can define its own uring bpf
>>> operations.
>>
>> This sounds useful to me.
>>
>>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
>>> ---
>>>    include/uapi/linux/io_uring.h |   9 ++
>>>    io_uring/bpf.c                | 271 +++++++++++++++++++++++++++++++++-
>>>    io_uring/io_uring.c           |   1 +
>>>    io_uring/io_uring.h           |   3 +-
>>>    io_uring/uring_bpf.h          |  30 ++++
>>>    5 files changed, 311 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>> index b8c49813b4e5..94d2050131ac 100644
>>> --- a/include/uapi/linux/io_uring.h
>>> +++ b/include/uapi/linux/io_uring.h
>>> @@ -74,6 +74,7 @@ struct io_uring_sqe {
>>>    		__u32		install_fd_flags;
>>>    		__u32		nop_flags;
>>>    		__u32		pipe_flags;
>>> +		__u32		bpf_op_flags;
>>>    	};
>>>    	__u64	user_data;	/* data to be passed back at completion time */
>>>    	/* pack this to avoid bogus arm OABI complaints */
>>> @@ -427,6 +428,13 @@ enum io_uring_op {
>>>    #define IORING_RECVSEND_BUNDLE		(1U << 4)
>>>    #define IORING_SEND_VECTORIZED		(1U << 5)
>>> +/*
>>> + * sqe->bpf_op_flags		top 8bits is for storing bpf op
>>> + *				The other 24bits are used for bpf prog
>>> + */
>>> +#define IORING_BPF_OP_BITS	(8)
>>> +#define IORING_BPF_OP_SHIFT	(24)
>>> +
>>>    /*
>>>     * cqe.res for IORING_CQE_F_NOTIF if
>>>     * IORING_SEND_ZC_REPORT_USAGE was requested
>>> @@ -631,6 +639,7 @@ struct io_uring_params {
>>>    #define IORING_FEAT_MIN_TIMEOUT		(1U << 15)
>>>    #define IORING_FEAT_RW_ATTR		(1U << 16)
>>>    #define IORING_FEAT_NO_IOWAIT		(1U << 17)
>>> +#define IORING_FEAT_BPF			(1U << 18)
>>>    /*
>>>     * io_uring_register(2) opcodes and arguments
>>> diff --git a/io_uring/bpf.c b/io_uring/bpf.c
>>> index bb1e37d1e804..8227be6d5a10 100644
>>> --- a/io_uring/bpf.c
>>> +++ b/io_uring/bpf.c
>>> @@ -4,28 +4,95 @@
>>>    #include <linux/kernel.h>
>>>    #include <linux/errno.h>
>>>    #include <uapi/linux/io_uring.h>
>>> +#include <linux/init.h>
>>> +#include <linux/types.h>
>>> +#include <linux/bpf_verifier.h>
>>> +#include <linux/bpf.h>
>>> +#include <linux/btf.h>
>>> +#include <linux/btf_ids.h>
>>> +#include <linux/filter.h>
>>>    #include "io_uring.h"
>>>    #include "uring_bpf.h"
>>> +#define MAX_BPF_OPS_COUNT	(1 << IORING_BPF_OP_BITS)
>>> +
>>>    static DEFINE_MUTEX(uring_bpf_ctx_lock);
>>>    static LIST_HEAD(uring_bpf_ctx_list);
>>> +DEFINE_STATIC_SRCU(uring_bpf_srcu);
>>> +static struct uring_bpf_ops bpf_ops[MAX_BPF_OPS_COUNT];
>>
>> This indicates to me that the whole system with all applications in all namespaces
>> need to coordinate in order to use these 256 ops?
> 
> So far there is only 62 in-tree io_uring operation defined, I feel 256
> should be enough.
>
>> I think in order to have something useful, this should be per
>> struct io_ring_ctx and each application should be able to load
>> its own bpf programs.
> 
> per-ctx requirement looks reasonable, and it shouldn't be hard to
> support.
> 
>>
>> Something that uses bpf_prog_get_type() based on a bpf_fd
>> like SIOCKCMATTACH in net/kcm/kcmsock.c.
> 
> I considered per-ctx prog before, one drawback is the prog can't be shared
> among io_ring_ctx, which could waste memory. In my ublk case, there can be
> lots of devices sharing same bpf prog.

Can't the ublk instances coordinate and use the same bpf_fd?
new instances could request it via a unix socket and SCM_RIGHTS
from a long running loading process. On the other hand do they
really want to share?

I don't know much about bpf in details, so I'm wondering in your
example from
https://github.com/ming1/liburing/commit/625b69ddde15ad80e078c684ba166f49c1174fa4

Would memory_map be global in the whole system or would
each loaded instance of the program have it's own instance of memory_map?

Thanks!
metze




