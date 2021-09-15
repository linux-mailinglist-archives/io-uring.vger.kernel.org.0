Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEA340CB2A
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 18:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbhIOQv1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 12:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbhIOQv0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 12:51:26 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448E5C061768
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 09:50:04 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id t35so2896012qtc.6
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 09:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:date:message-id:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=pFXyiSy5mSijsi+vyJp9AB0dIFK/hLMP5evPgimL4oI=;
        b=nT//ASu3kjB1yTgZVaPmiOOsJv/sdzgDl247t8dcGM0kHoePlSQ8SAPszJGV9J9iwg
         3G5vFa5H7CmK9wz87ZXOgKP+vMKwGBanH517h8eyTtpkrGSeOo5krQYZt4n3FZ87OB9N
         SwXyQ4pRQMNIppPyKfsGqsKPsS9fDxyg1UWFf0XoToUTYMlGYWkGqCIemk8tXTGTtH5m
         fv/3BzJuf7jYr1Oxb47jEgZxCn7WZ6pqIovl2Tdk67i5w0Z6UwyFQPU3XPGPrhr/zcS4
         Uv1N2WZTW1fvnBEphMbAQbCGTRiy0kBOYNgq4R6eWs8X+8nejdluBa73mgV7JbwZbN30
         I2lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=pFXyiSy5mSijsi+vyJp9AB0dIFK/hLMP5evPgimL4oI=;
        b=zrjBHFZiPeXdh8BSxoaZlInn0OVdFYDPyYFrTlVtn156/Gp0kAp5kXZ4E5DXfLI7v0
         ue9nE6t8TFT9fgIN5QPj+x6hrT0wi1naogpH5VzNzmiRkJW49hrpA0t7gvcxueR+oS4W
         eVRzdfooNwY2UyXcJUjiYMu3roXkifgLI4fsqNiFej1KwYRYlEXcJP1jkqpeAohUBAlC
         oxaU/gS+ypk4nxdH8LVigUaT3O8K0I4VRxcueHzWaCw+02CSS/HJagkQ/EjvwtlKAUiS
         Q6G6hBDCESb/bUA8SHM0ZY49A3+DCz9Hpfw5ou8udniGFspuP+Qmj51hJLMRMt3W4Esf
         V2Pg==
X-Gm-Message-State: AOAM5337K69VG9f0yWiz9g4Mn5IJoqHHo4OaV8U4pdues4815iDt3UqU
        iuox3IbME5o82rpW433fBvtk
X-Google-Smtp-Source: ABdhPJwxHpFS9FikZ0JUIYc0mk4r4o/AVbyPloTv5KlWztD4/Z4Jcgb2HFB09rgl94uVExhd3nfILQ==
X-Received: by 2002:ac8:7285:: with SMTP id v5mr801915qto.300.1631724603382;
        Wed, 15 Sep 2021 09:50:03 -0700 (PDT)
Received: from localhost (pool-96-237-52-188.bstnma.fios.verizon.net. [96.237.52.188])
        by smtp.gmail.com with ESMTPSA id t3sm377604qkg.2.2021.09.15.09.50.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 09:50:02 -0700 (PDT)
Subject: [PATCH v4 7/8] selinux: add support for the io_uring access controls
From:   Paul Moore <paul@paul-moore.com>
To:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Wed, 15 Sep 2021 12:50:02 -0400
Message-ID: <163172460230.88001.3182498346819815467.stgit@olly>
In-Reply-To: <163172413301.88001.16054830862146685573.stgit@olly>
References: <163172413301.88001.16054830862146685573.stgit@olly>
User-Agent: StGit/1.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

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
v4:
- no change
v3:
- removed work-in-progress warning from the description
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
index 6517f221d52c..012e8504ed9e 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -7111,6 +7111,35 @@ static int selinux_perf_event_write(struct perf_event *event)
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
@@ -7349,6 +7378,11 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
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
index 084757ff4390..698ccfdaf82d 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -254,6 +254,8 @@ struct security_class_mapping secclass_map[] = {
 	  { "integrity", "confidentiality", NULL } },
 	{ "anon_inode",
 	  { COMMON_FILE_PERMS, NULL } },
+	{ "io_uring",
+	  { "override_creds", "sqpoll", NULL } },
 	{ NULL }
   };
 

