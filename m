Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E35E52CE52
	for <lists+io-uring@lfdr.de>; Thu, 19 May 2022 10:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234774AbiESI3X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 May 2022 04:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiESI3X (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 May 2022 04:29:23 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA39977F12;
        Thu, 19 May 2022 01:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Ukgjfu0f07JgF+7rcTkChhLVf35mD3VwAQNSxB4A74c=; b=2KsfGfpBAN8e+UBrmZruBq76Tu
        x2U73Zz1wCon4mBRYPPzJ38EWfWDfvzCcBhxN3vO5HlesTL9E+oewS9884wzkyXHJdJx6pTTSPEJY
        DaZQxpVroYYwx0qowINv1zkaDqI4EKbuRwxaY94yWXlCTU1d9LBRbCWJB6zMulSski5lEtMbg6wlS
        i5LGqDPAMfdytAWVUpqKkddZMcDzrr3289Y6YRi2utDeEVEZnFRdhMdeDaRGH5L1dXIpzrgUFfH8C
        sq5S7ODU+BN1l25ErPtqL4BcFhBlyqNPMHqJwx/WRV62pBuBRl7fLekjh6gFs4/fNB+V2j7Feovmp
        I5kbQTug==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nrbX8-005qpl-14; Thu, 19 May 2022 08:29:22 +0000
Date:   Thu, 19 May 2022 01:29:21 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
Subject: Re: [RFC PATCH v3 15/18] mm: Add
 balance_dirty_pages_ratelimited_async() function
Message-ID: <YoX/4fwQOYyTL34a@infradead.org>
References: <20220518233709.1937634-1-shr@fb.com>
 <20220518233709.1937634-16-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518233709.1937634-16-shr@fb.com>
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

> +static int balance_dirty_pages_ratelimited_flags(struct address_space *mapping,
> +						bool no_wait)
>  {

This doesn't actully take flags, but a single boolean argument.  So
either it needs a new name, or we actually pass a descriptiv flag.

> +/**
> + * balance_dirty_pages_ratelimited_async - balance dirty memory state
> + * @mapping: address_space which was dirtied
> + *
> + * Processes which are dirtying memory should call in here once for each page
> + * which was newly dirtied.  The function will periodically check the system's
> + * dirty state and will initiate writeback if needed.
> + *
> + * Once we're over the dirty memory limit we decrease the ratelimiting
> + * by a lot, to prevent individual processes from overshooting the limit
> + * by (ratelimit_pages) each.
> + *
> + * This is the async version of the API. It only checks if it is required to
> + * balance dirty pages. In case it needs to balance dirty pages, it returns
> + * -EAGAIN.
> + */
> +int  balance_dirty_pages_ratelimited_async(struct address_space *mapping)
> +{
> +	return balance_dirty_pages_ratelimited_flags(mapping, true);
> +}
> +EXPORT_SYMBOL(balance_dirty_pages_ratelimited_async);

I'd much rather export the underlying
balance_dirty_pages_ratelimited_flags helper than adding a pointless
wrapper here.  And as long as only iomap is supported there is no need
to export it at all.

