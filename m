Return-Path: <io-uring+bounces-650-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4044C85AF47
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 23:59:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 99F68B22394
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 22:59:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66ABD56B67;
	Mon, 19 Feb 2024 22:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="IrbhwGQd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA0154FA7
	for <io-uring@vger.kernel.org>; Mon, 19 Feb 2024 22:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708383526; cv=none; b=OQXM8oOVPmu5v1GKgSxyh2/MbjTXj7mbPseis3FhjvElaBqzM4QmK32NHAAqVQLgX3gyrTt88Uqtm5ZM8OffXkc8D/blzj3E+7kOrw7q5H/cYw/Yss4YIilU0iXfA2bq6egvqrjvsNpRpxLPPiGB44frAAgn72ZHeqha7fwvBDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708383526; c=relaxed/simple;
	bh=2SNzo6Nm6HcU5wL9JoMRvctOw4lKDTA8DZJYggBpUos=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZcO7FKePbh2CrpqQEtXpIYMXnK7+HulDv/SIL15q8x4qTdF7Odsq+OAejJCx46Y7MJRPPz1IKStTg0P4NamDLfiwAcNohJ0WPrjMHhDLEmKme71t+FeUZrIXMbCpwGfRsuL+yp+bnCGe+CiQjRecGvM+BQvDON3Ck/BApmw809U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=IrbhwGQd; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6e08dd0fa0bso4118970b3a.1
        for <io-uring@vger.kernel.org>; Mon, 19 Feb 2024 14:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1708383522; x=1708988322; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=G2SusDOlkkZCINXkEP6RVbB2J47VRPBecZ6j24NRkMs=;
        b=IrbhwGQd+TUNReUTruXWKe7va0WBiuoxnX+sEsKPE28yTn8dzJiQmj+hIAnhV34uu7
         ZJtpzEyYXP8kr0HMS+/Efjwhu4UJuXp0tI+iH4MSXaXK35vP1K5T92CkdLzrOk7tTOWL
         gNfWCCRW1w8i8pO28muJTdxx66IddHiCNFwTWWNUMC7boNk55tGkwMgqh7q0XwbCyOr0
         oTzvsVcoWooLn+Rhjr24VKnwfWSewV0MfDwOzfB/TItTFiYJVaratRLTIexShDOh47OE
         r+WQjdXQF9c1yCi7Pxbgz5GZE402irit/i1VzQ7iidROnXBGOt0xrnssYzTMkkica29s
         NszA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708383522; x=1708988322;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G2SusDOlkkZCINXkEP6RVbB2J47VRPBecZ6j24NRkMs=;
        b=uKCPMdIcftWBaChce49hv85D6sDYxXmJgufMm5rNdqrDFCCIz2rBcX4nPaLHqmAqYU
         IuCjAeFjVI73yWXAfq6tQRMjU9KLYikA+/UNxk8WhJb+V/OAbuHLgUrHuYMaqKuC9QlA
         l2hVgkyYI/JDrInWuuvC0kMUmLPW3zqCxG6jsa33myuRqo2xBl8eZYlu3i6hS9HenkbR
         Rna8Lj59WW0YY5Qv16gcJ7SxbI9znLJaR+avqP8UfmbQBTAk5NFqHOw86AUmU0PGYU2X
         5xSDUWl0j+vilK189SmLUuujnVqeSQ0HFFDA5oRBVGjwBkRWnL7anfTs91UcXhrigaHe
         mnPw==
X-Forwarded-Encrypted: i=1; AJvYcCWQZxAmsrBT+7FTqBHG5rX9vUdSQmxJYsQCXgiCYHsj32ZKD8OWK5fUkkiCGEXflIHHi9gbbyFmZhOUavi356lJiFi7n9qnFo0=
X-Gm-Message-State: AOJu0YyO9FYCnRn572YvZ4s0i+E3seAMWuPpm8Jw/+XpUCImJZbxCBol
	wYDet+UlBLQBRfMGTJtAUjZd3qsEDWM6/fGb8R5DW4GaE08K2R3ARxWhkA5kgtM=
X-Google-Smtp-Source: AGHT+IHlfzy+s9i3qKJWzkHasWDQ5Dp8s/ZMPkMUlAlAKBlL38U+vY5Udn0W8KhJ2rlPYO9vcrxajg==
X-Received: by 2002:a05:6a00:198f:b0:6e4:74d7:a732 with SMTP id d15-20020a056a00198f00b006e474d7a732mr2108349pfl.11.1708383522593;
        Mon, 19 Feb 2024 14:58:42 -0800 (PST)
Received: from dread.disaster.area (pa49-181-247-196.pa.nsw.optusnet.com.au. [49.181.247.196])
        by smtp.gmail.com with ESMTPSA id e8-20020a62ee08000000b006e02da39dbcsm3319334pfi.10.2024.02.19.14.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 14:58:42 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rcCat-008oe1-1J;
	Tue, 20 Feb 2024 09:58:39 +1100
Date: Tue, 20 Feb 2024 09:58:39 +1100
From: Dave Chinner <david@fromorbit.com>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
	jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org,
	viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
	jack@suse.cz, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com,
	linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org, nilay@linux.ibm.com,
	ritesh.list@gmail.com
Subject: Re: [PATCH v4 05/11] block: Add core atomic write support
Message-ID: <ZdPdHzNAVb5hqlkY@dread.disaster.area>
References: <20240219130109.341523-1-john.g.garry@oracle.com>
 <20240219130109.341523-6-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240219130109.341523-6-john.g.garry@oracle.com>

On Mon, Feb 19, 2024 at 01:01:03PM +0000, John Garry wrote:
> Add atomic write support as follows:
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index 74e9e775f13d..12a75a252ca2 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -18,6 +18,42 @@
>  #include "blk-rq-qos.h"
>  #include "blk-throttle.h"
>  
> +static bool rq_straddles_atomic_write_boundary(struct request *rq,
> +					unsigned int front,
> +					unsigned int back)
> +{
> +	unsigned int boundary = queue_atomic_write_boundary_bytes(rq->q);
> +	unsigned int mask, imask;
> +	loff_t start, end;
> +
> +	if (!boundary)
> +		return false;
> +
> +	start = rq->__sector << SECTOR_SHIFT;
> +	end = start + rq->__data_len;
> +
> +	start -= front;
> +	end += back;
> +
> +	/* We're longer than the boundary, so must be crossing it */
> +	if (end - start > boundary)
> +		return true;
> +
> +	mask = boundary - 1;
> +
> +	/* start/end are boundary-aligned, so cannot be crossing */
> +	if (!(start & mask) || !(end & mask))
> +		return false;
> +
> +	imask = ~mask;
> +
> +	/* Top bits are different, so crossed a boundary */
> +	if ((start & imask) != (end & imask))
> +		return true;
> +
> +	return false;
> +}

I have no way of verifying this function is doing what it is
supposed to because it's function is undocumented. I have no idea
what the front/back variables are supposed to represent, and so no
clue if they are being applied properly.

That said, it's also applying unsigned 32 bit mask variables to
signed 64 bit quantities and trying to do things like "high bit changed"
checks on the 64 bit variable. This just smells like a future
source of "large offsets don't work like we expected!" bugs.

> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 06ea91e51b8b..176f26374abc 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -59,6 +59,13 @@ void blk_set_default_limits(struct queue_limits *lim)
>  	lim->zoned = false;
>  	lim->zone_write_granularity = 0;
>  	lim->dma_alignment = 511;
> +	lim->atomic_write_hw_max_sectors = 0;
> +	lim->atomic_write_max_sectors = 0;
> +	lim->atomic_write_hw_boundary_sectors = 0;
> +	lim->atomic_write_hw_unit_min_sectors = 0;
> +	lim->atomic_write_unit_min_sectors = 0;
> +	lim->atomic_write_hw_unit_max_sectors = 0;
> +	lim->atomic_write_unit_max_sectors = 0;
>  }

Seems to me this function would do better to just

	memset(lim, 0, sizeof(*lim));

and then set all the non-zero fields.

>  
>  /**
> @@ -101,6 +108,44 @@ void blk_queue_bounce_limit(struct request_queue *q, enum blk_bounce bounce)
>  }
>  EXPORT_SYMBOL(blk_queue_bounce_limit);
>  
> +
> +/*
> + * Returns max guaranteed sectors which we can fit in a bio. For convenience of
> + * users, rounddown_pow_of_two() the return value.
> + *
> + * We always assume that we can fit in at least PAGE_SIZE in a segment, apart
> + * from first and last segments.
> + */
> +static unsigned int blk_queue_max_guaranteed_bio_sectors(
> +					struct queue_limits *limits,
> +					struct request_queue *q)
> +{
> +	unsigned int max_segments = min(BIO_MAX_VECS, limits->max_segments);
> +	unsigned int length;
> +
> +	length = min(max_segments, 2) * queue_logical_block_size(q);
> +	if (max_segments > 2)
> +		length += (max_segments - 2) * PAGE_SIZE;
> +
> +	return rounddown_pow_of_two(length >> SECTOR_SHIFT);
> +}
> +
> +static void blk_atomic_writes_update_limits(struct request_queue *q)
> +{
> +	struct queue_limits *limits = &q->limits;
> +	unsigned int max_hw_sectors =
> +		rounddown_pow_of_two(limits->max_hw_sectors);
> +	unsigned int unit_limit = min(max_hw_sectors,
> +		blk_queue_max_guaranteed_bio_sectors(limits, q));
> +
> +	limits->atomic_write_max_sectors =
> +		min(limits->atomic_write_hw_max_sectors, max_hw_sectors);
> +	limits->atomic_write_unit_min_sectors =
> +		min(limits->atomic_write_hw_unit_min_sectors, unit_limit);
> +	limits->atomic_write_unit_max_sectors =
> +		min(limits->atomic_write_hw_unit_max_sectors, unit_limit);
> +}
> +
>  /**
>   * blk_queue_max_hw_sectors - set max sectors for a request for this queue
>   * @q:  the request queue for the device
> @@ -145,6 +190,8 @@ void blk_queue_max_hw_sectors(struct request_queue *q, unsigned int max_hw_secto
>  				 limits->logical_block_size >> SECTOR_SHIFT);
>  	limits->max_sectors = max_sectors;
>  
> +	blk_atomic_writes_update_limits(q);
> +
>  	if (!q->disk)
>  		return;
>  	q->disk->bdi->io_pages = max_sectors >> (PAGE_SHIFT - 9);
> @@ -182,6 +229,62 @@ void blk_queue_max_discard_sectors(struct request_queue *q,
>  }
>  EXPORT_SYMBOL(blk_queue_max_discard_sectors);
>  
> +/**
> + * blk_queue_atomic_write_max_bytes - set max bytes supported by
> + * the device for atomic write operations.
> + * @q:  the request queue for the device
> + * @bytes: maximum bytes supported
> + */
> +void blk_queue_atomic_write_max_bytes(struct request_queue *q,
> +				      unsigned int bytes)
> +{
> +	q->limits.atomic_write_hw_max_sectors = bytes >> SECTOR_SHIFT;
> +	blk_atomic_writes_update_limits(q);
> +}
> +EXPORT_SYMBOL(blk_queue_atomic_write_max_bytes);

Ok, so this can silently set a limit that is different to what the
caller asked to have set?

How is the caller supposed to find this out if the smaller limit
that was set is not compatible with their configuration?

i.e. shouldn't this return an error if the requested size cannot
be set exactly as specified?

Same concern about the other limits that can be trimmed to be
smaller than requested.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

