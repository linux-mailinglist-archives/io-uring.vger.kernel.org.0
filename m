Return-Path: <io-uring+bounces-10043-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EA98CBE6A8E
	for <lists+io-uring@lfdr.de>; Fri, 17 Oct 2025 08:27:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 87A3919C0ECB
	for <lists+io-uring@lfdr.de>; Fri, 17 Oct 2025 06:27:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2890A30E83B;
	Fri, 17 Oct 2025 06:26:36 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A197330F951;
	Fri, 17 Oct 2025 06:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.125.252.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760682396; cv=none; b=b8rEW4UdAtPWuW7jZ/+qOefWfWizHXRgJMOM/R1eqZuUtTOZksPRXpcSVLRxbrDHiusaDfRcEjxOBQBAKsTXyNJFL7eWgxPG/aFp5V+H2Dtut4eSQ7mh3L3YSuddSSikevkIAe5rty6rNnF4taqxXMAGREBpEYkZZEcRmL/3Sd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760682396; c=relaxed/simple;
	bh=28OhauPmUcAgORsj2s2x+3Bd/Y90rouYgwE26pYkae0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lh7Tqioh3jt0WOKJhigFr9yd1ByFFiHOuw2lUafnVPQ5NiR5SUsTSUWLDi7W9ckLZrWrRQv6knljFHUc5vNQb/bM56CbMxnK4jXci4hlc8unKRBbgg+ok9bMLvnyjndYOvyQ+PxJMTOeCWXMzyEnyJ2Zv4BEU9BpGcwYKXPdX+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com; spf=pass smtp.mailfrom=sk.com; arc=none smtp.client-ip=166.125.252.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sk.com
X-AuditID: a67dfc5b-c45ff70000001609-77-68f1e18c2a50
Date: Fri, 17 Oct 2025 15:26:14 +0900
From: Byungchul Park <byungchul@sk.com>
To: almasrymina@google.com
Cc: davem@davemloft.net, edumazet@google.com, horms@kernel.org,
	hawk@kernel.org, ilias.apalodimas@linaro.org, sdf@fomichev.me,
	dw@davidwei.uk, ap420073@gmail.com, dtatulea@nvidia.com,
	toke@redhat.com, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	kernel_team@skhynix.com, max.byungchul.park@gmail.com,
	ziy@nvidia.com, willy@infradead.org, david@redhat.com,
	axboe@kernel.dk, kuba@kernel.org, pabeni@redhat.com,
	asml.silence@gmail.com
Subject: Re: [PATCH net-next] page_pool: check if nmdesc->pp is !NULL to
 confirm its usage as pp for net_iov
Message-ID: <20251017062614.GA57077@system.software.com>
References: <20251016063657.81064-1-byungchul@sk.com>
 <20251016233139.GA37304@system.software.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251016233139.GA37304@system.software.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsXC9ZZnoW7Pw48ZBq+nyVqs/lFh8XPNcyaL
	Oau2MVqsvtvPZjHnfAuLxdf1v5gtdu56zmjxasZaNounxx6xW+xp385s8aj/BJtFb8tvZot3
	redYLC5s62O1uLxrDpvFhYm9rBbHFohZfDv9htHi6sxdTBaXDj9isfj9Ayg5++g9dgcxjy0r
	bzJ5XJsxkcXjxr5TTB47Z91l91iwqdRj8wotj8tnSz02repk87hzbQ+bR2/zOzaP9/uusnl8
	3iQXwBPFZZOSmpNZllqkb5fAldG2qpu54KNKxfwnq9gaGOfKdjFyckgImEhs/LSdFcZu2HOH
	HcRmEVCVuLdkGzOIzSagLnHjxk8wW0RASuLC4vtsXYxcHMwCj5gl5i/fy9jFyM4hLJAn8cwY
	pIRXwELi8MNGRhBbSCBF4n7XK2aIuKDEyZlPWEBsZgEtiRv/XjJ1MXIA2dISy/9xgIQ5BSwl
	DrUtAisXFVCWOLDtOBPIJgmBU+wSG5/9ZYE4U1Li4IobLBMYBWYhGTsLydhZCGMXMDKvYhTK
	zCvLTczMMdHLqMzLrNBLzs/dxAiM1WW1f6J3MH66EHyIUYCDUYmHd4HRxwwh1sSy4srcQ4wS
	HMxKIrwMBR8yhHhTEiurUovy44tKc1KLDzFKc7AoifMafStPERJITyxJzU5NLUgtgskycXBK
	NTDmchQWHZH/6D0/x1KgdbNOqZgI581zCzt/VXjF8E28lr23g23CsXN7uhIk7nyxn5Zg7y9w
	8PuPrUf2zNv28MW/hryLM1t2Wp9V56/QqJz2wlza7apeuiW3fW17HduSe86FF0XLO62utqoL
	1sTLNr+dKlS0/M1ihk0TzR5eafR+9zv5wewPZjuVWIozEg21mIuKEwG8CO130QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsXC5WfdrNvz8GOGQUM/u8XqHxUWP9c8Z7KY
	s2obo8Xqu/1sFnPOt7BYfF3/i9li567njBavZqxls3h67BG7xZ727cwWj/pPsFn0tvxmtnjX
	eo7F4vDck6wWF7b1sVpc3jWHzeLCxF5Wi2MLxCy+nX7DaHF15i4mi0uHH7FY/P4BlJx99B67
	g7jHlpU3mTyuzZjI4nFj3ykmj52z7rJ7LNhU6rF5hZbH5bOlHptWdbJ53Lm2h82jt/kdm8f7
	fVfZPBa/+MDk8XmTXABvFJdNSmpOZllqkb5dAldG26pu5oKPKhXzn6xia2CcK9vFyMkhIWAi
	0bDnDjuIzSKgKnFvyTZmEJtNQF3ixo2fYLaIgJTEhcX32boYuTiYBR4xS8xfvpexi5GdQ1gg
	T+KZMUgJr4CFxOGHjYwgtpBAisT9rlfMEHFBiZMzn7CA2MwCWhI3/r1k6mLkALKlJZb/4wAJ
	cwpYShxqWwRWLiqgLHFg23GmCYy8s5B0z0LSPQuhewEj8ypGkcy8stzEzBxTveLsjMq8zAq9
	5PzcTYzAyFtW+2fiDsYvl90PMQpwMCrx8Hoc+5ghxJpYVlyZe4hRgoNZSYSXoeBDhhBvSmJl
	VWpRfnxRaU5q8SFGaQ4WJXFer/DUBCGB9MSS1OzU1ILUIpgsEwenVAPjbr4LqV7/LH6nhh7c
	6+r667TNT46cuant00Ss4zf/kRHmX5jXPNHw1JW5FX7K93pfz5gYYK65X23rnv1pxw8bKv8+
	sHpde1lk7He1rQmTfwvvNQng2rFx642QOU6HNGs36Wrxn+Z95DKpcY1G+czqfY6TBBsufTpS
	0VQe2/ZbbdOuGzPE5y3kUWIpzkg01GIuKk4EADV5eNO4AgAA
X-CFilter-Loop: Reflected

On Fri, Oct 17, 2025 at 08:31:39AM +0900, Byungchul Park wrote:
> On Thu, Oct 16, 2025 at 03:36:57PM +0900, Byungchul Park wrote:
> > ->pp_magic field in struct page is current used to identify if a page
> > belongs to a page pool.  However, ->pp_magic will be removed and page
> > type bit in struct page e.g. PGTY_netpp should be used for that purpose.
> > 
> > As a preparation, the check for net_iov, that is not page-backed, should
> > avoid using ->pp_magic since net_iov doens't have to do with page type.
> > Instead, nmdesc->pp can be used if a net_iov or its nmdesc belongs to a
> > page pool, by making sure nmdesc->pp is NULL otherwise.
> > 
> > For page-backed netmem, just leave unchanged as is, while for net_iov,
> > make sure nmdesc->pp is initialized to NULL and use nmdesc->pp for the
> > check.

Hi Mina,

This patch extracts the network part from the following work:

  https://lore.kernel.org/all/20250729110210.48313-1-byungchul@sk.com/

Can I keep your reviewed-by tag on this patch?

  Reviewed-by: Mina Almasry <almasrymina@google.com>

	Byungchul

> +cc David Hildenbrand <david@redhat.com>
> +cc Zi Yan <ziy@nvidia.com>
> +cc willy@infradead.org
> 
> 	Byungchul
> > 
> > Signed-off-by: Byungchul Park <byungchul@sk.com>
> > ---
> >  io_uring/zcrx.c        |  4 ++++
> >  net/core/devmem.c      |  1 +
> >  net/core/netmem_priv.h |  6 ++++++
> >  net/core/page_pool.c   | 16 ++++++++++++++--
> >  4 files changed, 25 insertions(+), 2 deletions(-)
> > 
> > diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> > index 723e4266b91f..cf78227c0ca6 100644
> > --- a/io_uring/zcrx.c
> > +++ b/io_uring/zcrx.c
> > @@ -450,6 +450,10 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
> >  		area->freelist[i] = i;
> >  		atomic_set(&area->user_refs[i], 0);
> >  		niov->type = NET_IOV_IOURING;
> > +
> > +		/* niov->desc.pp is already initialized to NULL by
> > +		 * kvmalloc_array(__GFP_ZERO).
> > +		 */
> >  	}
> >  
> >  	area->free_count = nr_iovs;
> > diff --git a/net/core/devmem.c b/net/core/devmem.c
> > index d9de31a6cc7f..f81b700f1fd1 100644
> > --- a/net/core/devmem.c
> > +++ b/net/core/devmem.c
> > @@ -291,6 +291,7 @@ net_devmem_bind_dmabuf(struct net_device *dev,
> >  			niov = &owner->area.niovs[i];
> >  			niov->type = NET_IOV_DMABUF;
> >  			niov->owner = &owner->area;
> > +			niov->desc.pp = NULL;
> >  			page_pool_set_dma_addr_netmem(net_iov_to_netmem(niov),
> >  						      net_devmem_get_dma_addr(niov));
> >  			if (direction == DMA_TO_DEVICE)
> > diff --git a/net/core/netmem_priv.h b/net/core/netmem_priv.h
> > index 23175cb2bd86..fb21cc19176b 100644
> > --- a/net/core/netmem_priv.h
> > +++ b/net/core/netmem_priv.h
> > @@ -22,6 +22,12 @@ static inline void netmem_clear_pp_magic(netmem_ref netmem)
> >  
> >  static inline bool netmem_is_pp(netmem_ref netmem)
> >  {
> > +	/* Use ->pp for net_iov to identify if it's pp, which requires
> > +	 * that non-pp net_iov should have ->pp NULL'd.
> > +	 */
> > +	if (netmem_is_net_iov(netmem))
> > +		return !!netmem_to_nmdesc(netmem)->pp;
> > +
> >  	return (netmem_get_pp_magic(netmem) & PP_MAGIC_MASK) == PP_SIGNATURE;
> >  }
> >  
> > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > index 1a5edec485f1..2756b78754b0 100644
> > --- a/net/core/page_pool.c
> > +++ b/net/core/page_pool.c
> > @@ -699,7 +699,13 @@ s32 page_pool_inflight(const struct page_pool *pool, bool strict)
> >  void page_pool_set_pp_info(struct page_pool *pool, netmem_ref netmem)
> >  {
> >  	netmem_set_pp(netmem, pool);
> > -	netmem_or_pp_magic(netmem, PP_SIGNATURE);
> > +
> > +	/* For page-backed, pp_magic is used to identify if it's pp.
> > +	 * For net_iov, it's ensured nmdesc->pp is non-NULL if it's pp
> > +	 * and nmdesc->pp is NULL if it's not.
> > +	 */
> > +	if (!netmem_is_net_iov(netmem))
> > +		netmem_or_pp_magic(netmem, PP_SIGNATURE);
> >  
> >  	/* Ensuring all pages have been split into one fragment initially:
> >  	 * page_pool_set_pp_info() is only called once for every page when it
> > @@ -714,7 +720,13 @@ void page_pool_set_pp_info(struct page_pool *pool, netmem_ref netmem)
> >  
> >  void page_pool_clear_pp_info(netmem_ref netmem)
> >  {
> > -	netmem_clear_pp_magic(netmem);
> > +	/* For page-backed, pp_magic is used to identify if it's pp.
> > +	 * For net_iov, it's ensured nmdesc->pp is non-NULL if it's pp
> > +	 * and nmdesc->pp is NULL if it's not.
> > +	 */
> > +	if (!netmem_is_net_iov(netmem))
> > +		netmem_clear_pp_magic(netmem);
> > +
> >  	netmem_set_pp(netmem, NULL);
> >  }
> >  
> > 
> > base-commit: e1f5bb196f0b0eee197e06d361f8ac5f091c2963
> > -- 
> > 2.17.1

