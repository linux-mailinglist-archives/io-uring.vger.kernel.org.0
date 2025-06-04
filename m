Return-Path: <io-uring+bounces-8201-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D8F74ACD893
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 09:30:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 816C73A4600
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 07:30:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4733313AD05;
	Wed,  4 Jun 2025 07:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TL/eaE3Z"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D9D2C327E;
	Wed,  4 Jun 2025 07:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749022225; cv=none; b=fxqghrdj97sFIjkf4cNhtvfYFg1y+BjwyfVEUDYkH1QNJIUFM3xYIIRjRjpZEoDIu6CfbMFzXdQfc+LrCpuXQ1qILQpcNfywV3rgzasU02Kg/ocaKU0so7HF7BphmKUrnejr0YEMt1n20WFsMV7WjX/mHPeoo8wtAA4zWCGVvPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749022225; c=relaxed/simple;
	bh=nYGlvotog1vBEZHxftoO41s8QgqQurYnOLoxy9lvaZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rRaKlpBzehI/DziGQrGajVT225Y5FrdeTTh1llSfEPcx1LNQywdaCjdbF06qO9BuGICo3MMTKuK1DrIvNgxSv5f90kKOTpcmEEQAic5+UFpI7FAE1Ai48Lk8kmYLNiMM3bnaWuHVjZt0phLkQ+rPMKt2nKssnBLnueePoB6E4Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TL/eaE3Z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=jhFqGA7Qdy4GBuqDKCOMHvMHX8BdS/uyheN/8znQjlg=; b=TL/eaE3ZcUcLPhOgO6Sv3GLqLm
	OAGzgeKIlFm/MRwa3NddF0wG62CW5xcYvAROVzCOu5649e/gakMhkcBoGUNfPkq2C2BCUu9qR12wr
	ztQ1Ld0+yJYSmcYLKowmJ3yb680cSFdx1eCSlVwKRjJ7ZoP5VwTXgDVx4j3NRxp/mncV1RnIONLsu
	oZPk5yxnACReiuOrBt4V95rMS1NG8uVtAq04cLxK0ZihYlttXniWdQxAl1kK6juVaX2Mv66WqyfJu
	dPgJ0efIH7IoNAfgZEv3Rq3ajnz7SYQHB9jQ6sGyQSHd7H3d+j5rFn4WRatwKGmrKfq2J/KzgnDCs
	ihWQFZng==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uMiZn-0000000ClsW-0GJZ;
	Wed, 04 Jun 2025 07:30:19 +0000
Date: Wed, 4 Jun 2025 00:30:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Anuj gupta <anuj1072538@gmail.com>
Cc: Anuj Gupta <anuj20.g@samsung.com>, axboe@kernel.dk, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v11 00/10] Read/Write with meta/integrity
Message-ID: <aD_2C9-KKnssYXri@infradead.org>
References: <CGME20241128113036epcas5p397ba228852b72fff671fe695c322a3ef@epcas5p3.samsung.com>
 <20241128112240.8867-1-anuj20.g@samsung.com>
 <aD_qN7pDeYXz10NU@infradead.org>
 <CACzX3As_FH1tMgZHMoCJMPhnuB__oh7KBzd9Z_JLtg2CLFZ4rA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACzX3As_FH1tMgZHMoCJMPhnuB__oh7KBzd9Z_JLtg2CLFZ4rA@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jun 04, 2025 at 12:45:44PM +0530, Anuj gupta wrote:
> The fio plumbing I had done for testing was pretty hacky (e.g., using
> NVMe ioctls directly to query PI capabilities), so I didn’t send it
> upstream. I plan to submit a liburing test. While working on it, I
> realized that writing generic userspace tests is tricky without a way to
> query the device’s integrity capabilities. The current sysfs interface
> is limited — it doesn't expose key fields like pi_size or metadata_size,
> which are necessary to correctly prepare protection information in
> userspace.
> 
> That’s what motivated the ioctl RFC I sent earlier — to make it feasible
> for userspace to construct metadata buffers correctly. Once it gets
> settled, I can write some tests using it. Do you see this differently?

Ok, I'll wait for it.  In the meantime I might go ahead with just
converting the data path in nvme to the new DMA API and handle the
metadata mapping later.

