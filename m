Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA4B2E0B71
	for <lists+io-uring@lfdr.de>; Tue, 22 Dec 2020 15:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgLVOIc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Dec 2020 09:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727155AbgLVOIc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Dec 2020 09:08:32 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40C9C0613D6;
        Tue, 22 Dec 2020 06:07:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XnsEBHKmuwIqwZw9cYL0vV1Aq/iIMWLNA0XSZ9mrSbg=; b=exJwyhWYmapTVxVLc5bGLvtE5d
        xNeJhmtHOFCQYPhZZMbrj1Ak3HZx014+BylUYe7e0y8E9Mp622pTlvwASCIsDdeSCsmv7Lmh0HL48
        8Qvm6gTQ62jKNPVvB64/PWV5SXme9lhmsN6iKgQXb6xkjUU4JJBBIJVcWczeB+bQXigaU2wrfmq4J
        YDvm5bgdc9w7SthjP+9MyxnOObP8X7yhLPflUnvdtXHdmUK0pqARb+tVbqkogWDOBLAXOZih3JCl/
        a9CfEss5uumx4/GKG2GjX/Z85bS4vzfdbYjk/2RaExluvXl0hjN6Qvn8uex3sNRp8PGNUWp4mBmlE
        4HKPrHvA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kriKL-0003nr-Mv; Tue, 22 Dec 2020 14:07:49 +0000
Date:   Tue, 22 Dec 2020 14:07:49 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Ming Lei <ming.lei@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v1 5/6] bio: add a helper calculating nr segments to alloc
Message-ID: <20201222140749.GD13079@infradead.org>
References: <cover.1607976425.git.asml.silence@gmail.com>
 <94b6f76d2d47569742ee47caede1504926f9807a.1607976425.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94b6f76d2d47569742ee47caede1504926f9807a.1607976425.git.asml.silence@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The new helper needs a comment explaining the use case.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
