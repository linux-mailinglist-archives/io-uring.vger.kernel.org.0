Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8A28234693
	for <lists+io-uring@lfdr.de>; Fri, 31 Jul 2020 15:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730170AbgGaNIN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jul 2020 09:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726306AbgGaNIM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jul 2020 09:08:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1576C061574;
        Fri, 31 Jul 2020 06:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yj2xoKAlywTl8ua8JXKgkinbNIInpoi9iZwApZLpN2A=; b=lxhLj+6vz4x4ci3cMgZ260rQw0
        OJj6UHCushW5rXV/rva78XtNf8Lqj9latQCF+qH8fJDo2i3+qSOYB5Ee1OQMfti4CudmhNRKXmWGn
        V37fFhMvteQiPOxnsLmZLLDONGsNCv4WmgI3KO86/GqYMPeh6skRpctvUxr92QVr1PEuh6wkywaDN
        UDr6jqSIq6jc5oLRhr4SjIWiBwYrzhIrfqXvXaWo5zcht1R+faNn32zi1c0Y5nVk6NZeY71vyLjNA
        jS0iTJtNbZvsSZSfaBv0oij76BB3ZkVOsMsT/yCA0noHRDX1QksuDxj5lLM+/O7LH44gdHbu8nIMk
        7C1vL1bw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k1UlW-0004do-Ce; Fri, 31 Jul 2020 13:08:02 +0000
Date:   Fri, 31 Jul 2020 14:08:02 +0100
From:   "hch@infradead.org" <hch@infradead.org>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     "hch@infradead.org" <hch@infradead.org>,
        Kanchan Joshi <joshiiitr@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        Matthew Wilcox <willy@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        SelvaKumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Naohiro Aota <Naohiro.Aota@wdc.com>
Subject: Re: [PATCH v4 6/6] io_uring: add support for zone-append
Message-ID: <20200731130802.GA16665@infradead.org>
References: <MWHPR04MB3758DC08EA17780E498E9EC0E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731064526.GA25674@infradead.org>
 <MWHPR04MB37581344328A42EA7F5ED13EE74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <CA+1E3rLM4G4SwzD6RWsK6Ssp7NmhiPedZDjrqN3kORQr9fxCtw@mail.gmail.com>
 <MWHPR04MB375863C20C1EF2CB27E62703E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731091416.GA29634@infradead.org>
 <MWHPR04MB37586D39CA389296CE0252A4E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731094135.GA4104@infradead.org>
 <MWHPR04MB3758A4B2967DB1FABAAD9265E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731125110.GA11500@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731125110.GA11500@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

And FYI, this is what I'd do for a hacky aio-only prototype (untested):


diff --git a/fs/aio.c b/fs/aio.c
index 91e7cc4a9f179b..42b1934e38758b 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1438,7 +1438,10 @@ static void aio_complete_rw(struct kiocb *kiocb, long res, long res2)
 	}
 
 	iocb->ki_res.res = res;
-	iocb->ki_res.res2 = res2;
+	if ((kiocb->ki_flags & IOCB_REPORT_OFFSET) && res > 0)
+		iocb->ki_res.res2 = kiocb->ki_pos - res;
+	else
+		iocb->ki_res.res2 = res2;
 	iocb_put(iocb);
 }
 
@@ -1452,6 +1455,8 @@ static int aio_prep_rw(struct kiocb *req, const struct iocb *iocb)
 	req->ki_flags = iocb_flags(req->ki_filp);
 	if (iocb->aio_flags & IOCB_FLAG_RESFD)
 		req->ki_flags |= IOCB_EVENTFD;
+	if (iocb->aio_flags & IOCB_FLAG_REPORT_OFFSET)
+		req->ki_flags |= IOCB_REPORT_OFFSET;
 	req->ki_hint = ki_hint_validate(file_write_hint(req->ki_filp));
 	if (iocb->aio_flags & IOCB_FLAG_IOPRIO) {
 		/*
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f5abba86107d86..522b0a3437d420 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -316,6 +316,7 @@ enum rw_hint {
 #define IOCB_WRITE		(1 << 6)
 #define IOCB_NOWAIT		(1 << 7)
 #define IOCB_NOIO		(1 << 9)
+#define IOCB_REPORT_OFFSET	(1 << 10)
 
 struct kiocb {
 	struct file		*ki_filp;
diff --git a/include/uapi/linux/aio_abi.h b/include/uapi/linux/aio_abi.h
index 8387e0af0f768a..e4313d7aa3b7e7 100644
--- a/include/uapi/linux/aio_abi.h
+++ b/include/uapi/linux/aio_abi.h
@@ -55,6 +55,7 @@ enum {
  */
 #define IOCB_FLAG_RESFD		(1 << 0)
 #define IOCB_FLAG_IOPRIO	(1 << 1)
+#define IOCB_FLAG_REPORT_OFFSET	(1 << 2)
 
 /* read() from /dev/aio returns these structures. */
 struct io_event {
