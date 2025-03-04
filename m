Return-Path: <io-uring+bounces-6946-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C262DA4E908
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 18:34:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E7D1887F37
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 17:21:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B4B4276039;
	Tue,  4 Mar 2025 16:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Tj9QDfef"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D23E285407;
	Tue,  4 Mar 2025 16:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741107542; cv=none; b=NNQy6YcEXugptqnVFR6ujHAByWbWESB7yGr/5TP3Q8MVsx0cKgi1+hf3u4GZKRQP8/rQO5sruYIkKsfjqMAFFjpis1Y+7QBx6I4U/M0sT6kDjq4GMGX2yfqV9eDd5aNFVrD0pe9o6hTGUhsAsEHzkqx6ppV6BCteYLOrQzYbIvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741107542; c=relaxed/simple;
	bh=hlSefFu+T7kPa6zdQpbEdDrC5eBetGFjNBr7skzkaaU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gR22jFxf8VR5zLZ6pLwEKzwTf10aln1puWknoYqxsZzTvftfVG3ULsO0mgYGt/FcgOqvyQJoSeWyEAW3ZAO8szXj8npdTTKVggr3DM4t2fDVVy4U2cwnWFen4z0mzAW/D7HzyxhCknvQGLMfcDQzFje/GUaQIPzdTctW7hxI3QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Tj9QDfef; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dlSiTVCdYd8giigSRHqNV9RsrG2BwpE0SZCO+G9sIIg=; b=Tj9QDfef4hMq6tE5HVXKhhyleC
	uQ7gv0I2FYY6fUKM4gD1slplJXl4HU6zcvkiTxrssR6MNmIoCth7ztwtAil+QoKtuDETXLK845pFw
	7PP5WfNauQI2/ATlcR6KAWBZPkGG3dRqmbvAQ2RrW2gSGlu+UKewcjNzbVZsRQY35p0tAYONms9Jt
	qOvrK04k+5euTUYa2ho8j6ajMafUOgkbuSgu8jTabEhgUblq4J4FP6Lvr1uu36XMzgcnkLg3rEbdp
	X9Rb68Br2AusvK4ZcsBDDTBB1DP1XaWR9dxV0bBGnVhui7Fc2xgb40F55r5F3WO5bBJnstGwncxmo
	qR41luxw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tpVbg-00000005WTd-0ZRN;
	Tue, 04 Mar 2025 16:59:00 +0000
Date: Tue, 4 Mar 2025 08:59:00 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	io-uring@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org, wu lei <uwydoc@gmail.com>
Subject: Re: [PATCH v2 1/1] iomap: propagate nowait to block layer
Message-ID: <Z8cxVLEEEwmUigjz@infradead.org>
References: <f287a7882a4c4576e90e55ecc5ab8bf634579afd.1741090631.git.asml.silence@gmail.com>
 <Z8clJ2XSaQhLeIo0@infradead.org>
 <83af597f-e599-41d2-a17b-273d6d877dad@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83af597f-e599-41d2-a17b-273d6d877dad@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 04, 2025 at 04:41:40PM +0000, Pavel Begunkov wrote:
> bio_iov_vecs_to_alloc() can overestimate, i.e. the check might return
> -EAGAIN in more cases than required but not the other way around,
> that should be enough for a fix such as this patch. Or did I maybe
> misunderstood you?

No you didn;t but we need to do this properly.

> Assuming you're suggesting to implement that, I can't say I'm excited by
> the idea of reworking a non trivial chunk of block layer to fix a problem
> and then porting it up to some 5.x, especially since it was already
> attempted before by someone and ultimately got reverted.

Stop whining.  Backporting does not matter for upstream development,
and I'm pretty sure you'd qualify for a job where you don't have to do
this if you actually care and don't just like to complain.


