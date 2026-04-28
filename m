Return-Path: <io-uring+bounces-13152-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WKPFDLpr8GlmTQEAu9opvQ
	(envelope-from <io-uring+bounces-13152-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 10:11:38 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C3B2C47FAE2
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 10:11:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DB79A30C1C03
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 07:57:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31ADD2DCC01;
	Tue, 28 Apr 2026 07:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MIsSesFa"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9E640DFD3;
	Tue, 28 Apr 2026 07:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777363034; cv=none; b=nL9AyDNNdS8jJVq3V9MtvkiKD4OTKyqfTuxRhId6NXpOrGwiTGb8LGQXDGEzD6F7H8VeSTEqTERoRpdy8N5ZqbU62WAU30ewm29C8wocrAqe+JmYOL0DTDYMr+fg2rpF4WL42nH3M9gyOplXmPn4I5U58/5xb0K5SdG1BdUUzIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777363034; c=relaxed/simple;
	bh=y2akIwRGt1j1o5S2T/mkGT+ioZe1KnMos++4eTyBphA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cY8FhjogT0oZmRBMO9GkPKPHWc6l3z9EFoPOD8wM+C6V92LfLKF6UtDrF0VZKiFFUS29JBgIVEGLLT4eKNeNUG1mRzLVkx7c/Mkz1Ao2RRXw3kGkLt8x9P5snAsBpZO54taupNsWcYuNBjTOT45d9DsfFT242e80Ndhejd/OJe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MIsSesFa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77E3C2BCAF;
	Tue, 28 Apr 2026 07:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777363033;
	bh=y2akIwRGt1j1o5S2T/mkGT+ioZe1KnMos++4eTyBphA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MIsSesFaSTr1zZmoihbD7wYkorehJI2/CnswUbOtZj3cSTmoPMi+IpNJvL2vGzX7D
	 gA5wJpI7UytgGuuDwbpe/F+f/tfQJhYCIwTdZhjWynVmE3UyJdh0g1IcVLZX4SaCBr
	 jwHQn4ZEkXR2maCdXjfDcpUOsa1M34tsna5zI7jowaEt/5YRwx8TB3BEkFr/PHXShI
	 QXNTCCLTK6TxsUO2/ctirl0lfhD3LWEfs0hyGeyP3kn9BHbvsleHekG26BfNGJjCC2
	 HldsBxwaGedzg4mE/N+ugg7yJd28fGvl4gZpbEzbxXdU6EqV5+TXh4dX0MKTNLtbL3
	 EXtM+Nj4JzfXQ==
Message-ID: <6dcbee42-df9b-4c0a-b153-aad953441fad@kernel.org>
Date: Tue, 28 Apr 2026 09:57:08 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net: add net_iov_init() and use it to initialize
 ->page_type
Content-Language: en-US
To: Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
 Byungchul Park <byungchul@sk.com>
Cc: netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
 andrew+netdev@lunn.ch, horms@kernel.org, asml.silence@gmail.com,
 axboe@kernel.dk, almasrymina@google.com, sdf@fomichev.me, hawk@kernel.org,
 akpm@linux-foundation.org, rppt@kernel.org, io-uring@vger.kernel.org
References: <20260428025320.853452-1-kuba@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260428025320.853452-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C3B2C47FAE2
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13152-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,google.com,redhat.com,lunn.ch,kernel.org,gmail.com,kernel.dk,fomichev.me,linux-foundation.org];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[vbabka@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring,netdev];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,fomichev.me:email]

+Cc Byungchul

On 4/28/26 04:53, Jakub Kicinski wrote:
> Commit db359fccf212 ("mm: introduce a new page type for page pool in
> page type") added a page_type field to struct net_iov at the same
> offset as struct page::page_type, so that page_pool_set_pp_info() can
> call __SetPageNetpp() uniformly on both pages and net_iovs.
> 
> The page-type API requires the field to hold the UINT_MAX "no type"
> sentinel before a type can be set; for real struct page that invariant
> is established by the page allocator on free. struct net_iov is not
> allocated through the page allocator, so the field is left as zero
> (io_uring zcrx, which uses __GFP_ZERO) or as slab garbage (devmem,
> which uses kvmalloc_objs() without zeroing). When the page pool then
> calls page_pool_set_pp_info() on a freshly-bound niov,
> __SetPageNetpp()'s VM_BUG_ON_PAGE(page->page_type != UINT_MAX) fires
> and the kernel BUGs. Triggered in selftests by io_uring zcrx setup
> through the fbnic queue restart path:
> 
>  kernel BUG at ./include/linux/page-flags.h:1062!
>  RIP: 0010:page_pool_set_pp_info (./include/linux/page-flags.h:1062
>                                   net/core/page_pool.c:716)
>  Call Trace:
>   <TASK>
>   net_mp_niov_set_page_pool (net/core/page_pool.c:1360)
>   io_pp_zc_alloc_netmems (io_uring/zcrx.c:1089 io_uring/zcrx.c:1110)
>   fbnic_fill_bdq (./include/net/page_pool/helpers.h:160
>                   drivers/net/ethernet/meta/fbnic/fbnic_txrx.c:906)
>   __fbnic_nv_restart (drivers/net/ethernet/meta/fbnic/fbnic_txrx.c:2470
>                       drivers/net/ethernet/meta/fbnic/fbnic_txrx.c:2874)
>   fbnic_queue_start (drivers/net/ethernet/meta/fbnic/fbnic_txrx.c:2903)
>   netdev_rx_queue_reconfig (net/core/netdev_rx_queue.c:137)
>   __netif_mp_open_rxq (net/core/netdev_rx_queue.c:234)
>   io_register_zcrx (io_uring/zcrx.c:818 io_uring/zcrx.c:903)
>   __io_uring_register (io_uring/register.c:931)
>   __do_sys_io_uring_register (io_uring/register.c:1029)
>   do_syscall_64 (arch/x86/entry/syscall_64.c:63
>                  arch/x86/entry/syscall_64.c:94)
>   </TASK>
> 
> The same path is reachable through devmem dmabuf binding via
> netdev_nl_bind_rx_doit() -> net_devmem_bind_dmabuf_to_queue().
> 
> Add a net_iov_init() helper that stamps ->owner, ->type and the
> ->page_type sentinel, and use it from both the devmem and io_uring
> zcrx niov init loops.
> 
> Fixes: db359fccf212 ("mm: introduce a new page type for page pool in page type")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
> CC: asml.silence@gmail.com
> CC: axboe@kernel.dk
> CC: almasrymina@google.com
> CC: sdf@fomichev.me
> CC: hawk@kernel.org
> CC: akpm@linux-foundation.org
> CC: rppt@kernel.org
> CC: vbabka@kernel.org
> CC: io-uring@vger.kernel.org
> ---
>  include/net/netmem.h | 15 +++++++++++++++
>  io_uring/zcrx.c      |  3 +--
>  net/core/devmem.c    |  3 +--
>  3 files changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/include/net/netmem.h b/include/net/netmem.h
> index 507b74c9f52d..78fe51e5756b 100644
> --- a/include/net/netmem.h
> +++ b/include/net/netmem.h
> @@ -127,6 +127,21 @@ static inline unsigned int net_iov_idx(const struct net_iov *niov)
>  	return niov - net_iov_owner(niov)->niovs;
>  }
>  
> +/* Initialize a niov: stamp the owning area, the memory provider type,
> + * and the page_type "no type" sentinel expected by the page-type API
> + * (see PAGE_TYPE_OPS in <linux/page-flags.h>) so that
> + * page_pool_set_pp_info() can later call __SetPageNetpp() on a niov
> + * cast to struct page.
> + */
> +static inline void net_iov_init(struct net_iov *niov,
> +				struct net_iov_area *owner,
> +				enum net_iov_type type)
> +{
> +	niov->owner = owner;
> +	niov->type = type;
> +	niov->page_type = UINT_MAX;
> +}
> +
>  /* netmem */
>  
>  /**
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index 7b93c87b8371..19837e0b5e91 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> @@ -495,10 +495,9 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
>  	for (i = 0; i < nr_iovs; i++) {
>  		struct net_iov *niov = &area->nia.niovs[i];
>  
> -		niov->owner = &area->nia;
> +		net_iov_init(niov, &area->nia, NET_IOV_IOURING);
>  		area->freelist[i] = i;
>  		atomic_set(&area->user_refs[i], 0);
> -		niov->type = NET_IOV_IOURING;
>  	}
>  
>  	if (ifq->dev) {
> diff --git a/net/core/devmem.c b/net/core/devmem.c
> index cde4c89bc146..468344739db2 100644
> --- a/net/core/devmem.c
> +++ b/net/core/devmem.c
> @@ -297,8 +297,7 @@ net_devmem_bind_dmabuf(struct net_device *dev,
>  
>  		for (i = 0; i < owner->area.num_niovs; i++) {
>  			niov = &owner->area.niovs[i];
> -			niov->type = NET_IOV_DMABUF;
> -			niov->owner = &owner->area;
> +			net_iov_init(niov, &owner->area, NET_IOV_DMABUF);
>  			page_pool_set_dma_addr_netmem(net_iov_to_netmem(niov),
>  						      net_devmem_get_dma_addr(niov));
>  			if (direction == DMA_TO_DEVICE)


