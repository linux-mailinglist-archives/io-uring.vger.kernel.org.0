Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A2B3EA896
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 18:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbhHLQfr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 12:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbhHLQfa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 12:35:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5E6C061756;
        Thu, 12 Aug 2021 09:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ACm0fqAIuFX7BZZ77Max2Jtw2J5LfnzS9XyqVDSSvGU=; b=qQyDuJ8dOxWZCJy9ERKBKmlSTH
        n0gbYsfXycDhey9MsPOY5hu0w9zw+7vcD3ekRpSsHT6aHikjXzzu4yIQhBc/K+rIErPQ31LvDMz0D
        vCIaWexbSBM4im3Dh/Vy0ssX3T5qXNIuMnXv/RJiRoasCEePGvFmDmKde/PrvzoSPBy2e0H1/DWQG
        XNWXE7cC37uy5WH5TW8db+IP7c7xVkAS+kc9zG0owjvM1wYnUNbQJTUT7HaQV5sgws/RaGUXyQ7GI
        tvKexU+9sAYMR2xxmzDeqxZAxjpYAemg+NLobN469ibSZy7+tFgrR2F4XgxZspmP2GyYPmLPPH8K9
        6Ui4DmuQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mEDeO-00Em1H-5C; Thu, 12 Aug 2021 16:34:10 +0000
Date:   Thu, 12 Aug 2021 17:33:48 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH 4/6] block: clear BIO_PERCPU_CACHE flag if polling isn't
 supported
Message-ID: <YRVNbKEAzvFg13hS@infradead.org>
References: <20210812154149.1061502-1-axboe@kernel.dk>
 <20210812154149.1061502-5-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812154149.1061502-5-axboe@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Aug 12, 2021 at 09:41:47AM -0600, Jens Axboe wrote:
> The bio alloc cache relies on the fact that a polled bio will complete
> in process context, clear the cacheable flag if we disable polling
> for a given bio.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
