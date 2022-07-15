Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2670657670B
	for <lists+io-uring@lfdr.de>; Fri, 15 Jul 2022 21:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbiGOTCm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jul 2022 15:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiGOTCl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jul 2022 15:02:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F79F501A5;
        Fri, 15 Jul 2022 12:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jujfwG01dI+nm2T9PWfBuPM/ZuQZ4xaHDU/3x3esj7k=; b=vshOETTLB/053qWcYEpRjl1hLU
        btE+kOnXwV4W9dUiiMvLCrbAZAElTJXt5jVfg+IutzKO1cyip9ng1YfymUZ/5k36CU78ZV5kc3j8C
        fMQgXx/wFdRQ6EIyqjyHYBHAjxPR+sVAPbhARME3knMhuiZPWA6YIvGpXSihfBaXRuQN34HPqPgnJ
        Cu5JmTlZt3zltSMdmB4w+waspWOZe5YuplQ7nstXHO0quGTIM4f7jBLV2I5izohnKmmZEwQ0xRm+N
        JXw9qrxQjyEk3SaPLv++O3drVwz30VT8/XcNu6NSj4JHLEP2nZ70xQqyjcgsnwQy3yPuod3q83jgR
        zkrQmPCA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oCQaD-009bAK-9g; Fri, 15 Jul 2022 19:02:37 +0000
Date:   Fri, 15 Jul 2022 12:02:37 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Paul Moore <paul@paul-moore.com>
Cc:     casey@schaufler-ca.com, axboe@kernel.dk, joshi.k@samsung.com,
        linux-security-module@vger.kernel.org, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        a.manzanares@samsung.com, javier@javigon.com
Subject: Re: [PATCH] lsm,io_uring: add LSM hooks to for the new uring_cmd
 file op
Message-ID: <YtG5zRPFV967/y0v@bombadil.infradead.org>
References: <20220714000536.2250531-1-mcgrof@kernel.org>
 <CAHC9VhSjfrMtqy_6+=_=VaCsJKbKU1oj6TKghkue9LrLzO_++w@mail.gmail.com>
 <YtC8Hg1mjL+0mjfl@bombadil.infradead.org>
 <CAHC9VhQMABYKRqZmJQtXai0gtiueU42ENvSUH929=pF6tP9xOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhQMABYKRqZmJQtXai0gtiueU42ENvSUH929=pF6tP9xOg@mail.gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 15, 2022 at 02:46:16PM -0400, Paul Moore wrote:
> It looks like I owe you an apology, Luis.  While my frustration over
> io_uring remains, along with my disappointment that the io_uring
> developers continue to avoid discussing access controls with the LSM
> community, you are not the author of the IORING_OP_URING_CMD.   You
> are simply trying to do the right thing by adding the necessary LSM
> controls and in my confusion I likely caused you a bit of frustration;
> I'm sorry for that.

No frustration caused, I get it.

> Well, we're at -rc6 right now which means IORING_OP_URING_CMD is
> happening and it's unlikely the LSM folks are going to be able to
> influence the design/implementation much at this point so we have to
> do the best we can.  Given the existing constraints, I think your
> patch is reasonable (although please do shift the hook call site down
> a bit as discussed above), we just need to develop the LSM
> implementations to go along with it.
> 
> Luis, can you respin and resend the patch with the requested changes?

Sure thing.

> I also think we should mark the patches with a 'Fixes:' line that
> points at the IORING_OP_URING_CMD commit, ee692a21e9bf ("fs,io_uring:
> add infrastructure for uring-cmd").

I'll do that.

  Luis
