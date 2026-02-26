Return-Path: <io-uring+bounces-12426-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8EOhOSCSn2kicwQAu9opvQ
	(envelope-from <io-uring+bounces-12426-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 01:21:52 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4740019F5BA
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 01:21:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E42F130180BB
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 00:21:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 561D51F0E2E;
	Thu, 26 Feb 2026 00:21:48 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E48481EB5B;
	Thu, 26 Feb 2026 00:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.125.252.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772065308; cv=none; b=dQigESuuREywjWwGnz3qsfDuHcVhBwK7Rbdi4y/SikaA/LYLBbGBEHQhJO9QEdkM6xKNz8jPOIKOxN8sYH3+4RyYilpgolyHbbTqN174x/tHh/zUb0l3lqIzk4zLkr9N5TXemSgScTJ3uZEh+lb5mmFYd55b5VJdxZdaghUkq5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772065308; c=relaxed/simple;
	bh=/dH8VeKMwTRMZhEfieZTD729VyTa6c9cAscbGCcKeis=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jp43nMykro2EvRmr9I0PYbqzTT5XnvQ/FYUJcSGjpy/5t4V8R5lfMId5wd8ziUI9Mqqf+obWioKZvcY+qa2qy5OVDbImcEWTBB1Myexl4L5bOj21wYxsF5mXpLtLKefvAsNrD04Fz/TTmos2xEEIDtoXxV+8PI3tC6x+xm10K2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com; spf=pass smtp.mailfrom=sk.com; arc=none smtp.client-ip=166.125.252.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sk.com
X-AuditID: a67dfc5b-c45ff70000001609-5a-699f920d0ae2
Date: Thu, 26 Feb 2026 09:21:27 +0900
From: Byungchul Park <byungchul@sk.com>
To: Mina Almasry <almasrymina@google.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kernel_team@skhynix.com, harry.yoo@oracle.com,
	hawk@kernel.org, andrew+netdev@lunn.ch, david@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	ziy@nvidia.com, willy@infradead.org, toke@redhat.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org, asml.silence@gmail.com,
	axboe@kernel.dk, ncardwell@google.com, kuniyu@google.com,
	dsahern@kernel.org, sdf@fomichev.me, dw@davidwei.uk,
	ap420073@gmail.com, dtatulea@nvidia.com, shivajikant@google.com,
	io-uring@vger.kernel.org
Subject: Re: [RESEND PATCH net-next] netmem: remove the pp fields from net_iov
Message-ID: <20260226002127.GA71611@system.software.com>
References: <20260224061424.11219-1-byungchul@sk.com>
 <CAHS8izPjfrKFNtvkyODY7HXSsAuQuPhzy3+fMyYTFuWKQJZ0Fg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHS8izPjfrKFNtvkyODY7HXSsAuQuPhzy3+fMyYTFuWKQJZ0Fg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRzGeXfOzs6Gw9NSe9WwXERoaBZ+eJFuBsEhQiz9EBrYykOOtmmb
	Lo0Cw7xmToXQTbNV3jYv2cwrpnnXTDPHzGrqkkyItLzmrcumSH57eJ6H5/f/8CcxQTrbhRTL
	ohm5TCQREjycN233xIuf/UjsY/wNUdlyLCqx1LPRSvkUC+XrawEqG1URKP/tXRxN1awCVNmY
	yEINjVMAfcutINBk1wQHjRd/xVFTch2GJlQ9BJpJHMDRYG0GGw206whUF2/hIGNjPoHGyv+y
	Ua9Gh6MU80scdWmd0FLfd4BM6kYWemwOQ0PtEzjKu5MB0NqytZ/XOcY56Ua/0H1g0cO5WTg9
	0vyaRTdoRjm01hBDV5d60sb+GNqgTyVow1w2h26on2fR9xNmCHp28iNO/2g2EfQbbQeHnje4
	BdqH8I6GMxKxkpEfOn6JF1Fd0gmi+txi10wmIh5kOqUBLgkpX1ij6WFv6RWVGU8DJIlT+6G6
	wt9mE9QBODKygtm0A+UBC5uzrHUeiVFJbPi+Z4mwBTupAFjV0L2xw6cQNFYVbuwIqFswp1q6
	ae+AveovuE1j1s31giHMVsEoV1jyh9y098CEmrwNFJc6BysX1cCmHal98FVtN8uGhVQRCRfS
	VZzNk51ha+kIngl2aLYhNNsQmv8IzTaEFuB6IBDLlFKRWOLrHREnE8d6X4mUGoD1R4pvr4fW
	g7nBoDZAkUBox7+wUiAWsEVKRZy0DUASEzrwzT+tFj9cFHeTkUeGyWMkjKINuJK4cBf/yNKN
	cAF1VRTNXGOYKEa+lbJIrks8cB9WEmSqhftUl8K72F8l8+vNdR0P7pC9a/mc4O64YEzzeOYU
	fDpGWejX4m8p5znDvathQ3Xc6wETXpz1pFSPxYP6VkWCTnNs9GGylLg32xQWUoudGF66HDTd
	UW0+e+p5T9EDaU5WauBa0PzuX/OG4E/noTaHDpUQ9k4KnzOxQlwRITrsickVon84w9RmHwMA
	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsXC5WfdrMs7aX6mQd9/VovVPyoslj/YwWrx
	c81zJos5q7YxWqy+289mMed8C4vF862/GC3W7Wplsti56zmjxasZa9ksnh57xG5xf9kzFos9
	7duZLR71n2CzeNd6jsXi8NyTrBYXtvWxWpw7vJLNYnvDA3aLy7vmsFncWwO05+SslSwWHXf2
	slgcWyBm8e30G0aLqzN3MVksvBNvcenwIxaL2Y19jBa/fwDVzz56j91B3mPLyptMHtdmTGTx
	uLHvFJPHzll32T0WbCr12LxCy+Py2VKPTas62Tw2fZrE7rFzx2cmj97md2weH5/eYvF4v+8q
	m8fiFx+YPM4sOMLu8XmTXIBAFJdNSmpOZllqkb5dAlfG5uVHGQtOy1X8vnqVrYFxglgXIyeH
	hICJxM/+OyxdjBwcLAKqEjPXOoKE2QTUJW7c+MkMYosIaEos2TeRtYuRi4NZoI1V4vqJb2wg
	CWEBP4kNO4+zgti8AhYSlzcsAZsjJFAjMX1zLkRYUOLkzCcsIDYz0Mw/8y4xg5QwC0hLLP/H
	ARGWl2jeOhtsFadAoMS6rzMZQWxRAWWJA9uOM01g5JuFZNIsJJNmIUyahWTSAkaWVYwimXll
	uYmZOaZ6xdkZlXmZFXrJ+bmbGIFJYVntn4k7GL9cdj/EKMDBqMTDG/FzXqYQa2JZcWXuIUYJ
	DmYlEd47H4BCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeb3CUxOEBNITS1KzU1MLUotgskwcnFIN
	jHKvJ99ZKOqarjrn96e3Hn0nzjb5FM9rXrx3ymM1F4Y/xp2/0i7sagsuuBgU2KVv1Lud6x1L
	BPfBV89ij/c9OaZQHPhpvXzKQaXzKkn2PZvnCv+dGcsrs3Rzm0lQt6a1RFLKhHVr2DxaG86V
	a13g5vqS42y39mf1npAnoev1eOuP3i8rmpZarcRSnJFoqMVcVJwIAB3HkTgGAwAA
X-CFilter-Loop: Reflected
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[sk.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12426-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_TWELVE(0.00)[31];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[byungchul@sk.com,io-uring@vger.kernel.org];
	FREEMAIL_CC(0.00)[vger.kernel.org,kvack.org,skhynix.com,oracle.com,kernel.org,lunn.ch,suse.cz,nvidia.com,infradead.org,redhat.com,davemloft.net,google.com,gmail.com,kernel.dk,fomichev.me,davidwei.uk];
	NEURAL_HAM(-0.00)[-0.853];
	TAGGED_RCPT(0.00)[io-uring,netdev];
	R_DKIM_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[system.software.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4740019F5BA
X-Rspamd-Action: no action

On Wed, Feb 25, 2026 at 09:57:17AM -0800, Mina Almasry wrote:
> On Mon, Feb 23, 2026 at 10:14 PM Byungchul Park <byungchul@sk.com> wrote:
> >
> > Now that the pp fields in net_iov have no users, remove them from
> > net_iov and clean up.
> >
> > Signed-off-by: Byungchul Park <byungchul@sk.com>
> > ---
> > The original post was:
> >
> >   https://lore.kernel.org/all/20251121040047.71921-1-byungchul@sk.com/
> >
> > 1/3 was covered by Pavel's patch:
> >
> >   commit f0243d2b86b97 ("io_uring/zcrx: convert to use netmem_desc").
> >
> > 2/3 was taken by Jakub and merged:
> >
> >   commit df59bb5b9af3f ("netmem, devmem, tcp: access pp fields through
> >   @desc in net_iov")
> >
> > Now that io-uring and net core changes converge in one tree, I'm
> > resending the 3/3, which is what Jakub asked:
> >
> >   https://lore.kernel.org/all/20251124184729.7e365941@kernel.org/
> > ---
> >  include/net/netmem.h | 38 +-------------------------------------
> >  1 file changed, 1 insertion(+), 37 deletions(-)
> >
> > diff --git a/include/net/netmem.h b/include/net/netmem.h
> > index a96b3e5e5574..a6d65ced5231 100644
> > --- a/include/net/netmem.h
> > +++ b/include/net/netmem.h
> > @@ -93,23 +93,7 @@ enum net_iov_type {
> >   *             supported.
> >   */
> >  struct net_iov {
> > -       union {
> > -               struct netmem_desc desc;
> > -
> > -               /* XXX: The following part should be removed once all
> > -                * the references to them are converted so as to be
> > -                * accessed via netmem_desc e.g. niov->desc.pp instead
> > -                * of niov->pp.
> > -                */
> > -               struct {
> > -                       unsigned long _flags;
> > -                       unsigned long pp_magic;
> > -                       struct page_pool *pp;
> > -                       unsigned long _pp_mapping_pad;
> > -                       unsigned long dma_addr;
> > -                       atomic_long_t pp_ref_count;
> > -               };
> > -       };
> > +       struct netmem_desc desc;
> >         struct net_iov_area *owner;
> >         enum net_iov_type type;
> >  };
> > @@ -123,26 +107,6 @@ struct net_iov_area {
> >         unsigned long base_virtual;
> >  };
> >
> > -/* net_iov is union'ed with struct netmem_desc mirroring struct page, so
> > - * the page_pool can access these fields without worrying whether the
> > - * underlying fields are accessed via netmem_desc or directly via
> > - * net_iov, until all the references to them are converted so as to be
> > - * accessed via netmem_desc e.g. niov->desc.pp instead of niov->pp.
> > - *
> > - * The non-net stack fields of struct page are private to the mm stack
> > - * and must never be mirrored to net_iov.
> > - */
> > -#define NET_IOV_ASSERT_OFFSET(desc, iov)                    \
> > -       static_assert(offsetof(struct netmem_desc, desc) == \
> > -                     offsetof(struct net_iov, iov))
> > -NET_IOV_ASSERT_OFFSET(_flags, _flags);
> > -NET_IOV_ASSERT_OFFSET(pp_magic, pp_magic);
> > -NET_IOV_ASSERT_OFFSET(pp, pp);
> > -NET_IOV_ASSERT_OFFSET(_pp_mapping_pad, _pp_mapping_pad);
> > -NET_IOV_ASSERT_OFFSET(dma_addr, dma_addr);
> > -NET_IOV_ASSERT_OFFSET(pp_ref_count, pp_ref_count);
> > -#undef NET_IOV_ASSERT_OFFSET
> > -
> 
> Probably better to retain an assert that netmem_desc is the first
> field in struct net_iov, no?

What is the assert for?  Can you give an example that might lead wrong
without the assert?

	Byungchul

> There technically is no assert that netmem_desc is the first field of
> struct page, but it's generally well understood that the memory
> descriptor types should be the first field of struct page. It's not
> well understand that the netmem_desc type should be the first field in
> struct net_iov though.
> 
> --
> Thanks,
> Mina

