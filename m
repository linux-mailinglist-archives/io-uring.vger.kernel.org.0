Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 861F06E507E
	for <lists+io-uring@lfdr.de>; Mon, 17 Apr 2023 21:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbjDQTAy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 Apr 2023 15:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjDQTAx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 Apr 2023 15:00:53 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E319046BF;
        Mon, 17 Apr 2023 12:00:51 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f16b99b990so16108445e9.0;
        Mon, 17 Apr 2023 12:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681758050; x=1684350050;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XK4v5MJMwmg+Uel4aUp/2qOZYeDNDYULZOv/n+WFDZk=;
        b=G1ZPJObcoBUqGxehJKZEXfV1+MWzSvUo1KE8wI0JiRKiPIVlpzSw3afP9Hc15URNfP
         UYuUbv3JZTzLoAPploAib34jgxjztxEIiEKTrUEiI8Fu9fu6eFYyUNkGIwMvht2C2M7H
         DpbzjmzEtPm7VcCZ/dUg/uHYOw6yLpxBGVVMNioK+Vnqk/El795yQ1w6JxVuCwBdcck/
         dKI+/adzYBfI8MHdgG8FUvJsNUI47CqYZI4dx9TOwieCyM46BLUmATHMK68wkus+m7j0
         JBdACn+dScNqPJnxIsQoe5YcR9/KW0cwPYINq9THObvSHobeGf4R4X89G+sLDUkzYzrp
         tg3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681758050; x=1684350050;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XK4v5MJMwmg+Uel4aUp/2qOZYeDNDYULZOv/n+WFDZk=;
        b=O3c0Nfc/3w5p0pQJOjTZmyd2F62byXASH8bWpskTQx6m/QcBZALN+oDGF6rjR4e41I
         4T7HmWMKIrYr4Wpb/44h4oXTyG1//fG08mI6Gxm7ZpCd6M7PbpEUDq9Ij1z+076LPfB4
         a2edc3iIZB2M3YNd5B3mBI9RoodgdduUTCWC6Pyg2HxB9VAETXYqNGIlX8jVa9QTSlAw
         CrHJ5EfqwB0pFjIJGKhfi0jL36H7hrcskagF5AMcfQbKqhiQ9m9RT5+sL4wjH0notB9a
         ql50F2S8TgsDG2V4f5Ip9ZAHWSqVatOVDUE9ijh9yr9GWF5sPcyOr9DORqchfY0WJ5ot
         pHJA==
X-Gm-Message-State: AAQBX9cA8J69AaTO7PwNxEyXjIqL38uBpC013GX2TfRjAfCUV0oel88V
        VqBl4o3EQUzxY2sU8xE/Uq8=
X-Google-Smtp-Source: AKy350bhGCCOD3qqpqZLlv4//cNtwXXpoLWQVBGSi2t0ax4dpauuk4Cmae7AnPqgCtwC64G7rPe+xw==
X-Received: by 2002:adf:f741:0:b0:2db:2678:ffed with SMTP id z1-20020adff741000000b002db2678ffedmr7914wrp.7.1681758050053;
        Mon, 17 Apr 2023 12:00:50 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id y18-20020adff6d2000000b002daf0b52598sm11144482wrp.18.2023.04.17.12.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 12:00:49 -0700 (PDT)
Date:   Mon, 17 Apr 2023 20:00:48 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Subject: Re: [PATCH 5/7] io_uring: rsrc: use FOLL_SAME_FILE on
 pin_user_pages()
Message-ID: <b661ca21-b436-44cf-b70d-0b126989ab33@lucifer.local>
References: <cover.1681508038.git.lstoakes@gmail.com>
 <17357dec04b32593b71e4fdf3c30a346020acf98.1681508038.git.lstoakes@gmail.com>
 <ZD1CAvXee5E5456e@nvidia.com>
 <b1f125c8-05ec-4b41-9b3d-165bf7694e5a@lucifer.local>
 <ZD1I8XlSBIYET9A+@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZD1I8XlSBIYET9A+@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Apr 17, 2023 at 10:26:09AM -0300, Jason Gunthorpe wrote:
> On Mon, Apr 17, 2023 at 02:19:16PM +0100, Lorenzo Stoakes wrote:
>
> > > I'd rather see something like FOLL_ALLOW_BROKEN_FILE_MAPPINGS than
> > > io_uring open coding this kind of stuff.
> > >
> >
> > How would the semantics of this work? What is broken? It is a little
> > frustrating that we have FOLL_ANON but hugetlb as an outlying case, adding
> > FOLL_ANON_OR_HUGETLB was another consideration...
>
> It says "historically this user has accepted file backed pages and we
> we think there may actually be users doing that, so don't break the
> uABI"
>
> Without the flag GUP would refuse to return file backed pages that can
> trigger kernel crashes or data corruption.
>
> Eg we'd want most places to not specify the flag and the few that do
> to have some justification.
>
> We should consdier removing FOLL_ANON, I'm not sure it really makes
> sense these days for what proc is doing with it. All that proc stuff
> could likely be turned into a kthread_use_mm() and a simple
> copy_to/from user?
>
> I suspect that eliminates the need to check for FOLL_ANON?
>
> Jason

The proc invocations utilising FOLL_ANON are get_mm_proctitle(),
get_mm_cmdline() and environ_read() which each pass it to
access_remote_vm() and which will be being called from a process context,
i.e. with tsk->mm != NULL, but kthread_use_mm() explicitly disallows the
(slightly mind boggling) idea of swapping out an established mm.

So I don't think this route is plausible unless you were thinking of
somehow offloading to a thread?

In any case, if we institute the FOLL_ALLOW_BROKEN_FILE_MAPPINGS flag we
can just drop FOLL_ANON altogether right, as this will be implied and
hugetlb should work here too?

Separately, I find the semantics of access_remote_vm() kind of weird, and
with a possible mmap_lock-free future it does make me wonder whether
something better could be done there.

(Section where I sound like I might be going mad) Perhaps having some means
of context switching into the kernel portion of the remote process as if
were a system call or soft interrupt handler and having that actually do
the uaccess operation could be useful here?

I'm guesing nothing like that exists yet?
