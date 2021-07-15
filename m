Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCA7B3C9CF2
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 12:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238259AbhGOKlJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 06:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234408AbhGOKlJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 06:41:09 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA5CC061760;
        Thu, 15 Jul 2021 03:38:15 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id x192so8274073ybe.6;
        Thu, 15 Jul 2021 03:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kf//qSKVm8jwV9su5vj/cyZO+d19fZjtVwbyBoOChKM=;
        b=OYWGsPvHAU8pBbGk+jWO0R2YomvuxZLDCdqHykFxmr1t1y4aX0JEsbk+TUHCGG/mgG
         rVj3PhqGDhIN7qr578G1B7V/9HDZVzlFVU+RnSSuQ1a5/YklzWOX3y2eKrxfKdhkdUhd
         tY9Ss1nDJVEXgf1wWZFeXwdUiGq+HeGJDV4ARqwv3a9mdABfXpbu7Hd/rjGMIg2BRfCI
         072uzuott5MJ4gw8WuPwiGxCdzukPjQTYjpgoTiHqLbg8fBi4FS96ypSqNxUHEmjnUh5
         ZKb5P+VBMLMBH1Ac1zjwB3s3MfhKX2ezK+cSNCAuWcMCQQv2W8Q02+XF5Qj0/cy4KV5t
         RbHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kf//qSKVm8jwV9su5vj/cyZO+d19fZjtVwbyBoOChKM=;
        b=YU4oHGMaPRa4bO6DGpLnYrFcKzKIl29xIZhbvtf4/qpt20v+4tZlLwyiLx/84DGCrd
         wpLVqwl2tNnpcHA8zys86TIBaAKz4qAf5Tvse/Y/ClkG5Y9rY9weEdMQxOzKhPRwR+4v
         m5pMeHEO6OTS7JTdO1QX22HiQmt8AtEl//VdgCRX+//z2wwuQryk7drmTuYRqYj1rxIC
         fQAh+0vhoPWx8J0ya/LYxEzRY6rewnJ0nZZMC3KV4PN5pWpbzpkEgsRVINMDfT18b44U
         XRXOsEvAInJuKlvSRdqcKu466GuhGYDUoo/c/0DdJJF6Bm5a6cppd8e+8nsEGKWxnRc2
         B6Sg==
X-Gm-Message-State: AOAM5326TRAKD+5xq7Zr5Vnoa3zKTgRDpT9BY96WI3XUeVgWn62aXJdU
        yFz9eLWW2JtFFK8/ZJzsau4UdnLTUHET5bWbt1zlur4gDVnOxHLQ
X-Google-Smtp-Source: ABdhPJwstwcwWPneKxFLBp6bB4LiIKgddK8ID+0mAvsmceYMtOn+HANvCM+4V/mlvUMx8R+UaB1ixfBJ5P1fCoHgfY8=
X-Received: by 2002:a25:da11:: with SMTP id n17mr4538213ybf.428.1626345494989;
 Thu, 15 Jul 2021 03:38:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210712123649.1102392-1-dkadashev@gmail.com> <20210712123649.1102392-2-dkadashev@gmail.com>
 <20210713145341.lngtd5g3p6zf5eoo@wittgenstein> <CAHk-=wjJeGY0FAs+WLaz-cxjhYcYvF1UXtZVmqoLbZH0jqn0Qg@mail.gmail.com>
In-Reply-To: <CAHk-=wjJeGY0FAs+WLaz-cxjhYcYvF1UXtZVmqoLbZH0jqn0Qg@mail.gmail.com>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Thu, 15 Jul 2021 17:38:03 +0700
Message-ID: <CAOKbgA5HW+OTreZs13zESyV0Osh_1MwmKp8MChu9CL1PkTCQUw@mail.gmail.com>
Subject: Re: [PATCH 1/7] namei: clean up do_rmdir retry logic
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 13, 2021 at 11:58 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Tue, Jul 13, 2021 at 7:53 AM Christian Brauner
> <christian.brauner@ubuntu.com> wrote:
> >
> > Instead of naming all these $something_helper I would follow the
> > underscore naming pattern we usually do, i.e. instead of e.g.
> > rmdir_helper do __rmdir() or __do_rmdir().
>
> That's certainly a pattern we have, but I don't necessarily love it.
>
> It would be even better if we'd have names that actually explain
> what/why the abstraction exists. In this case, it's the "possibly
> retry due to ESTALE", but I have no idea how to sanely name that.
> Making it "try_rmdir()" or something like that is the best I can come
> up with right now.
>
> On  a similar note, the existing "do_rmdir()" and friends aren't
> wonderful names either, but we expose that name out so changing it is
> probably not worth it. But right now we have "vfs_rmdir()" and
> "do_rmdir()", and they are just different levels of the "rmdir stack",
> without the name really describing where in the stack they are.
>
> Naming is hard, and I don't think the double underscores have been
> wonderful either.

Naming *is* hard, I do not have any good ideas here, so I just went with
try_rmdir(). Christian, Linus, let me know if that is not good enough.

-- 
Dmitry Kadashev
