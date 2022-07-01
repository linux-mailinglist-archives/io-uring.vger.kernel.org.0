Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED33562A95
	for <lists+io-uring@lfdr.de>; Fri,  1 Jul 2022 06:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiGAEjW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Jul 2022 00:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiGAEjV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Jul 2022 00:39:21 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445D05A45F;
        Thu, 30 Jun 2022 21:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cq3htZEYFFtvd/u6WrlIkpab3k8hY7kkRHjqsyHHRwE=; b=F+6XPA3sXvJ6qA3XYsUoG5XpNm
        BnfDYsGkWnlDAWIfyOf+7tYZAoN5vRvPgpWChAGNnAm+m9IELpO0WqAdpu0NugGe18NZkD7RZyxrh
        /G4eM3oZJ8mOiAUOuEJaDsc9mf6TZ2R/Z8+t9vnv+kTEZCXiKrxFl96M7+167qk6gqyv9QN1GFtNz
        co30vlwoW5Oilr5odA3whFFJyEdnwGsfSvSwrZ9FzTuaYMI8TRw8V00xvu2ugcPqjCRGnfW728PDQ
        HCLRlTZCX499t+H+tGJsrfZh2b4rVL4x5J5aQtGZlQj8hNPVm+NtRYWMZOoJ4jo8QNY7ldfR9zTl1
        4LgupzVA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.95 #2 (Red Hat Linux))
        id 1o78R0-006npC-26;
        Fri, 01 Jul 2022 04:39:14 +0000
Date:   Fri, 1 Jul 2022 05:39:14 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        axboe@kernel.dk, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v7 15/15] xfs: Add async buffered write support
Message-ID: <Yr56ci/IZmN0S9J6@ZenIV>
References: <20220601210141.3773402-1-shr@fb.com>
 <20220601210141.3773402-16-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601210141.3773402-16-shr@fb.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jun 01, 2022 at 02:01:41PM -0700, Stefan Roesch wrote:
> This adds the async buffered write support to XFS. For async buffered
> write requests, the request will return -EAGAIN if the ilock cannot be
> obtained immediately.

breaks generic/471...
