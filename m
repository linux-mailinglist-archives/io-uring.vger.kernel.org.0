Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 143A32E0B6E
	for <lists+io-uring@lfdr.de>; Tue, 22 Dec 2020 15:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbgLVOH6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Dec 2020 09:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727227AbgLVOH6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Dec 2020 09:07:58 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B380BC0613D3;
        Tue, 22 Dec 2020 06:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HPjwx9Eom3k5Y+MPv+j4+M7Nms60E104uUeSn1eSQ7o=; b=Md9JZnpJ8HscU6pVN4BX/HhdCV
        ivSzpB9l32+i2rJqAsB+ttmiIDZQMKQTI/2AQOPO/Y/eA077L6xT5iAsUkDJUGLZGXr4NXkftXiA8
        KJZCgUBhAqzrRY/bloawkGO4LGa61CL6jxeVrY4dUFkilVXticty6G64zoN4r4PkHrD8WOH2rXEzT
        3Ne0KXNZnpc4jQkFekY4lpeFJnv/rxnJ+7zoRpkgKSI/aib8KfHa/BkESHTgI7zQ88RJDStwiGnlW
        PgwWTaT6Xd7M0vJjEbVYD0ROK5ClVPvg7ImZtP8U0jF6/BJEpIGmP+/DTJ2gM8EtjBPzd7bPLlqin
        u//P9fXA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kriJn-0003lz-Se; Tue, 22 Dec 2020 14:07:15 +0000
Date:   Tue, 22 Dec 2020 14:07:15 +0000
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
Subject: Re: [PATCH v1 4/6] block/psi: remove PSI annotations from direct IO
Message-ID: <20201222140715.GC13079@infradead.org>
References: <cover.1607976425.git.asml.silence@gmail.com>
 <1d3cf86668e44b3a3d35b5dbe759a086a157e434.1607976425.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d3cf86668e44b3a3d35b5dbe759a086a157e434.1607976425.git.asml.silence@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I think the commit log could use some rewording with less "as reported"
and "apparently".  IMHO it is more obvious to just clear the flag in
__bio_iov_bvec_add_pages in this patch as well, and just go straight to
the rewrite later instead of this intermediate stage.
