Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE10B6F2E6F
	for <lists+io-uring@lfdr.de>; Mon,  1 May 2023 06:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbjEAEb3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 May 2023 00:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232186AbjEAEb0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 May 2023 00:31:26 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5EA410C3;
        Sun, 30 Apr 2023 21:31:25 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id F3A6668B05; Mon,  1 May 2023 06:31:22 +0200 (CEST)
Date:   Mon, 1 May 2023 06:31:22 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Breno Leitao <leitao@debian.org>
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, axboe@kernel.dk, ming.lei@redhat.com,
        leit@fb.com, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, sagi@grimberg.me, joshi.k@samsung.com,
        hch@lst.de, kbusch@kernel.org
Subject: Re: [PATCH v3 4/4] block: ublk_drv: Add a helper instead of casting
Message-ID: <20230501043122.GC19673@lst.de>
References: <20230430143532.605367-1-leitao@debian.org> <20230430143532.605367-5-leitao@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230430143532.605367-5-leitao@debian.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Apr 30, 2023 at 07:35:32AM -0700, Breno Leitao wrote:
> ublk driver is using casts to get private data from uring cmd struct.
> Let's use a proper helper, as an interface that requires casts in all
> callers is one asking for bugs.
> 
> Suggested-by: Christoph Hellwig <hch@lst.de>

No, I've not suggested this.

> +static inline struct ublksrv_ctrl_cmd *ublk_uring_ctrl_cmd(
> +		struct io_uring_cmd *cmd)
> +{
> +	return (struct ublksrv_ctrl_cmd *)cmd->sqe->cmd;
> +}

I've two times explained we need a core io_uring helper to remove this
casting in the drivers, and I've explained how to do that and provided
the actual code for it.
