Return-Path: <io-uring+bounces-1282-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 08DB688FBC9
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 10:41:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 98A1E1F2305F
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 09:41:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59DCC56441;
	Thu, 28 Mar 2024 09:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cbO/vCRg"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F1754279;
	Thu, 28 Mar 2024 09:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711618873; cv=none; b=Ij7/HTQhAOMj+QP6fTbrmy7LfF3Xro6bPxu8kTo9hfjzJRNvuW00p36OFtKpTxeCGrlQsbs6nzLICWkOC1OC3CHBgXX+cYMf5eC94qzkVXMRXbYX0KIkHbL2br6wEha4OBB8gHtyHnSsB/5/8KAAVQrCvx4e6N9OEWO/v+zsD8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711618873; c=relaxed/simple;
	bh=t4T3CRc1oXBKZj+zWEqraSD1tmcZSvREDKPZziHPVoo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nS9t2wbwoshKAhFv6YwO8hk9syc73OTP41pnEsFfVrsB6mS5JJm+AyUoMhshj0H8XZH1y5gy5o3pcqz6Qv++w0/tB4a3N8x48UQMU878NX4+LnCNs1nAgEexcFaRhWXNpilM4ryxktWeHFWCzCMIDMo/9o34BN+uJZE8PY5voog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cbO/vCRg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEADDC433F1;
	Thu, 28 Mar 2024 09:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711618872;
	bh=t4T3CRc1oXBKZj+zWEqraSD1tmcZSvREDKPZziHPVoo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cbO/vCRgFoS1Vbm5RbZVcvA7BynXu2hMj7SzNX9wUhrwN7eqkBXZ5VWznZ5+Xh8xy
	 jpFN2IcBjePtDXWQZvHqVaC48TdQDW5+YuYtljQiOTXC++udVIFgv0DSFj4HFce/08
	 lUpj7uVAsniiJj4lKBwxGUTqNd6laQ1AYaQkdhxYeGcQgSG7Zj4PLblNl3r+ITdeJz
	 ql9uEdF5sPcpIDu3ku1yi29ew9Yh49Sgx+a9XzsQXil0eRTc2l8czSCYT+u6YHWPDR
	 H57CCvp0rCgAgUirJNkAp75Tjg9s1lctJMEo1x8YAeCW9iFNDVJ1eexkQby0KzMq03
	 xLKe40KmyRq6w==
Date: Thu, 28 Mar 2024 10:41:08 +0100
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org, 
	Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, io-uring@vger.kernel.org
Subject: Re: [PATCH] [RFC]: fs: claw back a few FMODE_* bits
Message-ID: <20240328-maserung-markant-287d66ba25cd@brauner>
References: <20240327-begibt-wacht-b9b9f4d1145a@brauner>
 <ZgTFTu8byn0fg9Ld@dread.disaster.area>
 <20240328-palladium-getappt-ce6ae1dc17aa@brauner>
 <20240328081323.GB19225@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240328081323.GB19225@lst.de>

On Thu, Mar 28, 2024 at 09:13:23AM +0100, Christoph Hellwig wrote:
> On Thu, Mar 28, 2024 at 09:06:43AM +0100, Christian Brauner wrote:
> > > Why do we need to set any of these for directory operations now that
> > > we have a clear choice? i.e. we can't mmap directories, and the rest
> > > of these flags are for read() and write() operations which we also
> > > can't do on directories...
> > 
> > Yeah, I know but since your current implementation raises them for both
> > I just did it 1:1:
> 
> Yes, sticking to the 1:1 for this patch is probably a good idea.
> But we should also fix this in a trivial follow on patch.  I can
> write it and add it to your series.

Ok.

