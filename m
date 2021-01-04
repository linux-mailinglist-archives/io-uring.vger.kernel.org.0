Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88E022E9ADD
	for <lists+io-uring@lfdr.de>; Mon,  4 Jan 2021 17:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbhADQUD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jan 2021 11:20:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728314AbhADQSF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jan 2021 11:18:05 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 196B0C061574;
        Mon,  4 Jan 2021 08:17:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lnGlZ07Br4iRlx3cevTIbdW4ub6R6dieT0l2rpJ6lwI=; b=tSSZE3lQD79SAw8vs/wFUAst7H
        O8JnawGM5RJ95pzH6VVKUk5k/G6vG2uvRkxUb4BrwOmdDgtrnK8dNeAYrGrTdLH9cP+IuPNBM3cnR
        28sZSFUYzCYPrxI2ICJmlVxdNm1ZDu+LQdG/wzRNoEoV4UeQ/Bi7myY4XRTqGHyawqxRO5rbhvtdo
        QLEfCz880D7kiNBodvZqjfMCm27sTho9JnenONQ3rmEsC4+1E9j1LwAiZ/n8SLo2YjygUQWNFykUS
        df3uHHIM+TUoLvtjY0AsX9OmjMudZ0m7KjDgemglOb2X0xpYprEGOj4pECSwL4ziQQxl1/CM+UIln
        f2D7oESA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kwSXk-000HuD-Qz; Mon, 04 Jan 2021 16:17:17 +0000
Date:   Mon, 4 Jan 2021 16:17:16 +0000
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
Subject: Re: [PATCH v2 1/7] splice: don't generate zero-len segement bvecs
Message-ID: <20210104161716.GA68600@infradead.org>
References: <cover.1609461359.git.asml.silence@gmail.com>
 <ca14f80bf5156d83b38f543be2b9434a571474c9.1609461359.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca14f80bf5156d83b38f543be2b9434a571474c9.1609461359.git.asml.silence@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Jan 02, 2021 at 03:17:33PM +0000, Pavel Begunkov wrote:
> iter_file_splice_write() may spawn bvec segments with zero-length. In
> preparation for prohibiting them, filter out by hand at splice level.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/splice.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/splice.c b/fs/splice.c
> index 866d5c2367b2..7299330c3270 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -644,7 +644,6 @@ iter_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
>  		ret = splice_from_pipe_next(pipe, &sd);
>  		if (ret <= 0)
>  			break;
> -

Spurious empty line removal..

> +			if (!this_len)
> +				continue;

Maybe throw in a comment on why we skip empty segments here?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
