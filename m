Return-Path: <io-uring+bounces-4559-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 488A09C0FD7
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 21:36:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BD2A0B21434
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 20:36:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7332F2170C0;
	Thu,  7 Nov 2024 20:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lEAbv3jy"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4A8210186;
	Thu,  7 Nov 2024 20:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731011799; cv=none; b=fBYUyQqqzbNk3ekLz4cthxkDBQ537ROHRoDVXz/oYqkDKjpDctF4pwuXm4sx2QKiSIR62GJTPSspv9dlXQrFF6vM0SdCgCJgUqrJwR/qhmXIx0zU/1bZ1GCYRcZofevBaDWFZRq+OlQqKLMaxOGg0ygxnbiBIKXHtJmRpky6tM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731011799; c=relaxed/simple;
	bh=pUEWBNk0QMyHT4XDwDxz52gT2AwKmMAH9IEJoyAd0F0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=grl++3uRKho9DrzelVUW38fugkPkPxvZLq27KpXNlXR+plzo0WuhCUhhJZwKsWbwrGxDyKks3bNY6J6pLL0XyMM3lCLIJyvgorGPQ1UemGyEsX7RfpbZYidlHiDCKzlNBJs1n+uWQwd9OFXLABaM82UVhX/8YQbOJDNACEQQeio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lEAbv3jy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F519C4CECC;
	Thu,  7 Nov 2024 20:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731011798;
	bh=pUEWBNk0QMyHT4XDwDxz52gT2AwKmMAH9IEJoyAd0F0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lEAbv3jyMcWY4wh1wsdT5LnVCt8LHbJxzO5I+Az9vZZPaYZ/22HoAlAHlhMz0VrTf
	 semcWRb3HO5dRteq9GX5T5DUXdmnZdysyPqYo0Ex1bz/sfh6dQXyrvtY/tI622GIxq
	 +1bSmk5rqs7I0uG3MFP/tqgMQCK4iZEgwqUcwSc4Py3qq3kPDETGwS+6bsEH4X9i15
	 rgyEj9bH3LyJuc0RDsFSQlbJYVIzEgAFQzXEOzADFPbmKFHhA1+KHMia7BUVdqz+g8
	 BSUJxfBVLOfWfLecJXwwlOes7EGYdpVaMYM2O/vFYn8LwH1zv2ZJJ/IzWAfbQZ7G3S
	 rAZUuj+bi4g7A==
Date: Thu, 7 Nov 2024 13:36:35 -0700
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	joshi.k@samsung.com, javier.gonz@samsung.com, bvanassche@acm.org
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
Message-ID: <Zy0k06wK0ymPm4BV@kbusch-mbp>
References: <20241029151922.459139-1-kbusch@meta.com>
 <20241105155014.GA7310@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241105155014.GA7310@lst.de>

On Tue, Nov 05, 2024 at 04:50:14PM +0100, Christoph Hellwig wrote:
> I've pushed my branch that tries to make this work with the XFS
> data separation here:
> 
> http://git.infradead.org/?p=users/hch/xfs.git;a=shortlog;h=refs/heads/xfs-zoned-streams

The zone block support all looks pretty neat, but I think you're making
this harder than necessary to support streams. You don't need to treat
these like a sequential write device. The controller side does its own
garbage collection, so no need to duplicate the effort on the host. And
it looks like the host side gc potentially merges multiple streams into
a single gc stream, so that's probably not desirable.

