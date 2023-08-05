Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB957712F5
	for <lists+io-uring@lfdr.de>; Sun,  6 Aug 2023 00:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjHEWyp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Aug 2023 18:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjHEWyo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 5 Aug 2023 18:54:44 -0400
X-Greylist: delayed 351 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 05 Aug 2023 15:54:43 PDT
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050:0:465::103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58CA519B5
        for <io-uring@vger.kernel.org>; Sat,  5 Aug 2023 15:54:43 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4RJHnC3JB0z9sZj;
        Sun,  6 Aug 2023 00:48:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyphar.com; s=MBO0001;
        t=1691275727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Zs3M/G44ypGLQBrS+6QpeGQyQMHY0My7xyCyNV5W7UY=;
        b=OK8G3j2tqbi0xW+hYczXouurJh/7+yh1lAy+hUoiYh/a362dI4iHFebLy56nohqqax4s3B
        hdAJ1wTzBf8B1O65AtKeW9jFupsDqNXNxBbq5rlgI5QNLC62nGqqpAU/gMc0NP4UJxaR6C
        kPrObKgTeRoZ+ICh1WMceu3on0zEiEkRqm/J859mOhVlPn06gJ9wTI4fZCZzQfiNqFQ/oJ
        ASoP8boEovce1emNvItAZP3xUvVArWzqNeTDHnnY8iBwxyTgScMzMoHIcVg05he6bWHs/f
        2tPKrPdywUs7Jrmsr82JT9taqK+HGBzvky340DKCaTDD9KAqP9hk7vBcIuyTYg==
From:   Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH v2 0/2] open: make RESOLVE_CACHED correctly test for
 O_TMPFILE
Date:   Sun, 06 Aug 2023 08:48:07 +1000
Message-Id: <20230806-resolve_cached-o_tmpfile-v2-0-058bff24fb16@cyphar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKfRzmQC/42NQQ6DIBREr2L+ujSCLVJXvUdjDOK3/ESFgCE1x
 ruXeoIu32TmzQ4RA2GEptghYKJIbskgLgUYq5c3MhoygyhFVapSsoDRTQk7o43Fgblunf1IE7J
 HrUwvKtUPUkGe+4AjfU71q81sKa4ubOdT4r/0D2nijLO611zm4k3e8Wk2b3W4GjdDexzHF2sgy
 UXBAAAA
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
        stable@vger.kernel.org
X-Developer-Signature: v=1; a=openpgp-sha256; l=1214; i=cyphar@cyphar.com;
 h=from:subject:message-id; bh=iu0CMEKoz0Ewqe8aOMvuXAQy1aWcE4V3njCd+ME8HFo=;
 b=owGbwMvMwCWmMf3Xpe0vXfIZT6slMaScu3jCQPDPKxvTW8zKfW/nKh57c/r5wtTjrZXtm2ezn
 N6teeHvso5SFgYxLgZZMUWWbX6eoZvmL76S/GklG8wcViaQIQxcnAIwkX+7Gf4ZPc6Kf7e53XrP
 0aPn351rntwsf8VuZeySBFmD5fN4ghM+MzK8WGm3uGN97IWvGm3PjsWuqauNnMpqvOj2BaWudbm
 J8TfZAA==
X-Developer-Key: i=cyphar@cyphar.com; a=openpgp;
 fpr=C9C370B246B09F6DBCFC744C34401015D1D2D386
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There were a few places that were incorrectly testing for whether an
open(2) operation was O_TMPFILE by doing (flags & O_TMPFILE). As
O_TMPFILE is defined as __O_TMPFILE|O_DIRECTORY, this would cause the
code to assume that O_DIRECTORY is equivalent to O_TMPFILE.

The only places where this happened were in RESOLVE_CACHED and
io_uring's checking related to RESOLVE_CACHED, so the only bug this
really fixes is that now O_DIRECTORY will no longer cause RESOLVE_CACHED
to always fail with -EAGAIN (and io_uring will thus be faster when doing
O_DIRECTORY opens).

Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
Changes in v2:
- fix io_uring's io_openat_force_async as well.
- v1: <https://lore.kernel.org/r/20230806-resolve_cached-o_tmpfile-v1-1-7ba16308465e@cyphar.com>

---
Aleksa Sarai (2):
      open: make RESOLVE_CACHED correctly test for O_TMPFILE
      io_uring: correct check for O_TMPFILE

 fs/open.c            | 2 +-
 io_uring/openclose.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)
---
base-commit: bf5ad7af0516cb47121dae1b1c160e4385615274
change-id: 20230806-resolve_cached-o_tmpfile-978cb238bd68

Best regards,
-- 
Aleksa Sarai <cyphar@cyphar.com>

