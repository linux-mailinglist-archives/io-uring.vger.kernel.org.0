Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6E1162B4D8
	for <lists+io-uring@lfdr.de>; Wed, 16 Nov 2022 09:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbiKPIRU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Nov 2022 03:17:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbiKPIRT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Nov 2022 03:17:19 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80045FD5
        for <io-uring@vger.kernel.org>; Wed, 16 Nov 2022 00:17:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qYrgx5eE5rv8EjaSg/J1cdZsWnSlhZDyCZ3Wk+qId6Q=; b=OpYZGrr1VlXtML68wKRKIk48P0
        lqklOrOzg1fCy7MOCbwXQ/LwCkZ5dbqctevtzdRV68EbfC7rg13fojqqC0Kwv2o/cn3pT9Y1YCisE
        k9ixc/OBygbuxd4OZRIve4OcdiI2wB1vkdk3WSeVPxylQ0otDipaQ5I760C7SbW/EaFZqN65SrkZS
        OgG6yGkKGStx6ENOxrDMhbg0kP3B6Q3r7rvvrNiIQshkq0N8tuSoniDxz9sm+8P6vkKCgLRoY/fva
        TLgqWHd+uJfx8kRqB2FjKjOlq3dTHhNPk/ripQMZc356Q91oysCfp9q3+EtOn3qN9Cv/d1/fSrxrG
        Fy+qTJxQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ovDbi-0018vq-CN; Wed, 16 Nov 2022 08:17:18 +0000
Date:   Wed, 16 Nov 2022 00:17:18 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     io-uring@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v1 06/15] io_uring: Provide driver API for zctap packet
 buffers.
Message-ID: <Y3ScjuwlCPSrnwZV@infradead.org>
References: <20221108050521.3198458-1-jonathan.lemon@gmail.com>
 <20221108050521.3198458-7-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108050521.3198458-7-jonathan.lemon@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Nov 07, 2022 at 09:05:12PM -0800, Jonathan Lemon wrote:
> +struct io_zctap_buf *io_zctap_get_buf(struct io_zctap_ifq *ifq, int refc)
> +{
> +	return NULL;
> +}
> +EXPORT_SYMBOL(io_zctap_get_buf);
> +
> +void io_zctap_put_buf(struct io_zctap_ifq *ifq, struct io_zctap_buf *buf)
> +{
> +}
> +EXPORT_SYMBOL(io_zctap_put_buf);

Adding stubs without anything in them is rather pointless.

Also why are these exported?  I can't find any modular users anywhere.
Even if so, any low-level uring zero copy functionality should be
EXPORT_SYMBOL_GPL, and only added once the modular users show up and
are discussed.
