Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2F43E8F4B
	for <lists+io-uring@lfdr.de>; Wed, 11 Aug 2021 13:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237180AbhHKLOD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Aug 2021 07:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236951AbhHKLOD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Aug 2021 07:14:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D2EC061765;
        Wed, 11 Aug 2021 04:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+AaUPWR63KD7Q/3F40cQY72+BoEe+z067JgDuIcBYhc=; b=hMi7MTzEd3F1nZZDspJ1K68Uxf
        rDKEVb2APC0G5lFI/y0L1fjgC2PuLOVZ9V/OY3MvnTvoRBQhD3QKxuSJS+EtF7rWD7mFIT54ElAun
        ICLNhs+eZoetO0JWvk8Q7ql5fbmmZlAx6LQhjLfGcT9865De64p4+r9lXV8hZ6iKz42x+1Ga95hW/
        Wc48y6wngCCl7cjSbOnYbv8KjooXMNzn3pwawf++tdHeQDfBOWRQjYss8VhiZUjxr5W/39CCXd6ca
        VndD1B/XGZkzEigMdl3DDmu4MArKYw9GmcHepGnk83k2PqQQKVn1gIggMzADp6yjK6dPNc4HIZ2vm
        bxcZJCQw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mDmAl-00DIqE-Dl; Wed, 11 Aug 2021 11:13:29 +0000
Date:   Wed, 11 Aug 2021 12:13:23 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCHSET v3 0/5] Enable bio recycling for polled IO
Message-ID: <YROw06H0z0Js8yg3@infradead.org>
References: <20210810163728.265939-1-axboe@kernel.dk>
 <YROJuSsUX7y236BW@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YROJuSsUX7y236BW@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 11, 2021 at 09:26:33AM +0100, Christoph Hellwig wrote:
> I really don't like all the layering violations in here.  What is the
> problem with a simple (optional) percpu cache in the bio_set?  Something
> like the completely untested patch below:

A slightly updated version that actually compiles and survives minimal
testing is here:

http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/bio-cache
