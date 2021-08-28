Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241C63FA74E
	for <lists+io-uring@lfdr.de>; Sat, 28 Aug 2021 21:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbhH1TTp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Aug 2021 15:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbhH1TTo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Aug 2021 15:19:44 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59ADC061756
        for <io-uring@vger.kernel.org>; Sat, 28 Aug 2021 12:18:53 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id i6so15907059wrv.2
        for <io-uring@vger.kernel.org>; Sat, 28 Aug 2021 12:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wPHd+ZoSLH+2F0Uc/YqsNzYzhfADgo8S8phfQNc870s=;
        b=sSObxA90T7TsRiASioETfFptIbp6LV3ogRv2b/c5jc701dcW4UBV1v+uuYOAN7LI/X
         kyG1qeEY9kTBWDEgr3xh5C6ijPdwc/p9xHb+BE1mLuFV9t677WrTTWGnIt6zgC3P9NqW
         Gc8IP58v24ZuuNT0nj3fGV2Nc4A+hPYO3R9deGjrdqf1oU3HXCAs+HwNDbjAECm/rDSg
         0WV4iqLENiMM390LSquGmRpGKWQ6cyXxySwEuwI/snFsICWdmjMBDc8AQcdb+rnhZwOh
         6s5UcjVc7rnv78mu2QlSOlchzOkbWOrruaFY0OpJEwx0xsmU6WEkLxqcSW3tPucU4OYd
         vtwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wPHd+ZoSLH+2F0Uc/YqsNzYzhfADgo8S8phfQNc870s=;
        b=fJgECy/K6MhQhTKINELKWq9PRm7h3H1NDDqR85IB8F1x6oKY0X0Fex9ok2cjQoUlPT
         +EL3Y6t2m6zchH+/lXi52bot7ZrDIjoNPeh/g3kz7fHGhyT6Ezf9hGnjkPcNVmb+lbyO
         f0erujC1i9sHwScjZveMUlSl/m9MS31RYGI+PfgoWvWFFXJgntn/J1/X+4KXyIaaif2a
         ucMQvY+U1bRJMHYO9LFRUsNdoh+cuohyVO21EVU2Q8zoz9DLEmgAMpHKBERSvagp7nt6
         Aeoik8oAppKzny6s/d51cWd4uUiGQ6As2QmX8dnIjdstwDOTg9yF1WqLk+JXYA1XxSi0
         2sig==
X-Gm-Message-State: AOAM530qBOAhX1xdNG9+3hm5PBwWiAT27xe3zPp/J7i8DNeN1OigF7Hn
        qbzb0NO4nRBgHjaaDTfwdw0=
X-Google-Smtp-Source: ABdhPJyYenSnS/6k+wN/D3yVsB2lOPzeZ7KkBoWD8o9mNOQgqT/ajpXxqngT2ywvcXL5O06M2g1j0A==
X-Received: by 2002:adf:c54a:: with SMTP id s10mr17418197wrf.125.1630178332344;
        Sat, 28 Aug 2021 12:18:52 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.102])
        by smtp.gmail.com with ESMTPSA id h11sm17429533wmc.23.2021.08.28.12.18.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 12:18:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [DRAFT liburing] man: document new register/update API
Date:   Sat, 28 Aug 2021 20:18:13 +0100
Message-Id: <17729362b172d19efe3dc51ab812f38461f51cc0.1630178128.git.asml.silence@gmail.com>
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

Most likely there is a bunch of silly typos, half-edited phrases and
mixed "buffer" with "file". Draft, will proof-read later.

 man/io_uring_register.2 | 141 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 140 insertions(+), 1 deletion(-)

diff --git a/man/io_uring_register.2 b/man/io_uring_register.2
index a8479fd..ac99847 100644
--- a/man/io_uring_register.2
+++ b/man/io_uring_register.2
@@ -95,6 +95,92 @@ wait for those to finish before proceeding.
 An application need not unregister buffers explicitly before shutting
 down the io_uring instance. Available since 5.1.
 
+.TP
+.B IORING_REGISTER_BUFFERS2
+Register buffers for I/O. similar to
+.B IORING_REGISTER_BUFFERS
+but aims to have a more extensible ABI.
+
+.I arg
+points to a
+.I struct io_uring_rsrc_register,
+.I nr_args
+should be set to the number of bytes in the structure.
+
+Field
+.I data
+contains a pointer to a
+.I struct iovec
+array of
+.I nr
+entries.
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
+don't necessarily deallocates resources by the time it returns, but they might
+be hold alive until all requests using it complete.
+
+Available since 5.13.
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
+.TP
+.B IORING_REGISTER_BUFFERS_UPDATE
+Updates registered buffers with new ones, either turning a sparse entry into
+a real one, or replacing an existing entry.
+
+.I arg
+must contain a pointer to a struct io_uring_files_update2, which contains
+an offset on which to start the update, and an array of
+.I struct iovec.
+.I tags
+points to an array of tags, for resource tagging description see
+.B IORING_REGISTER_BUFFERS2.
+.I nr
+must contain the number of descriptors in the passed in arrays.
+
+Available since 5.13.
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
+
 .TP
 .B IORING_UNREGISTER_BUFFERS
 This operation takes no argument, and
@@ -138,6 +224,36 @@ Files are automatically unregistered when the io_uring instance is
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
+.I nr_args
+should be set to the number of bytes in the structure.
+
+Field
+.I data
+contains a pointer to an array of
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
+don't necessarily deallocates resources, but might hold it until all
+requests using it complete.
+
+Available since 5.13.
+
 .TP
 .B IORING_REGISTER_FILES_UPDATE
 This operation replaces existing files in the registered file set with new
@@ -146,7 +262,9 @@ real one, removing an existing entry (new one is set to -1), or replacing
 an existing entry with a new existing entry.
 
 .I arg
-must contain a pointer to a struct io_uring_files_update, which contains
+must contain a pointer to a
+.I struct io_uring_files_update,
+which contains
 an offset on which to start the update, and an array of file descriptors to
 use for the update.
 .I nr_args
@@ -158,6 +276,27 @@ File descriptors can be skipped if they are set to
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
+.I struct io_uring_files_update2,
+which contains
+an offset on which to start the update, and an array of file descriptors to
+use for the update stored in
+.I data.
+.I tags
+points to an array of tags, for resource tagging description see
+.B IORING_REGISTER_BUFFERS2.
+.I nr
+must contain the number of descriptors in the passed in arrays.
+
+Available since 5.13.
 
 .TP
 .B IORING_UNREGISTER_FILES
-- 
2.33.0

