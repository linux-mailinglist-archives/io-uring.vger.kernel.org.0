Return-Path: <io-uring+bounces-4563-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A63929C16E8
	for <lists+io-uring@lfdr.de>; Fri,  8 Nov 2024 08:13:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5E0AD1F21DE4
	for <lists+io-uring@lfdr.de>; Fri,  8 Nov 2024 07:13:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE5061D0E35;
	Fri,  8 Nov 2024 07:12:56 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DF6DDA8;
	Fri,  8 Nov 2024 07:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731049976; cv=none; b=O1wfdPASwDCSjMq2YWawTOjL8IPX/CXE2cXU/ucl+BvnuwVAhS0wDlBVCl1kUpOkrm3zsjLLiOTOf+UmWEJ//z6Vb+Gi0pRBptcp7m3S1MPAlxQAxCm7v75LFtPiSeHgps89CCxLksfmQCtN4B38I0qyz/A3lVaWayNjMs11yJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731049976; c=relaxed/simple;
	bh=srBUBrMtrSwBkm97wqaSMupErLhKc8XzpEsRv7o0Te4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cg6zO4h0SKejLAPY31QJsXi2Xxq1mPPM/5mqPUABDdZemFy41MekonrluStBW0eouXRQXL84UVGx7kor3K7JySy5w+MEE5mHfublgO831qM338iR7i3At85oeHqELuDMEAH9pBrNebD6X5KwGQors+ei5ju/4LsJZSVvc1UJL6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0640768B05; Fri,  8 Nov 2024 08:12:50 +0100 (CET)
Date: Fri, 8 Nov 2024 08:12:49 +0100
From: Christoph Hellwig <hch@lst.de>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Keith Busch <kbusch@kernel.org>, Anuj Gupta <anuj20.g@samsung.com>,
	axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	anuj1072538@gmail.com, brauner@kernel.org, jack@suse.cz,
	viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, linux-fsdevel@vger.kernel.org,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v5 06/10] io_uring/rw: add support to send metadata
 along with read/write
Message-ID: <20241108071249.GA9374@lst.de>
References: <20241029162402.21400-1-anuj20.g@samsung.com> <CGME20241029163225epcas5p24ec51c7a9b6b115757ed99cadcc3690c@epcas5p2.samsung.com> <20241029162402.21400-7-anuj20.g@samsung.com> <ZyFuxfiRqH8YB-46@kbusch-mbp.dhcp.thefacebook.com> <7995ffbd-7ec0-4f99-86a2-011bc3375228@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7995ffbd-7ec0-4f99-86a2-011bc3375228@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 07, 2024 at 05:30:36PM +0000, Pavel Begunkov wrote:
> It makes sense to implement write hints as a meta/attribute type,
> but depends on whether it's supposed to be widely supported by
> different file types vs it being a block specific feature, and if
> SQEs have space for it.

It make sense everywhere.  Implementing it for direct I/O on regular
files is mostly trivial and I'll do it once this series lands.


