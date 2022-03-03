Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B412A4CC8ED
	for <lists+io-uring@lfdr.de>; Thu,  3 Mar 2022 23:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233329AbiCCWcW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Mar 2022 17:32:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233062AbiCCWcV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Mar 2022 17:32:21 -0500
X-Greylist: delayed 419 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 03 Mar 2022 14:31:35 PST
Received: from shells.gnugeneration.com (shells.gnugeneration.com [66.240.222.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F64512342E
        for <io-uring@vger.kernel.org>; Thu,  3 Mar 2022 14:31:35 -0800 (PST)
Received: by shells.gnugeneration.com (Postfix, from userid 1000)
        id 036C1C0249E; Thu,  3 Mar 2022 14:24:36 -0800 (PST)
Date:   Thu, 3 Mar 2022 14:24:35 -0800
From:   Vito Caputo <vcaputo@pengaru.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org, asml.silence@gmail.com
Subject: Re: [PATCH] io_uring: add io_uring_enter(2) fixed file support
Message-ID: <20220303222435.je5b66aqkc5ddm4u@shells.gnugeneration.com>
References: <20220303052811.31470-1-xiaoguang.wang@linux.alibaba.com>
 <4f197b0e-6066-b59e-aae0-2218e9c1b643@kernel.dk>
 <528ce414-c0fe-3318-483a-f51aa8a407b9@kernel.dk>
 <040e9262-4ebb-8505-5a14-6f399e40332c@kernel.dk>
 <951ea55c-b6a3-59e4-1011-4f46fae547b3@kernel.dk>
 <66bfc962-b983-e737-7c36-85784c52b7fa@kernel.dk>
 <8466f91e-416e-d53e-8c24-47a0b20412ac@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8466f91e-416e-d53e-8c24-47a0b20412ac@kernel.dk>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Mar 03, 2022 at 01:41:50PM -0700, Jens Axboe wrote:
> On 3/3/22 10:18 AM, Jens Axboe wrote:
> > On 3/3/22 9:31 AM, Jens Axboe wrote:
> >> On 3/3/22 7:40 AM, Jens Axboe wrote:
> >>> On 3/3/22 7:36 AM, Jens Axboe wrote:
> >>>> The only potential oddity here is that the fd passed back is not a
> >>>> legitimate fd. io_uring does support poll(2) on its file descriptor, so
> >>>> that could cause some confusion even if I don't think anyone actually
> >>>> does poll(2) on io_uring.
> >>>
> >>> Side note - the only implication here is that we then likely can't make
> >>> the optimized behavior the default, it has to be an IORING_SETUP_REG
> >>> flag which tells us that the application is aware of this limitation.
> >>> Though I guess close(2) might mess with that too... Hmm.
> >>
> >> Not sure I can find a good approach for that. Tried out your patch and
> >> made some fixes:
> >>
> >> - Missing free on final tctx free
> >> - Rename registered_files to registered_rings
> >> - Fix off-by-ones in checking max registration count
> >> - Use kcalloc
> >> - Rename ENTER_FIXED_FILE -> ENTER_REGISTERED_RING
> >> - Don't pass in tctx to io_uring_unreg_ringfd()
> >> - Get rid of forward declaration for adding tctx node
> >> - Get rid of extra file pointer in io_uring_enter()
> >> - Fix deadlock in io_ringfd_register()
> >> - Use io_uring_rsrc_update rather than add a new struct type
> > 
> > - Allow multiple register/unregister instead of enforcing just 1 at the
> >   time
> > - Check for it really being a ring fd when registering
> > 
> > For different batch counts, nice improvements are seen. Roughly:
> > 
> > Batch==1	15% faster
> > Batch==2	13% faster
> > Batch==4	11% faster
> > 
> > This is just in microbenchmarks where the fdget/fdput play a bigger
> > factor, but it will certainly help with real world situations where
> > batching is more limited than in benchmarks.
> 

Certainly seems worthwhile.

> In trying this out in applications, I think the better registration API
> is to allow io_uring to pick the offset. The application doesn't care,
> it's just a magic integer there. And if we allow io_uring to pick it,
> then that makes things a lot easier to deal with.
> 
> For registration, pass in an array of io_uring_rsrc_update structs, just
> filling in the ring_fd in the data field. Return value is number of ring
> fds registered, and up->offset now contains the chosen offset for each
> of them.
> 
> Unregister is the same struct, but just with offset filled in.
> 
> For applications using io_uring, which is all of them as far as I'm
> aware, we can also easily hide this. This means we can get the optimized
> behavior by default.
> 

Did you mean s/using io_uring/using liburing/ here?

Regards,
Vito Caputo
