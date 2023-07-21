Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3155975CC98
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 17:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbjGUPvj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 11:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232342AbjGUPvP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 11:51:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462F73AB2;
        Fri, 21 Jul 2023 08:50:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C05C61D24;
        Fri, 21 Jul 2023 15:50:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD920C433CA;
        Fri, 21 Jul 2023 15:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689954634;
        bh=CkuJeZngoopUBRXmmuGxK5Cdakxf8boSWuNyZaoBpSQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EM5pMm3fh5CJjXqdvOfpbpclbvkCEZDj1vOo++JTf/LTechKQo3NbfWVRpLuiXOsX
         egNr/Ja3b3GrUkNXwzaUqTHn87k+8a/57jbcTyS0rKyTvIkMZMyT9LvUhtBiYqIOh0
         A48uymLInN2xk/Ipbxt8fNFprsvEhIRv3WhE4omomIlL3YIATb6QRypKO6U0KpmhlY
         1hJD/9Imzy7suuKsKx2rOkUFMcJNfCVr+LYR2dpRkiBIPjDwzTnA94Dnsb0gIcLbSw
         RygBmtMwh3JagW/huBDfsqVTnXPJXM+IJr8GkAbPaTZ/WXjCme0Wi4p+t5Xmz5mPI3
         wUtwqZIfyVPIA==
Date:   Fri, 21 Jul 2023 08:50:34 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de, david@fromorbit.com
Subject: Re: [PATCH 7/8] io_uring/rw: add write support for IOCB_DIO_DEFER
Message-ID: <20230721155034.GP11352@frogsfrogsfrogs>
References: <20230720181310.71589-1-axboe@kernel.dk>
 <20230720181310.71589-8-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230720181310.71589-8-axboe@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 20, 2023 at 12:13:09PM -0600, Jens Axboe wrote:
> If the filesystem dio handler understands IOCB_DIO_DEFER, we'll get
> a kiocb->ki_complete() callback with kiocb->dio_complete set. In that
> case, rather than complete the IO directly through task_work, queue
> up an intermediate task_work handler that first processes this
> callback and then immediately completes the request.
> 
> For XFS, this avoids a punt through a workqueue, which is a lot less
> efficient and adds latency to lower queue depth (or sync) O_DIRECT
> writes.
> 
> Only do this for non-polled IO, as polled IO doesn't need this kind
> of deferral as it always completes within the task itself. This then
> avoids a check for deferral in the polled IO completion handler.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Seems pretty obvious to me, though I'm famous for not being an
experienced io_uring user yet...

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  io_uring/rw.c | 27 ++++++++++++++++++++++++---
>  1 file changed, 24 insertions(+), 3 deletions(-)
> 
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 1bce2208b65c..f4f700383b4e 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -285,6 +285,14 @@ static inline int io_fixup_rw_res(struct io_kiocb *req, long res)
>  
>  void io_req_rw_complete(struct io_kiocb *req, struct io_tw_state *ts)
>  {
> +	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
> +
> +	if (rw->kiocb.dio_complete) {
> +		long res = rw->kiocb.dio_complete(rw->kiocb.private);
> +
> +		io_req_set_res(req, io_fixup_rw_res(req, res), 0);
> +	}
> +
>  	io_req_io_end(req);
>  
>  	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)) {
> @@ -300,9 +308,11 @@ static void io_complete_rw(struct kiocb *kiocb, long res)
>  	struct io_rw *rw = container_of(kiocb, struct io_rw, kiocb);
>  	struct io_kiocb *req = cmd_to_io_kiocb(rw);
>  
> -	if (__io_complete_rw_common(req, res))
> -		return;
> -	io_req_set_res(req, io_fixup_rw_res(req, res), 0);
> +	if (!rw->kiocb.dio_complete) {
> +		if (__io_complete_rw_common(req, res))
> +			return;
> +		io_req_set_res(req, io_fixup_rw_res(req, res), 0);
> +	}
>  	req->io_task_work.func = io_req_rw_complete;
>  	__io_req_task_work_add(req, IOU_F_TWQ_LAZY_WAKE);
>  }
> @@ -916,6 +926,17 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
>  	}
>  	kiocb->ki_flags |= IOCB_WRITE;
>  
> +	/*
> +	 * For non-polled IO, set IOCB_DIO_DEFER, stating that our handler
> +	 * groks deferring the completion to task context. This isn't
> +	 * necessary and useful for polled IO as that can always complete
> +	 * directly.
> +	 */
> +	if (!(kiocb->ki_flags & IOCB_HIPRI)) {
> +		kiocb->ki_flags |= IOCB_DIO_DEFER;
> +		kiocb->dio_complete = NULL;
> +	}
> +
>  	if (likely(req->file->f_op->write_iter))
>  		ret2 = call_write_iter(req->file, kiocb, &s->iter);
>  	else if (req->file->f_op->write)
> -- 
> 2.40.1
 
