Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306861FEBC8
	for <lists+io-uring@lfdr.de>; Thu, 18 Jun 2020 08:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgFRG4i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Jun 2020 02:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727010AbgFRG4h (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Jun 2020 02:56:37 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D6ACC06174E;
        Wed, 17 Jun 2020 23:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=uAvmk2CwDLs4X+Ko7ajFBaGyB0rcXPF4WnH3SQrYs4k=; b=iQ/jY6BwNU0GexOcII4Y8RmC90
        vslaU7EwpUIeDbH4l3fPejGtKiiupUxIiUtFiXf9OKFRfNWnG9EfupRM5LYyTyoqkQ4NaCxf+rQEx
        QpA0xyEbPpW6VGUiNbZPittAv+QRYNnNWsWAqedu0wTvaDrHGNzeST60Osvj66lkMXofncPReYaX4
        xFEqPz0Pl/FlgUEfYqpEGhHy0/hcdSLaJ9QIprhDs1/QkI8aerds64dV+fhAfvor9e/DUmYIX86+S
        TJC0Ps7C1qPcTVNwNM4UX+vYpk2ktc961oLqTiOI4ve7lfCJzRLxzGLqieBv7S/MYQVFHGZpIRreL
        YlLoGcYw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jloTS-00012N-So; Thu, 18 Jun 2020 06:56:34 +0000
Date:   Wed, 17 Jun 2020 23:56:34 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, viro@zeniv.linux.org.uk, bcrl@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, selvakuma.s1@samsung.com,
        nj.shetty@samsung.com, javier.gonz@samsung.com
Subject: Re: [PATCH 0/3] zone-append support in aio and io-uring
Message-ID: <20200618065634.GB24943@infradead.org>
References: <CGME20200617172653epcas5p488de50090415eb802e62acc0e23d8812@epcas5p4.samsung.com>
 <1592414619-5646-1-git-send-email-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1592414619-5646-1-git-send-email-joshi.k@samsung.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jun 17, 2020 at 10:53:36PM +0530, Kanchan Joshi wrote:
> This patchset enables issuing zone-append using aio and io-uring direct-io interface.
> 
> For aio, this introduces opcode IOCB_CMD_ZONE_APPEND. Application uses start LBA
> of the zone to issue append. On completion 'res2' field is used to return
> zone-relative offset.
> 
> For io-uring, this introduces three opcodes: IORING_OP_ZONE_APPEND/APPENDV/APPENDV_FIXED.
> Since io_uring does not have aio-like res2, cqe->flags are repurposed to return zone-relative offset

And what exactly are the semantics supposed to be?  Remember the
unix file abstractions does not know about zones at all.

I really don't think squeezing low-level not quite block storage
protocol details into the Linux read/write path is a good idea.

What could be a useful addition is a way for O_APPEND/RWF_APPEND writes
to report where they actually wrote, as that comes close to Zone Append
while still making sense at our usual abstraction level for file I/O.
