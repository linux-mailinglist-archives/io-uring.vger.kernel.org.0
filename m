Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD2969357D
	for <lists+io-uring@lfdr.de>; Sun, 12 Feb 2023 02:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjBLBkV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Feb 2023 20:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjBLBkV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Feb 2023 20:40:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0096C113E1
        for <io-uring@vger.kernel.org>; Sat, 11 Feb 2023 17:39:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676165973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eAxzcbkCJ6zIQ31y1IjAFThY9NL30q5sWMTxM/NEZfE=;
        b=AdmNDVAazZwR6ovhcCscuZ/lK0eQfKGQW0uBFqPGFCYAa7/ou4iaMpFPLLjFy5DwcKpxEF
        sIthd7eRqJzVc+b/3ZRBUPkTtLeX3PlrOA6GBgpuHU2v0qqJfYrDPqNEDWfPM9F553PjfT
        QbvxCzGfTxihr91JF2wFzeQbLbhPYg0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-76X-Vc21OVugqo_uFi6N0Q-1; Sat, 11 Feb 2023 20:39:29 -0500
X-MC-Unique: 76X-Vc21OVugqo_uFi6N0Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A28491C0512F;
        Sun, 12 Feb 2023 01:39:28 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2029740C83B6;
        Sun, 12 Feb 2023 01:39:20 +0000 (UTC)
Date:   Sun, 12 Feb 2023 09:39:15 +0800
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
Message-ID: <Y+hDQ1vL6AMFri1E@T590>
References: <20230210153212.733006-1-ming.lei@redhat.com>
 <20230210153212.733006-2-ming.lei@redhat.com>
 <Y+e3b+Myg/30hlYk@T590>
 <CAHk-=wgTzLjvhzx-XGkgEQmXH6t=8OTFdQyhDgafGdC2n5gOfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgTzLjvhzx-XGkgEQmXH6t=8OTFdQyhDgafGdC2n5gOfg@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Feb 11, 2023 at 10:57:08AM -0800, Linus Torvalds wrote:
> On Sat, Feb 11, 2023 at 7:42 AM Ming Lei <ming.lei@redhat.com> wrote:
> >
> > +/*
> > + * Used by source/sink end only, don't touch them in generic
> > + * splice/pipe code. Set in source side, and check in sink
> > + * side
> > + */
> > +#define PIPE_BUF_PRIV_FLAG_MAY_READ    0x1000 /* sink can read from page */
> > +#define PIPE_BUF_PRIV_FLAG_MAY_WRITE   0x2000 /* sink can write to page */
> > +
> 
> So this sounds much more sane and understandable, but I have two worries:
> 
>  (a) what's the point of MAY_READ? A non-readable page sounds insane
> and wrong. All sinks expect to be able to read.

For example, it is one page which needs sink end to fill data, so
we needn't to zero it in source end every time, just for avoiding
leak kernel data if (unexpected)sink end simply tried to read from
the spliced page instead of writing data to page.

> 
>  (b) what about 'tee()' which duplicates a pipe buffer that has
> MAY_WRITE? Particularly one that may already have been *partially*
> given to something that thinks it can write to it?

The flags added is for kernel code(io_uring) over direct pipe,
and the two pipe buf flags won't be copied cross tee, cause the kernel
code just use spliced pages. (io_uring -> tee())

Also because of the added SPLICE_F_PRIV_FOR_READ[WRITE], pipe buffer
flags won't be copied over tee() too, because tee() can't pass the two
flags to device's ->splice_read().

We may need to document that the two pair flags should be used
together.

thanks,
Ming

