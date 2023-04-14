Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE1D6E1B7C
	for <lists+io-uring@lfdr.de>; Fri, 14 Apr 2023 07:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjDNFLf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Apr 2023 01:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjDNFLc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Apr 2023 01:11:32 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067D440C0;
        Thu, 13 Apr 2023 22:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WNOpNMH/eVLZcNAlnGp7soNPe+TQ073CyBzF+5FM2Ds=; b=K0qBJEdDeP8bxy0/G8rBpyKSSg
        xp0T/wvagY9TVPFgsUvWcAz+bmk5DHUusDpNl1DxzquVfg2R+5bV7o24jjVsT5h9JqagvZWLBK9Sp
        KxlO4JJOZfO8AxZrHpuNjEQaLZHjrNQvj76TnQ0gPUMFyMHP5yZthzbs2/XPlW1a0yiKgAPrak9oX
        fgTuEH2nmivhPfks5SoR+ZGTaD3SgXEDu+f0cjd1MbGeMCZUQo7M7vkFFpxWrUVG82sy5rsZsxOAb
        eg3Otbqk3VqZvHuog9uT6uGBc2ZVQB6meB5n312fEo/ivl74F2a68RcayscAlTlJLd+euMKFsTp3k
        05BT889Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pnBia-008KcZ-0w;
        Fri, 14 Apr 2023 05:11:28 +0000
Date:   Thu, 13 Apr 2023 22:11:28 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Bernd Schubert <bschubert@ddn.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        dsingh@ddn.com
Subject: Re: [PATCH 1/2] fs: add FMODE_DIO_PARALLEL_WRITE flag
Message-ID: <ZDjggMCGautPUDpW@infradead.org>
References: <20230307172015.54911-2-axboe@kernel.dk>
 <20230412134057.381941-1-bschubert@ddn.com>
 <CAJfpegt_ZCVodOhQCzF9OqKnCr65mKax0Gu4OTN8M51zP+8TcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegt_ZCVodOhQCzF9OqKnCr65mKax0Gu4OTN8M51zP+8TcA@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Apr 13, 2023 at 09:40:29AM +0200, Miklos Szeredi wrote:
> fuse_direct_write_iter():
> 
> bool exclusive_lock =
>     !(ff->open_flags & FOPEN_PARALLEL_DIRECT_WRITES) ||
>     iocb->ki_flags & IOCB_APPEND ||
>     fuse_direct_write_extending_i_size(iocb, from);
> 
> If the write is size extending, then it will take the lock exclusive.
> OTOH, I guess that it would be unusual for lots of  size extending
> writes to be done in parallel.
> 
> What would be the effect of giving the  FMODE_DIO_PARALLEL_WRITE hint
> and then still serializing the writes?

I have no idea how this flags work, but XFS also takes i_rwsem
exclusively for appends, when the positions and size aren't aligned to
the block size, and a few other cases.
