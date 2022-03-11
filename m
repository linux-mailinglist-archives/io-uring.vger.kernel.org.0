Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3091C4D579D
	for <lists+io-uring@lfdr.de>; Fri, 11 Mar 2022 02:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239153AbiCKBwf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 20:52:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238035AbiCKBwe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 20:52:34 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4F117B88A;
        Thu, 10 Mar 2022 17:51:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=z4x2hBPkj+jEGWmrRVyRt/pxXSV3iAHniQAONJ1aiFU=; b=v74GbM3lNawZ8OCADSP2zPJxjR
        MzG+bFSw0KM7uz7hTY24330lowcuhv9cbU1UFb5Lf7Tlg+/aGIrtS4HlgTSg082cXgOb6n54hsWSJ
        Zf4ePwaISlU7Kya+rFBJEifCI8lbTQYNZxXxPu9klnNH1ScxZvZz/5oVsu1YBzZoXbq3Cdg1yPN0r
        rlAWbCJVy0OypTSHgIYBlvrhAECF0wnEcscHQmnM1omByhhgOddhJMdjAn1syAiTktdMYaBtF9jAC
        ZDJvfZHTKxukYSZfAEyUCvZhR84Q7sdoiZL/l0l18g6MUK9pNfWzB+7pY4991N8qwN4+oCjyHQkmB
        LCZFXLMQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nSUR1-00EX8e-P7; Fri, 11 Mar 2022 01:51:15 +0000
Date:   Thu, 10 Mar 2022 17:51:15 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Kanchan Joshi <joshi.k@samsung.com>, jmorris@namei.org,
        serge@hallyn.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-security-module@vger.kernel.org
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        sbates@raithlin.com, logang@deltatee.com, pankydev8@gmail.com,
        javier@javigon.com, a.manzanares@samsung.com, joshiiitr@gmail.com,
        anuj20.g@samsung.com
Subject: Re: [PATCH 03/17] io_uring: add infra and support for
 IORING_OP_URING_CMD
Message-ID: <YiqrE4K5TWeB7aLd@bombadil.infradead.org>
References: <20220308152105.309618-1-joshi.k@samsung.com>
 <CGME20220308152658epcas5p3929bd1fcf75edc505fec71901158d1b5@epcas5p3.samsung.com>
 <20220308152105.309618-4-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308152105.309618-4-joshi.k@samsung.com>
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

On Tue, Mar 08, 2022 at 08:50:51PM +0530, Kanchan Joshi wrote:
> From: Jens Axboe <axboe@kernel.dk>
> 
> This is a file private kind of request. io_uring doesn't know what's
> in this command type, it's for the file_operations->async_cmd()
> handler to deal with.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> ---

<-- snip -->

> +static int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	struct file *file = req->file;
> +	int ret;
> +	struct io_uring_cmd *ioucmd = &req->uring_cmd;
> +
> +	ioucmd->flags |= issue_flags;
> +	ret = file->f_op->async_cmd(ioucmd);

I think we're going to have to add a security_file_async_cmd() check
before this call here. Because otherwise we're enabling to, for
example, bypass security_file_ioctl() for example using the new
iouring-cmd interface.

Or is this already thought out with the existing security_uring_*() stuff?

  Luis
