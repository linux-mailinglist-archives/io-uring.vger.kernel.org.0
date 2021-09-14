Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C60240A49B
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 05:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239008AbhINDfN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Sep 2021 23:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239071AbhINDex (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Sep 2021 23:34:53 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E72D0C061766
        for <io-uring@vger.kernel.org>; Mon, 13 Sep 2021 20:33:36 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id b14so10199375qtb.0
        for <io-uring@vger.kernel.org>; Mon, 13 Sep 2021 20:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:date:message-id:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=1hmr6L0fVcZTcmxPJPnof4mx/iAEjJvjvO8eEYK9GTY=;
        b=qPuX5/vw585Sn8sXxfV2jhjIJA+UeiZ6GNll27zSXPvWdTNB/vHf1WD4O0bzXD5NHi
         icq+MFF3VqBIDNRenVQhoK4YYfRP7v4Xd5jT8GkjpEszP8GKefKDvmOeQ/QW0eNhMntv
         RkRLnQurKrgiOV36gV2Feb0lsqgzrxnSq8KOwhfk1/eSd4/9FOu36mqbeRdmyaKHB+et
         DQxU3EySubFgliQLhDeVf2qbufZvRVqUOXTduk1ZmS6iZkhwnsLU2PB/LSl+YBpYvodr
         WIaQD27zb601BeNL6ba0DzQb/wSyfzg0oxJKFGW/SV2rrWSvJxXii1hFRj5dpMK/EvJt
         XRHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=1hmr6L0fVcZTcmxPJPnof4mx/iAEjJvjvO8eEYK9GTY=;
        b=TD7hsF/s1iaf/Yr3f6ZY398FxiGh96ZFEGyoytsrleEVwjqDBoD9HqgJDrwu02wYEV
         UrxNFLmqqCtulQE7DEJ7KwLLUs8qtDuOk7OFWpNddz7EEidLFMECj7x/PzhBCf+WMtiy
         kKpRI4Iyq8XeGRRiRU819/YuvmphPjrdW0g12VdroSwmXAadcpdjgj8MSYJvCOHP6SlQ
         eSn2tCo91tlhYzt6moy0KW8xc0FdM3R0/xLyuOCaxR0UaI3jPOA3yGfomqzMpxYESd/A
         XvGD9LNewji37XarkVI9g7QdGHkQ/B2SDYG5XfB6nf/CcO7uT8YDAG5zxHxztb+2MDRK
         oMCw==
X-Gm-Message-State: AOAM533u51ir9nFowlGY7ULWqOPXfONJ4Lf/IXrrmxAtcgnZETIBxqM7
        q5S8pv+QQIL2zJ7uq0p9pz0S
X-Google-Smtp-Source: ABdhPJyIyp1hiwJfZDPM7fHYpgOdMt/MoPWfVS5fj481zKGK2WbXUsP0NNJpdTxyHYf8LDUGODkTwg==
X-Received: by 2002:ac8:7090:: with SMTP id y16mr2821209qto.19.1631590415998;
        Mon, 13 Sep 2021 20:33:35 -0700 (PDT)
Received: from localhost (pool-96-237-52-188.bstnma.fios.verizon.net. [96.237.52.188])
        by smtp.gmail.com with ESMTPSA id g13sm6740138qkk.110.2021.09.13.20.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 20:33:35 -0700 (PDT)
Subject: [PATCH v3 7/8] selinux: add support for the io_uring access controls
From:   Paul Moore <paul@paul-moore.com>
To:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Mon, 13 Sep 2021 23:33:35 -0400
Message-ID: <163159041500.470089.11310853524829799938.stgit@olly>
In-Reply-To: <163159032713.470089.11728103630366176255.stgit@olly>
References: <163159032713.470089.11728103630366176255.stgit@olly>
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
 

