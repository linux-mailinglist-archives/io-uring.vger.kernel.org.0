Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4FCA6C8974
	for <lists+io-uring@lfdr.de>; Sat, 25 Mar 2023 00:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbjCXXyp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Mar 2023 19:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbjCXXyo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Mar 2023 19:54:44 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B12C18168
        for <io-uring@vger.kernel.org>; Fri, 24 Mar 2023 16:54:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 02292CE2810
        for <io-uring@vger.kernel.org>; Fri, 24 Mar 2023 23:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198CFC433D2;
        Fri, 24 Mar 2023 23:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679702079;
        bh=UKQYIJV7oYB2WoLQm7xEyaCIpiAYMl5SrvNf5d3FgFs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m9yfedTMi98k/xNx0tcOqNDqFxmgi/wnzxl/x7NaVhd9040uzzsp/G2AodnmDnN6M
         bGm9t8XeJLxDhep3D+AxgogxHpbjujuJitRnu/j9agU4r5qmHEAkv8dPPm3arq/IaC
         5Ubk9RnBDeKcPaBhwss9sVevn+HAdw2IeUpgOhw1znGSHGvfSwClKRTjQXgcfjYV1J
         hz7VgAf9+XiWwv8WZt5d6rVOANmRLT49BXJR/5v9EX1CDu0URtoL8C+IkTUeI++w5A
         +Nd3U/9DFLQBWt5mzHivcj1FJ4bz7IkGtG3mh2ZquaQugsVBUZbew1smH+61lovnQC
         1S7e2g89LXbXw==
Date:   Fri, 24 Mar 2023 17:54:36 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH] io_uring/rw: transform single vector readv/writev into
 ubuf
Message-ID: <ZB44PG+EFK4Xid/W@kbusch-mbp.dhcp.thefacebook.com>
References: <43cb1fb7-b30b-8df1-bba6-e50797d680c6@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43cb1fb7-b30b-8df1-bba6-e50797d680c6@kernel.dk>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Mar 24, 2023 at 08:35:38AM -0600, Jens Axboe wrote:
> @@ -402,7 +402,22 @@ static struct iovec *__io_import_iovec(int ddir, struct io_kiocb *req,
>  			      req->ctx->compat);
>  	if (unlikely(ret < 0))
>  		return ERR_PTR(ret);
> -	return iovec;
> +	if (iter->nr_segs != 1)
> +		return iovec;
> +	/*
> +	 * Convert to non-vectored request if we have a single segment. If we
> +	 * need to defer the request, then we no longer have to allocate and
> +	 * maintain a struct io_async_rw. Additionally, we won't have cleanup
> +	 * to do at completion time
> +	 */
> +	rw->addr = (unsigned long) iter->iov[0].iov_base;
> +	rw->len = iter->iov[0].iov_len;
> +	iov_iter_ubuf(iter, ddir, iter->iov[0].iov_base, rw->len);
> +	/* readv -> read distance is the same as writev -> write */
> +	BUILD_BUG_ON((IORING_OP_READ - IORING_OP_READV) !=
> +			(IORING_OP_WRITE - IORING_OP_WRITEV));
> +	req->opcode += (IORING_OP_READ - IORING_OP_READV);
> +	return NULL;
>  }

This may break anyone using io_uring with those bizarre drivers that have
entirely different readv semantics from normal read. I think we can safely say
no one's using io_uring for such interfaces, so probably a moot point. If you
wanted to be extra cautious though, you may want to skip this transformation if
the file->f_op implements both .read+read_iter and .write+.write_iter.
