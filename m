Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD0064D5BC3
	for <lists+io-uring@lfdr.de>; Fri, 11 Mar 2022 07:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346580AbiCKGvO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Mar 2022 01:51:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344359AbiCKGvM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Mar 2022 01:51:12 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0031AA040;
        Thu, 10 Mar 2022 22:50:10 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 170F268AFE; Fri, 11 Mar 2022 07:50:08 +0100 (CET)
Date:   Fri, 11 Mar 2022 07:50:07 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        sbates@raithlin.com, logang@deltatee.com, pankydev8@gmail.com,
        javier@javigon.com, mcgrof@kernel.org, a.manzanares@samsung.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com
Subject: Re: [PATCH 14/17] io_uring: add polling support for uring-cmd
Message-ID: <20220311065007.GC17728@lst.de>
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152723epcas5p34460b4af720e515317f88dbb78295f06@epcas5p3.samsung.com> <20220308152105.309618-15-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308152105.309618-15-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Mar 08, 2022 at 08:51:02PM +0530, Kanchan Joshi wrote:
> +		if (req->opcode == IORING_OP_URING_CMD ||
> +		    req->opcode == IORING_OP_URING_CMD_FIXED) {
> +			/* uring_cmd structure does not contain kiocb struct */
> +			struct kiocb kiocb_uring_cmd;
> +
> +			kiocb_uring_cmd.private = req->uring_cmd.bio;
> +			kiocb_uring_cmd.ki_filp = req->uring_cmd.file;
> +			ret = req->uring_cmd.file->f_op->iopoll(&kiocb_uring_cmd,
> +			      &iob, poll_flags);
> +		} else {
> +			ret = kiocb->ki_filp->f_op->iopoll(kiocb, &iob,
> +							   poll_flags);
> +		}

This is just completely broken.  You absolutely do need the iocb
in struct uring_cmd for ->iopoll to work.
