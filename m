Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 532B855549C
	for <lists+io-uring@lfdr.de>; Wed, 22 Jun 2022 21:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240412AbiFVTfr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jun 2022 15:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbiFVTfr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jun 2022 15:35:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F78FF32;
        Wed, 22 Jun 2022 12:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=11ZK0h9dNKq+tn7saPYTFwpIx/UcfWFs81TAdiQjTFg=; b=nWj4948F9YU/anh3+BcfKcXNcA
        BQY+KIzRASbQxyi7n1yn+hvd96ilXmbYal//kHeHYObd35mjQGgocxFOpeI+6MFbS7CqwRbT1nNjS
        gFzLTiV3noAgcsw+znTMsqEsXMEzolz99g3PuEvxcFYm1p0JpNj8HOKaaU6nSywjiV+/GlEH/lTrI
        XUb/odC7SVEu+3YU4tFm4eIptfWCC5hsjMr5nP0I8Ex2tTMUPacG6rcC9qz0zDqSP+Km2cWo0IbJ/
        9WPmwczKEjXeSi4EDpMaQgFDyTUKy3Wvi4LOjXJkqoF3mVMexkgNqeCsIj7LyTbXjBwKAybDSNwnO
        abkV4gSw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o468W-007GLI-Po; Wed, 22 Jun 2022 19:35:36 +0000
Date:   Wed, 22 Jun 2022 20:35:36 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        kernel-team@fb.com, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, david@fromorbit.com, jack@suse.cz,
        hch@infradead.org
Subject: Re: [PATCH v9 00/14] io-uring/xfs: support async buffered writes
Message-ID: <YrNvCGmBcqS80kNG@casper.infradead.org>
References: <20220616212221.2024518-1-shr@fb.com>
 <d18ffe14-7dd2-92a7-abd0-673b7da62adb@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d18ffe14-7dd2-92a7-abd0-673b7da62adb@kernel.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jun 22, 2022 at 11:41:14AM -0600, Jens Axboe wrote:
> Top posting - are people fine with queueing this up at this point? Will
> need a bit of massaging for io_uring as certain things moved to another
> file, but it's really minor. I'd do a separate topic branch for this.

I haven't had time to review this version, and I'm not likely to have
time before July 4th.
