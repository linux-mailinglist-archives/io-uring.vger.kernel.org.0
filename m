Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A531559227
	for <lists+io-uring@lfdr.de>; Fri, 24 Jun 2022 07:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbiFXFVD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jun 2022 01:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiFXFVD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jun 2022 01:21:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982A968004;
        Thu, 23 Jun 2022 22:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kOVNnlzTgA+Z+gBxY/9/lvwQCMpKmmF91Zjw5AXklLw=; b=QEzbdjW3WU084VDeSmzi22h9cz
        7NC83oBNvkYUraBLAkV/eBBPhl6m/Xw4AIEbomTTvLl7QfMAgWt4zEPxF/bzP43mz9s8a0UiZyZCa
        JYphmUiPuM08T232y0D1p6D/8hDa/TAdT1GiiWTwB1G/Tv6J5xm2FeOQiV/c+RadsQU/Ve7NiZ8pe
        M6qKeHv4D0LRru5iDPKTotzkTgtoQPRubNwaMz0aglhS9txRCkmkrLGYjzofdaIo9Dz+0EKyGBrMz
        g1X0r8hGE/GJYk6YnylvU8KgwWbtvfR5Af3ihjePPUsLGxt0lxJBAL5mAHqqPxPBy1Mj4HHn2EzwJ
        AKMK/i7w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o4bka-000aAk-91; Fri, 24 Jun 2022 05:21:00 +0000
Date:   Thu, 23 Jun 2022 22:21:00 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        axboe@kernel.dk, willy@infradead.org,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <brauner@kernel.org>
Subject: Re: [RESEND PATCH v9 07/14] fs: Add check for async buffered writes
 to generic_write_checks
Message-ID: <YrVJvA+kOvjYJHqw@infradead.org>
References: <20220623175157.1715274-1-shr@fb.com>
 <20220623175157.1715274-8-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623175157.1715274-8-shr@fb.com>
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

FYI, I think a subject like

"fs: add a FMODE_BUF_WASYNC flags for f_mode"

might be a more descriptive.  As the new flag here really is the
interesting part, not that we check it.
