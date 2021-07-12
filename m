Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C73F83C5C70
	for <lists+io-uring@lfdr.de>; Mon, 12 Jul 2021 14:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbhGLMoO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Jul 2021 08:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbhGLMoO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Jul 2021 08:44:14 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCD6C0613DD;
        Mon, 12 Jul 2021 05:41:25 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id y38so28714098ybi.1;
        Mon, 12 Jul 2021 05:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g6MuB/0ClteNwt/zlHeupKaM9i5wUB4Af5cH6F+dwBc=;
        b=jyC7c5b9JFOsxTEWNTVfttSJw3iqMoF5IU1YVyvRelokt7SSrApLTh7y1VTrG2Lb3l
         JvvhI3mwp5slu+ii7zXzBY4Zwqqzh8GSGedn/9cYE/sqGcLCvlMgRFxyADwkAM70UEtl
         FsCXIzAk3KQbtSlmHItGSx9AABnUA4mW04q0aeiAi+5isivpbDpa8VlsGIZTz0a93Pt3
         Outucu23QgKFVXYboHOPFb7xexV1dlpL4CeISnCN0IvTHRmjcqMeSkuzuKRVkbzfHM5l
         C9t30IRXYW33KyUPFrAZKY50/bvavUqXRzAB+64ATVvnmBzc3nwJxV2XE6RdXyZWAR4f
         W/Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g6MuB/0ClteNwt/zlHeupKaM9i5wUB4Af5cH6F+dwBc=;
        b=m61o+BVVNWoRq54ipfQ+EXL1jTqSysfrEmCQZ8KN0r1qwQ0+3QCcZkoIqRmOHns+li
         kSC0vr5jCqSsbUU2MIyk2cDndlRKfVInz+haJIphwG1GS2PeJxZOw9CenIX83zJ9G5Xs
         5O/IeIgx5esUx0sU1qVbWfjxILsD/qNx/adF5oZ+IqiR7qfRzwYKhZVLU9QdnuoynoDB
         AMI6xonMirdLUOYYLcQjfi42OR1ZzUDxs76sGN0S4DJfH+2k2Iuk0zpB8koPd+0itFQI
         DLxSPfH+8lsZVUfrCb2yEcDB5OzCXSTRh/Fee4M8ZJR/fN9YpwaxCdK5T+Zc/lU4Lfir
         CNkQ==
X-Gm-Message-State: AOAM532y4K3/aSmkYrQb7rbkANmvEKXSBWbJbAMrbJQ1fGeI5cXRWTO2
        iZBPv+f2eQ1eDC9OWk14cIMvyERF1C3zLMLWNTc=
X-Google-Smtp-Source: ABdhPJyEHMmrsrXR6ZEJArSXRHYrqP47uUa9Xu74UqxDiXoJDut/RLOyzihaVUwM5CK1nRBenIZUIIhPN1xLADCEijU=
X-Received: by 2002:a25:b886:: with SMTP id w6mr11757370ybj.167.1626093685303;
 Mon, 12 Jul 2021 05:41:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210712123649.1102392-1-dkadashev@gmail.com>
In-Reply-To: <20210712123649.1102392-1-dkadashev@gmail.com>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Mon, 12 Jul 2021 19:41:14 +0700
Message-ID: <CAOKbgA4EqwLa3WDK_JcxFAU92pBw4hS8vjQ9p7B-w+5y7yX5Eg@mail.gmail.com>
Subject: Re: [PATCH 0/7] namei: clean up retry logic in various do_* functions
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jul 12, 2021 at 7:37 PM Dmitry Kadashev <dkadashev@gmail.com> wrote:
>
> Suggested by Linus in https://lore.kernel.org/io-uring/CAHk-=wh=cpt_tQCirzFZRPawRpbuFTZ2MxNpXiyUF+eBXF=+sw@mail.gmail.com/
>
> This patchset does all the do_* functions one by one. The idea is to
> move the main logic to a helper function and handle stale retries /
> struct filename cleanups outside, which makes the logic easier to
> follow.
>
> There is one minor change in the behavior: filename_lookup() /
> filename_parentat() / filename_create() do their own retries on ESTALE
> (regardless of flags), and previously they were exempt from retries in
> the do_* functions (but they *were* called on retry - it's just the
> return code wasn't checked for ESTALE). And now the retry is done on
> the upper level, and so technically it could be called a behavior
> change. Hopefully it's an edge case where an additional check does not
> matter.
>
> On top of https://lore.kernel.org/io-uring/20210708063447.3556403-1-dkadashev@gmail.com/

Since this is on top of the stuff that is going to be in the Jens' tree
only until the 5.15 merge window, I'm assuming this series should go
there as well.

-- 
Dmitry Kadashev
