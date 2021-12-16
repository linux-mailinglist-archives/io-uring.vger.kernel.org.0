Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99DDA476D01
	for <lists+io-uring@lfdr.de>; Thu, 16 Dec 2021 10:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232953AbhLPJLr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Dec 2021 04:11:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232939AbhLPJLg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Dec 2021 04:11:36 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E23C06173E;
        Thu, 16 Dec 2021 01:11:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=oqPQPVKcFfy0OGZ5NFrYCW8VSWP587eza/wEkq3np3M=; b=sAqvoJM0lC8rw9cKRDFEZmxgag
        PeMQJH5w/diqX82nlKakmMVgYbaBw4uF2gH96S6emkTWKGP5cVSDTVlFwY28n4z3EPoUd167A1d/G
        zrdk9Wd/ozjHch+l1ji0LlImZJEZTt9czaKSV7LokZ3tjcUa6jz/5DbLg2u21BtllURPsuDv0fLFQ
        e+vZBjBeKxLxWa1bnvoYN6ckgnM7MIDecfZL4kGaFJ1s/xvSjVbFCm26eVCKP2c+eZ7VZFS6pAT5c
        rmel5Z+puDdnujRhvqw/+VmhwGtHvSRrWVeHlRL7DMnMqrPg1ZL3DxHeEGow74vcbOQKNzkViVJKA
        yfzaOFYg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mxmnX-004Ktx-OH; Thu, 16 Dec 2021 09:11:35 +0000
Date:   Thu, 16 Dec 2021 01:11:35 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 2/3] block: use singly linked list for bio cache
Message-ID: <YbsCxzt96BgDUeLo@infradead.org>
References: <20211215163009.15269-1-axboe@kernel.dk>
 <20211215163009.15269-3-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215163009.15269-3-axboe@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 15, 2021 at 09:30:08AM -0700, Jens Axboe wrote:
> Pointless to maintain a head/tail for the list, as we never need to
> access the tail. Entries are always LIFO for cache hotness reasons.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  block/bio.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index d9d8e1143edc..a76a3134625a 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -26,7 +26,7 @@
>  #include "blk-rq-qos.h"
>  
>  struct bio_alloc_cache {
> -	struct bio_list		free_list;
> +	struct bio		*free_list;
>  	unsigned int		nr;
>  };
>  
> @@ -630,7 +630,9 @@ static void bio_alloc_cache_prune(struct bio_alloc_cache *cache,
>  	unsigned int i = 0;
>  	struct bio *bio;
>  
> -	while ((bio = bio_list_pop(&cache->free_list)) != NULL) {
> +	while (cache->free_list) {
> +		bio = cache->free_list;

Nit:

	while ((bio = cache->free_list) != NULL) {

would mke the iteration a litle more obvious.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
