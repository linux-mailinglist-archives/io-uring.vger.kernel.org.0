Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A10C3EA8A2
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 18:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232744AbhHLQks (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 12:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232725AbhHLQks (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 12:40:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F8CC061756;
        Thu, 12 Aug 2021 09:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=L3TZh+KM/khYCofsHrKJGBXtbLTS523mfgnWyZNdJAw=; b=rYhU10EdwQ/vBC0iBHQwnX8vc+
        N05gi7ilrjAUnSv5QKZ0pyH++Qr06LkVmj5Kacbb/I+z8f4TKiu6wZLYd6u3mD7eEPfrK9ZJeYX7P
        hk73lCPTBHzNE9cTClVo+HFCFVrVJZ1lYv/3bT3/rXfe4PYgwC1IuqIekLWLxLtEbpZJo4qZeURuD
        ISRpx1dcLWNdzE9oEnBoFZdN5ATFlECWmRbxB7FSaIHe/NPNTv/qIWyp+N1TXIHDJYh1z6QDqUFTv
        ubXWjN1RmTrwAoXpPGRxrtFJeUPAHS5sspAYA5uuLqG985JPWdCD723s3E+Pdr3DpaKoToYm/MZv7
        2OcSIC8Q==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mEDjY-00EmEz-Pl; Thu, 12 Aug 2021 16:39:26 +0000
Date:   Thu, 12 Aug 2021 17:39:08 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH 5/6] io_uring: enable use of bio alloc cache
Message-ID: <YRVOrHvfBSKBiBEr@infradead.org>
References: <20210812154149.1061502-1-axboe@kernel.dk>
 <20210812154149.1061502-6-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812154149.1061502-6-axboe@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Aug 12, 2021 at 09:41:48AM -0600, Jens Axboe wrote:
> Mark polled IO as being safe for dipping into the bio allocation
> cache, in case the targeted bio_set has it enabled.
> 
> This brings an IOPOLL gen2 Optane QD=128 workload from ~3.0M IOPS to
> ~3.3M IOPS.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Didn't the cover letter say 3.5M+ IOPS, though?
