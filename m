Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9CD542A1A6
	for <lists+io-uring@lfdr.de>; Tue, 12 Oct 2021 12:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235496AbhJLKIW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Oct 2021 06:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232699AbhJLKIV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Oct 2021 06:08:21 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E22C061570;
        Tue, 12 Oct 2021 03:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Tm/SVhWyh0og9kUpE+P54a51MFIH9FnLLFZknRdEFn4=; b=O8UVPi0ygN+0OhAkW4mXfXCVn3
        c5WWOQuqD5gopWyCpqD80f3NEDSaWSpqcKLBMY09AoSrsvDMaYm4rJGiDyPoa87TO3d7ejwXJrISi
        TLvVN1SpzNOZ2tprhPq2BP5yo4CVBt2ADh4zy8jt+i4NRQTYdnW7xEJMPi7+5OjfOwO5d6PD347hN
        0Z7Bs49063KQeAcvzhDd8A+PrX+wajEg2jczTjYhHXCg3GCiZlYG7vVQStA8oisINLFdjASWBnGG7
        B3018lYsUdH9pfxr6WWEJItOzcve/EWcpgPUWmD+CYmCydlueRjBP0ZQlq5N66dS0LRBnv7HHj0+m
        H83zP/mQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1maEeP-006Oie-KT; Tue, 12 Oct 2021 10:05:21 +0000
Date:   Tue, 12 Oct 2021 11:04:49 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 1/3] block: bump max plugged deferred size from 16 to 32
Message-ID: <YWVdwWUuzqp7s7FV@infradead.org>
References: <20211006231330.20268-1-axboe@kernel.dk>
 <20211006231330.20268-2-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006231330.20268-2-axboe@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Oct 06, 2021 at 05:13:28PM -0600, Jens Axboe wrote:
> Particularly for NVMe with efficient deferred submission for many
> requests, there are nice benefits to be seen by bumping the default max
> plug count from 16 to 32. This is especially true for virtualized setups,
> where the submit part is more expensive. But can be noticed even on
> native hardware.

It might be worth to throw in a comment how ths value was chosen.

Otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
