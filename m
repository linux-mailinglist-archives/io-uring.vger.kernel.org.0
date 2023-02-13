Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B185694465
	for <lists+io-uring@lfdr.de>; Mon, 13 Feb 2023 12:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbjBML1v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Feb 2023 06:27:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbjBML1u (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Feb 2023 06:27:50 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0465FBC
        for <io-uring@vger.kernel.org>; Mon, 13 Feb 2023 03:27:48 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id v17so18416316lfd.7
        for <io-uring@vger.kernel.org>; Mon, 13 Feb 2023 03:27:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Cl0w281rrFrfhiUIdTV/d0ugreNYcSHFpO/ECMy29TE=;
        b=e7bciKYc6sFsjk66Q2HY2bAREKMTKUlPhq4a9cTOXcz1xyZcTqDqJymjO7IWB1Ylul
         IlpvnU0C3ApkMvJ83gxB5SGPm6ITtDB437l8wLQolVA6ASC7B2Zorv70J4IXa3U9roSV
         JkHZUH0H6nwWXDS8chRMrz0tJNU8lARg6vWJRxRa95lOzSb48KbOXUbv/nOp0xQNBdMY
         F+plOIGaSRi0g1Vn89ibIzo6wkezIdJyNj8xa6298uzNvgs01+4mRdWW6bTqANcdHWj2
         vYDLQ1svqIePbs+6IH7B8EmKzMsT6L7sE0iHj5ZQw9PTf+W3h+V2He4mBCMrKSxqygTq
         z3ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Cl0w281rrFrfhiUIdTV/d0ugreNYcSHFpO/ECMy29TE=;
        b=7L9JNWOOmsug+6/MbOBnHLrgn+Y30Ck29e/Q5dqe0Dr+NUMa8kCimSCFI1TMPdHRXg
         eXd3h+/auO5Hay69W2oAQtkocpoicidnSAx8pl7jUX90tvBWfzLd2wy26zmXpCukuQY/
         QkhAd3xWBYp8s19TvvBy9/X/nPpfhR28wkXi0UUhpX8phwF1XVtjYFbljamPerKPRJRf
         wqHLIu64U2r+02ojvFTZp676lyawXmatK2XaWM2WM3TSKUi4WcYMJ+uUpVbMJOulaR2Y
         5vjS9fPD4x6rqK54gyxAz0w+URWj/QL1pbFxVWP7CH83yAPxcWz6sj6SweC76mh9iNja
         rAmg==
X-Gm-Message-State: AO0yUKUe/DuM5b/lqUW3MBl+/+J7Udkrp9/zKYIF9Vy9qpcoMR9eVbPH
        8vJ65eg/4bhRMvCElIeovthkDUroYPVutO0GjXcRWA==
X-Google-Smtp-Source: AK7set9Nl/fvndCdrr+yNaVI5IGwWhni0J8QZf0QgFahmTSlmPC8iGZMyNCszJ0uH0PTSG7uUARRT9CfcMYfkF9H8vk=
X-Received: by 2002:a05:6512:3771:b0:4db:19fb:6aa with SMTP id
 z17-20020a056512377100b004db19fb06aamr2590302lft.185.1676287666179; Mon, 13
 Feb 2023 03:27:46 -0800 (PST)
MIME-Version: 1.0
References: <00000000000088b3d905f46ed421@google.com> <B83C9F6F-569B-4DCB-9FFE-45D9B1E32B21@kernel.org>
In-Reply-To: <B83C9F6F-569B-4DCB-9FFE-45D9B1E32B21@kernel.org>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 13 Feb 2023 12:27:33 +0100
Message-ID: <CACT4Y+YVXqD_LPpD05B34VRWvnOE-REDsZSeomggT+uqJmgjyw@mail.gmail.com>
Subject: Re: [syzbot] BUG: bad usercopy in io_openat2_prep
To:     Kees Cook <kees@kernel.org>
Cc:     syzbot <syzbot+cdd9922704fc75e03ffc@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, keescook@chromium.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, syzkaller-bugs@googlegroups.com,
        io-uring@vger.kernel.org, Aleksandr Nogikh <nogikh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 13 Feb 2023 at 12:05, Kees Cook <kees@kernel.org> wrote:
>
> On February 11, 2023 8:08:52 AM PST, syzbot <syzbot+cdd9922704fc75e03ffc@syzkaller.appspotmail.com> wrote:
> >Hello,
> >
> >syzbot found the following issue on:
> >
> >HEAD commit:    ca72d58361ee Merge branch 'for-next/core' into for-kernelci
> >git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> >console output: https://syzkaller.appspot.com/x/log.txt?x=14a882f3480000
> >kernel config:  https://syzkaller.appspot.com/x/.config?x=f3e78232c1ed2b43
> >dashboard link: https://syzkaller.appspot.com/bug?extid=cdd9922704fc75e03ffc
> >compiler:       Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2
> >userspace arch: arm64
> >syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1203777b480000
> >C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=124c1ea3480000
> >
> >Downloadable assets:
> >disk image: https://storage.googleapis.com/syzbot-assets/e2c91688b4cd/disk-ca72d583.raw.xz
> >vmlinux: https://storage.googleapis.com/syzbot-assets/af105438bee6/vmlinux-ca72d583.xz
> >kernel image: https://storage.googleapis.com/syzbot-assets/4a28ec4f8f7e/Image-ca72d583.gz.xz
> >
> >IMPORTANT: if you fix the issue, please add the following tag to the commit:
> >Reported-by: syzbot+cdd9922704fc75e03ffc@syzkaller.appspotmail.com
> >
> >usercopy: Kernel memory overwrite attempt detected to SLUB object 'pid' (offset 24, size 24)!
>
> This looks like some serious memory corruption. The pid slab is 24 bytes in size, but struct io_open is larger... Possible UAF after the memory being reallocated to a new slab??

We've just noticed that some of syzbot arm64 configs did not enable
KASAN, so it could produce false one-off reports caused by previous
silent memory corruptions.

So if you don't see anything obvious, don't spend too much time looking at it.

#syz invalid


> -Kees
>
> > [...]
> >Call trace:
> > usercopy_abort+0x90/0x94
> > __check_heap_object+0xa8/0x100
> > __check_object_size+0x208/0x6b8
> > io_openat2_prep+0xcc/0x2b8
> > io_submit_sqes+0x338/0xbb8
> > __arm64_sys_io_uring_enter+0x168/0x1308
> > invoke_syscall+0x64/0x178
> > el0_svc_common+0xbc/0x180
> > do_el0_svc+0x48/0x110
> > el0_svc+0x58/0x14c
> > el0t_64_sync_handler+0x84/0xf0
> > el0t_64_sync+0x190/0x194
>
>
>
> --
> Kees Cook
