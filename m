Return-Path: <io-uring+bounces-4258-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A28CD9B74CB
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 07:56:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6812D282B11
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 06:56:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F16241494B5;
	Thu, 31 Oct 2024 06:56:03 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD771494C2;
	Thu, 31 Oct 2024 06:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730357763; cv=none; b=hA6BSFaKxugIks0Xa2akbshS4y8r8opeLS/xDA238Reu4ZkAR4Y7nPMNNmgAchr3P/mnMpGwUdGYgWUnMdGSABCIs43Em8Oh61M4PDjN2tkMRG3VFs3sw1+IbfIMI9iAPKdynjypZq8fFWp8oXT3MvmCFHf0t6jUYlFncvWJ27A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730357763; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pyg8KaCvk0TRN973UVwwk5MOfKTpdQya+QfbDpL35e8l1YXzBIcfQTH1b2r0t/7wrKy3ZnfeN8+4NhDRPYeQcTOFB3Vg5xP/5vnygK4e/HDsNq1PE20jx4TLQTBZrqU+BVlMO+3gbI1iQ2lLr7+o/k2WMN3gkU/UnKYHNg/JPGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3664C227AAD; Thu, 31 Oct 2024 07:55:58 +0100 (CET)
Date: Thu, 31 Oct 2024 07:55:57 +0100
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com,
	brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, gost.dev@samsung.com,
	vishak.g@samsung.com, anuj1072538@gmail.com,
	Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH v6 06/10] io_uring/rw: add support to send metadata
 along with read/write
Message-ID: <20241031065557.GB26299@lst.de>
References: <20241030180112.4635-1-joshi.k@samsung.com> <CGME20241030181013epcas5p2762403c83e29c81ec34b2a7755154245@epcas5p2.samsung.com> <20241030180112.4635-7-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241030180112.4635-7-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


