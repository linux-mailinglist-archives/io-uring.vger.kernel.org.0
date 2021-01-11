Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4322F0B1C
	for <lists+io-uring@lfdr.de>; Mon, 11 Jan 2021 03:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbhAKCuZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 10 Jan 2021 21:50:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26688 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727134AbhAKCuY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 10 Jan 2021 21:50:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610333338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yjguCijslXAGWOXFjKVOGOP7FungpwsXWLGY8oK5Jm0=;
        b=YNpAa7mL9UfbkU3kYwcoePeNddhm5qgP+SYr3At0wUpluLGhCeVOrb/0+CHaEv+tYZRbOt
        WA4yZ9zwUYE8RFqhNV2TsWDIf1WCIoP+iDTNLE6YQ7z1mDVwNNlxMIDahK12/4bGKKzzQf
        uX3iG4siP/SDqeg0wrecEPT0RjdV87w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-tJVw7DbHPtK0V-YSLLxZtg-1; Sun, 10 Jan 2021 21:48:54 -0500
X-MC-Unique: tJVw7DbHPtK0V-YSLLxZtg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F608800D53;
        Mon, 11 Jan 2021 02:48:51 +0000 (UTC)
Received: from T590 (ovpn-12-180.pek2.redhat.com [10.72.12.180])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 74CBA19D9D;
        Mon, 11 Jan 2021 02:48:40 +0000 (UTC)
Date:   Mon, 11 Jan 2021 10:48:35 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 1/7] splice: don't generate zero-len segement bvecs
Message-ID: <20210111024835.GB4147870@T590>
References: <cover.1610170479.git.asml.silence@gmail.com>
 <bfaeb54c88f0c962461b75c6493103e11bb0b17b.1610170479.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfaeb54c88f0c962461b75c6493103e11bb0b17b.1610170479.git.asml.silence@gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Jan 09, 2021 at 04:02:57PM +0000, Pavel Begunkov wrote:
> iter_file_splice_write() may spawn bvec segments with zero-length. In
> preparation for prohibiting them, filter out by hand at splice level.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/splice.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/splice.c b/fs/splice.c
> index 866d5c2367b2..474fb8b5562a 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -662,12 +662,14 @@ iter_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
>  
>  		/* build the vector */
>  		left = sd.total_len;
> -		for (n = 0; !pipe_empty(head, tail) && left && n < nbufs; tail++, n++) {
> +		for (n = 0; !pipe_empty(head, tail) && left && n < nbufs; tail++) {
>  			struct pipe_buffer *buf = &pipe->bufs[tail & mask];
>  			size_t this_len = buf->len;
>  
> -			if (this_len > left)
> -				this_len = left;
> +			/* zero-length bvecs are not supported, skip them */
> +			if (!this_len)
> +				continue;
> +			this_len = min(this_len, left);
>  
>  			ret = pipe_buf_confirm(pipe, buf);
>  			if (unlikely(ret)) {
> @@ -680,6 +682,7 @@ iter_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
>  			array[n].bv_len = this_len;
>  			array[n].bv_offset = buf->offset;
>  			left -= this_len;
> +			n++;
>  		}
>  
>  		iov_iter_bvec(&from, WRITE, array, n, sd.total_len - left);
> -- 
> 2.24.0
> 

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

