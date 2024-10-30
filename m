Return-Path: <io-uring+bounces-4192-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 42BDE9B5B1E
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 06:10:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 740381C21126
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 05:10:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B9AA197543;
	Wed, 30 Oct 2024 05:10:22 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E96DBA4A;
	Wed, 30 Oct 2024 05:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730265021; cv=none; b=eXvVw5OWug27NlHYTWf5MiFlnEvpj7wx4dcgLcfPQ5fd3minqaQYY6iLVG/Dr8UQhr5cQDylv949w4WwpjzNijp8uWsbH0+g60eF0uyE/+IxRKcaixcupKhSA3qO9ZawZMbL9rHtmZze/FtlqITFkb0uz4TlKVUqLBxI9/xDz3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730265021; c=relaxed/simple;
	bh=izUWuxB2r/aE8rQ+KT4clPgfUm7Ml9ilY/AVtca46no=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YhZ8EUl6KQsv1BeCoPP6500CHHoc747XihAH/C2EUeivbrkA3XS0CKS3LOw0iKVFeAxffEiCb2w1U8FwTjdlYVRASqQ/ItZJFLO4ynk/zoOCzH3DSF8wdLVoHhi4ovR8qU6by8f3jU6cUYpikqGffgdlqfWvaFv5pOfb97T2hzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 32B60227A8E; Wed, 30 Oct 2024 06:10:16 +0100 (CET)
Date: Wed, 30 Oct 2024 06:10:16 +0100
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com,
	anuj1072538@gmail.com, brauner@kernel.org, jack@suse.cz,
	viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v5 09/10] scsi: add support for user-meta interface
Message-ID: <20241030051016.GD32598@lst.de>
References: <20241029162402.21400-1-anuj20.g@samsung.com> <CGME20241029163233epcas5p497b3c81dcdf3c691a6f9c461bf0da7ac@epcas5p4.samsung.com> <20241029162402.21400-10-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241029162402.21400-10-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 29, 2024 at 09:54:01PM +0530, Anuj Gupta wrote:
> Add support for sending user-meta buffer. Set tags to be checked
> using flags specified by user/block-layer.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

> -		if (bio_integrity_flagged(bio, BIP_CTRL_NOCHECK) == false)
> +		if (bio_integrity_flagged(bio, BIP_CHECK_GUARD))
>  			scmd->prot_flags |= SCSI_PROT_GUARD_CHECK;
>  	}
>  
>  	if (dif != T10_PI_TYPE3_PROTECTION) {	/* DIX/DIF Type 0, 1, 2 */
>  		scmd->prot_flags |= SCSI_PROT_REF_INCREMENT;
>  
> -		if (bio_integrity_flagged(bio, BIP_CTRL_NOCHECK) == false)
> +		if (bio_integrity_flagged(bio, BIP_CHECK_REFTAG))

BIP_CTRL_NOCHECK is unused now, and should probably go away.


