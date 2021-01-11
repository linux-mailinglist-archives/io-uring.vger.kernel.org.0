Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6701E2F0B3C
	for <lists+io-uring@lfdr.de>; Mon, 11 Jan 2021 03:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbhAKCzC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 10 Jan 2021 21:55:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24132 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726608AbhAKCzB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 10 Jan 2021 21:55:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610333615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VSn3PEjXx479346tX4pdLVVMo3Psn+BWkG3vnTamrKs=;
        b=T8/TViHEHwT1t1aEQIB3PphTSdAWVOdPhAomMmscmV7Ts1lIXzeLnbJT18wLuSxqAV/Rx1
        WPyzBPvHnTRJhSZtag57vDtGLGN8ps2d0NrbMcQsyOZm7vtQHxGmMigqNjYWdZQ/22sroM
        XOe+x01cpQY2jmUFnWBvgg7q8PWFgQQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-bbZB2EVONAW1M4aFghKepw-1; Sun, 10 Jan 2021 21:53:31 -0500
X-MC-Unique: bbZB2EVONAW1M4aFghKepw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77137107ACE4;
        Mon, 11 Jan 2021 02:53:28 +0000 (UTC)
Received: from T590 (ovpn-12-180.pek2.redhat.com [10.72.12.180])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 260EA5D9CC;
        Mon, 11 Jan 2021 02:53:16 +0000 (UTC)
Date:   Mon, 11 Jan 2021 10:53:12 +0800
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
Subject: Re: [PATCH v3 4/7] target/file: allocate the bvec array as part of
 struct target_core_file_cmd
Message-ID: <20210111025312.GE4147870@T590>
References: <cover.1610170479.git.asml.silence@gmail.com>
 <2650722037cd756690f2e398468420bbaa26ed7f.1610170479.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2650722037cd756690f2e398468420bbaa26ed7f.1610170479.git.asml.silence@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Jan 09, 2021 at 04:03:00PM +0000, Pavel Begunkov wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> This saves one memory allocation, and ensures the bvecs aren't freed
> before the AIO completion.  This will allow the lower level code to be
> optimized so that it can avoid allocating another bvec array.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  drivers/target/target_core_file.c | 20 ++++++--------------
>  1 file changed, 6 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
> index b0cb5b95e892..cce455929778 100644
> --- a/drivers/target/target_core_file.c
> +++ b/drivers/target/target_core_file.c
> @@ -241,6 +241,7 @@ struct target_core_file_cmd {
>  	unsigned long	len;
>  	struct se_cmd	*cmd;
>  	struct kiocb	iocb;
> +	struct bio_vec	bvecs[];
>  };
>  
>  static void cmd_rw_aio_complete(struct kiocb *iocb, long ret, long ret2)
> @@ -268,29 +269,22 @@ fd_execute_rw_aio(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
>  	struct target_core_file_cmd *aio_cmd;
>  	struct iov_iter iter = {};
>  	struct scatterlist *sg;
> -	struct bio_vec *bvec;
>  	ssize_t len = 0;
>  	int ret = 0, i;
>  
> -	aio_cmd = kmalloc(sizeof(struct target_core_file_cmd), GFP_KERNEL);
> +	aio_cmd = kmalloc(struct_size(aio_cmd, bvecs, sgl_nents), GFP_KERNEL);
>  	if (!aio_cmd)
>  		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>  
> -	bvec = kcalloc(sgl_nents, sizeof(struct bio_vec), GFP_KERNEL);
> -	if (!bvec) {
> -		kfree(aio_cmd);
> -		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> -	}
> -
>  	for_each_sg(sgl, sg, sgl_nents, i) {
> -		bvec[i].bv_page = sg_page(sg);
> -		bvec[i].bv_len = sg->length;
> -		bvec[i].bv_offset = sg->offset;
> +		aio_cmd->bvecs[i].bv_page = sg_page(sg);
> +		aio_cmd->bvecs[i].bv_len = sg->length;
> +		aio_cmd->bvecs[i].bv_offset = sg->offset;
>  
>  		len += sg->length;
>  	}
>  
> -	iov_iter_bvec(&iter, is_write, bvec, sgl_nents, len);
> +	iov_iter_bvec(&iter, is_write, aio_cmd->bvecs, sgl_nents, len);
>  
>  	aio_cmd->cmd = cmd;
>  	aio_cmd->len = len;
> @@ -307,8 +301,6 @@ fd_execute_rw_aio(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
>  	else
>  		ret = call_read_iter(file, &aio_cmd->iocb, &iter);
>  
> -	kfree(bvec);
> -
>  	if (ret != -EIOCBQUEUED)
>  		cmd_rw_aio_complete(&aio_cmd->iocb, ret, 0);
>  
> -- 
> 2.24.0
> 

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

