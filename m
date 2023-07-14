Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E87AF753F3F
	for <lists+io-uring@lfdr.de>; Fri, 14 Jul 2023 17:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236090AbjGNPry (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Jul 2023 11:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236139AbjGNPru (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Jul 2023 11:47:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED0BA30F8;
        Fri, 14 Jul 2023 08:47:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8750C61D53;
        Fri, 14 Jul 2023 15:47:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B66C433C7;
        Fri, 14 Jul 2023 15:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689349669;
        bh=zFqlmjpsUpD+jmVpoeLIgKaEz5lAVss4HVnOntoEqqQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m7GjHJfH1Mk4J4pGHhjKC67W9RKCBexZJhPfF9tKMuI83eOxxqj1V6rwDDu6ba5pE
         9FoyW5Yz1b3DjoSTPdDCPI+iw/BcH1oRafGZOLQvkkP0C0HR0LTKpqhhSUkWkpxxRV
         I+8NnBmAlPWi/P55EhXkMVWNQb96dtwGLV0FCY5o7YaS2scTIiKLlFEWaq+lNl9Zo3
         KP9Od2ztH1bo4NnGWBI/VK4R4LtxQDiU1MUaNRc15XZ5tLHLeAFQhDgipPGaHaA1GM
         wTh2NS6yVx/NRkle4gD31WtyCHW2RhtmaUltblWcWuhQ+PBi37f6Kx6q0BgHxGiBSL
         AfDUF5t0Um3xw==
Date:   Fri, 14 Jul 2023 17:47:45 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Arnd Bergmann <arnd@arndb.de>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] io_uring: add IORING_OP_WAITID support
Message-ID: <20230714-grummeln-sitzgelegenheit-1157c2feac71@brauner>
References: <20230711204352.214086-1-axboe@kernel.dk>
 <20230711204352.214086-6-axboe@kernel.dk>
 <8431d207-5e52-4f8c-a12d-276836174bad@app.fastmail.com>
 <048cfbce-5238-2580-2d53-2ca740e72d79@kernel.dk>
 <bbc5f3cf-99f8-0695-1367-979301c64ecb@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bbc5f3cf-99f8-0695-1367-979301c64ecb@kernel.dk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 11, 2023 at 04:18:13PM -0600, Jens Axboe wrote:
> On 7/11/23 3:22 PM, Jens Axboe wrote:
> > On 7/11/23 3:11?PM, Arnd Bergmann wrote:
> >> On Tue, Jul 11, 2023, at 22:43, Jens Axboe wrote:
> >>> This adds support for an async version of waitid(2), in a fully async
> >>> version. If an event isn't immediately available, wait for a callback
> >>> to trigger a retry.
> >>>
> >>> The format of the sqe is as follows:
> >>>
> >>> sqe->len		The 'which', the idtype being queried/waited for.
> >>> sqe->fd			The 'pid' (or id) being waited for.
> >>> sqe->file_index		The 'options' being set.
> >>> sqe->addr2		A pointer to siginfo_t, if any, being filled in.
> >>>
> >>> buf_index, add3, and waitid_flags are reserved/unused for now.
> >>> waitid_flags will be used for options for this request type. One
> >>> interesting use case may be to add multi-shot support, so that the
> >>> request stays armed and posts a notification every time a monitored
> >>> process state change occurs.
> >>>
> >>> Note that this does not support rusage, on Arnd's recommendation.
> >>>
> >>> See the waitid(2) man page for details on the arguments.
> >>>
> >>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >>
> >> Does this require argument conversion for compat tasks?
> >>
> >> Even without the rusage argument, I think the siginfo
> >> remains incompatible with 32-bit tasks, unfortunately.
> > 
> > Hmm yes good point, if compat_siginfo and siginfo are different, then it
> > does need handling for that. Would be a trivial addition, I'll make that
> > change. Thanks Arnd!
> 
> Should be fixed in the current version:
> 
> https://git.kernel.dk/cgit/linux/commit/?h=io_uring-waitid&id=08f3dc9b7cedbd20c0f215f25c9a7814c6c601cc

In kernel/signal.c in pidfd_send_signal() we have
copy_siginfo_from_user_any() it seems that a similar version
copy_siginfo_to_user_any() might be something to consider. We do have
copy_siginfo_to_user32() and copy_siginfo_to_user(). But I may lack
context why this wouldn't work here.
