Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE0986961BC
	for <lists+io-uring@lfdr.de>; Tue, 14 Feb 2023 12:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232647AbjBNLEE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Feb 2023 06:04:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbjBNLD7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Feb 2023 06:03:59 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6513D234F6
        for <io-uring@vger.kernel.org>; Tue, 14 Feb 2023 03:03:56 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id dr8so38987401ejc.12
        for <io-uring@vger.kernel.org>; Tue, 14 Feb 2023 03:03:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GdzfPCmVHJGyNX+E3E8axbyUX3GtR1Oh2TgImoToI7E=;
        b=ednkJZYRJrS0R2qMp7dMjiY5/E295iRlaB31w9ihVtnIAMOV0PYjYJ0bUgl+fdCYDB
         0nySuoMmVkCUk2nnTQRCQ9UurtE2OAzUShT4WRpDW3XDeL23fyrQchl2nNAer2OPMcch
         za6ywzuZT4iuSPB7pBWcIogfKh9Pxx+ltjH5A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GdzfPCmVHJGyNX+E3E8axbyUX3GtR1Oh2TgImoToI7E=;
        b=uWcm+eyroil5a+dqRh+RskP/j8tqsq2LPwrOXFheAe9CkXOs+7GCIjMRSkodNdpWNP
         Q/yp2DC5UfIPuHbB9UwAjuAEcqaAO92w1WMtBJYKvAQbgRaNknU1qA3P/cNEQuD4nVJ8
         6vg3mH2hUvgiIhqMFRy+ijO+38o23OwQu58nTGps+lcRVqEj0bKv8dhimaGF167wf5/8
         YSMuxhtLsUsNiGe+LfGCyXz7fuM8SOaQk5wHRTQ618v0Elt2xhVAv1Z1vUwityAv6Pmz
         teUBSERxmpArjDo93WsVL8vGV0QKc4iqDK0UUP0WvMGaemrJ2WXkSruIZKoOCMbXDIeq
         1neg==
X-Gm-Message-State: AO0yUKVml1LYB16gbv3vHyO5pfSL42zXu834ht2FRBj9/h6VKmR4h9Ks
        UgGGI/mOVy9DUuZLr5SXLBwKe/rWZlDzUqQgdXodbA==
X-Google-Smtp-Source: AK7set+WvUcFXeRoTtYGMf94EhUoMJevx+ByBygwMUIuKnc04+TQ6ZndZqpuUbrMuhp2ugN16oem+2f4IsHNxbEVu5A=
X-Received: by 2002:a17:906:8591:b0:8af:43c6:10bb with SMTP id
 v17-20020a170906859100b008af43c610bbmr1006905ejx.14.1676372634939; Tue, 14
 Feb 2023 03:03:54 -0800 (PST)
MIME-Version: 1.0
References: <20230210153212.733006-1-ming.lei@redhat.com> <20230210153212.733006-2-ming.lei@redhat.com>
 <Y+e3b+Myg/30hlYk@T590> <CAHk-=wgTzLjvhzx-XGkgEQmXH6t=8OTFdQyhDgafGdC2n5gOfg@mail.gmail.com>
 <Y+hDQ1vL6AMFri1E@T590> <CAHk-=wgJsi7t7YYpuo6ewXGnHz2nmj67iWR6KPGoz5TBu34mWQ@mail.gmail.com>
In-Reply-To: <CAHk-=wgJsi7t7YYpuo6ewXGnHz2nmj67iWR6KPGoz5TBu34mWQ@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 14 Feb 2023 12:03:44 +0100
Message-ID: <CAJfpegtOetw46DvR1PeuX5L9-fe7Qk75mq5L4tGwpS_wuEz=1g@mail.gmail.com>
Subject: Re: [PATCH 1/4] fs/splice: enhance direct pipe & splice for moving
 pages in kernel
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 13 Feb 2023 at 21:04, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
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

I think Ming is trying to generalize splice to allow flowing data in
the opposite direction.  So yes, sink would be writing to the buffer.
And it MUST NOT be reading the data since the buffer may be
uninitialized.

The problem is how to tell the original source that the buffer is
ready?  PG_uptodate comes to mind, but pipe buffers allow partial
pages to be passed around, and there's no mechanism to describe a
partially uptodate buffer.

Thanks,
Miklos
