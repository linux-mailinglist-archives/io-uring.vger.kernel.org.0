Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0497D2E0B7C
	for <lists+io-uring@lfdr.de>; Tue, 22 Dec 2020 15:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgLVOL4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Dec 2020 09:11:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbgLVOL4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Dec 2020 09:11:56 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D93C0613D6;
        Tue, 22 Dec 2020 06:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=T+iXOP0M1Q96GjQwN7A0jbcvtdBz8ylHUEIBZyFxI8I=; b=PeK+jxcEN9Ejy/YT3iuu9bqQFV
        7MYpiQ6MVIDoC07jo6Sb1KyxsiLNp/bafk92FKVYRNJk2pwjwrZ9Flk6GSvkhS7h+O3IfD9Ei2thK
        B98TTdovOFeDCsH6r0ocT67368f7x0o+JIL0zp1TBG8JY+IzqJQBgN2xUx7a1wVQK7BZNnnDibsCd
        Qg98YScZ5H1Gl5f8SF8aD4kVU8TGakW14RHIJCiQ4jhS8/xMI15DOpnymEbhFkIje4sxCcWRbsKO9
        z33BDSDf6kKnTtAqGIJKVE/ZYH4s/x/W7vkbPvN9389IvWQikHwQNG9zv+6ujEMaJC7vxtwuhmsbm
        5PoND+Qg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kriNc-00048z-VF; Tue, 22 Dec 2020 14:11:13 +0000
Date:   Tue, 22 Dec 2020 14:11:12 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v1 0/6] no-copy bvec
Message-ID: <20201222141112.GE13079@infradead.org>
References: <cover.1607976425.git.asml.silence@gmail.com>
 <20201215014114.GA1777020@T590>
 <103235c1-e7d0-0b55-65d0-013d1a09304e@gmail.com>
 <20201215120357.GA1798021@T590>
 <e755fec3-4181-1414-0603-02e1a1f4e9eb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e755fec3-4181-1414-0603-02e1a1f4e9eb@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Dec 15, 2020 at 02:05:35PM +0000, Pavel Begunkov wrote:
> > You may find clue from the following link:
> > 
> > https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg2262077.html
> 
> Thanks for the link!
> 
> Al, you mentioned "Zero-length segments are not disallowed", do you have
> a strong opinion on that? Apart from already diverged behaviour from the
> block layer and getting in the way of this series, without it we'd also be
> able to remove some extra ifs, e.g. in iterate_bvec()

I'd prefer not to support zero-length ITER_BVEC and catching them
early, as the block layer can't deal with them either.  From a quick
look at iter_file_splice_write it should be pretty trivial to fix there,
although we'll need to audit other callers as well (even if I don't
expect them to submit this degenerate case).
