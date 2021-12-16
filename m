Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5467E476CBF
	for <lists+io-uring@lfdr.de>; Thu, 16 Dec 2021 10:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbhLPJCY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Dec 2021 04:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbhLPJCX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Dec 2021 04:02:23 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07CDDC06173F
        for <io-uring@vger.kernel.org>; Thu, 16 Dec 2021 01:02:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=re27eGzcjzb3eMw+GuwuW8YytbX+lZz2SxXAAHMfR/c=; b=nFOkjlj3/mpaP/HoJmk76xwRl0
        zbWiCpBSyKJrQm/NSp0qjLQCbr0RbM1TLTRNAzO1Qq6P6CNbvZsm+/e8wDDfJPsZkxwwiQuGr8o7i
        gkTQklJQXxrmAF8AgaUc0ni7J09uflg6eA7qIKRMaRhj1H0rQwPgLNfoPHFoxCG8xF4HBuiUlxHho
        Ts0i4oS2D2O1ZsY8z2GI68bS+6/v7Ea4BbQb8VZg+XqBz+eaLljcy/3SCP3Bzup7ijGcWRKnLYb3u
        J7zv4GTILPO4eBq5xc5vzIuozwXXsvZOB8ZWGWrh3IeCsx+Hx5TopGq7JO4xvB82h1rdbLvFfXvH4
        axgbKoow==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mxmec-004GIH-G7; Thu, 16 Dec 2021 09:02:22 +0000
Date:   Thu, 16 Dec 2021 01:02:22 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/4] nvme: separate command prep and issue
Message-ID: <YbsAnrPMkxmOGc/O@infradead.org>
References: <20211215162421.14896-1-axboe@kernel.dk>
 <20211215162421.14896-4-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215162421.14896-4-axboe@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 15, 2021 at 09:24:20AM -0700, Jens Axboe wrote:
> Add a nvme_prep_rq() helper to setup a command, and nvme_queue_rq() is
> adapted to use this helper.
> 
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
