Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0F57294B04
	for <lists+io-uring@lfdr.de>; Wed, 21 Oct 2020 12:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409357AbgJUKCn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Oct 2020 06:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405683AbgJUKCn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Oct 2020 06:02:43 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27152C0613D2
        for <io-uring@vger.kernel.org>; Wed, 21 Oct 2020 03:02:43 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id t20so731137qvv.8
        for <io-uring@vger.kernel.org>; Wed, 21 Oct 2020 03:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xnb4S5hkq6BURUu/rhTqWY2zD92VHkscM9v42h9u1pw=;
        b=hPrRgAJdSC9qgVYpqs58Djiy9jW7qX/2bOcA8PsLyLnk3K1IGTECBQ/KiluBPINYDQ
         qZr5HUze1+k8N4bzqGycnnB+OTxTqaO/om2fNwBIUYiQEP0RvCVUhhVMzVnu7bdh+FaX
         5VCndHuJIIwBX51m5oEzhCp7InBg1Mh5BkLffXNCXvQWEE3OlSLfHj/1mIGnzUoIAxX+
         xKm/sz4YuuMm+Kz670DVwS25DzZI/nbKmlnEOooY7MfRJrUDRvrRAdPwZqijX6Tv00Zx
         pk3Qat3/7503P5DLdrupPPH7m+tr/vnMAMNfWv1MQQOcW1OgKuQWM1a2NyUJnLu8gwtM
         Lf9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xnb4S5hkq6BURUu/rhTqWY2zD92VHkscM9v42h9u1pw=;
        b=LiBomvahleu+Kz8rDo3oidVF0aG1rxMq0HZWSgd8Ek3TUYLbMd1lCYe9Ncp963mJaC
         PlYfiTLVpw7V1TQKreTR+FuTXk9TbhCng4onT6qaPQBRwHdANqQOzIysOFAk7cCNVvYy
         q0CxuIBhkbIghWpNOHFmGymii49aLZVyzvXxag8ykpD6IlIuOUqBiqUCGAfRZVH+JmLb
         ZPmn6f1oYeRhaW0CN/Q71RF3okBxfXyX0jgzppH8RJ2sIT/xu4hHfa24IlDCGbWp9tdc
         KDqDqGZ8DbzV0BIpZgu4QRYuQqJ1gVzkNFWqnypy+2VICraQxuGgSVPMfGiw2bOp/Ez6
         eMxQ==
X-Gm-Message-State: AOAM532T1epRSgvxPAKtZPl6IrxmUk/Lt+x7pdRM1wb8a0TjDXNzsjJH
        MVmch0iXcE+iNH0Ws5ajH9M9caYTKdgixeGqIcLfZQ==
X-Google-Smtp-Source: ABdhPJxh8i5rMjF7h2nMwGGOMnC8tgzLYSjRpt6RrRJ5khqmyTmwJYQMBrV92PQMbIU+pniLsWEpTce2a2RX9VFcM/8=
X-Received: by 2002:a0c:ba2a:: with SMTP id w42mr1949961qvf.23.1603274561877;
 Wed, 21 Oct 2020 03:02:41 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000010295205b1c553d5@google.com> <a7cac632aa89ed30c5c6deb9c67f428810aed9cb.camel@lca.pw>
 <1039be9b-ddb9-4f76-fda3-55d10f0bd286@kernel.dk>
In-Reply-To: <1039be9b-ddb9-4f76-fda3-55d10f0bd286@kernel.dk>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 21 Oct 2020 12:02:30 +0200
Message-ID: <CACT4Y+YB=co8j2Hv1EhfnfEH0Qj9f=OtTXO=X3Wtu1=aBeAR1A@mail.gmail.com>
Subject: Re: WARNING: suspicious RCU usage in io_init_identity
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Qian Cai <cai@lca.pw>, io-uring@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        syzbot <syzbot+4596e1fcf98efa7d1745@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Oct 16, 2020 at 5:05 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 10/16/20 9:02 AM, Qian Cai wrote:
> > On Fri, 2020-10-16 at 01:12 -0700, syzbot wrote:
> >> Hello,
> >>
> >> syzbot found the following issue on:
> >>
> >> HEAD commit:    b2926c10 Add linux-next specific files for 20201016
> >> git tree:       linux-next
> >> console output: https://syzkaller.appspot.com/x/log.txt?x=12fc877f900000
> >> kernel config:  https://syzkaller.appspot.com/x/.config?x=6160209582f55fb1
> >> dashboard link: https://syzkaller.appspot.com/bug?extid=4596e1fcf98efa7d1745
> >> compiler:       gcc (GCC) 10.1.0-syz 20200507
> >>
> >> Unfortunately, I don't have any reproducer for this issue yet.
> >>
> >> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> >> Reported-by: syzbot+4596e1fcf98efa7d1745@syzkaller.appspotmail.com
> >>
> >> =============================
> >> WARNING: suspicious RCU usage
> >> 5.9.0-next-20201016-syzkaller #0 Not tainted
> >> -----------------------------
> >> include/linux/cgroup.h:494 suspicious rcu_dereference_check() usage!
> >
> > Introduced by the linux-next commits:
> >
> > 07950f53f85b ("io_uring: COW io_identity on mismatch")
> >
> > Can't find the patchset was posted anywhere. Anyway, this should fix it?
>
> It's just in testing... I already folded in this change.

Now that it's in linux-next we can close this report:

#syz fix: io_uring: COW io_identity on mismatch
