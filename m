Return-Path: <io-uring+bounces-4509-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2296D9BF568
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 19:37:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CEA6D1F261F4
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 18:37:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27F9E209663;
	Wed,  6 Nov 2024 18:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OHNvOBeT"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E653820821C;
	Wed,  6 Nov 2024 18:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730918189; cv=none; b=SSTGyg+WIfc+i3JPEGr4WObLZ43elR9wJhrItYWoZTGXGHvpkAP75kM5uVsKfQuhT/I4STJa1FDh+REDEVzX+uaGQPgT3CxAUZZ9Aj8u8ESQQRHsi+Ww+SZIPXigw07Vffi24upgvUYBV0Md2+wdo2pUC4Zyt1eqCi31/3VWURQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730918189; c=relaxed/simple;
	bh=d7uZUo4EgxYYzo5iZ+B5585cT/fKf9oBOEL1ue47x3A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GJub9SePFePiUawo/MuTAm/TVjlShieFM1Fyp0dJ4uKn9lBZd4eEe1diPCX+MjfmEWR0fQ/l7pE4A5mqkOY15YQNuzxqYg8LYLcZ4sK5iwGC8hfP79xK7Jp8RG0EueqqJoTCLJxfKxKAvi1Ki35Tvm5acYDGk6jdJaDyxhYXLTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OHNvOBeT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB575C4CEC6;
	Wed,  6 Nov 2024 18:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730918188;
	bh=d7uZUo4EgxYYzo5iZ+B5585cT/fKf9oBOEL1ue47x3A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OHNvOBeT5vC90TwmRCctaWZjktJQY//J9y+dUKRTZs/9ChtFgZFgQEB7o4YNJfvNe
	 /SdUnQfudr+KzKo4DuKK1wyB76/c2wrLk5CW84KbqybdoTxkjw1Ek7UqvQaYtDageE
	 6vuU54XngSAekFTEfRjsJLx6DqBZlAfcWjTE9P/4ZLS1otP1Pg2fKVibQM9PaWsG0t
	 YZq/oULdXhmLM/XzujfxXSjmwFZYADeny+5Z02aGACmzVn/s7XIBF/89cANd6nYkmk
	 BKnx/1/yWLdOPoO2P74o7pcv7guF9NpBCXjkHQGID0OFJvPTKy2c0APWJOjGkhoXxZ
	 gCbmYUbFs1Vew==
Date: Wed, 6 Nov 2024 11:36:25 -0700
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	joshi.k@samsung.com, javier.gonz@samsung.com, bvanassche@acm.org
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
Message-ID: <Zyu3Kc2j8CjcEkiJ@kbusch-mbp>
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
> 
> This is basically my current WIP xfs zoned (aka always write out place)
> work optimistically destined for 6.14 + the patch set in this thread +
> a little fix to make it work for nvme-multipath plus the tiny patch to
> wire it up.
> 
> The good news is that the API from Keith mostly works.  I don't really
> know how to cope with the streams per partition bitmap, and I suspect
> this will need to be dealt with a bit better.  One option might be
> to always have a bitmap, which would also support discontiguous
> write stream numbers as actually supported by the underlying NVMe
> implementation, another option would be to always map to consecutive
> numbers.

Thanks for sharing that. Seeing the code makes it much easier to
understand where you're trying to steer this. I'll take a look and
probably have some feedback after a couple days going through it.

