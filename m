Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4C64BF359
	for <lists+io-uring@lfdr.de>; Tue, 22 Feb 2022 09:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbiBVITF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Feb 2022 03:19:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiBVITD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Feb 2022 03:19:03 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E99151361;
        Tue, 22 Feb 2022 00:18:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ERrGWV41uBVaXwzdfcMvPwmnT3Ef4CTpHhjDrOBmFLM=; b=BLBZOoBHmq/L/nsjEbWMihR/ZW
        Iey63mNTKVkTFPUYnAFVSMuDWGl3OojJrYZ4cZpgkXV6zrX/zn0joCs9Okw9EXwuZqODVnnv8T19I
        4dJkEDeyR+22/cSHJAGlpWkElzFnG5cZ/UVzFgUybJSi2mOCzhp85RbKfrPqc2TgelaGpHJta5ANP
        JRyBgNlbj5VDXJlz9ncSpm4zpRYFSmeY6cwl2fJWOM7RqeUCGOwnYidSoqk2IZUbZ1kCSYPzKTBPY
        M5RFDNe66pXjzaiJEe3mKohG7diLdoUcgr7SInZAvWw5INysW90EQSYGGzXXFxa5ImLH98AJDGhzE
        IjEl/XWg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nMQNX-008UHR-Tt; Tue, 22 Feb 2022 08:18:35 +0000
Date:   Tue, 22 Feb 2022 00:18:35 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@infradead.org>, Stefan Roesch <shr@fb.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 04/13] fs: split off __alloc_page_buffers function
Message-ID: <YhScWzgGVyeaufvU@infradead.org>
References: <20220218195739.585044-1-shr@fb.com>
 <20220218195739.585044-5-shr@fb.com>
 <YhCdruAyTmLyVp8z@infradead.org>
 <YhHCVnTYNPrtbu08@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhHCVnTYNPrtbu08@casper.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Feb 20, 2022 at 04:23:50AM +0000, Matthew Wilcox wrote:
> On Fri, Feb 18, 2022 at 11:35:10PM -0800, Christoph Hellwig wrote:
> > Err, hell no.  Please do not add any new functionality to the legacy
> > buffer head code.  If you want new features do that on the
> > non-bufferhead iomap code path only please.
> 
> I think "first convert the block device code from buffer_heads to iomap"
> might be a bit much of a prerequisite.  I think running ext4 on top of a
> block device still requires buffer_heads, for example (I tried to convert
> the block device to use mpage in order to avoid creating buffer_heads
> when possible, and ext4 stopped working.  I didn't try too hard to debug
> it as it was a bit of a distraction at the time).

Oh, I did not spot the users here is the block device.  Which is really
weird, why would anyone do buffered writes to a block devices?  Doing
so is a bit of a data integrity nightmare.

Can we please develop this feature for iomap based file systems first,
and if by then a use case for block devices arises I'll see what we can
do there.  I've been planning to get the block device code to stop using
buffer_heads by default, but taking them into account if used by a
legacy buffer_head user anyway.
