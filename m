Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 767DC4B9047
	for <lists+io-uring@lfdr.de>; Wed, 16 Feb 2022 19:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237381AbiBPSei (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Feb 2022 13:34:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234445AbiBPSeh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Feb 2022 13:34:37 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F4E2AB522;
        Wed, 16 Feb 2022 10:34:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Dtq+RXgCuYdBqFViiOLdlPIwiN8guC7NQX0CoQHjOc0=; b=SwWSe2kSdqLjvgKv4aZAqT+Jtk
        xwCqrxjvsPjuXdxeklBGW1ZKECW/B0glZQT1A81XdiLiare7s/IPhJ1TbqC+YGwhwb0UyQNVgvyfa
        lV+YQfLCJmktMrMZCpgzEJhBM1QRMvqZcLP5ntJuAUwQCwAAGNqT9LZ4/6dN8UsQwGF6/P99ItBJF
        JxnpNA9QoNdRINfAOEkDqXmESMU7VyGt8lZ6Mn8jNH8VB79Ctma2qNbIgPKKaIiztd9UeNLTVGUiO
        LdygF+zlfnlgXe9E8YRQS4GWoqZ4aEm1LnY+6EUMS3mBazCKru21aOkO0KFoejVdpOILrPj/CFK54
        58lIMIIg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nKP87-00EwvD-8k; Wed, 16 Feb 2022 18:34:19 +0000
Date:   Wed, 16 Feb 2022 18:34:19 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v1 07/14] fs: Add aop_flags parameter to
 create_page_buffers()
Message-ID: <Yg1Dqw4YYK+HuI0h@casper.infradead.org>
References: <20220214174403.4147994-1-shr@fb.com>
 <20220214174403.4147994-8-shr@fb.com>
 <Ygqb7j8PUIg8dU2v@casper.infradead.org>
 <a577fac3-1ad8-fb91-6ded-a5f2ed1b62a7@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a577fac3-1ad8-fb91-6ded-a5f2ed1b62a7@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Feb 16, 2022 at 10:30:33AM -0800, Stefan Roesch wrote:
> On 2/14/22 10:14 AM, Matthew Wilcox wrote:
> > On Mon, Feb 14, 2022 at 09:43:56AM -0800, Stefan Roesch wrote:
> >> This adds the aop_flags parameter to the create_page_buffers function.
> >> When AOP_FLAGS_NOWAIT parameter is set, the atomic allocation flag is
> >> set. The AOP_FLAGS_NOWAIT flag is set, when async buffered writes are
> >> enabled.
> > 
> > Why is this better than passing in gfp flags directly?
> > 
> 
> I don't think that gfp flags are a great fit here. We only want to pass in
> a nowait flag and this does not map nicely to a gfp flag. 

... what?  The only thing you do with this flag is use it to choose
some gfp flags.  Pass those gfp flags in directly.

> >> +		gfp_t gfp = GFP_NOFS | __GFP_ACCOUNT;
> >> +
> >> +		if (aop_flags & AOP_FLAGS_NOWAIT) {
> >> +			gfp |= GFP_ATOMIC | __GFP_NOWARN;
> >> +			gfp &= ~__GFP_DIRECT_RECLAIM;
> >> +		} else {
> >> +			gfp |= __GFP_NOFAIL;
> >> +		}

The flags you've chosen here are also bonkers, but I'm not sure that
it's worth explaining to you why if you're this resistant to making
obvious corrections to your patches.
