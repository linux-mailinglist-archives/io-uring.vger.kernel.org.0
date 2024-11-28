Return-Path: <io-uring+bounces-5111-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F0D69DB1DD
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 04:24:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7AE91673D0
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 03:24:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10B0E136353;
	Thu, 28 Nov 2024 03:24:14 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B87D136347;
	Thu, 28 Nov 2024 03:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732764253; cv=none; b=SUVtALjmEhjUyuqel/mm/U6L9lNoBdK/EhwPn8cosbnHvdtjylvfA7cIzti4buiBcfCdgrzTBxmcsKdidoavF9dnBZ8DIr8X2d95fjG44mNhM9KDe8EhXEv9Liiemm4h4Ybx1sijWgEcnksd9QmFgiQ2P8UG8tykbgg2DrqZanY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732764253; c=relaxed/simple;
	bh=GjrYbIqDLjzEu/3MrAlo7GkbrNx154BJtAs7kIh4PFA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cjR/+syu0g3+3Y2BuPaJQCtLB552Pg8qm0ZReQ3xWZoxrjz32B/FP6xSAJNXbws3qGjmQozUYswGq2wnlm2417dARhQ++GgAKxWHu8sTbY6a+vN7+fUyk+LB7cklJE2Y8RaKOjK190U5q0GnPz4EWmwzMtUOHpGh4g6BgO04B7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8037868D05; Thu, 28 Nov 2024 04:24:04 +0100 (CET)
Date: Thu, 28 Nov 2024 04:24:04 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Javier Gonzalez <javier.gonz@samsung.com>,
	Matthew Wilcox <willy@infradead.org>,
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@meta.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
Message-ID: <20241128032404.GA12440@lst.de>
References: <d7b7a759dd9a45a7845e95e693ec29d7@CAMSVWEXC02.scsc.local> <2b5a365a-215a-48de-acb1-b846a4f24680@acm.org> <20241111093154.zbsp42gfiv2enb5a@ArmHalley.local> <a7ebd158-692c-494c-8cc0-a82f9adf4db0@acm.org> <20241112135233.2iwgwe443rnuivyb@ubuntu> <yq1ed38roc9.fsf@ca-mkp.ca.oracle.com> <9d61a62f-6d95-4588-bcd8-de4433a9c1bb@acm.org> <yq1plmhv3ah.fsf@ca-mkp.ca.oracle.com> <8ef1ec5b-4b39-46db-a4ed-abf88cbba2cd@acm.org> <yq1jzcov5am.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1jzcov5am.fsf@ca-mkp.ca.oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Nov 27, 2024 at 03:14:09PM -0500, Martin K. Petersen wrote:
> How do you copy a block range without offload? You perform a READ to
> read the data into memory. And once the READ completes, you do a WRITE
> of the data to the new location.

Yes.  I.e. this is code that makes this pattern very clearm and for
which I'd love to be able to use copy offload when available:

http://git.infradead.org/?p=users/hch/xfs.git;a=blob;f=fs/xfs/xfs_zone_gc.c;h=ed8aa08b3c18d50afe79326e697d83e09542a9b6;hb=refs/heads/xfs-zoned#l820


