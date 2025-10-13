Return-Path: <io-uring+bounces-9968-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id CBCBABD15EC
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 06:23:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 449D84E5C10
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 04:23:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2C2521018A;
	Mon, 13 Oct 2025 04:23:13 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72F06155CB3;
	Mon, 13 Oct 2025 04:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.125.252.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760329393; cv=none; b=QOu1Q62SNCk+TkEWHXJhHAu9ai36pHdrCIeLDVH8kekWVHcAU3jJWHvU97peBAf1SUFlq3wv4yhWZNvVLhf/Ruh4C8BcjoF43JNxLqgPAZCoLro0o4wRUwng7k/HByZawTnh12IU+CyO8jnNgOywkY/eLdsC0/tvh/5J/PIawRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760329393; c=relaxed/simple;
	bh=hFyQ7FqHxztLfvRlvhvvHNogy7hO4gTqee2lFa8fEv8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GNcMfOZkpYZdqtItVCFW4mZcZHVtvDe+fyLhAbHWtJxTyfFyTY5Z0NrV+//TfDQmR5R6pEU6upzgQFF7Mj4Jk9LcWktubaF7tHJmuRU90x9CKAwgQx7F7nzGKhK9Q6y7cWsu5AZsSZgYnFa8GAhivn1NqtSK34vOSPBZfotCt4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com; spf=pass smtp.mailfrom=sk.com; arc=none smtp.client-ip=166.125.252.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sk.com
X-AuditID: a67dfc5b-c2dff70000001609-ce-68ec7ea88343
Date: Mon, 13 Oct 2025 13:22:59 +0900
From: Byungchul Park <byungchul@sk.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
	kernel_team@skhynix.com
Subject: Re: [PATCH io_uring for-review] io_uring/zcrx: convert to use
 netmem_desc
Message-ID: <20251013042259.GA6925@system.software.com>
References: <2ea0f9bd5d0dbc599d766b7b35df4132e904abc6.1759928725.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ea0f9bd5d0dbc599d766b7b35df4132e904abc6.1759928725.git.asml.silence@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsXC9ZZnke6KujcZBkcmmVjMWbWN0eJd6zkW
	i2MLxByYPXbOusvu8XmTXABTFJdNSmpOZllqkb5dAlfGjJN3GAv2CFdMmX6HtYHxGW8XIyeH
	hICJxPOXG1hh7BMdR5hAbBYBVYnpi+Ywg9hsAuoSN278BLNFBLQlXl8/xN7FyMHBLOAv8euw
	C0hYWCBE4sebM2AlvALmEvNm3AOzhQRiJE58eMQCEReUODnzCZjNLKAlcePfSyaIMdISy/9x
	gJicArESayaZgFSICihLHNh2HKiCC+iwj6wSKyddYoa4UlLi4IobLBMYBWYhmToLydRZCFMX
	MDKvYhTKzCvLTczMMdHLqMzLrNBLzs/dxAgMx2W1f6J3MH66EHyIUYCDUYmHN2P36wwh1sSy
	4srcQ4wSHMxKIrzm1W8yhHhTEiurUovy44tKc1KLDzFKc7AoifMafStPERJITyxJzU5NLUgt
	gskycXBKNTBGB/hPW31WWoTb2PjALMnJ6qeN6xv/KIluUpQUVTiqumzSuaYKuTuWzF83hB8t
	vqQfHMsgVxA6pUPgwEwxbuUYZ4+yaWFchpULrjTuc5vlvm+d30YNyy8bLQ5oS19Xakh5sfyh
	nHyC2c/fM7qc9Tn6G1++qar0vjcjuP6VArfh2RtqTibZs5RYijMSDbWYi4oTAQTv1JRDAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOLMWRmVeSWpSXmKPExsXC5WfdrLui7k2GwYzVShZzVm1jtHjXeo7F
	4vDck6wWxxaIObB47Jx1l91j8YsPTB6fN8kFMEdx2aSk5mSWpRbp2yVwZcw4eYexYI9wxZTp
	d1gbGJ/xdjFyckgImEic6DjCBGKzCKhKTF80hxnEZhNQl7hx4yeYLSKgLfH6+iH2LkYODmYB
	f4lfh11AwsICIRI/3pwBK+EVMJeYN+MemC0kECNx4sMjFoi4oMTJmU/AbGYBLYkb/14yQYyR
	llj+jwPE5BSIlVgzyQSkQlRAWeLAtuNMExh5ZyFpnoWkeRZC8wJG5lWMIpl5ZbmJmTmmesXZ
	GZV5mRV6yfm5mxiBwbWs9s/EHYxfLrsfYhTgYFTi4c3Y/TpDiDWxrLgy9xCjBAezkgivefWb
	DCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8XuGpCUIC6YklqdmpqQWpRTBZJg5OqQZGhSnT7WzC
	LUXO3Wzf+jDkirzWkz9ic6u3iGz3edNd/GP5oTvO/xJudfd2uU21fPjP/GR1qZLh5Vl/a3NL
	62zmdEVUHjh9T/HUzC0fa1/HC+i77bx5sfa2nfLmu2kLBZVsuorT5qTXGS348vmA85GyEudu
	RneB/QG8AcJLV64JPs34IWz/cX0WJZbijERDLeai4kQA7+EZ+CoCAAA=
X-CFilter-Loop: Reflected

On Wed, Oct 08, 2025 at 02:12:54PM +0100, Pavel Begunkov wrote:
> Convert zcrx to struct netmem_desc, and use struct net_iov::desc to
> access its fields instead of struct net_iov inner union alises.
> zcrx only directly reads niov->pp, so with this patch it doesn't depend
> on the union anymore.

Looks clear enough and it's the necessary changes.

Reviewed-by: Byungchul Park <byungchul@sk.com>

	Byungchul

> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  io_uring/zcrx.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index 723e4266b91f..966ed95e801d 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> @@ -693,12 +693,12 @@ static void io_zcrx_return_niov(struct net_iov *niov)
>  {
>         netmem_ref netmem = net_iov_to_netmem(niov);
> 
> -       if (!niov->pp) {
> +       if (!niov->desc.pp) {
>                 /* copy fallback allocated niovs */
>                 io_zcrx_return_niov_freelist(niov);
>                 return;
>         }
> -       page_pool_put_unrefed_netmem(niov->pp, netmem, -1, false);
> +       page_pool_put_unrefed_netmem(niov->desc.pp, netmem, -1, false);
>  }
> 
>  static void io_zcrx_scrub(struct io_zcrx_ifq *ifq)
> @@ -800,7 +800,7 @@ static void io_zcrx_ring_refill(struct page_pool *pp,
>                 if (!page_pool_unref_and_test(netmem))
>                         continue;
> 
> -               if (unlikely(niov->pp != pp)) {
> +               if (unlikely(niov->desc.pp != pp)) {
>                         io_zcrx_return_niov(niov);
>                         continue;
>                 }
> @@ -1136,13 +1136,15 @@ static int io_zcrx_recv_frag(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
>                              const skb_frag_t *frag, int off, int len)
>  {
>         struct net_iov *niov;
> +       struct page_pool *pp;
> 
>         if (unlikely(!skb_frag_is_net_iov(frag)))
>                 return io_zcrx_copy_frag(req, ifq, frag, off, len);
> 
>         niov = netmem_to_net_iov(frag->netmem);
> -       if (!niov->pp || niov->pp->mp_ops != &io_uring_pp_zc_ops ||
> -           io_pp_to_ifq(niov->pp) != ifq)
> +       pp = niov->desc.pp;
> +
> +       if (!pp || pp->mp_ops != &io_uring_pp_zc_ops || io_pp_to_ifq(pp) != ifq)
>                 return -EFAULT;
> 
>         if (!io_zcrx_queue_cqe(req, niov, ifq, off + skb_frag_off(frag), len))
> --
> 2.49.0

