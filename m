Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 406036E3545
	for <lists+io-uring@lfdr.de>; Sun, 16 Apr 2023 07:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbjDPFyz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 Apr 2023 01:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjDPFyy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 Apr 2023 01:54:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E26D2D52;
        Sat, 15 Apr 2023 22:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=TBtcpsXHeVpbPsSte8uqDCd7VMaCKEQiVcvyKRXX7Mg=; b=j5v+Vx78d62tZwWrCr9W+wLTGy
        ixFBl82hsUDRTvJYcHKmSVUrCIZXu4pJnyZpGCAs+aGltHNkeQjmqsI28wEXJIgjcDRkNPZsiCzLN
        LnXDLXTDebBnKZiioBEQFGH91J6VmcwjrxW/MxOeWHjZmnXT0zZbtgjJNVBUmEspvJl2lW1hCVTUp
        bPigqFbqljbFRaIob6Vlv5z2V64V4Qi2SulnmMxlKZhAJouRSidC6BLVTJRbuHKtWwcsecBwkaqhx
        97UuwsuzGG8b2w4rPlA/F9IQDZttleOaGKh+YoGncGeVIarSxQNrFnATN3gNEws+Ry2vmCf7IvXKC
        zSz3s3Zg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pnvLd-00DBwW-26;
        Sun, 16 Apr 2023 05:54:49 +0000
Date:   Sat, 15 Apr 2023 22:54:49 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Bernd Schubert <bschubert@ddn.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        dsingh@ddn.com
Subject: Re: [PATCH 1/2] fs: add FMODE_DIO_PARALLEL_WRITE flag
Message-ID: <ZDuNqQgpHUw+gi9G@infradead.org>
References: <20230307172015.54911-2-axboe@kernel.dk>
 <20230412134057.381941-1-bschubert@ddn.com>
 <CAJfpegt_ZCVodOhQCzF9OqKnCr65mKax0Gu4OTN8M51zP+8TcA@mail.gmail.com>
 <ZDjggMCGautPUDpW@infradead.org>
 <20230414153612.GB360881@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414153612.GB360881@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Apr 14, 2023 at 08:36:12AM -0700, Darrick J. Wong wrote:
> IIUC uring wants to avoid the situation where someone sends 300 writes
> to the same file, all of which end up in background workers, and all of
> which then contend on exclusive i_rwsem.  Hence it has some hashing
> scheme that executes io requests serially if they hash to the same value
> (which iirc is the inode number?) to prevent resource waste.
> 
> This flag turns off that hashing behavior on the assumption that each of
> those 300 writes won't serialize on the other 299 writes, hence it's ok
> to start up 300 workers.
> 
> (apologies for precoffee garbled response)

It might be useful if someone (Jens?) could clearly document the
assumptions for this flag.
