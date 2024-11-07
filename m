Return-Path: <io-uring+bounces-4536-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2A739C046E
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 12:45:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 885682834F8
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 11:45:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50AE920EA49;
	Thu,  7 Nov 2024 11:45:00 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A896E20EA3E;
	Thu,  7 Nov 2024 11:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730979900; cv=none; b=rhaotA0Y/r7FbDacd25uOBKGQIi9ukwe9ggMXwreTCnT065ezL/VWa2NNCISwLkorYCErzNnhhZen49l/6aObLGqIrvndJJngVYHQB+uXlDSFp09VISVgeqn72eBBhJIxkujK/mDA0pNjxLYYgQ4Z+MLxSq+NDdwB9SQ1XV96H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730979900; c=relaxed/simple;
	bh=/OpbqR2YxOIoxT9LA89l3XTqHM7jQEnOj4247aoH6vs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XRgra3t+ePZS56pX7+kxvnnzs764kH6BLxYMHLrdTlLX//XUgbky4w9bnnipFfgqnpz27redHtAO/+c+PjlivWKBwbhLEY3d6wdz7p9WboqZ06eyNbwOEFOJ3j/szsSkSVitSPgXcwQglwbWUEQD62dweYTSfynWZsjjk1jA328=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8C64D68B05; Thu,  7 Nov 2024 12:44:52 +0100 (CET)
Date: Thu, 7 Nov 2024 12:44:52 +0100
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Anuj gupta <anuj1072538@gmail.com>,
	axboe@kernel.dk, kbusch@kernel.org, martin.petersen@oracle.com,
	asml.silence@gmail.com, brauner@kernel.org, jack@suse.cz,
	viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, linux-fsdevel@vger.kernel.org,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v8 06/10] io_uring/rw: add support to send metadata
 along with read/write
Message-ID: <20241107114452.GA31441@lst.de>
References: <20241106121842.5004-1-anuj20.g@samsung.com> <CGME20241106122710epcas5p2b314c865f8333c890dd6f22cf2edbe2f@epcas5p2.samsung.com> <20241106121842.5004-7-anuj20.g@samsung.com> <20241107055542.GA2483@lst.de> <CACzX3As284BTyaJXbDUYeKB96Hy+JhgDXs+7qqP6Rq6sGNtEsw@mail.gmail.com> <20241107073852.GA5195@lst.de> <20241107104000.GB9730@green245>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241107104000.GB9730@green245>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +/*
> + * If sqe->ext_cap is set to this for IORING_OP_READ/WRITE, then the SQE
> + * contains protection information, and ring needs to be setup with SQE128
> + */
> +#define EXT_CAP_PI	(1U << 0)
> +
> +/* Second half of SQE128 for IORING_OP_READ/WRITE */
> +struct io_uring_sqe_ext {
> +	/*
> +	 * Reserved space for extended capabilities that are added down the
> +	 * line. Kept in beginning to maintain contiguity with the free space
> +	 * in first SQE
> +	 */
> +	__u64	rsvd0[4];

Thanks for documenting the design decision.  But I still don't understand
it.  Due to the layout it will be a bit hard to have fields spreading
form the "normal" SQE into the extended area anyway.  Note that this
is not a rejection of the approach, but I don't understand the argument
for it.

> +	/* only valid when EXT_CAP_PI is set */
> +	__u16	flags;
> +	__u16	pi_app_tag;
> +	__u32	pi_len;
> +	__u64	pi_addr;
> +	__u64	pi_seed;
> +	__u64	rsvd1;

.. but either way it would probably make sense to keep the reserved
areas together instead of spread out.

Otherwise this looks good to me.

