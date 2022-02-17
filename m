Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8778E4B95D8
	for <lists+io-uring@lfdr.de>; Thu, 17 Feb 2022 03:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231528AbiBQCQx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Feb 2022 21:16:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbiBQCQw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Feb 2022 21:16:52 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F35028AD8A;
        Wed, 16 Feb 2022 18:16:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MdoCcAk+OLslw71aT1g+FLgvYQdVds+g0psKDyCv4Dw=; b=frCj2lis/Drp84TC5bHwj3H+9b
        txoIs4AEW+yjU5hN1LAKZ5BqkbQAMhAx7okevRD+PhkFcJAzIeOJmE9EiGlAJy7SQf2vw2pvjgBB3
        K2x0pmtnx2Q4E1x+TFzqjGEUf8zKSACSOXer1TJEv0eHdG+zBi/MfJep5A6W58pm/YjszlkZ/BWty
        /96L6vaNwjUaHmLlxl2YW6jDskCOuuiJVGc78hEYYSXDPCFat+u+rxQQHFjXtCbLxOPfFYcSecrWa
        BSQSPHE4w+U0im8Z81LcVqa45/FviHPWdhL4hlDHRN0eNEbBe+VS6sEOVh+zOJpCTE/+7LmSdzrMW
        uqH0JueQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nKWLT-008joa-HD; Thu, 17 Feb 2022 02:16:35 +0000
Date:   Wed, 16 Feb 2022 18:16:35 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, axboe@kernel.dk, hch@lst.de,
        kbusch@kernel.org, javier@javigon.com, anuj20.g@samsung.com,
        joshiiitr@gmail.com, pankydev8@gmail.com
Subject: Re: [RFC 03/13] io_uring: mark iopoll not supported for uring-cmd
Message-ID: <Yg2wA2xxrDthoCDi@bombadil.infradead.org>
References: <20211220141734.12206-1-joshi.k@samsung.com>
 <CGME20211220142233epcas5p3b54aa591fb7b81bfb58bc33b5f92a2d3@epcas5p3.samsung.com>
 <20211220141734.12206-4-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211220141734.12206-4-joshi.k@samsung.com>
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

On Mon, Dec 20, 2021 at 07:47:24PM +0530, Kanchan Joshi wrote:
> From: Anuj Gupta <anuj20.g@samsung.com>
> 
> Currently uring-passthrough doesn't support iopoll. Bail out to avoid
> the panic.
> 
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>

Jens, can you fold this in to your series?

  Luis
