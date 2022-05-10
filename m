Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4A2D520E08
	for <lists+io-uring@lfdr.de>; Tue, 10 May 2022 08:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237319AbiEJGwB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 May 2022 02:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237316AbiEJGwA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 May 2022 02:52:00 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159AC24DC6E;
        Mon,  9 May 2022 23:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hSOy7qsmVu3PqugjLk/Ti9DKDnpY0bkOOlrS22BpeSQ=; b=Ei0kSog1Hutzu9lHEsIUI6Xylk
        RdQyvqMN9IoS+J81JaK063GFA4StvRa6GL3KWcnid3qcm0X+egQhkjmAS/d7JW5VsqVRvf3FNOJlb
        wvUpwkfWtpS0kBJ1rntxvhyWQWEu2OiI9vhoMzEwZUHm2d6CmlBSTw4G16xe7nFceoARw4mNtBucH
        +rTGH1kg25iL6OU2PE6F34QTeDS1jB2SD9Mg65NSQKbRj0JVTLMMP1NvBPepfOimQxLVVN21y2Vs3
        e9Sqund1zEwOiJ+JU8tycN01aXeq1stmRi40hWtNsjtcF0ZAvu8T84pOX2bX4eX/82doI5Xa9qvrc
        4oDDS+KA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1noJf5-000DcC-OM; Tue, 10 May 2022 06:47:59 +0000
Date:   Mon, 9 May 2022 23:47:59 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, Stefan Roesch <shr@fb.com>,
        io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH v1 11/18] xfs: add async buffered write support
Message-ID: <YnoKnyzqe3D70zoE@infradead.org>
References: <20220426174335.4004987-12-shr@fb.com>
 <20220426225652.GS1544202@dread.disaster.area>
 <30f2920c-5262-7cb0-05b5-6e84a76162a7@fb.com>
 <20220428215442.GW1098723@dread.disaster.area>
 <19d411e5-fe1f-a3f8-36e0-87284a1c02f3@fb.com>
 <20220506092915.GI1098723@dread.disaster.area>
 <31f09969-2277-6692-b204-f884dc65348f@fb.com>
 <20220509232425.GQ1098723@dread.disaster.area>
 <20220509234424.GX27195@magnolia>
 <20220510011205.GR1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510011205.GR1098723@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, May 10, 2022 at 11:12:05AM +1000, Dave Chinner wrote:
> > I still don't understand why /any/ of this is necessary.  When does
> > iocb->ki_filp->f_inode != iocb->ki_filp->f_mapping->host? 
> 
> I already asked that question because I don't know the answer,
> either. I suspect the answer is "block dev inodes" but that then
> just raises the question of "how do we get them here?" and I don't
> know the answer to that, either. I don't have the time to dig into
> this and I don't expect anyone to just pop up with an answer,
> either. So in the mean time, we can just ignore it for the purpose
> of this patch set...

Weird device nodes (including block device) is the answer.  It never
happens for a normal file system file struct that we'd see in XFS.
