Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53C9D6B8EDD
	for <lists+io-uring@lfdr.de>; Tue, 14 Mar 2023 10:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjCNJit (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Mar 2023 05:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbjCNJis (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Mar 2023 05:38:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A77C679;
        Tue, 14 Mar 2023 02:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5vvaeukfVSdJbsrX1lxYq00qs7EC/RNOV613Y0sKPI4=; b=cQxSFauQquCGX0VgW80UZvRRVU
        VjrL6g2jiy9wP2REnCA3b1tD4Kjpt0NX4ib7f1mYOuiiiY8PpGIX3pZrFGLbtrDvUql6rD5hLdlpX
        uS0CXR5EGPhdBC9FC7Qq6hxUbTb//hNhV20rgndMSTHOoz0hW6TCRioflH8XeDucDy56tH9WXP/ou
        dINc8BcqVgFXucYkZHxQ/v0Az3irEGuhFGIdkiZgBWemc09NoqfBuz0CsKwvEWpim8FOoVX80ZZfx
        XDRRn7niWirRyFVdAzt8OYiowCpyMmuR6aGeFKdVRt13LrCIbiE/K8/umLqUipcjOtj+T3ChGAOk3
        r54x7AKw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pc17C-00CmKV-J2; Tue, 14 Mar 2023 09:38:42 +0000
Date:   Tue, 14 Mar 2023 09:38:42 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/3] pipe: enable handling of IOCB_NOWAIT
Message-ID: <ZBBAoqTUlU7XJImT@casper.infradead.org>
References: <20230308031033.155717-1-axboe@kernel.dk>
 <20230308031033.155717-3-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308031033.155717-3-axboe@kernel.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Mar 07, 2023 at 08:10:32PM -0700, Jens Axboe wrote:
> @@ -493,9 +507,13 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
>  			int copied;
>  
>  			if (!page) {
> -				page = alloc_page(GFP_HIGHUSER | __GFP_ACCOUNT);
> +				gfp_t gfp = __GFP_HIGHMEM | __GFP_ACCOUNT;
> +
> +				if (!nonblock)
> +					gfp |= GFP_USER;
> +				page = alloc_page(gfp);

Hmm, looks like you drop __GFP_HARDWALL in the nonblock case.  People who
use cpusets might be annoyed by that.

>  				if (unlikely(!page)) {
> -					ret = ret ? : -ENOMEM;
> +					ret = ret ? : nonblock ? -EAGAIN : -ENOMEM;

double ternary operator?  really?

					if (!ret)
						ret = nonblock ? -EAGAIN : -ENOMEM;

