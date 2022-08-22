Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0F5959CAB7
	for <lists+io-uring@lfdr.de>; Mon, 22 Aug 2022 23:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237930AbiHVVVG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Aug 2022 17:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238052AbiHVVVF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Aug 2022 17:21:05 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13DB5208E
        for <io-uring@vger.kernel.org>; Mon, 22 Aug 2022 14:21:03 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id f14so8949869qkm.0
        for <io-uring@vger.kernel.org>; Mon, 22 Aug 2022 14:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:message-id:date
         :cc:to:from:subject:from:to:cc;
        bh=5RQRl53BMMbcV3UBpkUvMw0kVRmuERrDcog8F29EXKk=;
        b=XxTaY88L6YyDi4q4wmCk8eVhxMP+iLwiTQfB+DWrM8PTcGLBvO8N71ubEFVUt83vYA
         wdnD/fZmhMHsA9CfRa30LDpuYjZBFBee5jEo0dzDLzzEvvtbBR8P9Btu6S9Njwn6lz9q
         D5p7andXJ/eFjisCdzDEogdJKwtPCaGa425/HNYL6WAYn8VN/00nGGzBslxj6FN2XFUe
         RL/93480d1VSeSt+2h/uOGO55rmFRfWs6Cah4Wzys7DoYbZ+2N0WLpHIs+LMiA/yddYU
         40Hu9gdGDOMjJyTZm4sLwRZdlJ+jh/vXDMuYpQ26A1fELppD8lNBdIUPP8kKDUzyzMn2
         D5lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:message-id:date
         :cc:to:from:subject:x-gm-message-state:from:to:cc;
        bh=5RQRl53BMMbcV3UBpkUvMw0kVRmuERrDcog8F29EXKk=;
        b=2EMKnA/2/feJZyHA/4JjnA5thDdI7MP7XNm0SM7ToFAYeN4jDjC2W5Ox7MWtZZ4BI3
         ljasNDeCvKxoc1xFIpo/4RMO2QQ6aJEmLDsW8q9F9SoevEz8jccvhg3jb3Dg1+z8M6a+
         V6+76QHkJ9s1OxqawexNG1MCUDBX/VLtKSqdUZArT4tzS7fBgQDM02/BpRS3KEFW7NgB
         ZG44GwyrmOS2vcB4NE4P7K5BQ6A4UZo9ZP1je506J5tkLrsBUHG1UOO62QB1LrnB43hn
         pREEq+Rbv9elxBNbzp28aMCbEVxNc/DIBCWkRzLqa7orlysAtC4X43jL7z2uf4Sp0iEn
         XHHw==
X-Gm-Message-State: ACgBeo0YwNSOw7bhH15x2TUPGPb20lzXMxcGECmR//9Zi0ec2Fs3FcUm
        1PPojSsUvIAcF9clSX3i7GaE
X-Google-Smtp-Source: AA6agR5HRvyFM8nlzlvFRus8PX8jMZnrW3P+rNROq/qiCc53eyykqUoFMwCw7xUqAQrocMjVabC3Ng==
X-Received: by 2002:a37:cc5:0:b0:6bb:93e9:54f with SMTP id 188-20020a370cc5000000b006bb93e9054fmr13958588qkm.114.1661203262755;
        Mon, 22 Aug 2022 14:21:02 -0700 (PDT)
Received: from localhost (pool-96-237-52-46.bstnma.fios.verizon.net. [96.237.52.46])
        by smtp.gmail.com with ESMTPSA id m1-20020a05620a290100b006b95f832aebsm11627625qkp.96.2022.08.22.14.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 14:21:02 -0700 (PDT)
Subject: [PATCH 0/3] LSM hooks for IORING_OP_URING_CMD
From:   Paul Moore <paul@paul-moore.com>
To:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>
Date:   Mon, 22 Aug 2022 17:21:01 -0400
Message-ID: <166120321387.369593.7400426327771894334.stgit@olly>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
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
      selinux: implement the security_uring_cmd() LSM hook
      /dev/null: add IORING_OP_URING_CMD support


 drivers/char/mem.c                  |  6 ++++++
 include/linux/lsm_hook_defs.h       |  1 +
 include/linux/lsm_hooks.h           |  3 +++
 include/linux/security.h            |  5 +++++
 io_uring/uring_cmd.c                |  5 +++++
 security/security.c                 |  4 ++++
 security/selinux/hooks.c            | 24 ++++++++++++++++++++++++
 security/selinux/include/classmap.h |  2 +-
 8 files changed, 49 insertions(+), 1 deletion(-)

