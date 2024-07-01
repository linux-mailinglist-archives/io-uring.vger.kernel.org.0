Return-Path: <io-uring+bounces-2395-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A63291D71D
	for <lists+io-uring@lfdr.de>; Mon,  1 Jul 2024 06:39:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 221B5285509
	for <lists+io-uring@lfdr.de>; Mon,  1 Jul 2024 04:39:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E39B2AEE4;
	Mon,  1 Jul 2024 04:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ywHTxJXt"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62C02B9BF;
	Mon,  1 Jul 2024 04:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719808710; cv=none; b=sQeRkIyCRL1KER5Rf2UASi7y+XpMFKb+/R6jWfEBLwdYfdrHaNVQDTJ/wCR3j+qByDlbvCDtZlMq/HOEeZ8Ahc1muKVyrdTt/70FkbL95EDyL+MI6vGVsCJ9Rk3RN6+tjmrhRZe8A3JAHPD/O87ymCtfHrdtiw8FP2GsRfTlFDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719808710; c=relaxed/simple;
	bh=KlezMwv+XXY4o6pEzJ5jH4hLmE4QrEnT/MKhMfPB+Gg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sYwh0bW+1HTk7D+9t0qMeGeB9gUCP3Ips0DdTJUWHCByIUnIXG6Qwis/bEK/rDBwuJQgF9+xGfdwT74o8wYJjaRwC4eYSS0jqhFxXRp/itGRxej4nS+6WXn4DgAFzMyPvNXjNmWi0pEfYSL8QW7B4w6J25XUeGCEmls0GCkV/Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ywHTxJXt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KlezMwv+XXY4o6pEzJ5jH4hLmE4QrEnT/MKhMfPB+Gg=; b=ywHTxJXtpCmMFwwsRi4kvznuAo
	lsp3EOCiyjRHm1hsfBmvlJclgu5+tKIIm6ZT9wsIfCuGn8KcJGAXr/pnjOKmKUHGrN5kP2p3Z01Cx
	UzYHQTFpm3epTqB9jIXP9qwtz1IVGCGTr2Ljmsz+6T9LJq4qQbuhR2s6wIVO8vnvXdsEBVnVKCc/b
	y+rr9ZoOP/Ioq3tYpBgNOKuRIWu1GceuCOvpGawFLOuybcg0qKJ6Muvz3v2GKrkYXnynQL/aSPUfS
	Xz4fQGEKJ8K3BAxCa89NqLwkTLaxAbT/0Xp0nHKhY4ktDBs2ok0YaBL6B/qb+qsiBEWRQENmB4VAX
	HhJF0v3w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sO8o5-00000001fGL-1Zly;
	Mon, 01 Jul 2024 04:38:25 +0000
Date: Sun, 30 Jun 2024 21:38:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, axboe@kernel.dk,
	torvalds@linux-foundation.org, xry111@xry111.site,
	loongarch@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 0/2] statx NULL path support
Message-ID: <ZoIywaObDsx7SVw9@infradead.org>
References: <20240625110029.606032-1-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240625110029.606032-1-mjguzik@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Maybe it's time and declarate the idea to deprecate stat a failure
and we just add it back to the new generic ABI syscalls?

The idea to get rid of layers of backwards compatibility was a good one
and mostly succeeded, but having to deal with not only remapping
the structure but also the empty path issues sounds like it is worth
to just add these pretty trivial system calls back and make everyones
life easier?


