Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4824F4B5BF0
	for <lists+io-uring@lfdr.de>; Mon, 14 Feb 2022 22:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbiBNU4Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Feb 2022 15:56:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiBNU4P (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Feb 2022 15:56:15 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD17106CBE;
        Mon, 14 Feb 2022 12:55:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6oV/BYsJ2Iv0nHeWAGsToliTTqLlD4Bf/cVkrUQ0q7o=; b=eqy7DkvNFn/UaH2Y4iuSapWyBs
        56nmEkKA1dVhifDqvbt5jBaUFAbk+AAKU3lIBcZ0qP6RMHm/o4qytHppKZvNLHq8O7zO8+PwmyZLX
        DgFYD61GcXaXnXhpsQEQkupJxCpv2y3lSKpN5YapX4pw7mJNCHUyOR46dguSvPNROeu1ruHmIJOyg
        V/wp8LJZcANNzlTTBfuMUUYqQsk9EJgUv0Lrwg69UFGpDrWms/vtAyKRG+gbNeNyialLCPJVplDFk
        ttNsQPLVwTqCYXBAQLk4SOUnNgk9C00drQts9/5u1auKcPijnvKP9/MTA5qrvM6a/x20BsG5ecclB
        s6lnMBsA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nJgcj-00DBTt-BB; Mon, 14 Feb 2022 19:02:57 +0000
Date:   Mon, 14 Feb 2022 19:02:57 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v1 01/14] fs: Add flags parameter to
 __block_write_begin_int
Message-ID: <YgqnYYRZKGMQK7N/@casper.infradead.org>
References: <20220214174403.4147994-1-shr@fb.com>
 <20220214174403.4147994-2-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214174403.4147994-2-shr@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Feb 14, 2022 at 09:43:50AM -0800, Stefan Roesch wrote:
> This adds a flags parameter to the __begin_write_begin_int() function.
> This allows to pass flags down the stack.

In general, I am not in favour of more AOP_FLAG uses.  I'd prefer to
remove the two that we do have (reiserfs is the only user of
AOP_FLAG_CONT_EXPAND and AOP_FLAG_NOFS can usually be replaced by
passing in gfp_t flags).
