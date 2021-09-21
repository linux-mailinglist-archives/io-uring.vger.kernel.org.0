Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC9C412EDC
	for <lists+io-uring@lfdr.de>; Tue, 21 Sep 2021 08:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhIUG5S (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Sep 2021 02:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbhIUG5R (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Sep 2021 02:57:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD55C061574;
        Mon, 20 Sep 2021 23:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=KWSPXjobthOjv72bqCNOz8DtPivvepRJCfJ3a2IGzHM=; b=Twf1Y7esJEIGgbcfiJ/xfL0vZD
        MTPhlau7lBnrnixVgS3MtIh9pGCwXN83jDSR+wuEdjoCynqpj0iY6I80vZLNgA3J5TFQpMhgcphEP
        b72IDA10v4n2oq/SfQzBmVSKsZH6Y0G7yZ+I6CdpcW9oB7DXbW97JV2IRyRzZBUZ+w6z95MI/AyPm
        2fLYy+Bym1ENuzW9fGO9xhNlbU8hECVaJCJTpuyuwbvDJAPPmQpyGrmgRDmuEfe1SyVSIs2Rh9a/F
        AMXYM78n5+4yJpus79G+YJKAhCBjhfCcIuMZgYix6MPDP/YsoOFfup7njkNf/aMRN5qhMBjToXDu6
        qQCdcqvw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mSZg0-003Zvt-3t; Tue, 21 Sep 2021 06:55:01 +0000
Date:   Tue, 21 Sep 2021 07:54:48 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, io-uring@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RFC] io_uring: warning about unused-but-set parameter
Message-ID: <YUmBuLLTjN1vfhnA@infradead.org>
References: <20210920121352.93063-1-arnd@kernel.org>
 <YUh8Mj59BtyBdTRH@infradead.org>
 <CAK8P3a30a1SKh+71+EgPmsJ1FKJTPKYQuAFUebwKKrhuVzBh3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a30a1SKh+71+EgPmsJ1FKJTPKYQuAFUebwKKrhuVzBh3Q@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Sep 20, 2021 at 02:48:23PM +0200, Arnd Bergmann wrote:
> complete madness of crouse, only -Wunused-but-set-parameter,
> which is already part of W=1 and has the potential of catching
> actual bugs such as

Well, i you care about that just remove the

	locked = NULL;

which is pretty weird anyway.
