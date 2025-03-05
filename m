Return-Path: <io-uring+bounces-6966-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BA10A4F3D4
	for <lists+io-uring@lfdr.de>; Wed,  5 Mar 2025 02:34:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 83741188DAA5
	for <lists+io-uring@lfdr.de>; Wed,  5 Mar 2025 01:34:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D20B76C61;
	Wed,  5 Mar 2025 01:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qeiGC1ky"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C6C1428E7;
	Wed,  5 Mar 2025 01:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741138473; cv=none; b=VWLfVAh/lh/u8VZ6KgpkcS+BZDZFqwIqzaseq75+sO4PpFR1iTI1sdcqT7FvbsmJ1omgZPPzUsLQbc32t8bBmGbmfdJGXZCHgzu2Q6fkBfmhtyzmiqRaNtyMuYmzHPYc3jM7qP8NbyVfTCj91l18ZUa1NKFlMT3j7tbanms1rz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741138473; c=relaxed/simple;
	bh=CJ2PiRsUtvEkOe9ntMXRTLEdIi2mwE+/isxNv+IyilY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=guFfsXd6/3t39Y9EhnL4gAm6Qz5wgZi1/6g+GtP9cBkxsqQWDdHz+wMqAy0hWT+OcLCNZ+AEIOBxLWiAvKvXZHM5pV0KSrJ/O+2cVEBFnt9vxMluICgBBj793Hr2AWVVw9c3AVRtVad5wC6khG5koQCVNV/kcXuhIgyaCoZVP6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qeiGC1ky; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=B4Wqcz440T2k2P6AK89RTnwayezjggDFAeKMGLMRNLs=; b=qeiGC1kyuPLPU3NG7Y/Wf/Ak4m
	gubnV/QlP+lb+4JkPw9Pth/CKREHOqVEdmayVoWyyKlg5NLJB/qhELzbRvVT1QugwQbPQQYTAF5JT
	VF+2Vm7nwDhspCwxobDp2alwbyR+5ekW9rCtxsw1dFrElqUik7c5zVgF5RWbdh3f1Ozl1QCwyWTK2
	WnAq7Pfo8gfK01xeB3pT75dnavef26dOSG2C+sjae0jY+rVfqu+3cUalqJyDKQQo05BcNPJasSCsx
	l3VKmSXA2113Ule0YujfacCKYlYmHg+I1S2K6M90TdEMqj/nsgNDCw5bXFHitLFaxs4Vdol85uC7h
	IlCtblQw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tpdeZ-00000006jRP-22d8;
	Wed, 05 Mar 2025 01:34:31 +0000
Date: Tue, 4 Mar 2025 17:34:31 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	io-uring@vger.kernel.org, linux-xfs@vger.kernel.org,
	wu lei <uwydoc@gmail.com>
Subject: Re: [PATCH v2 1/1] iomap: propagate nowait to block layer
Message-ID: <Z8eqJ5DLVBF0hF_W@infradead.org>
References: <f287a7882a4c4576e90e55ecc5ab8bf634579afd.1741090631.git.asml.silence@gmail.com>
 <Z8clJ2XSaQhLeIo0@infradead.org>
 <83af597f-e599-41d2-a17b-273d6d877dad@gmail.com>
 <20250304192205.GD2803749@frogsfrogsfrogs>
 <6374c617-e9a3-4e1c-86ee-502356c46557@gmail.com>
 <Z8eUVcqMYfCJtdge@infradead.org>
 <d1b985d3-aa2b-4b63-99bd-7ba0ea016821@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1b985d3-aa2b-4b63-99bd-7ba0ea016821@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Mar 05, 2025 at 12:45:52AM +0000, Pavel Begunkov wrote:
> It's not something recent. After some digging I think the
> one I remember is
> 
> https://lore.kernel.org/all/20190717150445.1131-2-axboe@kernel.dk/
> 
> Remove by
> 
> commit 7b6620d7db566a46f49b4b9deab9fa061fd4b59b
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Thu Aug 15 11:09:16 2019 -0600
> 
>     block: remove REQ_NOWAIT_INLINE

That does indeed look pretty broken, mostly because it doesn't actually
return the errors inline as return values but tries to emulate it.

> > If you don't want to do synchronous wouldblock errors that's your
> > only option.  I think it would suck badly, but it's certainly easier
> > to backport.
> 
> Is there some intrinsic difference of iomap from the block file
> in block/fops.c? Or is that one broken?

block/fops.c has roughly the same issue, but it's not anywhere near
as sever, as block/fops.c doesn't have any file system state that
gets confused by the async BLK_STS_AGAIN.  But unless io_uring knows
how to rewind the state for that case it probably also doesn't work
properly.  It might be worth to look into testcases that actually
exercise the nowait I/O on block devices with annoyingly small limits
or that split a lot (like RAID0).


