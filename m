Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCC01740A8
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2020 21:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbgB1UHE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Feb 2020 15:07:04 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:49208 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgB1UHD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Feb 2020 15:07:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MR24cvpSgY48ccGH44GSUc8+VcIqnXfQnxpPqapCoV4=; b=k9XgOZCAT08IVxm2QUvsegLsjU
        jbP5zywPrjODmmooEZ2VN6acPNNMhl2BL4eigJmctcA2ULrZzrgvHcRt7l67rdsfo7Fh8LmVhlJtH
        8G/MlaP938VpwjeS1iqyixJgeOP2Ca1GUKUVKfSbzXAHLIPd+MxrDz5FdQ+N5uMgCDZwd9kS+TgHz
        VxSFigeu6gW0i4JtE0NTGQ0wB2xuRbDhaTFtcIRgoUOTcoDwifKpUgvaqZyt/l1QBKOdJPmSWwUmo
        OzNZbuA5l7sfkdX1/RUuOmMI+FgKfDnYkqfQMGF3Ul6WGZ+oxOP4NXqlpoVSvFiKmZoGYg2tUI8jG
        nto4SFhA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j7luS-000824-LP; Fri, 28 Feb 2020 20:06:57 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id AEF4A98037C; Fri, 28 Feb 2020 21:06:53 +0100 (CET)
Date:   Fri, 28 Feb 2020 21:06:53 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Oleg Nesterov <oleg@redhat.com>,
        Carter Li =?utf-8?B?5p2O6YCa5rSy?= <carter.li@eoitek.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH] task_work_run: don't take ->pi_lock unconditionally
Message-ID: <20200228200653.GP11457@worktop.programming.kicks-ass.net>
References: <20200218150756.GC14914@hirez.programming.kicks-ass.net>
 <20200218155017.GD3466@redhat.com>
 <20200220163938.GA18400@hirez.programming.kicks-ass.net>
 <20200220172201.GC27143@redhat.com>
 <20200220174932.GB18400@hirez.programming.kicks-ass.net>
 <20200221145256.GA16646@redhat.com>
 <77349a8d-ecbf-088d-3a48-321f68f1774f@kernel.dk>
 <de55c2ac-bc94-14d8-68b1-b2a9c0cb7428@kernel.dk>
 <20200228192505.GO18400@hirez.programming.kicks-ass.net>
 <4c320163-cb3b-8070-4441-6395c988d55d@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c320163-cb3b-8070-4441-6395c988d55d@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 28, 2020 at 12:28:54PM -0700, Jens Axboe wrote:

> Shelf the one I have queued up, or the suggested changes that you had
> for on top of it?

The stuff on top.
