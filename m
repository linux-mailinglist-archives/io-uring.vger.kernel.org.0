Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E52A54D6758
	for <lists+io-uring@lfdr.de>; Fri, 11 Mar 2022 18:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350621AbiCKRQe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Mar 2022 12:16:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350636AbiCKRQe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Mar 2022 12:16:34 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E30C1AD941;
        Fri, 11 Mar 2022 09:15:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=OA+UIitwtF53idCzlrlAHoDLn0zSshd74vpRjIMI/CA=; b=WXsLQ9LOxtM9LVX3OSq7e2mETX
        8Exm6EdZAwso51V83j94j//qebYA99slDmR7Zcz9uHdpFtAl6V481JREXeVc3DizXMI+uCQZU2wSR
        nxjFx6yWF2eZGchxUNC8hbAzTsQyZUe5RIv5t7F85u9cESWDs9xFdtKypOMZPqTtdoLuKtf5esI4B
        KqlFVPM63hkbHejwCCmMwPhQypdD7SAmhGkVJyWByFQFcXDiZXWi/OYniWyl0hPrrX0z6emDqpjqR
        a9mlPfu69jEODDApAHvGlO3wDVOo7qfNgpqzpvGFPatZ8S75OUZ4jpStud+ShWxqMZNTHXR7Xuwqi
        4lGV/khg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nSirO-00HT7M-Sp; Fri, 11 Mar 2022 17:15:26 +0000
Date:   Fri, 11 Mar 2022 09:15:26 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        sbates@raithlin.com, logang@deltatee.com, pankydev8@gmail.com,
        javier@javigon.com, a.manzanares@samsung.com, joshiiitr@gmail.com,
        anuj20.g@samsung.com
Subject: Re: [PATCH 09/17] io_uring: plug for async bypass
Message-ID: <YiuDrhoarylE2d6i@bombadil.infradead.org>
References: <20220308152105.309618-1-joshi.k@samsung.com>
 <CGME20220308152711epcas5p31de5d63f5de91fae94e61e5c857c0f13@epcas5p3.samsung.com>
 <20220308152105.309618-10-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308152105.309618-10-joshi.k@samsung.com>
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

On Tue, Mar 08, 2022 at 08:50:57PM +0530, Kanchan Joshi wrote:
> From: Jens Axboe <axboe@kernel.dk>
> 
> Enable .plug for uring-cmd.

It would be wonderful if the commit log explained *why*.

  Luis
