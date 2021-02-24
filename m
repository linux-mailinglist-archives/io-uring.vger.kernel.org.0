Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175E4324474
	for <lists+io-uring@lfdr.de>; Wed, 24 Feb 2021 20:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236086AbhBXTOK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Feb 2021 14:14:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236096AbhBXTMl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Feb 2021 14:12:41 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB1E5C061574
        for <io-uring@vger.kernel.org>; Wed, 24 Feb 2021 11:11:03 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id w36so4726501lfu.4
        for <io-uring@vger.kernel.org>; Wed, 24 Feb 2021 11:11:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LsetPJB5m47FCg13KC6GjSTLKBsPDI7MuzXhPKMTnS4=;
        b=g0wCVRLuZhRAZSx2tZaeQKkHmjHJt6HcVeX1wF81XK3ID/P21CzwT5FyHF6bzyJiaK
         7Wbpg65iES9Lwj24IG8yT/fkKOgtfPxfvdKC+qXihnsfhzxP5qlnVz0sgNHOO9KXWCV6
         eIoO/wnpUtMRNAs14sprZgujgxrvqBNk1ASSY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LsetPJB5m47FCg13KC6GjSTLKBsPDI7MuzXhPKMTnS4=;
        b=Tp2WV+slZyubaFrR5FD6e2OJ3tsgvrFL7/lZ3sJ/DMxFSmrltSAuSaoB+4x8LP+lhV
         T5xQl6AaIzvLD4Ego3dNQQyk1KLzAfV5vvC3UXPOglG7SU3LHY08Gfb5A5NWSife/gpK
         cH/5Ay6qXnCdLSG+C0oO1lncj/4xFC9L+ScU+yPiywyUOyf5RYdeUZBEVMbIY/NgFXBN
         neKEUC9Lhc2ZqspvcN8MbMQHVQcJifBrc/SXx8/cdyOlr+wQ0B9vTo4NFcHGVeLRDwKg
         Ac7BsoUKiZvYly5pmxxf1jtVhoYNUKV4c8SuWQEkby+kQATKDnBJ05GGGLGsnX/L5fwF
         /GeA==
X-Gm-Message-State: AOAM530MsxqcEWwqdE62aKYU/X+khKsA25CYR57L7RmK3toymabAZZA1
        +b5lArYeZE3QORSJMGX2J8/zt6ygfdlDgQ==
X-Google-Smtp-Source: ABdhPJwoFBqa3nFsXYGZeuEQFC7cZPBxEqOHmLmBZv+fCUveF9cdn9HF7dJIK0/Umga3biZkfS+rnA==
X-Received: by 2002:a05:6512:3a8f:: with SMTP id q15mr19192834lfu.389.1614193862085;
        Wed, 24 Feb 2021 11:11:02 -0800 (PST)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id c11sm649200lfb.104.2021.02.24.11.11.00
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Feb 2021 11:11:00 -0800 (PST)
Received: by mail-lf1-f46.google.com with SMTP id u4so4753948lfs.0
        for <io-uring@vger.kernel.org>; Wed, 24 Feb 2021 11:11:00 -0800 (PST)
X-Received: by 2002:a05:6512:a8c:: with SMTP id m12mr20000602lfu.253.1614193859813;
 Wed, 24 Feb 2021 11:10:59 -0800 (PST)
MIME-Version: 1.0
References: <20210224051845.GB6114@xsang-OptiPlex-9020> <m1czwpl83q.fsf@fess.ebiederm.org>
 <20210224183828.j6uut6sholeo2fzh@example.org>
In-Reply-To: <20210224183828.j6uut6sholeo2fzh@example.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 24 Feb 2021 11:10:43 -0800
X-Gmail-Original-Message-ID: <CAHk-=wh3wVpx97e=n2D98W+PSDWUkQrX3O+c7n7MGRbn_k9JMg@mail.gmail.com>
Message-ID: <CAHk-=wh3wVpx97e=n2D98W+PSDWUkQrX3O+c7n7MGRbn_k9JMg@mail.gmail.com>
Subject: Re: d28296d248: stress-ng.sigsegv.ops_per_sec -82.7% regression
To:     Alexey Gladkov <gladkov.alexey@gmail.com>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        kernel test robot <oliver.sang@intel.com>,
        0day robot <lkp@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org,
        "Huang, Ying" <ying.huang@intel.com>,
        Feng Tang <feng.tang@intel.com>, zhengjun.xing@intel.com,
        io-uring <io-uring@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>,
        Kees Cook <keescook@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Feb 24, 2021 at 10:38 AM Alexey Gladkov
<gladkov.alexey@gmail.com> wrote:
>
> One of the reasons for this is that I rolled back the patch that changed
> the ucounts.count type to atomic_t. Now get_ucounts() is forced to use a
> spin_lock to increase the reference count.

Yeah, that definitely should be an atomic type, since the extended use
of ucounts clearly puts way too much pressure on that ucount lock.

I remember complaining about one version of that patch, but my
complaint wasabout it changing semantics of the saturation logic (and
I think it was also wrong because it still kept the spinlock for
get_ucounts(), so it didn't even take advantage of the atomic
refcount).

Side note: I don't think a refcount_t" is necessarily the right thing
to do, since the ucount reference counter does its own saturation
logic, and the refcount_t version is imho not great.

So it probably just needs to use an atomic_t, and do the saturation
thing manually.

Side note: look at try_get_page(). That one actually does refcounting
with overflow protection better than refcount_t, in my opinion. But I
am obviously biased, since I wrote it ;)

See commits

    88b1a17dfc3e mm: add 'try_get_page()' helper function
    f958d7b528b1 mm: make page ref count overflow check tighter and
more explicit

with that "page->_recount" being just a regular atomic_t.

            Linus
