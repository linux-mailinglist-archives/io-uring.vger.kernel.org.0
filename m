Return-Path: <io-uring+bounces-2939-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B08E995DD08
	for <lists+io-uring@lfdr.de>; Sat, 24 Aug 2024 10:49:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 521C31F227DF
	for <lists+io-uring@lfdr.de>; Sat, 24 Aug 2024 08:49:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A6E238FA1;
	Sat, 24 Aug 2024 08:49:39 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBE664A;
	Sat, 24 Aug 2024 08:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724489379; cv=none; b=Z1GKTL1I7i2NPb8vlTST/HLW257FeFlP/su59D2HRujlYy35Ed8EAe26wYtiZSMb+aMnkpCKzNs/Zsctw53N6RM4sEzp7kZLjG6w3rz58nRpVoYvwXvgWf+K6nHQpizNVdhMsnhzzu3WshDiDX2/nJpB0cz/Jsg5DJyExMZXb28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724489379; c=relaxed/simple;
	bh=kGAG57UsXxcWlZyZLbOz9SkRHlXrL+qFF52dAmSh9vI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hj3uERRTQ+RkxRFF64gJAaBmnNNL3lwwmc9WZrP45nsdAkCj1fpiqAW8+OICIpF5k5OMKNpia5kAzXKrbLuCNGw9ZCT9VT9hqPYNwxAEvKQiN2pbIe3Ydo0hPdOO5mPSkDs0AFg1QAmB3cwKD3pc8cyG9VI9h2GEX00JUvKZ+GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2F221227A87; Sat, 24 Aug 2024 10:49:33 +0200 (CEST)
Date: Sat, 24 Aug 2024 10:49:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, krisman@suse.de,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v3 09/10] nvme: add handling for app_tag
Message-ID: <20240824084933.GH8805@lst.de>
References: <20240823103811.2421-1-anuj20.g@samsung.com> <CGME20240823104636epcas5p4825a6d2dd9e45cfbcc97895264662d30@epcas5p4.samsung.com> <20240823103811.2421-11-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823103811.2421-11-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Maybe name this "add support for passin on the application tag" ?

> +static void nvme_set_app_tag(struct nvme_command *cmnd, u16 apptag)
> +{
> +	cmnd->rw.apptag = cpu_to_le16(apptag);
> +	/* use 0xfff as mask so that apptag is used in entirety */
> +	cmnd->rw.appmask = cpu_to_le16(0xffff);

Can you throw in a patch to rename these field to match the field names
used in the specification?  I also don't think the comment is all that
useful.

> +}
> +
>  static void nvme_set_ref_tag(struct nvme_ns *ns, struct nvme_command *cmnd,
>  			      struct request *req)
>  {
> @@ -1010,6 +1017,11 @@ static inline blk_status_t nvme_setup_rw(struct nvme_ns *ns,
>  				control |= NVME_RW_APPEND_PIREMAP;
>  			nvme_set_ref_tag(ns, cmnd, req);
>  		}
> +		if (bio_integrity_flagged(req->bio, BIP_CHECK_APPTAG)) {
> +			control |= NVME_RW_PRINFO_PRCHK_APP;
> +			nvme_set_app_tag(cmnd,
> +					 bio_integrity(req->bio)->app_tag);

Passing the request to nvme_set_app_tag would probably be a bit cleaner.


