Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 133416966F6
	for <lists+io-uring@lfdr.de>; Tue, 14 Feb 2023 15:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbjBNOge (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Feb 2023 09:36:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbjBNOgd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Feb 2023 09:36:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F105422E
        for <io-uring@vger.kernel.org>; Tue, 14 Feb 2023 06:35:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676385344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9RjyhigfePlUSy6qTwqC04zzL1v2DzjMlFxn8DxRpjo=;
        b=YWaLPM41MYWZ8hnB0wD1ywSpY0HELwall1XGb6QXGcfY3MukAIkHGb3d+pCE+bzO7nPvkD
        KocW7nutcjmoGXwQFXG//cJumk8+qS+/Ik2qABd08GBxZJD61vVbuCDMROqgj1pc09EiLu
        xC0H8q50T1lt2uRAPLRY8STBOVUL2BQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-z75F3GTIPGunDAcx57uv8w-1; Tue, 14 Feb 2023 09:35:41 -0500
X-MC-Unique: z75F3GTIPGunDAcx57uv8w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26565104F0A0;
        Tue, 14 Feb 2023 14:35:40 +0000 (UTC)
Received: from T590 (ovpn-8-22.pek2.redhat.com [10.72.8.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BE4CE2026D4B;
        Tue, 14 Feb 2023 14:35:30 +0000 (UTC)
Date:   Tue, 14 Feb 2023 22:35:24 +0800
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
Message-ID: <Y+ucLFG/ap8uqwPG@T590>
References: <20230210153212.733006-1-ming.lei@redhat.com>
 <20230210153212.733006-2-ming.lei@redhat.com>
 <Y+e3b+Myg/30hlYk@T590>
 <CAHk-=wgTzLjvhzx-XGkgEQmXH6t=8OTFdQyhDgafGdC2n5gOfg@mail.gmail.com>
 <Y+hDQ1vL6AMFri1E@T590>
 <CAHk-=wgJsi7t7YYpuo6ewXGnHz2nmj67iWR6KPGoz5TBu34mWQ@mail.gmail.com>
 <CAJfpegtOetw46DvR1PeuX5L9-fe7Qk75mq5L4tGwpS_wuEz=1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegtOetw46DvR1PeuX5L9-fe7Qk75mq5L4tGwpS_wuEz=1g@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Miklos,

On Tue, Feb 14, 2023 at 12:03:44PM +0100, Miklos Szeredi wrote:
> On Mon, 13 Feb 2023 at 21:04, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > On Sat, Feb 11, 2023 at 5:39 PM Ming Lei <ming.lei@redhat.com> wrote:
> > >
> > > >
> > > >  (a) what's the point of MAY_READ? A non-readable page sounds insane
> > > > and wrong. All sinks expect to be able to read.
> > >
> > > For example, it is one page which needs sink end to fill data, so
> > > we needn't to zero it in source end every time, just for avoiding
> > > leak kernel data if (unexpected)sink end simply tried to read from
> > > the spliced page instead of writing data to page.
> >
> > I still don't understand.
> >
> > A sink *reads* the data. It doesn't write the data.
> 
> I think Ming is trying to generalize splice to allow flowing data in
> the opposite direction.

I think it isn't opposite direction, it is just that sink may be
WRITE to buffer, and the model is:

device(produce buffer in ->splice_read()) -> direct pipe ->
	file(consume buffer via READ or WRITE)

Follows kernel side implementation:

	splice_direct_to_actor(pipe, sd, source_actor)

	direct_actor():
		__splice_from_pipe(pipe, sd, sink_actor)

	sink_actor():
		get_page()

then read from file/socket to page.

The current userspace owns the whole buffer, so I understand the buffer
ownership can be transferred to consumer/sink side.

> So yes, sink would be writing to the buffer.
> And it MUST NOT be reading the data since the buffer may be
> uninitialized.

The added SPLICE_F_PRIV_FOR_READ[WRITE] is enough to avoid
un-expected READ, but the source end needs to confirm the buffer
ownership can be transferred to consumer, probably PIPE_BUF_FLAG_GIFT
can be used for this purpose.

> 
> The problem is how to tell the original source that the buffer is
> ready?  PG_uptodate comes to mind, but pipe buffers allow partial
> pages to be passed around, and there's no mechanism to describe a
> partially uptodate buffer.

I understand it isn't one issue from block device driver viewpoint at
least, since the WRITE to buffer in sink end can be thought as DMA
to buffer from device, and it is the upper layer(FS)'s responsibility
for updating page flag. And block driver needn't to handle page
status update.

So seems it is one fuse specific issue?


Thanks,
Ming

