Return-Path: <io-uring+bounces-10055-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DD9CBEC7C2
	for <lists+io-uring@lfdr.de>; Sat, 18 Oct 2025 06:47:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F2D331AA516A
	for <lists+io-uring@lfdr.de>; Sat, 18 Oct 2025 04:47:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1C4A25C818;
	Sat, 18 Oct 2025 04:47:08 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5874D1F584C;
	Sat, 18 Oct 2025 04:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.125.252.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760762828; cv=none; b=dJ9KOIChX/fkQdUrb1iqpXNgkhYZ1WexAGBbF0MfEjvoBXlVFvj0VXrPTySFO/MIfgz1Tn/DdYGe4gXmWQUp6V6YK38R9TFR+WRP49+5pSCZlkIsP88lidXsFlcHNZnOPUg0+8E6CeaR9szXpmvWMFv24aP/FN4ShJOMNm26cvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760762828; c=relaxed/simple;
	bh=y2x9f3aQVzHRpfAEf9bRNga9mO3Bh7q0jzvdlTL+hA4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kSSebBlZqnF2JeMGVcpeJrkXRk/xy2PfGtOpGjYs08kxvTNtZUcDGeWnUZraRBm3PSWtMPDRt11XD+Ecb/lvBLV0BDRK6n6+/UsS7aKbzTmT20Kohp+rblxQ9SwseG+vl0wd06oVrvsIIdPcC0XaCiLtFCaUJvZDloPdIVPGt10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com; spf=pass smtp.mailfrom=sk.com; arc=none smtp.client-ip=166.125.252.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sk.com
X-AuditID: a67dfc5b-c45ff70000001609-11-68f31bc3fadd
Date: Sat, 18 Oct 2025 13:46:53 +0900
From: Byungchul Park <byungchul@sk.com>
To: Mina Almasry <almasrymina@google.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, axboe@kernel.dk,
	kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net,
	edumazet@google.com, horms@kernel.org, hawk@kernel.org,
	ilias.apalodimas@linaro.org, sdf@fomichev.me, dw@davidwei.uk,
	ap420073@gmail.com, dtatulea@nvidia.com, toke@redhat.com,
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, kernel_team@skhynix.com,
	max.byungchul.park@gmail.com
Subject: Re: [PATCH net-next] page_pool: check if nmdesc->pp is !NULL to
 confirm its usage as pp for net_iov
Message-ID: <20251018044653.GA66683@system.software.com>
References: <20251016063657.81064-1-byungchul@sk.com>
 <20251016072132.GA19434@system.software.com>
 <8d833a3f-ae18-4ea6-9092-ddaa48290a63@gmail.com>
 <CAHS8izMdwiijk_15NgecSOi_VD3M7cx5M0XLAWxQqWnZgJksjg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHS8izMdwiijk_15NgecSOi_VD3M7cx5M0XLAWxQqWnZgJksjg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsXC9ZZnke5h6c8ZBvMf81qs/lFh8XPNcyaL
	Oau2MVqsvtvPZjHnfAuLxc5dzxktXs1Yy2bx9Ngjdos97duZLR71n2Cz6G35zWzxrvUci8WF
	bX2sFpd3zWGzuDCxl9Xi2AIxi2+n3zBaXJ25i8ni0uFHLA7CHltW3mTyuDZjIovHjX2nmDx2
	zrrL7rFgU6nH5bOlHptWdbJ53Lm2h82jt/kdm8f7fVfZPD5vkgvgjuKySUnNySxLLdK3S+DK
	WPFcteCBaMXCK1PYGhhbBLsYOTgkBEwk3i5k72LkBDNffLnDChJmEVCVWHa1ECTMJqAucePG
	T2YQW0RAU2LJvolAJVwczAK7mCX6rl1h7GJk5xAWyJN4ZgzSyStgIbHotSJIhZDAPUaJbzev
	gbXyCghKnJz5hAXEZgYa+WfeJWaQemYBaYnl/zggwvISzVtng5VzCgRKrNg7hRHEFhVQljiw
	7TgTyEwJgUPsEnvmL2SFuFhS4uCKGywTGAVnIVkxC8mKWQgrZiFZsYCRZRWjUGZeWW5iZo6J
	XkZlXmaFXnJ+7iZGYLwuq/0TvYPx04XgQ4wCHIxKPLwWMz9lCLEmlhVX5h5ilOBgVhLhZSj4
	kCHEm5JYWZValB9fVJqTWnyIUZqDRUmc1+hbeYqQQHpiSWp2ampBahFMlomDU6qBMfJns19/
	8uRlB9pMfp5mSfsWJlWRFD3XUiHz1ffJ3JkWOQbNZ3Se+B3ewBzIsWXa4Qzp60e3Rhbt2Pqv
	V6/ui3Zrg6Fa/FvrV8Hix1aUiUifebvg4J/dAmHdk541Op1n+bhLZ/KaGr+HvW//nYk4eceO
	7/lu2QffHqY2B2+UXF+n+a310p97CUosxRmJhlrMRcWJAEKmOxrTAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsXC5WfdrHtI+nOGwcRrVharf1RY/FzznMli
	zqptjBar7/azWcw538JisXPXc0aLVzPWslk8PfaI3WJP+3Zmi0f9J9gselt+M1u8az3HYnF4
	7klWiwvb+lgtLu+aw2ZxYWIvq8WxBWIW306/YbS4OnMXk8Wlw49YHEQ8tqy8yeRxbcZEFo8b
	+04xeeycdZfdY8GmUo/LZ0s9Nq3qZPO4c20Pm0dv8zs2j/f7rrJ5LH7xgcnj8ya5AJ4oLpuU
	1JzMstQifbsErowVz1ULHohWLLwyha2BsUWwi5GTQ0LAROLFlzusXYwcHCwCqhLLrhaChNkE
	1CVu3PjJDGKLCGhKLNk3EaiEi4NZYBezRN+1K4xdjOwcwgJ5Es+MQTp5BSwkFr1WBKkQErjH
	KPHt5jWwVl4BQYmTM5+wgNjMQCP/zLvEDFLPLCAtsfwfB0RYXqJ562ywck6BQIkVe6cwgtii
	AsoSB7YdZ5rAyDcLyaRZSCbNQpg0C8mkBYwsqxhFMvPKchMzc0z1irMzKvMyK/SS83M3MQLj
	b1ntn4k7GL9cdj/EKMDBqMTDu0PjU4YQa2JZcWXuIUYJDmYlEV6Ggg8ZQrwpiZVVqUX58UWl
	OanFhxilOViUxHm9wlMThATSE0tSs1NTC1KLYLJMHJxSDYy3r75I3x514BHbf3GO/Zxx0V7J
	//8fV22fVft3lRA714/vWt1yipfZdr/WrHCKXMuw4elL3X9z7k2/ccXi/L1rghcFgyVEJUxf
	sx3mPTbzmbjX2Xmm329fC3r+qd/CuVXFi8kvd+PXrV/caydab1x2J+r31ZjgwB7RfPHya4Es
	7Z45mRdmr96kxFKckWioxVxUnAgAhTkI7bsCAAA=
X-CFilter-Loop: Reflected

On Fri, Oct 17, 2025 at 08:13:14AM -0700, Mina Almasry wrote:
> On Fri, Oct 17, 2025 at 5:32 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
> >
> > On 10/16/25 08:21, Byungchul Park wrote:
> > > On Thu, Oct 16, 2025 at 03:36:57PM +0900, Byungchul Park wrote:
> > >> ->pp_magic field in struct page is current used to identify if a page
> > >> belongs to a page pool.  However, ->pp_magic will be removed and page
> > >> type bit in struct page e.g. PGTY_netpp should be used for that purpose.
> > >>
> > >> As a preparation, the check for net_iov, that is not page-backed, should
> > >> avoid using ->pp_magic since net_iov doens't have to do with page type.
> > >> Instead, nmdesc->pp can be used if a net_iov or its nmdesc belongs to a
> > >> page pool, by making sure nmdesc->pp is NULL otherwise.
> > >>
> > >> For page-backed netmem, just leave unchanged as is, while for net_iov,
> > >> make sure nmdesc->pp is initialized to NULL and use nmdesc->pp for the
> > >> check.
> > >
> > > IIRC,
> > >
> > > Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
> >
> > Pointing out a problem in a patch with a fix doesn't qualify to
> > me as "suggested-by", you don't need to worry about that.
> >
> > Did you get the PGTY bits merged? There is some uneasiness about
> > this patch as it does nothing good by itself, it'd be much better
> > to have it in a series finalising the page_pool conversion. And
> > I don't think it simplify merging anyhow, hmm?
> >
> 
> +1 honestly.
> 
> If you want to 'extract the networking bits' into its own patch,  let
> it be a patch series where this is a patch doing pre-work, and the
> next patches in the series are adding the page_flag.

Okay.  Then is it possible that one for mm tree and the other for
net-next in the same patch series?  I've never tried patches that way.

> I don't want added netmem_is_net_iov checks unnecessarily tbh. These
> checks are bad and only used when absolutely necessary, so let the
> patch series that adds them also do something useful (i.e. add the
> page flag), if possible. But I honestly think this patch was almost
> good as-is:

Hm.. but the following patch includes both networking changes and mm
changes.  Jakub thinks it should go to mm and I don't know how Andrew
thinks it should be.  It's not clear even to me.

That's why I splitted it into two, and this is the networking part, and
I will post the mm part to mm folks later.  Any suggestions?

	Byungchul

> https://lore.kernel.org/all/20250729110210.48313-1-byungchul@sk.com/
> 
> You just need to address Jakub's review comments and resubmit? Not
> sure why we want to split, but if you want let it be a patch series
> that does something useful.
> 
> --
> Thanks,
> Mina

