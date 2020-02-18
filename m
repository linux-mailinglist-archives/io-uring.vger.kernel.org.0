Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE0921626EE
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2020 14:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgBRNN4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Feb 2020 08:13:56 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49182 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbgBRNN4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Feb 2020 08:13:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=EL9Z1hymITAdsVTeF0C6/J/IZONkKNCLrMb8u+SP1ec=; b=VsbOCeem0C6QjceKbVafDym55O
        3LQUT6fcFUX446PpAJn+p+AlahocJyxnMIMyWtPghQWIuOU9qjweL4Hr2VBzWxEa3QeyFsJRqmthb
        khlfclkR0lsjsz+uw529V0fx3oUBRsPYr/SxXj9l7r0S7JwUgpdGIJiOU/Wx34Hy/5+/vgyPsMbpk
        qyvC0hkcWjuuEQpCvEljSphaIW6qY4xYKK6sCF0UG9aR0pEDg6bVzxT3zr5eKdDSFg9FaLSoUu2K9
        iQmkxPS/fk1GXqRp+XytGTWhWmoONfY22V/AysoNP+ymD3v2v62LT25mOLLJf+/fmJgZYK0TLLSFC
        HG+W/koQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j42hA-0004V5-VM; Tue, 18 Feb 2020 13:13:49 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A96B5300565;
        Tue, 18 Feb 2020 14:11:54 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5F8712B92E8B7; Tue, 18 Feb 2020 14:13:46 +0100 (CET)
Date:   Tue, 18 Feb 2020 14:13:46 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Carter Li =?utf-8?B?5p2O6YCa5rSy?= <carter.li@eoitek.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
Message-ID: <20200218131346.GA14914@hirez.programming.kicks-ass.net>
References: <671A3FE3-FA12-43D8-ADF0-D1DB463B053F@eoitek.com>
 <217eda7b-3742-a50b-7d6a-c1294a85c8e0@kernel.dk>
 <1b9a7390-7539-a8bc-d437-493253b13d77@kernel.dk>
 <20200214153218.GM14914@hirez.programming.kicks-ass.net>
 <5995f84e-8a6c-e774-6bb5-5b9b87a9cd3c@kernel.dk>
 <7c4c3996-4886-eb58-cdee-fe0951907ab5@kernel.dk>
 <addcd44e-ed9b-5f82-517d-c1ed3ee2d85c@kernel.dk>
 <b8069e62-7ea4-c7f3-55a3-838241951068@kernel.dk>
 <20200217120920.GQ14914@hirez.programming.kicks-ass.net>
 <53de3581-b902-89ba-3f53-fd46b052df40@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53de3581-b902-89ba-3f53-fd46b052df40@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Feb 17, 2020 at 08:12:30AM -0800, Jens Axboe wrote:
> Only potential hitch I see there is related to ordering, which is more
> of a fairness thab correctness issue. I'm going to ignore that for now,
> and we can always revisit later.

If that ever becomes a thing, see:

  c82199061009 ("task_work: remove fifo ordering guarantee")
