Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AACC4BC14D
	for <lists+io-uring@lfdr.de>; Fri, 18 Feb 2022 21:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233043AbiBRUmp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Feb 2022 15:42:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233019AbiBRUmp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Feb 2022 15:42:45 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25CD641300;
        Fri, 18 Feb 2022 12:42:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=40QY1Rdp00LDixcusTe0wqIqkM2Ud3XthEeGP7JtuJA=; b=cBFK4XH1tw4+phmmvC7nGvrX4L
        6osPzcETAuu34InapaZ7gOJ6H+6bCzaKz90YQXm0mLDTMoNIDvUkws9jJA4wD1oAPCGWAuLdCnMDG
        BTT9nRV54tjQEIu8eAnfiq8JUNrSw7741Zu4rC7PA1Tp79NRz387sYrTQYo8wunvgE7+8IMPyImRs
        a+YxknknT4s70r6EQz6GWBVVmFRE2Mzu59KuouGWpYnjfxoOEic91nf8Y8FzAIVj7AI6yvL3KT7kJ
        Km4ieSywJsgocAQVEuBfgcpUOj7RdYpTC7bIEmyOfpBiJoQ7FYXLL81lomlHlauaP11TT/W+KKwCi
        YRAjamQg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nLA5A-00GvUM-Tm; Fri, 18 Feb 2022 20:42:25 +0000
Date:   Fri, 18 Feb 2022 20:42:24 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 04/13] fs: split off __alloc_page_buffers function
Message-ID: <YhAEsGZj363ooo+h@casper.infradead.org>
References: <20220218195739.585044-1-shr@fb.com>
 <20220218195739.585044-5-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220218195739.585044-5-shr@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 18, 2022 at 11:57:30AM -0800, Stefan Roesch wrote:
> This splits off the __alloc_page_buffers() function from the
> alloc_page_buffers_function(). In addition it adds a gfp_t parameter, so
> the caller can specify the allocation flags.

This one only has six callers, so let's get the API right.  I suggest
making this:

struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size,
		gfp_t gfp)
{
	gfp |= __GFP_ACCOUNT;

and then all the existing callers specify either GFP_NOFS or
GFP_NOFS | __GFP_NOFAIL.

