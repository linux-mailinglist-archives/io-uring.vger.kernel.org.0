Return-Path: <io-uring+bounces-4209-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 096499B6825
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 16:42:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 380E11C20CF7
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 15:42:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E502213ED4;
	Wed, 30 Oct 2024 15:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E4+EK1i+"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2AE1213EC9;
	Wed, 30 Oct 2024 15:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730302902; cv=none; b=ibZIRjocdzxqOC5vyvrOHvYolKpL+v9YAHKDFIqX/coVZ6e0u8b9pojXx+5seCrQnSKgijakerLsy8D6rODTVuq7fBh8xWQMsEzyj6e9ezVhSLNApD9Q7IPBuSNEfuDZbUHMb0/v6NKnBciL3f4tAi5YUQYbaHFRz1IZzXr47Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730302902; c=relaxed/simple;
	bh=utkGkIOuyAypc5KWyKHdZPW7ZaIs7bjNM3+PPMYDXx4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A6kV1AmCUSMif5wDSkZZB1XLmzJtRhzwnzmc9Nr06WemoZcj7E7ZMWuqKWqhvzxERVHHYhQRdDDr2pYN1z3uKYPh4nexF2S/P4TX0fh386Vx44YMAbUEUfIxAHsShPW/YL/KWpExhIt4XNIBmVsxIcq0mL/IrX+qkWdUXphBZEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E4+EK1i+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822B9C4CECE;
	Wed, 30 Oct 2024 15:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730302902;
	bh=utkGkIOuyAypc5KWyKHdZPW7ZaIs7bjNM3+PPMYDXx4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E4+EK1i+uqMZAzhr3niOIOpMznn1nE/QRf8KI0TYOSRYmGtNNLZJHDw+1/IFQKmzH
	 fgy1C9dnab1BHJjhU6RaRtvPJihIfcI+Y3ZYKP2yEkTxWOxnSl/MEVY6K/YBTxabxq
	 8Rr8zXkHQo2RH64xzqPoNSbxTRUYZrmOBP7sPwsih5Rf3g+CA+GDtFwi8xAOTYPR5E
	 pwegXoh3EznGFIrhbSzymoA49utLWxetwb51M93vhihKuFjmS4Iz9Ue/Xtvj7O/A/r
	 kjTLnvRNLlgudf1AXgt46rnqb6N2AagNNV/2EFnS/IEDgSSSvdyK1gvfC7nLgk/wZm
	 HreLOajjVKngw==
Date: Wed, 30 Oct 2024 09:41:39 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	joshi.k@samsung.com, javier.gonz@samsung.com, bvanassche@acm.org,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv10 9/9] scsi: set permanent stream count in block limits
Message-ID: <ZyJTsyDjn6ABVbV0@kbusch-mbp.dhcp.thefacebook.com>
References: <20241029151922.459139-1-kbusch@meta.com>
 <20241029151922.459139-10-kbusch@meta.com>
 <20241029152654.GC26431@lst.de>
 <ZyEAb-zgvBlzZiaQ@kbusch-mbp>
 <20241029153702.GA27545@lst.de>
 <ZyEBhOoDHKJs4EEY@kbusch-mbp>
 <20241029155330.GA27856@lst.de>
 <ZyEL4FOBMr4H8DGM@kbusch-mbp>
 <20241030045526.GA32385@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241030045526.GA32385@lst.de>

On Wed, Oct 30, 2024 at 05:55:26AM +0100, Christoph Hellwig wrote:
> On Tue, Oct 29, 2024 at 10:22:56AM -0600, Keith Busch wrote:
> 
> > No need to create a new fcntl. The people already testing this are
> > successfully using FDP with the existing fcntl hints. Their applications
> > leverage FDP as way to separate files based on expected lifetime. It is
> > how they want to use it and it is working above expectations. 
> 
> FYI, I think it's always fine and easy to map the temperature hits to
> write streams if that's all the driver offers.  It loses a lot of the
> capapilities, but as long as it doesn't enforce a lower level interface
> that never exposes more that's fine.

But that's just the v2 from this sequence:

https://lore.kernel.org/linux-nvme/20240528150233.55562-1-joshi.k@samsung.com/

If you're okay with it now, then let's just go with that and I'm happy
continue iterating on the rest separately. 

