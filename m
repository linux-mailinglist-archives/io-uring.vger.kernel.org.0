Return-Path: <io-uring+bounces-6766-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C353AA4508D
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 23:55:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3858C3ACA4A
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 22:55:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD677232786;
	Tue, 25 Feb 2025 22:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KRHHXVfd"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4447204F9B;
	Tue, 25 Feb 2025 22:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740524110; cv=none; b=jkbKZpscqC0a4D2NQkjENxKviiDmvPRHMGoRWOQdgpfyRHUoIL/ud9fmWOSAJGZCAxN9+psBIMLMGVvFwwUEo+sLHYug6WFYFR7cXWn7gvRxoxnzJbVLYIT/AkKVfurwU+FJspD1woUcvDN5Vmot7875R+/6ghfm7QOkhecVXj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740524110; c=relaxed/simple;
	bh=PIaInqYCmkHEiGXAflZPveOpwE7G+A4RGoeK+8JMbyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BoHiI31UtbcujSHqiWAujPYQ4SH9LODtrrYOTFzGbwj1S552pbgztV7laQbN1gSwAkLPFpNYXG38i3QoXw0LUtde8A/N/Bo8USzLdjzPyYLnf09jLiGraSvji3nSBesKPqGEzcV+WsvPFEABrTilDPPdMscUfR/QQ7Zrugn03dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KRHHXVfd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48BDC4CEDD;
	Tue, 25 Feb 2025 22:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740524110;
	bh=PIaInqYCmkHEiGXAflZPveOpwE7G+A4RGoeK+8JMbyw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KRHHXVfdGIBMvmH2UjGQbRVXivy7uoORTYsvfwFXBTb1gNnFN3ArKeRLj5G4D8DHn
	 +zlL+tJxdb4y3nfj2kKe/QcBnZ9cpz6jCDebXR9k/+XcaeNMm4L62WFyp8wJLuMnSH
	 v4bbKQWYA810XXbbmiZ5l+y2h0MsSkZrUkkuP6TjkZY0IjZTjOmPbcMxiqzJ6JhF1w
	 nj3mEX2mm/HOEGoth6Ci74GMFvzkxBubj/aZb6pxe+3O6lFkIxmm4A3kWBwi5qBj/p
	 qQi8R/CmA3FJes2mK91Ro8DxEFgEhfxxtR4Zw2hrYtWbaXK9W5CNYO1v8sXb7XQ7vM
	 RXQmesLLq3mLQ==
Date: Tue, 25 Feb 2025 15:55:08 -0700
From: Keith Busch <kbusch@kernel.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, asml.silence@gmail.com, axboe@kernel.dk,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	bernd@bsbernd.com, csander@purestorage.com
Subject: Re: [PATCHv5 07/11] io_uring: add support for kernel registered bvecs
Message-ID: <Z75KTOk5ivO6x-lh@kbusch-mbp>
References: <20250224213116.3509093-1-kbusch@meta.com>
 <20250224213116.3509093-8-kbusch@meta.com>
 <Z72P_nnZD9i-ya-1@fedora>
 <Z73-rhNw3zgvUuZr@kbusch-mbp>
 <CAFj5m9KA1QUS-gYTRdpQRV4vMBcBE_7_t22YDrCh21ixgQMcxQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFj5m9KA1QUS-gYTRdpQRV4vMBcBE_7_t22YDrCh21ixgQMcxQ@mail.gmail.com>

On Wed, Feb 26, 2025 at 06:47:54AM +0800, Ming Lei wrote:
> On Wed, Feb 26, 2025 at 1:32 AM Keith Busch <kbusch@kernel.org> wrote:
> >
> > On Tue, Feb 25, 2025 at 05:40:14PM +0800, Ming Lei wrote:
> > > On Mon, Feb 24, 2025 at 01:31:12PM -0800, Keith Busch wrote:
> > > > +
> > > > +   if (op_is_write(req_op(rq)))
> > > > +           imu->perm = IO_IMU_WRITEABLE;
> > > > +   else
> > > > +           imu->perm = IO_IMU_READABLE;
> > >
> > > Looks the above is wrong, if request is for write op, the buffer
> > > should be readable & !writeable.
> > >
> > > IO_IMU_WRITEABLE is supposed to mean the buffer is writeable, isn't it?
> >
> > In the setup I used here, IMU_WRITEABLE means this can be used in a
> > write command. You can write from this buffer, not to it.
> 
> But IMU represents a buffer, and the buffer could be used for other
> OPs in future,
> instead of write command only. Here it is more readable to mark the buffer
> readable or writable.
> 
> I'd suggest not introducing the confusion from the beginning.

Absolutely, no disagreement here. My next version calls the flags
"IO_IMU_SOURCE" and "IO_IMU_DEST" and defined from the same ITER_
values.

