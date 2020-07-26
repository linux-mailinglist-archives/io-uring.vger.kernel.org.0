Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5CC222E084
	for <lists+io-uring@lfdr.de>; Sun, 26 Jul 2020 17:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgGZPSZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 26 Jul 2020 11:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbgGZPSZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 26 Jul 2020 11:18:25 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB69BC0619D2;
        Sun, 26 Jul 2020 08:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=khbJGT4iiSr5u+iKgwn7bl9+62UCe+CYOlUWfazTxPM=; b=STtIccUJbrGHRgBJdhNTayz1Ld
        ljv3MsUoYDsnK8KLZQFsoDnj6ZI7DzwasiQPTfoO9qzR6ViwsCgKrP566P9Ckq3JaJteeiknLstel
        N2djokW45aiJ75/ZtjAF3dBac/ckrf+MdlBZ/LWWMr9ft3tndvJG5LkG+ITi/fX06N4UlOX/EY1SM
        l7HYYllyigDLLipFkUIQ48f46/OE08cV4ze3kiWNXcoq6fRZDQj1y1mwx0v5Ya7veVhxM2GxFUWST
        OHl1fbiMjdeZNkplTIn2JWt+leI8Ry1ze0Ee7N0H28GXr1EeFAp2blNGoopSuWuStZoZMvmML0VP7
        nj/IZIEA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jziPr-0006f6-2o; Sun, 26 Jul 2020 15:18:19 +0000
Date:   Sun, 26 Jul 2020 16:18:19 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, viro@zeniv.linux.org.uk, bcrl@kvack.org,
        willy@infradead.org, hch@infradead.org, Damien.LeMoal@wdc.com,
        asml.silence@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org, SelvaKumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: Re: [PATCH v4 2/6] fs: change ki_complete interface to support 64bit
 ret2
Message-ID: <20200726151819.GB25328@infradead.org>
References: <1595605762-17010-1-git-send-email-joshi.k@samsung.com>
 <CGME20200724155324epcas5p18e1d3b4402d1e4a8eca87d0b56a3fa9b@epcas5p1.samsung.com>
 <1595605762-17010-3-git-send-email-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1595605762-17010-3-git-send-email-joshi.k@samsung.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 24, 2020 at 09:19:18PM +0530, Kanchan Joshi wrote:
> From: SelvaKumar S <selvakuma.s1@samsung.com>
> 
> kiocb->ki_complete(...,long ret2) - change ret2 to long long.
> This becomes handy to return 64bit written-offset with appending write.
> Change callers using ki_complete prototype.

There is no need for this at all.  By the time ki_complete is called
ki_pos contains the new offset, and you just have to subtract res from
that.
