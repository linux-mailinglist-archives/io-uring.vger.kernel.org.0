Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5D77375CC2
	for <lists+io-uring@lfdr.de>; Thu,  6 May 2021 23:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhEFVTs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 May 2021 17:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbhEFVTr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 May 2021 17:19:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45437C061574;
        Thu,  6 May 2021 14:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Xl1TeeOf/JGIUBjiOt9NoPB0yarR8RPKuDpQ8QvgIk4=; b=VaLxA3YCNmPK4D9hbt6DzrBcT7
        dIJOr62v1eUy78oMknmfq82Img84rVvLCTUeYZAay5BUJFreGDHfTX0iAvMli9v7BUaMjPuEvgxRP
        kjfk38ksIr4O9ELTr+R/baSvznJ9LLcgDJVO5fA0wKsyYLvYedMEAvsQ9zPaSuYCanV7bC8xznukV
        kSWGXuXJ71t3BGyUdQatBVgZIhc0pFQrdLFliR+cC611vb91N2ciwGidYWEQvq411QjfOHZVFqHV2
        s3NeGMg063/t65+Bv5hkaiym8LMTHMUwrhhTjncLHGEdpY0Dgfn0tqUiSqW42yNY/k7cN31uS0C0h
        7m3U61VQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lelN4-002EGe-Sj; Thu, 06 May 2021 21:17:35 +0000
Date:   Thu, 6 May 2021 22:17:22 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        yangerkun <yangerkun@huawei.com>, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH] block: reexpand iov_iter after read/write
Message-ID: <20210506211722.GH388843@casper.infradead.org>
References: <a2e97190-936d-ebe0-2adc-748328076f31@gmail.com>
 <7ff7d1b7-8b6d-a684-1740-6a62565f77b6@gmail.com>
 <3368729f-e61d-d4b6-f2ae-e17ebe59280e@gmail.com>
 <3d6904c0-9719-8569-2ae8-dd9694da046b@huawei.com>
 <05803db5-c6de-e115-3db2-476454b20668@gmail.com>
 <YIwVzWEU97BylYK1@zeniv-ca.linux.org.uk>
 <2ee68ca3-e466-24d4-3766-8c627d94d71e@kernel.dk>
 <YJQ7jf7Twxexx31T@zeniv-ca.linux.org.uk>
 <b4fe4a3d-06ab-31e3-e1a2-46c23307b32a@kernel.dk>
 <YJRa4gQSWl3/eMXV@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJRa4gQSWl3/eMXV@zeniv-ca.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 06, 2021 at 09:08:50PM +0000, Al Viro wrote:
> On Thu, May 06, 2021 at 01:15:01PM -0600, Jens Axboe wrote:
> 
> > Attached output of perf annotate <func> for that last run.
> 
> Heh...  I wonder if keeping the value of iocb_flags(file) in
> struct file itself would have a visible effect...

I suggested that ...
https://lore.kernel.org/linux-fsdevel/20210110061321.GC35215@casper.infradead.org/
