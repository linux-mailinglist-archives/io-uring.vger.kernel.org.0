Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6392538BB0
	for <lists+io-uring@lfdr.de>; Tue, 31 May 2022 09:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244359AbiEaHBY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 May 2022 03:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234919AbiEaHBX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 03:01:23 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E458E95A17;
        Tue, 31 May 2022 00:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=11YROVflJ/JefMo7bFYJ/62V17ukhxQj7XQ/9+30v1Y=; b=nsy/Jl9ZoApZk2nkkID018WoZq
        iK10PPsuQ0kdaYdJJyf2bPHHgwXwSH6owo/vp2xMf//K6fsYJ0mTlRtfUwSSZnShCghb5V8kUxzRV
        POLi29x0ya2vzgOyY4fBHnUaNuAwEm3hHh8slagu7+zsXuAiSRitRxzY0KqO0oH8wNiDfkxx/GrAQ
        /xCYv7q90p9YKFKk/r206BJ8/IVDXQTEkPoysiz84W+W+nF/5wffXS30WvnIdopSWGU+gwJJOui4f
        5w8WFJB/7GE3i0rAc/o/I7c6pMK32z8ChibQdgwHYze2gYRVNzXvHMD9QIThD/qmD79ingFiFSWr8
        mOPHudeg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nvvsY-009e1a-Em; Tue, 31 May 2022 07:01:22 +0000
Date:   Tue, 31 May 2022 00:01:22 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org
Subject: Re: [PATCH v6 08/16] fs: Split off inode_needs_update_time and
 __file_update_time
Message-ID: <YpW9Qkn3yZbUvETE@infradead.org>
References: <20220526173840.578265-1-shr@fb.com>
 <20220526173840.578265-9-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526173840.578265-9-shr@fb.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patch itself looks fine, but I think with how the next patch goes
we don't even need it anymore, do we?

