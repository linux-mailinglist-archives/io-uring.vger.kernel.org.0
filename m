Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F04A62C8DD
	for <lists+io-uring@lfdr.de>; Wed, 16 Nov 2022 20:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbiKPTV2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Nov 2022 14:21:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbiKPTV2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Nov 2022 14:21:28 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D77F2E
        for <io-uring@vger.kernel.org>; Wed, 16 Nov 2022 11:21:26 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id g62so18397071pfb.10
        for <io-uring@vger.kernel.org>; Wed, 16 Nov 2022 11:21:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=x/Frdrr9T3/J7dJauoN0piz8mbD0jAQ7KYIaSj0qbnU=;
        b=65Zvp5sOXxTtqlS2CUVrfYKhwPZyw2R1ohm7i0QLrac6dByjzi6NSgKhhtNnoX2Xh5
         Df3ncrtFh2ah4L/nlkHAouYm76xl9FpIxMtv+XWGokgr7ytIJL4/lwx2ZVEM7hrqclyG
         J7Qf+UDHc2GT4au3SvwQ4z+I0FsWJa9EC2WXuCB5Ap5l76nPuwU6miDgBdlQP3Fxqkj4
         jfwytxTeA+uiLyXM1rRQ3TioVHpLt0jW142gvFUVUHYGMwGPpwOiYLAHO/OI5ficDTcF
         5XX8cfzzKC88DRsN183EjKDMqkkM/pIJcBpjz6IET8l/yRJezWjA9BOwh4Xr9Tjbmxsk
         QV7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x/Frdrr9T3/J7dJauoN0piz8mbD0jAQ7KYIaSj0qbnU=;
        b=v3nJTxJbyGgaeWCIkPhMQAOiI4bKZLeZ34c/yMfTdVK5aUAZKSP6u0p/My7aU4PaO3
         MLo4dtk8mZXi13XgLtbu1upWPBdnMJ7yQ4VRJcBQ2IxehaPUR76x+tUNa8vh7HeZIIM3
         nxtD3prBdfvr/hRMsMtv+MSmqKXx3AHcin2EeHEiHTicSn/trGtkL7Jw7WtmymY2mLg8
         brrdxzXXh3rZJqSqG7FCDotwpwhrW7wsRT3EDE6q7Y2zSe9NAV/viwvUqGpDUsVcwyfu
         +udx4BuWFgixQ9sBG6erIT774Kjj7s/phWVhZTFl7Yfn/Aj6Lnzx5p2zIM66CeLb6O8R
         4mSg==
X-Gm-Message-State: ANoB5pmVCKJBqhhHSomjVHz38/q9nV2pQBTW4TmphW2Bf3CQQqvOnteo
        kE8Zj3aZOO5NuTRfE4hWFcnvKDUjznNbwiVVoqpF
X-Google-Smtp-Source: AA0mqf6OvVVxiocrrbL9Zw6kBNZGmmkI6GGLhCbzzkwJkLHHAxIjxfEwFzaWeRTAJMG7x4CYp1uEwT7ftQdsWzZdavw=
X-Received: by 2002:a63:5d50:0:b0:460:ec46:3645 with SMTP id
 o16-20020a635d50000000b00460ec463645mr22237856pgm.92.1668626485991; Wed, 16
 Nov 2022 11:21:25 -0800 (PST)
MIME-Version: 1.0
References: <20221116125051.3338926-1-j.granados@samsung.com>
 <CGME20221116125431eucas1p1dfd03b80863fce674a7c662660c94092@eucas1p1.samsung.com>
 <20221116125051.3338926-2-j.granados@samsung.com> <20221116173821.GC5094@test-zns>
In-Reply-To: <20221116173821.GC5094@test-zns>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 16 Nov 2022 14:21:14 -0500
Message-ID: <CAHC9VhSVzujW9LOj5Km80AjU0EfAuukoLrxO6BEfnXeK_s6bAg@mail.gmail.com>
Subject: Re: [RFC 1/1] Use ioctl selinux callback io_uring commands that
 implement the ioctl op convention
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     Joel Granados <j.granados@samsung.com>, ddiss@suse.de,
        mcgrof@kernel.org, linux-security-module@vger.kernel.org,
        io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Nov 16, 2022 at 12:49 PM Kanchan Joshi <joshi.k@samsung.com> wrote:
> On Wed, Nov 16, 2022 at 01:50:51PM +0100, Joel Granados wrote:
> >Signed-off-by: Joel Granados <j.granados@samsung.com>
> >---
> > security/selinux/hooks.c | 15 +++++++++++++--
> > 1 file changed, 13 insertions(+), 2 deletions(-)
> >
> >diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> >index f553c370397e..a3f37ae5a980 100644
> >--- a/security/selinux/hooks.c
> >+++ b/security/selinux/hooks.c
> >@@ -21,6 +21,7 @@
> >  *  Copyright (C) 2016 Mellanox Technologies
> >  */
> >
> >+#include "linux/nvme_ioctl.h"
> > #include <linux/init.h>
> > #include <linux/kd.h>
> > #include <linux/kernel.h>
> >@@ -7005,12 +7006,22 @@ static int selinux_uring_cmd(struct io_uring_cmd *ioucmd)
> >       struct inode *inode = file_inode(file);
> >       struct inode_security_struct *isec = selinux_inode(inode);
> >       struct common_audit_data ad;
> >+      const struct cred *cred = current_cred();
> >
> >       ad.type = LSM_AUDIT_DATA_FILE;
> >       ad.u.file = file;
> >
> >-      return avc_has_perm(&selinux_state, current_sid(), isec->sid,
> >-                          SECCLASS_IO_URING, IO_URING__CMD, &ad);
> >+      switch (ioucmd->cmd_op) {
> >+      case NVME_URING_CMD_IO:
> >+      case NVME_URING_CMD_IO_VEC:
> >+      case NVME_URING_CMD_ADMIN:
> >+      case NVME_URING_CMD_ADMIN_VEC:
>
> We do not have to spell out these opcodes here.
> How about this instead:
>
> +       /*
> +        * nvme uring-cmd continue to follow the ioctl format, so reuse what
> +        * we do for ioctl.
> +        */
> +       if(_IOC_TYPE(ioucmd->cmd_op) == 'N')
> +               return ioctl_has_perm(cred, file, FILE__IOCTL, (u16) ioucmd->cmd_op);
> +       else
> +               return avc_has_perm(&selinux_state, current_sid(), isec->sid,
> +                                   SECCLASS_IO_URING, IO_URING__CMD, &ad);
> +       }
> +
>
> Now, if we write the above fragment this way -
>
> if (__IOC_TYPE(ioucmd->cmd_op) != 0)
>         reuse_what_is_done_for_ioctl;
> else
>         current_check;
>
> That will be bit more generic and can support more opcodes than nvme.
> ublk will continue to fall into else case, but something else (of
> future) may go into the if-part and be as fine-granular as ioctl hook
> has been.
> Although we defined new nvme opcodes to be used with uring-cmd, it is
> also possible that some other provider decides to work with existing
> ioctl-opcode packaged inside uring-cmd and turns it async. It's just
> another implmentation choice.
>
> Not so nice with the above could be that driver-type being 0 seems
> under conflict already. The table in this page:
> https://www.kernel.org/doc/html/latest/userspace-api/ioctl/ioctl-number.html
> But that is first four out of many others. So those four will fall into
> else-part (if ever we get there) and everything else will go into the
> if-part.
>
> Let's see whether Paul considers all this an improvement from what is
> present now.

There are a two things that need consideration:

* The current access control enforces the SELinux io_uring/cmd
permission on all io_uring command passthrough operations, that would
need to be preserved using something we call "policy capabilities".
The quick summary is that policy capabilities are a way for the
SELinux policy to signal to the kernel that it is aware of a breaking
change and the policy is written to take this change into account;
when the kernel loads this newly capable policy it sets a flag which
triggers a different behavior in the kernel.  A simple example can be
found in selinux_file_ioctl(FIONCLEX)/selinux_policycap_ioctl_skip_cloexec(),
but we can talk more about this later if/when we resolve the other
issue.

* As we discussed previously, the real problem is the fact that we are
missing the necessary context in the LSM hook to separate the
different types of command targets.  With traditional ioctls we can
look at the ioctl number and determine both the type of
device/subsystem/etc. as well as the operation being requested; there
is no such information available with the io_uring command
passthrough.  In this sense, the io_uring command passthrough is
actually worse than traditional ioctls from an access control
perspective.  Until we have an easy(ish)[1] way to determine the
io_uring command target type, changes like the one suggested here are
going to be doomed as each target type is free to define their own
io_uring commands.

[1] Yes, one could theoretically make some determination of the target
type by inspecting io_uring_cmd::file::f_op (or similar), but checking
file_operations' function pointers is both a pretty awful layering
violation and downright ugly; I don't want to have to maintain that
long-term in a LSM.

--
paul-moore.com
