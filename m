Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D31C6E8952
	for <lists+io-uring@lfdr.de>; Thu, 20 Apr 2023 06:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233375AbjDTE5T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Apr 2023 00:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbjDTE5S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Apr 2023 00:57:18 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC9346AA;
        Wed, 19 Apr 2023 21:57:17 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 85E8E68AFE; Thu, 20 Apr 2023 06:57:12 +0200 (CEST)
Date:   Thu, 20 Apr 2023 06:57:12 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Breno Leitao <leitao@debian.org>
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, axboe@kernel.dk, leit@fb.com,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org,
        ming.lei@redhat.com
Subject: Re: [PATCH 1/2] io_uring: Pass whole sqe to commands
Message-ID: <20230420045712.GA4239@lst.de>
References: <20230419102930.2979231-1-leitao@debian.org> <20230419102930.2979231-2-leitao@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419102930.2979231-2-leitao@debian.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Apr 19, 2023 at 03:29:29AM -0700, Breno Leitao wrote:
>  	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
> -	const struct nvme_uring_cmd *cmd = ioucmd->cmd;
> +	const struct nvme_uring_cmd *cmd = (struct nvme_uring_cmd *)ioucmd->sqe->cmd;

Please don't add the pointless cast.  And in general avoid the overly
long lines.

I suspect most other users should just also defined their structures
const instead of adding all theses casts thare are a sign of problems,
but that's a pre-existing issue.
>  	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
> -	size_t cmd_size;
> +	size_t size = sizeof(struct io_uring_sqe);
>  
>  	BUILD_BUG_ON(uring_cmd_pdu_size(0) != 16);
>  	BUILD_BUG_ON(uring_cmd_pdu_size(1) != 80);
>  
> -	cmd_size = uring_cmd_pdu_size(req->ctx->flags & IORING_SETUP_SQE128);
> +	if (req->ctx->flags & IORING_SETUP_SQE128)
> +		size <<= 1;


Why does this stop using uring_cmd_pdu_size()?
