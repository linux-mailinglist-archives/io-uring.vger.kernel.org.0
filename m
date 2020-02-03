Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E66101502AD
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2020 09:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbgBCIe0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Feb 2020 03:34:26 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46850 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727631AbgBCIeZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Feb 2020 03:34:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ISKvjtxCsGxQouTQF8hu8PX2HbDANACxqq7KIY//4yE=; b=TPzCq1rZNQC4MjD4/eHCYwj++B
        uVkU7m7QWlHdOnu8gaUR58eZEvw7weYpohE4czQxabBGG6w+j8y6ijFb1xN3GhASBC3JjF9S/Zr6R
        f8XFaqiMBzkmZyDJ+N6cc+Aa3Ep31qWgJc9ryJiDx47o8kevpkWci4EI1nJL73B2pw2WBxHa6URH0
        HmIpPHWELtR4k8dAKk/pzRcs/DPRXvCQ/UewHMTo/lGO2tlAWfcj58tbTObn5bIBi7oz8bz4dHslp
        B995uUl8bhowcH1NsDyYedCv+hKhkb17CNEjtFaxqrOTWAu62luPFIyeqwSkmPjTUCgJT7dXS4Qta
        Gx/Dt/Lw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iyXBW-0001Eo-4p; Mon, 03 Feb 2020 08:34:22 +0000
Date:   Mon, 3 Feb 2020 00:34:22 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 1/1] block: Manage bio references so the bio persists
 until necessary
Message-ID: <20200203083422.GA2671@infradead.org>
References: <1580441022-59129-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1580441022-59129-2-git-send-email-bijan.mottahedeh@oracle.com>
 <20200131064230.GA28151@infradead.org>
 <9f29fbc7-baf3-00d1-a20c-d2a115439db2@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9f29fbc7-baf3-00d1-a20c-d2a115439db2@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jan 31, 2020 at 06:08:16PM +0000, Bijan Mottahedeh wrote:
> I think the problem is that in the async case, bio_get() is not called for
> the initial bio *before* the submit_bio() call for that bio:
> 
>     if (dio->is_sync) {
>         dio->waiter = current;
>         bio_get(bio);
>     } else {
>         dio->iocb = iocb;
>     }
> 
> 
> The bio_get() call for the async case happens too late, after the
> submit_bio() call:
> 
>         if (!dio->multi_bio) {
>             /*
>              * AIO needs an extra reference to ensure the dio
>              * structure which is embedded into the first bio
>              * stays around.
>              */
>             if (!is_sync)
>                 bio_get(bio);
>             dio->multi_bio = true;
>             atomic_set(&dio->ref, 2);
>         } else {
>             atomic_inc(&dio->ref);
>         }

That actualy is before the submit_bio call, which is just below that
code.

>
> 
> See my previous message on the mailing list titled "io_uring: acquire
> ctx->uring_lock before calling io_issue_sqe()" for the more details but
> basically blkdev_bio_end_io() can be called before submit_bio() returns and
> therefore free the initial bio.  I think it is the unconditional bio_put()
> at the end that does it.

But we never access the bio after submit_bio returns for the single
bio async case, so I still don't understand the problem.
