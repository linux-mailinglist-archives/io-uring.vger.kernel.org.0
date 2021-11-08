Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656934499DD
	for <lists+io-uring@lfdr.de>; Mon,  8 Nov 2021 17:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237209AbhKHQdg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Nov 2021 11:33:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232506AbhKHQdg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Nov 2021 11:33:36 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0706C061570
        for <io-uring@vger.kernel.org>; Mon,  8 Nov 2021 08:30:51 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id bf8so10474678oib.6
        for <io-uring@vger.kernel.org>; Mon, 08 Nov 2021 08:30:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2NLlko22ws9u3osm/QBjCUdE0DTuITdkkMKME+p3p0k=;
        b=RMvOlXp+BAtFmQ22eDRiZ6o7HlYtZ0K/HIZQC8DKgzazdP/Fbk7Ouekea1OUJI9Gam
         lHF7H0VmNwFV4iWzjG15cVo+UldlEa6otM+Ny+tmxdnmd00l7yUz0iIwAZ/yzcASgQxl
         Su7LGJtWS3xwi3aYGYdZF02kjpZytI8ooH7RVh5iIvD+VOQw8WfNIO4EzXeUO8T3RmfH
         s4URQRUZo6j+/0I7igUSIRfolN2mTmhSs2DIWBA0Nkn9rJC0Vtujwqmo8QT/Q8skF7W9
         FVmqum+tmF4k58ooabwvOMeSmFW4lHv/iE3Hd0DvvUZWlMDfRJw2VRNIvBYzI7ZJ5Hvt
         IX4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2NLlko22ws9u3osm/QBjCUdE0DTuITdkkMKME+p3p0k=;
        b=V1kPQaqO911wgtwHyrFwnzHlvUfU253LbmvXrw/WLQBRbtfiTK8VPbzsDy6RguSfzU
         BgtECvdxGp/P1SufvuNX3GnTwH3IVhdAS+Xnoejw/F1E8HW0t2m5C4QjdrjZ1GRXU1cq
         TYJd74PXIc/TGp+TLyLWGQhct5a94aNUYf+6AaRbMCRjjnvePE5obpL5SEgmoHo1niCC
         ieiPsRY+6Y3CUKAgb3xvyET6ZHQdBiDSV38s+uMgn1RCfv828QVU64rNa/SajBJxIcgG
         4vq4twFexYDg2WUXEFxa1CGIILLTRQZJFDGwDbAOzfUM3OD3FuOke6UCxMkCaWSypeho
         PH9g==
X-Gm-Message-State: AOAM533oowndIFYnulPjtajfQAYSFM9u8eOxZmowmbXUrLP08W/RpLaO
        Pg7jhvD2t8aNw5ZbctTz8f8fONgqz3ygZUiYSeG3Jg==
X-Google-Smtp-Source: ABdhPJxC4W/TmdRgvFfio+0JxJwA1O2TIYI9TSyleeOlIQ5U1De25vZ9O6YuZ4Nz05csB5d6H/FDXyeXnk8KKLSGXnk=
X-Received: by 2002:a54:4390:: with SMTP id u16mr333430oiv.109.1636389050790;
 Mon, 08 Nov 2021 08:30:50 -0800 (PST)
MIME-Version: 1.0
References: <0000000000007a0d5705cfea99b2@google.com> <0935df19-f813-8840-fa35-43c5558b90e7@kernel.dk>
 <CANp29Y4hi=iFti=BzZxEEPgnn74L80fr3WXDR8OVkGNqR9BOLw@mail.gmail.com> <97328832-70de-92d9-bf42-c2d1c9d5a2d6@kernel.dk>
In-Reply-To: <97328832-70de-92d9-bf42-c2d1c9d5a2d6@kernel.dk>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 8 Nov 2021 17:30:39 +0100
Message-ID: <CACT4Y+a05_HXcUfooYP5Jp2V5QsxB6zoSZKM6g6P3DiVWUvcyg@mail.gmail.com>
Subject: Re: [syzbot] WARNING in io_poll_task_func (2)
To:     Jens Axboe <axboe@kernel.dk>,
        syzkaller <syzkaller@googlegroups.com>
Cc:     Aleksandr Nogikh <nogikh@google.com>,
        syzbot <syzbot+804709f40ea66018e544@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiaoguang.wang@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 4 Nov 2021 at 12:44, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 11/4/21 4:45 AM, Aleksandr Nogikh wrote:
> > Hi Jeans,
> >
> > We'll try to figure something out.
> >
> > I've filed an issue to track progress on the problem.
> > https://github.com/google/syzkaller/issues/2865
>
> Great thanks. It's annoyed me a bit in the past, but it's really
> excessive this time around. Probably because that particular patch
> caused more than its fair share of problems, but still shouldn't
> be an issue once it's dropped from the trees.

syzbot always tests the latest working tree. In this case it's the
latest linux-next tree. No dead branches were tested.

The real problem here is rebased trees and dropped patches and the use
of "invalid" command.
For issues fixed with a commit (#syz fix) syzbot tracks precisely when
the commit reaches all of the tested builds and only then closes the
issue and starts reporting new occurrences as new issues.
But "syz invalid" does not give syzbot a commit to track and means
literally "close now", so any new occurrences are reported as new
issues immediately.
The intention is that it's on the user issuing the "invalid" command
to do this only when the issue is really not present in any of syzbot
builds anymore.
There are hacks around like saying "syz fix" with some unrelated later
commit that will reach linux-next upstream along with the dropped
patch, then syzbot will do proper tracking on its own.
Better suggestions are welcome.

I think https://github.com/google/syzkaller/issues/2865 will help only
in very limited number of cases (no reproducer, can't determine the
subsystem tree") and in some cases can make things worse (falsely
deciding to not report a real bug).
