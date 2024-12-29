Return-Path: <io-uring+bounces-5627-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F83C9FE04C
	for <lists+io-uring@lfdr.de>; Sun, 29 Dec 2024 20:42:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4AE9B7A0FBA
	for <lists+io-uring@lfdr.de>; Sun, 29 Dec 2024 19:42:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5059192B95;
	Sun, 29 Dec 2024 19:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="hWH7DfBA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FB82594BC;
	Sun, 29 Dec 2024 19:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735501360; cv=none; b=HRPAF9jj/p+CQOF9J9idFbmrOE5+jOvcundYIIsSNwFw6kBPsCeCBqBKCFzfmE/0Xn8OI2R1o8CEqv08TabYwEEBzYMFEZPqlR+bkwvMy1U6WqrKRioXqT8Vornse9eXJ9YpqyDxYddDHZ+W8vX1Q/P3jl9QFRcVQJjLgGedHz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735501360; c=relaxed/simple;
	bh=B5Yzr1DlE3ZbPLFmZHpdS43ieOvU/CzRyfoxcJy/wgE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=N5WGB3Fla+GtbSGH7vpmzcJxkY+VGAn3/vCp0jGFCknfvm1SI3Hnh/AAgVysYM9Xvmo3QWivoMzNtqm0HTIiMrj5no2Mx4goWe+sdaha0UHJkyTt7/tYXkru2g4o7iXBlzzwRk6Wjzrzgx1ObSBv5fvz+IPhAmn/v2HzN7CSeo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=hWH7DfBA; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Received: from fpc (unknown [10.10.165.4])
	by mail.ispras.ru (Postfix) with ESMTPSA id 23861518E78F;
	Sun, 29 Dec 2024 19:42:28 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 23861518E78F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1735501348;
	bh=SPG/YizN2O05q44/je00g9z52uR4tR/e5GEzszjGkDk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=hWH7DfBASDbUxD1oo27LoY3qI0QIyOGu8axT/ftS4tP8Q+7kYuBLNL30PrzdcKSKc
	 7tqomdl32cJUFyMZT4EHCy+ev3VPN9s43IM5qAKbOV/zS+ehaH5MTbuF+hwcKaJikE
	 AxBJomFLvWhTtS9O5GMbMuJ8T0kRIg693RO6xiU0=
Date: Sun, 29 Dec 2024 22:42:17 +0300
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Matthew Wilcox <willy@infradead.org>
Cc: Jann Horn <jannh@google.com>,
	syzbot <syzbot+cc36d44ec9f368e443d3@syzkaller.appspotmail.com>,
	asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [syzbot] [io-uring?] WARNING in __io_uring_free
Message-ID: <20241229-aa972fa46c7415a89006f784-pchelkin@ispras.ru>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z0kDWtjmlI_LwP5S@casper.infradead.org>

Matthew Wilcox wrote:
> On Fri, Nov 29, 2024 at 12:30:35AM +0100, Jann Horn wrote:
> > > ------------[ cut here ]------------
> > > WARNING: CPU: 0 PID: 16 at io_uring/tctx.c:51 __io_uring_free+0xfa/0x140 io_uring/tctx.c:51
> > 
> > This warning is a check for WARN_ON_ONCE(!xa_empty(&tctx->xa)); and as
> > Jens pointed out, this was triggered after error injection caused a
> > memory allocation inside xa_store() to fail.
> > 
> > Is there maybe an issue where xa_store() can fail midway through while
> > allocating memory for the xarray, so that xa_empty() is no longer true
> > even though there is nothing in the xarray? (And if yes, is that
> > working as intended?)
> 
> Yes, that's a known possibility.  We have similar problems when people
> use error injection with mapping->i_pages.  The effort to fix it seems
> disproportionate to the severity of the problem.

Found this discussion while investigating memory leak in radix_tree_insert [1].
That report has a similar cause - a fault injection in the innards of
radix_tree (say, xarray) allocating loop, then the absence of release of
already allocated internal xarray memory afterall.

I wonder whether just the plain usage of xa_destroy() should be considered
a fix for these kinds of failures. Are there any pitfalls? xa_destroy() is
claimed to cleanup the internal xarray memory.

Judging by ca6484cd308a ("io_uring: no need to call xa_destroy() on empty
xarray"), seems some pitfalls do exist but still..

Would be glad to have a look into the previous discussions of this problem
if they exist - in case I'm raising the questions that were already
answered. Thanks!

P.S. there is no variant of xa_destroy() for radix tree. I think nobody
noticed this since it may have an effect only on these types of bugs
triggered by fault injection. If you think adding it overall makes sense
then I'd try to prepare a patch.

[1]: https://syzkaller.appspot.com/bug?extid=006987d1be3586e13555


