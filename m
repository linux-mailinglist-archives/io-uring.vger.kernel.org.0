Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B281C30515C
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 05:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239529AbhA0EpU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jan 2021 23:45:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404725AbhA0B3u (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jan 2021 20:29:50 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E6FC061756
        for <io-uring@vger.kernel.org>; Tue, 26 Jan 2021 17:28:51 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id s11so404979edd.5
        for <io-uring@vger.kernel.org>; Tue, 26 Jan 2021 17:28:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VloOxVTWTXqWDaDylYaDP6r9O9mwm1VBZ94Z+gINwqA=;
        b=XEy53taEyqzQuMRBHhDnDB/pDNW0NKm74zPRsRYKmbZ2l1jtp5CWX4H0BIpBrXFkag
         9OfKNoTQKI/Y+aBZlRTSDIzEdOVu1omv51iGOzberDPe34KQL+n8poqxNJUg4Bksu0j2
         UwKxwA9z19AgBzObCqXiAAvj8F0wIApVbdX3zOfK1juLtzwgjhIwNSkD0HIjdcRVj2CT
         TdWHnEK6M5V6Xtg0rjQU3khplZAP9iZLXtF92VNx7M27f8FMcahye/pz25j9iZnaFPic
         QkeQRtFj5Zlgbj+ePUN/8Ahy9v5/DYtjqQojtp/Sfg0S4fa9POvNZ+HLLB0bt4gzpTMM
         xOug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VloOxVTWTXqWDaDylYaDP6r9O9mwm1VBZ94Z+gINwqA=;
        b=ceI4NAniSqjfBKhZw+X3ZgbaK0Y59bd295hTrhz5aEsJTqVJ5Ez/yJCfrxxa9xzCs9
         R9SG6ywPp1lK00UJE3wisJcB8unKULupFD1O4zzVN7MH+pqA96HuCYPX5TL9jeqGo+Jo
         OBg5PhaAVAK2nc9MTGKKYf+zw/7dU3NMequNIVNOOfoa38rgNwjg8BJEdHuUwavl4/ih
         9eHiY8NSeD/bkwdu8DgULEs4pHFqGG4v8dti9BL8X++O5XtPDH+U0TGhF6Ecw6xQAu54
         EVVUwjIM1f7wLEoTqO2Thevd1o9hmaIWSFKeE9D/szK15doIMUFJprpcOZWpGnudwTxz
         KVtw==
X-Gm-Message-State: AOAM530WMETn8agl/HFmR21sJfsZLEVCEp32rRscaMJeNE/cIskBDFzC
        th55cvNoXdHkuLoE4hbkt90=
X-Google-Smtp-Source: ABdhPJxmvQiH7Qlgq2lvuUFblJrxKU2zw8wivzM/ipM0OTPPIr704qDgqM+95d/RM/wQFiTu9G6W4g==
X-Received: by 2002:a05:6402:60a:: with SMTP id n10mr6580361edv.230.1611710930563;
        Tue, 26 Jan 2021 17:28:50 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.161])
        by smtp.gmail.com with ESMTPSA id dh14sm291760edb.11.2021.01.26.17.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 17:28:50 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2] MAINTAINERS: update io_uring section
Date:   Wed, 27 Jan 2021 01:25:04 +0000
Message-Id: <4a6a96702bfef97cb5e6c8e7b5f05074d001a484.1611710680.git.asml.silence@gmail.com>
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
 MAINTAINERS | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 992fe3b0900a..e49b9c5ee49f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6862,6 +6862,9 @@ F:	include/linux/fs.h
 F:	include/linux/fs_types.h
 F:	include/uapi/linux/fs.h
 F:	include/uapi/linux/openat2.h
+X:	fs/io-wq.c
+X:	fs/io-wq.h
+X:	fs/io_uring.c
 
 FINTEK F75375S HARDWARE MONITOR AND FAN CONTROLLER DRIVER
 M:	Riku Voipio <riku.voipio@iki.fi>
@@ -9297,6 +9300,7 @@ F:	include/uapi/linux/iommu.h
 
 IO_URING
 M:	Jens Axboe <axboe@kernel.dk>
+R:	Pavel Begunkov <asml.silence@gmail.com>
 L:	io-uring@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.dk/linux-block
@@ -9304,6 +9308,7 @@ T:	git git://git.kernel.dk/liburing
 F:	fs/io-wq.c
 F:	fs/io-wq.h
 F:	fs/io_uring.c
+F:	include/linux/io_uring.h
 F:	include/uapi/linux/io_uring.h
 
 IPMI SUBSYSTEM
-- 
2.24.0

