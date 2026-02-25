Return-Path: <io-uring+bounces-12421-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EEqAAjE4n2m5ZQQAu9opvQ
	(envelope-from <io-uring+bounces-12421-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 18:58:09 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C43D19BE17
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 18:58:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8C26930B4D63
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 17:55:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C78483E95AA;
	Wed, 25 Feb 2026 17:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="Na0MzCD+";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ZCwJ4s/Y"
X-Original-To: io-uring@vger.kernel.org
Received: from flow-b5-smtp.messagingengine.com (flow-b5-smtp.messagingengine.com [202.12.124.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768F43E8C5F;
	Wed, 25 Feb 2026 17:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772042156; cv=none; b=QCBPmSxpc08b1Ra2fEGN7TeeDq/j6Vb5yM/ZIEsfN3t95GsN2JReTt1OJskg0XvhYBgaZygYRPxZ7t2FLYXAVTjqOkpIM76hFfQu8gC8Mem0f7+wG3eLrWvmGHAJ6elIBVhR5KboKODmC0BUR9z/qhHi2fk9xSnB6AxlaQpxjCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772042156; c=relaxed/simple;
	bh=uD38oTLlNjkN+C8HXx+cxZIej0i76KhNKKPpNtVruM0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=quCrHZL8dvRCHEd3650e3FMvsqOnvMcWOF/NyJMEs5D8X4PljPFZaVvEFy9/58DkOD04o4LDv6MnGgQ+/aAXkobpn5lF2puIkQxe1ZZtc7pU30e85J2fLRprY2GRlrO7yfSDaMR+F5lXsJuwsLW9KB7Pp3QTgOoRelmCCpJlztU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=Na0MzCD+; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ZCwJ4s/Y; arc=none smtp.client-ip=202.12.124.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id 59BF21301D54;
	Wed, 25 Feb 2026 12:55:53 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Wed, 25 Feb 2026 12:55:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1772042153;
	 x=1772049353; bh=OBq61eNWm8i0gU3MCHpLLdiMq8xxkjMq6L/+4+spvmE=; b=
	Na0MzCD+GXVlx6rb8hl6pxPOA2z5zAcAINymjS9WERo2thjTXBS3HDUeugDijJC6
	vrhipebzdFm4J3UilGuepiR9J4xphef3Zdh4r9lVncyl/V8428YwAlumPQdfA5G5
	g6vlbTF3HZ/HRmk/d7BqXtV6rm3Z5RWmyShb77386KaQVWE28bgtDrLbHWfJidfY
	uk40S/XBKLcGAUCvqq/+5hRhnRdxDCZGPOJaokHrFB8TamBB1ZY6Xlh1G3PE8RQ7
	6ombUYvsj/hwlHJ6H1oO31x/mPgnVRLlDYoH/Y0OUUMtlnc1tLbN1Qlya0bS5RU8
	wYiN2QVjR20kGEDlJODFXg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1772042153; x=
	1772049353; bh=OBq61eNWm8i0gU3MCHpLLdiMq8xxkjMq6L/+4+spvmE=; b=Z
	CwJ4s/YYHS6v5tDUtRpIs5+JchxtNxU8nQ+Y+hwcqDA+Trad2LDQ94ee7Bsoh4Ir
	nFUK5OWUGt1rcxwNaLFsYLuPlSCDi6BGDfZZqMADTat0nwT4gCAkNFm11Ojn9vSK
	1xN6siuaTD/RH+u8eB5UjrH0pK/kZgsF9yfEUH8EsHwBPknnM+nzbuJALUnTLls+
	EVSUKWwtBFvwB3A6mCAmy8IPUjzM9hEcfMbZEmofu2Yz93rabBtAOicEL3rzzLrG
	CRxtOgnHlW4VxFkPnjqiXscILo6V36FNVmQi7p+AwuT3PzTyQP9bSB0CVy9qPWe4
	7HzaqgacI1dAmvk/1pf1g==
X-ME-Sender: <xms:qDefaSDzDmG_cD8EUpRjXS6g-gBKs2dyEM6PdKoDZAjlwjm8xnJ7eg>
    <xme:qDefaflFwdMTXFhYi5KbpiTYJftSV5ZgAEr_C9xqFECFVfrnFnlCYL6zYCmVo_x6g
    eAtaGBgrUEr1zVVMjaiebZ7MuPnXIUbEjHLvPOEEIyDtWocmlE>
X-ME-Received: <xmr:qDefaQNZ0pnhHHGzksa0NTQdz32YR15zi3xfC5zDgfNiij5MtiUqfZJT0m-vELGrZSXA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeefjeehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffhvfevfhgjtgfgsehtjeertddtvdejnecuhfhrohhmpeeuvghrnhgu
    ucfutghhuhgsvghrthcuoegsvghrnhgusegsshgsvghrnhgurdgtohhmqeenucggtffrrg
    htthgvrhhnpeelleegudduueffuddvteegffehudeuieffledtudehkeehffegteegfeeh
    vedtteenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    gsvghrnhgusegsshgsvghrnhgurdgtohhmpdhnsggprhgtphhtthhopedutddpmhhouggv
    pehsmhhtphhouhhtpdhrtghpthhtohepjhhorghnnhgvlhhkohhonhhgsehgmhgrihhlrd
    gtohhmpdhrtghpthhtoheprgigsghovgeskhgvrhhnvghlrdgukhdprhgtphhtthhopehm
    ihhklhhoshesshiivghrvgguihdrhhhupdhrtghpthhtoheptghsrghnuggvrhesphhurh
    gvshhtohhrrghgvgdrtghomhdprhgtphhtthhopehkrhhishhmrghnsehsuhhsvgdruggv
    pdhrtghpthhtohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheprghsmhhlrdhsihhlvghntggvsehgmhgrihhlrdgtohhmpdhrtghpthhtohep
    gihirghosghinhhgrdhlihesshgrmhhsuhhnghdrtghomhdprhgtphhtthhopehsrghfih
    hnrghskhgrrhesghhmrghilhdrtghomh
X-ME-Proxy: <xmx:qDefac8PT_zmggksGk-7v1FA8HlF0JmjPt2VkoyfCRXDGJCsd28ADw>
    <xmx:qDefaSEech5AcAaFE-ENn2a0XyJp49ZfF1CCxOrwTdfTGzVFnkDTKA>
    <xmx:qDefabiKhqTQxs9rJaVT-jAn1OK8tQvmSke-SHFzdaCe8npziWhEAA>
    <xmx:qDefaXsiBensS82qS-qvWrhep1iXWNF0yFFmlC6MtUVMFQBrStelRA>
    <xmx:qTefadMxRNBBvPP_S0R1k5Hex4bHbUPF8H-whBW8TD29Ph53et8RF8W4>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Feb 2026 12:55:47 -0500 (EST)
Message-ID: <7ccf7574-42d4-4094-9b84-eb223e73188e@bsbernd.com>
Date: Wed, 25 Feb 2026 18:55:44 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 19/25] fuse: add io-uring kernel-managed buffer ring
From: Bernd Schubert <bernd@bsbernd.com>
To: Joanne Koong <joannelkoong@gmail.com>, axboe@kernel.dk, miklos@szeredi.hu
Cc: csander@purestorage.com, krisman@suse.de, io-uring@vger.kernel.org,
 asml.silence@gmail.com, xiaobing.li@samsung.com, safinaskar@gmail.com,
 linux-fsdevel@vger.kernel.org
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
 <20260116233044.1532965-20-joannelkoong@gmail.com>
 <2f14fb1a-0ee2-4d86-98be-ed6112ed706d@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <2f14fb1a-0ee2-4d86-98be-ed6112ed706d@bsbernd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[bsbernd.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[bsbernd.com:s=fm2,messagingengine.com:s=fm3];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[purestorage.com,suse.de,vger.kernel.org,gmail.com,samsung.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com,kernel.dk,szeredi.hu];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12421-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[bsbernd.com:+,messagingengine.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bernd@bsbernd.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.997];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,messagingengine.com:dkim]
X-Rspamd-Queue-Id: 5C43D19BE17
X-Rspamd-Action: no action



On 1/28/26 22:44, Bernd Schubert wrote:
> 
> 
> On 1/17/26 00:30, Joanne Koong wrote:
>> Add io-uring kernel-managed buffer ring capability for fuse daemons
>> communicating through the io-uring interface.
>>
>> This has two benefits:
>> a) eliminates the overhead of pinning/unpinning user pages and
>> translating virtual addresses for every server-kernel interaction
>>
>> b) reduces the amount of memory needed for the buffers per queue and
>> allows buffers to be reused across entries. Incremental buffer
>> consumption, when added, will allow a buffer to be used across multiple
>> requests.
>>
>> Buffer ring usage is set on a per-queue basis. In order to use this, the
>> daemon needs to have preregistered a kernel-managed buffer ring and a
>> fixed buffer at index 0 that will hold all the headers, and set the
>> "use_bufring" field during registration. The kernel-managed buffer ring
>> will be pinned for the lifetime of the connection.
>>
>> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
>> ---
>>  fs/fuse/dev_uring.c       | 412 ++++++++++++++++++++++++++++++++------
>>  fs/fuse/dev_uring_i.h     |  31 ++-
>>  include/uapi/linux/fuse.h |  15 +-
>>  3 files changed, 389 insertions(+), 69 deletions(-)
>>
>> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
>> index b57871f92d08..40e8c2e6b77c 100644
>> --- a/fs/fuse/dev_uring.c
>> +++ b/fs/fuse/dev_uring.c
>> @@ -10,6 +10,8 @@
>>  #include "fuse_trace.h"
>>  
>>  #include <linux/fs.h>
>> +#include <linux/io_uring.h>
>> +#include <linux/io_uring/buf.h>
>>  #include <linux/io_uring/cmd.h>
>>  
>>  static bool __read_mostly enable_uring;
>> @@ -19,6 +21,8 @@ MODULE_PARM_DESC(enable_uring,
>>  
>>  #define FUSE_URING_IOV_SEGS 2 /* header and payload */
>>  
>> +#define FUSE_URING_RINGBUF_GROUP 0
>> +#define FUSE_URING_FIXED_HEADERS_OFFSET 0
>>  
>>  bool fuse_uring_enabled(void)
>>  {
>> @@ -276,20 +280,45 @@ static struct fuse_ring *fuse_uring_create(struct fuse_conn *fc)
>>  	return res;
>>  }
>>  
>> -static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
>> -						       int qid)
>> +static int fuse_uring_buf_ring_setup(struct io_uring_cmd *cmd,
>> +				     struct fuse_ring_queue *queue,
>> +				     unsigned int issue_flags)
>> +{
>> +	int err;
>> +
>> +	err = io_uring_buf_ring_pin(cmd, FUSE_URING_RINGBUF_GROUP, issue_flags,
>> +				    &queue->bufring);
>> +	if (err)
>> +		return err;
>> +
>> +	if (!io_uring_is_kmbuf_ring(cmd, FUSE_URING_RINGBUF_GROUP,
>> +				    issue_flags)) {
>> +		io_uring_buf_ring_unpin(cmd, FUSE_URING_RINGBUF_GROUP,
>> +					issue_flags);
>> +		return -EINVAL;
>> +	}
>> +
>> +	queue->use_bufring = true;
>> +
>> +	return 0;
>> +}
>> +
>> +static struct fuse_ring_queue *
>> +fuse_uring_create_queue(struct io_uring_cmd *cmd, struct fuse_ring *ring,
>> +			int qid, bool use_bufring, unsigned int issue_flags)
>>  {
>>  	struct fuse_conn *fc = ring->fc;
>>  	struct fuse_ring_queue *queue;
>>  	struct list_head *pq;
>> +	int err;
>>  
>>  	queue = kzalloc(sizeof(*queue), GFP_KERNEL_ACCOUNT);
>>  	if (!queue)
>> -		return NULL;
>> +		return ERR_PTR(-ENOMEM);
>>  	pq = kcalloc(FUSE_PQ_HASH_SIZE, sizeof(struct list_head), GFP_KERNEL);
>>  	if (!pq) {
>>  		kfree(queue);
>> -		return NULL;
>> +		return ERR_PTR(-ENOMEM);
>>  	}
>>  
>>  	queue->qid = qid;
>> @@ -307,6 +336,15 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
>>  	queue->fpq.processing = pq;
>>  	fuse_pqueue_init(&queue->fpq);
>>  
>> +	if (use_bufring) {
>> +		err = fuse_uring_buf_ring_setup(cmd, queue, issue_flags);
>> +		if (err) {
>> +			kfree(pq);
>> +			kfree(queue);
>> +			return ERR_PTR(err);
>> +		}
>> +	}
>> +
>>  	spin_lock(&fc->lock);
>>  	if (ring->queues[qid]) {
>>  		spin_unlock(&fc->lock);
>> @@ -584,6 +622,35 @@ static int fuse_uring_out_header_has_err(struct fuse_out_header *oh,
>>  	return err;
>>  }
>>  
>> +static int get_kernel_ring_header(struct fuse_ring_ent *ent,
>> +				  enum fuse_uring_header_type type,
>> +				  struct iov_iter *headers_iter)
>> +{
>> +	size_t offset;
>> +
>> +	switch (type) {
>> +	case FUSE_URING_HEADER_IN_OUT:
>> +		/* No offset - start of header */
>> +		offset = 0;
>> +		break;
>> +	case FUSE_URING_HEADER_OP:
>> +		offset = offsetof(struct fuse_uring_req_header, op_in);
>> +		break;
>> +	case FUSE_URING_HEADER_RING_ENT:
>> +		offset = offsetof(struct fuse_uring_req_header, ring_ent_in_out);
>> +		break;
>> +	default:
>> +		WARN_ONCE(1, "Invalid header type: %d\n", type);
>> +		return -EINVAL;
>> +	}
>> +
>> +	*headers_iter = ent->headers_iter;
>> +	if (offset)
>> +		iov_iter_advance(headers_iter, offset);
>> +
>> +	return 0;
>> +}
>> +
>>  static void __user *get_user_ring_header(struct fuse_ring_ent *ent,
>>  					 enum fuse_uring_header_type type)
>>  {
>> @@ -605,17 +672,38 @@ static __always_inline int copy_header_to_ring(struct fuse_ring_ent *ent,
>>  					       const void *header,
>>  					       size_t header_size)
>>  {
>> -	void __user *ring = get_user_ring_header(ent, type);
>> +	bool use_bufring = ent->queue->use_bufring;
>> +	int err = 0;
>>  
>> -	if (!ring)
>> -		return -EINVAL;
>> +	if (use_bufring) {
>> +		struct iov_iter iter;
>> +
>> +		err =  get_kernel_ring_header(ent, type, &iter);
>> +		if (err)
>> +			goto done;
>> +
>> +		if (copy_to_iter(header, header_size, &iter) != header_size)
>> +			err = -EFAULT;
>> +	} else {
>> +		void __user *ring = get_user_ring_header(ent, type);
>> +
>> +		if (!ring) {
>> +			err = -EINVAL;
>> +			goto done;
>> +		}
>>  
>> -	if (copy_to_user(ring, header, header_size)) {
>> -		pr_info_ratelimited("Copying header to ring failed.\n");
>> -		return -EFAULT;
>> +		if (copy_to_user(ring, header, header_size))
>> +			err = -EFAULT;
>>  	}
>>  
>> -	return 0;
>> +done:
>> +	if (err)
>> +		pr_info_ratelimited("Copying header to ring failed: "
>> +				    "header_type=%u, header_size=%zu, "
>> +				    "use_bufring=%d\n", type, header_size,
>> +				    use_bufring);
>> +
>> +	return err;
>>  }
>>  
>>  static __always_inline int copy_header_from_ring(struct fuse_ring_ent *ent,
>> @@ -623,17 +711,38 @@ static __always_inline int copy_header_from_ring(struct fuse_ring_ent *ent,
>>  						 void *header,
>>  						 size_t header_size)
>>  {
>> -	const void __user *ring = get_user_ring_header(ent, type);
>> +	bool use_bufring = ent->queue->use_bufring;
>> +	int err = 0;
>>  
>> -	if (!ring)
>> -		return -EINVAL;
>> +	if (use_bufring) {
>> +		struct iov_iter iter;
>> +
>> +		err = get_kernel_ring_header(ent, type, &iter);
>> +		if (err)
>> +			goto done;
>> +
>> +		if (copy_from_iter(header, header_size, &iter) != header_size)
>> +			err = -EFAULT;
>> +	} else {
>> +		const void __user *ring = get_user_ring_header(ent, type);
>>  
>> -	if (copy_from_user(header, ring, header_size)) {
>> -		pr_info_ratelimited("Copying header from ring failed.\n");
>> -		return -EFAULT;
>> +		if (!ring) {
>> +			err = -EINVAL;
>> +			goto done;
>> +		}
>> +
>> +		if (copy_from_user(header, ring, header_size))
>> +			err = -EFAULT;
>>  	}
>>  
>> -	return 0;
>> +done:
>> +	if (err)
>> +		pr_info_ratelimited("Copying header from ring failed: "
>> +				    "header_type=%u, header_size=%zu, "
>> +				    "use_bufring=%d\n", type, header_size,
>> +				    use_bufring);
>> +
>> +	return err;
>>  }
>>  
>>  static int setup_fuse_copy_state(struct fuse_copy_state *cs,
>> @@ -643,14 +752,23 @@ static int setup_fuse_copy_state(struct fuse_copy_state *cs,
>>  {
>>  	int err;
>>  
>> -	err = import_ubuf(dir, ent->payload, ring->max_payload_sz, iter);
>> -	if (err) {
>> -		pr_info_ratelimited("fuse: Import of user buffer failed\n");
>> -		return err;
>> +	if (!ent->queue->use_bufring) {
>> +		err = import_ubuf(dir, ent->payload, ring->max_payload_sz, iter);
>> +		if (err) {
>> +			pr_info_ratelimited("fuse: Import of user buffer "
>> +					    "failed\n");
>> +			return err;
>> +		}
>>  	}
>>  
>>  	fuse_copy_init(cs, dir == ITER_DEST, iter);
>>  
>> +	if (ent->queue->use_bufring) {
>> +		cs->is_kaddr = true;
>> +		cs->len = ent->payload_kvec.iov_len;
>> +		cs->kaddr = ent->payload_kvec.iov_base;
>> +	}
>> +
>>  	cs->is_uring = true;
>>  	cs->req = req;
>>  
>> @@ -762,6 +880,94 @@ static int fuse_uring_copy_to_ring(struct fuse_ring_ent *ent,
>>  				   sizeof(req->in.h));
>>  }
>>  
>> +static bool fuse_uring_req_has_payload(struct fuse_req *req)
>> +{
>> +	struct fuse_args *args = req->args;
>> +
>> +	return args->in_numargs > 1 || args->out_numargs;
>> +}
>> +
>> +static int fuse_uring_select_buffer(struct fuse_ring_ent *ent,
>> +				    unsigned int issue_flags)
>> +	__must_hold(&queue->lock)
>> +{
>> +	struct io_br_sel sel;
>> +	size_t len = 0;
>> +
>> +	lockdep_assert_held(&ent->queue->lock);
>> +
>> +	/* Get a buffer to use for the payload */
>> +	sel = io_ring_buffer_select(cmd_to_io_kiocb(ent->cmd), &len,
>> +				    ent->queue->bufring, issue_flags);
>> +	if (sel.val)
>> +		return sel.val;
>> +	if (!sel.kaddr)
>> +		return -ENOENT;
>> +
>> +	ent->payload_kvec.iov_base = sel.kaddr;
>> +	ent->payload_kvec.iov_len = len;
>> +	ent->ringbuf_buf_id = sel.buf_id;
>> +
>> +	return 0;
>> +}
>> +
>> +static void fuse_uring_clean_up_buffer(struct fuse_ring_ent *ent,
>> +				       unsigned int issue_flags)
>> +	__must_hold(&queue->lock)
>> +{
>> +	struct kvec *kvec = &ent->payload_kvec;
>> +
>> +	lockdep_assert_held(&ent->queue->lock);
>> +
>> +	if (!ent->queue->use_bufring || !kvec->iov_base)
>> +		return;
>> +
>> +	WARN_ON_ONCE(io_uring_kmbuf_recycle(ent->cmd, FUSE_URING_RINGBUF_GROUP,
>> +					    (u64)kvec->iov_base, kvec->iov_len,
>> +					    ent->ringbuf_buf_id, issue_flags));
>> +
>> +	memset(kvec, 0, sizeof(*kvec));
>> +}
>> +
>> +static int fuse_uring_next_req_update_buffer(struct fuse_ring_ent *ent,
>> +					     struct fuse_req *req,
>> +					     unsigned int issue_flags)
>> +{
>> +	bool buffer_selected;
>> +	bool has_payload;
>> +
>> +	if (!ent->queue->use_bufring)
>> +		return 0;
>> +
>> +	ent->headers_iter.data_source = false;
>> +
>> +	buffer_selected = ent->payload_kvec.iov_base != NULL;
>> +	has_payload = fuse_uring_req_has_payload(req);
>> +
>> +	if (has_payload && !buffer_selected)
>> +		return fuse_uring_select_buffer(ent, issue_flags);
>> +
>> +	if (!has_payload && buffer_selected)
>> +		fuse_uring_clean_up_buffer(ent, issue_flags);
>> +
>> +	return 0;
>> +}
>> +
>> +static int fuse_uring_prep_buffer(struct fuse_ring_ent *ent,
>> +				  struct fuse_req *req, unsigned issue_flags)
>> +{
>> +	if (!ent->queue->use_bufring)
>> +		return 0;
>> +
>> +	ent->headers_iter.data_source = false;
>> +
>> +	/* no payload to copy, can skip selecting a buffer */
>> +	if (!fuse_uring_req_has_payload(req))
>> +		return 0;
>> +
>> +	return fuse_uring_select_buffer(ent, issue_flags);
>> +}
>> +
>>  static int fuse_uring_prepare_send(struct fuse_ring_ent *ent,
>>  				   struct fuse_req *req)
>>  {
>> @@ -824,21 +1030,29 @@ static void fuse_uring_add_req_to_ring_ent(struct fuse_ring_ent *ent,
>>  }
>>  
>>  /* Fetch the next fuse request if available */
>> -static struct fuse_req *fuse_uring_ent_assign_req(struct fuse_ring_ent *ent)
>> +static struct fuse_req *fuse_uring_ent_assign_req(struct fuse_ring_ent *ent,
>> +						  unsigned int issue_flags)
>>  	__must_hold(&queue->lock)
>>  {
>>  	struct fuse_req *req;
>>  	struct fuse_ring_queue *queue = ent->queue;
>>  	struct list_head *req_queue = &queue->fuse_req_queue;
>> +	int err;
>>  
>>  	lockdep_assert_held(&queue->lock);
>>  
>>  	/* get and assign the next entry while it is still holding the lock */
>>  	req = list_first_entry_or_null(req_queue, struct fuse_req, list);
>> -	if (req)
>> -		fuse_uring_add_req_to_ring_ent(ent, req);
>> +	if (req) {
>> +		err = fuse_uring_next_req_update_buffer(ent, req, issue_flags);
>> +		if (!err) {
>> +			fuse_uring_add_req_to_ring_ent(ent, req);
>> +			return req;
>> +		}
>> +	}
>>  
>> -	return req;
>> +	fuse_uring_clean_up_buffer(ent, issue_flags);
>> +	return NULL;
>>  }
>>  
>>  /*
>> @@ -878,7 +1092,8 @@ static void fuse_uring_commit(struct fuse_ring_ent *ent, struct fuse_req *req,
>>   * Else, there is no next fuse request and this returns false.
>>   */
>>  static bool fuse_uring_get_next_fuse_req(struct fuse_ring_ent *ent,
>> -					 struct fuse_ring_queue *queue)
>> +					 struct fuse_ring_queue *queue,
>> +					 unsigned int issue_flags)
>>  {
>>  	int err;
>>  	struct fuse_req *req;
>> @@ -886,7 +1101,7 @@ static bool fuse_uring_get_next_fuse_req(struct fuse_ring_ent *ent,
>>  retry:
>>  	spin_lock(&queue->lock);
>>  	fuse_uring_ent_avail(ent, queue);
>> -	req = fuse_uring_ent_assign_req(ent);
>> +	req = fuse_uring_ent_assign_req(ent, issue_flags);
>>  	spin_unlock(&queue->lock);
>>  
>>  	if (req) {
>> @@ -927,6 +1142,39 @@ static void fuse_uring_send(struct fuse_ring_ent *ent, struct io_uring_cmd *cmd,
>>  	io_uring_cmd_done(cmd, ret, issue_flags);
>>  }
>>  
>> +static void fuse_uring_headers_cleanup(struct fuse_ring_ent *ent,
>> +				       unsigned int issue_flags)
>> +{
>> +	if (!ent->queue->use_bufring || !ent->headers_node)
>> +		return;
>> +
>> +	io_uring_fixed_index_put(ent->cmd, ent->headers_node, issue_flags);
>> +	ent->headers_node = NULL;
>> +}
>> +
>> +static int fuse_uring_headers_prep(struct fuse_ring_ent *ent, unsigned int dir,
>> +				   unsigned int issue_flags)
>> +{
>> +	size_t header_size = sizeof(struct fuse_uring_req_header);
>> +	struct io_uring_cmd *cmd = ent->cmd;
>> +	struct io_rsrc_node *node;
>> +	unsigned int offset;
>> +
>> +	if (!ent->queue->use_bufring)
>> +		return 0;
>> +
>> +	offset = ent->fixed_buf_id * header_size;
>> +
>> +	node = io_uring_fixed_index_get(cmd, FUSE_URING_FIXED_HEADERS_OFFSET,
>> +					offset, header_size, dir,
>> +					&ent->headers_iter, issue_flags);
>> +	if (IS_ERR(node))
>> +		return PTR_ERR(node);
>> +
>> +	ent->headers_node = node;
>> +	return 0;
>> +}
>> +
>>  /* FUSE_URING_CMD_COMMIT_AND_FETCH handler */
>>  static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
>>  				   struct fuse_conn *fc)
>> @@ -940,6 +1188,7 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
>>  	unsigned int qid = READ_ONCE(cmd_req->qid);
>>  	struct fuse_pqueue *fpq;
>>  	struct fuse_req *req;
>> +	bool send;
>>  
>>  	err = -ENOTCONN;
>>  	if (!ring)
>> @@ -990,7 +1239,12 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
>>  
>>  	/* without the queue lock, as other locks are taken */
>>  	fuse_uring_prepare_cancel(cmd, issue_flags, ent);
>> -	fuse_uring_commit(ent, req, issue_flags);
>> +
>> +	err = fuse_uring_headers_prep(ent, ITER_SOURCE, issue_flags);
>> +	if (err)
>> +		fuse_uring_req_end(ent, req, err);
>> +	else
>> +		fuse_uring_commit(ent, req, issue_flags);
>>  
>>  	/*
>>  	 * Fetching the next request is absolutely required as queued
>> @@ -998,7 +1252,9 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
>>  	 * and fetching is done in one step vs legacy fuse, which has separated
>>  	 * read (fetch request) and write (commit result).
>>  	 */
>> -	if (fuse_uring_get_next_fuse_req(ent, queue))
>> +	send = fuse_uring_get_next_fuse_req(ent, queue, issue_flags);
>> +	fuse_uring_headers_cleanup(ent, issue_flags);
>> +	if (send)
>>  		fuse_uring_send(ent, cmd, 0, issue_flags);
>>  	return 0;


Hello Joanne,

couldn't it call fuse_uring_headers_cleanup() before the
fuse_uring_get_next_fuse_req()? I find it a bit confusing that it firsts
gets the next request and then cleans up the buffer from the previous
request.

As I understand it, the the patch basically adds the feature of 0-byte
payloads. Maybe worth mentioning in the commit message?
I also wonder if it would be worth to document as code comment that
fuse_uring_ent_assign_req / fuse_uring_next_req_update_buffer are
allowed to fail for a buffer upgrade (i.e. 0 to max-payload). At least
the current comment of  "Fetching the next request is absolutely
required" is actually not entirely true anymore.


Thanks,
Bernd

