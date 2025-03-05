Return-Path: <io-uring+bounces-6960-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D7594A4F1FE
	for <lists+io-uring@lfdr.de>; Wed,  5 Mar 2025 01:01:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0679E188CF3E
	for <lists+io-uring@lfdr.de>; Wed,  5 Mar 2025 00:01:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 545B21FDA;
	Wed,  5 Mar 2025 00:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="L7P9wnUb"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B8C4C7D;
	Wed,  5 Mar 2025 00:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741132887; cv=none; b=c+11aqPvXGyK9+rcauc5mWVuvvAkAPUyEpVYobhGiGLcG6GU0tkwxJOd3446ubw/vmHkNiOG1HIwyo1tRz8x7YqpKYNJ2Z69txd6nvGgVjPCwLHVIHrwJEuMB+UnTwcK+d8uWsaiktxYPhuY8rDpquJu5WED4Y4QIbkT9WvAYFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741132887; c=relaxed/simple;
	bh=NsFdvokmDwtRG/3Jkin6bWmAUWDRLCpraJ8X3HUuMkc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QkxcwXFLPkY3m05ai5+H+rK64gFlaRJunOm2pdDXam/+ODYg74tlCxqM9vK0/hx80pHV01mSXWUj2XB3eIRc/0pCpOW5Eg/sb1jlc392M7skiHI+9pqK2tmyQpI4/lH2HMUOykmRVgaWo+iD69XcEdJy5/Ft5Nz7Gn2J5A8XtXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=L7P9wnUb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Fsywue9rlH/mIZo7+SU832OJHSex48bjtHHpvJ2zoX0=; b=L7P9wnUbfw/lruC6syYinp568F
	qikqyAkn/4Zp7dblCs05eDijffMFDTcpVS5dands069A94KwFhP3r9qdmnE7UGe4CY0a+1sCkbz8X
	UQRafeI/ufDeCk8MRjjndo4JY/DlUP3AvFDhWSxJkH+en8V4td4+Tg6kb1cUZSeXTkyTfefUkyh7L
	+L4NHqm140lUCq8m3T1KRWSg255YtBwYmVILuwCHe7BBvLVVCU66LaRQ+z53JDHNxkcaNqMGe9F01
	X0eV7xVwdz4lr8N0fR5a6+YnRVNsrtMrUIo3qXTJ6diEZZOdzjbJ7lSgEHKwg7cGXO8T+IUPM9lfK
	UifO+YCg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tpcCT-00000006aH6-1JoY;
	Wed, 05 Mar 2025 00:01:25 +0000
Date: Tue, 4 Mar 2025 16:01:25 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	io-uring@vger.kernel.org, linux-xfs@vger.kernel.org,
	wu lei <uwydoc@gmail.com>
Subject: Re: [PATCH v2 1/1] iomap: propagate nowait to block layer
Message-ID: <Z8eUVcqMYfCJtdge@infradead.org>
References: <f287a7882a4c4576e90e55ecc5ab8bf634579afd.1741090631.git.asml.silence@gmail.com>
 <Z8clJ2XSaQhLeIo0@infradead.org>
 <83af597f-e599-41d2-a17b-273d6d877dad@gmail.com>
 <20250304192205.GD2803749@frogsfrogsfrogs>
 <6374c617-e9a3-4e1c-86ee-502356c46557@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6374c617-e9a3-4e1c-86ee-502356c46557@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 04, 2025 at 08:35:52PM +0000, Pavel Begunkov wrote:
> Clarification: the mentioned work was reverted or pulled out _upstream_,
> it wasn't about back porting.

I don't think we ever tried synchronous reporting of wouldblock errors,
but maybe i'm just too old and confused by now.

> lines. And Christoph even of confirmed that the main check in the patch
> does what's intended,

I absolutely did not.

> Another option is to push all io_uring filesystem / iomap requests
> to the slow path (where blocking is possible) and have a meaningful
> perf regression for those who still use fs+io_uring direct IO. And
> I don't put any dramaticism into it, it's essentially what users
> who detect the problem already do, either that but from the user
> space or disabling io_uring all together.

If you don't want to do synchronous wouldblock errors that's your
only option.  I think it would suck badly, but it's certainly easier
to backport.


