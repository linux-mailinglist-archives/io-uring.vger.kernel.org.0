Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 901786BD7D0
	for <lists+io-uring@lfdr.de>; Thu, 16 Mar 2023 19:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbjCPSH5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Mar 2023 14:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbjCPSH4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Mar 2023 14:07:56 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC4CB79C4;
        Thu, 16 Mar 2023 11:07:50 -0700 (PDT)
Received: from biznet-home.integral.gnuweeb.org (unknown [182.253.183.169])
        by gnuweeb.org (Postfix) with ESMTPSA id 3D74A7E73F;
        Thu, 16 Mar 2023 18:07:47 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1678990070;
        bh=DOI/vhfRjWJ7oxxrRJuBZvtdAxMi6YB40xZiAb1Ksi4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hSmsCUrq1m99gDZeEOWK8MWugjCVC7865y7nKHx64B7ksIJj7/UFtj46b5Veh7F1o
         nQnqqB1cFhM8VRyoTNWt1kitCqmZFe/s7V6fBVe7nw0Jv0zUn1oc9jahibsVWppC79
         /1rf9+Hd+hToBX03FTK2FeMbxUmyJMU4d8RYQttWWi+TyxQGrvxxrMbiVDRBzph/w7
         7Q9RBy20BizsiOsiOhYCcGVd6/4TWmyRNj4iPDko54Mu2ZnEFTcJGJp1YhyodDhyD/
         gpLTwc64+x9dN5ZofJNeIxKJJl+ABxW7HDyFQnS21LWfxzRZ5ObSwSSawTa6TJ3ofE
         MCIpITLumJQEg==
Date:   Fri, 17 Mar 2023 01:07:43 +0700
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Helge Deller <deller@gmx.de>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Parisc Mailing List <linux-parisc@vger.kernel.org>
Subject: Re: [PATCH 5/5] io_uring: add support for user mapped provided
 buffer ring
Message-ID: <ZBNa7/tIwEXiQMcQ@biznet-home.integral.gnuweeb.org>
References: <20230314171641.10542-1-axboe@kernel.dk>
 <20230314171641.10542-6-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314171641.10542-6-axboe@kernel.dk>
X-Bpl:  hUx9VaHkTWcLO7S8CQCslj6OzqBx2hfLChRz45nPESx5VSB/xuJQVOKOB1zSXE3yc9ntP27bV1M1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I tried to verify the for-next build report. And I think this doesn't
look right.

On Tue, Mar 14, 2023 at 11:16:42AM -0600, Jens Axboe wrote:
> @@ -214,15 +215,27 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
>  	if (!nbufs)
>  		return 0;
>  
> -	if (bl->is_mapped && bl->buf_nr_pages) {
> -		int j;
> -
> +	if (bl->is_mapped) {
>  		i = bl->buf_ring->tail - bl->head;
                    ^^^^^^^^^^^^^^^^^^

Dereference bl->buf_ring. It implies bl->buf_ring is not NULL.

> -		for (j = 0; j < bl->buf_nr_pages; j++)
> -			unpin_user_page(bl->buf_pages[j]);
> -		kvfree(bl->buf_pages);
> -		bl->buf_pages = NULL;
> -		bl->buf_nr_pages = 0;
> +		if (bl->is_mmap) {
> +			if (bl->buf_ring) {
                        ^^^^^^^^^^^^^^^^^

A NULL check against bl->buf_ring here. If it was possible to be NULL,
wouldn't the above dereference BUG()?

-- 
Ammar Faizi

