Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C380276A998
	for <lists+io-uring@lfdr.de>; Tue,  1 Aug 2023 08:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbjHAG76 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Aug 2023 02:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbjHAG75 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Aug 2023 02:59:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B74E40;
        Mon, 31 Jul 2023 23:59:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8946C6149D;
        Tue,  1 Aug 2023 06:59:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC64C43395;
        Tue,  1 Aug 2023 06:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690873194;
        bh=/gQvjODYvLMqUy07t7y8PCmPc8B1DqCFqK3+xM+p1bI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RIUbWtDy4AuTnbjTy4OSkNJ2XS+5NTXtNgFxUb7YzKNQiOpwRNjMOEEfpGdnALNJs
         bfXghMsCRLxllIEcz7Lq9FJHD/k2t3FpIxFlMjnmmax3B9RRLo8OGcdNAuUo3MqQOQ
         2tKqnI3xp32Iw4E/7OsaD2wF8ZY4EpSS6FDN4c1LAO4eGqeqSZnB0N8bNzJatTqZjE
         wid2Dr+EutAY4ZKsPhM/DA9fOsf8yVrS2LUN7LYA/+NHl5VTXYo2ylap8ZjeKMVVQV
         kOQQ3Ffq21ymhkExgB0c9xl50X5wTFLk6JuSyAQoGVONI6bvulrLjfp3tAoTkmtakU
         7wpQyXiDtuRag==
Date:   Tue, 1 Aug 2023 08:59:49 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Matthew Wilcox <willy@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>, Hao Xu <hao.xu@linux.dev>,
        io-uring@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH 3/5] io_uring: add support for getdents
Message-ID: <20230801-transpirieren-hallo-94682f16962f@brauner>
References: <20230718132112.461218-4-hao.xu@linux.dev>
 <20230726-leinen-basisarbeit-13ae322690ff@brauner>
 <e9ddc8cc-f567-46bc-8f82-cf5ff8ff6c95@linux.dev>
 <20230727-salbe-kurvigen-31b410c07bb9@brauner>
 <ZMcPUX0lYC2nscAm@dread.disaster.area>
 <20230731-gezeugt-tierwelt-f3d6a900c262@brauner>
 <20230731152623.GC11336@frogsfrogsfrogs>
 <22630618-40fc-5668-078d-6cefcb2e4962@kernel.dk>
 <ZMhWI/2UIFAb3vR7@casper.infradead.org>
 <e2d8e5f1-f794-38eb-cecf-ed30c571206b@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e2d8e5f1-f794-38eb-cecf-ed30c571206b@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jul 31, 2023 at 06:49:45PM -0600, Jens Axboe wrote:
> On 7/31/23 6:47?PM, Matthew Wilcox wrote:
> > On Mon, Jul 31, 2023 at 06:28:02PM -0600, Jens Axboe wrote:
> >> It's also not an absolute thing, like memory allocations are. It's
> >> perfectly fine to grab a mutex under NOWAIT issue. What you should not
> >> do is grab a mutex that someone else can grab while waiting on IO. This
> >> kind of extra context is only available in the code in question, not
> >> generically for eg mutex locking.
> > 
> > Is that information documented somewhere?  I didn't know that was the
> > rule, and I wouldn't be surprised if that's news to several of the other
> > people on this thread.
> 
> I've mentioned it in various threads, but would probably be good to
> write down somewhere if that actually makes more people see it. I'm
> dubious, but since it applies to NOWAIT in general, would be a good
> thing to do regardless. And then at least I could point to that rather
> than have to write up a long description every time.

I've only been aware of this because we talked about it somewhere else.
So adding it as documentation would be great.
