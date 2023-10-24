Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD777D5A93
	for <lists+io-uring@lfdr.de>; Tue, 24 Oct 2023 20:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344131AbjJXSfc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 Oct 2023 14:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343922AbjJXSfb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 Oct 2023 14:35:31 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B716AA2
        for <io-uring@vger.kernel.org>; Tue, 24 Oct 2023 11:35:28 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id ca18e2360f4ac-7a66bf80fa3so54807339f.0
        for <io-uring@vger.kernel.org>; Tue, 24 Oct 2023 11:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1698172528; x=1698777328; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Rh49hnxveSHpPqxFNsKHQhjblqpWbfArPQXsCbv9Cx8=;
        b=RXMdEFoYXYYclct+iLzPu37sZehnQ8EUeoE+F0tQkz9ROEAP9KpyhC3yygxjnzxB5f
         CsV2wNgUx6h8O0fEwOq3Quilx8S6AZSi/xHHlfxlRH065LemGBSw8d+tJPLifbbaYsFS
         POd8V2ZcsFxuumMgqW+ByTisYUq02Iny3Sb5tvPlbnfq4q58kH4BBl3QdDfX/44/rsyT
         cAmFzssiUicLysGS2IeMJmbn/LODppRvXEPNXAZMfCjpkBruqnPaESKho9ac2hNb4j2z
         Kxr2+JlyrYEUaaXShZbyecvdCHI+p20LdONNiEMQuCG40OeKkWfndDFcAcY/OAkqQNKj
         LZGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698172528; x=1698777328;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rh49hnxveSHpPqxFNsKHQhjblqpWbfArPQXsCbv9Cx8=;
        b=YpkPwOAQCX5UZcTOt1Gan1ioszBSzU0BtaSnS6n1CmRUZ45/31gTHi5lX/ca35PzY3
         Rrxu8VtUnKfRwLnk4JtM96pbRoMVRDbh1NTgLp3Yu+N8cWnqjKqI8j1uH6Sq+ccISCI6
         jQptS27rcCLHdQYeiAqjlQU8tw9gaRZ4Nu4ZvMRjvxxN5hbsxYnJdwEu/TE8UlqvGFOu
         1R+Mt+0kt/tv7ukh4NjjJQvuoIDMWwBjkr3Ipc71oa2jT9LwMWxrH5OqxcDk4nEmwrxL
         KgV0iAWsA+9paoiwodriEsH0MbegnTbN3miz2l0tglDSNVOH8JPhUN1mNtivnqvS+oT4
         iCoA==
X-Gm-Message-State: AOJu0YytgcfdZAjsYzCPIYwUwfSh1fo46UPc3bl8jbzaRaioGfLGl/yQ
        VUAOWGpbHVkTdg0YQfzzKnY4Gg==
X-Google-Smtp-Source: AGHT+IFdz/vLyj7MWTKRr/BUKOjk0rXEkOJDBYY0Lt8T3CuGdx3jA9ZeQwlZxJOIMUJWoiayiIsJVw==
X-Received: by 2002:a05:6e02:4ac:b0:34e:2a69:883c with SMTP id e12-20020a056e0204ac00b0034e2a69883cmr11603414ils.1.1698172527817;
        Tue, 24 Oct 2023 11:35:27 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id dp35-20020a0566381ca300b0042b068d921esm3025149jab.16.2023.10.24.11.35.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 11:35:27 -0700 (PDT)
Message-ID: <ab4f311b-9700-4d3d-8f2e-09ccbcfb3df5@kernel.dk>
Date:   Tue, 24 Oct 2023 12:35:26 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: task hung in ext4_fallocate #2
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Dave Chinner <david@fromorbit.com>,
        Andres Freund <andres@anarazel.de>
Cc:     Theodore Ts'o <tytso@mit.edu>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Shreeya Patel <shreeya.patel@collabora.com>,
        linux-ext4@vger.kernel.org,
        =?UTF-8?Q?Ricardo_Ca=C3=B1uelo?= <ricardo.canuelo@collabora.com>,
        gustavo.padovan@collabora.com, zsm@google.com, garrick@google.com,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        io-uring@vger.kernel.org
References: <20231017033725.r6pfo5a4ayqisct7@awork3.anarazel.de>
 <20231018004335.GA593012@mit.edu>
 <20231018025009.ulkykpefwdgpfvzf@awork3.anarazel.de>
 <ZTcZ9+n+jX6UDrgd@dread.disaster.area>
 <74921cba-6237-4303-bb4c-baa22aaf497b@kernel.dk>
In-Reply-To: <74921cba-6237-4303-bb4c-baa22aaf497b@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/24/23 8:30 AM, Jens Axboe wrote:
> I don't think this is related to the io-wq workers doing non-blocking
> IO. The callback is eventually executed by the task that originally
> submitted the IO, which is the owner and not the async workers. But...
> If that original task is blocked in eg fallocate, then I can see how
> that would potentially be an issue.
> 
> I'll take a closer look.

I think the best way to fix this is likely to have inode_dio_wait() be
interruptible, and return -ERESTARTSYS if it should be restarted. Now
the below is obviously not a full patch, but I suspect it'll make ext4
and xfs tick, because they should both be affected.

Andres, any chance you can throw this into the testing mix?


diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 202c76996b62..0d946b6d36fe 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4747,7 +4747,9 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	}
 
 	/* Wait all existing dio workers, newcomers will block on i_rwsem */
-	inode_dio_wait(inode);
+	ret = inode_dio_wait(inode);
+	if (ret)
+		goto out;
 
 	ret = file_modified(file);
 	if (ret)
diff --git a/fs/inode.c b/fs/inode.c
index 84bc3c76e5cc..c4eca812b16b 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2417,17 +2417,24 @@ EXPORT_SYMBOL(inode_owner_or_capable);
 /*
  * Direct i/o helper functions
  */
-static void __inode_dio_wait(struct inode *inode)
+static int __inode_dio_wait(struct inode *inode)
 {
 	wait_queue_head_t *wq = bit_waitqueue(&inode->i_state, __I_DIO_WAKEUP);
 	DEFINE_WAIT_BIT(q, &inode->i_state, __I_DIO_WAKEUP);
+	int ret = 0;
 
 	do {
-		prepare_to_wait(wq, &q.wq_entry, TASK_UNINTERRUPTIBLE);
-		if (atomic_read(&inode->i_dio_count))
-			schedule();
+		prepare_to_wait(wq, &q.wq_entry, TASK_INTERRUPTIBLE);
+		if (!atomic_read(&inode->i_dio_count))
+			break;
+		schedule();
+		if (signal_pending(current)) {
+			ret = -ERESTARTSYS;
+			break;
+		}
 	} while (atomic_read(&inode->i_dio_count));
 	finish_wait(wq, &q.wq_entry);
+	return ret;
 }
 
 /**
@@ -2440,10 +2447,11 @@ static void __inode_dio_wait(struct inode *inode)
  * Must be called under a lock that serializes taking new references
  * to i_dio_count, usually by inode->i_mutex.
  */
-void inode_dio_wait(struct inode *inode)
+int inode_dio_wait(struct inode *inode)
 {
 	if (atomic_read(&inode->i_dio_count))
-		__inode_dio_wait(inode);
+		return __inode_dio_wait(inode);
+	return 0;
 }
 EXPORT_SYMBOL(inode_dio_wait);
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 203700278ddb..8ea0c414b173 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -936,7 +936,9 @@ xfs_file_fallocate(
 	 * the on disk and in memory inode sizes, and the operations that follow
 	 * require the in-memory size to be fully up-to-date.
 	 */
-	inode_dio_wait(inode);
+	error = inode_dio_wait(inode);
+	if (error)
+		goto out_unlock;
 
 	/*
 	 * Now AIO and DIO has drained we flush and (if necessary) invalidate
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4a40823c3c67..7dff3167cb0c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2971,7 +2971,7 @@ static inline ssize_t blockdev_direct_IO(struct kiocb *iocb,
 }
 #endif
 
-void inode_dio_wait(struct inode *inode);
+int inode_dio_wait(struct inode *inode);
 
 /**
  * inode_dio_begin - signal start of a direct I/O requests

-- 
Jens Axboe

