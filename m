Return-Path: <io-uring+bounces-6956-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 66898A4F178
	for <lists+io-uring@lfdr.de>; Wed,  5 Mar 2025 00:28:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B81893A4C61
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 23:28:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EAB827814C;
	Tue,  4 Mar 2025 23:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hw85WIaW"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2111FCF6D;
	Tue,  4 Mar 2025 23:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741130894; cv=none; b=i0c5ILEz57P6KopcnVMFMzkC7aV9+1zVOCEDVKheY+r0PpCHrLTNm7Sgt0PYsPGYwbkrQXYidWoIOAwQYSyB75hkPeyxj8FrOQCZepQHvyWDopC0xr8fXMLwERcvOs1c2fRhq1jehL2w5igIXNajlfYrall4YKlGVFQnywmy5hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741130894; c=relaxed/simple;
	bh=FqFCOPO4oEwOOtkeZwtGKDAg/YNPsQBtEqMuhN8VBYk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XdLvDVjfjflTHdgIroKj4BsYpP+592xNr41OoHFHfI7Z5+jlLAhbUKscyrB3Zf9KYgWaq5DS9zcCZ6Wrn67OfmJxG7R2VRANi0ykNuenyu5u1CFMrGGqfo7pRb7IpDUb0KqWlZgvDPRW8B8Xf6VsP5rwGM4gK/rwjxcg/RoMVpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hw85WIaW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jK1rlGvQyRQRFyeFzVVVZCNGAja0T1DkuqKUqk3mPjg=; b=hw85WIaWPlGfutr7ZGdO6QPUS+
	eemm5Ufl420sgyNm7Iht8sADjKpJAWvv5w1jgsuxMahabAX856T/QSTatfReAWPJ7B4SkccAv3LQr
	AJoelWVQQOr2B9YsOtChRvTUJ6Tg4FPC2Spc/k5lwoR9nPshhfqx6Lb3lFgP0VMGB8Ku5+fg/LrJG
	rTb1oFliQQ0yf13Bg1VmwWVT52YTBX5FaJn7gFmrrKJsRkwPAqrIk7HTsH5/sEwGvN+Wg17UlTVHY
	s7FepNHL9W/eczJjbpKix9CqzEUq7/UILO8YsA4oNpiiNycqEDsgNlD0avyWdZEFdG7lPcUFniLIo
	XjTKkNVg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tpbgJ-00000006Wjj-3ttm;
	Tue, 04 Mar 2025 23:28:11 +0000
Date: Tue, 4 Mar 2025 15:28:11 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	io-uring@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org, wu lei <uwydoc@gmail.com>
Subject: Re: [PATCH v2 1/1] iomap: propagate nowait to block layer
Message-ID: <Z8eMi8jZ6pUFYp8o@infradead.org>
References: <f287a7882a4c4576e90e55ecc5ab8bf634579afd.1741090631.git.asml.silence@gmail.com>
 <Z8clJ2XSaQhLeIo0@infradead.org>
 <83af597f-e599-41d2-a17b-273d6d877dad@gmail.com>
 <Z8cxVLEEEwmUigjz@infradead.org>
 <8295d4e5-dff7-4e20-80b5-0a8019498257@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8295d4e5-dff7-4e20-80b5-0a8019498257@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 04, 2025 at 05:54:51PM +0000, Pavel Begunkov wrote:
> That's an interesting choice of words. Dear Christoph, I'm afraid you
> don't realise that you're the one whining at a person who actually tries
> to fix it. I'd appreciate if you stop this bullshit, especially if you're
> not willing to fix it yourself. If you do, please, be my guest and prove
> me wrong.

I'm not bullshiting.  I put my money where my mouth is, and you're
complaining.


