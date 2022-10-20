Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 745F56059C1
	for <lists+io-uring@lfdr.de>; Thu, 20 Oct 2022 10:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiJTIac (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Oct 2022 04:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiJTIab (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Oct 2022 04:30:31 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27FF4BC450;
        Thu, 20 Oct 2022 01:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YBJ6CPVckSe7+zKCUltneL6fxHtUazOx75/bK3nYf7g=; b=Pk760JUMtwMM6mZkn5N3uYVLBe
        BnSlExu/eaLRfYWmr9ml2dGZNx7DeXSDdL3f/0je0r+c06j/wS7AG2tzoqV0/0k10QvbzmNscp00A
        uTm7+ZkzYpnHxrC7y0J/oVMTMtSaMIeUmWzT/dKZBpHnV/dNXCCcomyJO5Muv0cf46s7I5LL5i9Cx
        vTjzVhBzZvCcI3MGxOooui2FGpbKLpPNuw7ox3raU3wTa62QOvXCtPNI/uu28fvEPNRH2uDRXNW2I
        xPFjUlx9W+94lYKKZwgOe1avQF3mjOICW0k2QAOl1XVc7cZlGFq7xiYTmpqVf9SGNXPiRpe3sPy3j
        rtGQw+ZA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1olQwZ-00CDV4-3I; Thu, 20 Oct 2022 08:30:23 +0000
Date:   Thu, 20 Oct 2022 01:30:23 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC for-next v2 2/4] bio: split pcpu cache part of bio_put into
 a helper
Message-ID: <Y1EHH/+TBtGn2/U8@infradead.org>
References: <cover.1666122465.git.asml.silence@gmail.com>
 <cd6df8c5289a2df20c338d0842172950b0dedef2.1666122465.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd6df8c5289a2df20c338d0842172950b0dedef2.1666122465.git.asml.silence@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> +	if ((bio->bi_opf & REQ_POLLED) && !WARN_ON_ONCE(in_interrupt())) {
> +		bio->bi_next = cache->free_list;
> +		cache->free_list = bio;
> +		cache->nr++;
> +	} else {
> +		put_cpu();
> +		bio_free(bio);
> +		return;
> +	}

This reads a little strange with the return in an else.  Why not:

	if (!(bio->bi_opf & REQ_POLLED) || WARN_ON_ONCE(in_interrupt())) {
		put_cpu();
		bio_free(bio);
		return;
	}

	bio->bi_next = cache->free_list;
	cache->free_list = bio;
	cache->nr++;

but given that the simple free case doesn't care about what CPU we're
on or the per-cpu cache pointer, I think we can simply move the

	cache = per_cpu_ptr(bio->bi_pool->cache, get_cpu());

after the above return as well.

