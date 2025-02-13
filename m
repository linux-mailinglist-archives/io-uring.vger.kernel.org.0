Return-Path: <io-uring+bounces-6402-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 968ACA33509
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 02:58:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C6863A68DC
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 01:58:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D3BB139CE3;
	Thu, 13 Feb 2025 01:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mv3Qv+PE"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C788635E;
	Thu, 13 Feb 2025 01:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739411917; cv=none; b=H3Y52XqNDxZXffdDFRu1TPUNqjlM9kB4/tD9AKfsBhQi/a25w/EEn1+avMypUprCZtSZdUW4sMERqWfn/MmAqekvS7Y2AwdheUhRp/vrYGEGSY5Kg0B9AvV/juL2JN9vvl7SlgDxAPqRLHn+F5q+gLa82aS0tf7uyeMHwCLWpug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739411917; c=relaxed/simple;
	bh=NkrVX57Tz0yQt2AyZmpd4CAH+Jh85ASkX/Gz0++Ddi4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EdorcPiZlqS2B2qbSk5xcrl+8qUtURaUKO5TCei7nrQ24Y1KDtmpha4Gn2Kwr5Be66X4SVXVj2ySYnCoYoGULVtrrgbUaDwJNLbQWKvzYRvgziJo8w6yB3rz+gRQ4Xowveqn9P4zG2o/7k2N0frRekJMfWXHC8g4XGavXpi35UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mv3Qv+PE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B13C4CEDF;
	Thu, 13 Feb 2025 01:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739411917;
	bh=NkrVX57Tz0yQt2AyZmpd4CAH+Jh85ASkX/Gz0++Ddi4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mv3Qv+PEIQWMAR4+WzASpqW5/QXbAMDrJhuWwqFF7rs6HEv8TBDw6E37PZywss92F
	 YgOeLTLoYnzml9+tZAg6Pqrtv++9v0F4WzCTIFiiRiTxRcf6HvjrLgeFuGrYoSzkel
	 miPPUKIVzrUGRdXJLv3GghmQ8Zpl/gi8ZOdtcj7tr8Xyjiou7nc8kMzXiheom7Tj/T
	 dC+FRNRf/1+gz/DWv93UcZgu65E1ZxSjVGWbICvdnLzXwxilzKXDAMDrDzklyL4OwW
	 dt1fGuv0cF3EcG3zjxpQk8k4TzKKxqMNthntroD9E2ycT9/kyXIsUQJNUk/CuJpM09
	 E768V4Jx0dzoQ==
Date: Wed, 12 Feb 2025 18:58:34 -0700
From: Keith Busch <kbusch@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, axboe@kernel.dk,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	bernd@bsbernd.com
Subject: Re: [PATCHv2 2/6] io_uring: create resource release callback
Message-ID: <Z61RyrzGbUopEJiV@kbusch-mbp>
References: <20250211005646.222452-1-kbusch@meta.com>
 <20250211005646.222452-3-kbusch@meta.com>
 <d24b097b-efea-4780-af67-e7a96eb1d784@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d24b097b-efea-4780-af67-e7a96eb1d784@gmail.com>

On Thu, Feb 13, 2025 at 01:31:07AM +0000, Pavel Begunkov wrote:
> On 2/11/25 00:56, Keith Busch wrote:
> > @@ -24,6 +24,9 @@ struct io_rsrc_node {
> >   		unsigned long file_ptr;
> >   		struct io_mapped_ubuf *buf;
> >   	};
> > +
> > +	void (*release)(void *);
> > +	void *priv;
> 
> Nodes are more generic than buffers. Unless we want to reuse it
> for files, and I very much doubt that, it should move into
> io_mapped_ubuf.

Good point. Cloning is another reason it should be in the imu.

If we want to save space, the "KBUFFER" type doesn't need ubuf or
folio_shift, so we could even union the new fields to prevent imu from
getting any bigger. The downside would be we can't use "release" to
distinguish kernel vs user buffers, which you suggested in that patch's
thread. Which option do you prefer?

