Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEDBE4B5BA4
	for <lists+io-uring@lfdr.de>; Mon, 14 Feb 2022 22:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbiBNUxc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Feb 2022 15:53:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbiBNUxR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Feb 2022 15:53:17 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2956E188DCB;
        Mon, 14 Feb 2022 12:52:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=louZKO8cbEM9QptRsxsmHgbH7+Fa+c/S1q0vNYkDH3g=; b=UjdqUYJ1JLKgXUSVseQ8ZBfIZY
        IeI4c1RXj24IwvpQC7ZdMBJszohuKrMZgL6W8FUFzUtFq2uxHBmNh7Qvirb3opvGdGElomF673VVF
        23tAfi/h08HcY1umj1XjsFGyQfMYaT3Aeuj3hbAnSBp5b/33U0yftAOztHV8tMNir2Ek549SUtr/X
        YHtsKW7o0JNhV00q4W10c+4mACf8cNRaKusYiB/nzN6pH+dnMmw8ne1n8yzF7C3C444yZdXkr8dHB
        6k0GtVTVVsHPPWfkxBbgvZ9yGPSO5lk9x5hrA6WSQX6HUA3yO4yThiWpXvw4AA0V7SmJZCCSrVjrb
        C2rM7V4w==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nJgjI-00DBp2-Cc; Mon, 14 Feb 2022 19:09:44 +0000
Date:   Mon, 14 Feb 2022 19:09:44 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v1 04/14] mm: Add support for async buffered writes
Message-ID: <Ygqo+O1D+MLaSmpD@casper.infradead.org>
References: <20220214174403.4147994-1-shr@fb.com>
 <20220214174403.4147994-5-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214174403.4147994-5-shr@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Feb 14, 2022 at 09:43:53AM -0800, Stefan Roesch wrote:
> @@ -1986,6 +1987,10 @@ struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
>  			gfp |= __GFP_WRITE;
>  		if (fgp_flags & FGP_NOFS)
>  			gfp &= ~__GFP_FS;
> +		if (fgp_flags & FGP_NOWAIT) {
> +			gfp |= GFP_ATOMIC;
> +			gfp &= ~__GFP_DIRECT_RECLAIM;
> +		}
>  
>  		folio = filemap_alloc_folio(gfp, 0);

No.  FGP_NOWAIT means "Don't block on page lock".  You can't redefine it
to mean "Use GFP_ATOMIC" without changing all the existing callers.  (Do
not change the existing callers).

__filemap_get_folio() already takes a gfp_t.  There's no need for this.

