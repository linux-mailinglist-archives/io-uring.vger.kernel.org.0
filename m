Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7EAB40763C
	for <lists+io-uring@lfdr.de>; Sat, 11 Sep 2021 13:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbhIKLNw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Sep 2021 07:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbhIKLNw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Sep 2021 07:13:52 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CC1C061574
        for <io-uring@vger.kernel.org>; Sat, 11 Sep 2021 04:12:39 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id t8so1481725wrq.4
        for <io-uring@vger.kernel.org>; Sat, 11 Sep 2021 04:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ix3E9gw7+ideaC6VUaVqYukG6F7xiP6RRJHkJiv+Ff0=;
        b=fiJ6w4ih9kw++oOmyKIRUANjWZu1/TTnIHaY1P/Qq2+s5SvNdqyEPeAbueiXIWBQF+
         FyzXKvmdo2cOFUrocklk0w3ia8HIvd2euCjewcuL29bcUxc9p6U8bMJ9f4QH4HdA7XOM
         oOhjGe31s7EkiSfet4cfOAKoHevu7VLIwUhUgz8vQG43lsGC5KMEB96gqVvDgVCCP4cg
         NtzAcfh4807N49c9ILJUKosDc1MVvqDKgsMJo1KSGnYwS4ShFfV80s0VqkywtF2B6ZqD
         S+NMQtqH8KpUh+mULIubhuDJei+iofAtGYSV8/wY9nMZz3BblVwkBBHZdcSU1T2ZZ70Q
         awHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ix3E9gw7+ideaC6VUaVqYukG6F7xiP6RRJHkJiv+Ff0=;
        b=JXJumVnpvwuspd8Q4LnxbwEo9xA5S6eotIWtanSwckPyi8beJMok2E3NBczCxZj/BS
         G2I7RQiELZud3V04cSXMXBE3n4subNxLoI6StbiSXEFjRnZzFHS/l9kEEGT75/wRd/LN
         htgcTjOl2OgHC3SQ8tDRJ/2UxaDvnPkV+Casia61rMkW47e/tzA9Q9vczuJg6g4CsLP1
         UKA8s6i2y9lgJcd8SrRkc9uyzoZ2xzxGI99f5UQ8h3+X2ZfbtiCLp2Ww3zvLn4SFAsr+
         nfUgk5IwmakaWuMp3l8OSNTFItSuKzmTMbIa1a1oRdj4uati7AcujpARPBmVStWZRZ/z
         SNig==
X-Gm-Message-State: AOAM530dy0+Hf/8Cpcg2K+aZTDHTAM9xnihB7kgqZMv88iutHXJ7+6MB
        EWFegGZFVyo1WoXTNYsbywA=
X-Google-Smtp-Source: ABdhPJwP6/jo5WJqU1J1GuE4ch9v4IPdGcZAlheuPhdBo6nz9adEWhWuZMs3UpBOUz732ggy0F3Ybw==
X-Received: by 2002:a5d:4a08:: with SMTP id m8mr2623649wrq.263.1631358758120;
        Sat, 11 Sep 2021 04:12:38 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.175])
        by smtp.gmail.com with ESMTPSA id x11sm1335470wmk.21.2021.09.11.04.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Sep 2021 04:12:37 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing v2 0/2] exec + timeout cancellation
Date:   Sat, 11 Sep 2021 12:11:54 +0100
Message-Id: <cover.1631358658.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add some infra to test exec(), hopefully we will get more
tests using it. And also add a timeout test, which uses exec.

v2: rebase

Pavel Begunkov (2):
  tests: add no-op executable for exec
  tests: test timeout cancellation fails links

 .gitignore         |  1 +
 test/Makefile      |  2 ++
 test/exec-target.c |  4 +++
 test/timeout.c     | 84 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 91 insertions(+)
 create mode 100644 test/exec-target.c

-- 
2.33.0

