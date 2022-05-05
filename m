Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EADE651C0B0
	for <lists+io-uring@lfdr.de>; Thu,  5 May 2022 15:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348398AbiEENcv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 May 2022 09:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243197AbiEENcu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 May 2022 09:32:50 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F2256C1B
        for <io-uring@vger.kernel.org>; Thu,  5 May 2022 06:29:10 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 87FDD68BFE; Thu,  5 May 2022 15:29:03 +0200 (CEST)
Date:   Thu, 5 May 2022 15:29:02 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, asml.silence@gmail.com,
        ming.lei@redhat.com, mcgrof@kernel.org, shr@fb.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
Subject: Re: [PATCH v4 1/5] fs,io_uring: add infrastructure for uring-cmd
Message-ID: <20220505132902.GA11853@lst.de>
References: <20220505060616.803816-1-joshi.k@samsung.com> <CGME20220505061144epcas5p3821a9516dad2b5eff5a25c56dbe164df@epcas5p3.samsung.com> <20220505060616.803816-2-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220505060616.803816-2-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 05, 2022 at 11:36:12AM +0530, Kanchan Joshi wrote:
> +	void (*uring_cmd)(struct io_uring_cmd *ioucmd, unsigned int issue_flags);

This adds an overly long line now.

>  } __randomize_layout;
> +struct io_uring_cmd {
> +	struct file	*file;
> +	const u8	*cmd;
> +	/* callback to defer completions to task context */
> +	void (*task_work_cb)(struct io_uring_cmd *cmd);
> +	u32		cmd_op;
> +	u8		pdu[32]; /* available inline for free use */

And with both unused and flags gone, pdu is unaligned again and will
crash the kernel on 64-bit architectures that do not support unaligned
loads and stores, so we'll need a "u32 __pad" here now.
