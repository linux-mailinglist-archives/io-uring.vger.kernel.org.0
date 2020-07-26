Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E688B22E080
	for <lists+io-uring@lfdr.de>; Sun, 26 Jul 2020 17:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgGZPSU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 26 Jul 2020 11:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbgGZPSU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 26 Jul 2020 11:18:20 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8598BC0619D2;
        Sun, 26 Jul 2020 08:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cYcLOt9xMtmqE1IKx7EJ1yVFnTZAqfZV+W0fuS8FqWc=; b=um7wejtOBrnxldoh/n2UwYzdJD
        D9kN+dcL/MsT/0uG9sGqD8xfLD9J1OZl36V8NSMrE09UsBqvu5cey9jY62V9FZ+l0rfWlK2XivUQ5
        IvH8MMhKTIuHmlxZTP2YzPDzfb5cybiixpKPU2L9yzQiyshm67sAIyAYZaS1u71ZYizWOSQI2tkmZ
        xodRaLGMMyE5//vKS2Hmbd9saln6jEn3qGiPpEk7V7s8dupqyhTmcTeO0EMJ46MGFeeOVY9yWVlOK
        5sIRSUu6VFjVOx2zaDKoQcIzXsKhsm/LzpkqVbNsWq0dmTLKOFGVKdOx0MexfeDq26NjNefxjkUDA
        2+7zsW2w==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jziPi-0006ej-M1; Sun, 26 Jul 2020 15:18:10 +0000
Date:   Sun, 26 Jul 2020 16:18:10 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, viro@zeniv.linux.org.uk, bcrl@kvack.org,
        willy@infradead.org, hch@infradead.org, Damien.LeMoal@wdc.com,
        asml.silence@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org, Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: Re: [PATCH v4 1/6] fs: introduce FMODE_ZONE_APPEND and
 IOCB_ZONE_APPEND
Message-ID: <20200726151810.GA25328@infradead.org>
References: <1595605762-17010-1-git-send-email-joshi.k@samsung.com>
 <CGME20200724155258epcas5p1a75b926950a18cd1e6c8e7a047e6c589@epcas5p1.samsung.com>
 <1595605762-17010-2-git-send-email-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1595605762-17010-2-git-send-email-joshi.k@samsung.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Zone append is a protocol context that ha not business showing up
in a file system interface.  The right interface is a generic way
to report the written offset for an append write for any kind of file.
So we should pick a better name like FMODE_REPORT_APPEND_OFFSET
(not that I particularly like that name, but it is the best I could
quickly come up with).
