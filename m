Return-Path: <io-uring+bounces-10588-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D123C572C6
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 12:27:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 97FA535067B
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 11:25:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F4C633C515;
	Thu, 13 Nov 2025 11:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="vK8694Jz"
X-Original-To: io-uring@vger.kernel.org
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB5833BBB0;
	Thu, 13 Nov 2025 11:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763033131; cv=none; b=KAYpbUPjYO43A3IBRR7Ieh1TqKKLVlyUA2f/QZ/LpE6XoVWX4CJ5F+RH1rh+u96cBOLLUbXI1HFxAF3rfbXruN7ptKc8L1ozrxU8E9IxF7tqWLA8ZKQYzFJICIGtzs9sZRb/8bxOpucdgyzDrJHxTigTpTpf1x2v2XuogMbG1WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763033131; c=relaxed/simple;
	bh=7lGw8nD661qX7W7IwuXAyASKXR9WpzKNfKTJep2dRHw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oLzwROsq7lK7xM8NPdIe4srJMN4ltrm2q/9XObTlvC0CeI5TilRrY7S8bL/LwlIy5OYcbv+aq0QfupJnhWbww0I+d30gElNRnpoqjwPDpWTaBvKUjZBkpIoKdlwn+Gx9Tb3207+DGAx0hBdPFpAXBksB1CZLVoq1Ui3NbP4T2pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=vK8694Jz; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=e7gQ5NF1cbJXIXSON4UN1zyqfiyHDrHRiTf/0f8yN3o=; b=vK8694JzwgWPp2tpHT3wObbZbj
	RQsjerR433hlhFdWidkSPbSUHVaYEfX9dsWc/m82W6HNKssCcVnnOURi9jZMnxH4BdEJsN3uSfVvg
	gBAYw0KFq+vMSJ6fmfJdtGd9lWcMC2dX6pKkK1VeEUntGYj78tpcRJG8+Y3v8zXCvrOdhGKNWD7gw
	sSjFvqN+uWzyTGz5V+mwwJ/1aqIl/Qkm3/8sj/MoR2cKqWzILu9gOfniPRq3KE66TqLYEWg2H5sIz
	NjQMRFw/gxnfKUvYVd9JFiAC3EhANwPpWalbNvZjezwjZg1m9BkhuPsQHWM+Xozd1/PagJdRolrxV
	GqKRP+T8+3kzt6FQqHPv5h4qB8D2Udd0PjNDpAqiLWToc4UsM+0pXKckXBHKQ1eSXwRxBkkxOfltm
	IfWyUulXdIDgSm0yw/jWuIn9PDXi0esnC604FmfTbRei2hJVI/FG67V5UD1p4w7LPQCBZ3IswQm5L
	4oSLiiD22QY+kCJzc+F52aCG;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vJVSB-00DtY6-04;
	Thu, 13 Nov 2025 11:25:27 +0000
Message-ID: <b412ad25-27c4-44ec-bcaa-aeb21a64d657@samba.org>
Date: Thu, 13 Nov 2025 12:25:26 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] io_uring: bpf: add buffer support for IORING_OP_BPF
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 Caleb Sander Mateos <csander@purestorage.com>,
 Akilesh Kailash <akailash@google.com>, bpf@vger.kernel.org,
 Alexei Starovoitov <ast@kernel.org>
References: <20251104162123.1086035-1-ming.lei@redhat.com>
 <20251104162123.1086035-5-ming.lei@redhat.com>
 <944b9487-059f-4c9b-b383-3ae4e359e01b@samba.org> <aRW7VJT3xLjHkChj@fedora>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <aRW7VJT3xLjHkChj@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 13.11.25 um 12:04 schrieb Ming Lei:
> On Thu, Nov 13, 2025 at 11:42:53AM +0100, Stefan Metzmacher wrote:
>> Am 04.11.25 um 17:21 schrieb Ming Lei:
>>> Add support for passing 0-2 buffers to BPF operations through
>>> IORING_OP_BPF. Buffer types are encoded in sqe->bpf_op_flags
>>> using dedicated 3-bit fields for each buffer.
>>>
>>> Buffer 1 can be:
>>> - None (no buffer)
>>> - Plain user buffer (addr=sqe->addr, len=sqe->len)
>>> - Fixed/registered buffer (index=sqe->buf_index, offset=sqe->addr,
>>>     len=sqe->len)
>>>
>>> Buffer 2 can be:
>>> - None (no buffer)
>>> - Plain user buffer (addr=sqe->addr3, len=sqe->optlen)
>>>
>>> The sqe->bpf_op_flags layout (32 bits):
>>>     Bits 31-24: BPF operation ID (8 bits)
>>>     Bits 23-21: Buffer 1 type (3 bits)
>>>     Bits 20-18: Buffer 2 type (3 bits)
>>>     Bits 17-0:  Custom BPF flags (18 bits)
>>>
>>> Using 3-bit encoding for each buffer type allows for future
>>> expansion to 8 types (0-7). Currently types 0-2 are defined
>>> (none/plain/fixed) and 3-7 are reserved for future use.
>>>
>>> Buffer 2 currently only supports none/plain types because the
>>> io_uring framework can only handle one fixed buffer per request
>>> (via req->buf_index). The 3-bit encoding provides room for
>>> future enhancements.
>>>
>>> Buffer metadata (addresses, lengths) is stored in the extended
>>> uring_bpf_data structure and is accessible to BPF programs with
>>> readonly permissions. Buffer types can be extracted from the opf
>>> field using IORING_BPF_BUF1_TYPE() and IORING_BPF_BUF2_TYPE()
>>> macros.
>>>
>>> Valid buffer combinations:
>>> - 0 buffers
>>> - 1 plain buffer
>>> - 1 fixed buffer
>>> - 2 plain buffers
>>> - 1 fixed buffer + 1 plain buffer
>>>
>>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
>>> ---
>>>    include/uapi/linux/io_uring.h | 45 +++++++++++++++++++++++--
>>>    io_uring/bpf.c                | 63 ++++++++++++++++++++++++++++++++++-
>>>    io_uring/uring_bpf.h          | 12 ++++++-
>>>    3 files changed, 116 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>> index 94d2050131ac..950f4cfbbf86 100644
>>> --- a/include/uapi/linux/io_uring.h
>>> +++ b/include/uapi/linux/io_uring.h
>>> @@ -429,12 +429,53 @@ enum io_uring_op {
>>>    #define IORING_SEND_VECTORIZED		(1U << 5)
>>>    /*
>>> - * sqe->bpf_op_flags		top 8bits is for storing bpf op
>>> - *				The other 24bits are used for bpf prog
>>> + * sqe->bpf_op_flags layout (32 bits total):
>>> + *   Bits 31-24: BPF operation ID (8 bits, 256 possible operations)
>>> + *   Bits 23-21: Buffer 1 type (3 bits: none/plain/fixed/reserved)
>>> + *   Bits 20-18: Buffer 2 type (3 bits: none/plain/reserved)
>>> + *   Bits 17-0:  Custom BPF flags (18 bits, available for BPF programs)
>>> + *
>>> + * For IORING_OP_BPF, buffers are specified as follows:
>>> + *   Buffer 1 (plain):  addr=sqe->addr, len=sqe->len
>>> + *   Buffer 1 (fixed):  index=sqe->buf_index, offset=sqe->addr, len=sqe->len
>>> + *   Buffer 2 (plain):  addr=sqe->addr3, len=sqe->optlen
>>> + *
>>> + * Note: Buffer 1 can be none/plain/fixed. Buffer 2 can only be none/plain.
>>> + *       3-bit encoding for each buffer allows for future expansion to 8 types (0-7).
>>> + *       Currently only one fixed buffer per request is supported (buffer 1).
>>> + *       Valid combinations: 0 buffers, 1 plain, 1 fixed, 2 plain, 1 fixed + 1 plain.
>>>     */
>>>    #define IORING_BPF_OP_BITS	(8)
>>>    #define IORING_BPF_OP_SHIFT	(24)
>>> +/* Buffer type encoding in sqe->bpf_op_flags */
>>> +#define IORING_BPF_BUF1_TYPE_SHIFT	(21)
>>> +#define IORING_BPF_BUF2_TYPE_SHIFT	(18)
>>> +#define IORING_BPF_BUF_TYPE_NONE	(0)	/* No buffer */
>>> +#define IORING_BPF_BUF_TYPE_PLAIN	(1)	/* Plain user buffer */
>>> +#define IORING_BPF_BUF_TYPE_FIXED	(2)	/* Fixed/registered buffer */
>>> +#define IORING_BPF_BUF_TYPE_MASK	(7)	/* 3-bit mask */
>>> +
>>> +/* Helper macros to encode/decode buffer types */
>>> +#define IORING_BPF_BUF1_TYPE(flags) \
>>> +	(((flags) >> IORING_BPF_BUF1_TYPE_SHIFT) & IORING_BPF_BUF_TYPE_MASK)
>>> +#define IORING_BPF_BUF2_TYPE(flags) \
>>> +	(((flags) >> IORING_BPF_BUF2_TYPE_SHIFT) & IORING_BPF_BUF_TYPE_MASK)
>>> +#define IORING_BPF_SET_BUF1_TYPE(type) \
>>> +	(((type) & IORING_BPF_BUF_TYPE_MASK) << IORING_BPF_BUF1_TYPE_SHIFT)
>>> +#define IORING_BPF_SET_BUF2_TYPE(type) \
>>> +	(((type) & IORING_BPF_BUF_TYPE_MASK) << IORING_BPF_BUF2_TYPE_SHIFT)
>>> +
>>> +/* Custom BPF flags mask (18 bits available, bits 17-0) */
>>> +#define IORING_BPF_CUSTOM_FLAGS_MASK	((1U << 18) - 1)
>>> +
>>> +/* Encode all components into sqe->bpf_op_flags */
>>> +#define IORING_BPF_OP_FLAGS(op, buf1_type, buf2_type, flags) \
>>> +	(((op) << IORING_BPF_OP_SHIFT) | \
>>> +	 IORING_BPF_SET_BUF1_TYPE(buf1_type) | \
>>> +	 IORING_BPF_SET_BUF2_TYPE(buf2_type) | \
>>> +	 ((flags) & IORING_BPF_CUSTOM_FLAGS_MASK))
>>> +
>>>    /*
>>>     * cqe.res for IORING_CQE_F_NOTIF if
>>>     * IORING_SEND_ZC_REPORT_USAGE was requested
>>> diff --git a/io_uring/bpf.c b/io_uring/bpf.c
>>> index 8227be6d5a10..e837c3d57b96 100644
>>> --- a/io_uring/bpf.c
>>> +++ b/io_uring/bpf.c
>>> @@ -11,8 +11,10 @@
>>>    #include <linux/btf.h>
>>>    #include <linux/btf_ids.h>
>>>    #include <linux/filter.h>
>>> +#include <linux/uio.h>
>>>    #include "io_uring.h"
>>>    #include "uring_bpf.h"
>>> +#include "rsrc.h"
>>>    #define MAX_BPF_OPS_COUNT	(1 << IORING_BPF_OP_BITS)
>>> @@ -28,7 +30,7 @@ static inline unsigned char uring_bpf_get_op(unsigned int op_flags)
>>>    static inline unsigned int uring_bpf_get_flags(unsigned int op_flags)
>>>    {
>>> -	return op_flags & ((1U << IORING_BPF_OP_SHIFT) - 1);
>>> +	return op_flags & IORING_BPF_CUSTOM_FLAGS_MASK;
>>>    }
>>>    static inline struct uring_bpf_ops *uring_bpf_get_ops(struct uring_bpf_data *data)
>>> @@ -36,18 +38,77 @@ static inline struct uring_bpf_ops *uring_bpf_get_ops(struct uring_bpf_data *dat
>>>    	return &bpf_ops[uring_bpf_get_op(data->opf)];
>>>    }
>>> +static int io_bpf_prep_buffers(struct io_kiocb *req,
>>> +			       const struct io_uring_sqe *sqe,
>>> +			       struct uring_bpf_data *data,
>>> +			       unsigned int op_flags)
>>> +{
>>> +	u8 buf1_type, buf2_type;
>>> +
>>> +	/* Extract buffer configuration from bpf_op_flags */
>>> +	buf1_type = IORING_BPF_BUF1_TYPE(op_flags);
>>> +	buf2_type = IORING_BPF_BUF2_TYPE(op_flags);
>>> +
>>> +	/* Prepare buffer 1 */
>>> +	if (buf1_type == IORING_BPF_BUF_TYPE_PLAIN) {
>>> +		/* Plain user buffer: addr=sqe->addr, len=sqe->len */
>>> +		data->buf1_addr = READ_ONCE(sqe->addr);
>>> +		data->buf1_len = READ_ONCE(sqe->len);
>>> +	} else if (buf1_type == IORING_BPF_BUF_TYPE_FIXED) {
>>> +		/* Fixed buffer: index=sqe->buf_index, offset=sqe->addr, len=sqe->len */
>>> +		req->buf_index = READ_ONCE(sqe->buf_index);
>>> +		data->buf1_addr = READ_ONCE(sqe->addr);  /* offset within fixed buffer */
>>> +		data->buf1_len = READ_ONCE(sqe->len);
>>> +
>>> +		/* Validate buffer index */
>>> +		if (unlikely(!req->ctx->buf_table.nr))
>>> +			return -EFAULT;
>>> +		if (unlikely(req->buf_index >= req->ctx->buf_table.nr))
>>> +			return -EINVAL;
>>> +	} else if (buf1_type == IORING_BPF_BUF_TYPE_NONE) {
>>> +		data->buf1_addr = 0;
>>> +		data->buf1_len = 0;
>>> +	} else {
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	/* Prepare buffer 2 (plain only - io_uring only supports one fixed buffer) */
>>> +	if (buf2_type == IORING_BPF_BUF_TYPE_PLAIN) {
>>> +		/* Plain user buffer: addr=sqe->addr3, len=sqe->optlen */
>>> +		data->buf2_addr = READ_ONCE(sqe->addr3);
>>> +		data->buf2_len = READ_ONCE(sqe->optlen);
>>> +	} else if (buf2_type == IORING_BPF_BUF_TYPE_NONE) {
>>> +		data->buf2_addr = 0;
>>> +		data->buf2_len = 0;
>>> +	} else {
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +
>>>    int io_uring_bpf_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>    {
>>>    	struct uring_bpf_data *data = io_kiocb_to_cmd(req, struct uring_bpf_data);
>>>    	unsigned int op_flags = READ_ONCE(sqe->bpf_op_flags);
>>>    	struct uring_bpf_ops *ops;
>>> +	int ret;
>>>    	if (!(req->ctx->flags & IORING_SETUP_BPF))
>>>    		return -EACCES;
>>> +	if (uring_bpf_get_flags(op_flags))
>>> +		return -EINVAL;
>>> +
>>>    	data->opf = op_flags;
>>>    	ops = &bpf_ops[uring_bpf_get_op(data->opf)];
>>> +	/* Prepare buffers based on buffer type flags */
>>> +	ret = io_bpf_prep_buffers(req, sqe, data, op_flags);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>>    	if (ops->prep_fn)
>>>    		return ops->prep_fn(data, sqe);
>>>    	return -EOPNOTSUPP;
>>> diff --git a/io_uring/uring_bpf.h b/io_uring/uring_bpf.h
>>> index c76eba887d22..c919931cb4b0 100644
>>> --- a/io_uring/uring_bpf.h
>>> +++ b/io_uring/uring_bpf.h
>>> @@ -7,8 +7,18 @@ struct uring_bpf_data {
>>>    	struct file     *file;
>>>    	u32		opf;
>>> +	/* Buffer 1 metadata - readable for bpf prog */
>>> +	u32		buf1_len;		/* buffer 1 length, bytes 12-15 */
>>> +	u64		buf1_addr;		/* buffer 1 address or offset, bytes 16-23 */
>>> +
>>> +	/* Buffer 2 metadata - readable for bpf prog (plain only) */
>>> +	u64		buf2_addr;		/* buffer 2 address, bytes 24-31 */
>>> +	u32		buf2_len;		/* buffer 2 length, bytes 32-35 */
>>> +	u32		__pad;			/* padding, bytes 36-39 */
>>
>> I'm wondering if this should be in the generic struct uring_bpf_data
>> at all. For io_uring_cmd we have helper functions like
>> io_uring_cmd_import_fixed[_vec] which can be used by the implementation,
>> but the layout on top of io_uring_cmd->pdu is up to the
>> specific operation.
> 
> Actually all above are not necessary, I plan to remove all in V2 because
> data can be passed via arena map easily & efficiently, and all kinds of
> buffer(plain user, fixed, vectored, fixed vectored) handing can leave to
> kfunc.

Ok, I guess I can learn a lot from the next version and its
examples :-)

>> Thinking about it, I'm wondering if the bpf operations
>> could be implemented on top of io_uring_cmd.
> 
> It could be one mess for uring_cmd which should focus on in-tree kernel
> users, not see obvious benefit, IMO.

Yes, I'm not saying we should do it, only that it would be possible...

metze

