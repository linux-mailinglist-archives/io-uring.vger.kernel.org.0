Return-Path: <io-uring+bounces-10024-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56F16BE1E35
	for <lists+io-uring@lfdr.de>; Thu, 16 Oct 2025 09:21:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A3894835CB
	for <lists+io-uring@lfdr.de>; Thu, 16 Oct 2025 07:21:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43C5E23C8AE;
	Thu, 16 Oct 2025 07:21:47 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 452251EE019;
	Thu, 16 Oct 2025 07:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.125.252.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760599307; cv=none; b=EviiXTo1cFeHk7ybsCO5DkQyUl6rEYCo8JPX+ggkUbL6UyT2+p5oi9Tnn5sHo87eQ9iEf0LYhj5/4lYGE42xKe7q+idXsFW6E57yH0JnNaNo9Hv10RFMMrxREPlY76jmud6Aq63MisOGRdNhs4HVxZv8FzanTG8cXbMfKL0x6lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760599307; c=relaxed/simple;
	bh=EJXNHgEM/c6BAiZKCxEAAJsXGxgydll/3KwHHRXA9qQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AwVzwaVFIw4pS3SwIbxV/1uDhjqrq2RGJXTC5Xznkcq5blIZBzJwMvB4XVbwaiQt7wtpZX2L5cHoqJokhFgqfB4IOqX7xZU30PF8ATmJ8hVRSV3JHt6hRDcasamhZkW2yTQxWCFPd6Hi7bJHVQZOtbIHrz7mxKChOPMUECO56pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com; spf=pass smtp.mailfrom=sk.com; arc=none smtp.client-ip=166.125.252.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sk.com
X-AuditID: a67dfc5b-c45ff70000001609-70-68f09d01a5d2
Date: Thu, 16 Oct 2025 16:21:32 +0900
From: Byungchul Park <byungchul@sk.com>
To: axboe@kernel.dk, kuba@kernel.org, pabeni@redhat.com,
	almasrymina@google.com, asml.silence@gmail.com
Cc: davem@davemloft.net, edumazet@google.com, horms@kernel.org,
	hawk@kernel.org, ilias.apalodimas@linaro.org, sdf@fomichev.me,
	dw@davidwei.uk, ap420073@gmail.com, dtatulea@nvidia.com,
	toke@redhat.com, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	kernel_team@skhynix.com, max.byungchul.park@gmail.com
Subject: Re: [PATCH net-next] page_pool: check if nmdesc->pp is !NULL to
 confirm its usage as pp for net_iov
Message-ID: <20251016072132.GA19434@system.software.com>
References: <20251016063657.81064-1-byungchul@sk.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251016063657.81064-1-byungchul@sk.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsXC9ZZnkS7T3A8ZBns2c1is/lFh8XPNcyaL
	Oau2MVqsvtvPZjHnfAuLxc5dzxktXs1Yy2bx9Ngjdos97duZLR71n2Cz6G35zWzxrvUci8WF
	bX2sFpd3zWGzuDCxl9Xi2AIxi2+n3zBaXJ25i8ni0uFHLA7CHltW3mTyuDZjIovHjX2nmDx2
	zrrL7rFgU6nH5bOlHptWdbJ53Lm2h82jt/kdm8f7fVfZPD5vkgvgjuKySUnNySxLLdK3S+DK
	eHp4BXPBUoWKlZOnMjYwNkp1MXJwSAiYSLzf4t/FyAlm7l39jxHEZhFQlejoe8QOYrMJqEvc
	uPGTGcQWEciU6Jp8Hcjm4mAWuMEkMfvrFtYuRnYOYYE8iWfGICW8AhYSR4/9AysXEjCVeHv+
	AzNEXFDi5MwnLCA2s4CWxI1/L5lALmAWkJZY/o8DJMwpYCbxfd47VhBbVEBZ4sC240wgmyQE
	NrFLzL74nxHiTEmJgytusExgFJiFZOwsJGNnIYxdwMi8ilEoM68sNzEzx0QvozIvs0IvOT93
	EyMwBpfV/onewfjpQvAhRgEORiUe3gcr3mcIsSaWFVfmHmKU4GBWEuFlKPiQIcSbklhZlVqU
	H19UmpNafIhRmoNFSZzX6Ft5ipBAemJJanZqakFqEUyWiYNTqoGxurxw0j8Wi/cPP/SyWKyQ
	WZxz/bjiwjU1xn8r9U6sDF//t+S11/rm+bv9s20fLrmlvu1tW7W3cEPyPsazeUbeAoHVleL8
	tXFLzL/ZK8Q2b5w2Zc21Cd9vdf0OZdBS3jnj9lTubfN732y5e9jvjfHaUzemtH/tWFK6MXZp
	3eaVM9cvW1Zx9svscCWW4oxEQy3mouJEAFZ2F+e9AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsXC5WfdrMs490OGwbnZpharf1RY/FzznMli
	zqptjBar7/azWcw538JisXPXc0aLVzPWslk8PfaI3WJP+3Zmi0f9J9gselt+M1u8az3HYnF4
	7klWiwvb+lgtLu+aw2ZxYWIvq8WxBWIW306/YbS4OnMXk8Wlw49YHEQ8tqy8yeRxbcZEFo8b
	+04xeeycdZfdY8GmUo/LZ0s9Nq3qZPO4c20Pm0dv8zs2j/f7rrJ5LH7xgcnj8ya5AJ4oLpuU
	1JzMstQifbsEroynh1cwFyxVqFg5eSpjA2OjVBcjJ4eEgInE3tX/GEFsFgFViY6+R+wgNpuA
	usSNGz+ZQWwRgUyJrsnXgWwuDmaBG0wSs79uYe1iZOcQFsiTeGYMUsIrYCFx9Ng/sHIhAVOJ
	t+c/MEPEBSVOznzCAmIzC2hJ3Pj3kqmLkQPIlpZY/o8DJMwpYCbxfd47VhBbVEBZ4sC240wT
	GHlnIemehaR7FkL3AkbmVYwimXlluYmZOaZ6xdkZlXmZFXrJ+bmbGIExtaz2z8QdjF8uux9i
	FOBgVOLhfbDifYYQa2JZcWXuIUYJDmYlEV6Ggg8ZQrwpiZVVqUX58UWlOanFhxilOViUxHm9
	wlMThATSE0tSs1NTC1KLYLJMHJxSDYyH/Q+/jPUq3unscvvsj49y4YGJt6sqb88KfH66OP78
	jtXvZ645HBnbIWWwZGfKuZ+M1bWrs26HS8mq2vofF19o/v2jKO/0alONF0vS9p5cs7R1n/0z
	7wiF+9mmUakJyw58NBP8mf7h4rZ1Z3XneonULP3q5CUnxb900bG76tuEdxxxvfL39kQRJZbi
	jERDLeai4kQABs+akaUCAAA=
X-CFilter-Loop: Reflected

On Thu, Oct 16, 2025 at 03:36:57PM +0900, Byungchul Park wrote:
> ->pp_magic field in struct page is current used to identify if a page
> belongs to a page pool.  However, ->pp_magic will be removed and page
> type bit in struct page e.g. PGTY_netpp should be used for that purpose.
> 
> As a preparation, the check for net_iov, that is not page-backed, should
> avoid using ->pp_magic since net_iov doens't have to do with page type.
> Instead, nmdesc->pp can be used if a net_iov or its nmdesc belongs to a
> page pool, by making sure nmdesc->pp is NULL otherwise.
> 
> For page-backed netmem, just leave unchanged as is, while for net_iov,
> make sure nmdesc->pp is initialized to NULL and use nmdesc->pp for the
> check.

IIRC,

Suggested-by: Pavel Begunkov <asml.silence@gmail.com>

	Byungchul

> Signed-off-by: Byungchul Park <byungchul@sk.com>
> ---
>  io_uring/zcrx.c        |  4 ++++
>  net/core/devmem.c      |  1 +
>  net/core/netmem_priv.h |  6 ++++++
>  net/core/page_pool.c   | 16 ++++++++++++++--
>  4 files changed, 25 insertions(+), 2 deletions(-)
> 
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index 723e4266b91f..cf78227c0ca6 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> @@ -450,6 +450,10 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
>  		area->freelist[i] = i;
>  		atomic_set(&area->user_refs[i], 0);
>  		niov->type = NET_IOV_IOURING;
> +
> +		/* niov->desc.pp is already initialized to NULL by
> +		 * kvmalloc_array(__GFP_ZERO).
> +		 */
>  	}
>  
>  	area->free_count = nr_iovs;
> diff --git a/net/core/devmem.c b/net/core/devmem.c
> index d9de31a6cc7f..f81b700f1fd1 100644
> --- a/net/core/devmem.c
> +++ b/net/core/devmem.c
> @@ -291,6 +291,7 @@ net_devmem_bind_dmabuf(struct net_device *dev,
>  			niov = &owner->area.niovs[i];
>  			niov->type = NET_IOV_DMABUF;
>  			niov->owner = &owner->area;
> +			niov->desc.pp = NULL;
>  			page_pool_set_dma_addr_netmem(net_iov_to_netmem(niov),
>  						      net_devmem_get_dma_addr(niov));
>  			if (direction == DMA_TO_DEVICE)
> diff --git a/net/core/netmem_priv.h b/net/core/netmem_priv.h
> index 23175cb2bd86..fb21cc19176b 100644
> --- a/net/core/netmem_priv.h
> +++ b/net/core/netmem_priv.h
> @@ -22,6 +22,12 @@ static inline void netmem_clear_pp_magic(netmem_ref netmem)
>  
>  static inline bool netmem_is_pp(netmem_ref netmem)
>  {
> +	/* Use ->pp for net_iov to identify if it's pp, which requires
> +	 * that non-pp net_iov should have ->pp NULL'd.
> +	 */
> +	if (netmem_is_net_iov(netmem))
> +		return !!netmem_to_nmdesc(netmem)->pp;
> +
>  	return (netmem_get_pp_magic(netmem) & PP_MAGIC_MASK) == PP_SIGNATURE;
>  }
>  
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 1a5edec485f1..2756b78754b0 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -699,7 +699,13 @@ s32 page_pool_inflight(const struct page_pool *pool, bool strict)
>  void page_pool_set_pp_info(struct page_pool *pool, netmem_ref netmem)
>  {
>  	netmem_set_pp(netmem, pool);
> -	netmem_or_pp_magic(netmem, PP_SIGNATURE);
> +
> +	/* For page-backed, pp_magic is used to identify if it's pp.
> +	 * For net_iov, it's ensured nmdesc->pp is non-NULL if it's pp
> +	 * and nmdesc->pp is NULL if it's not.
> +	 */
> +	if (!netmem_is_net_iov(netmem))
> +		netmem_or_pp_magic(netmem, PP_SIGNATURE);
>  
>  	/* Ensuring all pages have been split into one fragment initially:
>  	 * page_pool_set_pp_info() is only called once for every page when it
> @@ -714,7 +720,13 @@ void page_pool_set_pp_info(struct page_pool *pool, netmem_ref netmem)
>  
>  void page_pool_clear_pp_info(netmem_ref netmem)
>  {
> -	netmem_clear_pp_magic(netmem);
> +	/* For page-backed, pp_magic is used to identify if it's pp.
> +	 * For net_iov, it's ensured nmdesc->pp is non-NULL if it's pp
> +	 * and nmdesc->pp is NULL if it's not.
> +	 */
> +	if (!netmem_is_net_iov(netmem))
> +		netmem_clear_pp_magic(netmem);
> +
>  	netmem_set_pp(netmem, NULL);
>  }
>  
> 
> base-commit: e1f5bb196f0b0eee197e06d361f8ac5f091c2963
> -- 
> 2.17.1

