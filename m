Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7451B22E08D
	for <lists+io-uring@lfdr.de>; Sun, 26 Jul 2020 17:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgGZPTY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 26 Jul 2020 11:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgGZPTY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 26 Jul 2020 11:19:24 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15CCAC0619D2;
        Sun, 26 Jul 2020 08:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vtsWR5kposDocS52/2wJ1kZ1A8spMlKJv7t/OGXW3Go=; b=MIwLu2JNLgd0x7UfNhObEmRZ+u
        /TUB3piRcXJ82wmv24hFkogBQ3auECc5jT30ANIAuOBbIYdDbMBzFVLBFgsvLPaL+Ry9RfDd+jJcC
        dB/8NY/ZtGeLwgUKwrAMENXUoC8g/xj7G4nR80YQDuARiWzkPNeWfc45hQJYXXrdU1V5h1MqUSIJo
        0A4juTCBGqVeT5I+RRbDX73tq4mGCDFPMnra1RHe4uPsuL4nRk1YtQ9LzzbYU3bBo9+/9PPvVL1qn
        BZFG8ay+s9r8kHVSaZ8AzHuqTkYIjq05Bul9uZjeF8uzfwsDlEWL8HVjILGKBeiNtCh/UQqN7LFBZ
        goHTtJZA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jziQm-0006ih-Qi; Sun, 26 Jul 2020 15:19:16 +0000
Date:   Sun, 26 Jul 2020 16:19:16 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, viro@zeniv.linux.org.uk, bcrl@kvack.org,
        willy@infradead.org, hch@infradead.org, Damien.LeMoal@wdc.com,
        asml.silence@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org, Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Arnav Dawn <a.dawn@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: Re: [PATCH v4 4/6] block: add zone append handling for direct I/O
 path
Message-ID: <20200726151916.GC25328@infradead.org>
References: <1595605762-17010-1-git-send-email-joshi.k@samsung.com>
 <CGME20200724155341epcas5p15bfc55927f2abb60f19784270fe8e377@epcas5p1.samsung.com>
 <1595605762-17010-5-git-send-email-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1595605762-17010-5-git-send-email-joshi.k@samsung.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 24, 2020 at 09:19:20PM +0530, Kanchan Joshi wrote:
> For zoned block device, opt in for zone-append by setting
> FMODE_ZONE_APPEND during open. Make direct IO submission path use
> IOCB_ZONE_APPEND to send bio with append op. Make direct IO completion
> return written-offset, in bytes, to upper layer via ret2 of
> kiocb->ki_complete interface.
> Write with the flag IOCB_ZONE_APPEND are ensured not be be short.
> Prevent short write and instead return failure if appending write spans
> beyond end of device.
> Return failure if write is larger than max_append_limit and therefore
> requires formation of multiple bios.

We should support reporting the append offset for all block devices
and all file systems support by iomap at least.  There is nothing that
requires actual zone append support here.
