Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9EB8219EE2
	for <lists+io-uring@lfdr.de>; Thu,  9 Jul 2020 13:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgGILKj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jul 2020 07:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbgGILKj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jul 2020 07:10:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F8FC061A0B;
        Thu,  9 Jul 2020 04:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/myYpnCCMiEJKy/mwmtgXMuLa5s6GUxQEGJeQoTY/qo=; b=XxH5eZ79FQ6Y0woPfTeuaD54pl
        H/6h/M2RYn7YtWi4MfADnd89/zW9fUsOsSEO8dgMM+qrLTro1qeEyCDIDmgJUlYdfWFzhsmDzap7r
        57naCnIVOixvdegCXiPMLuSq8QV/Hsk+CjJEY3keFNWufiEX7lbFKclmPDDtgOeGBFIn59ehXCWI2
        3RKz9V3H3JCptMz0ED2DcbA+f4h0C/VfPVcaScu7IuGKPAgv+wSnrRlGrVx8CIYIgnu4ROpJiFYrH
        qABucRQpDAB84/bON3Zc4bCuEVcCw32oClvC+85XeYuvedbaFxE0+Lb+omrtkC9qPwhsY0+flhgYE
        QVCjOcxw==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtURo-0003ii-7X; Thu, 09 Jul 2020 11:10:36 +0000
Date:   Thu, 9 Jul 2020 12:10:36 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kanchan Joshi <joshi.k@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: Re: [PATCH 0/2] Remove kiocb ki_complete
Message-ID: <20200709111036.GA12769@casper.infradead.org>
References: <20200708222637.23046-1-willy@infradead.org>
 <20200709101705.GA2095@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709101705.GA2095@infradead.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 09, 2020 at 11:17:05AM +0100, Christoph Hellwig wrote:
> I really don't like this series at all.  If saves a single pointer
> but introduces a complicated machinery that just doesn't follow any
> natural flow.  And there doesn't seem to be any good reason for it to
> start with.

Jens doesn't want the kiocb to grow beyond a single cacheline, and we
want the ability to set the loff_t in userspace for an appending write,
so the plan was to replace the ki_complete member in kiocb with an
loff_t __user *ki_posp.

I don't think it's worth worrying about growing kiocb, personally,
but this seemed like the easiest way to make room for a new pointer.
