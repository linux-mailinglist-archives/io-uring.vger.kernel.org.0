Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE5E26138D
	for <lists+io-uring@lfdr.de>; Tue,  8 Sep 2020 17:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730478AbgIHPcx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Sep 2020 11:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730283AbgIHPYH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Sep 2020 11:24:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83CC5C08C5ED;
        Tue,  8 Sep 2020 08:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hyoD9QmcI5oiNUeN3ikrG7yLEGezAUx3TNWi/z6zbWI=; b=pgKsLb/aVboApOOdFqn5zDVWgG
        Snx9karx64Rd7CkJliDojwf8qA6Vh8rEzXBdRiZ8IQONB/Feeejk7hc6VphgfXzIdXRcmZqmEQSAj
        5+cj7IfmEd2fNt84yK5+jgEZ9BGWTAAdzs+64KItaB1DXE5Kc0WjadecA0kyx3wIm0Py7BPINIWFK
        K6h868Fkl8wsC8soHGKMlfCMsIA1vDWjYdnTq579hK/y7Muua+Oimtkv6XxgFIkUy04p3qROWpPGg
        BhIPKafV1qYxUpaG3uBP5qGUxTfc4x7kGtPFdj3u0f6h5QbDHQSj5enIFCSO0WKCv3+p/khC8QmVr
        ujFJjjAA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kFfNh-0004N6-CU; Tue, 08 Sep 2020 15:18:01 +0000
Date:   Tue, 8 Sep 2020 16:18:01 +0100
From:   "hch@infradead.org" <hch@infradead.org>
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     "hch@infradead.org" <hch@infradead.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
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
Message-ID: <20200908151801.GA16742@infradead.org>
References: <CA+1E3rLM4G4SwzD6RWsK6Ssp7NmhiPedZDjrqN3kORQr9fxCtw@mail.gmail.com>
 <MWHPR04MB375863C20C1EF2CB27E62703E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731091416.GA29634@infradead.org>
 <MWHPR04MB37586D39CA389296CE0252A4E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731094135.GA4104@infradead.org>
 <MWHPR04MB3758A4B2967DB1FABAAD9265E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731125110.GA11500@infradead.org>
 <CY4PR04MB37517D633920E4D31AC6EA0DE74B0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200814081411.GA16943@infradead.org>
 <CA+1E3r+WXC_MK5Zf2OZEv17ddJDjtXbhpRFoeDns4F341xMhow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1E3r+WXC_MK5Zf2OZEv17ddJDjtXbhpRFoeDns4F341xMhow@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Sep 07, 2020 at 12:31:42PM +0530, Kanchan Joshi wrote:
> But there are use-cases which benefit from supporting zone-append on
> raw block-dev path.
> Certain user-space log-structured/cow FS/DB will use the device that
> way. Aerospike is one example.
> Pass-through is synchronous, and we lose the ability to use io-uring.

So use zonefs, which is designed exactly for that use case.
