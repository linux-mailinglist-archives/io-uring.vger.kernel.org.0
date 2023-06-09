Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5426E729B0F
	for <lists+io-uring@lfdr.de>; Fri,  9 Jun 2023 15:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbjFINH4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Jun 2023 09:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbjFINHz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Jun 2023 09:07:55 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 153FC2D74;
        Fri,  9 Jun 2023 06:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1686316073;
        bh=0ul0obtGOxYV6/odr4pTROAjF+3eU0MKJl2ER52zhBI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=k1KZokw74XoTtKFKdTSdKU48rp4Q0axJc5YwUhCYQDsC+B585daNmDoaTS4X0/q+M
         /lYKeUbYnkiXt4aylEeddT+ZLxawc9rp2QOWWNtcy/vAEfk2D2a4cl3DnOAX5D5Icp
         q6YLTc7EPnmdBAZ3e5Nz2yXQ8BrGlFknnjt8ClqgkVQupQY6jPi5yGVi2BtDQhP+n4
         +IyIPesNKrPaViQdlfILYDpB6K4+VkllRGsaYKj961ELSEwhlbHSl4XuzRe2aTryxa
         kyeC+QcgIS5C6J1LF4hB5bUyc0p7+GzoO6zWILna5/giq4qzgoCsLjC+2BTuYxOpS2
         qAq1wWJbnqfEQ==
Received: from biznet-home.integral.gnuweeb.org (unknown [103.74.5.63])
        by gnuweeb.org (Postfix) with ESMTPSA id C05FF23EC43;
        Fri,  9 Jun 2023 20:07:51 +0700 (WIB)
Date:   Fri, 9 Jun 2023 20:07:38 +0700
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Hao Xu <hao.xu@linux.dev>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Linux Fsdevel Mailing List <linux-fsdevel@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Subject: Re: [PATCH 07/11] io_uring: add new api to register fixed workers
Message-ID: <ZIMkGh3kI0tfoxxp@biznet-home.integral.gnuweeb.org>
References: <20230609122031.183730-1-hao.xu@linux.dev>
 <20230609122031.183730-8-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609122031.183730-8-hao.xu@linux.dev>
X-Bpl:  hUx9VaHkTWcLO7S8CQCslj6OzqBx2hfLChRz45nPESx5VSB/xuJQVOKOB1zSXE3yc9ntP27bV1M1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jun 09, 2023 at 08:20:27PM +0800, Hao Xu wrote:
> +	rcu_read_lock();
> +
> +	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
> +		unsigned int nr = count[i].nr_workers;
> +
> +		acct = &wq->acct[i];
> +		acct->fixed_nr = nr;
> +		acct->fixed_workers = kcalloc(nr, sizeof(struct io_worker *),
> +					      GFP_KERNEL);
> +		if (!acct->fixed_workers) {
> +			ret = -ENOMEM;
> +			break;
> +		}
> +
> +		for (j = 0; j < nr; j++) {
> +			struct io_worker *worker =
> +				io_wq_create_worker(wq, acct, true);
> +			if (IS_ERR(worker)) {
> +				ret = PTR_ERR(worker);
> +				break;
> +			}
> +			acct->fixed_workers[j] = worker;
> +		}
> +		if (j < nr)
> +			break;
> +	}
> +	rcu_read_unlock();

This looks wrong. kcalloc() with GFP_KERNEL may sleep. Note that you're
not allowed to sleep inside the RCU read lock critical section.

Using GFP_KERNEL implies GFP_RECLAIM, which means that direct reclaim
may be triggered under memory pressure; the calling context must be
allowed to sleep.

-- 
Ammar Faizi

