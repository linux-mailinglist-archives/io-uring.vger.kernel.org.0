Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6D9532293
	for <lists+io-uring@lfdr.de>; Tue, 24 May 2022 07:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233748AbiEXFnJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 May 2022 01:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233496AbiEXFnI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 May 2022 01:43:08 -0400
X-Greylist: delayed 1627 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 23 May 2022 22:43:07 PDT
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBDF093981
        for <io-uring@vger.kernel.org>; Mon, 23 May 2022 22:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Xspr9q8wrCQ7j9SHJRfFWrr/gJIyMTnBbmdu+lbI3DE=; b=npe8XcGtbFzrIey6KxjzcJM/lN
        2KAayELHKWfk/kP5dk7mlufKZauN2T9sXvYPJVqW03nsWK53Pae+CC7GbyoPGyd7iZID629SJn0V3
        iTNvEzDwVtRD3xPIoy9A4FG2Ac0xeVGoz/yuetq+NmBACg1jgDLQB1E7op2H74jPshfEnY92L78lo
        KBWdiXcP0ijER4u6Z6ItKvPsV8u6AYWHzl0xqUJ2fAxbd2EGBlt3mBa103BHJ+dNPEdYC3MT1k2dX
        wjLA9WDG8xJlje54DFm/0vFmdY52Wet7sTTivbSwXV4+7s7JDYmoxt6FnaRu8m1w2fhmq7WnjAUfg
        B0beg3Fw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ntMti-006q39-Aj; Tue, 24 May 2022 05:15:58 +0000
Date:   Mon, 23 May 2022 22:15:58 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [GIT PULL] io_uring passthrough support
Message-ID: <YoxqDtk71JuyydDv@infradead.org>
References: <6f712c75-c849-ae89-d763-b2a18da52844@kernel.dk>
 <CAHk-=whfi3FE3O7KrziqPbyGvAmNFas3xxLz2O+ttzBkCOQmfw@mail.gmail.com>
 <caa5e85c-2bfe-b9e3-1e32-c11f78e6ad29@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <caa5e85c-2bfe-b9e3-1e32-c11f78e6ad29@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, May 23, 2022 at 02:19:38PM -0600, Jens Axboe wrote:
> We can obviously dump this as it isn't integral to anything, and
> honestly now that the NVMe is wired up, there's no great need to have a
> separate test for it. But it doesn't really hurt and there are already
> regression tests for it.

Yes, please dump it.  It is not actually useful and is just more
code around for no good reason.
