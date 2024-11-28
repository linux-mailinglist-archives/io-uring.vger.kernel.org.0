Return-Path: <io-uring+bounces-5128-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C4A3E9DBE29
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 00:57:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 747DD163AA8
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 23:57:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36E521940A2;
	Thu, 28 Nov 2024 23:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NVeH6hxn"
X-Original-To: io-uring@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77365211C;
	Thu, 28 Nov 2024 23:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732838242; cv=none; b=KDApxuQ6WDjaH+hvxHSqn2ocMDvwspQ7f1Afd5McPuNCFdkRnDZU0D9XFB6XG741ZyIna0V0Gw1zh29yLwKk2SIegdqM0dG2wvGoEOXsJRTJ9HwjTCYgkYnwGeTJQ5V4xtNykgQdFziW+ZpKpmG2Lvzr+3xEvTDgDX3qlHGiHlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732838242; c=relaxed/simple;
	bh=9ji3H8fVHUjH72z/Rew8W0jSVxV2FEfIPTBs/eVMFjg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EeHPXFfIFFkh+/vALVLnDfh66RDo7bOu70PC+EMxnmrRQa/QLYy8fZiRTL6LCbcSwG/R9hbay68ZfjfSZryhVVbXjkTtSIYOI4B5aVA3myqgMQjiDEwulTj+F9kU9MN1ECFM6PriT9oVDo7dVc81kqgKjXe06WRNd5VgHCzRwQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NVeH6hxn; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=n5TzocNg5NSMR/EMBC9MaqP0bB5Vs+X18ru/ZYSehlg=; b=NVeH6hxn/aRlD0e0Tsx+goBKac
	XZ3mNsUUfAD7UxJGfUsaJZBZlFf0mo9HwddjDwKC9TqK6TCtl+qt8sbxiQMgiCap1IvXyc7PhHf9G
	YjVowoOEYQF3NJUGIhQG54GSJBfodIxFdlYdcIcoTZEW57AThHJCh/UoEJ4iHjEOn19F0COJuI5/5
	KZEl//ULOvdxunN9yysC2lTLatv+lFX5PjqGlmPBNsh3sNKr2XgW+UMdhA6VhlitebIFxSc8g0Bck
	fG+AE/EhlMnxI8bd+ATgWFcNhnX6LSjoX80i+mh+Mw+mGdEDBq6HIEvtVKu+zaVdGAU0skOaWxjNz
	nzvQUFhw==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tGoNm-00000003GRQ-1N8k;
	Thu, 28 Nov 2024 23:57:14 +0000
Date: Thu, 28 Nov 2024 23:57:14 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Jann Horn <jannh@google.com>
Cc: syzbot <syzbot+cc36d44ec9f368e443d3@syzkaller.appspotmail.com>,
	asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [syzbot] [io-uring?] WARNING in __io_uring_free
Message-ID: <Z0kDWtjmlI_LwP5S@casper.infradead.org>
References: <673c1643.050a0220.87769.0066.GAE@google.com>
 <CAG48ez0uhdGNCopX2nspLzWZKfuZp0XLyUk90kYku=sP7wsWfg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez0uhdGNCopX2nspLzWZKfuZp0XLyUk90kYku=sP7wsWfg@mail.gmail.com>

On Fri, Nov 29, 2024 at 12:30:35AM +0100, Jann Horn wrote:
> > ------------[ cut here ]------------
> > WARNING: CPU: 0 PID: 16 at io_uring/tctx.c:51 __io_uring_free+0xfa/0x140 io_uring/tctx.c:51
> 
> This warning is a check for WARN_ON_ONCE(!xa_empty(&tctx->xa)); and as
> Jens pointed out, this was triggered after error injection caused a
> memory allocation inside xa_store() to fail.
> 
> Is there maybe an issue where xa_store() can fail midway through while
> allocating memory for the xarray, so that xa_empty() is no longer true
> even though there is nothing in the xarray? (And if yes, is that
> working as intended?)

Yes, that's a known possibility.  We have similar problems when people
use error injection with mapping->i_pages.  The effort to fix it seems
disproportionate to the severity of the problem.

