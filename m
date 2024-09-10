Return-Path: <io-uring+bounces-3100-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DDAC972B6A
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 10:03:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B9901F25639
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 08:03:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93321142904;
	Tue, 10 Sep 2024 08:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="y3ge0A8+"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B741174EFC;
	Tue, 10 Sep 2024 08:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725955342; cv=none; b=tRskIz8Iz6WipsLfcTEuAIOkQxunJORkX25Fm1Z0Y5MadUOq97i7qNFQgymFktmBKWUad5+I+EtAq75pJY55wxF6WRlId5oYhNgsnnfel0V4nFqsm8ofERE02NqT/pQ9vU6WNpYJBtQL3cxQpy4sgaLxFmqum94KDysqhdzFbiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725955342; c=relaxed/simple;
	bh=vTz3MV9w6m6pfeY8ONMFTdEGEOUJYAfZxsmwK2qeTXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=syFzmRKdmwWsciy9NOjVzZgljlLffocc0mBNCEa6KplYaO+O1KUdvACwyNIvyZNocDdq1NSY7f7MDo61Xoj74tiyj1yiSLnJiyUf9N2z9KrDzvs9FvF0HwNkkYKum1stcFI9UqmUUeqdc1tpIzCIMI5qnlj8vu20PEMYVuJdltA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=y3ge0A8+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0ia0RjKuVOWgdJ6dtAbKCY9WS/3lhSpvP+9a6dXQbxI=; b=y3ge0A8+fysNL8GCRK4sCRcaxL
	nIzfT1+aWy4jbqu1ip9AXtmaOktM2OX+cYLtDe29Gz3/WoWr75YErc1NHLJMCS5TxPthPkTPEZwyE
	QVS8iX0rXZJR0gS7cn4W9URTsZMLjeMI9fNBsSVhb+Sx7ChQtLM7W0t9jGUz48qfZH+E5Vdn6j2Gp
	xmTvfJ5EtB5yKF+iTHQHu7H2VGwlEweAsqUmjRlR6tEu/M+uEq27/+f0OrmXYX6SELEbzTQD4Es5t
	fP9JEzIVWzz3pl47ido0OIZg3dVxo1AJ5YPWSZf1uuL3iicASrFxJ5kqf8L3n86jrygBdvAiPXGMi
	Vh26s7JQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1snvpM-00000004iZo-2EVM;
	Tue, 10 Sep 2024 08:02:20 +0000
Date: Tue, 10 Sep 2024 01:02:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Conrad Meyer <conradmeyer@meta.com>, linux-block@vger.kernel.org,
	linux-mm@kvack.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4 8/8] block: implement async write zero pages command
Message-ID: <Zt_9DEzoX6uxC9Q7@infradead.org>
References: <cover.1725621577.git.asml.silence@gmail.com>
 <c465430b0802ced71d22f548587f2e06951b3cd5.1725621577.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c465430b0802ced71d22f548587f2e06951b3cd5.1725621577.git.asml.silence@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Sep 06, 2024 at 11:57:25PM +0100, Pavel Begunkov wrote:
> Add a command that writes the zero page to the drive. Apart from passing
> the zero page instead of actual data it uses the normal write path and
> doesn't do any further acceleration, nor it requires any special
> hardware support. The indended use is to have a fallback when
> BLOCK_URING_CMD_WRITE_ZEROES is not supported.

That's just a horrible API.  The user should not have to care if the
kernel is using different kinds of implementations.


