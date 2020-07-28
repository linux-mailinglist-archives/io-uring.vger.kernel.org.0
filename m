Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D90522FF18
	for <lists+io-uring@lfdr.de>; Tue, 28 Jul 2020 03:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbgG1BuK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jul 2020 21:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgG1BuK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jul 2020 21:50:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 017BAC061794;
        Mon, 27 Jul 2020 18:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=sO5DBW8cKfAwrO4ChCjI6ktCdvfob49E/MQneeyqWGA=; b=EQh16+tJezpBCQzOPoGKRmK7tx
        rUU9S+ewLhBxfY8sfxvrACb0HgWQEPyDfriXZeY+1Qcy4tXecE1iY6bb6bP9rKhRfcA9karWizDFU
        X34xVM3QWYJJgdaxRjX7FiNqBbKem5a6KzCdvnt3EDLC43aUe4/uPzlusL2HHlvG7A+4sjD+ArBK9
        hBhsC+AiRxftL568fyevrFOI6ONxLd//10BOX7rIcO04xzcTZpuTsfRj9Rqgx35X42iaxgXILc+Fm
        /TZi9plKEEjDqiXHrQYcehpFRjT7NCFWeL1PjxuyH+wPoP9Ax8AkSMVN9NZEoOMb+izFu2nk2kb05
        uWWJ+D6Q==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k0Ekh-00070f-DB; Tue, 28 Jul 2020 01:50:00 +0000
Date:   Tue, 28 Jul 2020 02:49:59 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, bcrl@kvack.org, Damien.LeMoal@wdc.com,
        asml.silence@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org, Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: Re: [PATCH v4 1/6] fs: introduce FMODE_ZONE_APPEND and
 IOCB_ZONE_APPEND
Message-ID: <20200728014959.GO23808@casper.infradead.org>
References: <1595605762-17010-1-git-send-email-joshi.k@samsung.com>
 <CGME20200724155258epcas5p1a75b926950a18cd1e6c8e7a047e6c589@epcas5p1.samsung.com>
 <1595605762-17010-2-git-send-email-joshi.k@samsung.com>
 <20200726151810.GA25328@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200726151810.GA25328@infradead.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Jul 26, 2020 at 04:18:10PM +0100, Christoph Hellwig wrote:
> Zone append is a protocol context that ha not business showing up
> in a file system interface.  The right interface is a generic way
> to report the written offset for an append write for any kind of file.
> So we should pick a better name like FMODE_REPORT_APPEND_OFFSET
> (not that I particularly like that name, but it is the best I could
> quickly come up with).

Is it necessarily *append*?  There were a spate of papers about ten
years ago for APIs that were "write anywhere and I'll tell you where it
ended up".  So FMODE_ANONYMOUS_WRITE perhaps?
