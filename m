Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA5DE477B1A
	for <lists+io-uring@lfdr.de>; Thu, 16 Dec 2021 18:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240525AbhLPRxW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Dec 2021 12:53:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233248AbhLPRxV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Dec 2021 12:53:21 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8C3C061574;
        Thu, 16 Dec 2021 09:53:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=Y2KpbTNSuQK4QoxpwVIGaL8jZ7
        8tJD43mJVthhbKeHcpdlslmsJgGaBG4ylLXNL/WB9L3ABhkqeYWc0XNj9IS2/wg9+Q6aHyEhrwRmy
        AJc/tvdGvVEB2xZ98HssbdOSrhwGduHsWV6Ja6CQdikwKyb1GZerfCXy6wBy2/jLnqzdK1ck1Q3BZ
        Xg+CCd3xR/rweTExM1WqAXdH7R8B+VweI5UQ3ce4v7RSE9YaZOaLybrNddZkHLoJHCn2KK9Ykxsf8
        F/LgjsVmYDhySa5aLGAP7W9qpdVOgrTHzAx/mzVatcpovQZE9rYj4ZxJZh34TlfZbM8EGPx0OCXGz
        p2NDSy/Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mxuwT-0072Mo-2I; Thu, 16 Dec 2021 17:53:21 +0000
Date:   Thu, 16 Dec 2021 09:53:21 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Hannes Reinecke <hare@suse.de>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: Re: [PATCH 2/4] nvme: split command copy into a helper
Message-ID: <Ybt9EZI1wQ4k/TPa@infradead.org>
References: <20211216163901.81845-1-axboe@kernel.dk>
 <20211216163901.81845-3-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211216163901.81845-3-axboe@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
