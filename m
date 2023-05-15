Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C756C702BFD
	for <lists+io-uring@lfdr.de>; Mon, 15 May 2023 13:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241657AbjEOL4N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 May 2023 07:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239652AbjEOLzb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 May 2023 07:55:31 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC1030DF;
        Mon, 15 May 2023 04:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=KLi1zmQuR3gtU/V8s6LS2xMnr/
        pm14ITI128LzPEkXFde+hdAZUHNWIdIC6r9q8hO31SQ89G+jqMCCcUS8TcgtGsGqgJu/SbV7w87/x
        qYD6b/zNHeCALlLohnZ007lxa0UsC7lddAQsjoQ4dmiJ5mxqa3fbUMxvpreVfEcRDZh6GTdM/FVs0
        +EpXEQcJCxlENfst+o86TNDXi6MtWi9ln1U4KoNKNQdfjkaZeYMApu+XXOmkQmKMvEVhguJV3oVoR
        8XQdp79zbIM6hT6qt/IlSKjeUbtgb6K1olqDNBy10DANifnqL74QfHJkAey5IuHoNmqfdRGI7m4N8
        mmpJoywA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pyWiR-0022Bb-2M;
        Mon, 15 May 2023 11:50:11 +0000
Date:   Mon, 15 May 2023 04:50:11 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH v5 4/6] io_uring: rsrc: delegate VMA file-backed check to
 GUP
Message-ID: <ZGIccwk5w44RL3X4@infradead.org>
References: <cover.1684097001.git.lstoakes@gmail.com>
 <642128d50f5423b3331e3108f8faf6b8ac0d957e.1684097002.git.lstoakes@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <642128d50f5423b3331e3108f8faf6b8ac0d957e.1684097002.git.lstoakes@gmail.com>
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

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
