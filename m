Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3D10538BC7
	for <lists+io-uring@lfdr.de>; Tue, 31 May 2022 09:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244337AbiEaHFm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 May 2022 03:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243395AbiEaHFl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 03:05:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 055F7972A8;
        Tue, 31 May 2022 00:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZWTAexFEZbhBo5spKs3rq2FWdrwX8G7RgSIvxHi5RmQ=; b=YB/ZZBr77bLyjSaRO09WsY3nsv
        8IVQsPttfbJfnnSaPOF9wx9w92qczr7FA0aDIB6yVx24cuVdrAXKgUN2DcT9mAPxQCVfuZAP3RvS4
        o8opr/EPGUlHb1vwBzt8KW14aHhQd7iwPapqlnmP9p2D51P0ocvsIW8sjtMzuEVGYSolBiH5idvkW
        qiiXgmrcpB8ZtD1tXMugFo7r7EJRMwmnRzc1gLUNC28p00IGVK/9OUz9Lkdluby5U317CaUWRh4aC
        pJVPFwgs4aNrY5uUWj2ofWLlvnnegvyUvPfme0mSDp1gKAI7hDEdSX3va1A4rC4WAJhVXTeIpO0AA
        I+p81lSA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nvvwi-009env-HB; Tue, 31 May 2022 07:05:40 +0000
Date:   Tue, 31 May 2022 00:05:40 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org
Subject: Re: [PATCH v6 16/16] xfs: Enable async buffered write support
Message-ID: <YpW+RKOGGkywMheu@infradead.org>
References: <20220526173840.578265-1-shr@fb.com>
 <20220526173840.578265-17-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526173840.578265-17-shr@fb.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 26, 2022 at 10:38:40AM -0700, Stefan Roesch wrote:
> This turns on the async buffered write support for XFS.

I think this belongs into the previous patch, but otherwise this looks
obviously fine.
