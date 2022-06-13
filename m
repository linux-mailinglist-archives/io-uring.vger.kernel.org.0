Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC03B549F7C
	for <lists+io-uring@lfdr.de>; Mon, 13 Jun 2022 22:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbiFMUhM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jun 2022 16:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbiFMUgs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jun 2022 16:36:48 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484C1B874
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 12:26:48 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id w17so849791wrg.7
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 12:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aIHi6VLJ6lGbopMxA+h35AmNejPIvaCVJVh26XjqFqA=;
        b=Yfzy5ohSUHVWQpcc9ZTxU2riNBsZ9BaD+zKDGlMqs2NFnDJ+4vV7L+uQgt4ZOuZkkd
         Bj8Cw+jqMC4NJy5QU9c+A4o90vVJn8crF3UMGFCkXyViALyNT3Hs3aM0y/yZE4WYBKxU
         4+Yghu5hpXq+lHl3NyJNR7LUHHA0NFzfntSvZl5HAZ7RSOTQ713Ure52mMoB+w3+vynE
         7ShmS32/N0J9i7UMz3i4RSgAPrJoLK+eKpdZnaA5xBABDYBf2l1SiTHxn1nXc6g22e3h
         5BGR/81n3xMuLk6eVhjEPV3nqN7orab1WY4G4tymae7Fatt+1PiLP6/WfnYyf5tFvsIO
         zTPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aIHi6VLJ6lGbopMxA+h35AmNejPIvaCVJVh26XjqFqA=;
        b=bgoxwwG6EG9/PLnaI6aOln11X3l3hNzFsxg12QiR2GSIqFkflUf84+mp1lVOYbljJ5
         1xu1TzoxLMzqGK+I1iADvsDsX1Z7PjvysXzV+SySf2M0ighkC0BDD+sZXJYU/LoGGpOL
         6RYJn0JfCOiHDm6ja6Nfj3gtFRnKPY2weBYDXtMTKSokq3iKKHvmhMlZnnHieixFo+eY
         02jzxe8312dt6Bg/CVxlD639/g2HGRuodf/wajRnlpbeBcNNSXxf738tXh81lwdrzoMO
         putW4a9g/OJRJMK3cDTEvxi0ukl49I2+oPDCuDKmZL66t5uBgi5KvVhjvf7o00JbNw4/
         mR1A==
X-Gm-Message-State: AJIora/0C+tUSp6Rx2nL+FyJ0UW3iBv1A7zPNhgclR6Kv+S8Rmv6pBkD
        aJBrvOyWKn1kTljGFu8KHmM+vf/XgfCb4ICD
X-Google-Smtp-Source: AGRyM1s+ruvYaWGRkZgtFAapqrgmIdF4HPdonfisi6hlzmaBOE4fF4NUnNZdOgitqcSMSSJNc9zP7Q==
X-Received: by 2002:a5d:4532:0:b0:210:2c52:bac2 with SMTP id j18-20020a5d4532000000b002102c52bac2mr1196970wra.711.1655148406668;
        Mon, 13 Jun 2022 12:26:46 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b497:0:f4c0:c139:b453:c8db])
        by smtp.gmail.com with ESMTPSA id p1-20020a05600c204100b0039aef592ca0sm10163198wmg.35.2022.06.13.12.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 12:26:46 -0700 (PDT)
From:   Usama Arif <usama.arif@bytedance.com>
To:     io-uring@vger.kernel.org, axboe@kernel.dk,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [RFC 1/3] ipc/msg: split do_msgsnd into functions
Date:   Mon, 13 Jun 2022 20:26:40 +0100
Message-Id: <20220613192642.2040118-2-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220613192642.2040118-1-usama.arif@bytedance.com>
References: <20220613192642.2040118-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

do_msgsnd is split into check_and_load_msgsnd and __do_msgsnd.
This does not introduce any change in the functions' operation.
Its only needed for async msgsnd in io_uring which will be added
in a later patch.

Functions used for msgsnd and msgrcv are also declared in the
header file for use in io_uring patches later.

Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 include/linux/msg.h | 11 ++++++++++
 ipc/msg.c           | 52 ++++++++++++++++++++++++++++++++++-----------
 2 files changed, 51 insertions(+), 12 deletions(-)

diff --git a/include/linux/msg.h b/include/linux/msg.h
index 9a972a296b95..36e3116fed86 100644
--- a/include/linux/msg.h
+++ b/include/linux/msg.h
@@ -15,4 +15,15 @@ struct msg_msg {
 	/* the actual message follows immediately */
 };
 
+long check_and_load_msgsnd(int msqid, long mtype, void __user *mtext,
+			   struct msg_msg **msg, size_t msgsz);
+
+void free_msg(struct msg_msg *msg);
+
+long __do_msgsnd(int msqid, long mtype, struct msg_msg **msg,
+		 size_t msgsz, int msgflg);
+
+long ksys_msgrcv(int msqid, struct msgbuf __user *msgp, size_t msgsz,
+		 long msgtyp, int msgflg);
+
 #endif /* _LINUX_MSG_H */
diff --git a/ipc/msg.c b/ipc/msg.c
index a0d05775af2c..0682204a684e 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -839,14 +839,11 @@ static inline int pipelined_send(struct msg_queue *msq, struct msg_msg *msg,
 	return 0;
 }
 
-static long do_msgsnd(int msqid, long mtype, void __user *mtext,
-		size_t msgsz, int msgflg)
+long check_and_load_msgsnd(int msqid, long mtype, void __user *mtext,
+			   struct msg_msg **msg, size_t msgsz)
 {
-	struct msg_queue *msq;
-	struct msg_msg *msg;
-	int err;
 	struct ipc_namespace *ns;
-	DEFINE_WAKE_Q(wake_q);
+	struct msg_msg *tmp;
 
 	ns = current->nsproxy->ipc_ns;
 
@@ -855,12 +852,45 @@ static long do_msgsnd(int msqid, long mtype, void __user *mtext,
 	if (mtype < 1)
 		return -EINVAL;
 
-	msg = load_msg(mtext, msgsz);
+	tmp = load_msg(mtext, msgsz);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
-	msg->m_type = mtype;
-	msg->m_ts = msgsz;
+	tmp->m_type = mtype;
+	tmp->m_ts = msgsz;
+
+	*msg = tmp;
+	return 0;
+}
+
+static long do_msgsnd(int msqid, long mtype, void __user *mtext,
+		      size_t msgsz, int msgflg)
+{
+	struct msg_msg *msg;
+	int err;
+
+	err = check_and_load_msgsnd(msqid, mtype, mtext, &msg, msgsz);
+	if (err)
+		return err;
+
+	err = __do_msgsnd(msqid, mtype, &msg, msgsz, msgflg);
+	if (msg != NULL)
+		free_msg(msg);
+
+	return err;
+}
+
+long __do_msgsnd(int msqid, long mtype, struct msg_msg **_msg,
+		 size_t msgsz, int msgflg)
+{
+	struct msg_queue *msq;
+	struct msg_msg *msg;
+	int err;
+	struct ipc_namespace *ns;
+	DEFINE_WAKE_Q(wake_q);
+
+	msg = *_msg;
+	ns = current->nsproxy->ipc_ns;
 
 	rcu_read_lock();
 	msq = msq_obtain_object_check(ns, msqid);
@@ -940,15 +970,13 @@ static long do_msgsnd(int msqid, long mtype, void __user *mtext,
 	}
 
 	err = 0;
-	msg = NULL;
+	*_msg = NULL;
 
 out_unlock0:
 	ipc_unlock_object(&msq->q_perm);
 	wake_up_q(&wake_q);
 out_unlock1:
 	rcu_read_unlock();
-	if (msg != NULL)
-		free_msg(msg);
 	return err;
 }
 
-- 
2.25.1

