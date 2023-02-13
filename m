Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91D16695145
	for <lists+io-uring@lfdr.de>; Mon, 13 Feb 2023 21:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjBMUEt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Feb 2023 15:04:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbjBMUEs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Feb 2023 15:04:48 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8466B1D901
        for <io-uring@vger.kernel.org>; Mon, 13 Feb 2023 12:04:47 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id sa10so34638519ejc.9
        for <io-uring@vger.kernel.org>; Mon, 13 Feb 2023 12:04:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3VQLY//5P39OuXGOEpzf1Glp5VE7sIcldzWZWkHVBtk=;
        b=TsAcvf6Rib9TA7nd5ff4vkYnkiTo2vkqF7CbonXHIwalzDwl0C+xPzUQngvguvBhYW
         lfrD3pWDukUSl79bN71gu/WciycmYWabbXLrlXuPTtajVxjnp+EjdrsnaaWimERVUikg
         BZJmYQInM/dGBkTYdpAbao9PfJ1lR4MxklY+k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3VQLY//5P39OuXGOEpzf1Glp5VE7sIcldzWZWkHVBtk=;
        b=LSYGAZe3J7HRKdxMmMVD3N3tI6ta60NsxKCh/+taRjBpTaIn1ZogUB/cvfVlIG6cZO
         WjaozPZib6SXpL4UGiVgADEmTNKUh9ShSi6ccNV98QMMqR1Rc5gyEJF1Tk2GWNsFRgxp
         hk+Ck4Db3zhYBGkzbLD72nEGQ2Yg8AgPcoq6mdiQyCli1eBlCqqIzj+KBmS4J4NBm84x
         1PUnT5lJXgnNMWDFgEYZRSAhaW1OCJxBfazarLawSw/8JWKazyzMZa/5rcXv28L042Zq
         kIefSlXvBLR/PyBUKQB6a3SYCMARlJlO2q/aH8+O19t4dkCLl37kZe8K+ep1wH52JkEA
         GLlg==
X-Gm-Message-State: AO0yUKXismv9Ml3vh3U5E7c4R3HAklKVGzgjuqJOYFJ9RmRm2POzYws+
        4S11LU6wei+uxXe6JhT7LiWXvyWNKsUC/R8uXD8=
X-Google-Smtp-Source: AK7set/X2cAEQa9gifDo9u/cVZymyu1CwcW/rF75qcsq4LzXM/XERi9ij9zjtEsGQL5CMjhDFPmOQg==
X-Received: by 2002:a17:906:34d9:b0:8af:2f5e:93e3 with SMTP id h25-20020a17090634d900b008af2f5e93e3mr15683218ejb.29.1676318685624;
        Mon, 13 Feb 2023 12:04:45 -0800 (PST)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com. [209.85.218.42])
        by smtp.gmail.com with ESMTPSA id og49-20020a1709071df100b008898c93f086sm7156174ejc.71.2023.02.13.12.04.44
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Feb 2023 12:04:44 -0800 (PST)
Received: by mail-ej1-f42.google.com with SMTP id sa10so34638305ejc.9
        for <io-uring@vger.kernel.org>; Mon, 13 Feb 2023 12:04:44 -0800 (PST)
X-Received: by 2002:a17:907:366:b0:88d:ba79:4310 with SMTP id
 rs6-20020a170907036600b0088dba794310mr5996890ejb.0.1676318684223; Mon, 13 Feb
 2023 12:04:44 -0800 (PST)
MIME-Version: 1.0
References: <20230210153212.733006-1-ming.lei@redhat.com> <20230210153212.733006-2-ming.lei@redhat.com>
 <Y+e3b+Myg/30hlYk@T590> <CAHk-=wgTzLjvhzx-XGkgEQmXH6t=8OTFdQyhDgafGdC2n5gOfg@mail.gmail.com>
 <Y+hDQ1vL6AMFri1E@T590>
In-Reply-To: <Y+hDQ1vL6AMFri1E@T590>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 13 Feb 2023 12:04:27 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgJsi7t7YYpuo6ewXGnHz2nmj67iWR6KPGoz5TBu34mWQ@mail.gmail.com>
Message-ID: <CAHk-=wgJsi7t7YYpuo6ewXGnHz2nmj67iWR6KPGoz5TBu34mWQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] fs/splice: enhance direct pipe & splice for moving
 pages in kernel
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Feb 11, 2023 at 5:39 PM Ming Lei <ming.lei@redhat.com> wrote:
>
> >
> >  (a) what's the point of MAY_READ? A non-readable page sounds insane
> > and wrong. All sinks expect to be able to read.
>
> For example, it is one page which needs sink end to fill data, so
> we needn't to zero it in source end every time, just for avoiding
> leak kernel data if (unexpected)sink end simply tried to read from
> the spliced page instead of writing data to page.

I still don't understand.

A sink *reads* the data. It doesn't write the data.

There's no point trying to deal with "if unexpectedly doing crazy
things". If a sink writes the data, the sinkm is so unbelievably buggy
that it's not even funny.

And having two flags that you then say "have to be used together" is pointless.

It's not two different flags if you can't use them separately!

So I think your explanations are anything *but* explaining what you
want. They are just strange and not sensible.

Please explain to me in small words and simple sentences what it is
you want. And no, if the explanation is "the sink wants to write to
the buffer", then that's not an explanation, it's just insanity.

We *used* to have the concept of "gifting" the buffer explicitly to
the sink, so that the sink could - instead of reading from it - decide
to just use the whole buffer as-is long term. The idea was that tthe
buffer woudl literally be moved from the source to the destination,
ownership and all.

But if that's what you want, then it's not about "sink writes". It's
literally about the splice() wanting to move not just the data, but
the whole ownership of the buffer.

Anyway, I will NAK this as long as the explanations for what the
semantics are and what you want to do don't make sense. Right now they
don't.

              Linus
