Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB41410E76
	for <lists+io-uring@lfdr.de>; Mon, 20 Sep 2021 04:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbhITCq3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Sep 2021 22:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbhITCq3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Sep 2021 22:46:29 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FAA6C061760
        for <io-uring@vger.kernel.org>; Sun, 19 Sep 2021 19:45:03 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id n10so54509272eda.10
        for <io-uring@vger.kernel.org>; Sun, 19 Sep 2021 19:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=3Ifk3gkF4EZgOSOMd5BgLpaHigpIrEHERLHWxDsnhms=;
        b=LVf1yeUaOvahbvnAr8QSl4J6ZtcbeULCwPTL7dt53FaJqSzp6G2JD/v8RAm+KDo8sc
         1qAdKYmaeRzsm7I3CY1R1cnpCx+XM862SyESXguq2cv13yt5vMg1VMR4JFhGE4vfhoKk
         w8FVR6rMzHt8XvuNyTW6Ztp7bihmi8Iypi1Iisxahzi1iAxmuj1yVBWgavP0uthDHohY
         lvKtLRtrDQLxh5uiOZNgN/MaR4JIYdgjHT8oMYOZiABn2JTBBFrxq0vBroAsfzZG0X3A
         o05l6ouifQ63PVw5owy9FwvYWmqGfcvrcVTtTDeJkvIMcYW7WHBeZl73sqRhvcmhAGOR
         DzCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=3Ifk3gkF4EZgOSOMd5BgLpaHigpIrEHERLHWxDsnhms=;
        b=65g7WBDeeT0KEnyfSG7/8PuR7gXRhtwFfrbFf0DBbvgJm4VKOm+o2DgehkUcE87h13
         jwbZT/wVMbYME9BPb8Eg2qq/02pbbjQchSgBLw7e7rYY5oBMnvOpqDCtPSlsNYc/rZ7B
         pU0Uz6DYx27uEkd6F8zmhGqnSHrQwSsjh/8n6DzMb07NWtdElvtSMDfQmQdfceps9aj/
         Mxp2CTBsyyL5lMVcggmqyTBDz+luffUMlAyAxfCLulmelmyitRsM7d5ukRcyWzoOWisT
         JSjNwTn6+PnNuRLBXOfdA2cFTYhrvkn7RBHobjUtdq8HGrpc9/pbwKFozRrbiT90qMqV
         jwCw==
X-Gm-Message-State: AOAM532o9/elOmSTvsjozrTU/QQGek132NB1PzI0Z6DB7FrH5edHqcm0
        p7MLbE+3UzIzwDSy27JfcszWYDo6cdHcHFK4iIQs
X-Google-Smtp-Source: ABdhPJw2UlastqklS4OK5FaL+3CWPBvyDVpEb1e1t4MZvuTxLVTwSniWgJwO2vosjrYuK5Il/R6vvtG2InMyHm29HSQ=
X-Received: by 2002:a50:cf48:: with SMTP id d8mr16576051edk.293.1632105901532;
 Sun, 19 Sep 2021 19:45:01 -0700 (PDT)
MIME-Version: 1.0
References: <163172413301.88001.16054830862146685573.stgit@olly>
In-Reply-To: <163172413301.88001.16054830862146685573.stgit@olly>
From:   Paul Moore <paul@paul-moore.com>
Date:   Sun, 19 Sep 2021 22:44:50 -0400
Message-ID: <CAHC9VhSn3pvUgUo5_T=TfiBXw3=f6Pn6GaAUVS=jfg-Kfr_ZEw@mail.gmail.com>
Subject: Re: [PATCH v4 0/8] Add LSM access controls and auditing to io_uring
To:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Sep 15, 2021 at 12:49 PM Paul Moore <paul@paul-moore.com> wrote:
>
> A quick update to the v3 patchset with a small change to the audit
> record format (remove the audit login ID on io_uring records) and
> a subject line fix on the Smack patch.  I also caught a few minor
> things in the code comments and fixed those up.  All told, nothing
> significant but I really dislike merging patches that haven't hit
> the list so here ya go ...
>
> As a reminder, I'm planning to merge these in the selinux/next tree
> later this week and it would be *really* nice to get some ACKs from
> the io_uring folks; this patchset is implementing the ideas we all
> agreed to back in the v1 patchset so there shouldn't be anything
> surprising in here.
>
> For reference the v3 patchset can be found here:
> https://lore.kernel.org/linux-security-module/163159032713.470089.11728103630366176255.stgit@olly/T/#t
>
> Those who would prefer to fetch these patches directly from git can
> do so using the tree/branch below:
> git://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/selinux.git
>  (checkout branch "working-io_uring")
>
> ---
>
> Casey Schaufler (1):
>       Smack: Brutalist io_uring support
>
> Paul Moore (7):
>       audit: prepare audit_context for use in calling contexts beyond syscalls
>       audit,io_uring,io-wq: add some basic audit support to io_uring
>       audit: add filtering for io_uring records
>       fs: add anon_inode_getfile_secure() similar to anon_inode_getfd_secure()
>       io_uring: convert io_uring to the secure anon inode interface
>       lsm,io_uring: add LSM hooks to io_uring
>       selinux: add support for the io_uring access controls
>
>
>  fs/anon_inodes.c                    |  29 ++
>  fs/io-wq.c                          |   4 +
>  fs/io_uring.c                       |  69 +++-
>  include/linux/anon_inodes.h         |   4 +
>  include/linux/audit.h               |  26 ++
>  include/linux/lsm_hook_defs.h       |   5 +
>  include/linux/lsm_hooks.h           |  13 +
>  include/linux/security.h            |  16 +
>  include/uapi/linux/audit.h          |   4 +-
>  kernel/audit.h                      |   7 +-
>  kernel/audit_tree.c                 |   3 +-
>  kernel/audit_watch.c                |   3 +-
>  kernel/auditfilter.c                |  15 +-
>  kernel/auditsc.c                    | 469 ++++++++++++++++++++++------
>  security/security.c                 |  12 +
>  security/selinux/hooks.c            |  34 ++
>  security/selinux/include/classmap.h |   2 +
>  security/smack/smack_lsm.c          |  46 +++
>  18 files changed, 646 insertions(+), 115 deletions(-)

With no serious objections or outstanding comments, I just merged
these patches into selinux/next.  If anyone has any follow-on patches
please base them against selinux/next, thanks.

-- 
paul moore
www.paul-moore.com
