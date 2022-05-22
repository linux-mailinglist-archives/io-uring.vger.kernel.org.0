Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2E3530195
	for <lists+io-uring@lfdr.de>; Sun, 22 May 2022 09:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345270AbiEVHds (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 May 2022 03:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344951AbiEVHds (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 May 2022 03:33:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 388803B2AC;
        Sun, 22 May 2022 00:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4gdF6O3kUX9Och/QIOagwvCP4ijVcQquNR1zIJ/LzOY=; b=4Usxbn5+rwTA8NGZmpo+mf5yRu
        8kWhWSCziTXwxyuMJZmmS6x5/iMjYMx9/tgohDjJP+0jloOY9iwB7IsKs8ydTzoVqVOauSMEIhN/X
        AGs7e8XrbTsjvLT/LuGRJZnqF/66+bnv/FNpUjlReSzrPd6qEc7nxbY0abWAXoXsN+EUvu7aL4mgl
        QQY4glFu9dIO2f2EoEk8fa2hfXx7BZiqZkWcKcteeQk8gMGKK/OdiJcKQRR3XvODTyKcQt66wK+XZ
        nv9ucmb4Kc1AxjP4usluux/bs+M89MPOL9OyzNIJYFIjT+OlI95Gzk7CLDP5zFMU8wuFExMA/qwBh
        cJCNkRCA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nsg5y-000nwe-Kb; Sun, 22 May 2022 07:33:46 +0000
Date:   Sun, 22 May 2022 00:33:46 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org
Subject: Re: [RFC PATCH v4 15/17] xfs: Add iomap async buffered write support
Message-ID: <YonnWjcb2opa/f0X@infradead.org>
References: <20220520183646.2002023-1-shr@fb.com>
 <20220520183646.2002023-16-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520183646.2002023-16-shr@fb.com>
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

On Fri, May 20, 2022 at 11:36:44AM -0700, Stefan Roesch wrote:
> This adds the async buffered write support to the iomap layer of XFS. If
> a lock cannot be acquired or additional reads need to be performed, the
> request will return -EAGAIN in case this is an async buffered write
> request.
> 
> This patch changes the helper function xfs_ilock_for_iomap such that the
> lock mode needs to be passed in.

So from a pure commit structure POV, I'd make the changes to
xfs_ilock_for_iomap one separate and clearly document patch, and then
merge all the rest of the XFS enablement into a single other patch.
