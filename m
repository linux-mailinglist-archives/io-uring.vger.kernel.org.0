Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C795F3FCD80
	for <lists+io-uring@lfdr.de>; Tue, 31 Aug 2021 21:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239988AbhHaTGz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Aug 2021 15:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239852AbhHaTGy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Aug 2021 15:06:54 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D2A6C061575
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 12:05:59 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id q11so684765wrr.9
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 12:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y7z6asOEB+V7nZVlFjPNfz+N0Tn05raHKoG2+B44c50=;
        b=p8lWo1zpkw3xqSJZJoY77lT2Y37GS3HIfoOYbSMaTV9GGMgsBiIw3B1WzdoQUW0Zt+
         s37P3zU2EZu1CGRntJCWE8BqS65WRfVb3Uqkql9k6mlQ+GPIZ1S2DNmo8A+bEbrOvX83
         XdF0+J3sn1JytC4UrXC4qrc8lLuwpgubinv2xTotgSSnR9Hnyg8ATRALa9S/m/S2iKeV
         888MWazpxF4jW9dfrPNt4uw22q5eMQURfRfHEu+V9LBUm0OyEDyv7cMAmLLSjyvov3wY
         ika04+/8ZUpxi2EOF5ulswmR7UosCscHzk5N2+p0aa87GNOfpYou/eY8oqJ/o58NoOul
         TidA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y7z6asOEB+V7nZVlFjPNfz+N0Tn05raHKoG2+B44c50=;
        b=Ltg1OY1ZUl4oN3H33hddCu0FEqRDDSzgWVFmBvYZCdCPbouPPCCsjEiz3U4G1COB+b
         kjyL018DaekWJu/ukAGzCS1FuC2iPsFKA4+bvtotvMQ9rNJO2wSfYojB7L4FZprc/LRs
         2TREcFx0Sp//7OFhhZX5ECJmkvhK+1OW9BOBAFEfTAmOYoCeo549GcwJqYYsZJvbGVv9
         36O/auY88cHmoUexvdTPM/roF92XjuPFMBxcE6nDopM9bD7NundzEVAwUKmzu0hnhX5S
         zyy0fnyyBT8SsyQQtt3x6jznlqFldeso1v3cgxkC+nTRCwW2XZt7bd1mZmE1c0NG/D99
         2L3A==
X-Gm-Message-State: AOAM530Yi5r6pbM6BWtwBViHXmsGTfjf8140rITu3/4lAHRNFsa7mFQ/
        FxczuOl3HuNT8ouh5umwa40BWozqf+4=
X-Google-Smtp-Source: ABdhPJzn5iYIIvgm1domQHcgXo9v530Yj3DJbxTRtK3MxK+MnKbVr6ssgI59A1sqH1MoWYciXNymXg==
X-Received: by 2002:a05:6000:1627:: with SMTP id v7mr12686726wrb.195.1630436757611;
        Tue, 31 Aug 2021 12:05:57 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.138])
        by smtp.gmail.com with ESMTPSA id s7sm19256727wra.75.2021.08.31.12.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 12:05:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing v2] man: document new register/update API
Date:   Tue, 31 Aug 2021 20:05:19 +0100
Message-Id: <f456c80bb8795eb7b8c3db8279206d94ce148587.1630436406.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Document
- IORING_REGISTER_FILES2
- IORING_REGISTER_FILES_UPDATE2,
- IORING_REGISTER_BUFFERS2
- IORING_REGISTER_BUFFERS_UPDATE,

And add a couple of words on registered resources (buffers, files)
tagging.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: bunch of small changes (Jens)
    fix incorrect struct names 


 man/io_uring_register.2 | 151 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 150 insertions(+), 1 deletion(-)

diff --git a/man/io_uring_register.2 b/man/io_uring_register.2
index a17e411..1a348d1 100644
--- a/man/io_uring_register.2
+++ b/man/io_uring_register.2
@@ -95,6 +95,99 @@ wait for those to finish before proceeding.
 An application need not unregister buffers explicitly before shutting
 down the io_uring instance. Available since 5.1.
 
+.TP
+.B IORING_REGISTER_BUFFERS2
+Register buffers for I/O. Similar to
+.B IORING_REGISTER_BUFFERS
+but aims to have a more extensible ABI.
+
+.I arg
+points to a
+.I struct io_uring_rsrc_register,
+and
+.I nr_args
+should be set to the number of bytes in the structure.
+
+.PP
+.in +8n
+.EX
+struct io_uring_rsrc_register {
+    __u32 nr;
+    __u32 resv;
+    __u64 resv2;
+    __aligned_u64 data;
+    __aligned_u64 tags;
+};
+
+.EE
+.in
+.PP
+
+.in +8n
+
+The
+.I data
+field contains a pointer to a
+.I struct iovec
+array of
+.I nr
+entries.
+The
+.I tags
+field should either be 0, then tagging is disabled, or point to an array
+of
+.I nr
+"tags" (unsigned 64 bit integers). If a tag is zero, then tagging for this
+particular resource (a buffer in this case) is disabled. Otherwise, after the
+resource had been unregistered and it's not anymore used, a CQE will be
+posted with
+.I user_data
+set to the specified tag and all other fields zeroed.
+
+Note that resource updates, e.g.
+.B IORING_REGISTER_BUFFERS_UPDATE,
+don't necessarily deallocate resources by the time it returns, but they might
+be held alive until all requests using it complete.
+
+Available since 5.13.
+
+.TP
+.B IORING_REGISTER_BUFFERS_UPDATE
+Updates registered buffers with new ones, either turning a sparse entry into
+a real one, or replacing an existing entry.
+
+.I arg
+must contain a pointer to a struct io_uring_rsrc_update2, which contains
+an offset on which to start the update, and an array of
+.I struct iovec.
+.I tags
+points to an array of tags.
+.I nr
+must contain the number of descriptors in the passed in arrays.
+See
+.B IORING_REGISTER_BUFFERS2
+for the resource tagging description.
+
+.PP
+.in +8n
+.EX
+
+struct io_uring_rsrc_update2 {
+    __u32 offset;
+    __u32 resv;
+    __aligned_u64 data;
+    __aligned_u64 tags;
+    __u32 nr;
+    __u32 resv2;
+};
+.EE
+.in
+.PP
+
+.in +8n
+
+Available since 5.13.
+
 .TP
 .B IORING_UNREGISTER_BUFFERS
 This operation takes no argument, and
@@ -138,6 +231,37 @@ Files are automatically unregistered when the io_uring instance is
 torn down. An application need only unregister if it wishes to
 register a new set of fds. Available since 5.1.
 
+.TP
+.B IORING_REGISTER_FILES2
+Register files for I/O. similar to
+.B IORING_REGISTER_FILES.
+
+.I arg
+points to a
+.I struct io_uring_rsrc_register,
+and
+.I nr_args
+should be set to the number of bytes in the structure.
+
+The
+.I data
+field contains a pointer to an array of
+.I nr
+file descriptors (signed 32 bit integers).
+.I tags
+field should either be 0 or or point to an array of
+.I nr
+"tags" (unsigned 64 bit integers). See
+.B IORING_REGISTER_BUFFERS2
+for more info on resource tagging.
+
+Note that resource updates, e.g.
+.B IORING_REGISTER_FILES_UPDATE,
+don't necessarily deallocate resources, but might hold it until all
+requests using it complete.
+
+Available since 5.13.
+
 .TP
 .B IORING_REGISTER_FILES_UPDATE
 This operation replaces existing files in the registered file set with new
@@ -146,7 +270,9 @@ real one, removing an existing entry (new one is set to -1), or replacing
 an existing entry with a new existing entry.
 
 .I arg
-must contain a pointer to a struct io_uring_files_update, which contains
+must contain a pointer to a
+.I struct io_uring_files_update,
+which contains
 an offset on which to start the update, and an array of file descriptors to
 use for the update.
 .I nr_args
@@ -158,6 +284,29 @@ File descriptors can be skipped if they are set to
 Skipping an fd will not touch the file associated with the previous
 fd at that index. Available since 5.12.
 
+.TP
+.B IORING_REGISTER_FILES_UPDATE2
+Similar to IORING_REGISTER_FILES_UPDATE, replaces existing files in the
+registered file set with new ones, either turning a sparse entry (one where
+fd is equal to -1) into a real one, removing an existing entry (new one is
+set to -1), or replacing an existing entry with a new existing entry.
+
+.I arg
+must contain a pointer to a
+.I struct io_uring_rsrc_update2,
+which contains
+an offset on which to start the update, and an array of file descriptors to
+use for the update stored in
+.I data.
+.I tags
+points to an array of tags.
+.I nr
+must contain the number of descriptors in the passed in arrays.
+See
+.B IORING_REGISTER_BUFFERS2
+for the resource tagging description.
+
+Available since 5.13.
 
 .TP
 .B IORING_UNREGISTER_FILES
-- 
2.33.0

