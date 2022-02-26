Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDD924C5304
	for <lists+io-uring@lfdr.de>; Sat, 26 Feb 2022 02:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiBZBX0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Feb 2022 20:23:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbiBZBXZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Feb 2022 20:23:25 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D518188A27;
        Fri, 25 Feb 2022 17:22:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UqTxgPzBGNmtV0S9i6rlVD3vrlcZrRdHQzqIsmgvHcM=; b=2swJ+bn7Skt1EDGRL+PHwX6oEm
        2jzw801sexhJYLIcEaimPtyzuqcUi8bPmqWzagJGBJYCd9EJKuV0ijRL00Bg2D68uYL8o2TjKoT+9
        8uxEcUdrxFw48SHLFVXNAl5iso7c60Wg6upd19gZWIH9biOLqvqDMAgSgS98NQWNO9IDx1joMSu0l
        vVFVRzIPYUNKvj/BnoovIk9OeRFCWIyUFNdzQ2APT+ARcYIlOOgCIzzLIwieu3CoAFaWQKeB5VWdP
        lJMNkn1wW0pI4ndJaC5FjzxMrXz41OF1kAlLTPMFluqU1vcqtlpbDBhRd+9Dof6i1CmkPwfwh/A86
        M8ObOWDg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nNlnL-007JwR-4a; Sat, 26 Feb 2022 01:22:47 +0000
Date:   Fri, 25 Feb 2022 17:22:47 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Qian Cai <quic_qiancai@quicinc.com>, Jens Axboe <axboe@kernel.dk>
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>, kernel-team@fb.com,
        Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH v3 0/2] io-uring: Make statx api stable
Message-ID: <YhmA5xJi28CBdXH+@bombadil.infradead.org>
References: <20220215180328.2320199-1-shr@fb.com>
 <164555550976.110748.6933069169641927964.b4-ty@kernel.dk>
 <CGME20220224124715eucas1p2a7d1b7f2a5131ef1dd5b8280c1d3749b@eucas1p2.samsung.com>
 <5e0084b9-0090-c2a6-ab64-58fd1887d95f@samsung.com>
 <a906fc93-1295-f27c-b96a-32571039bf92@kernel.dk>
 <YhgwfHtP7ry83oUr@qian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhgwfHtP7ry83oUr@qian>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Feb 24, 2022 at 08:27:24PM -0500, Qian Cai wrote:
> On Thu, Feb 24, 2022 at 07:09:35AM -0700, Jens Axboe wrote:
> > > Freeing unused kernel image (initmem) memory: 1024K
> > > Run /sbin/init as init process
> > > systemd[1]: System time before build time, advancing clock.
> > > systemd[1]: Cannot be run in a chroot() environment.
> > > systemd[1]: Freezing execution.
> > > 
> > > Reverting them on top of next-20220223 fixes the boot issue. Btw, those 
> > > patches are not bisectable. The code at 
> > > 30512d54fae354a2359a740b75a1451b68aa3807 doesn't compile.
> > 
> > Thanks, I'll drop them from for-next until we figure out what that is.
> 
> FYI, this breaks the boot on bare-metal as well.

It also broke my boot on a simple debian testing KVM guest as well.
Reverting those two commits fixes my boot.

Jens, any chance we can include / ask for a bit more run time
testing? What sort of tests get run ?

  Luis
