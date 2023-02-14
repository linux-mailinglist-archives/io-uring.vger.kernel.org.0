Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50D8B69683C
	for <lists+io-uring@lfdr.de>; Tue, 14 Feb 2023 16:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbjBNPjQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Feb 2023 10:39:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjBNPjP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Feb 2023 10:39:15 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7917428847
        for <io-uring@vger.kernel.org>; Tue, 14 Feb 2023 07:39:13 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id dz21so5952869edb.13
        for <io-uring@vger.kernel.org>; Tue, 14 Feb 2023 07:39:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xZmPo9Q6Z4RUvjG621OuZzJYIrsFcDWjerwh051FXoA=;
        b=FAZSGVM05LiY4aBSpZ5WadxilW/R17zFfxlNey9X70rWvVUa3MG9VyAKd8htvJEXnC
         wooRzSazMoXgO15zXzpSBVYlNPU8O7UVynukN5MqkrpiRmvAso7+Y+0dBcDZTsksGwzz
         4mt/KJrc3UWd/KnLPbAbYCAVmbppctdW70IPQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xZmPo9Q6Z4RUvjG621OuZzJYIrsFcDWjerwh051FXoA=;
        b=XO9uzWquidse0Ihkn1uaNd75Ynyyy9lHgb5IKlNaO5kF60lLhnCSalvQfgEn+mxOr8
         L05ZLKWCf+R+30Yk+kYqh2JvefS1O+dxR29MB15GGqgbp3CB+vsvL9XNGV26ioQImSLl
         mxHynWpWVNH4d43UOUYj2sfnUMJROnChuNBeA50h2GWpy3E6IUdyJ34lueKSOHUPXR49
         lO+619mBJ/exdfQCZVCL7aiptuup2SssAHCosDx9xRDqM+M1DNTU66FO6mhwQvFufFcY
         RWJfRAGxIQUM+3mhyE5GcfW5r3bU+681xY3vBWvAAARr+rzlpVigLFuXmEIBVbn0zaww
         xXKA==
X-Gm-Message-State: AO0yUKXFYysk1ZTTSbmCCpGA2jS1I7mF/sOwJH1iE8DEpvI/p/9jr20B
        NIi4aBPC/K0+ULbxgt8sNKpEVe3+1qkVfHVnNVjGQA==
X-Google-Smtp-Source: AK7set+LFMwnBwC1msVbCl4zOk4kMAfWh+Y8EdW51624/1+QCBEmVGc3gYPzRWOo9U81Q8EYcBz3QTdfSUKg/pIn3fw=
X-Received: by 2002:a50:d656:0:b0:4ab:4b7d:5f76 with SMTP id
 c22-20020a50d656000000b004ab4b7d5f76mr1404574edj.8.1676389152127; Tue, 14 Feb
 2023 07:39:12 -0800 (PST)
MIME-Version: 1.0
References: <20230210153212.733006-1-ming.lei@redhat.com> <20230210153212.733006-2-ming.lei@redhat.com>
 <Y+e3b+Myg/30hlYk@T590> <CAHk-=wgTzLjvhzx-XGkgEQmXH6t=8OTFdQyhDgafGdC2n5gOfg@mail.gmail.com>
 <Y+hDQ1vL6AMFri1E@T590> <CAHk-=wgJsi7t7YYpuo6ewXGnHz2nmj67iWR6KPGoz5TBu34mWQ@mail.gmail.com>
 <CAJfpegtOetw46DvR1PeuX5L9-fe7Qk75mq5L4tGwpS_wuEz=1g@mail.gmail.com> <Y+ucLFG/ap8uqwPG@T590>
In-Reply-To: <Y+ucLFG/ap8uqwPG@T590>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 14 Feb 2023 16:39:01 +0100
Message-ID: <CAJfpeguGayE2fS2m9U7=Up4Eqa_89oTeR4xW-WbcfjJBRaYqHA@mail.gmail.com>
Subject: Re: [PATCH 1/4] fs/splice: enhance direct pipe & splice for moving
 pages in kernel
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
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

On Tue, 14 Feb 2023 at 15:35, Ming Lei <ming.lei@redhat.com> wrote:

> I understand it isn't one issue from block device driver viewpoint at
> least, since the WRITE to buffer in sink end can be thought as DMA
> to buffer from device, and it is the upper layer(FS)'s responsibility
> for updating page flag. And block driver needn't to handle page
> status update.

The block device still needs to know when the DMA is finished, right?

Thanks,
Miklos
