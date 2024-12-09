Return-Path: <io-uring+bounces-5338-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8917F9E9AFF
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 16:58:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE7BD282BC7
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 15:58:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5DD213665B;
	Mon,  9 Dec 2024 15:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fub9RQA+"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68A4233139;
	Mon,  9 Dec 2024 15:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733759872; cv=none; b=Tmi1Y0SVfNiXkMLqwvjzHZ/spREWE/gpKFFf5iBSG8EdlCgtcSiRW7YLwta5lbJU5+RBIoC9Iav3gzP12OrLMGjQ30dfNplTbJgOxPwEZjwE1ipSC44FOrYXErm7UEf5opypaphrspnD56JCnRi/I2yL4O/QY7cub8MNaCY4K7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733759872; c=relaxed/simple;
	bh=Pz7fIUtIf0IsPOePSYLfjM9CCwShvhiLHveXBe7i7aM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dec2Qoazo6dh6dBPUVpbnNhEM6xcW6hU5p6vFh4CjX6B+Dz2m6ExYBicXj1FMAieXOqX6a4VIMsI7+nMb/mMGVpLob7Dy9PpFwkuCKN0pmFsbbU0AaomzEAwaOlMamKgVgF0hgOLkCKXFpebZh894dxurq4UEI6MGujswHITXPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fub9RQA+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99310C4CEDE;
	Mon,  9 Dec 2024 15:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733759872;
	bh=Pz7fIUtIf0IsPOePSYLfjM9CCwShvhiLHveXBe7i7aM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fub9RQA+FnF//HKXEpAIl9wIGLsvt16Lxi5GuSRKF3kz90wTwUOD6W9ml8l/JmGZW
	 1Vrx/S2taBUhavUbY6j5SgCgN/M+5wt3Q2zmXzs9veQ1mVi8HX5VykT5HwNvpnf1Eu
	 a4hQfnvXvgX/VRwUGoDElS5UDn17M8dYF+p/Gr/KiES18jNujUalngJZh8bAVvkGZ6
	 +hwajX3SU/W3fbC7h12rB3isNSfebaHRMCRxwe07rr8wAjvAjq+cU8f4gyBUzwHxor
	 KmDJgTWSLbo2jB95tQTT391EWWyIfszP060xJPx0W27jB1fzdIRcG6WDcmv9qEUQQn
	 3uuQ80y/dltRA==
Date: Mon, 9 Dec 2024 08:57:49 -0700
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, axboe@kernel.dk,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	sagi@grimberg.me, asml.silence@gmail.com
Subject: Re: [PATCHv11 00/10] block write streams with nvme fdp
Message-ID: <Z1cTfefzaKHMFQ9p@kbusch-mbp.dhcp.thefacebook.com>
References: <20241206015308.3342386-1-kbusch@meta.com>
 <20241209125132.GA14316@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241209125132.GA14316@lst.de>

On Mon, Dec 09, 2024 at 01:51:32PM +0100, Christoph Hellwig wrote:
> On Thu, Dec 05, 2024 at 05:52:58PM -0800, Keith Busch wrote:
> > 
> >  Not mixing write hints usage with write streams. This effectively
> >  abandons any attempts to use the existing fcntl API for use with
> >  filesystems in this series.
> 
> That's not true as far as I can tell given that this is basically the
> architecture from my previous posting.  The block code still maps the
> rw hints into write streams, and file systems can do exactly the same.
> You just need to talk to the fs maintainers and convince them it's a
> good thing for their particular file system.  Especially for simple
> file systems that task should not be too hard, even if they might want
> to set a stream or two aside for fs usage.  Similarly a file system
> can implement the stream based API.

Sorry for my confusing message here. I meant *this series* doesn't
attempt to use streams with filesystems (I wasn't considering raw block
in the same catagory as a traditional filesystems).

I am not abandoning follow on efforst to make use of these elsewhere. I
just don't want the open topics to distract from the less controversial
parts, and this series doesn't prevent or harm future innovations there,
so I think we're pretty well aligned up to this point.

