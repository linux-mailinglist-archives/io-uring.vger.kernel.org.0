Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4004C76A9A7
	for <lists+io-uring@lfdr.de>; Tue,  1 Aug 2023 09:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbjHAHCB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Aug 2023 03:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbjHAHBg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Aug 2023 03:01:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A3B2D55;
        Tue,  1 Aug 2023 00:01:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6000C614AB;
        Tue,  1 Aug 2023 07:01:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01D0C433CD;
        Tue,  1 Aug 2023 07:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690873261;
        bh=J5UXSRgvzz2O/7rYusodi0lZCdJOd1yy2tVOlshX6/c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RkkkJz46ZlRpy6I5pOzXtf1jdC1uGoGKp53y8Xfp1Znopcf6LFVPs1hS1KR4h+ZkH
         Nre+xWPcfhrgckNbxhIOJlIT3bEDmbWnsgm549rUeZVN7WsXbHUGJT1AnHjYp/2Riq
         vDKndXvyQ3V49yEa+9St7SC+4xirMmPdzF4BwXSPFTTJZYsdwuJb+zVYVqlv4awr5O
         wnlhn2KOKWWRcM1NWrItzxZpotSHkrGJ1R8l5/GO4QDruGWo9tfD1NNhvsMzHpUw1U
         EggO9CLGm0Y9BC9d9G938hCB3ktkq6ze7YwMJNcFGZsMnO+JotkoWaAmfmPCZ4jHcb
         nTUlcNgljzyDw==
Date:   Tue, 1 Aug 2023 09:00:56 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>, Hao Xu <hao.xu@linux.dev>,
        io-uring@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH 3/5] io_uring: add support for getdents
Message-ID: <20230801-ziehharmonika-infostand-16a69319d15b@brauner>
References: <20230726-leinen-basisarbeit-13ae322690ff@brauner>
 <e9ddc8cc-f567-46bc-8f82-cf5ff8ff6c95@linux.dev>
 <20230727-salbe-kurvigen-31b410c07bb9@brauner>
 <ZMcPUX0lYC2nscAm@dread.disaster.area>
 <20230731-gezeugt-tierwelt-f3d6a900c262@brauner>
 <20230731152623.GC11336@frogsfrogsfrogs>
 <22630618-40fc-5668-078d-6cefcb2e4962@kernel.dk>
 <ZMhWI/2UIFAb3vR7@casper.infradead.org>
 <e2d8e5f1-f794-38eb-cecf-ed30c571206b@kernel.dk>
 <ZMhZh2EYPMH1wIXX@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZMhZh2EYPMH1wIXX@casper.infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 01, 2023 at 02:01:59AM +0100, Matthew Wilcox wrote:
> On Mon, Jul 31, 2023 at 06:49:45PM -0600, Jens Axboe wrote:
> > On 7/31/23 6:47?PM, Matthew Wilcox wrote:
> > > On Mon, Jul 31, 2023 at 06:28:02PM -0600, Jens Axboe wrote:
> > >> It's also not an absolute thing, like memory allocations are. It's
> > >> perfectly fine to grab a mutex under NOWAIT issue. What you should not
> > >> do is grab a mutex that someone else can grab while waiting on IO. This
> > >> kind of extra context is only available in the code in question, not
> > >> generically for eg mutex locking.
> > > 
> > > Is that information documented somewhere?  I didn't know that was the
> > > rule, and I wouldn't be surprised if that's news to several of the other
> > > people on this thread.
> > 
> > I've mentioned it in various threads, but would probably be good to
> > write down somewhere if that actually makes more people see it. I'm
> > dubious, but since it applies to NOWAIT in general, would be a good
> > thing to do regardless. And then at least I could point to that rather
> > than have to write up a long description every time.
> 
> Would be good to include whether it's OK to wait on a mutex that's held
> by another thread that's allocating memory without __GFP_NOFS (since
> obviously that can block on I/O)

And adding a few illustrative examples would be helpful.
