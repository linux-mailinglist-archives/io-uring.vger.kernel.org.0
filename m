Return-Path: <io-uring+bounces-12779-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mEomFUYov2k6xAMAu9opvQ
	(envelope-from <io-uring+bounces-12779-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 22 Mar 2026 00:22:46 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C07022E7A0A
	for <lists+io-uring@lfdr.de>; Sun, 22 Mar 2026 00:22:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 390EE301B151
	for <lists+io-uring@lfdr.de>; Sat, 21 Mar 2026 23:22:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB58B2D94AB;
	Sat, 21 Mar 2026 23:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FFdVnCvy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476ED31197C
	for <io-uring@vger.kernel.org>; Sat, 21 Mar 2026 23:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774135359; cv=none; b=l+ok+We4zYqIJBR6YacMcW2ZHHePEyNc/GK18k2/+XQDvAjfWBxvyvAYL1h9pzR9P6FeuCsbiQAQiXJylgfBM9rLdu27zkIftSw7SP7E7bqAwZDweznnb/QoRdbtx7/qKWkkLn3C4J46MSL+ihvp3akEkFg6hVc8WZp5SsZDRq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774135359; c=relaxed/simple;
	bh=Cbpz0wTAAecCENpy6dkwCR4y4KV7gT+LUo7v+qu5ORo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XSxbXRqPSDf7uwvQrXg90+uwNhXU4gF2hMttxJ85H9cPyIyvWMeYbPyvt8PRM5/wr81qBEqEzA+YZXXWG50IBapaUV4Sdy9g10kOuGksqXGEdSwFvZKIO1vq+rCt/3unB7UPGHcpTL3a7vyaBxdKNBF+7bb2f0chbuCiHsBznuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FFdVnCvy; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-43b3f91a7abso1789778f8f.1
        for <io-uring@vger.kernel.org>; Sat, 21 Mar 2026 16:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774135356; x=1774740156; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LG7/xv1ED2/Fp38bMgbYCLmyS3o8XB4jo/Ro8g7rHKM=;
        b=FFdVnCvyVWpntrzhlQyKVMbLcgTNXc+mVkgAPTV2k7xxGZswIt0fp8AJKIyEVZaqkj
         ceGvVBdWFdap+qmnCBhpuYASsN+iEhGHGPePQ0ZH3upfDJCPgedu3RFXSD78Ak4X9Rfv
         8PXz7DbrDznfJ8eNtPErIm/HALMc9pSp3SjyMPE94us1GoTw5O7xqo9k33q8GU5hBZcv
         VLaIB84KSZvnPQKtYWMeOVUs58C3uXaXQsrfMbDGQKmh0uKaUjteCLflzUYtyiCVsMzX
         SOoGXdshbfntpSdYfGLlDSSoDwMjSlrl5B8PFKh2AasTiKoQJB3PlxpnKs/Vk9zNJ4rl
         AiDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774135356; x=1774740156;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LG7/xv1ED2/Fp38bMgbYCLmyS3o8XB4jo/Ro8g7rHKM=;
        b=EfWKpShh7ixzaAfZUCXTMkLcbYcjcoUQ151fNXXkRPZGOqstjNtwDlxdgDIMlq2owI
         Vyz8ByIOb3rPSyniwRYPopDXMSKKhPFjWOBB18llMU3w6UisZv1KSlIznhWrNMrKp8wg
         vI2NsfCXUQMzq23H3PJOyaiLrwVVWvXVXU4+iJeurVgemo8fWCTzTvItQPrC8N54TR91
         k5xYHlwhnzS5ZT3XXKPEkbbWVftPiYbTl24mi2l8jauXQ4/8mxBT9WRoWK5qgl906MFS
         D8X/wPzIgk4XFqfp9ZpCQ/hnHInmL39Uj2JxHtGveHtR69JXP18reRdu4zZnDr+t3lkL
         buhA==
X-Gm-Message-State: AOJu0Yxm7zeWYiZ4bNM3HXckRNtOPdvBR/1z3F5GcH9nPG1wC9eT6ta1
	1nprCCfA6qwQ8Hqdzsa9RhEjNbu2mOHj1oM8u5FpJhNFNdupiFDFdgANk4jHfGmc5ys=
X-Gm-Gg: ATEYQzxmrqI+jJO5f5QuN7aReoAVqw3wYQi8wr80rIRD+QaovXt6bq5YW6IvwK7WEBn
	whfrG2HsiBRFwjBShVQIEz24W1K1mysvNTYNuHAANYGrniO3OLIAyH7FnAhEygoR1MpqQTRuvJT
	veAZwA/2yNm3Zpmkqf3xger7ipx7YQFZbE3uDy7A2QMCJDTswYjLRisaiKXdWGiKHsBkQRKnpDO
	o6LuVqhnhK0tjgLBALODhSS+Ufin4sUDFJ+AlEApUieIpmZeQnatqAXV9rB59BSP0WDj1o7vrjA
	K6wBhNCNLJXbV70D0du5tA+3p/8tLTnmm/L5wsvxoLBrCeSx00CR8TVtlCvtIHgdibnwlXY4lUL
	Fy5XjUgxLd2DzGKEY95sq/wOsAAprMDxLTPqPlllCS83d4EC5BYkqPUUg/AVe+9etKfYvii9uka
	xX5CXdqTr8e7Lkv3hm2W1qW8lH1UOQY2DALnGXQNtT4rUOAkP9qBWCm7xQ9O0=
X-Received: by 2002:a05:6000:2406:b0:43b:6356:7d00 with SMTP id ffacd0b85a97d-43b6424e6b0mr11637182f8f.17.1774135356276;
        Sat, 21 Mar 2026 16:22:36 -0700 (PDT)
Received: from ddp-thinkpad.tail20b0d.ts.net ([95.141.20.197])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b6425eeb4sm15609897f8f.0.2026.03.21.16.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 16:22:35 -0700 (PDT)
From: Daniele Di Proietto <daniele.di.proietto@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Daniele Di Proietto <daniele.di.proietto@gmail.com>
Subject: [PATCH v3 3/4] fs: Export new helper do_replace_fd_locked()
Date: Sat, 21 Mar 2026 23:21:41 +0000
Message-ID: <20260321232142.911280-4-daniele.di.proietto@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260321232142.911280-1-daniele.di.proietto@gmail.com>
References: <20260321232142.911280-1-daniele.di.proietto@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12779-lists,io-uring=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[kernel.dk,kernel.org,gmail.com,vger.kernel.org,zeniv.linux.org.uk,suse.cz];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[danielediproietto@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C07022E7A0A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

This is a new helper that installs a new file in a specific fd number
and returns the previous file that was there. It requires holding the
files_lock.

In order to keep ksys_dup3() simple, this commit introduces a new
static do_dup3() helper.

It's going to be used in a future commit.

Signed-off-by: Daniele Di Proietto <daniele.di.proietto@gmail.com>
---
 fs/file.c     | 97 +++++++++++++++++++++++++++++++++------------------
 fs/internal.h |  3 ++
 2 files changed, 66 insertions(+), 34 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 573ab3b5191e..ac79763c4ac7 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -1290,13 +1290,33 @@ bool get_close_on_exec(unsigned int fd)
 	return res;
 }
 
-static int do_dup2(struct files_struct *files,
-	struct file *file, unsigned fd, unsigned flags)
-__releases(&files->file_lock)
+/**
+ * do_replace_fd_locked() - Installs a file on a specific fd number.
+ * @files: struct files_struct to install the file on.
+ * @file: struct file to be installed.
+ * @fd: number in the files table to replace
+ * @flags: the O_* flags to apply to the new fd entry
+ *
+ * Installs a @file on the specific @fd number on the @files table.
+ *
+ * The caller must makes sure that @fd fits inside the @files table, likely via
+ * expand_files().
+ *
+ * Requires holding @files->file_lock.
+ *
+ * This helper handles its own reference counting of the incoming
+ * struct file.
+ *
+ * Returns a preexisting file in @fd, if any, NULL, if none or an error.
+ */
+struct file *do_replace_fd_locked(struct files_struct *files, struct file *file,
+				  unsigned int fd, unsigned int flags)
 {
 	struct file *tofree;
 	struct fdtable *fdt;
 
+	lockdep_assert_held(&files->file_lock);
+
 	/*
 	 * dup2() is expected to close the file installed in the target fd slot
 	 * (if any). However, userspace hand-picking a fd may be racing against
@@ -1327,26 +1347,19 @@ __releases(&files->file_lock)
 	fd = array_index_nospec(fd, fdt->max_fds);
 	tofree = rcu_dereference_raw(fdt->fd[fd]);
 	if (!tofree && fd_is_open(fd, fdt))
-		goto Ebusy;
+		return ERR_PTR(-EBUSY);
 	get_file(file);
 	rcu_assign_pointer(fdt->fd[fd], file);
 	__set_open_fd(fd, fdt, flags & O_CLOEXEC);
-	spin_unlock(&files->file_lock);
 
-	if (tofree)
-		filp_close(tofree, files);
-
-	return fd;
-
-Ebusy:
-	spin_unlock(&files->file_lock);
-	return -EBUSY;
+	return tofree;
 }
 
 int replace_fd(unsigned fd, struct file *file, unsigned flags)
 {
-	int err;
 	struct files_struct *files = current->files;
+	struct file *tofree;
+	int err;
 
 	if (!file)
 		return close_fd(fd);
@@ -1358,9 +1371,14 @@ int replace_fd(unsigned fd, struct file *file, unsigned flags)
 	err = expand_files(files, fd);
 	if (unlikely(err < 0))
 		goto out_unlock;
-	err = do_dup2(files, file, fd, flags);
-	if (err < 0)
-		return err;
+	tofree = do_replace_fd_locked(files, file, fd, flags);
+	spin_unlock(&files->file_lock);
+
+	if (IS_ERR(tofree))
+		return PTR_ERR(tofree);
+
+	if (tofree)
+		filp_close(tofree, files);
 	return 0;
 
 out_unlock:
@@ -1421,11 +1439,29 @@ int receive_fd_replace(int new_fd, struct file *file, unsigned int o_flags)
 	return new_fd;
 }
 
-static int ksys_dup3(unsigned int oldfd, unsigned int newfd, int flags)
+static struct file *do_dup3(struct files_struct *files, unsigned int oldfd,
+			    unsigned int newfd, int flags)
+	__releases(files->file_lock) __acquires(files->file_lock)
 {
-	int err = -EBADF;
 	struct file *file;
+	int err = 0;
+
+	err = expand_files(files, newfd);
+	file = files_lookup_fd_locked(files, oldfd);
+	if (unlikely(!file))
+		return ERR_PTR(-EBADF);
+	if (unlikely(err < 0)) {
+		if (err == -EMFILE)
+			err = -EBADF;
+		return ERR_PTR(err);
+	}
+	return do_replace_fd_locked(files, file, newfd, flags);
+}
+
+static int ksys_dup3(unsigned int oldfd, unsigned int newfd, int flags)
+{
 	struct files_struct *files = current->files;
+	struct file *to_free;
 
 	if ((flags & ~O_CLOEXEC) != 0)
 		return -EINVAL;
@@ -1437,22 +1473,15 @@ static int ksys_dup3(unsigned int oldfd, unsigned int newfd, int flags)
 		return -EBADF;
 
 	spin_lock(&files->file_lock);
-	err = expand_files(files, newfd);
-	file = files_lookup_fd_locked(files, oldfd);
-	if (unlikely(!file))
-		goto Ebadf;
-	if (unlikely(err < 0)) {
-		if (err == -EMFILE)
-			goto Ebadf;
-		goto out_unlock;
-	}
-	return do_dup2(files, file, newfd, flags);
-
-Ebadf:
-	err = -EBADF;
-out_unlock:
+	to_free = do_dup3(files, oldfd, newfd, flags);
 	spin_unlock(&files->file_lock);
-	return err;
+
+	if (IS_ERR(to_free))
+		return PTR_ERR(to_free);
+	if (to_free)
+		filp_close(to_free, files);
+
+	return newfd;
 }
 
 SYSCALL_DEFINE3(dup3, unsigned int, oldfd, unsigned int, newfd, int, flags)
diff --git a/fs/internal.h b/fs/internal.h
index 3a26252dcdae..c3d1eaf65328 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -197,6 +197,9 @@ extern struct file *do_file_open_root(const struct path *,
 extern struct open_how build_open_how(int flags, umode_t mode);
 extern int build_open_flags(const struct open_how *how, struct open_flags *op);
 struct file *file_close_fd_locked(struct files_struct *files, unsigned fd);
+struct file *do_replace_fd_locked(struct files_struct *files, struct file *file,
+				  unsigned int fd, unsigned int flags)
+	__must_hold(files->file_lock);
 int expand_files(struct files_struct *files, unsigned int nr)
 	__releases(files->file_lock) __acquires(files->file_lock);
 
-- 
2.43.0


