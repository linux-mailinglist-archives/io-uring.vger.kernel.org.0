Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6036209C2
	for <lists+io-uring@lfdr.de>; Tue,  8 Nov 2022 07:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233352AbiKHGyM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Nov 2022 01:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiKHGyM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Nov 2022 01:54:12 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ACD31F639;
        Mon,  7 Nov 2022 22:54:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=VOakFTCaKuLEv2D82OsubD8D3LPFiH3ckd5BU32nB6c=; b=zQYXaJOW6FGyL9jF7Lhii2muZj
        TeEqbO6rv/5PGxbx49t18GEjv3piBdOQDek931YO+oLwtD6q1Z1G9+8cRntrKgteUYTJXjsdqTlaX
        9SIaWNE+Ugr0mmvcWtfDPTLTht/oyqbbX3mCY66ozEPg5D4mHJXh3iCLobh00HFEOeWABjbr1GhCW
        18teDAk+mv+XHHjawk1EDAILFyW2G/tW5b3AFDBYhbB+f4Wq/C6HBBkfXblTJUWyx9DwrZVqYqS5N
        po7N+aR3GbeUswvMsPzfSFd6vOi2C9XuddOhN/GqbueiyoVGNkrukfXq1Spx1SdLNftCYtDhJH0Qu
        moljlSFg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1osIUo-003IJZ-Bs; Tue, 08 Nov 2022 06:54:06 +0000
Date:   Mon, 7 Nov 2022 22:54:06 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Keith Busch <kbusch@meta.com>
Cc:     viro@zeniv.linux.org.uk, axboe@kernel.dk, io-uring@vger.kernel.org,
        asml.silence@gmail.com, linux-fsdevel@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 0/4] io_uring: use ITER_UBUF
Message-ID: <Y2n9DteukhGuvdGe@infradead.org>
References: <20221107175610.349807-1-kbusch@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107175610.349807-1-kbusch@meta.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Nov 07, 2022 at 09:56:06AM -0800, Keith Busch wrote:
>   1. io_uring will always prefer using the _iter versions of read/write
>      callbacks if file_operations implement both, where as the generic
>      syscalls will use .read/.write (if implemented) for non-vectored IO.

There are very few file operations that have both, and for those
the difference matters, e.g. the strange vectors semantics for the
sound code.  I would strongly suggest to mirror what the normal
read/write path does here.

>   2. io_uring will use the ITER_UBUF representation for single vector
>      readv/writev, but the generic syscalls currently uses ITER_IOVEC for
>      these.

Same here.  It might be woth to use ITER_UBUF for single vector
readv/writev, but this should be the same for all interfaces.  I'd
suggest to drop this for now and do a separate series with careful
review from Al for this.
