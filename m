Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70D9307842
	for <lists+io-uring@lfdr.de>; Thu, 28 Jan 2021 15:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbhA1Ohk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Jan 2021 09:37:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbhA1Ohe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Jan 2021 09:37:34 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BD7C061573;
        Thu, 28 Jan 2021 06:36:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qfAZf6ZlTjVgH/IQFEPEEQyZ2qBJXEjzt5yHOvBrM7g=; b=v53fKlviZc5sva3sIUfmyQSDwf
        vECJy6fhl/xvrQxMUjM7yRht/5xeQI133IEUEnazHP2sqyv95gQrAYwKO9ydaaYozNmGs25UNxkdy
        UZkkqXR5QnaT22xxka1QAHmET9yRHli848etiAdMKtBqo8xxNDmeDyoV/CYSJT34rB7lH38Y9Wp3s
        r2tt4T0/syQV24vwfbb3Qn5JxqSeHLMa1N9jdwucGbIX+G5CV0MyJ0MebFcTesb784J/y+Kk3t+LX
        JgnbVLcu5k9nagve01nJ+VY6K2MWWYO3G8UcjXkhp9dHZtDduKjMCQvLq74iEOSELcAEUa6c9gUgk
        +cePZcCA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l58PY-008Zc6-Qb; Thu, 28 Jan 2021 14:36:41 +0000
Date:   Thu, 28 Jan 2021 14:36:40 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     JeffleXu <jefflexu@linux.alibaba.com>
Cc:     Christoph Hellwig <hch@infradead.org>, snitzer@redhat.com,
        joseph.qi@linux.alibaba.com, dm-devel@redhat.com,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH v2 3/6] block: add iopoll method to support bio-based IO
 polling
Message-ID: <20210128143640.GA2043450@infradead.org>
References: <20210125121340.70459-1-jefflexu@linux.alibaba.com>
 <20210125121340.70459-4-jefflexu@linux.alibaba.com>
 <20210128084016.GA1951639@infradead.org>
 <7d5402f2-c4d7-9d9a-e637-54a2dd349b3f@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d5402f2-c4d7-9d9a-e637-54a2dd349b3f@linux.alibaba.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jan 28, 2021 at 07:52:05PM +0800, JeffleXu wrote:
> 
> 
> On 1/28/21 4:40 PM, Christoph Hellwig wrote:
> > On Mon, Jan 25, 2021 at 08:13:37PM +0800, Jeffle Xu wrote:
> >> +int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
> > 
> > Can you split the guts of this function into two separate helpers
> > for the mq vs non-mq case?  As is is is a little hard to read and
> > introduced extra branches in the fast path.
> > 
> 
> I know your consideration, actually I had ever tried.
> 
> I can extract some helper functions, but I'm doubted if the extra
> function call is acceptable.
> 
> Besides, the iteration logic is generic and I'm afraid the branch or
> function call is unavoidable. Or if we maintain two separate function
> for mq and dm, the code duplication may be unavoidable.

I'd just split the functions entirely at the highest level.
