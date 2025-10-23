Return-Path: <io-uring+bounces-10153-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0741DBFFEB0
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 10:28:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 973E51887171
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 08:28:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 519DA2F7468;
	Thu, 23 Oct 2025 08:28:04 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBA9E2BDC15;
	Thu, 23 Oct 2025 08:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.125.252.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761208084; cv=none; b=XNzYPoliIu4lrYEcAgWW3BMEYfxkKkwL+nrSMSh9XBPfC/sJNLgXfpybHvMonF+fDNWwReNUQ1bkBeUoTpB2fwzAo5KhEM/V/T9q+ZTQLYGusbjEh80UXX5i3RIA9z+j6t+7cqPueQNEEcERgLpAJtfUZ/BsLayia4FYgjs3LtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761208084; c=relaxed/simple;
	bh=AUgJ3Jmn3m2RnEHWD18AOjigfIzZkqbCx9HFiI29QkE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DzFPdJjrNVqdPaPvncRvctHCDsklCtiYfY42tBDaMJFIt/bGdJWgY/3LhNNCxP199WjbgwqFTKSBF2MKk8OCp59IFYIfvQ3cP9hXUfsyi1+0MlJG+eKJ6ztqz3IsCI3HBarJU0PV4tchGz57tPJSf8MMxwpMcsn6juDum3liK88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com; spf=pass smtp.mailfrom=sk.com; arc=none smtp.client-ip=166.125.252.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sk.com
X-AuditID: a67dfc5b-c2dff70000001609-2b-68f9e70bae0f
Date: Thu, 23 Oct 2025 17:27:50 +0900
From: Byungchul Park <byungchul@sk.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: axboe@kernel.dk, kuba@kernel.org, pabeni@redhat.com,
	almasrymina@google.com, davem@davemloft.net, edumazet@google.com,
	horms@kernel.org, hawk@kernel.org, ilias.apalodimas@linaro.org,
	sdf@fomichev.me, dw@davidwei.uk, ap420073@gmail.com,
	dtatulea@nvidia.com, toke@redhat.com, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	kernel_team@skhynix.com, max.byungchul.park@gmail.com
Subject: Re: [PATCH net-next] page_pool: check if nmdesc->pp is !NULL to
 confirm its usage as pp for net_iov
Message-ID: <20251023082750.GA11851@system.software.com>
References: <20251016063657.81064-1-byungchul@sk.com>
 <20251016072132.GA19434@system.software.com>
 <8d833a3f-ae18-4ea6-9092-ddaa48290a63@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d833a3f-ae18-4ea6-9092-ddaa48290a63@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsXC9ZZnoS73858ZBtv3KVus/lFh8XPNcyaL
	Oau2MVqsvtvPZjHnfAuLxc5dzxktXs1Yy2bx9Ngjdos97duZLR71n2Cz6G35zWzxrvUci8WF
	bX2sFpd3zWGzuDCxl9Xi2AIxi2+n3zBaXJ25i8ni0uFHLA7CHltW3mTyuDZjIovHjX2nmDx2
	zrrL7rFgU6nH5bOlHptWdbJ53Lm2h82jt/kdm8f7fVfZPD5vkgvgjuKySUnNySxLLdK3S+DK
	mNK+gblgvlDFon3T2BsYP/F2MXJySAiYSKzacZ4Rxr52YSpzFyMHB4uAqsSKZ+ogYTYBdYkb
	N34yg9giAtoSr68fYu9i5OJgFljOLHHz4gugBDuHsECexDNjkBJeAQuJmW2TGUFKhASmM0pc
	+T+dDSIhKHFy5hMWEJtZQEvixr+XTCCrmAWkJZb/4wAJcwrYSjzc+QWsRFRAWeLAtuNMIHMk
	BDaxS5z9tZcF4kxJiYMrbrBMYBSYhWTsLCRjZyGMXcDIvIpRKDOvLDcxM8dEL6MyL7NCLzk/
	dxMjMAqX1f6J3sH46ULwIUYBDkYlHl6H4z8yhFgTy4orcw8xSnAwK4nwlkUChXhTEiurUovy
	44tKc1KLDzFKc7AoifMafStPERJITyxJzU5NLUgtgskycXBKNTAy3Aldv4v1g8GFrpd7+S4H
	3zViOJi7NJXJN6fUabY0q4TKz/ln3ff+5U5M23e27cLVG45NUt+3//v8nn3n5NWZGy5aWta+
	/OMqerZ4mrPGn8RG4TVaJ1a/mBLRIyCX4MGSe2SmjpairGHT6pTaQ5Gz52z02XKh6Urc88XP
	rduK4g98ZFv3Lve6EktxRqKhFnNRcSIA5i0Vnr4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsXC5WfdrMv9/GeGQecFIYvVPyosfq55zmQx
	Z9U2RovVd/vZLOacb2Gx2LnrOaPFqxlr2SyeHnvEbrGnfTuzxaP+E2wWvS2/mS3etZ5jsTg8
	9ySrxYVtfawWl3fNYbO4MLGX1eLYAjGLb6ffMFpcnbmLyeLS4UcsDiIeW1beZPK4NmMii8eN
	faeYPHbOusvusWBTqcfls6Uem1Z1snncubaHzaO3+R2bx/t9V9k8Fr/4wOTxeZNcAE8Ul01K
	ak5mWWqRvl0CV8aU9g3MBfOFKhbtm8bewPiJt4uRk0NCwETi2oWpzF2MHBwsAqoSK56pg4TZ
	BNQlbtz4yQxiiwhoS7y+foi9i5GLg1lgObPEzYsvgBLsHMICeRLPjEFKeAUsJGa2TWYEKRES
	mM4oceX/dDaIhKDEyZlPWEBsZgEtiRv/XjKBrGIWkJZY/o8DJMwpYCvxcOcXsBJRAWWJA9uO
	M01g5J2FpHsWku5ZCN0LGJlXMYpk5pXlJmbmmOoVZ2dU5mVW6CXn525iBMbUsto/E3cwfrns
	fohRgINRiYfX4fiPDCHWxLLiytxDjBIczEoivGWRQCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8
	XuGpCUIC6YklqdmpqQWpRTBZJg5OqQbGE648Hp+zDS6G+Z1WOejJX66rmit3WOBC9bWY06vu
	VF53lrnyTVtnVsDSxjgdU5vbHg9yf8b1Xd+d/fVIbyFv2quZ96x6niluOnlMir0xdWrlnl/6
	+t3xJXz77PJLt18LyVtxuTNwRpbmg7Jrf3K2rM9Xk46rtF05/153Vpf/LNXkpijjqUuVWIoz
	Eg21mIuKEwH3xgZVpQIAAA==
X-CFilter-Loop: Reflected

On Fri, Oct 17, 2025 at 01:33:43PM +0100, Pavel Begunkov wrote:
> On 10/16/25 08:21, Byungchul Park wrote:
> > On Thu, Oct 16, 2025 at 03:36:57PM +0900, Byungchul Park wrote:
> > > ->pp_magic field in struct page is current used to identify if a page
> > > belongs to a page pool.  However, ->pp_magic will be removed and page
> > > type bit in struct page e.g. PGTY_netpp should be used for that purpose.
> > > 
> > > As a preparation, the check for net_iov, that is not page-backed, should
> > > avoid using ->pp_magic since net_iov doens't have to do with page type.
> > > Instead, nmdesc->pp can be used if a net_iov or its nmdesc belongs to a
> > > page pool, by making sure nmdesc->pp is NULL otherwise.
> > > 
> > > For page-backed netmem, just leave unchanged as is, while for net_iov,
> > > make sure nmdesc->pp is initialized to NULL and use nmdesc->pp for the
> > > check.
> > 
> > IIRC,
> > 
> > Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
> 
> Pointing out a problem in a patch with a fix doesn't qualify to
> me as "suggested-by", you don't need to worry about that.
> 
> Did you get the PGTY bits merged? There is some uneasiness about
> this patch as it does nothing good by itself, it'd be much better
> to have it in a series finalising the page_pool conversion. And

I also considered that.  However, I think the finalizing e.i. removing
pp fields in struct page, would better be done once every thing else has
been ready, so that I can focus on examining more thoroughly if there
aren't accesses through struct page and it can be fianlized safely :-)

	Byungchul

> I don't think it simplify merging anyhow, hmm?
> 
> ...>> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> > > index 723e4266b91f..cf78227c0ca6 100644
> > > --- a/io_uring/zcrx.c
> > > +++ b/io_uring/zcrx.c
> > > @@ -450,6 +450,10 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
> > >              area->freelist[i] = i;
> > >              atomic_set(&area->user_refs[i], 0);
> > >              niov->type = NET_IOV_IOURING;
> > > +
> > > +            /* niov->desc.pp is already initialized to NULL by
> > > +             * kvmalloc_array(__GFP_ZERO).
> > > +             */
> 
> Please drop this hunk if you'll be resubmitting, it's not
> needed.
> 
> --
> Pavel Begunkov

