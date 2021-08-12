Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB9EA3E9F00
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 08:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbhHLG4j (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 02:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbhHLG4j (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 02:56:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13DDC061765;
        Wed, 11 Aug 2021 23:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qbJuc7xxfC1wevyeqyz98eS9HrkmMVNsbHhCEvHY6bo=; b=G5odaOUkci0+ovkET3ZnSyFTKK
        YHocQKo6/WwYfMWO8OgQS54f3SyN++/yM/D6OTGijy8gUYGMng2xkKO/LcIJn7ZaSXlXDp1QVoK1z
        IcpQly8xKMvhh5HxJsTVB2LQzyyxJVX303O4YsqdWWhKwX5JhEQpX7JJRVuN5zRP4Jq1rb5DZ6S6z
        z5KjgkPOAE3P6osKcO26D7YH8K4RDSkb9MB5p59n0AKadxKOU4KW8uYxsXCZXgT7TnzpeC3ijf+j0
        gmRQWDuCe7qghiMK5J9y4qC2a3SdXg7wimTw0o1CPBZ0ozTS8lFRjtBlMUcH2EXivrGSf1ogrctqN
        Xpceg+QQ==;
Received: from [2001:4bb8:184:6215:d7d:1904:40de:694d] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mE4br-00EG9A-51; Thu, 12 Aug 2021 06:54:50 +0000
Date:   Thu, 12 Aug 2021 08:54:34 +0200
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH 2/6] fs: add kiocb alloc cache flag
Message-ID: <YRTFqraI8vckPjRV@infradead.org>
References: <20210811193533.766613-1-axboe@kernel.dk>
 <20210811193533.766613-3-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811193533.766613-3-axboe@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 11, 2021 at 01:35:29PM -0600, Jens Axboe wrote:
> If this kiocb can safely use the polled bio allocation cache, then this
> flag must be set.

Looks fine, but it might be worth to define the semantics a little bit
better.
