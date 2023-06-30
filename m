Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99031743E4C
	for <lists+io-uring@lfdr.de>; Fri, 30 Jun 2023 17:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232964AbjF3PKh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Jun 2023 11:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232213AbjF3PKg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Jun 2023 11:10:36 -0400
Received: from mail-ed1-x549.google.com (mail-ed1-x549.google.com [IPv6:2a00:1450:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D181BD3
        for <io-uring@vger.kernel.org>; Fri, 30 Jun 2023 08:10:35 -0700 (PDT)
Received: by mail-ed1-x549.google.com with SMTP id 4fb4d7f45d1cf-51de1a050a7so1246182a12.1
        for <io-uring@vger.kernel.org>; Fri, 30 Jun 2023 08:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688137833; x=1690729833;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=loQnDSW9i5LQhmfPoJ46XCIWUTUs998PhfaFmb8iPCg=;
        b=wV/AbYBDpdmbnu1YXDKN+oBr9te5bbwTFjXCX+p+JSvzD9dErSY/O74w8yfzZ16p51
         3Od1QYzsQZ1AEsh/lKwZLkk6RMDChs6mPHCDAfEeHwdgo32BUfdw7HeOjkjURjOyUOzz
         ZgqnDNwD6BICpQkyAkzynhWrpXaEObB7I/EuwzIzU53xHc3lm7lXWhUPYBmLYQo8PY9g
         Rzy+UmgVqCt9AOwDqjuOzicwNW8jX4Idp00fTc2oymxSWVZCArWNwTTIH73Cr6egGvrk
         hk7g81HfHNGEK0uiRVgMoV91gLwmAsXnVPI0R/K/LL3ZOZpH8P4jw4wkn9fHrY76oIwk
         cXdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688137833; x=1690729833;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=loQnDSW9i5LQhmfPoJ46XCIWUTUs998PhfaFmb8iPCg=;
        b=JMLjsP1YkHABaj4EsdwqTOnnnFl+vUfxrzMtyOl0QE5y+mh8HKPDrFcMt5schJadjG
         TNfQjh3VH26/TXrU9SaFZE/+5bwVIZvJgsoH7rTAuPyJ48KmekGQHI3cYu+OKfPrCAco
         jSyPB0tuRlPDXRPndBo/qGkksST6mJKx3d5+qKZCa1vaM0baU9xyRN4/bCpxHrsCjcIW
         nCg6bAbigm5TWjJ1y2p6Efmitgpvxb7azxB9E5O5QcbQ3NJIIqOlXo4997PoQE5xND/w
         AM5jt3p4KUyTvlFP3Zq21mNN8kkz/cc8suBaIrUYe+PCdZSej+Gi4wQFYMTHO3TcDv2b
         Svhw==
X-Gm-Message-State: ABy/qLagIxRybNvOXUx108ng/MFjFK26WWj7GMb6KRLsKIy+KpxzZ1EQ
        zJ/eDKauvmiXYRvLoxchEb8IWlvcQP2SLlyBVw==
X-Google-Smtp-Source: APBJJlEv85eOlT2Ou52uqPZuUTuFK0QDmKuWT4jlAo1G5h8cw8X8JntUMAG5b8OBfMI5o+Wy5gdplV1s7bH9+wFHMA==
X-Received: from mr-cloudtop2.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:fb5])
 (user=matteorizzo job=sendgmr) by 2002:a50:a6dd:0:b0:51d:9659:4dae with SMTP
 id f29-20020a50a6dd000000b0051d96594daemr11259edc.5.1688137833489; Fri, 30
 Jun 2023 08:10:33 -0700 (PDT)
Date:   Fri, 30 Jun 2023 15:10:02 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230630151003.3622786-1-matteorizzo@google.com>
Subject: [PATCH v3 0/1] Add a sysctl to disable io_uring system-wide
From:   Matteo Rizzo <matteorizzo@google.com>
To:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com
Cc:     matteorizzo@google.com, corbet@lwn.net, akpm@linux-foundation.org,
        keescook@chromium.org, ribalda@chromium.org, rostedt@goodmis.org,
        jannh@google.com, chenhuacai@kernel.org, gpiccoli@igalia.com,
        ldufour@linux.ibm.com, evn@google.com, poprdi@google.com,
        jordyzomer@google.com, jmoyer@redhat.com, krisman@suse.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Over the last few years we've seen many critical vulnerabilities in
io_uring[1] which could be exploited by an unprivileged process to gain
control over the kernel. This patch introduces a new sysctl which disables
the creation of new io_uring instances system-wide.

The goal of this patch is to give distros, system admins, and cloud
providers a way to reduce the risk of privilege escalation through io_uring
where disabling it with seccomp or at compile time is not practical. For
example a distro or cloud provider might want to disable io_uring by
default and have users enable it again if they need to run a program that
requires it. The new sysctl is designed to let a user with root on the
machine enable and disable io_uring systemwide at runtime without requiring
a kernel recompilation or a reboot.

[1] Link: https://goo.gle/limit-iouring

---
v3:
	* Fix the commit message
	* Use READ_ONCE in io_uring_allowed to avoid races
	* Add reviews
v2:
	* Documentation style fixes
	* Add a third level that only disables io_uring for unprivileged
	  processes


Matteo Rizzo (1):
  io_uring: add a sysctl to disable io_uring system-wide

 Documentation/admin-guide/sysctl/kernel.rst | 19 +++++++++++++
 io_uring/io_uring.c                         | 31 +++++++++++++++++++++
 2 files changed, 50 insertions(+)


base-commit: 1601fb26b26758668533bdb211fdfbb5234367ee
-- 
2.41.0.255.g8b1d071c50-goog

