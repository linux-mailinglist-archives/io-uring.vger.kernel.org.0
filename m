Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33C9A69728A
	for <lists+io-uring@lfdr.de>; Wed, 15 Feb 2023 01:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjBOAMO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Feb 2023 19:12:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjBOAMN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Feb 2023 19:12:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2F72FCE9
        for <io-uring@vger.kernel.org>; Tue, 14 Feb 2023 16:11:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676419883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k37hKnr7FAR3AoepA4iTJhmjAlSP4APBHTl0oHVqVs4=;
        b=jTEflOEFPAnGtgRE0NNRJjdXXuqLDftxGpoKwNBBkvW2O+BSNIERqq7EPANQW+IJ+kU9dD
        MToBj32M+zMKo9DGgNH/If9tbz4N0ANP146q5FRvGIEc48GScReppe9leSPqDcvPzeyBjT
        XhT9TVMenS+ZJ3gRM397kP4UBrlCvLM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-127-9poEkWqlOpK_nbH3DRHwcg-1; Tue, 14 Feb 2023 19:11:20 -0500
X-MC-Unique: 9poEkWqlOpK_nbH3DRHwcg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF5BF1C0418E;
        Wed, 15 Feb 2023 00:11:19 +0000 (UTC)
Received: from T590 (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C1DBC15BAD;
        Wed, 15 Feb 2023 00:11:10 +0000 (UTC)
Date:   Wed, 15 Feb 2023 08:11:05 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>,
        ming.lei@redhat.com
Subject: Re: [PATCH 1/4] fs/splice: enhance direct pipe & splice for moving
 pages in kernel
Message-ID: <Y+wjGZO6rVw5W35T@T590>
References: <20230210153212.733006-1-ming.lei@redhat.com>
 <20230210153212.733006-2-ming.lei@redhat.com>
 <Y+e3b+Myg/30hlYk@T590>
 <CAHk-=wgTzLjvhzx-XGkgEQmXH6t=8OTFdQyhDgafGdC2n5gOfg@mail.gmail.com>
 <Y+hDQ1vL6AMFri1E@T590>
 <CAHk-=wgJsi7t7YYpuo6ewXGnHz2nmj67iWR6KPGoz5TBu34mWQ@mail.gmail.com>
 <CAJfpegtOetw46DvR1PeuX5L9-fe7Qk75mq5L4tGwpS_wuEz=1g@mail.gmail.com>
 <Y+ucLFG/ap8uqwPG@T590>
 <CAJfpeguGayE2fS2m9U7=Up4Eqa_89oTeR4xW-WbcfjJBRaYqHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpeguGayE2fS2m9U7=Up4Eqa_89oTeR4xW-WbcfjJBRaYqHA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Feb 14, 2023 at 04:39:01PM +0100, Miklos Szeredi wrote:
> On Tue, 14 Feb 2023 at 15:35, Ming Lei <ming.lei@redhat.com> wrote:
> 
> > I understand it isn't one issue from block device driver viewpoint at
> > least, since the WRITE to buffer in sink end can be thought as DMA
> > to buffer from device, and it is the upper layer(FS)'s responsibility
> > for updating page flag. And block driver needn't to handle page
> > status update.
> 
> The block device still needs to know when the DMA is finished, right?

Yeah, for normal in-kernel device driver, the completion is triggered by
interrupt or io polling.

For ublk, io handling is done by userspace, here we use io_uring to
handle the IO in aio style. When the aio is completed, the userspace
gets notified of the completion.

Here the way is basically same with loop dio mode(losetup --direct-io=on),
it is still zero copy, pages from loop block driver are passed to FS(backing file)
directly for handling the original IO.


Thanks, 
Ming

