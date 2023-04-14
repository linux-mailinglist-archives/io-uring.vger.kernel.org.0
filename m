Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD7E36E271F
	for <lists+io-uring@lfdr.de>; Fri, 14 Apr 2023 17:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjDNPgQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Apr 2023 11:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjDNPgP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Apr 2023 11:36:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 787E855A1;
        Fri, 14 Apr 2023 08:36:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14B876160E;
        Fri, 14 Apr 2023 15:36:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E141C4339B;
        Fri, 14 Apr 2023 15:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681486573;
        bh=fQbshHMyenXjbLKMFET/GjpZqotL8SVaYFHwivrmZGc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EPOFVu/DuwyuZANHqHcIFm3updxEbeHUXzp/iRet476VBB6uNbMtHE1khP4Sh1gSE
         Q6Y694QdGbv5cpKGotEUfJRvJFmAmSEOCyaATRoC+Yokm5MNHTdT1IGLIy/xBIH5zi
         Stm+pAFlxwJkRhantTSMdg4sGEej5MG3L7DrM1oAQsogxP1WRzj6x/rfKNWXFN86I/
         JlS0RrvRFAaR3ouKEs+sy9hsqIIaceSojg+zNfCUkEJDRaAO3UdU6vlJzG7Qch+KvH
         wkp97f4xUGTIbmDQdTdWmg0VGlJsaciHwLK93XPh4PBN6K/LDYrQlWfmFnmq4/fqu+
         4Q2Wnj0bxfFeA==
Date:   Fri, 14 Apr 2023 08:36:12 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Bernd Schubert <bschubert@ddn.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        dsingh@ddn.com
Subject: Re: [PATCH 1/2] fs: add FMODE_DIO_PARALLEL_WRITE flag
Message-ID: <20230414153612.GB360881@frogsfrogsfrogs>
References: <20230307172015.54911-2-axboe@kernel.dk>
 <20230412134057.381941-1-bschubert@ddn.com>
 <CAJfpegt_ZCVodOhQCzF9OqKnCr65mKax0Gu4OTN8M51zP+8TcA@mail.gmail.com>
 <ZDjggMCGautPUDpW@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDjggMCGautPUDpW@infradead.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Apr 13, 2023 at 10:11:28PM -0700, Christoph Hellwig wrote:
> On Thu, Apr 13, 2023 at 09:40:29AM +0200, Miklos Szeredi wrote:
> > fuse_direct_write_iter():
> > 
> > bool exclusive_lock =
> >     !(ff->open_flags & FOPEN_PARALLEL_DIRECT_WRITES) ||
> >     iocb->ki_flags & IOCB_APPEND ||
> >     fuse_direct_write_extending_i_size(iocb, from);
> > 
> > If the write is size extending, then it will take the lock exclusive.
> > OTOH, I guess that it would be unusual for lots of  size extending
> > writes to be done in parallel.
> > 
> > What would be the effect of giving the  FMODE_DIO_PARALLEL_WRITE hint
> > and then still serializing the writes?
> 
> I have no idea how this flags work, but XFS also takes i_rwsem
> exclusively for appends, when the positions and size aren't aligned to
> the block size, and a few other cases.

IIUC uring wants to avoid the situation where someone sends 300 writes
to the same file, all of which end up in background workers, and all of
which then contend on exclusive i_rwsem.  Hence it has some hashing
scheme that executes io requests serially if they hash to the same value
(which iirc is the inode number?) to prevent resource waste.

This flag turns off that hashing behavior on the assumption that each of
those 300 writes won't serialize on the other 299 writes, hence it's ok
to start up 300 workers.

(apologies for precoffee garbled response)

--D
