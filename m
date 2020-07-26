Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7120422E08F
	for <lists+io-uring@lfdr.de>; Sun, 26 Jul 2020 17:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbgGZPUW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 26 Jul 2020 11:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbgGZPUV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 26 Jul 2020 11:20:21 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72ADAC0619D2;
        Sun, 26 Jul 2020 08:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=uNW1eZ4bx44vGwfBMFPSJ/xfKPBN8zLMfK//Re7u/r8=; b=hgywvEY7znvmMpz/qJfRo27bKH
        8KllS+Z3U+0/fzHmuJd2FBTeRViKOOXxYvHeFHUmQ+OPLlwk8cCRCUII73LNMY3iXCTsRotJQC6Bz
        abLmbfPBHQMDJYgueFPta9U3YmgN5+euI9UuThGRSnOg+NdOTXU/QlxIBesV3n4A3nPO0K3DgIrPa
        v9SkxBM3g7zT5QqqghYXEi9xn+CiLjUwjPuhLoG9VTk23a2MJU2+bCBd/OjqJ9i9m4bUA55xV4Rdo
        j2u/9a4lsBmd34Y47dy2wb+oJJi8kkgUuehsf+mqg0NpBQTrg18+ipcQ8M7WGuBpsBYxfS4+vmLgh
        WfR7QqGA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jziRi-0006pE-JN; Sun, 26 Jul 2020 15:20:14 +0000
Date:   Sun, 26 Jul 2020 16:20:14 +0100
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
Subject: Re: [PATCH v4 5/6] block: enable zone-append for iov_iter of bvec
 type
Message-ID: <20200726152014.GD25328@infradead.org>
References: <1595605762-17010-1-git-send-email-joshi.k@samsung.com>
 <CGME20200724155346epcas5p2cfb383fe9904a45280c6145f4c13e1b4@epcas5p2.samsung.com>
 <1595605762-17010-6-git-send-email-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1595605762-17010-6-git-send-email-joshi.k@samsung.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 24, 2020 at 09:19:21PM +0530, Kanchan Joshi wrote:
> zone-append with bvec iov_iter gives WARN_ON, and returns -EINVAL.
> Add new helper to process such iov_iter and add pages in bio honoring
> zone-append specific constraints.
> This is used to enable zone-append with io-uring fixed-buffer.
> 
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> Signed-off-by: Selvakumar S <selvakuma.s1@samsung.com>
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>
> ---
>  block/bio.c | 31 ++++++++++++++++++++++++++++---
>  1 file changed, 28 insertions(+), 3 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 0cecdbc..ade9da7 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -975,6 +975,30 @@ static int __bio_iov_bvec_add_pages(struct bio *bio, struct iov_iter *iter)
>  	iov_iter_advance(iter, size);
>  	return 0;
>  }
> +static int __bio_iov_bvec_append_add_pages(struct bio *bio, struct iov_iter *iter)

Missing empty line and too long line, please stick to 80 chars for this
code.

Otherwise this looks sensible.
