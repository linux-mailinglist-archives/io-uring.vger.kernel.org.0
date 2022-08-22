Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC22559CA97
	for <lists+io-uring@lfdr.de>; Mon, 22 Aug 2022 23:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237970AbiHVVOT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Aug 2022 17:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237907AbiHVVOS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Aug 2022 17:14:18 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D08E2DAB8
        for <io-uring@vger.kernel.org>; Mon, 22 Aug 2022 14:14:17 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id b2so9131057qvp.1
        for <io-uring@vger.kernel.org>; Mon, 22 Aug 2022 14:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:message-id:date
         :cc:to:from:subject:from:to:cc;
        bh=/q0nwJ3bwd102jW5hNeK0W5Y+IabNfyQyp4vndAiVuU=;
        b=e7mi3hA/9lmUPcqxPTbADoCC8pT86ri6GA3t9cVCuQXQhfBwn6yK44Mj/rprBv+7GV
         4oI0rkwJ4Lq/vP1Dnl+s7n2NLXiuTQ6dOqhAtgXAOhOxD6xAyq3DpVy60aaUWRDRwOUY
         W8cWg79RBr9Vag6KNjRP/gHkIg4QsPVh/bqIy3lFvGgOzurygvLUF7UA1gF73eH/GqDA
         i5bXgcP5S+vUjX0yyeXSLk98b7jhjPzjgcYZBfjtpvxf7FvtpNBTt9CvgAodyV/7XQbo
         n2nXgpC3zq4A3IULamMAfRytYXZNRbBG1ygAwCRbCvxDtZp/BTTwgidJtvIArMQja+sx
         AOvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:message-id:date
         :cc:to:from:subject:x-gm-message-state:from:to:cc;
        bh=/q0nwJ3bwd102jW5hNeK0W5Y+IabNfyQyp4vndAiVuU=;
        b=NQbn160wpAHzKMin1Xd6XIBHraNm9jgi1U8xtVRQiK6RLQ3RLKdzpHCtZEWWmkcAqi
         oWWQf/JFWD6CBG8ql1k7PR0rywLRGVfoxbVpHF1ZncX9I3Fcun2s6TmLqga3xDTEfaVp
         NRGDH2Aao51WSSh3eKzFyLTyfGmfj90XSGtdJ8AUsy3UeEVQw663sR47KcZH+HKYwU9M
         AKo5LBFgXWMR7C7oS/TxI7MrZJ+nnkMOSEenSzRufXvtjVhoKX4/I5ENjdoDX/p0x4c8
         kqpl/X/ptxq6j15+M9Lx+Dp5nW/7w0k65ZrMGpkeOCQTb3tixFN1PHPCdEB+OD9fIQWb
         HuHA==
X-Gm-Message-State: ACgBeo1wsQVYqq0XeAmWyfNdbyZggzkrp0CfcBH9jVkBLCLVnbZt9BeF
        PN58J9PyMKI8NogFlkMy8sjF
X-Google-Smtp-Source: AA6agR5clwk558fyRJ2M0NL9frufphXmD/cgoQOiUrZkCZYHtPhhTObuqdoe7E23W0ptCPik/U+mhQ==
X-Received: by 2002:a05:6214:4119:b0:474:877b:8bac with SMTP id kc25-20020a056214411900b00474877b8bacmr17088024qvb.1.1661202855975;
        Mon, 22 Aug 2022 14:14:15 -0700 (PDT)
Received: from localhost (pool-96-237-52-46.bstnma.fios.verizon.net. [96.237.52.46])
        by smtp.gmail.com with ESMTPSA id b17-20020ac84f11000000b0031e9ab4e4cesm9488658qte.26.2022.08.22.14.14.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 14:14:15 -0700 (PDT)
Subject: [PATCH 0/3] LSM hooks for IORING_OP_URING_CMD
From:   Paul Moore <paul@paul-moore.com>
To:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 17:14:14 -0400
Message-ID: <166120234006.357028.9335354304390109167.stgit@olly>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patchset includes three patches: one to add a new LSM hook for
the IORING_OP_URING_CMD operation, one to add the SELinux
implementation for the new hook, and one to enable
IORING_OP_URING_CMD for /dev/null.  The last patch, the /dev/null
support, is obviously not critical but it makes testing so much
easier and I believe is in keeping with the general motivation behind
/dev/null.

Luis' patch has already been vetted by Jens and the io_uring folks,
so the only new bits are the SELinux implementation and the trivial
/dev/null implementation of IORING_OP_URING_CMD.  Assuming no one
has any objections over the next few days, I'll plan on sending this
up to Linus during the v6.0-rcX cycle.

I believe Casey is also currently working on Smack support for the
IORING_OP_URING_CMD hook, and as soon as he is ready I can add it
to this patchset (or Casey can send it up himself).

-Paul

---

Luis Chamberlain (1):
      lsm,io_uring: add LSM hooks for the new uring_cmd file op

Paul Moore (2):
      /dev/null: add IORING_OP_URING_CMD support
      selinux: implement the security_uring_cmd() LSM hook


 drivers/char/mem.c                  |  6 ++++++
 include/linux/lsm_hook_defs.h       |  1 +
 include/linux/lsm_hooks.h           |  3 +++
 include/linux/security.h            |  5 +++++
 io_uring/uring_cmd.c                |  5 +++++
 security/security.c                 |  4 ++++
 security/selinux/hooks.c            | 24 ++++++++++++++++++++++++
 security/selinux/include/classmap.h |  2 +-
 8 files changed, 49 insertions(+), 1 deletion(-)

