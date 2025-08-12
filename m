Return-Path: <io-uring+bounces-8940-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88685B224ED
	for <lists+io-uring@lfdr.de>; Tue, 12 Aug 2025 12:51:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A350E622588
	for <lists+io-uring@lfdr.de>; Tue, 12 Aug 2025 10:50:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97A272EBDCC;
	Tue, 12 Aug 2025 10:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h5oCWpFB"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC7B2E764E;
	Tue, 12 Aug 2025 10:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754995782; cv=none; b=tMh5RGaNexWkSgELVxemLEBGoMpNz3Ki3d0n9lzlp6cmSrEsjY2KvTWb7QOuWv7NDUzBIyXSAudhmPImnWeA/LvwPFttk5IruwjypcYRCf/2Cf2pPM8+bk4H7SxU0WUcDoNIincs2+omkP068N9jJl5T/Yp+uS6+BJkclIkrBxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754995782; c=relaxed/simple;
	bh=p/Zaq5uBu0sHxfa/r1xHQ9y/wu57zAnoWogo2D3Eo4k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fhz2OdyoSAEM16M9cCbPRILOK/9Th2tazRGPP4dyJRIK+ZuulB6hFUYta2V+XXphuqNkwNBzIiUsyn9mPIaa1/WlvKdHB6Qa+UPeb0/t8RMcEJbNmL2HPEzIug0bLOYOtU/ESAPZBYKMr2bt47hpe+14s9EndEVnwBADfZT4eog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h5oCWpFB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669C2C4CEF0;
	Tue, 12 Aug 2025 10:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1754995781;
	bh=p/Zaq5uBu0sHxfa/r1xHQ9y/wu57zAnoWogo2D3Eo4k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h5oCWpFBm4+ERkUDRWnb722caLv2yuyQEUl14dQbCsQevgcS5qBxujZoT1gsRQ4oP
	 4cY5Zx48tLGMfvw7LyWgzmHiGQyaW8SF2bYX/voBJQ5uGj+eYfS4Ms+nJvoEPa/PRT
	 +pyxOztEX0Gxca/9QrwMQkl6UOGIbQdcqc3iiD9k=
Date: Tue, 12 Aug 2025 12:49:33 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Sumanth Gavini <sumanth.gavini@yahoo.com>
Cc: axboe@kernel.dk, asml.silence@gmail.com, lkp@intel.com,
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com, oe-kbuild-all@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH v2 6.6] io_uring/rw: ensure reissue path is correctly
 handled for IOPOLL
Message-ID: <2025081248-kinswoman-deserving-59c0@gregkh>
References: <aJeVj4yXt4F01nPb@f5c43a121a53>
 <20250809205420.214099-1-sumanth.gavini@yahoo.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250809205420.214099-1-sumanth.gavini@yahoo.com>

On Sat, Aug 09, 2025 at 03:54:18PM -0500, Sumanth Gavini wrote:
> commit bcb0fda3c2da9fe4721d3e73d80e778c038e7d27 upstream.
> 
> The IOPOLL path posts CQEs when the io_kiocb is marked as completed,
> so it cannot rely on the usual retry that non-IOPOLL requests do for
> read/write requests.
> 
> If -EAGAIN is received and the request should be retried, go through
> the normal completion path and let the normal flush logic catch it and
> reissue it, like what is done for !IOPOLL reads or writes.
> 
> Fixes: d803d123948f ("io_uring/rw: handle -EAGAIN retry at IO completion time")
> Reported-by: John Garry <john.g.garry@oracle.com>
> Link: https://lore.kernel.org/io-uring/2b43ccfa-644d-4a09-8f8f-39ad71810f41@oracle.com/
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Sumanth Gavini <sumanth.gavini@yahoo.com>
> ---
> Changes in v2:
> - Removed the extra space before commit-id in message, No codes changes
> - Link to v1:https://lore.kernel.org/all/20250809182636.209767-1-sumanth.gavini@yahoo.com/

We can not take patches ONLY for older kernel trees and not newer ones,
otherwise you will have a regression when moving to a newer one.  I've
dropped this now, please submit for all relevant trees.

thanks,

greg k-h

