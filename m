Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9F52E0B5C
	for <lists+io-uring@lfdr.de>; Tue, 22 Dec 2020 15:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgLVOFh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Dec 2020 09:05:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726868AbgLVOFh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Dec 2020 09:05:37 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF997C0613D3;
        Tue, 22 Dec 2020 06:04:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DxJqoJ8PnZK608eAZuGRcAj/J+cjWwjqs4ZUdTA2aew=; b=Wk0QyNPy3C7mnC8JzcEbs7bvSx
        ozNMMdU8xG2atPmKs5376oVfRxkJIVdFdrKtl2H+yVycLYEyCN5/KErhmQ7HlYH5spEQ+OBxzePES
        fzTTHU4psBg+4K1MNT4mWu1vr+rUS9JyISGryO9MeVUuq1zXfuiu/N2BfoJ/tDz2xip/4liR36iwG
        U4xmkNIHV9G8zFqFtZbkduhNh2YrClKJ1TG+drl9Nl9/1tfWcxO+pbSoRciPdzOEaRhwSv8RRU0FQ
        tGul94ouWAU8VpNmAsLvphJ0llkmVPz4nUXj2PHJJYkjHiHLESJo6fSQww5RaGcZmBT3Z/4Nc90k+
        CBkCCo9A==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kriHX-0003Xe-5N; Tue, 22 Dec 2020 14:04:55 +0000
Date:   Tue, 22 Dec 2020 14:04:55 +0000
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
Subject: Re: [PATCH v1 3/6] bio: deduplicate adding a page into bio
Message-ID: <20201222140455.GB13079@infradead.org>
References: <cover.1607976425.git.asml.silence@gmail.com>
 <189cae47946fa49318f85678def738d358e8298b.1607976425.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <189cae47946fa49318f85678def738d358e8298b.1607976425.git.asml.silence@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If it was up to me I'd shorten noaccount to noacct.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
