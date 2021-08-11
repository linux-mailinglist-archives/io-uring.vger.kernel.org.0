Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082013E99FD
	for <lists+io-uring@lfdr.de>; Wed, 11 Aug 2021 22:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbhHKUtz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Aug 2021 16:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbhHKUti (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Aug 2021 16:49:38 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1709C0617B9
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 13:49:03 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id c6so3222339qtv.5
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 13:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:date:message-id:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=aKsKoHqmsZAVF8Rg44lH5t0OfNGgPIxtypJyrDcBmw4=;
        b=IGSbf/s0ur37Nk3NPxnIck3BCoLugpdPaVsVyr30fmwA9kQWgXlHN0/W9s61/HjV32
         ap/AcGfdjK7GODb5rGY+xW592XMZYImEigmWW9YalL9/PXLDBZPtGVB7p98MTG32luHp
         2mCK8gO/ftHVYSiWS8ODZ4MTITXZ7D0S7KhgGqIaqRB6Kqg1U0dvKzHCmh4fap+uBoFO
         V4VOpBcQ6hzX7/gkU0pR8yAHU0LMzfR/zyhOXZf7wbWke9xZV3ZiGQaaDcWL0/YaPcnn
         myXuptVBKJeIAPRKJXIafRTsSQff8BZoPDFD27MINouLCa4HwPazChfBGjBAdPEjYRE3
         83Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=aKsKoHqmsZAVF8Rg44lH5t0OfNGgPIxtypJyrDcBmw4=;
        b=aF1Y4SpAwcjZEHaGBii/C0/fX8OY5bmhrl0ORP5ICaZ9UbU/896kOFC6hOFjW41jA+
         qi2Fp/2N3GdMFgcXx2tDOjOLSQXqM/B7e7Yacu1UjSUSzHC6X5w6H7ZhFIVCq9Ya8xMW
         k7ViDCigzjYFfykCQhNNEk1OHlqT3EO6XuH4pkVijucbkPPa/ClDJRSDU9XhV48IvHrF
         iy/AWhWrcCOF6TtgcEEOWaYuTDMCycSJE4ATtkMt13ReeqQdyIlx/RQYrwcqxfgDLBG4
         TwXoIh5k06BvYP0melhM9eopD2/Gdq+FEOKUwUrv9WkHRyJPg88DJDCT82x27gCwqO6D
         uUbQ==
X-Gm-Message-State: AOAM5320B95bghidtqoLsjkddfHIKBShf/7eKvPOPBxsdEpV4+gdrHe8
        XV0eStVRKR+GTExRRy7vDBL2
X-Google-Smtp-Source: ABdhPJwUNiEpaP+PnCDNAxzfQreTvk0/bSRZpum/ItWkECnR696IHTh5PszjLPJX8QmS68QTFRGQhw==
X-Received: by 2002:ac8:4e33:: with SMTP id d19mr579232qtw.197.1628714942836;
        Wed, 11 Aug 2021 13:49:02 -0700 (PDT)
Received: from localhost (pool-96-237-52-188.bstnma.fios.verizon.net. [96.237.52.188])
        by smtp.gmail.com with ESMTPSA id h10sm181971qta.74.2021.08.11.13.49.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 13:49:02 -0700 (PDT)
Subject: [RFC PATCH v2 8/9] selinux: add support for the io_uring access
 controls
From:   Paul Moore <paul@paul-moore.com>
To:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Date:   Wed, 11 Aug 2021 16:49:01 -0400
Message-ID: <162871494177.63873.3490371261067398163.stgit@olly>
In-Reply-To: <162871480969.63873.9434591871437326374.stgit@olly>
References: <162871480969.63873.9434591871437326374.stgit@olly>
User-Agent: StGit/1.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

WARNING - This is a work in progress, this patch, including the
description, may be incomplete or even incorrect.  You have been
warned.

This patch implements two new io_uring access controls, specifically
support for controlling the io_uring "personalities" and
IORING_SETUP_SQPOLL.  Controlling the sharing of io_urings themselves
is handled via the normal file/inode labeling and sharing mechanisms.

The io_uring { override_creds } permission restricts which domains
the subject domain can use to override it's own credentials.
Granting a domain the io_uring { override_creds } permission allows
it to impersonate another domain in io_uring operations.

The io_uring { sqpoll } permission restricts which domains can create
asynchronous io_uring polling threads.  This is important from a
security perspective as operations queued by this asynchronous thread
inherit the credentials of the thread creator by default; if an
io_uring is shared across process/domain boundaries this could result
in one domain impersonating another.  Controlling the creation of
sqpoll threads, and the sharing of io_urings across processes, allow
policy authors to restrict the ability of one domain to impersonate
another via io_uring.

As a quick summary, this patch adds a new object class with two
permissions:

 io_uring { override_creds sqpoll }

These permissions can be seen in the two simple policy statements
below:

  allow domA_t domB_t : io_uring { override_creds };
  allow domA_t self : io_uring { sqpoll };

Signed-off-by: Paul Moore <paul@paul-moore.com>

---
v2:
- made the selinux_uring_* funcs static
- removed the debugging code
v1:
- initial draft
---
 security/selinux/hooks.c            |   34 ++++++++++++++++++++++++++++++++++
 security/selinux/include/classmap.h |    2 ++
 2 files changed, 36 insertions(+)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index b0032c42333e..1fb0c76deff2 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -7105,6 +7105,35 @@ static int selinux_perf_event_write(struct perf_event *event)
 }
 #endif
 
+#ifdef CONFIG_IO_URING
+/**
+ * selinux_uring_override_creds - check the requested cred override
+ * @new: the target creds
+ *
+ * Check to see if the current task is allowed to override it's credentials
+ * to service an io_uring operation.
+ */
+static int selinux_uring_override_creds(const struct cred *new)
+{
+	return avc_has_perm(&selinux_state, current_sid(), cred_sid(new),
+			    SECCLASS_IO_URING, IO_URING__OVERRIDE_CREDS, NULL);
+}
+
+/**
+ * selinux_uring_sqpoll - check if a io_uring polling thread can be created
+ *
+ * Check to see if the current task is allowed to create a new io_uring
+ * kernel polling thread.
+ */
+static int selinux_uring_sqpoll(void)
+{
+	int sid = current_sid();
+
+	return avc_has_perm(&selinux_state, sid, sid,
+			    SECCLASS_IO_URING, IO_URING__SQPOLL, NULL);
+}
+#endif /* CONFIG_IO_URING */
+
 /*
  * IMPORTANT NOTE: When adding new hooks, please be careful to keep this order:
  * 1. any hooks that don't belong to (2.) or (3.) below,
@@ -7343,6 +7372,11 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(perf_event_write, selinux_perf_event_write),
 #endif
 
+#ifdef CONFIG_IO_URING
+	LSM_HOOK_INIT(uring_override_creds, selinux_uring_override_creds),
+	LSM_HOOK_INIT(uring_sqpoll, selinux_uring_sqpoll),
+#endif
+
 	LSM_HOOK_INIT(locked_down, selinux_lockdown),
 
 	/*
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index 62d19bccf3de..3314ad72279d 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -252,6 +252,8 @@ struct security_class_mapping secclass_map[] = {
 	  { "integrity", "confidentiality", NULL } },
 	{ "anon_inode",
 	  { COMMON_FILE_PERMS, NULL } },
+	{ "io_uring",
+	  { "override_creds", "sqpoll", NULL } },
 	{ NULL }
   };
 

