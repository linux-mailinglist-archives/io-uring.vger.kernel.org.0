Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4427E543BAE
	for <lists+io-uring@lfdr.de>; Wed,  8 Jun 2022 20:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbiFHSpE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jun 2022 14:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiFHSpD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jun 2022 14:45:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082F815FCA;
        Wed,  8 Jun 2022 11:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FDjnLy+pI0O/9EP1fTGUd0rLGC+Ln6Gxzq93mIPlllk=; b=tFBJwCDmwykMjxJ7Hc1+s8JLfs
        85ul7YYMILGBrwvnVYlEI7s5Yomxtf1Ba0eELxJ88nPSlAPr7qjdYtp73+ktB0IaINpwxM55ww6FU
        ayAMehnXjXOI12TayMfNRDrf2ziYunqu4/gRnuTpgckH/4ZPbuw3PX83mPeWSTmKg7UJckf8VvFFD
        rDanMF9/iUutBiW0pF9H+Gef7wj+OD9NyxHD2elfWPr1cXGVIKyMRyU3WHWnuF2C7nmwB2TAK+xG/
        crGbXSEI8sfP2cZ+VlGSofb0pKzbBKQaTA8L3CKhJHq+zU8fpG6NcVnEq81kcbvCLiGbNTIGFIm1b
        cWlACf3Q==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nz0fo-00Csi5-Le; Wed, 08 Jun 2022 18:44:56 +0000
Date:   Wed, 8 Jun 2022 19:44:56 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        axboe@kernel.dk, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v8 03/14] mm: Add balance_dirty_pages_ratelimited_flags()
 function
Message-ID: <YqDuKCXzRDjyyam2@casper.infradead.org>
References: <20220608171741.3875418-1-shr@fb.com>
 <20220608171741.3875418-4-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608171741.3875418-4-shr@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jun 08, 2022 at 10:17:30AM -0700, Stefan Roesch wrote:
> -/**
> - * balance_dirty_pages_ratelimited - balance dirty memory state
> - * @mapping: address_space which was dirtied
> - *
> - * Processes which are dirtying memory should call in here once for each page
> - * which was newly dirtied.  The function will periodically check the system's
> - * dirty state and will initiate writeback if needed.
> - *
> - * Once we're over the dirty memory limit we decrease the ratelimiting
> - * by a lot, to prevent individual processes from overshooting the limit
> - * by (ratelimit_pages) each.
> - */
> -void balance_dirty_pages_ratelimited(struct address_space *mapping)
> +int balance_dirty_pages_ratelimited_flags(struct address_space *mapping,
> +					unsigned int flags)

I'm distressed to see no documentation for
balance_dirty_pages_ratelimited_flags().  I see it got moved down to
balance_dirty_pages_ratelimited(), but this function is externally
visible and needs (at the very least) something like this:

/**
 * balance_dirty_pages_ratelimited_flags - Balance dirty memory state.
 * @mapping: address_space which was dirtied.
 * @flags: BDP flags.
 *
 * See balance_dirty_pages_ratelimited() for details.
 *
 * Return: If @flags contains BDP_ASYNC, it may return -EAGAIN to
 * indicate that memory is out of balance and the caller must wait
 * for I/O to complete.  Otherwise, it will return 0 to indicate
 * that either memory was already in balance, or it was able to sleep
 * until the amount of dirty memory returned to balance.
 */

