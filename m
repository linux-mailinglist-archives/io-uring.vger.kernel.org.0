Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86234538BB3
	for <lists+io-uring@lfdr.de>; Tue, 31 May 2022 09:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244410AbiEaHBq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 May 2022 03:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243917AbiEaHBp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 03:01:45 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA6665A6;
        Tue, 31 May 2022 00:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=xEuZfUUz6m1/uZ8VIxwUp0Xmz3
        dXtbHR/AJxI1hnh008fgG5WrYVVTgiI/4QCR7++ChwOlT2AHIJHpz0uu/x6YaZ+73lLDvG3nvRw1+
        54bx6BBWhPPXLg6I44MWrnJ3eUUTyxEii+K2kf4p2BoChe8QUkpaZ+krEY/hNYFThRcV5eST69Jjk
        qTJVeUpJ4w7x2SGDyAXNMyXqvhwFB+kSv51qZb7/6l9bqEqVk7mGEPNvbKt7EmB2h48Rpy9quyAf8
        8rPTcAPBoptHOfP+IjYGZASuzp8FNYuzBnuQQYbgHl9OaBwgohKMmmL2mmlHhqBl5CKdy230Yi+tq
        h3OSBE9w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nvvst-009e7n-In; Tue, 31 May 2022 07:01:43 +0000
Date:   Tue, 31 May 2022 00:01:43 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org
Subject: Re: [PATCH v6 09/16] fs: Add async write file modification handling.
Message-ID: <YpW9V9+oAQHxJX1E@infradead.org>
References: <20220526173840.578265-1-shr@fb.com>
 <20220526173840.578265-10-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526173840.578265-10-shr@fb.com>
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
