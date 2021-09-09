Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D80B4058FD
	for <lists+io-uring@lfdr.de>; Thu,  9 Sep 2021 16:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239329AbhIIO1q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Sep 2021 10:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237911AbhIIO1j (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Sep 2021 10:27:39 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11DE1C05BD30
        for <io-uring@vger.kernel.org>; Thu,  9 Sep 2021 06:07:51 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id d6so2469182wrc.11
        for <io-uring@vger.kernel.org>; Thu, 09 Sep 2021 06:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ifiDPiBYkOMxGZqf5Ih6uLntKFy5SymgTpf0yZrExj4=;
        b=qK5PANpDh6POi4iYcEsYBBLLaWS3dhoVzqkMrxnSl1SJFTuD3JARzo9KdW45bsNUcK
         jvORWy0GvR1ivp/HF5zDKoi4MFRzLOmdDGfHs2cEw3ZM7frpRU9cDninO3r7rh+Z7UB8
         M/A1k8elTqpnSomXcoV0f57rUgN3Sh6AQHkRN+BMEkuovjkymc4iIAD+5u8M/Ejscvk0
         qGQLq3bG8utaI0Bii8dGoxODdQejXuV8IYiwmGL5t85+V1/3n7/rDG6hd5uadIRaf6e/
         +SDt2QHpxyJDbqD6cYjb3Uz+cVFj9f/UF23Zi3/kX+nHSsbSaTVObWMqgaLIx+wuEqwT
         poLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ifiDPiBYkOMxGZqf5Ih6uLntKFy5SymgTpf0yZrExj4=;
        b=tkH/hk2HUPCiqOUyfQNil7hEJU9UT8QY1Pq/gO6FRMiLwJN5Ob237/W0/QTAbk7H7k
         Wh6beqXvsvC36iExLdTMEhYDtsSDIxO+xcgCiz1EN4gxeABMgY3/Z8Dmsi3RvK5pNkQh
         Wp4Qm2997+75r0FoXQHtYsSr8L8ZzCj2aR4KW9mgeTTpBdUIE5bLWI/WlMeJZKa2y1VJ
         MxybyQAOeTADNYxv6jntlW0jyBJQ1Rg9U5ENqgkdwUu8W5IbdhPLrTxIyOdLU3OM3rnl
         zjyjNpI5sFXNKyIsp/386/GV4Ueo8tQ7CEeij3LPhjLaB1ubi1iJTEWXmGW/R0l3bxIy
         7I/Q==
X-Gm-Message-State: AOAM531WRNlbsyoJ6JTuJoMIJ5BUkA4G0UxEATGnY3R867C6mIjHLFtU
        SlBP2H6/qwwtG3UT5P3/MgjNe3c/6yE=
X-Google-Smtp-Source: ABdhPJxDXvWWNM6/UpgEOsJh8gt6tKxSRYco84GbIb7HzwcKKcQXaIJ+uj/8H4U99+XyOay6yRwvpQ==
X-Received: by 2002:adf:e712:: with SMTP id c18mr3482681wrm.438.1631192869691;
        Thu, 09 Sep 2021 06:07:49 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.167])
        by smtp.gmail.com with ESMTPSA id w20sm1762096wrg.1.2021.09.09.06.07.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 06:07:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 1/2] tests: add no-op executable for exec
Date:   Thu,  9 Sep 2021 14:07:08 +0100
Message-Id: <d859a7c3c9888e88b80bbf69740d0c6a6ee79009.1631192734.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1631192734.git.asml.silence@gmail.com>
References: <cover.1631192734.git.asml.silence@gmail.com>
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
index 176c60c..66f25db 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -136,6 +136,7 @@ test_targets += \
 	sendmsg_fs_cve \
 	rsrc_tags \
 	multi_cq \
+	exec-target \
 	# EOL
 
 all_targets += $(test_targets)
@@ -278,6 +279,7 @@ test_srcs := \
 	sendmsg_fs_cve.c \
 	rsrc_tags.c \
 	multi_cq.c \
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

