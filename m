Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6462E9AF1
	for <lists+io-uring@lfdr.de>; Mon,  4 Jan 2021 17:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbhADQW3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jan 2021 11:22:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727886AbhADQW2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jan 2021 11:22:28 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E90C061574;
        Mon,  4 Jan 2021 08:21:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=c0jpPOEqnvAg3akTI36JpIt9xU
        3Ekb+xZLKcCXAuP6aX6X9X8OGfhEZ17fGCaGMIef9SYWHAdGFc3uo+vlM9b1aXhF2iUKc3eoM/+dB
        IQGe6jvfoR/G8XoGFUMvlRk4jRdegFaYaE6jx2RsUzv3k6nJKLUfpQHggy8F8pB0AZd+3mRagBkmm
        m3WCbGkk0X4L0vgPqIe18hM7QT3VbjVhhWEDpUWZER/+kUzQkuZsCNMWKvmvJtTLy6zB8vkGFhGvM
        MziqpdCXp1G/luzbgryf1rW4esI1mIB1/QXusWuiHmvToORh0ubs8CpGH8homiD0Ul2EDf3i99GBY
        fTjSWP2g==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kwSbF-000I7h-7f; Mon, 04 Jan 2021 16:20:54 +0000
Date:   Mon, 4 Jan 2021 16:20:53 +0000
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
Subject: Re: [PATCH v2 7/7] bio: don't copy bvec for direct IO
Message-ID: <20210104162053.GC68600@infradead.org>
References: <cover.1609461359.git.asml.silence@gmail.com>
 <29ed343fa15eb4139f8ab9104d3f9b16fe025dfd.1609461359.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29ed343fa15eb4139f8ab9104d3f9b16fe025dfd.1609461359.git.asml.silence@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
