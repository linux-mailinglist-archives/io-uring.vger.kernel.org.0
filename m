Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 176435285A2
	for <lists+io-uring@lfdr.de>; Mon, 16 May 2022 15:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239390AbiEPNkh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 May 2022 09:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243891AbiEPNkG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 May 2022 09:40:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94BB2F02C;
        Mon, 16 May 2022 06:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ag+kYhBHOWVHyefgJy+1K09AOBdX5dHXPtZQwUVHJuA=; b=sVKb5rfhrwztbNXlQsxaBDThEY
        Jd72MNm9Nb2HCQ6eFtQlQwOL0coIvmAbA17ffxPAYu5wIMRcnFqK/K34tD71axZPLWVKczUkIZTv+
        B7oZisAJTOwpCJWVaP756Ti8JeOX6+UrD1VJh4PvZMQpmlrmtaRB9U8AnDD9ZKHmolCFVVvo4LoVK
        rwxDgE3Z5tP2ERGFhOc4B1geKQgFCYbL6JlD24VmAmBRB5dT7qKcrSN/hDhrowvmVBwqS2tXmOEKp
        kvDZBgbczt5k8tKDo7qcr4exuG1oPIbIiUYcos3pPRdm4Fe2Qgm2KHHf8IcClRt+mXaWcmxRE5iIK
        NTv62z/g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nqawz-0080Wh-RC; Mon, 16 May 2022 13:39:53 +0000
Date:   Mon, 16 May 2022 06:39:53 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>, Stefan Roesch <shr@fb.com>,
        io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH v1 11/18] xfs: add async buffered write support
Message-ID: <YoJUKdV7p71fDO2Q@infradead.org>
References: <30f2920c-5262-7cb0-05b5-6e84a76162a7@fb.com>
 <20220428215442.GW1098723@dread.disaster.area>
 <19d411e5-fe1f-a3f8-36e0-87284a1c02f3@fb.com>
 <20220506092915.GI1098723@dread.disaster.area>
 <31f09969-2277-6692-b204-f884dc65348f@fb.com>
 <20220509232425.GQ1098723@dread.disaster.area>
 <20220509234424.GX27195@magnolia>
 <20220510011205.GR1098723@dread.disaster.area>
 <YnoKnyzqe3D70zoE@infradead.org>
 <20220516022430.GN1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516022430.GN1098723@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, May 16, 2022 at 12:24:30PM +1000, Dave Chinner wrote:
> Ok, so we can just use XFS_I(file_inode(iocb->ki_filp)) then and we
> don't need to pass the xfs_inode at all. We probably should convert
> the rest of the io path to do this as well so we don't end up
> forgetting this again...

Yes.
