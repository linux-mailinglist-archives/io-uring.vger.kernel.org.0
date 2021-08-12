Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8923E9F30
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 09:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbhHLHGa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 03:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbhHLHGa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 03:06:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99855C061765;
        Thu, 12 Aug 2021 00:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1MectOUgcrUFVwq1OFBd/OPftXzfc7hvlaR3c8DnIwY=; b=Oghg0EtEyBSUGjYK0YEBjTwrj/
        4c+8z8RGfNXrM/XPSrs6a0SOVGA72t6TebcItXMJK/nyxRfqkMduTYiwAQyVg5S/2dp3z4KnvX1NU
        2Apn83LQSRODPHKfDcKag57P7hqONQL3SzFGiW98T0NyIJ4f9f0Ha7RgX9J7zOJ91FAU0PutB9SyU
        TrlShEZfOMt3yN0MUOshhyH0+RUhjlhpMCZMDISSISvUkODh1no564uOIrCtjr/+UjpHoRs3PvPpe
        OToGq/tDA9xSuLJ3LmvgXP1X1WRwIeB4jLk0jucN58wzlAKKckSC05BbUyH+dHwfbf2kp8HHcVmAL
        2ukk2wHg==;
Received: from [2001:4bb8:184:6215:d7d:1904:40de:694d] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mE4l3-00EGhR-VR; Thu, 12 Aug 2021 07:04:18 +0000
Date:   Thu, 12 Aug 2021 09:04:05 +0200
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH 6/6] block: enable use of bio allocation cache
Message-ID: <YRTH5T6R7PMpWaBF@infradead.org>
References: <20210811193533.766613-1-axboe@kernel.dk>
 <20210811193533.766613-7-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811193533.766613-7-axboe@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 11, 2021 at 01:35:33PM -0600, Jens Axboe wrote:
> Initialize the bio_set used for IO with per-cpu bio caching enabled,
> and use the new bio_alloc_kiocb() helper to dip into that cache.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

This seems to be pretty much my patch as-is..
