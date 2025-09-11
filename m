Return-Path: <io-uring+bounces-9743-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BA7AB53211
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 14:29:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A6F25A06F9
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 12:29:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A1EC32142A;
	Thu, 11 Sep 2025 12:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pNMNCpr5"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F1C32142E;
	Thu, 11 Sep 2025 12:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757593750; cv=none; b=Babo9RKpsESGMomYmXmAfxrwRHvmml19iL1TSqcwaSx/M7PL7xxTG+TyFxnaqMdtQAw6tp7IPh68AIriGSk3PKxvwa8GfH/e89qZXagOFrxgsUSWDgSUmbgF4FLRwo8gfdSFDkH+a6jwUxishlRIRpdpWfa8BwO1KIFTDn+KN1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757593750; c=relaxed/simple;
	bh=TiEUC8XNZsgBOxE4ZMaxPRWvAWuVWg/6QoHUA8fUpes=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UemvsJ6QUUntBJ7RPsOszansP5quHD0XYnsgPm27FY+AQUbgpbHQTz+6tmwplKO/qZsulJWEFxaOdUHbn5vN/O7q2uWz9LFHg6pnRE1rcPfAa9+Ek65GtBm/WjC1H5CjbXvdZSjndxHn0wVxTGx5V8g7Jyzh1vQ1IGVbrW0i1ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pNMNCpr5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bRjM3zLimfEwLXOfkopRPffMT0vpfOsIodIMklr0UF0=; b=pNMNCpr5jZP/jJm5yQspi6JYPa
	kR9fsHEmT3fY4aYtO87JTOBfdV3PqFoJxW70dQJOc6hSPoNa0W7S9m744EueY7HA+Fcg8o5DIDg37
	mHxOtYwXyVjf6jHiEDTrpco3DMWE5oXhZgu1P57SAF42ZdDFxECsjCKUPWWmKUNPOFR1YNsi2S2zf
	4C0wtQmVfKqTy+OPY835qox6/PuIa3IM4IdBlF5kY2SqqrJdNzlISXMfRnNGOVL+RFcKJKxbKBUsN
	p4Dvl9W0aNyLBRyhC1WIsYaNLMC1VgrP/Ac4hRP1ijEgIB7VZXA8E/ZNIW4AVIEDNz03CGc1Z6HCb
	5/vgHBLg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwgQF-00000002y7f-3vMp;
	Thu, 11 Sep 2025 12:29:07 +0000
Date: Thu, 11 Sep 2025 05:29:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk,
	linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
	brauner@kernel.org, linux-nfs@vger.kernel.org,
	linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH 10/10] xfs: add support for non-blocking fh_to_dentry()
Message-ID: <aMLAkwL42TGw0-n6@infradead.org>
References: <20250910214927.480316-1-tahbertschinger@gmail.com>
 <20250910214927.480316-11-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910214927.480316-11-tahbertschinger@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Sep 10, 2025 at 03:49:27PM -0600, Thomas Bertschinger wrote:
> This is to support using open_by_handle_at(2) via io_uring. It is useful
> for io_uring to request that opening a file via handle be completed
> using only cached data, or fail with -EAGAIN if that is not possible.
> 
> The signature of xfs_nfs_get_inode() is extended with a new flags
> argument that allows callers to specify XFS_IGET_INCORE.
> 
> That flag is set when the VFS passes the FILEID_CACHED flag via the
> fileid_type argument.

Please post the entire series to all list.  No one has any idea what your
magic new flag does without seeing all the patches.



