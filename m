Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCA838D017
	for <lists+io-uring@lfdr.de>; Fri, 21 May 2021 23:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbhEUVvJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 May 2021 17:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhEUVvI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 May 2021 17:51:08 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C3D3C061574
        for <io-uring@vger.kernel.org>; Fri, 21 May 2021 14:49:44 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id o59so11223680qva.1
        for <io-uring@vger.kernel.org>; Fri, 21 May 2021 14:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=rnbRWaK3S2pNJ8BuaJG2JWJsS1i7bhrZxXnssJvgZhA=;
        b=ukbuvTj1LEG7m1bNqbx6Bc8nAyL3W885rRdBvJa1OQN5TKe49Aq0zJpJVdl12MfxTW
         RJvet95fv+qZv9l6lvTnvvRxQfrwcMQyyM+OdWAUUoMleMfDSBspA3pj3f0BifboGXCI
         xNE+2iNRS5OOo6B1ZTG74E/Z4qTvc6958Re9zmDZUuH2H73TBLaxC5zDLW5fADHb8Kus
         V/LlKM02Kcx9W5Udgv06HGj3CjopJ8/Zi0NdtPDHkWcjuVOy11YA59X91c0ZVwZU8QZG
         6saq4CXSoQRYlL3GBUOhzZfUU+WszendSs/6RD3iuOBKo10ABcqgXgRxEYy5mD0uDps2
         4AqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=rnbRWaK3S2pNJ8BuaJG2JWJsS1i7bhrZxXnssJvgZhA=;
        b=FTvWfHbZgenUdq4t4GicjkicSTGChjcjRKbkfI/fgyKau0uCW86OVCNRlSJK3J2ONX
         AtrLhia921jNDnA6EDakF+Rb5uXYypxKbqM4Phdu88C4ThZqoPZfPq/cOqRfIUPqphnZ
         AHd5p4X7xHxOAC9Th7Vcr427HgUU62YaYhZy8ruf/Uwq17Ypxi9+OBzM3gESkamRNR7W
         I/GGAMap3KNtx48I+z4QSb16YuxLi9oZ4eTU2hEe5wplp1eE0KC6/Tacdnw4Q+3V5DDT
         4dQA8EyloUIRKMN0qFReNE5gHWUxx0HeA0eCeis+Zv7mt4d5Hdh+F+JU/qaYPFvFoxK2
         zr7Q==
X-Gm-Message-State: AOAM53350BBi0HMjMI5Ir6h5cSfSQU2pCPojEuGdrfqO+U/i+YqVR9Rc
        u4vPFao1oYNP4h6QnvZ16Sq6
X-Google-Smtp-Source: ABdhPJxeykuSzKF4Ef2u3A55uIH3hhoAOxzj8OlMe3fTY2qtbfs+nxISBoK03j9mFD3TGDQhJV4KRg==
X-Received: by 2002:a05:6214:c6c:: with SMTP id t12mr15192850qvj.34.1621633783282;
        Fri, 21 May 2021 14:49:43 -0700 (PDT)
Received: from localhost (pool-96-237-52-188.bstnma.fios.verizon.net. [96.237.52.188])
        by smtp.gmail.com with ESMTPSA id f13sm4912251qkk.107.2021.05.21.14.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 14:49:42 -0700 (PDT)
Subject: [RFC PATCH 0/9] Add LSM access controls and auditing to io_uring
From:   Paul Moore <paul@paul-moore.com>
To:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Date:   Fri, 21 May 2021 17:49:41 -0400
Message-ID: <162163367115.8379.8459012634106035341.stgit@sifl>
User-Agent: StGit/1.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Earlier this week Kumar Kartikeya Dwivedi posted a patchset switching
io_uring over to the anonymous inode variant that allows for LSM
controls.  While nice, the patchset left the actual LSM controls as
an exercise for the reader.  The posting can be found using the lore
link below:

https://lore.kernel.org/io-uring/CAHC9VhS=PDxx=MzZnGGNLwo-o5Og-HGZe84=+BBtBCZgaGSn4A@mail.gmail.com/T/#mde8c5120f3b8e34a5a3b18229b8c563a7855fd20

As fate would have it, I had been working on something very similar,
in fact the two patches from Kumar mirrored two in my own patchset.
This patchset, while still a bit crude, does include an attempt at
adding the LSM and audit support necessary to properly implement LSM
based access controls for io_uring.  I've provided the SELinux
implementation, Casey has been nice enough to provide a Smack patch,
and John is working on an AppArmor patch as I write this.  I've
mentioned this work to the other LSM maintainers that I believe might
be affected but I have not heard back from anyone else at this point.
If any of the other LSMs would like to contribute a patch to this
patchset I will happily accept it; I only ask that you post it to the
LSM list and make sure I am on the To/CC line.  I think it would be
nice to try and wrap this up as soon as possible for the obvious
reasons.

The individual patches provide an explanation of the changes involved
so I'm not going to repeat that here, but I will caution you that
these patches are still rather crude, perhaps more than a RFC patchset
should be, but it seemed prudent to move this along so I'm posting
these now.  Any review that you can provide would be helpful.

Also, any pointers to easy-to-run io_uring tests would be helpful.  I
am particularly interested in tests which make use of the personality
option, share urings across process boundaries, and make use of the
sqpoll functionality.

As a point of reference, this patchset is based on v5.13-rc2 and if
you want to follow along via git I'll be making updates to the git
tree/branch below (warning I will be force-pushing on this branch given
the early/rough nature of these patches).

git://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/selinux.git
 (checkout branch "working-io_uring")

Thanks in advance,
-Paul

---

Casey Schaufler (1):
      Smack: Brutalist io_uring support with debug

Paul Moore (8):
      audit: prepare audit_context for use in calling contexts beyond syscalls
      audit,io_uring,io-wq: add some basic audit support to io_uring
      audit: dev/test patch to force io_uring auditing
      audit: add filtering for io_uring records
      fs: add anon_inode_getfile_secure() similar to anon_inode_getfd_secure()
      io_uring: convert io_uring to the secure anon inode interface
      lsm,io_uring: add LSM hooks to io_uring
      selinux: add support for the io_uring access controls


 fs/anon_inodes.c                    |  29 ++
 fs/io-wq.c                          |   4 +
 fs/io_uring.c                       |  25 +-
 include/linux/anon_inodes.h         |   4 +
 include/linux/audit.h               |  17 +
 include/linux/lsm_hook_defs.h       |   5 +
 include/linux/lsm_hooks.h           |  13 +
 include/linux/security.h            |  16 +
 include/uapi/linux/audit.h          |   4 +-
 kernel/audit.h                      |   7 +-
 kernel/auditfilter.c                |   4 +-
 kernel/auditsc.c                    | 481 ++++++++++++++++++++++------
 security/security.c                 |  12 +
 security/selinux/hooks.c            |  67 ++++
 security/selinux/include/classmap.h |   2 +
 security/smack/smack_lsm.c          |  64 ++++
 16 files changed, 650 insertions(+), 104 deletions(-)
