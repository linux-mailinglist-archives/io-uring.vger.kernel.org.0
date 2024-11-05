Return-Path: <io-uring+bounces-4457-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F4169BCE6A
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 14:57:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FD601C2174D
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 13:57:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA0D01D6DBB;
	Tue,  5 Nov 2024 13:57:06 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1E81D45FD;
	Tue,  5 Nov 2024 13:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730815026; cv=none; b=J+JiFvD/p/HyohCRGbGGp+LhSWfWQ+KwOnAGQepxiKkY6MO1xDlj5cyD49ekUAsyHZ6vvle7Zl6MW9VjtahlViaxeghB/mH7ztVvP7zg/HHj2BKQGx2SCVnDFKIZNaH44LVrK5baV0xood+4UCP2GMRCcJOqqg0n3O8H+KBrGEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730815026; c=relaxed/simple;
	bh=xnApAfOCVcI5XWfGu7l/qg4TZxgZYjy0NexAotGmOdg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uz+oQPqxbw9kwrjQfoI4FzmCXzbMTYDjPkzN50sVyQ/6zNKPBZuV6nmJZV+DKVk994O68GatctqvFHTyZq/EfiuNZBaDSNgMwx4Xc+kiDChW7z3TP05QZEm51wr0nYBMy9XIQ76DTfvNNE2tA64vtngpkY/TasSMDTUO+S3apWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E87FE68CFE; Tue,  5 Nov 2024 14:56:57 +0100 (CET)
Date: Tue, 5 Nov 2024 14:56:57 +0100
From: Christoph Hellwig <hch@lst.de>
To: Anuj gupta <anuj1072538@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Anuj Gupta <anuj20.g@samsung.com>,
	axboe@kernel.dk, kbusch@kernel.org, martin.petersen@oracle.com,
	asml.silence@gmail.com, brauner@kernel.org, jack@suse.cz,
	viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, linux-fsdevel@vger.kernel.org,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v7 06/10] io_uring/rw: add support to send metadata
 along with read/write
Message-ID: <20241105135657.GA4775@lst.de>
References: <20241104140601.12239-1-anuj20.g@samsung.com> <CGME20241104141459epcas5p27991e140158b1e7294b4d6c4e767373c@epcas5p2.samsung.com> <20241104140601.12239-7-anuj20.g@samsung.com> <20241105095621.GB597@lst.de> <CACzX3AuNFoE-EC_xpDPZkoiUk1uc0LXMNw-mLnhrKAG4dnJzQw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACzX3AuNFoE-EC_xpDPZkoiUk1uc0LXMNw-mLnhrKAG4dnJzQw@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 05, 2024 at 06:34:29PM +0530, Anuj gupta wrote:
> The field is used only at io_uring level, and it helps there in using the
> SQE space flexibly.

How so?  There is absolutely no documentation for it in either the
code or commit log.  And if it is about sqe space management, meta_type
is about the most confusing possible name as well.  So someone please
needs to write down how it is supposed to work and come up with a name
that remotely makes sense for that.


