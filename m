Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B05BD559210
	for <lists+io-uring@lfdr.de>; Fri, 24 Jun 2022 07:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiFXFUA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jun 2022 01:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiFXFUA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jun 2022 01:20:00 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D5F62C16;
        Thu, 23 Jun 2022 22:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CmZzTyGW86kGCLkluUVgPh+OfAMYe+DuVFM8OGCdpCU=; b=fA6geQpWNnz816AjU0KE7HCJMS
        iEK3mYQ1E1tZfmJ7Lpzb4e5cD9EEafs31PkdzJyZaBUR3cQTU6JyzFLYgZYlrlb6dm5jb3s9Xe/pY
        8QXUWwzdNlTgshaiYxclesvtpCci0unpNLP8ZzyvlMpILHVC4rpq1vBIfAHf8cE4AsPbALZ+KZD4Q
        fdYMd1W252YHFaaBLb0E/y5qKnh85QjKG+uDZ0TaKbM6qWzhXLBYP/jSf/Hkj08pc2JEHGXZclcna
        B6I+bBnGzZ55M1zRGRY21gllsIP0+R/jWWDigRww5M61EuOcgZn+8JCGbeljlc/hDsat9ziNc0UkY
        mAk17aQw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o4bjZ-000ZoG-0c; Fri, 24 Jun 2022 05:19:57 +0000
Date:   Thu, 23 Jun 2022 22:19:56 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        axboe@kernel.dk, willy@infradead.org
Subject: Re: [RESEND PATCH v9 06/14] iomap: Return -EAGAIN from
 iomap_write_iter()
Message-ID: <YrVJfPWQ29hYJ03M@infradead.org>
References: <20220623175157.1715274-1-shr@fb.com>
 <20220623175157.1715274-7-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623175157.1715274-7-shr@fb.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jun 23, 2022 at 10:51:49AM -0700, Stefan Roesch wrote:
> If iomap_write_iter() encounters -EAGAIN, return -EAGAIN to the caller.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
