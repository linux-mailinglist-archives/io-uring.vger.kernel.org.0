Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62275219D76
	for <lists+io-uring@lfdr.de>; Thu,  9 Jul 2020 12:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgGIKRk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jul 2020 06:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbgGIKRj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jul 2020 06:17:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8220C061A0B;
        Thu,  9 Jul 2020 03:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LRPqrhsNrVoCtzLxk2wePAErWiLop2DSkjv1pIhjoHg=; b=GBV5Mmfdm2akDAsfJJUzUXaw06
        1X1qfTTyW7QEtBEjfGD5qe55tU/LYxGUNuvdSK+mdIV4lZoO2isTN9NMUkHIDvypM/Tlgf5Bzz0LD
        DdwJCG+atOIh2kmNiDGNlspUcMKRsBs3MyF7jeuin83VXsC0vf4EkvI1RSQ1rIQBf/ypJn56hlmnf
        jmep2fHi3S9ott/V3ERLi/TmjgCTRunpQUwcs6eg7ZckXDF2ZisSHei0QxENA9Jp+ar9H6rlz7q+l
        JiO63nNcvO9IqyjV3r2oaQJPy49Y0StY0EludsHDgPjq+iVbkN0mPvPmIREoRDU/AnNEt/OHSb3OS
        7yLXvO0A==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtTc1-0000aq-Tc; Thu, 09 Jul 2020 10:17:05 +0000
Date:   Thu, 9 Jul 2020 11:17:05 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kanchan Joshi <joshi.k@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: Re: [PATCH 0/2] Remove kiocb ki_complete
Message-ID: <20200709101705.GA2095@infradead.org>
References: <20200708222637.23046-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200708222637.23046-1-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I really don't like this series at all.  If saves a single pointer
but introduces a complicated machinery that just doesn't follow any
natural flow.  And there doesn't seem to be any good reason for it to
start with.
