Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3784768F15
	for <lists+io-uring@lfdr.de>; Mon, 31 Jul 2023 09:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjGaHlO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Jul 2023 03:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbjGaHlN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Jul 2023 03:41:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E569CDC;
        Mon, 31 Jul 2023 00:41:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EE6D60F40;
        Mon, 31 Jul 2023 07:41:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0503C433C8;
        Mon, 31 Jul 2023 07:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690789264;
        bh=N8xXDJhIqvl6gFtDtQlkTXSnFOUp5pK3mWMXr/11weY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Jr1uNHkLtZCsjH3HJ+2isbdKAE9neVgqV126e6gNrfJjAg0WF7Q3dB+6tFEGdlCnx
         8f6rQDtv0yqInmPSvawCNmdPwJTKnalobyqngRtmbUDiPFx/3dMY/izQrZjl2vzTDL
         elJJFt0cmzhn8h+VSLa1mG542l6PyQssZ1JcYzqcH1asYCmBOzkfVNumZJXj10295J
         F4C7PgIZhNsiU9qKZ4++sQpWaxILisvqobilsNP3lowfG6nTnjQAQ8m46glh5e5BvI
         w/1fOQ6+OKAleTmM2bQAjFs0SEiA1eaTzC1Ezhm0lwyp+rOj7RJOCRZ88JR0lFsNBc
         tpjP60mI/qIYA==
Date:   Mon, 31 Jul 2023 09:40:58 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, Hao Xu <hao.xu@linux.dev>,
        djwong@kernel.org, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        josef@toxicpanda.com
Subject: Re: [PATCH 3/5] io_uring: add support for getdents
Message-ID: <20230731-kooperativ-akquirieren-fd700d697cfd@brauner>
References: <20230718132112.461218-1-hao.xu@linux.dev>
 <20230718132112.461218-4-hao.xu@linux.dev>
 <20230726-leinen-basisarbeit-13ae322690ff@brauner>
 <e9ddc8cc-f567-46bc-8f82-cf5ff8ff6c95@linux.dev>
 <20230727-salbe-kurvigen-31b410c07bb9@brauner>
 <2785f009-2ebb-028d-8250-d5f3a30510f0@gmail.com>
 <20230727-westen-geldnot-63435c2f65ad@brauner>
 <77feb96e-adf7-56f2-dac5-ca5b075afa83@gmail.com>
 <20230727-daran-abtun-4bc755f668ad@brauner>
 <ZMcVWj9GfcHol3xG@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZMcVWj9GfcHol3xG@dread.disaster.area>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jul 31, 2023 at 11:58:50AM +1000, Dave Chinner wrote:
> On Thu, Jul 27, 2023 at 06:28:52PM +0200, Christian Brauner wrote:
> > On Thu, Jul 27, 2023 at 05:17:30PM +0100, Pavel Begunkov wrote:
> > > On 7/27/23 16:52, Christian Brauner wrote:
> > > > On Thu, Jul 27, 2023 at 04:12:12PM +0100, Pavel Begunkov wrote:
> > > > It would also solve it for writes which is what my kiocb_modified()
> > > > comment was about. So right now you have:
> > > 
> > > Great, I assumed there are stricter requirements for mtime not
> > > transiently failing.
> > 
> > But I mean then wouldn't this already be a problem today?
> > kiocb_modified() can error out with EAGAIN today:
> > 
> >           ret = inode_needs_update_time(inode, &now);
> >           if (ret <= 0)
> >                   return ret;
> >           if (flags & IOCB_NOWAIT)
> >                   return -EAGAIN;
> > 
> >           return __file_update_time(file, &now, ret);
> > 
> > the thing is that it doesn't matter for ->write_iter() - for xfs at
> > least - because xfs does it as part of preparatory checks before
> > actually doing any real work. The problem happens when you do actual
> > work and afterwards call kiocb_modified(). That's why I think (2) is
> > preferable.
> 
> This has nothing to do with what "XFS does". It's actually an
> IOCB_NOWAIT API design constraint.
> 
> That is, IOCB_NOWAIT means "complete the whole operation without
> blocking or return -EAGAIN having done nothing".  If we have to do
> something that might block (like a timestamp update) then we need to
> punt the entire operation before anything has been modified.  This
> requires all the "do we need to modify this" checks to be done up
> front before we start modifying anything.
> 
> So while it looks like this might be "an XFS thing", that's because
> XFS tends to be the first filesystem that most io_uring NOWAIT
> functionality is implemented on. IOWs, what you see is XFS is doing
> things the way IOCB_NOWAIT requires to be done. i.e. it's a
> demonstration of how nonblocking filesystem modification operations
> need to be run, not an "XFS thing"...

Yes, I'm aware. I was trying to pay xfs a compliment for that but
somehow that didn't come through.

> 
> > > > I would prefer 2) which seems cleaner to me. But I might miss why this
> > > > won't work. So input needed/wanted.
> > > 
> > > Maybe I didn't fully grasp the (2) idea
> > > 
> > > 2.1: all read_iter, write_iter, etc. callbacks should do file_accessed()
> > > before doing IO, which sounds like a good option if everyone agrees with
> > > that. Taking a look at direct block io, it's already like this.
> > 
> > Yes, that's what I'm talking about. I'm asking whether that's ok for xfs
> > maintainers basically. i_op->write_iter() already works like that since
> > the dawn of time but i_op->read_iter doesn't and I'm proposing to make
> > it work like that and wondering if there's any issues I'm unaware of.
> 
> XFS already calls file_accessed() in the DIO read path before the
> read gets issued. I don't see any problem with lifting it to before
> the copy-out loop in filemap_read() because it is run regardless of
> whether any data is read or any error occurred.  Hence it just
> doesn't look like it matters if it is run before or after the
> copy-out loop to me....

Great.
