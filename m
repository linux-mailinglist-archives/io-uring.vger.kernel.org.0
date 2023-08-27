Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B92D278A19A
	for <lists+io-uring@lfdr.de>; Sun, 27 Aug 2023 22:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjH0Urd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 27 Aug 2023 16:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbjH0UrV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 27 Aug 2023 16:47:21 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CECCBF;
        Sun, 27 Aug 2023 13:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PcFOPVpAmfEy32wmLZk8ueqNLvTCgnNwnqcJznT/RPQ=; b=rNsimzjbKmM2oAlOTJ0DzjsqcD
        17aYtuzwaGU+CR8bJtkEeJr/wCSQMKchDc0n2mlQZ7v9rEEKKGacwZsk+Mho4BlGQdRHWhRckPvPs
        fMAYQy7+QXBdTjAznfYn8yoo2Vt8NnBgsp0KpbdkC6EeIBdGLqHsafJ8s67fpw63Doi4IWtOlBji1
        MNTrBEfgnOFbk2WLamTkOgHWwWl/muBmiqb1Xzl2D+NHqIQ82dzKbnLLfmjRYZ7IV0n24RJ6z3j9d
        dk+Bi80MVVBrmB0+FFfEqYIN7sGr6Bu4FSHMLVu2SkHeyRuhO+l5+YcAQVjuGi14l8MuPMLDNTwlB
        D4MIXbrw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qaMf3-00DklQ-NN; Sun, 27 Aug 2023 20:47:05 +0000
Date:   Sun, 27 Aug 2023 21:47:05 +0100
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
Subject: Re: [PATCH 04/11] vfs: add a vfs helper for io_uring file pos lock
Message-ID: <ZOu2SbpbRtQPeaDk@casper.infradead.org>
References: <20230827132835.1373581-1-hao.xu@linux.dev>
 <20230827132835.1373581-5-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230827132835.1373581-5-hao.xu@linux.dev>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Aug 27, 2023 at 09:28:28PM +0800, Hao Xu wrote:
> +++ b/include/linux/file.h
> @@ -81,6 +81,8 @@ static inline void fdput_pos(struct fd f)
>  	fdput(f);
>  }
>  
> +extern int file_pos_lock_nowait(struct file *file, bool nowait);

No extern on function declarations.
