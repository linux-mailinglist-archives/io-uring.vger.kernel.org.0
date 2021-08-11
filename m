Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 698A83E8BE1
	for <lists+io-uring@lfdr.de>; Wed, 11 Aug 2021 10:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235282AbhHKIf5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Aug 2021 04:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233112AbhHKIf5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Aug 2021 04:35:57 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E210C061765;
        Wed, 11 Aug 2021 01:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qkSAYZ3xAvUamfq9k/TQrh/xI0CJJK908Q4oFH9NH9k=; b=Wjh9rWhzxkA2mNzFLI5meO5cxd
        RbbLhw+FiJV5aOrniYsfLf/NXKwxWvEzxbc4yLWEKpw2Bls4kl4ro10aWkHMItcxBKdQlatIpl8uL
        Tf/ipfqu6W+CW8ZYAQOi019RaefZt2WGVnTUP8vuBbvwY4oepCK1iqWLuR5cLaA7bkD+yFwRoqoZ2
        +GOV4qAaFkABZ4xUcJZi6sZBBppsJWgcr0VIhbD4M/dVs73lsnNTK7hlCEjHmr/9KPjY9NrrjXuLX
        pafmeC6IeSx4JXhYvUykPOGQm9fd2tkv6mEVX1CL64OaUb6HcJvpp09dgLtdhsofFrsXA3WaSOrR9
        jv19EYlQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mDjhK-00DAT7-Fp; Wed, 11 Aug 2021 08:35:06 +0000
Date:   Wed, 11 Aug 2021 09:34:50 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 1/5] bio: add allocation cache abstraction
Message-ID: <YROLqiFAyx6ZjuH6@infradead.org>
References: <20210810163728.265939-1-axboe@kernel.dk>
 <20210810163728.265939-2-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810163728.265939-2-axboe@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> +static inline void __bio_init(struct bio *bio)
> +{

> +}
> +
>  /*
>   * Users of this function have their own bio allocation. Subsequently,
>   * they must remember to pair any call to bio_init() with bio_uninit()
> @@ -246,7 +275,7 @@ static void bio_free(struct bio *bio)
>  void bio_init(struct bio *bio, struct bio_vec *table,
>  	      unsigned short max_vecs)
>  {
> -	memset(bio, 0, sizeof(*bio));
> +	__bio_init(bio);

Please split this into a separate, well-documented prep patch.
