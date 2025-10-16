Return-Path: <io-uring+bounces-10042-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E0D7BE5CCA
	for <lists+io-uring@lfdr.de>; Fri, 17 Oct 2025 01:32:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 02D781A66553
	for <lists+io-uring@lfdr.de>; Thu, 16 Oct 2025 23:32:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E160227F19B;
	Thu, 16 Oct 2025 23:31:54 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E27B33468B;
	Thu, 16 Oct 2025 23:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.125.252.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760657514; cv=none; b=XX403+4cy49ebQOXfAB9259GfBLwDMZM6cqjHK3LHOwwO8pQi2Ivwc1dEsVK1/6dxL89Fs90qocAtYq3KUGu/TtZSX+njqQW3Xb7n3Ez4hl0oMTJ9ZeaSlbck1z5vinTulMwpK44m/OBiOi3sZZ39qWCPwSSzAqdBTO+lCxfbjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760657514; c=relaxed/simple;
	bh=6jNU4d/KiNNzDU38nskytHoALT5q/NWETL5gYn1PHUc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BxjXmbaXQnEdSk5BoIleJM9wvKKRfdM1FkLjTMzewNIns2Q733UZ30L0Ngy7lIrOsiasQqFc7UKntgNpGxuWqIOWqf5vebd4Rb9dH+IpSv/gvqi+FF/QHYGILgRhZr8Xv25Bn4MMbP/KBi63ESKBKBelVQTmRoGT6kcNMj/ix6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com; spf=pass smtp.mailfrom=sk.com; arc=none smtp.client-ip=166.125.252.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sk.com
X-AuditID: a67dfc5b-c2dff70000001609-85-68f180618d69
Date: Fri, 17 Oct 2025 08:31:39 +0900
From: Byungchul Park <byungchul@sk.com>
To: axboe@kernel.dk, kuba@kernel.org, pabeni@redhat.com,
	almasrymina@google.com, asml.silence@gmail.com
Cc: davem@davemloft.net, edumazet@google.com, horms@kernel.org,
	hawk@kernel.org, ilias.apalodimas@linaro.org, sdf@fomichev.me,
	dw@davidwei.uk, ap420073@gmail.com, dtatulea@nvidia.com,
	toke@redhat.com, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	kernel_team@skhynix.com, max.byungchul.park@gmail.com,
	ziy@nvidia.com, willy@infradead.org, david@redhat.com
Subject: Re: [PATCH net-next] page_pool: check if nmdesc->pp is !NULL to
 confirm its usage as pp for net_iov
Message-ID: <20251016233139.GA37304@system.software.com>
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsXC9ZZnkW5iw8cMg/+tfBarf1RY/FzznMli
	zqptjBar7/azWcw538Ji8XX9L2aLnbueM1q8mrGWzeLpsUfsFnvatzNbPOo/wWbR2/Kb2eJd
	6zkWiwvb+lgtLu+aw2ZxYWIvq8WxBWIW306/YbS4OnMXk8Wlw49YLH7/AErOPnqP3UHMY8vK
	m0we12ZMZPG4se8Uk8fOWXfZPRZsKvXYvELL4/LZUo9NqzrZPO5c28Pm0dv8js3j/b6rbB6f
	N8kF8ERx2aSk5mSWpRbp2yVwZbzeqVFwXKHi6e2lLA2M86S6GDk5JARMJN7tP8QKY0/YPI0Z
	xGYRUJX4u2YxO4jNJqAucePGT7C4iECmRNfk60A2FwezwERmiSUn9rJ1MbJzCAvkSTwzBinh
	FbCQ2HuwmxHEFhIwlXh7/gMzRFxQ4uTMJywgNrOAlsSNfy+Zuhg5gGxpieX/OEDCnAJmEt/n
	vQO7RlRAWeLAtuNMIJskBI6xS9y/MYkJ4kxJiYMrbrBMYBSYhWTsLCRjZyGMXcDIvIpRKDOv
	LDcxM8dEL6MyL7NCLzk/dxMjMFKX1f6J3sH46ULwIUYBDkYlHt4FRh8zhFgTy4orcw8xSnAw
	K4nwMhR8yBDiTUmsrEotyo8vKs1JLT7EKM3BoiTOa/StPEVIID2xJDU7NbUgtQgmy8TBKdXA
	WPHjiuWtmiNbnKOUJK+sVrhS+cWB66vj98qDz03i9vg/eqlQddq0M5u34ZDoVSFJufS2P4tr
	3tYzM6xc0SiqMs2e5dreTnO2X7p20Y6Tsv2eHnket0z8JeMNxW7Xpb33y4Kqvnqf+T1LZ+rZ
	P1Ft4j8a7rtcndeg/pZ14t/wmjjLUsP24xnKSizFGYmGWsxFxYkAk0r85tACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsXC5WfdrJvY8DHDYG2axeofFRY/1zxnspiz
	ahujxeq7/WwWc863sFh8Xf+L2WLnrueMFq9mrGWzeHrsEbvFnvbtzBaP+k+wWfS2/Ga2eNd6
	jsXi8NyTrBYXtvWxWlzeNYfN4sLEXlaLYwvELL6dfsNocXXmLiaLS4cfsVj8/gGUnH30HruD
	uMeWlTeZPK7NmMjicWPfKSaPnbPusnss2FTqsXmFlsfls6Uem1Z1snncubaHzaO3+R2bx/t9
	V9k8Fr/4wOTxeZNcAG8Ul01Kak5mWWqRvl0CV8brnRoFxxUqnt5eytLAOE+qi5GTQ0LARGLC
	5mnMIDaLgKrE3zWL2UFsNgF1iRs3foLFRQQyJbomXweyuTiYBSYySyw5sZeti5GdQ1ggT+KZ
	MUgJr4CFxN6D3YwgtpCAqcTb8x+YIeKCEidnPmEBsZkFtCRu/HvJ1MXIAWRLSyz/xwES5hQw
	k/g+7x0riC0qoCxxYNtxpgmMvLOQdM9C0j0LoXsBI/MqRpHMvLLcxMwcU73i7IzKvMwKveT8
	3E2MwKhbVvtn4g7GL5fdDzEKcDAq8fAuNPqYIcSaWFZcmXuIUYKDWUmEl6HgQ4YQb0piZVVq
	UX58UWlOavEhRmkOFiVxXq/w1AQhgfTEktTs1NSC1CKYLBMHp1QDY2eb98OQ+f0Biit0TZf7
	va6y8dS7EHH2wCquCqaV81//MNaqOnWUbSNnyZcXb6YcF39YkJv4lWdP7ccD+68HulxamyvW
	v/zgXKaJN7iCt3IWVDFeryp8FpR+rU+usHhr0N/81WUH/aaYdT59W/M74YaphNaBVKlLpyUT
	1hiy1Vt/O80psFvpnRJLcUaioRZzUXEiAMSUyx22AgAA
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

+cc David Hildenbrand <david@redhat.com>
+cc Zi Yan <ziy@nvidia.com>
+cc willy@infradead.org

	Byungchul
> 
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

