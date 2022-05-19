Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0597D52CE56
	for <lists+io-uring@lfdr.de>; Thu, 19 May 2022 10:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbiESIcM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 May 2022 04:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbiESIcM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 May 2022 04:32:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B78071A33;
        Thu, 19 May 2022 01:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=z0VulKkXWTFJSRnaleVs6kNcyiBhFADcaZisxPBE7tM=; b=05s9ISOpfkpuTstanmUDq2bKnF
        9pIoGjju+h4SX5a2iN7+aQonQ1woQTpJq0GxFgp4jsF3QArHF6Bj3YRoRJTaU2TYvf6qRq2meYvCa
        OwMd/dezqb6Gz1+EHcGXVTYpZcJDCOivmvyXqECE4TLt9He6snuQHz5YQbANRnqD0FA4vbmCDe8YK
        46z5vlRBS/VJadmIc7tHAFflPRMmqVhxu38qS2ODFjCuCPKF3XsOl3nrV2seq3ayXqOyy2Lgzt3T1
        VA38bdz9XaNf/bjBtQ53a/rnVKCbAZrrtqvp1RZGeDTjB4mjOXwgEZV1K3ZL2TjurGGG1PWrboYpl
        l2EF9Etg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nrbZq-005s9y-VX; Thu, 19 May 2022 08:32:11 +0000
Date:   Thu, 19 May 2022 01:32:10 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
Subject: Re: [RFC PATCH v3 16/18] iomap: Use
 balance_dirty_pages_ratelimited_flags in iomap_write_iter
Message-ID: <YoYAivwbExCgWj1l@infradead.org>
References: <20220518233709.1937634-1-shr@fb.com>
 <20220518233709.1937634-17-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518233709.1937634-17-shr@fb.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -784,6 +784,7 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
>  	do {
>  		struct folio *folio;
>  		struct page *page;
> +		struct address_space *i_mapping = iter->inode->i_mapping;

We tend to call these variables just mapping without the i_ prefix.

>  again:
> +		if (iter->flags & IOMAP_NOWAIT) {
> +			status = balance_dirty_pages_ratelimited_async(i_mapping);

Which also nicely avoids the overly long line here.

> +			if (unlikely(status))
> +				break;
> +		} else {
> +			balance_dirty_pages_ratelimited(i_mapping);
> +		}

Then again directly calling the underlying helper here would be simpler
to start with.

	unsigned int bdp_flags = (iter->flags & IOMAP_NOWAIT) ? BDP_ASYNC : 0;

	...


		status = balance_dirty_pages_ratelimited_flags(mapping,
				bdp_flags);
		if (status)
			break;

