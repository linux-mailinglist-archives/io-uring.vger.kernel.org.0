Return-Path: <io-uring+bounces-7206-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA809A6CBBE
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 18:52:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 076A43B7872
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 17:52:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A3D17FBAC;
	Sat, 22 Mar 2025 17:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TUbo2BYW"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642F64C6C
	for <io-uring@vger.kernel.org>; Sat, 22 Mar 2025 17:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742665942; cv=none; b=FXTuh9tCh9ml692n/UQJ/2/VIwmyXpbsJxsO1FfcuJgFEAH5MjqvkLC+8A6g2OSjSbDrOQUu8czzy5jPiMHd04XfOM96/5T8jlPdjETo4dnU8pIOHwVZ2RgSDijrLReRlDfSnVGpya4HUPYO1UgByp9XiLEg18Mk7Dce20csaYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742665942; c=relaxed/simple;
	bh=cSIBAxfDjrKiaZ3N58LzKppM+HMI6BSY0PH56yg8/tc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YfuYJ3uBbNKP2l0K9rBoLT1iEhRIceU3XTO3OKjxgSJrq1DpdiEyU7yvgJkDS5wp0vXBb/x/jS5J/i9LLIlu0P0z7fuQvHV3DsTnagyMAqB7x9r5VwQgsQAHWtBg8PXTmWaHv9lhUcmB+rnXg5/qO50+XouJz4kIW/NPpiOXTmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TUbo2BYW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B007C4CEDD;
	Sat, 22 Mar 2025 17:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742665941;
	bh=cSIBAxfDjrKiaZ3N58LzKppM+HMI6BSY0PH56yg8/tc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TUbo2BYWeowRh/3UAe9k5HQ5nZ6C65xb7qjm2nYwrwirSWJL1/rM6ZAssJjU54g/g
	 tpUF0fru4bl7PPnEpYXfcT4Q8uoSMgHkc/kh3Dq6AI/mSllL5NdeMIq+VgfpAiS8HC
	 PEFT4fRT3DuEPtQaZ3Y4z8cRoNO4ZYSBinCDQCLCXAwL2PuYhhZwR43o3gUMzgCgCW
	 nj24Tx+4XpT573pwUIBNlpgVReB6VzxNHmHiFfO1e+/Q2u5zD4J6Cz3pIlJqOjrW0w
	 Uj6mqFULSdIHDHvMBUSjuznp3jblY1kPcWMvfbwtC/qcy5dycCV4EZh+lP61MfrMMf
	 oZDAscZ/VHt1A==
Date: Sat, 22 Mar 2025 11:52:20 -0600
From: Keith Busch <kbusch@kernel.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: Re: [PATCH] io_uring: zero remained bytes when reading to fixed
 kernel buffer
Message-ID: <Z9741KU2Fz7J0NSq@kbusch-mbp>
References: <20250322075625.414708-1-ming.lei@redhat.com>
 <ae74ba78-d102-42de-95a6-1834f5f85dc6@gmail.com>
 <Z97ALTDd-s0-uT7O@fedora>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z97ALTDd-s0-uT7O@fedora>

On Sat, Mar 22, 2025 at 09:50:37PM +0800, Ming Lei wrote:
> On Sat, Mar 22, 2025 at 12:02:02PM +0000, Pavel Begunkov wrote:
> > On 3/22/25 07:56, Ming Lei wrote:
> > > So far fixed kernel buffer is only used for FS read/write, in which
> > > the remained bytes need to be zeroed in case of short read, otherwise
> > > kernel data may be leaked to userspace.
> > 
> > Can you remind me, how that can happen? Normally, IIUC, you register
> > a request filled with user pages, so no kernel data there. Is it some
> > bounce buffers?
> 
> For direct io, it is filled with user pages, but it can be buffered IO,
> and the page can be mapped to userspace.

I may missing something here because that doesn't sound specific to
kernel registered bvecs. Is page cache memory not already zeroed out to
protect against short reads?

I can easily wire up a flakey device that won't fill the requested
memory. What do I need to do to observe this data leak?

