Return-Path: <io-uring+bounces-1390-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AB3BB897CF5
	for <lists+io-uring@lfdr.de>; Thu,  4 Apr 2024 02:20:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 47B141F2A4BF
	for <lists+io-uring@lfdr.de>; Thu,  4 Apr 2024 00:20:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45E3D28EA;
	Thu,  4 Apr 2024 00:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="nBfpn3r5"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7316E23CE;
	Thu,  4 Apr 2024 00:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712189909; cv=none; b=l/UfcuKcKo0Oo7S44meJsEdrQDOGjXTX9EPNCRtqalZXvbq2L5sh7Thy6tXniUHRj1/Zz02m6yI6qb8pOAqCa1xGqSy5vttBjUOg/HUM3ZIRtrjRmeCJmlgyvogMiHTuQ0VbOZ80pGdQX5mgeYcinRYxMr5nu9GEyoBia3q0xNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712189909; c=relaxed/simple;
	bh=j8Vd4HpiPBroNvmjK9rwTnZO4v1iynoIydnJokVfVTw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IJx1LD/Ve9BJ76DXlcp7aIGoIhhsfanPebuPwXTd2EMirTroI+vAEkrwgATBOPHuihm4OUU7PPDBzMb2Sbht85dEuv2kpQfF+boq5bIphZBCDr8VSad3DVVx6QpCVkIEWkmCGuXUM1Xg7fyhAdaj0sb9xCyx9Bverk+k+JyGkWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=nBfpn3r5; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=D1Qy3uDlb5XwBny7lH9hFBYMOl++jZ3p8eUgQAsnp68=; b=nBfpn3r5exKRz9e1SCCNaOmI6m
	x04cK1HdGeI/TSsa3zBHQygME5IjAzxKGZ9l69wGhyNrttA4EfBDl4908YBTF0WqDdTgO/2siYCng
	NhhtjpAsl3kEE6m+eJiwo0pfwrjMm3RD34JOaa2eTCKSu5IkOOPKN6jsjDswk7Kvbeimtjdy0c1F6
	kMkJRxxRKwoc0vScJmsh0hkH7/985L8CbQNTkupIDMj1yd97g1OV0KYgFFe7awqQjcGYVqfNwi1H7
	+o5AM6RLdSKMYMOiuVRisyyStJD3S+82r2Qpnplsm/GJEllLHvDCHPQUrXjlfjryun49YG2LYbD6U
	MZpunzqg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rsAoB-005EUU-2X;
	Thu, 04 Apr 2024 00:18:23 +0000
Date: Thu, 4 Apr 2024 01:18:23 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Dave Chinner <david@fromorbit.com>, io-uring@vger.kernel.org
Subject: Re: [PATCH v2] fs: claw back a few FMODE_* bits
Message-ID: <20240404001823.GP538574@ZenIV>
References: <20240328-gewendet-spargel-aa60a030ef74@brauner>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328-gewendet-spargel-aa60a030ef74@brauner>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Thu, Mar 28, 2024 at 01:27:24PM +0100, Christian Brauner wrote:

> (Fwiw, FMODE_NOACCOUNT and FMODE_BACKING could live in fop_flags as
>  well because they're also completely static but they aren't really
>  about file operations so they're better suited for FMODE_* imho.)

????

FMODE_BACKING is set for files opened by e.g. overlayfs in the underlying
layers.  They bloody well can share file_operations with the files opened
in the same underlying filesystem the usual way - you wouldn't be able
to store that in file_operations, simply because the instances with
identical ->f_op might differ in that flag.

The same goes for FMODE_NOACCOUNT - kernel_file_open() vs. open(2)
can easily yield struct file instances that differ in that flag, but
have the same ->f_op.

