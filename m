Return-Path: <io-uring+bounces-13153-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WCaxOUxx8GldTgEAu9opvQ
	(envelope-from <io-uring+bounces-13153-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 10:35:24 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 221EC4803C3
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 10:35:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E0B2B301F35C
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 08:30:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C63CA3D47B1;
	Tue, 28 Apr 2026 08:30:14 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4C3829B20A;
	Tue, 28 Apr 2026 08:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.125.252.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777365014; cv=none; b=SfZcqKfSmTMxTX3jweimw28Dx3SznGpXmg7+DFEUif4Oa+mpNICDNQHqLM+G1BThoMFuzQRPTdfePTjex8Q5hXasWm/KZ8aHrVxJV0KYZHLP497xuTOq0WkhWCYjmr+reauMezidGwFfcwsr0+z3atmRp2sCfL4inJEOUmWAVts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777365014; c=relaxed/simple;
	bh=06IdvlqN3C6rUqlYelqWPtkHcy6SOnAqVKtcRw4LPmw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sXpQpgueEVmf0h3F+vB96ACkovI2cxUbni2co0gHnUWYXkCxSx14dp/Trm7iS2Wt2u3qjmR03ShcLEpVcP+7iU0pvQhUVR1SrzGb02WF/1om5XU75noR7kbzc4Rw6Qou1yaJGS0IZ6/qyp5qkhpgYcPA7qgPYgFBPARX6uWyhAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com; spf=pass smtp.mailfrom=sk.com; arc=none smtp.client-ip=166.125.252.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sk.com
X-AuditID: a67dfc5b-c2dff70000001609-83-69f06c832b09
Date: Tue, 28 Apr 2026 17:14:53 +0900
From: Byungchul Park <byungchul@sk.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
	netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
	andrew+netdev@lunn.ch, horms@kernel.org, asml.silence@gmail.com,
	axboe@kernel.dk, almasrymina@google.com, sdf@fomichev.me,
	hawk@kernel.org, akpm@linux-foundation.org, rppt@kernel.org,
	io-uring@vger.kernel.org, kernel_team@skhynix.com
Subject: Re: [PATCH net] net: add net_iov_init() and use it to initialize
 ->page_type
Message-ID: <20260428081453.GA29789@system.software.com>
References: <20260428025320.853452-1-kuba@kernel.org>
 <6dcbee42-df9b-4c0a-b153-aad953441fad@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6dcbee42-df9b-4c0a-b153-aad953441fad@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsXC9ZZnoW5zzodMg4OtWhZz1q9hs1j9o8Ji
	+YMdrBZzVm1jtFh9t5/NYs75FhaLp8cesVvsad/ObPGo/wSbxbvWcywWF7b1sVocWyBm8e30
	G0aLI+u3M1lcnbmLyaLj5X0WBwGPLStvMnnc2HeKyWPnrLvsHgs2lXpcPlvqsWlVJ5vHiRm/
	WTx27vjM5PF+31U2j8+b5AK4orhsUlJzMstSi/TtErgyPs2ezFawSLdi9v7LjA2Mi5S6GDk5
	JARMJLbcWsrSxcgBZh/tFgEJswioSjxonsQMYrMJqEvcuPETzBYRMJDYvfk8K4jNLPCOSeLT
	wSQQW1ggXGLHo33sIGN4BSwkWnpVQMJCApkSC+5/AmvlFRCUODnzCQtEq5bEjX8vmUDKmQWk
	JZb/4wAJcwrYSfz/3s4IYosKKEsc2HYcqIQL6LB+dokzbx6xQlwsKXFwxQ2WCYwCs5CMnYVk
	7CyEsQsYmVcxCmXmleUmZuaY6GVU5mVW6CXn525iBMbWsto/0TsYP10IPsQowMGoxMN7Iux9
	phBrYllxZe4hRgkOZiUR3iv/3mYK8aYkVlalFuXHF5XmpBYfYpTmYFES5zX6Vp4iJJCeWJKa
	nZpakFoEk2Xi4JRqYPTXSDFcvlO8uGteQMTRC64su+ru+9g3mbKUvy/4m7ckrfPRlnq/Szzt
	0/KzAo4Hfaxi3a51rpjJfhFPvP1hr8BrB+vk/cwTDFaGvfm3z3XNiqY5W8v2bb+q7DPxx+0d
	Kxq2bZ3hUDTLY02G8tawLfLPhKqDeb8W3xDw/7v4YM0H/TsHvz59lKbEUpyRaKjFXFScCACJ
	EHK5qQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsXC5WfdrNuc8yHT4Pc+OYs569ewWaz+UWGx
	/MEOVos5q7YxWqy+289mMed8C4vF02OP2C32tG9ntnjUf4LN4l3rORaLw3NPslpc2NbHanFs
	gZjFt9NvGC2OrN/OZHF15i4mi46X91kcBD22rLzJ5HFj3ykmj52z7rJ7LNhU6nH5bKnHplWd
	bB4nZvxm8di54zOTx/t9V9k8Fr/4wOTxeZNcAHcUl01Kak5mWWqRvl0CV8an2ZPZChbpVsze
	f5mxgXGRUhcjB4eEgInE0W6RLkZODhYBVYkHzZOYQWw2AXWJGzd+gtkiAgYSuzefZwWxmQXe
	MUl8OpgEYgsLhEvseLSPHWQMr4CFREuvCkhYSCBTYsH9T2CtvAKCEidnPmGBaNWSuPHvJRNI
	ObOAtMTyfxwgYU4BO4n/39sZQWxRAWWJA9uOM01g5J2FpHsWku5ZCN0LGJlXMYpk5pXlJmbm
	mOoVZ2dU5mVW6CXn525iBEbKsto/E3cwfrnsfohRgINRiYf3RNj7TCHWxLLiytxDjBIczEoi
	vFf+vc0U4k1JrKxKLcqPLyrNSS0+xCjNwaIkzusVnpogJJCeWJKanZpakFoEk2Xi4JRqYFy8
	bSfbNYemnRw77si2bexc7mn2eOO3euv2iwFSIiUPfuaEpszSMfp59seb576/1pRItUeJabK1
	LWL4FqHZetqr/cXnvLQra7xmqx1oOCh8s2fzg+KK1w/nfNh5tONNGR/H1LZjOvOXOX86d+no
	vOt/Nh8t7OSWv/GspnOTnevDu3vm/03j9J6hxFKckWioxVxUnAgA3mk5z5ACAAA=
X-CFilter-Loop: Reflected
X-Rspamd-Queue-Id: 221EC4803C3
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[sk.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13153-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[byungchul@sk.com,io-uring@vger.kernel.org];
	FREEMAIL_CC(0.00)[kernel.org,davemloft.net,vger.kernel.org,google.com,redhat.com,lunn.ch,gmail.com,kernel.dk,fomichev.me,linux-foundation.org,skhynix.com];
	NEURAL_HAM(-0.00)[-0.982];
	TAGGED_RCPT(0.00)[io-uring,netdev];
	R_DKIM_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:email,fomichev.me:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,linux-foundation.org:email]

On Tue, Apr 28, 2026 at 09:57:08AM +0200, Vlastimil Babka (SUSE) wrote:
> +Cc Byungchul
> 
> On 4/28/26 04:53, Jakub Kicinski wrote:
> > Commit db359fccf212 ("mm: introduce a new page type for page pool in
> > page type") added a page_type field to struct net_iov at the same
> > offset as struct page::page_type, so that page_pool_set_pp_info() can
> > call __SetPageNetpp() uniformly on both pages and net_iovs.
> >
> > The page-type API requires the field to hold the UINT_MAX "no type"
> > sentinel before a type can be set; for real struct page that invariant
> > is established by the page allocator on free. struct net_iov is not
> > allocated through the page allocator, so the field is left as zero

My bad.  Overlooked the point.  Thanks for the fix.

Acked-by: Byungchul Park <byungchul@sk.com>

	Byungchul

> > (io_uring zcrx, which uses __GFP_ZERO) or as slab garbage (devmem,
> > which uses kvmalloc_objs() without zeroing). When the page pool then
> > calls page_pool_set_pp_info() on a freshly-bound niov,
> > __SetPageNetpp()'s VM_BUG_ON_PAGE(page->page_type != UINT_MAX) fires
> > and the kernel BUGs. Triggered in selftests by io_uring zcrx setup
> > through the fbnic queue restart path:
> >
> >  kernel BUG at ./include/linux/page-flags.h:1062!
> >  RIP: 0010:page_pool_set_pp_info (./include/linux/page-flags.h:1062
> >                                   net/core/page_pool.c:716)
> >  Call Trace:
> >   <TASK>
> >   net_mp_niov_set_page_pool (net/core/page_pool.c:1360)
> >   io_pp_zc_alloc_netmems (io_uring/zcrx.c:1089 io_uring/zcrx.c:1110)
> >   fbnic_fill_bdq (./include/net/page_pool/helpers.h:160
> >                   drivers/net/ethernet/meta/fbnic/fbnic_txrx.c:906)
> >   __fbnic_nv_restart (drivers/net/ethernet/meta/fbnic/fbnic_txrx.c:2470
> >                       drivers/net/ethernet/meta/fbnic/fbnic_txrx.c:2874)
> >   fbnic_queue_start (drivers/net/ethernet/meta/fbnic/fbnic_txrx.c:2903)
> >   netdev_rx_queue_reconfig (net/core/netdev_rx_queue.c:137)
> >   __netif_mp_open_rxq (net/core/netdev_rx_queue.c:234)
> >   io_register_zcrx (io_uring/zcrx.c:818 io_uring/zcrx.c:903)
> >   __io_uring_register (io_uring/register.c:931)
> >   __do_sys_io_uring_register (io_uring/register.c:1029)
> >   do_syscall_64 (arch/x86/entry/syscall_64.c:63
> >                  arch/x86/entry/syscall_64.c:94)
> >   </TASK>
> >
> > The same path is reachable through devmem dmabuf binding via
> > netdev_nl_bind_rx_doit() -> net_devmem_bind_dmabuf_to_queue().
> >
> > Add a net_iov_init() helper that stamps ->owner, ->type and the
> > ->page_type sentinel, and use it from both the devmem and io_uring
> > zcrx niov init loops.
> >
> > Fixes: db359fccf212 ("mm: introduce a new page type for page pool in page type")
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> 
> > ---
> > CC: asml.silence@gmail.com
> > CC: axboe@kernel.dk
> > CC: almasrymina@google.com
> > CC: sdf@fomichev.me
> > CC: hawk@kernel.org
> > CC: akpm@linux-foundation.org
> > CC: rppt@kernel.org
> > CC: vbabka@kernel.org
> > CC: io-uring@vger.kernel.org
> > ---
> >  include/net/netmem.h | 15 +++++++++++++++
> >  io_uring/zcrx.c      |  3 +--
> >  net/core/devmem.c    |  3 +--
> >  3 files changed, 17 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/net/netmem.h b/include/net/netmem.h
> > index 507b74c9f52d..78fe51e5756b 100644
> > --- a/include/net/netmem.h
> > +++ b/include/net/netmem.h
> > @@ -127,6 +127,21 @@ static inline unsigned int net_iov_idx(const struct net_iov *niov)
> >       return niov - net_iov_owner(niov)->niovs;
> >  }
> >
> > +/* Initialize a niov: stamp the owning area, the memory provider type,
> > + * and the page_type "no type" sentinel expected by the page-type API
> > + * (see PAGE_TYPE_OPS in <linux/page-flags.h>) so that
> > + * page_pool_set_pp_info() can later call __SetPageNetpp() on a niov
> > + * cast to struct page.
> > + */
> > +static inline void net_iov_init(struct net_iov *niov,
> > +                             struct net_iov_area *owner,
> > +                             enum net_iov_type type)
> > +{
> > +     niov->owner = owner;
> > +     niov->type = type;
> > +     niov->page_type = UINT_MAX;
> > +}
> > +
> >  /* netmem */
> >
> >  /**
> > diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> > index 7b93c87b8371..19837e0b5e91 100644
> > --- a/io_uring/zcrx.c
> > +++ b/io_uring/zcrx.c
> > @@ -495,10 +495,9 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
> >       for (i = 0; i < nr_iovs; i++) {
> >               struct net_iov *niov = &area->nia.niovs[i];
> >
> > -             niov->owner = &area->nia;
> > +             net_iov_init(niov, &area->nia, NET_IOV_IOURING);
> >               area->freelist[i] = i;
> >               atomic_set(&area->user_refs[i], 0);
> > -             niov->type = NET_IOV_IOURING;
> >       }
> >
> >       if (ifq->dev) {
> > diff --git a/net/core/devmem.c b/net/core/devmem.c
> > index cde4c89bc146..468344739db2 100644
> > --- a/net/core/devmem.c
> > +++ b/net/core/devmem.c
> > @@ -297,8 +297,7 @@ net_devmem_bind_dmabuf(struct net_device *dev,
> >
> >               for (i = 0; i < owner->area.num_niovs; i++) {
> >                       niov = &owner->area.niovs[i];
> > -                     niov->type = NET_IOV_DMABUF;
> > -                     niov->owner = &owner->area;
> > +                     net_iov_init(niov, &owner->area, NET_IOV_DMABUF);
> >                       page_pool_set_dma_addr_netmem(net_iov_to_netmem(niov),
> >                                                     net_devmem_get_dma_addr(niov));
> >                       if (direction == DMA_TO_DEVICE)

