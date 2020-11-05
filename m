Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE2A2A7EC0
	for <lists+io-uring@lfdr.de>; Thu,  5 Nov 2020 13:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730465AbgKEMgw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Nov 2020 07:36:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729992AbgKEMgl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Nov 2020 07:36:41 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37391C0613CF
        for <io-uring@vger.kernel.org>; Thu,  5 Nov 2020 04:36:41 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id z2so1212659ilh.11
        for <io-uring@vger.kernel.org>; Thu, 05 Nov 2020 04:36:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=4drRpkMzk7c9vMVuCFMe6QeS6svk8sVYV6Wo0B6UTgU=;
        b=uF7ceb4ECSXyaytY9bzjewwVtNY6cUDChRCwt2s1UyKcu7ra0izetRwHDmxX+7qFMX
         jx9D5spGXnb8WeIONMlwYvRMq8gB2IDVFg70dBQcg8ysMzbQR76xMRqQZPGI3BeZigi1
         rNrYLUdmz+iKHny2rrobbFKxiWxvM3QPKAtjJUAvzzPte7/G+bjqGRG53y4G7u+lpLSw
         X2PaMe8pizjeYoYN1DDO1M3KJBEGvGYJIICuPAx/Rb5FBHR5BvnnGnpFYEXSvT/9Gc1N
         c5+t2c5YtW2B59lV7siH3jZ8LwlHJMSQEp1YEmWUYGniJROn8DF869wygzjPjIUkNJ4w
         6tMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=4drRpkMzk7c9vMVuCFMe6QeS6svk8sVYV6Wo0B6UTgU=;
        b=U87slg7v+fGPciOdr/G1NDTriC+/Cm9xmlv5rowZk22oM3+N52RCf6rl03Sw9TfoUU
         nGWOgb38O5iPn5XZ/WYJAHQPK8xG0uX1x/RuLOpaKwV0TSodaqdsDZtmAINuNeSHgTKn
         sNRDB9h0lxy16yzokphOs+1oXfamyVTQ60O8rFkjI5yV+DeG6ydG2Q/CsV2Ai6Jn0yCK
         TaEeV8flFMx6G0HRsoQoWSH7rLJQC/zDqga5M48YffzT+m354XzESrc9Ijl1wXBFlpUz
         l2yeiOilL/4tr9+NuuC3jYmCgVD2SfBHvv3OIoyXomeRrWEMgUwyAgmr8ynydywCrvUj
         geCw==
X-Gm-Message-State: AOAM533rL0j+A8PnQSQJ/owzn8SehbqZzyYIEgRF6dvHhVomRDlsfRx8
        3B7NGtxvMbRNARklpPx9Kop3LRo6g/j3c86B41vtATT5HIc=
X-Google-Smtp-Source: ABdhPJzR/KsWOrQYte8siVN4rev5TqfpO7lWZGymV/Y+Z8DGtNoIuhv1at8s3sI5N/AxMdRwTCjS+zrd2Msl6U21W94=
X-Received: by 2002:a92:dac1:: with SMTP id o1mr1461013ilq.191.1604579799805;
 Thu, 05 Nov 2020 04:36:39 -0800 (PST)
MIME-Version: 1.0
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Thu, 5 Nov 2020 19:36:28 +0700
Message-ID: <CAOKbgA5ojRs0xuor9TEtBEHUfhEj5sJewDoNgsbAYruhrFmPQw@mail.gmail.com>
Subject: Use of disowned struct filename after 3c5499fa56f5?
To:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

I am trying to implement mkdirat support in io_uring and was using
commit 3c5499fa56f5 ("fs: make do_renameat2() take struct filename") as
an example (kernel newbie here). But either I do not understand how it
works, or on retry struct filename is used that is not owned anymore
(and is probably freed).

Here is the relevant part of the patch:

diff --git a/fs/namei.c b/fs/namei.c
index d4a6dd772303..a696f99eef5c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4346,8 +4346,8 @@ int vfs_rename(struct inode *old_dir, struct
dentry *old_dentry,
 }
 EXPORT_SYMBOL(vfs_rename);

-static int do_renameat2(int olddfd, const char __user *oldname, int newdfd,
-                       const char __user *newname, unsigned int flags)
+int do_renameat2(int olddfd, struct filename *oldname, int newdfd,
+                struct filename *newname, unsigned int flags)
 {
        struct dentry *old_dentry, *new_dentry;
        struct dentry *trap;
@@ -4359,28 +4359,28 @@ static int do_renameat2(int olddfd, const char
__user *oldname, int newdfd,
        struct filename *to;
        unsigned int lookup_flags = 0, target_flags = LOOKUP_RENAME_TARGET;
        bool should_retry = false;
-       int error;
+       int error = -EINVAL;

        if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE | RENAME_WHITEOUT))
-               return -EINVAL;
+               goto put_both;

        if ((flags & (RENAME_NOREPLACE | RENAME_WHITEOUT)) &&
            (flags & RENAME_EXCHANGE))
-               return -EINVAL;
+               goto put_both;

        if (flags & RENAME_EXCHANGE)
                target_flags = 0;

 retry:
-       from = filename_parentat(olddfd, getname(oldname), lookup_flags,
-                               &old_path, &old_last, &old_type);
+       from = filename_parentat(olddfd, oldname, lookup_flags, &old_path,
+                                       &old_last, &old_type);

With the new code on the first run oldname ownership is released. And if
we do end up on the retry path then it is used again erroneously (also
`from` was already put by that time).

Am I getting it wrong or is there a bug?

do_unlinkat that you reference does things a bit differently, as far as
I can tell the problem does not exist there.

Thanks,
Dmitry
