Return-Path: <io-uring+bounces-6275-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CE344A29525
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 16:45:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4461B3A6691
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 15:42:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E87618A6A8;
	Wed,  5 Feb 2025 15:42:21 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F40015854F;
	Wed,  5 Feb 2025 15:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738770141; cv=none; b=aDD5aW+alm8p7PeBNpzl1FEa8zu1ILd5R86OanJNs3DpRx9W/Lrs2UmT4U255BhEpFSMoJH40YdRLEYFgEIDMv/snyzVqNcX0GEsbEg6dJkoS25ty98QT+hadkX2mZm7JnR+pXdrLVz7rqNkqfQXelPpNYw62Rv0iN+guDzO2oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738770141; c=relaxed/simple;
	bh=m2nOXibL+fGpe0G1tswQJTFHG8wwtAmmoV7YtVSBXtU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XTj6Pfz/PG8pZQNsDgWjgL5QAvZ5mzyyREX6NiMorwiXiMl57b/aTJSymbcqyjtyVYl0K41Oney57+lUmamI4mMAWhF+FCXfnge7kvKHwQkS8eSTOiaFLRB+xPP7t6zVT6y1kRRkgvQQO8QHhabBOkuNE+PaT/2e2B56wTtRAVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 40BFE68BFE; Wed,  5 Feb 2025 16:42:07 +0100 (CET)
Date: Wed, 5 Feb 2025 16:42:06 +0100
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com,
	anuj1072538@gmail.com, brauner@kernel.org, jack@suse.cz,
	viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, linux-fsdevel@vger.kernel.org,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v11 07/10] block: introduce
 BIP_CHECK_GUARD/REFTAG/APPTAG bip_flags
Message-ID: <20250205154206.GA13814@lst.de>
References: <20241128112240.8867-1-anuj20.g@samsung.com> <CGME20241128113112epcas5p186ef86baaa3054effb7244c54ee2f991@epcas5p1.samsung.com> <20241128112240.8867-8-anuj20.g@samsung.com> <20250203065331.GA16999@lst.de> <20250203143948.GA17571@green245> <20250204053914.GA28919@lst.de> <20250205115134.GA16697@green245>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250205115134.GA16697@green245>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Feb 05, 2025 at 05:21:34PM +0530, Anuj Gupta wrote:
> On Tue, Feb 04, 2025 at 06:39:14AM +0100, Christoph Hellwig wrote:
> > On Mon, Feb 03, 2025 at 08:09:48PM +0530, Anuj Gupta wrote:
> > > +	if (bi->csum_type == BLK_INTEGRITY_CSUM_IP)
> > > +		bip->bip_flags |= BIP_IP_CHECKSUM;
> > 
> > We'll also need to set the BIP_CHECK_GUARD flag here I think.
> 
> Right, I think this patch should address the problem [*]
> I couldn't test this patch, as nvme-tcp doesn't support T10-PI and so
> does rdma_rxe. I don't have rdma h/w to test this.
> It would be great if someone can give this a run.

I'll add support to nvmet-loop, which should make testing either.

Note that the SCSI target code has the same issues and might be a
little easier to test.


