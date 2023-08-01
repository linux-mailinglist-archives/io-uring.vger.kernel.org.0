Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF9376A5B9
	for <lists+io-uring@lfdr.de>; Tue,  1 Aug 2023 02:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbjHAArz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Jul 2023 20:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjHAAry (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Jul 2023 20:47:54 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD272116;
        Mon, 31 Jul 2023 17:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JdZdYfH9Sqqb3oTstrTYwWa0TUTpdBVuYJoktWPnoKE=; b=BaZsjQ3q1NctuJkj/OvL42HX15
        2KGWN7mUpgailrix6+RSNsan/8fJ14pbvqX4vZgc+4/yBD6fE0KiIgDyqYUVnzd6JINU+bQxAB0no
        PFvVx0talBM0nASoxdUWv49Ej89gnvM9Xp29N0RBgkmTvwAMP1kFj5D6IW0uFrXnB8T9IpIRG+UHN
        oMQh//+SCGebOsd6tPQI9zxzCAHvvxIKGcbfudksidij6xIwxG9sP21icRzr6JAR7Gw9f88CaGZzs
        sFI9PPuV2dpiBfJcuWXH8jadP+VCoI+RqiEHupwSz7Dz0Ftic6yaS4rqSTH+zf6YptcMDa5pYVGsT
        dw4BiotA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qQdXv-004lPt-BA; Tue, 01 Aug 2023 00:47:31 +0000
Date:   Tue, 1 Aug 2023 01:47:31 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Dave Chinner <david@fromorbit.com>, Hao Xu <hao.xu@linux.dev>,
        io-uring@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH 3/5] io_uring: add support for getdents
Message-ID: <ZMhWI/2UIFAb3vR7@casper.infradead.org>
References: <20230718132112.461218-1-hao.xu@linux.dev>
 <20230718132112.461218-4-hao.xu@linux.dev>
 <20230726-leinen-basisarbeit-13ae322690ff@brauner>
 <e9ddc8cc-f567-46bc-8f82-cf5ff8ff6c95@linux.dev>
 <20230727-salbe-kurvigen-31b410c07bb9@brauner>
 <ZMcPUX0lYC2nscAm@dread.disaster.area>
 <20230731-gezeugt-tierwelt-f3d6a900c262@brauner>
 <20230731152623.GC11336@frogsfrogsfrogs>
 <22630618-40fc-5668-078d-6cefcb2e4962@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22630618-40fc-5668-078d-6cefcb2e4962@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jul 31, 2023 at 06:28:02PM -0600, Jens Axboe wrote:
> It's also not an absolute thing, like memory allocations are. It's
> perfectly fine to grab a mutex under NOWAIT issue. What you should not
> do is grab a mutex that someone else can grab while waiting on IO. This
> kind of extra context is only available in the code in question, not
> generically for eg mutex locking.

Is that information documented somewhere?  I didn't know that was the
rule, and I wouldn't be surprised if that's news to several of the other
people on this thread.
