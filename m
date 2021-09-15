Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02D6E40CB09
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 18:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhIOQus (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 12:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbhIOQuk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 12:50:40 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23312C061575
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 09:49:21 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id u4so2274272qvb.6
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 09:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=subject:from:to:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=tZwBVZ5ivrPb6DCSmr/gfWXOF5H7MpGJkku89V1qfH0=;
        b=GmYCadx8bMhGbpmSXQkaENi2AwpsDk4eicoMJAb8ftUwKq8x4RRfBTKM3YrGwJXIcK
         LTK6/KOqdno7n7n/55XdVcVV23K7/9TedZipQAkrJVt9BcIZsNpl8JYvQOP7jTlkWoeS
         IAmFraZ0WZGN9UOPi3qaJYgrE/bpl69T7juHgOdJBV+YMrSOGrQL5mY0nPqzlJKsHlgc
         W/BkFiRcn58ZyCHY7Y7xVr20AzfPaXsL5J3W/BakFi4bUrDljf6RTA71kzPXXaoC+SAP
         MWjc7HE3QZxgCn6M3Npq4lqaLjnXSGmIz5KB953JeZ90Cshp3gYGTGfKAu0Z2sGSNpnf
         T+jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=tZwBVZ5ivrPb6DCSmr/gfWXOF5H7MpGJkku89V1qfH0=;
        b=1qxcskiV6cPiOYAxpzKrV9OFW9hiifD1RIp6fF6ee/p5hMVrV9xS6G6s6iN9J1Fpss
         ezXAYEetAAOYXE9aPAq/R+jr13vx4MDJaPKKf7Bx9Pp+QRaO9InZMZBR4Pe99BiChq0x
         1z2ZFmPbMwhrAoebdhklBAr+UhjonTZC6jObOuwqGpOcnt9NOae4/kWOoarStQIgu35Q
         LTpL0qlNPjpr4HCAeS2/O0gz8ll3B7NPI/eck08e8Gyn2gYajDj3LNdRMSJ6FsF5ukJR
         W/usvBeeMV1+zaUFvzJ/G6Ef0usF8XaliBYczCszYSRiqNdkycWhs92WMWhOqV3OsTiL
         edMg==
X-Gm-Message-State: AOAM532RzjcEUoxf/ZH9yO3sTAWNZKd6onC11AmkC5mJ/Dm0vtbrkBZF
        hNRBGY7WLaw2/qYEv7eE6MWF
X-Google-Smtp-Source: ABdhPJw8vf5IO3EobDwbYHe2XkhMkNPHww7tMzZRabrqUnjoI4PvPa3dInjX+UhLg8nS5HeMJcXDpA==
X-Received: by 2002:ad4:55b3:: with SMTP id f19mr727008qvx.16.1631724560204;
        Wed, 15 Sep 2021 09:49:20 -0700 (PDT)
Received: from localhost (pool-96-237-52-188.bstnma.fios.verizon.net. [96.237.52.188])
        by smtp.gmail.com with ESMTPSA id h9sm389334qkl.4.2021.09.15.09.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 09:49:19 -0700 (PDT)
Subject: [PATCH v4 0/8] Add LSM access controls and auditing to io_uring
From:   Paul Moore <paul@paul-moore.com>
To:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Wed, 15 Sep 2021 12:49:18 -0400
Message-ID: <163172413301.88001.16054830862146685573.stgit@olly>
User-Agent: StGit/1.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A quick update to the v3 patchset with a small change to the audit
record format (remove the audit login ID on io_uring records) and
a subject line fix on the Smack patch.  I also caught a few minor
things in the code comments and fixed those up.  All told, nothing
significant but I really dislike merging patches that haven't hit
the list so here ya go ...

As a reminder, I'm planning to merge these in the selinux/next tree
later this week and it would be *really* nice to get some ACKs from
the io_uring folks; this patchset is implementing the ideas we all
agreed to back in the v1 patchset so there shouldn't be anything
surprising in here.

For reference the v3 patchset can be found here:
https://lore.kernel.org/linux-security-module/163159032713.470089.11728103630366176255.stgit@olly/T/#t

Those who would prefer to fetch these patches directly from git can
do so using the tree/branch below:
git://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/selinux.git
 (checkout branch "working-io_uring")

---

Casey Schaufler (1):
      Smack: Brutalist io_uring support

Paul Moore (7):
      audit: prepare audit_context for use in calling contexts beyond syscalls
      audit,io_uring,io-wq: add some basic audit support to io_uring
      audit: add filtering for io_uring records
      fs: add anon_inode_getfile_secure() similar to anon_inode_getfd_secure()
      io_uring: convert io_uring to the secure anon inode interface
      lsm,io_uring: add LSM hooks to io_uring
      selinux: add support for the io_uring access controls


 fs/anon_inodes.c                    |  29 ++
 fs/io-wq.c                          |   4 +
 fs/io_uring.c                       |  69 +++-
 include/linux/anon_inodes.h         |   4 +
 include/linux/audit.h               |  26 ++
 include/linux/lsm_hook_defs.h       |   5 +
 include/linux/lsm_hooks.h           |  13 +
 include/linux/security.h            |  16 +
 include/uapi/linux/audit.h          |   4 +-
 kernel/audit.h                      |   7 +-
 kernel/audit_tree.c                 |   3 +-
 kernel/audit_watch.c                |   3 +-
 kernel/auditfilter.c                |  15 +-
 kernel/auditsc.c                    | 469 ++++++++++++++++++++++------
 security/security.c                 |  12 +
 security/selinux/hooks.c            |  34 ++
 security/selinux/include/classmap.h |   2 +
 security/smack/smack_lsm.c          |  46 +++
 18 files changed, 646 insertions(+), 115 deletions(-)
