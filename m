Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3922F477918
	for <lists+io-uring@lfdr.de>; Thu, 16 Dec 2021 17:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236763AbhLPQa5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Dec 2021 11:30:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239114AbhLPQa5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Dec 2021 11:30:57 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19147C061574
        for <io-uring@vger.kernel.org>; Thu, 16 Dec 2021 08:30:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xnWEXOZkKkaJSMhIpKZJuUl3Fw7AOQgr8GUGiornnME=; b=V+KR05xWGKvH49npnKAX49tAkN
        rQXgORN/CYBI9JfS8XJmv92qP/toDvRnHalzmPR8AwRex1nXPS9cXSP7FYUPnHqnAD8INgJeGKH8v
        CR0a4c7FqjG8FnWvrkaYdJOGbFs/y3QP6XtVmuXt5PRE7xmnwr7OHasnjDLGmPWLLe1MhFeQgAcT3
        bx1SNvIwN8A68g1l8jflrY6uC+g6BIwImj8WOCt/4C3W3ibKxkcGVZbV10lZjEdUnq5aYYbSpeY5x
        Xj5uxNnUpN8z6LSLgq7KkaNFrVqx5NMzJOcfVdY2LyhPHfvQcB1jkjaZznKb1INjRoAh1XimezHAM
        S6m4lclA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mxtei-006d71-GL; Thu, 16 Dec 2021 16:30:56 +0000
Date:   Thu, 16 Dec 2021 08:30:56 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/4] nvme: add support for mq_ops->queue_rqs()
Message-ID: <YbtpwAP5HJSKAjh8@infradead.org>
References: <20211215162421.14896-1-axboe@kernel.dk>
 <20211215162421.14896-5-axboe@kernel.dk>
 <YbsB/W/1Uwok4i0u@infradead.org>
 <83aa4715-7bf8-4ed1-6945-3910cb13f233@kernel.dk>
 <YbtmPjisO5RIAnby@infradead.org>
 <db771bc2-4d7a-ee1c-aff7-f8e37dc964d5@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db771bc2-4d7a-ee1c-aff7-f8e37dc964d5@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Dec 16, 2021 at 09:27:18AM -0700, Jens Axboe wrote:
> OK, I misunderstood which one you referred to then. So this incremental,

Yes, that's the preferred version.
