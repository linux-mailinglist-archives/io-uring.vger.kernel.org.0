Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E74C788B27
	for <lists+io-uring@lfdr.de>; Fri, 25 Aug 2023 16:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235376AbjHYOKs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 10:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343759AbjHYOKo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 10:10:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624F12D49;
        Fri, 25 Aug 2023 07:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=EU4c+QvmUrzx56YT6HV/cCIR2Pjqx+IXpn7k2GV7Q+c=; b=sXnwInRucx8CcJKwrlTfZ031er
        LEY7y8jsL9Hib5zZnhCnKvqEBOaupx8CYhaoOaWj/VYF41GGvSOMwZwP7gnqnUjyUY5nybhBoSrxT
        cix5TlGhcoCY3jjdx5/eXfy7PSYCUWLL6z2ZL1LRTqjCJLf619sI6Mfr/SSckV734m8GK683QEHy+
        aF/xKkJIUvAhE/VXofyvjMKZ4LYU11OPTfozENym+/mg5hUGQWADpmiwU301hOx3e6IcpV8ta4h3y
        7U3MMVZnd623qdMqd3D0FkVtdSaK+AiLgU+Qa7F9jQSRFB1EUCUT2iSVWxr49S72DAzkgcEx6R3cM
        2mytwuWw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qZXUl-00HWBm-5H; Fri, 25 Aug 2023 14:09:03 +0000
Date:   Fri, 25 Aug 2023 15:09:03 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Hao Xu <hao.xu@linux.dev>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-cachefs@redhat.com,
        ecryptfs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-unionfs@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-btrfs@vger.kernel.org, codalist@coda.cs.cmu.edu,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-mm@kvack.org, linux-nilfs@vger.kernel.org,
        devel@lists.orangefs.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-mtd@lists.infradead.org,
        Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH 22/29] xfs: comment page allocation for nowait case in
 xfs_buf_find_insert()
Message-ID: <ZOi1/yafn3HQFWnW@casper.infradead.org>
References: <20230825135431.1317785-1-hao.xu@linux.dev>
 <20230825135431.1317785-23-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230825135431.1317785-23-hao.xu@linux.dev>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Aug 25, 2023 at 09:54:24PM +0800, Hao Xu wrote:
> @@ -633,6 +633,8 @@ xfs_buf_find_insert(
>  	 * allocate the memory from the heap to minimise memory usage. If we
>  	 * can't get heap memory for these small buffers, we fall back to using
>  	 * the page allocator.
> +	 * xfs_buf_alloc_kmem may return -EAGAIN, let's not return it but turn
> +	 * to page allocator as well.

This new sentence seems like it says exactly the same thing as the
previous sentence.  What am I missing?

