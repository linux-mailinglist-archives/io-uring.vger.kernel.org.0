Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 058A22E1EF6
	for <lists+io-uring@lfdr.de>; Wed, 23 Dec 2020 16:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgLWPwb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Dec 2020 10:52:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbgLWPwa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Dec 2020 10:52:30 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B2CFC06179C;
        Wed, 23 Dec 2020 07:51:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DvH0NyUD3VzfHuiFkeAq1PYtCpt4Xs2NiwNXDYcFb5E=; b=r5Av1aYEpmlsqfXcI87HZwooYp
        hNoYZTPHlzpf8R3PngDBkeUYyekmPZHjSvP+5Y3t/QDQeOb7PjtU60bOreHBspxZd8YUySWfx6LXs
        Jc2J9cL/2SNWMnDDg0JGyL1dbeq6bwFLoAYSIkWYQpYYDrcyBWd1k7ay5dhh6Ajknf6vcfWMobB4M
        d7YDf4C3uW5cb8WAsCp1mdzQnIS5cXmqbZK92BQ+Gkc1Nn7tDAmwqTDjrN+pMSjzMJ8ia/7RQBNPY
        TuwEJMOQDeNP7zK1fBQ2omM4imubJcd/XoiZyc13i9XFXRjtUoP5Advk/4h1hgU32RFuK0kJecodo
        rkLAE63g==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ks6QT-0001ad-OM; Wed, 23 Dec 2020 15:51:45 +0000
Date:   Wed, 23 Dec 2020 15:51:45 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
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
Message-ID: <20201223155145.GA5902@infradead.org>
References: <cover.1607976425.git.asml.silence@gmail.com>
 <20201215014114.GA1777020@T590>
 <103235c1-e7d0-0b55-65d0-013d1a09304e@gmail.com>
 <20201215120357.GA1798021@T590>
 <e755fec3-4181-1414-0603-02e1a1f4e9eb@gmail.com>
 <20201222141112.GE13079@infradead.org>
 <933030f0-e428-18fd-4668-68db4f14b976@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <933030f0-e428-18fd-4668-68db4f14b976@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 23, 2020 at 12:52:59PM +0000, Pavel Begunkov wrote:
> Can scatterlist have 0-len entries? Those are directly translated into
> bvecs, e.g. in nvme/target/io-cmd-file.c and target/target_core_file.c.
> I've audited most of others by this moment, they're fine.

For block layer SGLs we should never see them, and for nvme neither.
I think the same is true for the SCSI target code, but please double
check.
