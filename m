Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9AC95209AB
	for <lists+io-uring@lfdr.de>; Tue, 10 May 2022 01:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233562AbiEIXtF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 May 2022 19:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233622AbiEIXs1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 May 2022 19:48:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9E72631ED;
        Mon,  9 May 2022 16:44:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40DC6B81813;
        Mon,  9 May 2022 23:44:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0F2C385C2;
        Mon,  9 May 2022 23:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652139864;
        bh=HMCkkZVPva2XKldmuw596NTy01fyYAKF6NRBK0XvqEM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DNmOuSwyIWAZL5cg9HhCl+E97Nqe7qUZvtFLE/kLdtYq99hJ6MLc/VzxL49ib0FE1
         4khVVFRKwzzvYWwbxAvUzORdKlOnroxiJJ6Ex/XkMneNoUAo3SCaC2Z7zVXpjvoCNv
         KteA5jpx6g2bMM9r2OGD5JWjM5u7oOsdEj6i2gt/Ks1sKLim6UybBGygI609M4fr9M
         c5pILAL6iut1loltPFAg8uU3PPYK0BeLjWq3hhVz6r0a5HR809zzH3RWMOB/G5ljyY
         blfpd9TE+RJXvX7fMJOtqo2UM8VRJwOaNdtjbdr0WF4UXf53JeAohoJPKfYCET/XMK
         POXcJHquQNOug==
Date:   Mon, 9 May 2022 16:44:24 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        kernel-team@fb.com, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH v1 11/18] xfs: add async buffered write support
Message-ID: <20220509234424.GX27195@magnolia>
References: <20220426174335.4004987-1-shr@fb.com>
 <20220426174335.4004987-12-shr@fb.com>
 <20220426225652.GS1544202@dread.disaster.area>
 <30f2920c-5262-7cb0-05b5-6e84a76162a7@fb.com>
 <20220428215442.GW1098723@dread.disaster.area>
 <19d411e5-fe1f-a3f8-36e0-87284a1c02f3@fb.com>
 <20220506092915.GI1098723@dread.disaster.area>
 <31f09969-2277-6692-b204-f884dc65348f@fb.com>
 <20220509232425.GQ1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509232425.GQ1098723@dread.disaster.area>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, May 10, 2022 at 09:24:25AM +1000, Dave Chinner wrote:
> On Mon, May 09, 2022 at 12:32:59PM -0700, Stefan Roesch wrote:
> > On 5/6/22 2:29 AM, Dave Chinner wrote:
> > > On Mon, May 02, 2022 at 02:21:17PM -0700, Stefan Roesch wrote:
> > >> On 4/28/22 2:54 PM, Dave Chinner wrote:
> > >>> On Thu, Apr 28, 2022 at 12:58:59PM -0700, Stefan Roesch wrote:
> > >> - replace the pointer to iocb with pointer to xfs_inode in the function xfs_ilock_iocb()
> > >>   and also pass in the flags value as a parameter.
> > >> or
> > >> - create function xfs_ilock_inode(), which xfs_ilock_iocb() calls. The existing
> > >>   calls will not need to change, only the xfs_ilock in xfs_file_buffered_write()
> > >>   will use xfs_ilock_inode().
> > > 
> > > You're making this way more complex than it needs to be. As I said:
> > > 
> > >>> Regardless, if this is a problem, then just pass the XFS inode to
> > >>> xfs_ilock_iocb() and this is a moot point.
> > > 
> > 
> > The function xfs_ilock_iocb() is expecting a pointer to the data structure kiocb, not
> > a pointer to xfs_inode. I don't see how that's possible without changing the signature
> > of xfs_ilock_iocb().
> 
> For the *third time*: pass the xfs_inode to xfs_ilock_iocb() and
> update all the callers to do the same thing.

I still don't understand why /any/ of this is necessary.  When does
iocb->ki_filp->f_inode != iocb->ki_filp->f_mapping->host? 

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
