Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5381C3EA894
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 18:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbhHLQdX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 12:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbhHLQdX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 12:33:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94CFC061756;
        Thu, 12 Aug 2021 09:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tjmjBpSBqsZf+/EJHCAHJu+M5CpnuHJ9Gp/V8cFx4xU=; b=WKPTdcv5+jSyYTbmR9ZJKSSijE
        SrqIp7+f9uflBQSPFw+8fuHss4eF7ui10e180ZFzgiCvRxnz09NMxfKVMRmseywlSzD1MhqiCC5Gi
        u339UOEk52xJXkI/UGA3Fo1wAT8KJBEdajDAC06LmKbQf05Z0EEpVbaMLXOp0KIhx3HmLrgi58bnP
        Xh3tV0BukHGjyyLrwQZXSBMIqAP+CQ0ObEo/B2+JtElEU5onnox6aJnS1hX4PJDDvisHmA0ANVNGi
        1fS+89Maor8xdEaq/BYBPwiSYBF1hLnnDZfXN/W5u9jawhasQOd71YuPWsgXfeOEvPpp8aS5ggKYp
        aAgr5GpQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mEDco-00ElrW-NW; Thu, 12 Aug 2021 16:32:18 +0000
Date:   Thu, 12 Aug 2021 17:32:10 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/6] bio: add allocation cache abstraction
Message-ID: <YRVNCubDmQSUslSd@infradead.org>
References: <20210812154149.1061502-1-axboe@kernel.dk>
 <20210812154149.1061502-4-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812154149.1061502-4-axboe@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[adding Thomas for a cpu hotplug questions]

> +static void bio_alloc_cache_destroy(struct bio_set *bs)
> +{
> +	int cpu;
> +
> +	if (!bs->cache)
> +		return;
> +
> +	preempt_disable();
> +	cpuhp_state_remove_instance_nocalls(CPUHP_BIO_DEAD, &bs->cpuhp_dead);
> +	for_each_possible_cpu(cpu) {
> +		struct bio_alloc_cache *cache;
> +
> +		cache = per_cpu_ptr(bs->cache, cpu);
> +		bio_alloc_cache_prune(cache, -1U);
> +	}
> +	preempt_enable();

If I understand the cpu hotplug state machine we should not get any new
cpu down callbacks after cpuhp_state_remove_instance_nocalls returned,
so what do we need the preempt disable here for?

> +	/*
> +	 * Hot un-plug notifier for the per-cpu cache, if used
> +	 */
> +	struct hlist_node cpuhp_dead;

Nit, even if we don't need the cpu up notifaction the node actually
provides both.  So I'd reword the comment drop the _dead from the
member name.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
