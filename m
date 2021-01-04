Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE9912E9B31
	for <lists+io-uring@lfdr.de>; Mon,  4 Jan 2021 17:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbhADQiq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jan 2021 11:38:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727897AbhADQip (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jan 2021 11:38:45 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685EFC061793;
        Mon,  4 Jan 2021 08:38:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jtkbapT8fmTkqdGfawodnxdn1L9OuJ2hV6kgW2yTqWk=; b=kPgHDr7sil9tk8p6Bt6Pg7BkoU
        qgIFz+hKZQewdgVs5RRcTUS8US4wERe/1Ik9TLb7yss87lkLOSjfChOBjgFVcdJGJqGqKRcfOclCn
        y+Fk/AajWS5n6Dnx+M7QBg4FrHcUBHQeD8KAxcb7SOO1nzdvOs9WceX3ackS4w9cx3Tr9zvtzhsMs
        htyNAT7f4vdjSW0tQ1tiAZL2lOrexShD800pjnGRTvsN6+Ry9GtpShUREBOFDmPg5+NQLyPvkMlo/
        Zvj67UkaUamUNM9aDHexzMNReovVddfdRhtk68Bhu+gEPy71ABUAOCUPs7K0PQdTbD7vZs4RR+NIJ
        uNehDS9g==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kwSrj-000JJd-C5; Mon, 04 Jan 2021 16:37:56 +0000
Date:   Mon, 4 Jan 2021 16:37:55 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Ming Lei <ming.lei@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 2/7] bvec/iter: disallow zero-length segment bvecs
Message-ID: <20210104163755.GA22407@casper.infradead.org>
References: <cover.1609461359.git.asml.silence@gmail.com>
 <b46b8c1943bbefcb90ea5c4dd9beaad8bbc15448.1609461359.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b46b8c1943bbefcb90ea5c4dd9beaad8bbc15448.1609461359.git.asml.silence@gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Jan 02, 2021 at 03:17:34PM +0000, Pavel Begunkov wrote:
> --- a/Documentation/filesystems/porting.rst
> +++ b/Documentation/filesystems/porting.rst
> @@ -865,3 +865,10 @@ no matter what.  Everything is handled by the caller.
>  
>  clone_private_mount() returns a longterm mount now, so the proper destructor of
>  its result is kern_unmount() or kern_unmount_array().
> +
> +---
> +
> +**mandatory**
> +
> +zero-length bvec segments are disallowed, they must be filtered out before
> +passed on to an iterator.

Why are you putting this in filesystems/porting?  Filesystems don't usually
generate bvecs ... there's nothing in this current series that stops them.
I'd suggest Documentation/block/biovecs.rst or biodoc.rst (and frankly,
biodoc.rst needs a good cleanup)
