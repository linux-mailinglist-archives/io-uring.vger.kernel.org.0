Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB51219110
	for <lists+io-uring@lfdr.de>; Wed,  8 Jul 2020 21:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725915AbgGHT5N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jul 2020 15:57:13 -0400
Received: from casper.infradead.org ([90.155.50.34]:44522 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgGHT5N (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jul 2020 15:57:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3QedjCKlFcADfyqXkA7L2+nDdApGhHWck1i1wXm40Mg=; b=Qdcr3C5ZT56PtDpdy2T5LCfv6t
        ZBeRcQKYcBg6ID+NF8mN32YBZuexEiOMM2xPa1tHcJXGr7CrCrw1yv7Xa/K594m2hH9KYCbg1Iu4u
        mNCxDtT+ron85F8kSiXC8DCDxw2LC7VMr0GnQmrj4Z/RCWZfEv/7glZLrux3soaVISwcVjrsDJ+Q9
        r+Om4zbbhFl4aW2+3D3KpzpP+tmLSLkM54srHqqixXkaNSR2I7ICq1CF8UJx/N8VK+BETnXhb0P55
        +NprhdXFBKSsk53Kkad9r5MOgZ4vH8Tlv2X9VCifPoSUj6n5EozzZpvDRBbW/rdZ7ncnXNkwFjrl7
        L94iZVdw==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtGBF-0007Wt-4f; Wed, 08 Jul 2020 19:56:34 +0000
Date:   Wed, 8 Jul 2020 20:56:32 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] io_uring: fix a use after free in io_async_task_func()
Message-ID: <20200708195632.GW25523@casper.infradead.org>
References: <20200708184711.GA31157@mwanda>
 <58b9349b-22fd-e474-c746-2d3b542f5b23@kernel.dk>
 <66d2af76-eee0-e30d-44e5-ed70d9d808a5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66d2af76-eee0-e30d-44e5-ed70d9d808a5@gmail.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 08, 2020 at 10:28:51PM +0300, Pavel Begunkov wrote:
> On 08/07/2020 22:15, Jens Axboe wrote:
> > On 7/8/20 12:47 PM, Dan Carpenter wrote:
> >> The "apoll" variable is freed and then used on the next line.  We need
> >> to move the free down a few lines.
> > 
> > Thanks for spotting this Dan, applied.
> 
> I wonder why gcc can't find it... It shouldn't be hard to do after
> marking free-like functions with an attribute.
> 
> Are there such tools for the kernel?

GCC doesn't have an __attribute__((free)) yet.  Martin Sebor is working on
it: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=87736
also: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=94527

(I just confirmed with him on IRC that he's still working on it; it's
part of an ongoing larger project)
