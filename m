Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE1704BC11E
	for <lists+io-uring@lfdr.de>; Fri, 18 Feb 2022 21:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239261AbiBRUWv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Feb 2022 15:22:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239295AbiBRUWu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Feb 2022 15:22:50 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D13D4B1F7;
        Fri, 18 Feb 2022 12:22:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5+YeizP40Y0PWstFb8RAq1h2np5VpvWL9X3s6WTurVg=; b=AdA+6fR/A00UPoUBFt4oapl7wn
        7wQUtuow7uevHvv6T9v6cpPfWc7Qd6th8zFr6Z4a/9RGqEdDHrzQyJ3uGyFRLNSFkAa1nwExfn1hN
        DPid8N5i2uHw1oA7UZL8iAWbWGij2DR8hymGUCjMaV6c9JwAN8mWUD7o9LM+8MYVW9ria3wVFIZAh
        GLYGeWOTEMT/4J8m8ynoTHrggKTN6K2McvutXhdSeR2b+xoj5AXC4wfVMbOujzH8RcH9zkbikIWGx
        6xGFDepj8ayA4rkg2h14KLE2TUVf/WwsIIf0DKXlJcHEBDM0Uv8Z18VERDwBdVlV0JQtEbgLyDKXc
        O/AZqTgw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nL9lt-00GuVb-CV; Fri, 18 Feb 2022 20:22:29 +0000
Date:   Fri, 18 Feb 2022 20:22:29 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 01/13] fs: Add flags parameter to
 __block_write_begin_int
Message-ID: <YhAABYQDsqSiU5pD@casper.infradead.org>
References: <20220218195739.585044-1-shr@fb.com>
 <20220218195739.585044-2-shr@fb.com>
 <Yg/6qDCDuCLGkYux@casper.infradead.org>
 <d6a89358-c43c-9576-91bd-d90db4d2aa42@fb.com>
 <Yg/9zKvlwkVJqj+p@casper.infradead.org>
 <5ac7e88d-76a9-9d8e-e3e5-58a89f48b0d5@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ac7e88d-76a9-9d8e-e3e5-58a89f48b0d5@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 18, 2022 at 12:14:50PM -0800, Stefan Roesch wrote:
> 
> 
> On 2/18/22 12:13 PM, Matthew Wilcox wrote:
> > On Fri, Feb 18, 2022 at 12:08:27PM -0800, Stefan Roesch wrote:
> >>
> >>
> >> On 2/18/22 11:59 AM, Matthew Wilcox wrote:
> >>> On Fri, Feb 18, 2022 at 11:57:27AM -0800, Stefan Roesch wrote:
> >>>> This adds a flags parameter to the __begin_write_begin_int() function.
> >>>> This allows to pass flags down the stack.
> >>>
> >>> Still no.
> >>
> >> Currently block_begin_write_cache is expecting an aop_flag. Are you asking to
> > 
> > There is no function by that name in Linus' tree.
> > 
> >> first have a patch that replaces the existing aop_flag parameter with the gfp_t?
> >> and then modify this patch to directly use gfp flags?
> 
> s/block_begin_write_cache/block_write_begin/

I don't think there's any need to change the arguments to
block_write_begin().  That's widely used and I don't think changing
all the users is worth it.  You don't seem to call it anywhere in this
patch set.

But having block_write_begin() translate the aop flags into gfp
and fgp flags, yes.  It can call pagecache_get_page() instead of
grab_cache_page_write_begin().  And then you don't need to change
grab_cache_page_write_begin() at all.
