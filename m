Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D27B218A56
	for <lists+io-uring@lfdr.de>; Wed,  8 Jul 2020 16:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729881AbgGHOpZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jul 2020 10:45:25 -0400
Received: from casper.infradead.org ([90.155.50.34]:36326 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729595AbgGHOpZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jul 2020 10:45:25 -0400
X-Greylist: delayed 1276 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Jul 2020 10:45:25 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MrAnEvtYxJ3CG9gxR3loAOZTO73HHraqyOfrOks4hhg=; b=JMJwqmeTQ9cGJpeD9W93Dw1IjO
        XWotEiYbye0J2WZMFOcGjZcu3WbLV55gbbJHp4tN6THMa9cj8svxx7BtFefMqc5eD0hLPhSeiRHfc
        dht8oKIrdba3H++FPHoTHrH8o9AQOKTc5hTH/OdDHsBq21QVOWsKJkMnSgzwbdKEGeCAdNafeHIRP
        HEnmGYkfg5gUtC+4LV/Yixsovv71OLHrATMzHBfgyjOvNVwWFVhR/b96qceLBtbGfR6b7iZywHu96
        xYgs+G2w1wHc8O/belST07+MM+apfnisUfdTHRfp0HtCEz7f1uB/VtCHjo6wP6mC5f+lUYi8bEbKU
        1Q3ih66A==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtAyJ-0007LT-Jr; Wed, 08 Jul 2020 14:22:51 +0000
Date:   Wed, 8 Jul 2020 15:22:51 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     Jens Axboe <axboe@kernel.dk>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, hch@infradead.org, Damien.LeMoal@wdc.com,
        asml.silence@gmail.com, linux-fsdevel@vger.kernel.org,
        mb@lightnvm.io, linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
Message-ID: <20200708142251.GQ25523@casper.infradead.org>
References: <4a9bf73e-f3ee-4f06-7fad-b8f8861b0bc1@kernel.dk>
 <20200706143208.GA25523@casper.infradead.org>
 <20200707151105.GA23395@test-zns>
 <20200707155237.GM25523@casper.infradead.org>
 <20200707202342.GA28364@test-zns>
 <7a44d9c6-bf7d-0666-fc29-32c3cba9d1d8@kernel.dk>
 <20200707221812.GN25523@casper.infradead.org>
 <CGME20200707223803epcas5p41814360c764d6b5f67fdbf173a8ba64e@epcas5p4.samsung.com>
 <145cc0ad-af86-2d6a-78b3-9ade007aae52@kernel.dk>
 <20200708125805.GA16495@test-zns>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200708125805.GA16495@test-zns>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 08, 2020 at 06:28:05PM +0530, Kanchan Joshi wrote:
> The last thing is about the flag used to trigger this processing. Will it be
> fine to intoduce new flag (RWF_APPEND2 or RWF_APPEND_OFFSET)
> instead of using RWF_APPEND?
> 
> New flag will do what RWF_APPEND does and will also return the
> written-location (and therefore expects pointer setup in application).

I think it's simpler to understand if it's called RWF_INDIRECT_OFFSET
Then it'd look like:

+	rwf_t rwf = READ_ONCE(sqe->rw_flags);
...
-	iocb->ki_pos = READ_ONCE(sqe->off);
+	if (rwf & RWF_INDIRECT_OFFSET) {
+		loff_t __user *loffp = u64_to_user_ptr(sqe->addr2);
+
+		if (get_user(iocb->ki_pos, loffp)
+			return -EFAULT;
+		iocb->ki_loffp = loffp;
+	} else {
+		iocb->ki_pos = READ_ONCE(sqe->off);
+	}
...
-	ret = kiocb_set_rw_flags(kiocb, READ_ONCE(sqe->rw_flags));
+	ret = kiocb_set_rw_flags(kiocb, rwf);

