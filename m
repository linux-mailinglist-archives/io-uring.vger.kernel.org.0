Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C9E305130
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 05:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239531AbhA0EpW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jan 2021 23:45:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404881AbhA0BaH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jan 2021 20:30:07 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A02C061573
        for <io-uring@vger.kernel.org>; Tue, 26 Jan 2021 17:21:03 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id bl23so360338ejb.5
        for <io-uring@vger.kernel.org>; Tue, 26 Jan 2021 17:21:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E1J5IbK1qJkJLAPW4JmpxIn448hVPrPljrY0olmejHU=;
        b=FTpueQ/OmBNFsCvdDYpcKI45VJiKFWM4slkiJPvyG2kphTlyD/UI2aeYv07kcJyUoh
         RS9+QkW9lpqvIgIEu3FbSEwrpW1gNBjRZ9I3+1cRLyFWhhqFPonCoQQdCehUZGiRH7Ig
         RJIMu729tbe9Ivg20Lk1aTMrk+1UAYbYpfOUb3tJGQAyMGFqFPqbrsbo+pp8ZhN73gtO
         NX9e2lsUV1qOHqsNDgTbRK9DQVo+0kF6hIZ7qgVmLFeFcQze/u6VlDLl/EP4ebdT8FME
         DCr1WX+LMJDbVP6wIjPaOtP5xVofwJILsLlK2QcKoPhjPbTErD80WorfE4A+iZEAqWTA
         BEOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E1J5IbK1qJkJLAPW4JmpxIn448hVPrPljrY0olmejHU=;
        b=THRiDRBH03q/9dItKfJkLho8Y/3FBwwxmFUoBrMTmmLpek2x71JNfRj4OtwUxi+AqX
         Ie9hLiD4QhufnvcU6l+WSgJ5ufLIcF7t9nbdblNWVP59ia0RW1473/Jf7IQREgMA1hbx
         jCdQJya3S7dsvOHkbtkCYJ5QPjc7O0p8yXvxa7GDZ/PRjQhjFBd5efpbLZl71p/mrFbc
         D5GJdZ6tYt9eiJDl5YEnCfw3K2LIn+TTYyeDHHp76LgWyAgSZaf5Ft8lxDXdygTQr8vU
         3M3/GSwR/aB7RTeY4y81s46Cha2VdWkcneCQsHi5h3nJEbW/Ywx0h6EMQrEeTXSaanti
         FfZg==
X-Gm-Message-State: AOAM533lfnHPom8aTFc8J0BKg3r7TbU3/Gz9gkRuDPzvpNTVB7xpbJGU
        vQFuT8DMQluRNVseyyWwv4I=
X-Google-Smtp-Source: ABdhPJwNiXU8i1yYXoQSwGGKacLqSzpsGyBSO6XG2+3Y7aN3m4Nae8waaQwxAspDvLeMhGv9SO7Alw==
X-Received: by 2002:a17:906:6d0e:: with SMTP id m14mr4990593ejr.285.1611710461821;
        Tue, 26 Jan 2021 17:21:01 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.161])
        by smtp.gmail.com with ESMTPSA id i26sm278933eds.55.2021.01.26.17.21.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 17:21:01 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH] MAINTAINERS: update io_uring section
Date:   Wed, 27 Jan 2021 01:17:13 +0000
Message-Id: <4f7860f785c308d7341302b70a0e8a975586f611.1611710197.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

- add a missing file
- add a reviewer
- don't spam fsdevel

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 MAINTAINERS | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 992fe3b0900a..f3accf0f63f9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6858,6 +6858,7 @@ M:	Alexander Viro <viro@zeniv.linux.org.uk>
 L:	linux-fsdevel@vger.kernel.org
 S:	Maintained
 F:	fs/*
+X:	fs/io_uring.c
 F:	include/linux/fs.h
 F:	include/linux/fs_types.h
 F:	include/uapi/linux/fs.h
@@ -9297,6 +9298,7 @@ F:	include/uapi/linux/iommu.h
 
 IO_URING
 M:	Jens Axboe <axboe@kernel.dk>
+R:	Pavel Begunkov <asml.silence@gmail.com>
 L:	io-uring@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.dk/linux-block
@@ -9304,6 +9306,7 @@ T:	git git://git.kernel.dk/liburing
 F:	fs/io-wq.c
 F:	fs/io-wq.h
 F:	fs/io_uring.c
+F:	include/linux/io_uring.h
 F:	include/uapi/linux/io_uring.h
 
 IPMI SUBSYSTEM
-- 
2.24.0

