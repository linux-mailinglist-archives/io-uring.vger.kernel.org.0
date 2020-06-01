Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA18E1EA5A0
	for <lists+io-uring@lfdr.de>; Mon,  1 Jun 2020 16:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbgFAOQi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Jun 2020 10:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbgFAOQi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Jun 2020 10:16:38 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446F9C05BD43;
        Mon,  1 Jun 2020 07:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cUFCFUAHtxI+0MrjB+VhTFEOv+nU3U/VpjJNBE19AfU=; b=pH9GUaVOcrpmbA+xhEZGHkqPsU
        OPIxxW2zXvtxdarH4aonsmSOAjJRazit1ADK3sGVR4APDR0XP9xfrrPXOxZsXTp41i38UtrXdMMaS
        q5+gPFl1jDFQjXq1Eb/5nw1PPSperRIoVD0lmu8VffbxqPSLGPykihIKtC9ympBZdLyITvu8p8zF7
        LGIxyZYKxLYCV15cI3kWyb0XBehMHBQL0/8+IpEnZnyRPZd6EQlPcrUHEM11GMcBx99OLMcHKK2sK
        FNrccB7jCbOtQD1p1ebBm5Nyt30+0pn1bWRCWCDh7/rUKHk1mcaUSzCF1JDRw52CPb6iUdkXzBwfG
        +tYPF12g==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jflEv-0005tJ-1a; Mon, 01 Jun 2020 14:16:33 +0000
Date:   Mon, 1 Jun 2020 07:16:32 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 03/12] mm: abstract out wake_page_match() from
 wake_page_function()
Message-ID: <20200601141632.GI19604@bombadil.infradead.org>
References: <20200526195123.29053-1-axboe@kernel.dk>
 <20200526195123.29053-4-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526195123.29053-4-axboe@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, May 26, 2020 at 01:51:14PM -0600, Jens Axboe wrote:
> +++ b/include/linux/pagemap.h
> @@ -456,6 +456,43 @@ static inline pgoff_t linear_page_index(struct vm_area_struct *vma,
>  	return pgoff;
>  }
>  
> +/* This has the same layout as wait_bit_key - see fs/cachefiles/rdwr.c */
> +struct wait_page_key {
> +	struct page *page;
> +	int bit_nr;
> +	int page_match;
> +};

I know you only moved the struct, and the comment along with it, but now
that this struct is in pagemap.h, I think cachefiles should be updated
to use wait_page_key instead of wait_bit_key.  Dave?

