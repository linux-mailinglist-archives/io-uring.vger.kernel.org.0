Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17D3217AEE
	for <lists+io-uring@lfdr.de>; Wed,  8 Jul 2020 00:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbgGGWSb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jul 2020 18:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726946AbgGGWSb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jul 2020 18:18:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E76BC061755;
        Tue,  7 Jul 2020 15:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1K4l6yYDUhNq1W8OpHwz9oEz6LJgckDMlJCE1K+hf90=; b=TqIkf7gSfTZ+ypBulT5xLFqsmS
        v0W/P23ds3WGz6uS1Mx+XEGqDBiXuTMdeBtvYACL7StjeswkSp4n0kANmczuzodkB/QAUE7wvuYUk
        EdRwYwzbg9lKJycCQS6VLZTacs2Y4M+juEcNJHE0X/SpKcEKAReFTfvU8WHaXj3ieoY0Qz8sO3NT8
        wLv1Vq5F/hT45AGGHahNcsGKAdG89vSfqRudgpFpuu25LhhW1yTlJh2x8dIvUYbkmBvWWAcnzl2qB
        e5eFcCx2r3f2+qyvJteQW7aYH0h6SLXh6YbLo9ouhDZJ0IKUe/hAnG8+kwP5SOJNsopqkaHU2ikuQ
        N6a3MnHg==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jsvum-0001dA-Mj; Tue, 07 Jul 2020 22:18:12 +0000
Date:   Tue, 7 Jul 2020 23:18:12 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, hch@infradead.org, Damien.LeMoal@wdc.com,
        asml.silence@gmail.com, linux-fsdevel@vger.kernel.org,
        mb@lightnvm.io, linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
Message-ID: <20200707221812.GN25523@casper.infradead.org>
References: <fe0066b7-5380-43ee-20b2-c9b17ba18e4f@kernel.dk>
 <20200705210947.GW25523@casper.infradead.org>
 <239ee322-9c38-c838-a5b2-216787ad2197@kernel.dk>
 <20200706141002.GZ25523@casper.infradead.org>
 <4a9bf73e-f3ee-4f06-7fad-b8f8861b0bc1@kernel.dk>
 <20200706143208.GA25523@casper.infradead.org>
 <20200707151105.GA23395@test-zns>
 <20200707155237.GM25523@casper.infradead.org>
 <20200707202342.GA28364@test-zns>
 <7a44d9c6-bf7d-0666-fc29-32c3cba9d1d8@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a44d9c6-bf7d-0666-fc29-32c3cba9d1d8@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 07, 2020 at 02:40:06PM -0600, Jens Axboe wrote:
> >> so we have another 24 bytes before io_kiocb takes up another cacheline.
> >> If that's a serious problem, I have an idea about how to shrink struct
> >> kiocb by 8 bytes so struct io_rw would have space to store another
> >> pointer.
> > Yes, io_kiocb has room. Cache-locality wise whether that is fine or
> > it must be placed within io_rw - I'll come to know once I get to
> > implement this. Please share the idea you have, it can come handy.
> 
> Except it doesn't, I'm not interested in adding per-request type fields
> to the generic part of it. Before we know it, we'll blow past the next
> cacheline.
> 
> If we can find space in the kiocb, that'd be much better. Note that once
> the async buffered bits go in for 5.9, then there's no longer a 4-byte
> hole in struct kiocb.

Well, poot, I was planning on using that.  OK, how about this:

+#define IOCB_NO_CMPL		(15 << 28)

 struct kiocb {
[...]
-	void (*ki_complete)(struct kiocb *iocb, long ret, long ret2);
+	loff_t __user *ki_uposp;
-	int			ki_flags;
+	unsigned int		ki_flags;

+typedef void ki_cmpl(struct kiocb *, long ret, long ret2);
+static ki_cmpl * const ki_cmpls[15];

+void ki_complete(struct kiocb *iocb, long ret, long ret2)
+{
+	unsigned int id = iocb->ki_flags >> 28;
+
+	if (id < 15)
+		ki_cmpls[id](iocb, ret, ret2);
+}

+int kiocb_cmpl_register(void (*cb)(struct kiocb *, long, long))
+{
+	for (i = 0; i < 15; i++) {
+		if (ki_cmpls[id])
+			continue;
+		ki_cmpls[id] = cb;
+		return id;
+	}
+	WARN();
+	return -1;
+}

... etc, also need an unregister.

