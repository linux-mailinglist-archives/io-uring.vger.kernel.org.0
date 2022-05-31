Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F91A538BBF
	for <lists+io-uring@lfdr.de>; Tue, 31 May 2022 09:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242917AbiEaHFH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 May 2022 03:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236941AbiEaHEw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 03:04:52 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE4E91584;
        Tue, 31 May 2022 00:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=oVJpnjRN3uu9YWQ3925Ggyja7JOC+2S+QQtKpyilufU=; b=46ICdxEoY7uCcE0MhluKeHSQUc
        pp+stswRc2WEnoWJmcvwCOxs/nTh2Lc97RFrCy8tZl4krbOj9P7lmXOGIouJsguNa7wCDXnfqC6Kq
        YUSTNxI5fo8FKv/oE0ZuE6uXdr4rNWPqKqW51UT0XE2f2HHtZlPCznaQPlYPrHO2aKZBg+OuN47fz
        MYb+WdflW7nHnmHO7EqmYHfsiZWprv1l4O7VGLyecCTcV3BBs22QESk5sjuG4oilgkxipxCVSGx0k
        4UnO7AVJWIYwRhandFLJOnnm5bc8mZuKZRamJNCW3Z4LUycMcx5KGbEd0xnSE0TYj5bDzq/gzunCI
        A/2eS0WQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nvvvp-009ec0-MN; Tue, 31 May 2022 07:04:45 +0000
Date:   Tue, 31 May 2022 00:04:45 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org
Subject: Re: [PATCH v6 14/16] xfs: Change function signature of
 xfs_ilock_iocb()
Message-ID: <YpW+DToVN0NjUpx4@infradead.org>
References: <20220526173840.578265-1-shr@fb.com>
 <20220526173840.578265-15-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526173840.578265-15-shr@fb.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 26, 2022 at 10:38:38AM -0700, Stefan Roesch wrote:
> This changes the function signature of the function xfs_ilock_iocb():
> - the parameter iocb is replaced with ip, passing in an xfs_inode
> - the parameter iocb_flags is added to be able to pass in the iocb flags
> 
> This allows to call the function from xfs_file_buffered_writes.

xfs_file_buffered_write?  But even that already has the iocb, so I'm
not sure why we need that change to start with.
