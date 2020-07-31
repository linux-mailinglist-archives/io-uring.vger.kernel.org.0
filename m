Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327E1234376
	for <lists+io-uring@lfdr.de>; Fri, 31 Jul 2020 11:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732257AbgGaJlo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jul 2020 05:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732254AbgGaJlo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jul 2020 05:41:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D52C061574;
        Fri, 31 Jul 2020 02:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yW1amiISh90U+7G4GBjuyuOrXFidnl8gA0+LdBOz9oA=; b=PCla3Z6gdsm86AfGkcADwFVzi7
        HbRDcD/SlnJelgcZZgvKBC3Ql5xFrnfPU53TlnpOhyuqNPY0gRqBVZHrJErJQ6/0OxQh5jljdTgpt
        Dq8IW7p01tolCCIxV+ujqh/2/gMdQC8c50YpxU6jYEPW4N/QeIEzLVkcWACdArfP93u6TJ2IA7ZdW
        x1hM1O8AffyTzSNYYE5auRSwkCZ2DJk5XTHo+y7bTtgsqFVsTd9ai36CVFqTnnpUFH7BsyIiDiv0q
        08S2tip82hsIVDzqLV5YY1RADfyKJr1+7sA0BN1VU0xvjvVXnH9WKFBAP0ulwffDKp7YfFvrxhsoB
        5sfSebfA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k1RXj-0001Yr-IF; Fri, 31 Jul 2020 09:41:35 +0000
Date:   Fri, 31 Jul 2020 10:41:35 +0100
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
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCH v4 6/6] io_uring: add support for zone-append
Message-ID: <20200731094135.GA4104@infradead.org>
References: <CA+1E3rJ3SoLU9aYcugAQgJnSPnJtcCwjZdMREXS3FTmXgy3yow@mail.gmail.com>
 <f030a338-cd52-2e83-e1da-bdbca910d49e@kernel.dk>
 <CA+1E3rKxZk2CatTuPcQq5d14vXL9_9LVb2_+AfR2m9xn2WTZdg@mail.gmail.com>
 <MWHPR04MB3758DC08EA17780E498E9EC0E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731064526.GA25674@infradead.org>
 <MWHPR04MB37581344328A42EA7F5ED13EE74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <CA+1E3rLM4G4SwzD6RWsK6Ssp7NmhiPedZDjrqN3kORQr9fxCtw@mail.gmail.com>
 <MWHPR04MB375863C20C1EF2CB27E62703E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731091416.GA29634@infradead.org>
 <MWHPR04MB37586D39CA389296CE0252A4E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR04MB37586D39CA389296CE0252A4E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 31, 2020 at 09:34:50AM +0000, Damien Le Moal wrote:
> Sync writes are done under the inode lock, so there cannot be other writers at
> the same time. And for the sync case, since the actual written offset is
> necessarily equal to the file size before the write, there is no need to report
> it (there is no system call that can report that anyway). For this sync case,
> the only change that the use of zone append introduces compared to regular
> writes is the potential for more short writes.
> 
> Adding a flag for "report the actual offset for appending writes" is fine with
> me, but do you also mean to use this flag for driving zone append write vs
> regular writes in zonefs ?

Let's keep semantics and implementation separate.  For the case
where we report the actual offset we need a size imitation and no
short writes.

Anything with those semantics can be implemented using Zone Append
trivially in zonefs, and we don't even need the exclusive lock in that
case.  But even without that flag anything that has an exclusive lock can
at least in theory be implemented using Zone Append, it just need
support for submitting another request from the I/O completion handler
of the first.  I just don't think it is worth it - with the exclusive
lock we do have access to the zone serialied so a normal write works
just fine.  Both for the sync and async case.

> The fcntl or ioctl for getting the max atomic write size would be fine too.
> Given that zonefs is very close to the underlying zoned drive, I was assuming
> that the application can simply consult the device sysfs zone_append_max_bytes
> queue attribute.

For zonefs we can, yes.  But in many ways that is a lot more cumbersome
that having an API that works on the fd you want to write on.

> For regular file systems, this value would be used internally
> only. I do not really see how it can be useful to applications. Furthermore, the
> file system may have a hard time giving that information to the application
> depending on its underlying storage configuration (e.g. erasure
> coding/declustered RAID).

File systems might have all kinds of limits of their own (e.g. extent
sizes).  And a good API that just works everywhere and is properly
documented is much better than heaps of cargo culted crap all over
applications.
