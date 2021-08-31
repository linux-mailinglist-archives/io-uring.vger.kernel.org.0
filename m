Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB783FCED6
	for <lists+io-uring@lfdr.de>; Tue, 31 Aug 2021 22:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241207AbhHaU4C (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Aug 2021 16:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234503AbhHaU4C (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Aug 2021 16:56:02 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B677C061575
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 13:55:06 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id u9so1130193wrg.8
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 13:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CYD5fPtMmhfgYtczBovLEtR2i+o9/aBQuEYpkWRTF4w=;
        b=vSrYZ71GjuCc2WPyYk57HilRNfqx9geNpUOGycq+VQTdo3HuVuN9q4xhZHT2gW3sad
         HRYbydLdecCeH3vSVzMN54gf8wkhUuWLnzGYv7e/6zRSjoElcuaYD+WV0FwPNF9uw/ht
         8rQD/sZLbu1wO0yaV9sSTqHx9Pu6+Wd0zI2tUcPLEisHPc+ZEzOLmCB0E3d+468ehjhn
         SRfmUWmMtDyikSVZWVsZZ53QSi48cLaENz5iiGIQre5RO/ecoE96TF3O/oP2ZAYlMfXA
         sqFBz+M7UN50SLWs2V8c0gH/FaJoWMnVDe00Khvyv+9steDlqYd0VHnVe65FBgcTwCpa
         IjGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CYD5fPtMmhfgYtczBovLEtR2i+o9/aBQuEYpkWRTF4w=;
        b=tceNyJWy+PRfUk+MJvlEsx1oXD4a+jBEB0JeYmG9djvuMLwFhVn5gFEySUGyMjkZwc
         EEJ87N90b5GJBgkW0CphQO4hBbCnIaiIP3+rn2R0CI5ettfp3cpVBGNGXH9E9U1wYCd0
         b4IgDgad3QRh1EkprQBd31gXkaaCSfbXjowT6Ac1i2oAGh/cQJubYkbxmBYpkCHwJx0W
         bGF6KV9U0KMAoRFUJsGPxpZsJMxDOHEyA12o/ndP9gIMBmdn2T/udvEV1oVatuYfENTI
         om3S0iPFigd7Y0jabVJg1RKLq5Nw3GN8gj31vIqOQkW8bqB9nX6SURjV+biFuFBD8lsn
         QU6A==
X-Gm-Message-State: AOAM533DBO9v3n4+3OBsZF2d+k1zvLrAFPOgD8HbkUPYkDQSSrV+KNhb
        s9vzTmQHbmXo2WH5Ylwv84L6NZy68iQ=
X-Google-Smtp-Source: ABdhPJwH+j4voSC8/7GRfV/0ZwwprJdXF0C+6juKY7OHtnUZBQ8/0FxIvdDvZPQL2FWrgCV5pZDytg==
X-Received: by 2002:a05:6000:259:: with SMTP id m25mr34208303wrz.53.1630443305165;
        Tue, 31 Aug 2021 13:55:05 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.138])
        by smtp.gmail.com with ESMTPSA id g138sm3668050wmg.34.2021.08.31.13.55.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 13:55:04 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing v2] man/io_uring_enter.2: add notes about direct open/accept
Date:   Tue, 31 Aug 2021 21:54:25 +0100
Message-Id: <cf33283b0f2e795ac7f9b6e2eabc70a4f71863c0.1630443189.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a few lines describing openat/openat2/accept bypassing normal file
tables and installing files right into the fixed file table.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: s/non-negative/positive/ (Jens)
    mention fixed files restrictions

 man/io_uring_enter.2 | 48 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index 9ccedef..e1ae707 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -511,6 +511,22 @@ field. See also
 .BR accept4(2)
 for the general description of the related system call. Available since 5.5.
 
+If the
+.I file_index
+field is set to a positive number, the file won't be installed into the
+normal file table as usual but will be placed into the fixed file table at index
+.I file_index - 1.
+In this case, instead of returning a file descriptor, the result will contain
+either 0 on success or an error. If there is already a file registered at this
+index, the request will fail with
+.B -EBADF.
+Only io_uring has access to such files and no other syscall can use them. See
+.B IOSQE_FIXED_FILE
+and
+.B IORING_REGISTER_FILES.
+
+Available since 5.15.
+
 .TP
 .B IORING_OP_ASYNC_CANCEL
 Attempt to cancel an already issued request.
@@ -634,6 +650,22 @@ is access mode of the file. See also
 .BR openat(2)
 for the general description of the related system call. Available since 5.6.
 
+If the
+.I file_index
+field is set to a positive number, the file won't be installed into the
+normal file table as usual but will be placed into the fixed file table at index
+.I file_index - 1.
+In this case, instead of returning a file descriptor, the result will contain
+either 0 on success or an error. If there is already a file registered at this
+index, the request will fail with
+.B -EBADF.
+Only io_uring has access to such files and no other syscall can use them. See
+.B IOSQE_FIXED_FILE
+and
+.B IORING_REGISTER_FILES.
+
+Available since 5.15.
+
 .TP
 .B IORING_OP_OPENAT2
 Issue the equivalent of a
@@ -654,6 +686,22 @@ should be set to the address of the open_how structure. See also
 .BR openat2(2)
 for the general description of the related system call. Available since 5.6.
 
+If the
+.I file_index
+field is set to a positive number, the file won't be installed into the
+normal file table as usual but will be placed into the fixed file table at index
+.I file_index - 1.
+In this case, instead of returning a file descriptor, the result will contain
+either 0 on success or an error. If there is already a file registered at this
+index, the request will fail with
+.B -EBADF.
+Only io_uring has access to such files and no other syscall can use them. See
+.B IOSQE_FIXED_FILE
+and
+.B IORING_REGISTER_FILES.
+
+Available since 5.15.
+
 .TP
 .B IORING_OP_CLOSE
 Issue the equivalent of a
-- 
2.33.0

