Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602502F9511
	for <lists+io-uring@lfdr.de>; Sun, 17 Jan 2021 21:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729936AbhAQUP2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Jan 2021 15:15:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728732AbhAQUPW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Jan 2021 15:15:22 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D02C061573
        for <io-uring@vger.kernel.org>; Sun, 17 Jan 2021 12:14:41 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id m13so16058234ljo.11
        for <io-uring@vger.kernel.org>; Sun, 17 Jan 2021 12:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FrMVxfeB3+KKIBV6QBSYXo4T1vI48P4RMLKoRIf1OUc=;
        b=Gf36Q8ai78kVx9Z3/GXZ67OKv5MBTb+tGROqoFacgXbbIlaG8TvPDg0d+RXn/fc4/Q
         O2jr4S1owdj4WB59GlYsn6A4TYRyJ6J6r57aobiLqISJSe5DSFpdr2HgMHvU3vEGruzH
         9jMYwg0+1DpWroaJ91eWTRYwtKVSCtyrBAhCc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FrMVxfeB3+KKIBV6QBSYXo4T1vI48P4RMLKoRIf1OUc=;
        b=KBNfNr5WLczTudoHAZl0leA+oEtBBIVs4kRVg5IQA9oMM3BNh3+QEgmW18OCgq+8rf
         G/JqYDshvUUYhoXz0Dl7XnpYpamH3LOTF4djEKujL2JQcqsP117Y6NnyMPmXB7s4Josm
         FpAI5ufGYS04DjFTMihfODfGztbvhxCmH9yMC+sr4kor0MTp2PzJc6Hnlc4YBrWYknVP
         QAdUnpL6zhnbUA6by3mFKeC1kphIkX4fWpA99+UnRSuHcqOeJ3ywCJz3Ly0qkHcb8Iug
         tjez1T968KmWeZx2+ad3FOlEI7Xr210wOCzJJcJJFoe8Yxd4QZ6EALaBZOm6hiG1rsRF
         /zvA==
X-Gm-Message-State: AOAM532V5a/2JN2UX1W6bpsOtwQv1DXtecZdlJYQkVe8SZUXxZ3T23c4
        0CnvpaFG7O17ll6vcPydZKReW7Za1yAvVQ==
X-Google-Smtp-Source: ABdhPJzyBdNA+/o4eQbAk/T6p19Zc9xiozi/kj0KufDn6fMDoaAmUUZ/TzBlHi0En8BdafEJ867gdQ==
X-Received: by 2002:a2e:740d:: with SMTP id p13mr9545738ljc.288.1610914479959;
        Sun, 17 Jan 2021 12:14:39 -0800 (PST)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id q19sm1710852lfa.80.2021.01.17.12.14.38
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jan 2021 12:14:38 -0800 (PST)
Received: by mail-lj1-f182.google.com with SMTP id p13so16143140ljg.2
        for <io-uring@vger.kernel.org>; Sun, 17 Jan 2021 12:14:38 -0800 (PST)
X-Received: by 2002:a2e:6f17:: with SMTP id k23mr9059477ljc.411.1610914477750;
 Sun, 17 Jan 2021 12:14:37 -0800 (PST)
MIME-Version: 1.0
References: <01020176e45e6c4d-c15dc1e2-6a6a-407c-a32d-24be51a1b3f8-000000@eu-west-1.amazonses.com>
 <8ba549a0-7724-a42f-bd11-3605ef0bd034@kernel.dk> <01020176e8159fa5-3f556133-fda7-451b-af78-94c712df611e-000000@eu-west-1.amazonses.com>
 <b56ed553-096c-b51a-49e3-da4e8eda8d43@gmail.com> <01020176ed350725-cc3c8fa7-7771-46c9-8fa9-af433acb2453-000000@eu-west-1.amazonses.com>
 <0102017702e086ca-cdb34993-86ad-4ec6-bea5-b6a5ad055a62-000000@eu-west-1.amazonses.com>
 <61566b44-fe88-03b0-fd94-70acfc82c093@kernel.dk> <CAHk-=wh3Agdy3h+rsx5HTOWt6dS-jN9THBqNhk=mWG4KnCK0tw@mail.gmail.com>
 <CAHk-=wiGEFZf-+YXcUVDj_mutwG6qWZzKUKZ-5yQ5UWgLGrBNQ@mail.gmail.com> <0102017711f5dc95-8153416f-4641-4495-9103-82c2744e0d69-000000@eu-west-1.amazonses.com>
In-Reply-To: <0102017711f5dc95-8153416f-4641-4495-9103-82c2744e0d69-000000@eu-west-1.amazonses.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 17 Jan 2021 12:14:21 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjZ_z9radV3bCC5HH7gDJ9-CZNwqE1JYksUpX6GqPRj+w@mail.gmail.com>
Message-ID: <CAHk-=wjZ_z9radV3bCC5HH7gDJ9-CZNwqE1JYksUpX6GqPRj+w@mail.gmail.com>
Subject: Re: Fixed buffers have out-dated content
To:     Martin Raiber <martin@urbackup.org>, Peter Xu <peterx@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Jan 17, 2021 at 12:07 PM Martin Raiber <martin@urbackup.org> wrote:
>
> Thanks! With the patch (skip swapping pinned pages) the problem doesn't
> occur anymore, so it seems to fix it.

Heh, this email came in just as I had committed it to my tree and was
actively writing an email about how you likely wouldn't test it before
I did rc4 because it's a weekend ;)

But since I hadn't pushed it out yet (or done some of the pulls I have
pending), I amended the commit message with your tested-by as well.
Thanks.

It's commit feb889fb40fa ("mm: don't put pinned pages into the swap cache").

I was pretty sure that was the cause from the symptoms you saw, and
the commit explains the whole chain (and explains why the "simple and
stupid" two-liner is actually the right thing to do).

I was very tempted to make the condition for "don't put it into the
swap cache" be much more aggressive, to handle the "GUP with write"
case too, something like

        /* Single mapper, more references than us and the map? */
        if (page_mapcount(page) == 1 && page_count(page) > 2)
                goto keep_locked;

but just using page_maybe_dma_pinned() is the more targeted one for now.

(Added Peter to the cc so that he sees this).

                     Linus
