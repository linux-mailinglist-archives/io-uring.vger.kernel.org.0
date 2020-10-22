Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0AC2960B5
	for <lists+io-uring@lfdr.de>; Thu, 22 Oct 2020 16:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443484AbgJVOKk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 10:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2442858AbgJVOKk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Oct 2020 10:10:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 202A2C0613CE
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 07:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=t2bZnP+rctmVrRIc/SzGwMkVhSC+/cbQBfFQMrZXn/8=; b=h56hKfQHD5DGej7Qcr/ErVsAWP
        m0ffk6kNO0c9y4cnmFK5nLUcTeVFz9+B6jrf/AM6so7t+U1W3DNBq5yUeus1c9gYXhFJD8/qNijjr
        OF/1TUlZt2xM/+XwEN/FrZiszwdYdmGR+5NIvfg5lpujI4ls9kekj6LrlGF17Q4pFRQR8fpqtS1L8
        8k8WIMpcdkXEjqffKw17+HtpYCns4fhto5wLq/BBkUJILWiYYRNQO4t2x92uTLEWt937mP9xHi3Cb
        zJUZRj6cV35M8MsU4XZKnJ8ZhuDBRRWUWE0ETJpBiHxiB2cbOxgcfmTwcPyZbc4qMW8ppNuVq+wNH
        pfCTOGOg==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kVbIb-00027y-6o; Thu, 22 Oct 2020 14:10:37 +0000
Date:   Thu, 22 Oct 2020 15:10:37 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RFC] mm: fix the sync buffered read to the old way
Message-ID: <20201022141037.GS20115@casper.infradead.org>
References: <1603375114-58419-1-git-send-email-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1603375114-58419-1-git-send-email-haoxu@linux.alibaba.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Oct 22, 2020 at 09:58:34PM +0800, Hao Xu wrote:
> The commit 324bcf54c449 changed the code path of async buffered reads
> to go with the page_cache_sync_readahead() way when readahead is
> disabled, meanwhile the sync buffered reads are forced to do IO in the
> above way as well, which makes it go to a more complex code path.

But ->readpage is (increasingly) synchronous while readahead should be
used to start async I/Os.  I'm pretty sure Jens meant to do exactly what
he did.

