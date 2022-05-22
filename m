Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3085D53018E
	for <lists+io-uring@lfdr.de>; Sun, 22 May 2022 09:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236552AbiEVHYG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 May 2022 03:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235208AbiEVHYF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 May 2022 03:24:05 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C513C63B8;
        Sun, 22 May 2022 00:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jpqo4ZefQHaMA5S5OSvPtjCRSete+aQ/dNFBECqTMkk=; b=mBiqo/L1d9jx1h/KO3v4izVQWv
        DoleK9XcwWp1+QBH17/8SZWzkg6Y5U1IO2sL9rJlhgtQpiJnv4uITRuB7u9WWjSav+HZgKEdYB+J6
        7QRX+1kpnb2BDAxKMlC2zbRvxM3PdwPLLJ0eyy5zMZcfUNAGb3uKW+IkbiaLq2Qm1RJQlIKf9FIdb
        ZqCLiA9S9Fqu62fcbxkU+gBfNoAY2nbehNOKmJiMoIl82DMMcH1VkcjZOGjUHYZIEOv+uSq7S9Bmj
        jF4rC86x+RyM+FvaPcb9NGbzOvetOdRblsgaMyRcncrmdb65F4pr03TVY1FmwD2DPE/B9jYTH2BVH
        50kvDqfA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nsfwZ-000mrI-Ls; Sun, 22 May 2022 07:24:03 +0000
Date:   Sun, 22 May 2022 00:24:03 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org
Subject: Re: [RFC PATCH v4 11/17] fs: Add async write file modification
 handling.
Message-ID: <YonlE9w2VhSa0jcq@infradead.org>
References: <20220520183646.2002023-1-shr@fb.com>
 <20220520183646.2002023-12-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520183646.2002023-12-shr@fb.com>
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

> +int file_modified_async(struct file *file, int flags)

file_modified_flags?  Or even bette kiocb_modified and pass the
kiocb as that makes is very clear which flags we use by making that
implicit.

> +EXPORT_SYMBOL(file_modified_async);

EXPORT_SYMBOL_GPL, please.

> -	return file_modified(file);
> +	return file_modified_async(file, iocb->ki_flags);

And this should go into the XFS enablemnt patch.

>  extern int file_modified(struct file *file);
> +extern int file_modified_async(struct file *file, int flags);

No need for the extern here, or any function declarations for that
matter.
