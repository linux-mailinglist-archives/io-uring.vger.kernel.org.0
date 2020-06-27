Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A6F20BF02
	for <lists+io-uring@lfdr.de>; Sat, 27 Jun 2020 08:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgF0Gvc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Jun 2020 02:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbgF0Gvc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 27 Jun 2020 02:51:32 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174FAC03E979;
        Fri, 26 Jun 2020 23:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cA+nDLk1cEiM+pjhFHWGJZnPhFcjX6nAKwC92ViSHuk=; b=cJU7Kmy1aduUvHoiPAo1vh16S7
        lN7xe3StQ5MB7txNrLcHuv3hHkuDTagybLIaCpnw8Cd20sXvqmhtn7mtrzf/gvfyY0eiFE6KwcAuY
        ZHkFfjSsqPIib22YZ3I6Sku5XtZZUkuaUmeoONil6pw4UF/Rp54mfPwGOO8qpuy1ZBcxDvosIZWdp
        oaImaF6BBRTmoiG6bcKYsNimillWYaBpua7CFYiYlPF5DHHKFfnu0UsxyHC5BWal8X61mhX7IujAP
        4L+3aIwbGMa710Zi58WPU63g8b/fBV2pMLPb9A+YQoSM12xTjGkmL5irlo0aT/Qc+S7PFsYUdbygF
        uLWb8Kew==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jp4g4-0005I8-2Z; Sat, 27 Jun 2020 06:51:04 +0000
Date:   Sat, 27 Jun 2020 07:51:04 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, bcrl@kvack.org, asml.silence@gmail.com,
        Damien.LeMoal@wdc.com, linux-fsdevel@vger.kernel.org,
        mb@lightnvm.io, linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        selvakuma.s1@samsung.com, nj.shetty@samsung.com,
        javier.gonz@samsung.com, Arnav Dawn <a.dawn@samsung.com>
Subject: Re: [PATCH v2 1/2] fs,block: Introduce RWF_ZONE_APPEND and handling
 in direct IO path
Message-ID: <20200627065104.GA20157@infradead.org>
References: <1593105349-19270-1-git-send-email-joshi.k@samsung.com>
 <CGME20200625171834epcas5p226a24dfcb84cfa83fe29a2bd17795d85@epcas5p2.samsung.com>
 <1593105349-19270-2-git-send-email-joshi.k@samsung.com>
 <20200626085846.GA24962@infradead.org>
 <20200626211514.GA24762@test-zns>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626211514.GA24762@test-zns>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Jun 27, 2020 at 02:45:14AM +0530, Kanchan Joshi wrote:
> For block IO path (which is the scope of this patchset) there is no
> probelm in using RWF_APPEND for zone-append, because it does not do
> anything for block device. We can use that, avoiding introduction of
> RWF_ZONE_APPEND in user-space.

No, you are not just touching the block I/O path.  This is all over the
general file code, and all RWF_* flag are about file I/O.
