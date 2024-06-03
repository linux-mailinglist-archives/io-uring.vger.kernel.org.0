Return-Path: <io-uring+bounces-2074-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0604A8D7E74
	for <lists+io-uring@lfdr.de>; Mon,  3 Jun 2024 11:26:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABAAA282353
	for <lists+io-uring@lfdr.de>; Mon,  3 Jun 2024 09:26:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CC35757E0;
	Mon,  3 Jun 2024 09:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BGYyrAyK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="iktIf95i";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="CRtM5bSS";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9mUkp0gi"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110BF7E578;
	Mon,  3 Jun 2024 09:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717406812; cv=none; b=rzXNYOkdDUAo6fXOjh6m+EHX2vV0NkWWjimgp+kKUgYxOgZbCwbMcqaXyk3ig78MIY0ilUnLPOGK6B84T8vYZtq76rSaYWBBXmif/FtrgGuXDbL5t8NN8HQXUPonQcYQ1IQzDRPwxTXnjlmCxWo9Htf5PjYCY4D22jzm+eEDDj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717406812; c=relaxed/simple;
	bh=bIKgTHqqqvNrDn6N46S23oj6Yn8jnVRBUOsZYqWHjnw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wlx6gu8HpMWFQOzBAsqRg0bdtgEsEQ9SbTRldbFekVCAnY/y5BcDh6yq3+7SYmuf5Ab8s7CiEVt7dvUFBV4RNVz8QOZe0ja5l45F5csuwcWexciwJhTNcrPlhE118YGzOc0s0ja/9o6GJuat9e4MCwNh3NlLRqIKq9zFEtLb85I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BGYyrAyK; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=iktIf95i; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=CRtM5bSS; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9mUkp0gi; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 334982001E;
	Mon,  3 Jun 2024 09:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717406808; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4aiqyGNs4C6F+459GE4XKKIaj4uHNvODVh4oeUc9YQQ=;
	b=BGYyrAyKVIVppKuFCDEVCQqAMX3+cbzScFb/SmBJE9FsafW60ImLURzecJUbtPj+EU7qd8
	vkq4XUehN2UOcypeE0ZIW3SwVrqNvJkuFLsuidqJkFvs2knxu+BkLv8kGMMdFOSkNAzf3A
	W2x/xbKWNR8AJMYK3ikPiqMJa72a2J4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717406808;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4aiqyGNs4C6F+459GE4XKKIaj4uHNvODVh4oeUc9YQQ=;
	b=iktIf95ibTh8suh83mbxhsmIwD12npaRJTO3Tel2NYrJdwhvuYQHA99L7p0fgRdDp4/Ue3
	/wbV33bFzYZ0bKDQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717406807; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4aiqyGNs4C6F+459GE4XKKIaj4uHNvODVh4oeUc9YQQ=;
	b=CRtM5bSS3vtA1ctSrWW37O8hx39qarpl0KB1WdfR/cytUAB0x98GLtGwsoz+3wXsVXoPqy
	sHrlAnlhuzPNMByAZ3blK6KTukZacSrncVwhgoQrfUB+EccNBhJIHpz+SdqGrF7ENHIjCL
	6XcUDj4wpXXKqHZg8ERCUkXHhrKSxSE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717406807;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4aiqyGNs4C6F+459GE4XKKIaj4uHNvODVh4oeUc9YQQ=;
	b=9mUkp0giwL7NhJ1jtx4OC9TvCHau/UID+Bkr+jBA9/Q8H2t9tKpcl4lk0QMUm26ZX0arss
	4oQV6QFAonOh4hBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E3B1A139CB;
	Mon,  3 Jun 2024 09:26:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rWTdNlaMXWY6AgAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 03 Jun 2024 09:26:46 +0000
Message-ID: <749f9615-2fd2-49a3-9c9e-c725cb027ad3@suse.de>
Date: Mon, 3 Jun 2024 11:26:46 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 4/9] block: Add core atomic write support
To: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, kbusch@kernel.org,
 hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com,
 martin.petersen@oracle.com, djwong@kernel.org, viro@zeniv.linux.org.uk,
 brauner@kernel.org, dchinner@redhat.com, jack@suse.cz
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org,
 ojaswin@linux.ibm.com, linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
 io-uring@vger.kernel.org, nilay@linux.ibm.com, ritesh.list@gmail.com,
 willy@infradead.org, Himanshu Madhani <himanshu.madhani@oracle.com>
References: <20240602140912.970947-1-john.g.garry@oracle.com>
 <20240602140912.970947-5-john.g.garry@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240602140912.970947-5-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Score: -2.79
X-Spam-Level: 
X-Spamd-Result: default: False [-2.79 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[27];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.infradead.org,mit.edu,google.com,linux.ibm.com,kvack.org,gmail.com,infradead.org,oracle.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	R_RATELIMIT(0.00)[to_ip_from(RLusjj3u5c53i6g8q6enupwtij)]

On 6/2/24 16:09, John Garry wrote:
> Add atomic write support, as follows:
> - add helper functions to get request_queue atomic write limits
> - report request_queue atomic write support limits to sysfs and update Doc
> - support to safely merge atomic writes
> - deal with splitting atomic writes
> - misc helper functions
> - add a per-request atomic write flag
> 
> New request_queue limits are added, as follows:
> - atomic_write_hw_max is set by the block driver and is the maximum length
>    of an atomic write which the device may support. It is not
>    necessarily a power-of-2.
> - atomic_write_max_sectors is derived from atomic_write_hw_max_sectors and
>    max_hw_sectors. It is always a power-of-2. Atomic writes may be merged,
>    and atomic_write_max_sectors would be the limit on a merged atomic write
>    request size. This value is not capped at max_sectors, as the value in
>    max_sectors can be controlled from userspace, and it would only cause
>    trouble if userspace could limit atomic_write_unit_max_bytes and the
>    other atomic write limits.
> - atomic_write_hw_unit_{min,max} are set by the block driver and are the
>    min/max length of an atomic write unit which the device may support. They
>    both must be a power-of-2. Typically atomic_write_hw_unit_max will hold
>    the same value as atomic_write_hw_max.
> - atomic_write_unit_{min,max} are derived from
>    atomic_write_hw_unit_{min,max}, max_hw_sectors, and block core limits.
>    Both min and max values must be a power-of-2.
> - atomic_write_hw_boundary is set by the block driver. If non-zero, it
>    indicates an LBA space boundary at which an atomic write straddles no
>    longer is atomically executed by the disk. The value must be a
>    power-of-2. Note that it would be acceptable to enforce a rule that
>    atomic_write_hw_boundary_sectors is a multiple of
>    atomic_write_hw_unit_max, but the resultant code would be more
>    complicated.
> 
> All atomic writes limits are by default set 0 to indicate no atomic write
> support. Even though it is assumed by Linux that a logical block can always
> be atomically written, we ignore this as it is not of particular interest.
> Stacked devices are just not supported either for now.
> 
> An atomic write must always be submitted to the block driver as part of a
> single request. As such, only a single BIO must be submitted to the block
> layer for an atomic write. When a single atomic write BIO is submitted, it
> cannot be split. As such, atomic_write_unit_{max, min}_bytes are limited
> by the maximum guaranteed BIO size which will not be required to be split.
> This max size is calculated by request_queue max segments and the number
> of bvecs a BIO can fit, BIO_MAX_VECS. Currently we rely on userspace
> issuing a write with iovcnt=1 for pwritev2() - as such, we can rely on each
> segment containing PAGE_SIZE of data, apart from the first+last, which each
> can fit logical block size of data. The first+last will be LBS
> length/aligned as we rely on direct IO alignment rules also.
> 
> New sysfs files are added to report the following atomic write limits:
> - atomic_write_unit_max_bytes - same as atomic_write_unit_max_sectors in
> 				bytes
> - atomic_write_unit_min_bytes - same as atomic_write_unit_min_sectors in
> 				bytes
> - atomic_write_boundary_bytes - same as atomic_write_hw_boundary_sectors in
> 				bytes
> - atomic_write_max_bytes      - same as atomic_write_max_sectors in bytes
> 
> Atomic writes may only be merged with other atomic writes and only under
> the following conditions:
> - total resultant request length <= atomic_write_max_bytes
> - the merged write does not straddle a boundary
> 
> Helper function bdev_can_atomic_write() is added to indicate whether
> atomic writes may be issued to a bdev. If a bdev is a partition, the
> partition start must be aligned with both atomic_write_unit_min_sectors
> and atomic_write_hw_boundary_sectors.
> 
> FSes will rely on the block layer to validate that an atomic write BIO
> submitted will be of valid size, so add blk_validate_atomic_write_op_size()
> for this purpose. Userspace expects an atomic write which is of invalid
> size to be rejected with -EINVAL, so add BLK_STS_INVAL for this. Also use
> BLK_STS_INVAL for when a BIO needs to be split, as this should mean an
> invalid size BIO.
> 
> Flag REQ_ATOMIC is used for indicating an atomic write.
> 
> Co-developed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   Documentation/ABI/stable/sysfs-block | 53 ++++++++++++++++
>   block/blk-core.c                     | 19 ++++++
>   block/blk-merge.c                    | 95 +++++++++++++++++++++++++++-
>   block/blk-settings.c                 | 52 +++++++++++++++
>   block/blk-sysfs.c                    | 33 ++++++++++
>   block/blk.h                          |  3 +
>   include/linux/blk_types.h            |  8 ++-
>   include/linux/blkdev.h               | 54 ++++++++++++++++
>   8 files changed, 315 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/ABI/stable/sysfs-block b/Documentation/ABI/stable/sysfs-block
> index 831f19a32e08..cea8856f798d 100644
> --- a/Documentation/ABI/stable/sysfs-block
> +++ b/Documentation/ABI/stable/sysfs-block
> @@ -21,6 +21,59 @@ Description:
>   		device is offset from the internal allocation unit's
>   		natural alignment.
>   
> +What:		/sys/block/<disk>/atomic_write_max_bytes
> +Date:		February 2024
> +Contact:	Himanshu Madhani <himanshu.madhani@oracle.com>
> +Description:
> +		[RO] This parameter specifies the maximum atomic write
> +		size reported by the device. This parameter is relevant
> +		for merging of writes, where a merged atomic write
> +		operation must not exceed this number of bytes.
> +		This parameter may be greater than the value in
> +		atomic_write_unit_max_bytes as
> +		atomic_write_unit_max_bytes will be rounded down to a
> +		power-of-two and atomic_write_unit_max_bytes may also be
> +		limited by some other queue limits, such as max_segments.
> +		This parameter - along with atomic_write_unit_min_bytes
> +		and atomic_write_unit_max_bytes - will not be larger than
> +		max_hw_sectors_kb, but may be larger than max_sectors_kb.
> +
> +
> +What:		/sys/block/<disk>/atomic_write_unit_min_bytes
> +Date:		February 2024
> +Contact:	Himanshu Madhani <himanshu.madhani@oracle.com>
> +Description:
> +		[RO] This parameter specifies the smallest block which can
> +		be written atomically with an atomic write operation. All
> +		atomic write operations must begin at a
> +		atomic_write_unit_min boundary and must be multiples of
> +		atomic_write_unit_min. This value must be a power-of-two.
> +
> +
> +What:		/sys/block/<disk>/atomic_write_unit_max_bytes
> +Date:		February 2024
> +Contact:	Himanshu Madhani <himanshu.madhani@oracle.com>
> +Description:
> +		[RO] This parameter defines the largest block which can be
> +		written atomically with an atomic write operation. This
> +		value must be a multiple of atomic_write_unit_min and must
> +		be a power-of-two. This value will not be larger than
> +		atomic_write_max_bytes.
> +
> +
> +What:		/sys/block/<disk>/atomic_write_boundary_bytes
> +Date:		February 2024
> +Contact:	Himanshu Madhani <himanshu.madhani@oracle.com>
> +Description:
> +		[RO] A device may need to internally split an atomic write I/O
> +		which straddles a given logical block address boundary. This
> +		parameter specifies the size in bytes of the atomic boundary if
> +		one is reported by the device. This value must be a
> +		power-of-two and at least the size as in
> +		atomic_write_unit_max_bytes.
> +		Any attempt to merge atomic write I/Os must not result in a
> +		merged I/O which crosses this boundary (if any).
> +
>   
>   What:		/sys/block/<disk>/diskseq
>   Date:		February 2021
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 82c3ae22d76d..d9f58fe71758 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -174,6 +174,8 @@ static const struct {
>   	/* Command duration limit device-side timeout */
>   	[BLK_STS_DURATION_LIMIT]	= { -ETIME, "duration limit exceeded" },
>   
> +	[BLK_STS_INVAL]		= { -EINVAL,	"invalid" },
> +
>   	/* everything else not covered above: */
>   	[BLK_STS_IOERR]		= { -EIO,	"I/O" },
>   };
> @@ -739,6 +741,18 @@ void submit_bio_noacct_nocheck(struct bio *bio)
>   		__submit_bio_noacct(bio);
>   }
>   
> +static blk_status_t blk_validate_atomic_write_op_size(struct request_queue *q,
> +						 struct bio *bio)
> +{
> +	if (bio->bi_iter.bi_size > queue_atomic_write_unit_max_bytes(q))
> +		return BLK_STS_INVAL;
> +
> +	if (bio->bi_iter.bi_size % queue_atomic_write_unit_min_bytes(q))
> +		return BLK_STS_INVAL;
> +
> +	return BLK_STS_OK;
> +}
> +
>   /**
>    * submit_bio_noacct - re-submit a bio to the block device layer for I/O
>    * @bio:  The bio describing the location in memory and on the device.
> @@ -797,6 +811,11 @@ void submit_bio_noacct(struct bio *bio)
>   	switch (bio_op(bio)) {
>   	case REQ_OP_READ:
>   	case REQ_OP_WRITE:
> +		if (bio->bi_opf & REQ_ATOMIC) {
> +			status = blk_validate_atomic_write_op_size(q, bio);
> +			if (status != BLK_STS_OK)
> +				goto end_io;
> +		}
>   		break;
>   	case REQ_OP_FLUSH:
>   		/*
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index 8957e08e020c..ad07759ca147 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -18,6 +18,46 @@
>   #include "blk-rq-qos.h"
>   #include "blk-throttle.h"
>   
> +/*
> + * rq_straddles_atomic_write_boundary - check for boundary violation
> + * @rq: request to check
> + * @front: data size to be appended to front
> + * @back: data size to be appended to back
> + *
> + * Determine whether merging a request or bio into another request will result
> + * in a merged request which straddles an atomic write boundary.
> + *
> + * The value @front_adjust is the data which would be appended to the front of
> + * @rq, while the value @back_adjust is the data which would be appended to the
> + * back of @rq. Callers will typically only have either @front_adjust or
> + * @back_adjust as non-zero.
> + *
> + */
> +static bool rq_straddles_atomic_write_boundary(struct request *rq,
> +					unsigned int front_adjust,
> +					unsigned int back_adjust)
> +{
> +	unsigned int boundary = queue_atomic_write_boundary_bytes(rq->q);
> +	u64 mask, start_rq_pos, end_rq_pos;
> +
> +	if (!boundary)
> +		return false;
> +
> +	start_rq_pos = blk_rq_pos(rq) << SECTOR_SHIFT;
> +	end_rq_pos = start_rq_pos + blk_rq_bytes(rq) - 1;
> +
> +	start_rq_pos -= front_adjust;
> +	end_rq_pos += back_adjust;
> +
> +	mask = ~(boundary - 1);
> +
> +	/* Top bits are different, so crossed a boundary */
> +	if ((start_rq_pos & mask) != (end_rq_pos & mask))
> +		return true;
> +
> +	return false;
> +}

But isn't that precisely what 'chunk_sectors' is doing?
IE ensuring that requests never cross that boundary?

Q1: Shouldn't we rather use/modify/adapt chunk_sectors for this thing?
Q2: If we don't, shouldn't we align the atomic write boundary to the 
chunk_sectors setting to ensure both match up?

Cheers,

Hannes


