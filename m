Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5F432DA8E
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 20:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbhCDTsD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 14:48:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231941AbhCDTrw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 14:47:52 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB74EC061574
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 11:47:11 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id a17so34868044ljq.2
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 11:47:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UvpWFVw1erLjJVLYv0OJJkHDf27lSxmiVrMiY7jaZ1c=;
        b=KhplcVrt2ntaQgPQf8/JRQgrquNfI/ZHqRrQitoSOERXfS+Xyxrd2KX/I0UsAvgHwL
         ohluBTjXAvfMQo6ezsVDsKxj+t2yDBMFDAm+ugXC7LCvXdvMt8fOJzWr2l1jXJ26i/fy
         7H8NRB6y1AbRN6mXb6liuvi+OUvmB60azbZGA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UvpWFVw1erLjJVLYv0OJJkHDf27lSxmiVrMiY7jaZ1c=;
        b=NQ0DvufSZ0C++M25eOEPFktdhSqNv/hHtwpuY2eFEaW7qiQ0iC6HH6oDikgZ+7EjJM
         cjMK5QQEQjzmbzCrRp1ozqKBn2V4lClds7yAwbL9fo/uvaxo0gG0A+VS8XxkFC2BIckt
         rakgxQKSyTvGCc/Z2yeC/1L4XVRRGz7yBWnAcEmkDAZdZLYTrt9t85lplWVBsNpwVnmQ
         9NeI6C3WZR8znX5bK3i8mNR1gUb92GXEev8YtZoo5A/47gpunRytFcE6oVetLgmrcENW
         ztcYNSKSQYEy+aDLt0qg9FLJGId0ArPfMQfTvAK8ECcCI+mxU/K8G+9KfR6Xhm/vvvIR
         S9HA==
X-Gm-Message-State: AOAM530WQkJejbvYu+Zos6wBZowvSsK5q3QLpONI60mTvggcyzfP7NyN
        ni3PKlbbkAVCsCO0OieCGT8SNkUaRlsBYA==
X-Google-Smtp-Source: ABdhPJy6UDsmUnywSXFEiQuKIXGUZlIxA0UedjbmGrQcRw7p4lFeHwCdO3GlWDpFHbvPSNymsLFH4w==
X-Received: by 2002:a2e:2d02:: with SMTP id t2mr3046918ljt.488.1614887229920;
        Thu, 04 Mar 2021 11:47:09 -0800 (PST)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com. [209.85.208.169])
        by smtp.gmail.com with ESMTPSA id x8sm39441lfc.8.2021.03.04.11.47.08
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 11:47:09 -0800 (PST)
Received: by mail-lj1-f169.google.com with SMTP id u18so21207068ljd.3
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 11:47:08 -0800 (PST)
X-Received: by 2002:a2e:9bd0:: with SMTP id w16mr3058504ljj.465.1614887228379;
 Thu, 04 Mar 2021 11:47:08 -0800 (PST)
MIME-Version: 1.0
References: <20210219171010.281878-1-axboe@kernel.dk> <20210219171010.281878-10-axboe@kernel.dk>
 <85bc236d-94af-6878-928b-c69dbdcd46f9@samba.org> <d9704b9e-ae5e-0795-ba2e-029293f89616@kernel.dk>
 <a9f58269-b260-6281-4e83-43cb5e881d25@samba.org> <d3dfc422-8762-0078-bc80-989f1d71f006@samba.org>
 <32f1218b-49c3-eeb6-5866-3ec45acbc1c5@kernel.dk> <34857989-ff46-b2a7-9730-476636848acc@samba.org>
 <47c76a83-a449-3a65-5850-1d3dff4f3249@kernel.dk> <09579257-8d8e-8f25-6ceb-eea4f5596eb3@kernel.dk>
 <CAHk-=wgqJdq6GjydKoAb41K9QX5Q8XMLA2dPaM3a3xqQQa_ygg@mail.gmail.com> <f42dcb4e-5044-33ed-9563-c91b9f8b7e64@kernel.dk>
In-Reply-To: <f42dcb4e-5044-33ed-9563-c91b9f8b7e64@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 4 Mar 2021 11:46:52 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj8BnbsSKWx=kUFPqpoohDdPchsW00c4L-x6ES8bOWLSg@mail.gmail.com>
Message-ID: <CAHk-=wj8BnbsSKWx=kUFPqpoohDdPchsW00c4L-x6ES8bOWLSg@mail.gmail.com>
Subject: Re: [PATCH 09/18] io-wq: fork worker threads from original task
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Mar 4, 2021 at 11:19 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> Took a quick look at this, and I agree that's _much_ better. In fact, it
> boils down to just calling copy_process() and then having the caller do
> wake_up_new_task(). So not sure if it's worth adding an
> create_io_thread() helper, or just make copy_process() available
> instead. This is ignoring the trace point for now...

I really don't want to expose copy_process() outside of kernel/fork.c.

The whole three-phase "copy - setup - activate" model is a really
really good thing, and it's how we've done things internally almost
forever, but I really don't want to expose those middle stages to any
outsiders.

So I'd really prefer a simple new "create_io_worker()", even if it's
literally just some four-line function that does

   p = copy_process(..);
   if (!IS_ERR(p)) {
      block all signals in p
      set PF_IO_WORKER flag
      wake_up_new_task(p);
   }
   return p;

I very much want that to be inside kernel/fork.c and have all these
rules about creating new threads localized there.

              Linus
