Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE9862B4CE
	for <lists+io-uring@lfdr.de>; Wed, 16 Nov 2022 09:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233152AbiKPIP4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Nov 2022 03:15:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237481AbiKPIPl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Nov 2022 03:15:41 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B0BBCAA
        for <io-uring@vger.kernel.org>; Wed, 16 Nov 2022 00:15:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tEQ9w5XhExMpJ5wgV0chxgtX/DWqYmdg46wZWytdte0=; b=ZCuWqhUSDVect0FQlrd0GfX5se
        v+l7A8sye96tv4NqjaxLAadGQFMyI3pkfa0+UJ0Z+vj/X59mCrGznKfiYswCyd0eH9pST3MFFLdCn
        s0wM5QXVSPGlgxE4gC00ubVFdcsfwuDKD74PhHhGvqI65KfACmvcbtmBQpr2nNbSxjSXoTXNwH/EN
        0RVQFej/f5IRY8DjC02AJAsFEbgXmxDJYYHO7U0k6xnTRiXLtv/FNZUHknPErXzYV6bziq5kFnijz
        p4+FJoMUYBbqHQqkIDhlvjFhgoPKIgoHW92waPm/F6Q9JrwUDamjBV7W7QC0bTcbsOUYuVMtdTNaz
        rcH+FW3w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ovDZa-00185c-RY; Wed, 16 Nov 2022 08:15:06 +0000
Date:   Wed, 16 Nov 2022 00:15:06 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     io-uring@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v1 07/15] io_uring: Allocate zctap device buffers and dma
 map them.
Message-ID: <Y3ScCh6P1kC5vifs@infradead.org>
References: <20221108050521.3198458-1-jonathan.lemon@gmail.com>
 <20221108050521.3198458-8-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108050521.3198458-8-jonathan.lemon@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> +		dma_unmap_page_attrs(device, buf->dma, PAGE_SIZE,
> +				     DMA_BIDIRECTIONAL,
> +				     DMA_ATTR_SKIP_CPU_SYNC);

> +		addr = dma_map_page_attrs(device, page, 0, PAGE_SIZE,
> +					  DMA_BIDIRECTIONAL,
> +					  DMA_ATTR_SKIP_CPU_SYNC);

You can't just magically skip cpu syncs.  The flag is only valid
for mappings of already mapped memory when following a very careful
protocol.  I can't see any indications of that beeing true here,
but maybe I'm just missing something.

