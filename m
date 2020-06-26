Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB46320AE9E
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2020 10:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbgFZI7L (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Jun 2020 04:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbgFZI7L (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Jun 2020 04:59:11 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22962C08C5C1;
        Fri, 26 Jun 2020 01:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gW+E1Jv1j6enHoS9ci8iskFSPJ2rZo4CjUglSeffP7o=; b=ec0yT0jWfXYNE/yB3dPz5baX8B
        7smSzXLFiuj9f0Ed4NKLekPpMe3/SiPIJja5Dct7nl3HgWRYIQXNMnHS6dpZPVOyL5xaG5iCqF9X0
        CL3mCgMIilh6uQny45ec0cTru4ix75kp0Y/VoGHgARCzk12v4eRECmaoJuAJIQD0/Tp7bJ32ekvrI
        YWqtMrFLoHgzk6rGoKlqFr+ht7kheor1fGdeZ/YN27RadZ0oDsErMMl00SvVyR2aEjChHMyYZlnWR
        luo7btYT2RvswiLQ98qswiHpUXLJnF3hTV3xX9fg/ehbnNMRGmQTlrVE/fJQfHzp9COF8QB+Vrtm2
        FLx1RVYg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jokC6-0007l8-Fb; Fri, 26 Jun 2020 08:58:46 +0000
Date:   Fri, 26 Jun 2020 09:58:46 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, viro@zeniv.linux.org.uk, bcrl@kvack.org,
        asml.silence@gmail.com, Damien.LeMoal@wdc.com, hch@infradead.org,
        linux-fsdevel@vger.kernel.org, mb@lightnvm.io,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        selvakuma.s1@samsung.com, nj.shetty@samsung.com,
        javier.gonz@samsung.com, Arnav Dawn <a.dawn@samsung.com>
Subject: Re: [PATCH v2 1/2] fs,block: Introduce RWF_ZONE_APPEND and handling
 in direct IO path
Message-ID: <20200626085846.GA24962@infradead.org>
References: <1593105349-19270-1-git-send-email-joshi.k@samsung.com>
 <CGME20200625171834epcas5p226a24dfcb84cfa83fe29a2bd17795d85@epcas5p2.samsung.com>
 <1593105349-19270-2-git-send-email-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1593105349-19270-2-git-send-email-joshi.k@samsung.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

To restate my previous NAK:

A low-level protocol detail like RWF_ZONE_APPEND has absolutely no
business being exposed in the Linux file system interface.

And as mentioned before I think the idea of returning the actual
position written for O_APPEND writes totally makes sense, and actually
is generalizable to all files.  Together with zonefs that gives you a
perfect interface for zone append.

On Thu, Jun 25, 2020 at 10:45:48PM +0530, Kanchan Joshi wrote:
> Introduce RWF_ZONE_APPEND flag to represent zone-append.

And no one but us select few even know what zone append is, nevermind
what the detailed semantics are.  If you add a userspace API you need
to very clearly document the semantics inluding errors and corner cases.
