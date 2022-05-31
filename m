Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51FE6538BC2
	for <lists+io-uring@lfdr.de>; Tue, 31 May 2022 09:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiEaHFS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 May 2022 03:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236941AbiEaHFR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 03:05:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F432972A8;
        Tue, 31 May 2022 00:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Ih86PMPd5isjOiHWIoVJizmuLl
        qQ4ufk5bdPvwCuux7qESZBjmuYT3biJompADGdyh+DB/IUswr9hSVTZKcCj/drbVNPO0h96cXiMrr
        E5dfcRtnoYI99VZ2XppSgzDnHTfsDw/6S1H63rCT/IteR6QtxVs8O8rFl2I2eEZ3GllJsoVyfUT2L
        +2MiSnHtgzomzjE9ko7z/uJSJNEr/Garf75kKUdcpsY+tlD4ajgmwi1XwMg4XRN/2j9Ouj8HQSOBx
        3AzvE4HsxdZjFUbZqIXs31xmJ41Nq4PuU52vhjJSqN09s0l6KmrotnKRQ0YLwkmEtjr8uVnO01Fxt
        JKfFZsQQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nvvwK-009eiu-MG; Tue, 31 May 2022 07:05:16 +0000
Date:   Tue, 31 May 2022 00:05:16 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org
Subject: Re: [PATCH v6 15/16] xfs: Add async buffered write support
Message-ID: <YpW+LOmjoczIL5dI@infradead.org>
References: <20220526173840.578265-1-shr@fb.com>
 <20220526173840.578265-16-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526173840.578265-16-shr@fb.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
