Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A008B21B70E
	for <lists+io-uring@lfdr.de>; Fri, 10 Jul 2020 15:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbgGJNtm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jul 2020 09:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727092AbgGJNtm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jul 2020 09:49:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68F9C08C5CE;
        Fri, 10 Jul 2020 06:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3xDdy1lO/VESQQ+XIKtdvZXNsbdN37Eb/qTJ2DIu6ic=; b=hb75Vl/qOQRKSrCFc7dBnj8nW+
        DWLgtlYO8WDorx37QoqqOFXFQdt2KKIPDcszlbj3SKdQzbQFO8s4eABPxYQVxXmoGNHlJPI/JjLj2
        pglouwDIRscalO2YKgKmMXSVJ00Ui8W8dUaWRrTiYOPsOGYhWbhuitupp8fnuq5utEipxiWuWvdtv
        iL49fdyjs3HVLBnoyB98A1PwrUP1zDq+nApWW2D5PwI5PX8nFOlV4qfGV8gPNzzRKGWZKSmIyH8Xt
        T8My2DllIHM3gCGhF/MFhMt8MLPgMTUREzgUp2H3W0yA51WlMSR9Bex/9L0hZi7q8Ajc0PXBd6I1S
        gcL2CmOg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jttPA-0004GD-AI; Fri, 10 Jul 2020 13:49:32 +0000
Date:   Fri, 10 Jul 2020 14:49:32 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Kanchan Joshi <joshiiitr@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Kanchan Joshi <joshi.k@samsung.com>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, Damien.LeMoal@wdc.com, asml.silence@gmail.com,
        linux-fsdevel@vger.kernel.org, Matias Bj??rling <mb@lightnvm.io>,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
Message-ID: <20200710134932.GA16257@infradead.org>
References: <fe0066b7-5380-43ee-20b2-c9b17ba18e4f@kernel.dk>
 <20200709085501.GA64935@infradead.org>
 <adc14700-8e95-10b2-d914-afa5029ae80c@kernel.dk>
 <20200709140053.GA7528@infradead.org>
 <2270907f-670c-5182-f4ec-9756dc645376@kernel.dk>
 <CA+1E3r+H7WEyfTufNz3xBQQynOVV-uD3myYynkfp7iU+D=Svuw@mail.gmail.com>
 <f5e3e931-ef1b-2eb6-9a03-44dd5589c8d3@kernel.dk>
 <CA+1E3rLna6VVuwMSHVVEFmrgsTyJN=U4CcZtxSGWYr_UYV7AmQ@mail.gmail.com>
 <20200710131054.GB7491@infradead.org>
 <20200710134824.GK12769@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710134824.GK12769@casper.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 10, 2020 at 02:48:24PM +0100, Matthew Wilcox wrote:
> If we're going to go the route of changing the CQE, how about:
> 
>  struct io_uring_cqe {
>          __u64   user_data;      /* sqe->data submission passed back */
> -        __s32   res;            /* result code for this event */
> -        __u32   flags;
> +	union {
> +		struct {
> +		        __s32   res;            /* result code for this event */
> +		        __u32   flags;
> +		};
> +		__s64	res64;
> +	};
>  };
> 
> then we don't need to change the CQE size and it just depends on the SQE
> whether the CQE for it uses res+flags or res64.

How do you return a status code or short write when you just have
a u64 that is needed for the offset?
