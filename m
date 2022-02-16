Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6E24B904C
	for <lists+io-uring@lfdr.de>; Wed, 16 Feb 2022 19:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237636AbiBPSfX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Feb 2022 13:35:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237459AbiBPSfX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Feb 2022 13:35:23 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CBA2AB523;
        Wed, 16 Feb 2022 10:35:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0I4CUBXoLuJADzXOuu5zc7t0Qfn2X3v9vaJASke2DFs=; b=s2y6gWRyvz8QKmVHfLOc2TONl9
        m0uE3rLxXxTLxMJ2ff6nDoIhCurNABcoCioUs29B1F512I9KXftmIl/uwPAQeCk+I6BppI7KSPSiE
        apw6Q3BcVOcZdflOg3hGk3eNQDpqjP0+wObVLd4WQrKSb2nc1Dgo0Gz1+hheNNZG2XoaB8Hga5gUO
        KtM7piHMNGLc0wtkN6N4aZjxlsr8CJTk4DwpehN0v6HWZhqfxZxObSL/0d3EShnzMp9zmgd0Q/g0c
        NcMTjQ2bOdwQ/WJT7BeLD4jLseHAXdW+13juMuORbmO3tHPjlN9THQIKIJD4HRYW5IgpR5Dm0kCd+
        iU2rQy6A==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nKP8u-00EwxQ-S4; Wed, 16 Feb 2022 18:35:08 +0000
Date:   Wed, 16 Feb 2022 18:35:08 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v1 01/14] fs: Add flags parameter to
 __block_write_begin_int
Message-ID: <Yg1D3HjzGaTOz5YD@casper.infradead.org>
References: <20220214174403.4147994-1-shr@fb.com>
 <20220214174403.4147994-2-shr@fb.com>
 <YgqnYYRZKGMQK7N/@casper.infradead.org>
 <ff6b5c97-c74b-1984-818d-339555fed94b@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff6b5c97-c74b-1984-818d-339555fed94b@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Feb 16, 2022 at 10:31:18AM -0800, Stefan Roesch wrote:
> I don't think that gfp flags are a great fit here. We only want to pass in
> a nowait flag and this does not map nicely to a gfp flag. 
> 
> Instead of passing in a flag parameter we can also pass in a bool parameter,
> however that has its limitations as it can't be extended in the future.

if you're just going to copy and paste this inanity into every reply
to me, let's just say hard NAK to every patch from you for now on?
