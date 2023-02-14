Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E339695597
	for <lists+io-uring@lfdr.de>; Tue, 14 Feb 2023 01:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjBNAxW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Feb 2023 19:53:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbjBNAxV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Feb 2023 19:53:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D1F1C166
        for <io-uring@vger.kernel.org>; Mon, 13 Feb 2023 16:52:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676335960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C7fWPKUxf/ySZogJmPF+FERbCegk6jr7LEHTCcC3FMQ=;
        b=X+puFKp2i1WaEPxnBQ4DWahOfv+n3vrZD6io+t4X3pD4qJsPm+U+7zXWIXjj49Au3PQPUv
        iI4uKN7hYQXHh7FWUPzXrVeTOujYubAw0bw25ocpL4edNdRElEx3Uxr6gvFHJEr6OJCHce
        xO7SO8Wq3IQsNuPLdXUPdrv+mrdqq40=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-138-4RYuPyS3PZCEszgvkpSmIA-1; Mon, 13 Feb 2023 19:52:37 -0500
X-MC-Unique: 4RYuPyS3PZCEszgvkpSmIA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D065080006E;
        Tue, 14 Feb 2023 00:52:36 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3A49418EC7;
        Tue, 14 Feb 2023 00:52:28 +0000 (UTC)
Date:   Tue, 14 Feb 2023 08:52:23 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
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
Message-ID: <Y+rbR48vvhHDJlUF@T590>
References: <20230210153212.733006-1-ming.lei@redhat.com>
 <20230210153212.733006-2-ming.lei@redhat.com>
 <Y+e3b+Myg/30hlYk@T590>
 <CAHk-=wgTzLjvhzx-XGkgEQmXH6t=8OTFdQyhDgafGdC2n5gOfg@mail.gmail.com>
 <Y+hDQ1vL6AMFri1E@T590>
 <CAHk-=wgJsi7t7YYpuo6ewXGnHz2nmj67iWR6KPGoz5TBu34mWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgJsi7t7YYpuo6ewXGnHz2nmj67iWR6KPGoz5TBu34mWQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Feb 13, 2023 at 12:04:27PM -0800, Linus Torvalds wrote:
> On Sat, Feb 11, 2023 at 5:39 PM Ming Lei <ming.lei@redhat.com> wrote:
> >
> > >
> > >  (a) what's the point of MAY_READ? A non-readable page sounds insane
> > > and wrong. All sinks expect to be able to read.
> >
> > For example, it is one page which needs sink end to fill data, so
> > we needn't to zero it in source end every time, just for avoiding
> > leak kernel data if (unexpected)sink end simply tried to read from
> > the spliced page instead of writing data to page.
> 
> I still don't understand.
> 
> A sink *reads* the data. It doesn't write the data.
> 
> There's no point trying to deal with "if unexpectedly doing crazy
> things". If a sink writes the data, the sinkm is so unbelievably buggy
> that it's not even funny.
> 
> And having two flags that you then say "have to be used together" is pointless.

Actually I think it is fine to use the pipe buffer flags separately,
if MAY_READ/MAY_WRITE is set in source end, the sink side need to respect
it. All current in-tree source end actually implies both MAY_READ & MAY_WRITE.

> It's not two different flags if you can't use them separately!
> 
> So I think your explanations are anything *but* explaining what you
> want. They are just strange and not sensible.
> 
> Please explain to me in small words and simple sentences what it is
> you want. And no, if the explanation is "the sink wants to write to
> the buffer", then that's not an explanation, it's just insanity.
> 
> We *used* to have the concept of "gifting" the buffer explicitly to
> the sink, so that the sink could - instead of reading from it - decide
> to just use the whole buffer as-is long term. The idea was that tthe
> buffer woudl literally be moved from the source to the destination,
> ownership and all.
> 
> But if that's what you want, then it's not about "sink writes". It's
> literally about the splice() wanting to move not just the data, but
> the whole ownership of the buffer.

Yeah, it is actually transferring the buffer ownership, and looks
SPLICE_F_GIFT is exactly the case, but the driver side needs to set
QUEUE_FLAG_STABLE_WRITES for avoiding writeback to touch these pages.

Follows the idea:

file(devices(such as, fuse, ublk), produce pipe buffer) -> direct pipe -> file(consume the pipe buffer)

The 'consume' could be READ or WRITE.

So once SPLICE_F_GIFT is set from source side, the two buffer flags
aren't needed any more, right?

Please see the detailed explanation & use case in following link:

https://lore.kernel.org/linux-block/409656a0-7db5-d87c-3bb2-c05ff7af89af@kernel.dk/T/#m237e5973571b3d85df9fa519cf2c9762440009ba



Thanks,
Ming

