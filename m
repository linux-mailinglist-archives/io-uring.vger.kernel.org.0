Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBC04B9576
	for <lists+io-uring@lfdr.de>; Thu, 17 Feb 2022 02:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbiBQBZe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Feb 2022 20:25:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbiBQBZe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Feb 2022 20:25:34 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436741F227A
        for <io-uring@vger.kernel.org>; Wed, 16 Feb 2022 17:25:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SEDdEOUoigqujxshhHn2OnVIwq0lCTrQKSE9KoWDQP8=; b=ZfEKRWScPu4nVmqSVUUQe9V36W
        YLXKQCEcWJ8pqYtlD+eFU6tplMvDeTL1ZYgxVsOG1HD1xchg1vfATztJgl+ZtGjAsLp487qpEir7t
        ImaZPvQvwDFM/aKVD8kakCXZKtCWudzIhdUB0Kg//fotg0LgYGiVBO/VUW5eYMM8rLds1IJ9pg2n2
        PlnRQr2EVmsVsObI23JvZSwvq8i7nrVo0Ma84bHGZpRIg9PesvvrrIEmMG7wT5xKa252tDVUseKAA
        XPeOGDgcNlPW/3EIZB/V+l0OKHTsmrwigecCiuyWMHkk2eCTQZ4ck8XUrmSQI3iJgiTE/Ky0rZ+xG
        bvObyGRQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nKVXs-008fEv-2Y; Thu, 17 Feb 2022 01:25:20 +0000
Date:   Wed, 16 Feb 2022 17:25:20 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, joshi.k@samsung.com, hch@lst.de,
        kbusch@kernel.org, linux-nvme@lists.infradead.org, metze@samba.org
Subject: Re: [PATCH 3/8] fs: add file_operations->uring_cmd()
Message-ID: <Yg2kAP4Zj2+YCNwA@bombadil.infradead.org>
References: <20210317221027.366780-1-axboe@kernel.dk>
 <20210317221027.366780-4-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210317221027.366780-4-axboe@kernel.dk>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Mar 17, 2021 at 04:10:22PM -0600, Jens Axboe wrote:
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index ec8f3ddf4a6a..009abc668987 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1884,6 +1884,15 @@ struct dir_context {
>  #define REMAP_FILE_ADVISORY		(REMAP_FILE_CAN_SHORTEN)
>  
>  struct iov_iter;
> +struct io_uring_cmd;
> +
> +/*
> + * f_op->uring_cmd() issue flags
> + */

Adding kdoc style comments would be nice.

  Luis
