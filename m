Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90DC26EC6FE
	for <lists+io-uring@lfdr.de>; Mon, 24 Apr 2023 09:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbjDXHYZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Apr 2023 03:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbjDXHYY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Apr 2023 03:24:24 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E86358E;
        Mon, 24 Apr 2023 00:23:48 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id A1FE06732D; Mon, 24 Apr 2023 09:23:39 +0200 (CEST)
Date:   Mon, 24 Apr 2023 09:23:39 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Breno Leitao <leitao@debian.org>
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, axboe@kernel.dk, leit@fb.com,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org,
        ming.lei@redhat.com
Subject: Re: [PATCH v2 2/3] io_uring: Pass whole sqe to commands
Message-ID: <20230424072339.GB13287@lst.de>
References: <20230421114440.3343473-1-leitao@debian.org> <20230421114440.3343473-3-leitao@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421114440.3343473-3-leitao@debian.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Apr 21, 2023 at 04:44:39AM -0700, Breno Leitao wrote:
> -	struct ublksrv_io_cmd *ub_cmd = (struct ublksrv_io_cmd *)cmd->cmd;
> +	struct ublksrv_io_cmd *ub_cmd = (struct ublksrv_io_cmd *)cmd->sqe->cmd;

As mentioned in my (late) reply to the previous series, please
add a helper like:

static inline const void *io_uring_sqe_cmd(struct io_uring_sqe *sqe)
{
	return sqe->cmd;
}

and then avoid all these casts.

>  int io_uring_cmd_prep_async(struct io_kiocb *req)
>  {
>  	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
> +	size_t size = uring_sqe_size(req->ctx);
>  
>  	BUILD_BUG_ON(uring_cmd_pdu_size(0) != 16);
>  	BUILD_BUG_ON(uring_cmd_pdu_size(1) != 80);
>  
> +	memcpy(req->async_data, ioucmd->sqe, size);
> +	ioucmd->sqe = req->async_data;

This can skip the size local variable now.
