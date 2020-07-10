Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41BE321B706
	for <lists+io-uring@lfdr.de>; Fri, 10 Jul 2020 15:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgGJNse (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jul 2020 09:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbgGJNsd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jul 2020 09:48:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B281C08C5CE;
        Fri, 10 Jul 2020 06:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3sEWKCgSSIJlrf5jylxGAqRUeqaTvOph1wbVl9BPw2U=; b=pPiM8bMasRSGqygx9oUy8tC8Xm
        Li5gj0nNDz6jJRK0BaXcFZHy75weUBw1+Ahkd4xRXqnqt0JTU1LOENkF34flVjVBrrpffQAF9A3V/
        8Z92+xOx9CQW4XI47QxeCT3HI4Maa9xtfSuGl9gLyqSMm8mDkyS/IZJ8eZ940C/OvAwkk+85X10OT
        H5/RwtnNGC5E6AjtyATcbpvbe4Jj0Iiv2bDDh8W678THbJELC6cHqsILZ45eWwlHQRyQcxo4ldroY
        adRZX9LVQR98oIQ3LC8/6TJ6fIuSfk+uMONEpV0jWrweSZH/e74OzdGH85K1ADlQnvrHN3CQlteac
        EJlYC0Ng==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jttO4-0004DD-TF; Fri, 10 Jul 2020 13:48:24 +0000
Date:   Fri, 10 Jul 2020 14:48:24 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Kanchan Joshi <joshiiitr@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Kanchan Joshi <joshi.k@samsung.com>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, Damien.LeMoal@wdc.com, asml.silence@gmail.com,
        linux-fsdevel@vger.kernel.org, Matias Bj??rling <mb@lightnvm.io>,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
Message-ID: <20200710134824.GK12769@casper.infradead.org>
References: <1593974870-18919-5-git-send-email-joshi.k@samsung.com>
 <fe0066b7-5380-43ee-20b2-c9b17ba18e4f@kernel.dk>
 <20200709085501.GA64935@infradead.org>
 <adc14700-8e95-10b2-d914-afa5029ae80c@kernel.dk>
 <20200709140053.GA7528@infradead.org>
 <2270907f-670c-5182-f4ec-9756dc645376@kernel.dk>
 <CA+1E3r+H7WEyfTufNz3xBQQynOVV-uD3myYynkfp7iU+D=Svuw@mail.gmail.com>
 <f5e3e931-ef1b-2eb6-9a03-44dd5589c8d3@kernel.dk>
 <CA+1E3rLna6VVuwMSHVVEFmrgsTyJN=U4CcZtxSGWYr_UYV7AmQ@mail.gmail.com>
 <20200710131054.GB7491@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710131054.GB7491@infradead.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 10, 2020 at 02:10:54PM +0100, Christoph Hellwig wrote:
> On Fri, Jul 10, 2020 at 12:35:43AM +0530, Kanchan Joshi wrote:
> > Append required special treatment (conversion for sector to bytes) for io_uring.
> > And we were planning a user-space wrapper to abstract that.
> > 
> > But good part (as it seems now) was: append result went along with cflags at
> > virtually no additional cost. And uring code changes became super clean/minimal
> > with further revisions.
> > While indirect-offset requires doing allocation/mgmt in application,
> > io-uring submission
> > and in completion path (which seems trickier), and those CQE flags
> > still get written
> > user-space and serve no purpose for append-write.
> 
> I have to say that storing the results in the CQE generally make
> so much more sense.  I wonder if we need a per-fd "large CGE" flag
> that adds two extra u64s to the CQE, and some ops just require this
> version.

If we're going to go the route of changing the CQE, how about:

 struct io_uring_cqe {
         __u64   user_data;      /* sqe->data submission passed back */
-        __s32   res;            /* result code for this event */
-        __u32   flags;
+	union {
+		struct {
+		        __s32   res;            /* result code for this event */
+		        __u32   flags;
+		};
+		__s64	res64;
+	};
 };

then we don't need to change the CQE size and it just depends on the SQE
whether the CQE for it uses res+flags or res64.
