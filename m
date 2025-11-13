Return-Path: <io-uring+bounces-10569-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id CBE12C56E29
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 11:36:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4E6073549B2
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 10:33:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EC4932ED31;
	Thu, 13 Nov 2025 10:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="dS0ybgZm"
X-Original-To: io-uring@vger.kernel.org
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C849C2EA174;
	Thu, 13 Nov 2025 10:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763029988; cv=none; b=TVlC5ZRQ6lidXeGYxxLRs/38jUU9ITAzwCRb3g5tyqX3zcLhlG0TFDSYrxyGUYW7GHrcb4qDARYldE0urzATrvqj+7SImJ8y9P4Pt+Wa8b4l0SqPOLHycOPoQ5VA4WUlbpn0BnVPy3kVNS5skNTnKCLmuGHSxz/IWNo9iOrrVW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763029988; c=relaxed/simple;
	bh=EUq5b0ceA384HoAYJcqr3tX9lyN6QpMFb8Oj5B5T+ho=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u3A+eiVUqS6lPsbbP9Xg4S+9muYETNjvPQiNuTEvUm/zzGMzWIORSopHrbMRTkxHLi0daW02VJaCQViaTBWd+Gu7G2Mxa2Cl4krV5YklhaZJWXBKqqaXeMG7SnA5fjct5t4T72eyAthnmiw71XT+jhwKdGLWKe9xbuBS/BcFTVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=dS0ybgZm; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=kHQcfq9vg4tvLXnucSzKVW15QIbwB3IQmGxst8gx5PQ=; b=dS0ybgZm1rTRKJIYj6rQPJ3avt
	dDFzH1IGQ1TlJJbfWLmGNQQRjulTLDtahuEpfOOf8pxQDOLnkHQMNZr9SkONFaZHorvH5ntbeXh2o
	AC7TQwns+CFUfta/BMUJGjHfF6hXwftfKmBIDur7PI4UYw9SbQpnjuHxnPDkURg0DpLVUTKu6m/Hg
	loVbQiE988UupfL7weh3YgCmgNjFpNdDtzUUwfXWmD6wo91vvOMx0HyscRNnDqbzz1gIXrjmmFspy
	ZyXElWEpQzjgyq3G2kj0HxJmDzjro6sQzb/UXXWvDEsJF5NZGS8SbQsqbdDxdWg+YPsk7ANwnghcG
	nGV23DK3cZNcLOvWsKqmk7TkA1rR9j5uw43uHkIMrwb9uuyz5U3QI0x4ex7EpxxhaFXe3SXC++stl
	Q/D1I+Ia+ysdrkBjKaHH/srNfP/zJGoBH5qgxDVWFmYvxqQ5KjF037PXzENi6N8FBRMyn5Duqsq3R
	4yNRTs3Bgko9s0oL4QZmTD17;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vJUdM-00DtHE-2k;
	Thu, 13 Nov 2025 10:32:56 +0000
Message-ID: <94f94f0e-7086-4f44-a658-9cb3b5496faf@samba.org>
Date: Thu, 13 Nov 2025 11:32:56 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] io_uring: bpf: extend io_uring with bpf struct_ops
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
Cc: Caleb Sander Mateos <csander@purestorage.com>,
 Akilesh Kailash <akailash@google.com>, bpf@vger.kernel.org,
 Alexei Starovoitov <ast@kernel.org>
References: <20251104162123.1086035-1-ming.lei@redhat.com>
 <20251104162123.1086035-4-ming.lei@redhat.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <20251104162123.1086035-4-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Ming,

> io_uring can be extended with bpf struct_ops in the following ways:
> 
> 1) add new io_uring operation from application
> - one typical use case is for operating device zero-copy buffer, which
> belongs to kernel, and not visible or too expensive to export to
> userspace, such as supporting copy data from this buffer to userspace,
> decompressing data to zero-copy buffer in Android case[1][2], or
> checksum/decrypting.
> 
> [1] https://lpc.events/event/18/contributions/1710/attachments/1440/3070/LPC2024_ublk_zero_copy.pdf
> 
> 2) extend 64 byte SQE, since bpf map can be used to store IO data
>     conveniently
> 
> 3) communicate in IO chain, since bpf map can be shared among IOs,
> when one bpf IO is completed, data can be written to IO chain wide
> bpf map, then the following bpf IO can retrieve the data from this bpf
> map, this way is more flexible than io_uring built-in buffer
> 
> 4) pretty handy to inject error for test purpose
> 
> bpf struct_ops is one very handy way to attach bpf prog with kernel, and
> this patch simply wires existed io_uring operation callbacks with added
> uring bpf struct_ops, so application can define its own uring bpf
> operations.

This sounds useful to me.

> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   include/uapi/linux/io_uring.h |   9 ++
>   io_uring/bpf.c                | 271 +++++++++++++++++++++++++++++++++-
>   io_uring/io_uring.c           |   1 +
>   io_uring/io_uring.h           |   3 +-
>   io_uring/uring_bpf.h          |  30 ++++
>   5 files changed, 311 insertions(+), 3 deletions(-)
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index b8c49813b4e5..94d2050131ac 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -74,6 +74,7 @@ struct io_uring_sqe {
>   		__u32		install_fd_flags;
>   		__u32		nop_flags;
>   		__u32		pipe_flags;
> +		__u32		bpf_op_flags;
>   	};
>   	__u64	user_data;	/* data to be passed back at completion time */
>   	/* pack this to avoid bogus arm OABI complaints */
> @@ -427,6 +428,13 @@ enum io_uring_op {
>   #define IORING_RECVSEND_BUNDLE		(1U << 4)
>   #define IORING_SEND_VECTORIZED		(1U << 5)
>   
> +/*
> + * sqe->bpf_op_flags		top 8bits is for storing bpf op
> + *				The other 24bits are used for bpf prog
> + */
> +#define IORING_BPF_OP_BITS	(8)
> +#define IORING_BPF_OP_SHIFT	(24)
> +
>   /*
>    * cqe.res for IORING_CQE_F_NOTIF if
>    * IORING_SEND_ZC_REPORT_USAGE was requested
> @@ -631,6 +639,7 @@ struct io_uring_params {
>   #define IORING_FEAT_MIN_TIMEOUT		(1U << 15)
>   #define IORING_FEAT_RW_ATTR		(1U << 16)
>   #define IORING_FEAT_NO_IOWAIT		(1U << 17)
> +#define IORING_FEAT_BPF			(1U << 18)
>   
>   /*
>    * io_uring_register(2) opcodes and arguments
> diff --git a/io_uring/bpf.c b/io_uring/bpf.c
> index bb1e37d1e804..8227be6d5a10 100644
> --- a/io_uring/bpf.c
> +++ b/io_uring/bpf.c
> @@ -4,28 +4,95 @@
>   #include <linux/kernel.h>
>   #include <linux/errno.h>
>   #include <uapi/linux/io_uring.h>
> +#include <linux/init.h>
> +#include <linux/types.h>
> +#include <linux/bpf_verifier.h>
> +#include <linux/bpf.h>
> +#include <linux/btf.h>
> +#include <linux/btf_ids.h>
> +#include <linux/filter.h>
>   #include "io_uring.h"
>   #include "uring_bpf.h"
>   
> +#define MAX_BPF_OPS_COUNT	(1 << IORING_BPF_OP_BITS)
> +
>   static DEFINE_MUTEX(uring_bpf_ctx_lock);
>   static LIST_HEAD(uring_bpf_ctx_list);
> +DEFINE_STATIC_SRCU(uring_bpf_srcu);
> +static struct uring_bpf_ops bpf_ops[MAX_BPF_OPS_COUNT];

This indicates to me that the whole system with all applications in all namespaces
need to coordinate in order to use these 256 ops?

I think in order to have something useful, this should be per
struct io_ring_ctx and each application should be able to load
its own bpf programs.

Something that uses bpf_prog_get_type() based on a bpf_fd
like SIOCKCMATTACH in net/kcm/kcmsock.c.

metze


