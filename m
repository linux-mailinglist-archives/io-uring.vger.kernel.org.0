Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64C371FF480
	for <lists+io-uring@lfdr.de>; Thu, 18 Jun 2020 16:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbgFROQv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Jun 2020 10:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730277AbgFROQu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Jun 2020 10:16:50 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9A4C06174E;
        Thu, 18 Jun 2020 07:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=59v7DL+Q6M0O6agqJhZf72SPocZXRPqx3iv/O5eS9Zk=; b=frBBXjmKpVtAc+AqKk5DD8LQNU
        wbXudAS7/WiZVQ1wkOg5A1ixxX85phlK37al49JjUr3uf6dYnpaQrHmHDThIfg/5T2KcquAjDchIJ
        5tbQR1JRhwgA8oiv/tbO5pI+PrShy4gU8oT5ZvztmYtlogsPm4n6sNtO33CkT5OGOrwMhquvwhgeA
        FC6kTYlBxc43qy5rcUEsh9gLh7ZLSPn2l/HnHnJePiJizDk7EPysFbh5hxYI8YP/llFbTe0uMMwzd
        nXmSN6L/g4upY7k4bzc+G1g2Fnu3gFfd95Y4PN1fvigpZVS+rQYFnfavVmMWaToR0PCyznDj3IR8T
        0pGOqomA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jlvLQ-0002tV-UP; Thu, 18 Jun 2020 14:16:44 +0000
Date:   Thu, 18 Jun 2020 07:16:44 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Matias =?iso-8859-1?Q?Bj=F8rling?= <mb@lightnvm.io>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, bcrl@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, selvakuma.s1@samsung.com,
        nj.shetty@samsung.com, javier.gonz@samsung.com,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <keith.busch@wdc.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/3] zone-append support in aio and io-uring
Message-ID: <20200618141644.GB16866@infradead.org>
References: <CGME20200617172653epcas5p488de50090415eb802e62acc0e23d8812@epcas5p4.samsung.com>
 <1592414619-5646-1-git-send-email-joshi.k@samsung.com>
 <f503c488-fa00-4fe2-1ceb-7093ea429e45@lightnvm.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f503c488-fa00-4fe2-1ceb-7093ea429e45@lightnvm.io>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jun 18, 2020 at 10:04:32AM +0200, Matias Bjørling wrote:
> Please provide a pointers to applications that are updated and ready to take
> advantage of zone append.

That is a pretty high bar for kernel APIs that we don't otherwise
apply unless seriously in doubt.

> I do not believe it's beneficial at this point to change the libaio API,
> applications that would want to use this API, should anyway switch to use
> io_uring.

I think that really depends on the amount of churn required.  We
absolutely can expose things like small additional flags or simple
new operations, as rewriting application to different APIs is not
exactly trivial.  On the other hand we really shouldn't do huge
additions to the machinery.

> Please also note that applications and libraries that want to take advantage
> of zone append, can already use the zonefs file-system, as it will use the
> zone append command when applicable.

Not really.  While we already use Zone Append in Zonefs for some cases,
we can't fully take advantage of the scalability of Zone Append.  For
that we'd need a way to return the file position where an O_APPEND
write actually landed, as suggested in my earlier mail.  Which I think
is a very useful addition, and Damien and I had looked into adding
it both for zonefs and normal file systems, but didn't get around to
doing the work yet.
