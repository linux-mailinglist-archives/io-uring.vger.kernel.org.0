Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6045F40763A
	for <lists+io-uring@lfdr.de>; Sat, 11 Sep 2021 13:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232239AbhIKLNx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Sep 2021 07:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbhIKLNx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Sep 2021 07:13:53 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2FBBC061574
        for <io-uring@vger.kernel.org>; Sat, 11 Sep 2021 04:12:40 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id i3so2971421wmq.3
        for <io-uring@vger.kernel.org>; Sat, 11 Sep 2021 04:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=4VLpTG0ZVENOMUBsiF1DWd/wgkV9BVasFPU16qCzV34=;
        b=IiTEvgWyyq1FM/LjOcelTCka9rgcVvqBk1+HxCz6qDdMnQ7QjibIAWEgklHq+VxkEo
         c/o2enkOLzVKJ+AqkLyA6rV+4sF16jZkmL913PqlYHzv3GWlT2VG++WofoozNllYJ6ZB
         PLX9jpsm+pXu406mlGP07GTjDED4VsEUi6zCtiJvrLbSQLdH5HSOuVeFS4DpfZoBXWAw
         wYviULyoHL6vR7PwPOgWOSYL5k6U12CC8yCPCumIpZL9s9FOmerTBY+k3PauPcm681A1
         idJwbl8943xzZ8YhLCxIQ3zivdEwgnprYSTKksBGjcAwMcWPz2lnfiixi2Y5DWxrj9f5
         fd6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4VLpTG0ZVENOMUBsiF1DWd/wgkV9BVasFPU16qCzV34=;
        b=RfF22MqXW0au2BbmKCuu8m0BS03T66qz+hu7IeLPtVkpeeRSYwV83tLp2teX2Vfd7d
         4w+6fVEB7UiFlPtg8VAvyGixrVRnr3Vp+qhYAhjCnuHqUuo1raqn+vVk2qeaftYleB9q
         95bONK0Uf+P6FracsBPnmOV++pM/E3dPygbrqXPhetFJ8bL89UX5ehDN1Dt8uHjkBrtM
         bx/0ZyBatG7akSxozPFZYRv67peOBP4Qb/psGK2ggIjlVlbcrxmYeXqId0CF6V7WlesL
         btxpbGY6nGMtHKtxAInyESsFDLyDEWpGin3AEFGLjuXdZp2X9ymkRDHX5gjxN75ovoA8
         Zt2Q==
X-Gm-Message-State: AOAM532GxpipFDtM73OEh3r5y4rOC5l1mexkFO0cxbeYwzVbfT3yOe8y
        lPVLN9IbLYrr1x4yEuWjg4iQ5v+Y5d8=
X-Google-Smtp-Source: ABdhPJxi94E1Xp9GN73ZvkpI4SHys5H3tBcNeOGPMN4kBC0K/Plk8uSOJ9PhtpAAPWGWMLaWG7MbbA==
X-Received: by 2002:a1c:4384:: with SMTP id q126mr2287631wma.155.1631358759253;
        Sat, 11 Sep 2021 04:12:39 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.175])
        by smtp.gmail.com with ESMTPSA id x11sm1335470wmk.21.2021.09.11.04.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Sep 2021 04:12:38 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing v2 1/2] tests: add no-op executable for exec
Date:   Sat, 11 Sep 2021 12:11:55 +0100
Message-Id: <ed97597635e67d750bff377bdf68d03e1eb022e5.1631358658.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1631358658.git.asml.silence@gmail.com>
References: <cover.1631358658.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are differences between close and exec from io_uring perspective,
so we want to test exec as well. For that we need a program doing
nothing to exec into.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 .gitignore         | 1 +
 test/Makefile      | 2 ++
 test/exec-target.c | 4 ++++
 3 files changed, 7 insertions(+)
 create mode 100644 test/exec-target.c

diff --git a/.gitignore b/.gitignore
index df0f740..0213bfa 100644
--- a/.gitignore
+++ b/.gitignore
@@ -129,6 +129,7 @@
 /test/sqpoll-cancel-hang
 /test/testfile
 /test/submit-link-fail
+/test/exec-target
 /test/*.dmesg
 
 config-host.h
diff --git a/test/Makefile b/test/Makefile
index 2313fcc..54ee730 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -135,6 +135,7 @@ test_targets += \
 	wakeup-hang \
 	sendmsg_fs_cve \
 	rsrc_tags \
+	exec-target \
 	# EOL
 
 all_targets += $(test_targets)
@@ -276,6 +277,7 @@ test_srcs := \
 	wakeup-hang.c \
 	sendmsg_fs_cve.c \
 	rsrc_tags.c \
+	exec-target.c \
 	# EOL
 
 test_objs := $(patsubst %.c,%.ol,$(patsubst %.cc,%.ol,$(test_srcs)))
diff --git a/test/exec-target.c b/test/exec-target.c
new file mode 100644
index 0000000..50bc2c9
--- /dev/null
+++ b/test/exec-target.c
@@ -0,0 +1,4 @@
+int main(int argc, char *argv[])
+{
+	return 0;
+}
-- 
2.33.0

