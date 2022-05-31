Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71AA3538B96
	for <lists+io-uring@lfdr.de>; Tue, 31 May 2022 08:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244371AbiEaGwb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 May 2022 02:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244370AbiEaGwa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 02:52:30 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D2B87E1C6;
        Mon, 30 May 2022 23:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=QftehnXD0t6zU0rR+xdgmVq3Th
        /2gefJLtcNI4+kZSB/Re/Q4DUK0q6ZJ1s8uh9vDhUQYeCPBzSZI1pR6cfQ1LiV3vL6XOtT96m3btv
        u/z3+DUiy2dTLaOnPhRlbl/5hgTNv+1YGZk/j1dwRCBT1kmQMJeRV7hwVzQYFKp19J2E0C3tsJVYb
        O+zt/3c4UXW3s9h+YY/a+bD2N0jUD/b5iOnyreRPv+ph7AjZRjvQZ0cFR3FtJs6GaU75NE9WvmmF0
        E4oi+YFnLd0S2p+FUbf0LOYee0/yGPYgrUMFWMQSgbTqIGnKaVQRbKNeGIYciG65bpXdigWOwpTm2
        EoW9vbww==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nvvjs-009cNG-BS; Tue, 31 May 2022 06:52:24 +0000
Date:   Mon, 30 May 2022 23:52:24 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org
Subject: Re: [PATCH v6 03/16] mm: Add balance_dirty_pages_ratelimited_flags()
 function
Message-ID: <YpW7KBU56E/E/C2p@infradead.org>
References: <20220526173840.578265-1-shr@fb.com>
 <20220526173840.578265-4-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526173840.578265-4-shr@fb.com>
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
