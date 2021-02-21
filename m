Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8038E320853
	for <lists+io-uring@lfdr.de>; Sun, 21 Feb 2021 06:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbhBUFF2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Feb 2021 00:05:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhBUFFX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Feb 2021 00:05:23 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3E2C061574
        for <io-uring@vger.kernel.org>; Sat, 20 Feb 2021 21:04:42 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id e17so45292103ljl.8
        for <io-uring@vger.kernel.org>; Sat, 20 Feb 2021 21:04:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pcexIzuBmz0FYcH9inbNj5BzxQ+60xNhqWH2FoghYLI=;
        b=dYiICboCC/1Nxx+EqFHhbn0ySU6sHqmS/uVZ/wkp0l/vnZnOTGXLhVxzp9aBSPRd98
         VIfmzsfhI2UZcFuWehKxTQKZNRXfp6lxKeJefCu+8vr7Ll+rQqAeg0bT4PYGVRclbxKU
         fRFyrXNcr0Kg2oCd043K8+22smwkLNTE/BJXQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pcexIzuBmz0FYcH9inbNj5BzxQ+60xNhqWH2FoghYLI=;
        b=ri2LArvL5L6Xvj6nSxxZFaEZOq/TRam8SMR5UJg2a5V9Tr1MEf5mkxtS1wxTiE80aj
         sSHj2ncbebDyjt0EcuPevheZkMJGDZ/emkBupGsJA+efKNkhNaF+RX8+Rd2FbYFuml4Q
         yCWRuYgduS2tSuv+cVI6+lYkhNJ73lN99N0ci3fEbuUY9aXZer816W8EP9V/bhLcno+Z
         G2FCKPl3tVfy6X3vnmrH1tUzCRNVItfOUkC5KhzIcbF2rj7/iNKUKFgmHrn3SNqcyAMA
         SAHTHcvw3TmGam0XS30rUSmLjwX95NMTtjt7amI9lXt0uCqMzoDFKT4zjXtKolu+bgfh
         tTGg==
X-Gm-Message-State: AOAM531NpAbGP3xo0UT28xh/SyqSLeeHn8gBuys+taom4WIEGV5mWFy9
        RSF1DTD0B7upc5J2bKvxDXUDstNHHSk+UA==
X-Google-Smtp-Source: ABdhPJw3I49X+LdymWTDZrWi5ewJjkqImj1SCK+P7O3tuE74suPB+WKdFUGOB6qOL5cE8+NFBIBreg==
X-Received: by 2002:ac2:4ed3:: with SMTP id p19mr1821915lfr.648.1613883880697;
        Sat, 20 Feb 2021 21:04:40 -0800 (PST)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id q1sm1439412lfu.48.2021.02.20.21.04.39
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Feb 2021 21:04:40 -0800 (PST)
Received: by mail-lj1-f179.google.com with SMTP id u4so45305506ljh.6
        for <io-uring@vger.kernel.org>; Sat, 20 Feb 2021 21:04:39 -0800 (PST)
X-Received: by 2002:a19:7f44:: with SMTP id a65mr10074526lfd.41.1613883879530;
 Sat, 20 Feb 2021 21:04:39 -0800 (PST)
MIME-Version: 1.0
References: <20210219171010.281878-1-axboe@kernel.dk>
In-Reply-To: <20210219171010.281878-1-axboe@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 20 Feb 2021 21:04:23 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgShFTn_BiVqtFrtL6xnJVUFJ5xFgVeWFHYs7P2ak_5zg@mail.gmail.com>
Message-ID: <CAHk-=wgShFTn_BiVqtFrtL6xnJVUFJ5xFgVeWFHYs7P2ak_5zg@mail.gmail.com>
Subject: Re: [PATCHSET RFC 0/18] Remove kthread usage from io_uring
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 19, 2021 at 9:10 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> tldr - instead of using kthreads that assume the identity of the original
> tasks for work that needs offloading to a thread, setup these workers as
> threads of the original task.

Ok, from a quick look-through of the patch series this most definitely
seems to be the right way to go, getting rid of a lot of subtle (and
not-so-subtle) issues.

                Linus
