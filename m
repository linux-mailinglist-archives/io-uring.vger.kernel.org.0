Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8EB3530199
	for <lists+io-uring@lfdr.de>; Sun, 22 May 2022 09:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239551AbiEVHce (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 May 2022 03:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234813AbiEVHc2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 May 2022 03:32:28 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 832F138796;
        Sun, 22 May 2022 00:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=OBykm/D/SYJ7gKlORyPx7N67S5gQLn7hn9NwpX1v5SU=; b=PMOm8v6Q+wNcm1jrngrSFqONja
        jVgBd8AYgnxsN3Ngg9iDtYbWz9qS4Av8r1Jgmvwspogs6v9wL6mkWtEoWdu7ZJVUg2jFrpeogETa9
        ZOhnP+AhiKVLXGI40BDT/E+CD0IBgGd25cHNrLwBMR0mGCKsJGSg3ehJiQEDnRGCiGRJyvfjSmSn8
        g1zE0SnFDsN4I6nGs8yhMbaA+6pmRFEfkZ87JwvPW3/xVI7a76eoS8LGhvUaEKyOiA8KA/8Vd0Qrx
        DHTz/zSd9wC87OgIGUsLz/QaxRN/5Zf/tykqXXwRRZWEM9I2KPw7hEbMa0O70YDeAQ7PVIPDk+Q1U
        ws1LL1FQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nsg4h-000nky-2K; Sun, 22 May 2022 07:32:27 +0000
Date:   Sun, 22 May 2022 00:32:27 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org
Subject: Re: [RFC PATCH v4 09/17] fs: Split off remove_needs_file_privs()
 __remove_file_privs()
Message-ID: <YonnC9JYZNWu8Mxr@infradead.org>
References: <20220520183646.2002023-1-shr@fb.com>
 <20220520183646.2002023-10-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520183646.2002023-10-shr@fb.com>
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

So why don't we just define a __file_remove_privs that gets the iocb
flags passed an an extra argument, and then make file_remove_privs pass
0 flags, and maybe also add a kiocb_remove_privs wrapper for callers
that have the kiocb.  Same for the timestamp update, btw.  That seems
less churn and less code overall.
