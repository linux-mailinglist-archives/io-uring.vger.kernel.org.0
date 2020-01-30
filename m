Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFED914DDD0
	for <lists+io-uring@lfdr.de>; Thu, 30 Jan 2020 16:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbgA3P3q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jan 2020 10:29:46 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:33506 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727191AbgA3P3q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jan 2020 10:29:46 -0500
Received: by mail-io1-f65.google.com with SMTP id z8so4494106ioh.0
        for <io-uring@vger.kernel.org>; Thu, 30 Jan 2020 07:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=VOUdWPBKIqUsd/PS2M+PiV/rz6RJfKJyvzJyzqx4zlY=;
        b=V8zWzqgg+lxCA+hJna5QbGZ9YfEgkZf0pBIb7ik8wx0ggBezLTKmC6YW6hEJd4w41f
         /hUsMksIljG0kgIiD9ObH7gv3UYBAR5igZxME7afHqH7IFYmXFL5D144onTnx/2GqzuY
         ZWwGjFqqO6l9AySWc8NylnjELcasja9E6LMqY32/auJS4ZYT2hxkpU0Bs0hZghqaLCrJ
         8YcbdS1XUAFZLWGVgRS+gMqOCv4IY92NCiF0I/joUbi2pSPs/ucZqeHrhK76C2ydTK0c
         uzbBt1rI04UZK4bp3kx7qY6B0JABt80RRrf2Jb+OlBu+LAkkveDCxLFtD83mw2eYjp59
         A/Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=VOUdWPBKIqUsd/PS2M+PiV/rz6RJfKJyvzJyzqx4zlY=;
        b=dme3p8FenDqbPfl19g1o6vHp88n+S18fWybLiv73ng7Y+YUSHH0YhHLmKOOYA3pzC2
         oulesJ2E2wIhRvF4snCTgcaiLiapPo9enbOLkuI9LAaQFus/CJyZJkNdAh7W/hv2/arA
         Ww6tBbUjH4JD6lCjcQc3AcRtCn1HybWD2etWjSleTT0bsZxdeAT4sS5/jnK/Zk33Sx1r
         HKDTHgyWpSEKKleYBE3Bg/h91C/1OFajx1M1NmYurHrbbEUnE5CCNnk82TVTMyYrNDEu
         CWPbzQJJyY+nTfr2XEnEHjCMng97oXJvkq+813rpfukJPGF+M+W8Aymz2+MPhBOCxdHW
         NIkg==
X-Gm-Message-State: APjAAAXiHtk5ygzOqzcOwbTEW5hLDzZ6O0AGtCys9N3eVhIZbgMInBpy
        bQEOzYkR9bJLW84nzb3u38Max7dyqHM=
X-Google-Smtp-Source: APXvYqyM9Xi7NHXpahNja/HHgSCEfon5yq3pJHS1y31Zp+qAcQ2GpUF4NidoUoPw79O5Xr8RL4n0+g==
X-Received: by 2002:a6b:600f:: with SMTP id r15mr4428943iog.54.1580398185397;
        Thu, 30 Jan 2020 07:29:45 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 9sm1521290ion.18.2020.01.30.07.29.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2020 07:29:45 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Jann Horn <jannh@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH]: io_uring: add ->show_fdinfo() for the io_uring file
 descriptor
Message-ID: <e46272c7-ef66-2569-a7f4-5c12e238ddbd@kernel.dk>
Date:   Thu, 30 Jan 2020 08:29:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It can be hard to know exactly what is registered with the ring.
Especially for credentials, it'd be handy to be able to see which
ones are registered, what personalities they have, and what the ID
of each of them is.

This adds support for showing information registered in the ring from
the fdinfo of the io_uring fd. Here's an example from a test case that
registers 4 files (two of them sparse), 4 buffers, and 2 personalities:

pos:    0
flags:  02000002
mnt_id: 14
UserFiles:      4
    0: file-no-1
    1: file-no-2
    2: <none>
    3: <none>
UserBufs:       4
    0: 0x563817c46000/128
    1: 0x563817c47000/256
    2: 0x563817c48000/512
    3: 0x563817c49000/1024
Personalities:
    1
        Uid:    0               0               0               0
        Gid:    0               0               0               0
        Groups: 0
        CapEff: 0000003fffffffff
    2
        Uid:    0               0               0               0
        Gid:    0               0               0               0
        Groups: 0
        CapEff: 0000003fffffffff

Suggested-by: Jann Horn <jannh@google.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ac5340fdcdfe..41a74276572b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6501,6 +6501,79 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	return submitted ? submitted : ret;
 }
 
+static int io_uring_show_cred(int id, void *p, void *data)
+{
+	const struct cred *cred = p;
+	struct seq_file *m = data;
+	struct user_namespace *uns = seq_user_ns(m);
+	struct group_info *gi;
+	kernel_cap_t cap;
+	unsigned __capi;
+	int g;
+
+	seq_printf(m, "%5d\n", id);
+	seq_put_decimal_ull(m, "\tUid:\t", from_kuid_munged(uns, cred->uid));
+	seq_put_decimal_ull(m, "\t\t", from_kuid_munged(uns, cred->euid));
+	seq_put_decimal_ull(m, "\t\t", from_kuid_munged(uns, cred->suid));
+	seq_put_decimal_ull(m, "\t\t", from_kuid_munged(uns, cred->fsuid));
+	seq_put_decimal_ull(m, "\n\tGid:\t", from_kgid_munged(uns, cred->gid));
+	seq_put_decimal_ull(m, "\t\t", from_kgid_munged(uns, cred->egid));
+	seq_put_decimal_ull(m, "\t\t", from_kgid_munged(uns, cred->sgid));
+	seq_put_decimal_ull(m, "\t\t", from_kgid_munged(uns, cred->fsgid));
+	seq_puts(m, "\n\tGroups:\t");
+	gi = cred->group_info;
+	for (g = 0; g < gi->ngroups; g++) {
+		seq_put_decimal_ull(m, g ? " " : "",
+					from_kgid_munged(uns, gi->gid[g]));
+	}
+	seq_puts(m, "\n\tCapEff:\t");
+	cap = cred->cap_effective;
+	CAP_FOR_EACH_U32(__capi)
+		seq_put_hex_ll(m, NULL, cap.cap[CAP_LAST_U32 - __capi], 8);
+	seq_putc(m, '\n');
+	return 0;
+}
+
+static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
+{
+	int i;
+
+	mutex_lock(&ctx->uring_lock);
+	seq_printf(m, "UserFiles:\t%u\n", ctx->nr_user_files);
+	for (i = 0; i < ctx->nr_user_files; i++) {
+		struct fixed_file_table *table;
+		struct file *f;
+
+		table = &ctx->file_data->table[i >> IORING_FILE_TABLE_SHIFT];
+		f = table->files[i & IORING_FILE_TABLE_MASK];
+		if (f)
+			seq_printf(m, "%5u: %s\n", i, file_dentry(f)->d_iname);
+		else
+			seq_printf(m, "%5u: <none>\n", i);
+	}
+	seq_printf(m, "UserBufs:\t%u\n", ctx->nr_user_bufs);
+	for (i = 0; i < ctx->nr_user_bufs; i++) {
+		struct io_mapped_ubuf *buf = &ctx->user_bufs[i];
+
+		seq_printf(m, "%5u: 0x%llx/%lu\n", i, buf->ubuf, buf->len);
+	}
+	if (!idr_is_empty(&ctx->personality_idr)) {
+		seq_printf(m, "Personalities:\n");
+		idr_for_each(&ctx->personality_idr, io_uring_show_cred, m);
+	}
+	mutex_unlock(&ctx->uring_lock);
+}
+
+static void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
+{
+	struct io_ring_ctx *ctx = f->private_data;
+
+	if (percpu_ref_tryget(&ctx->refs)) {
+		__io_uring_show_fdinfo(ctx, m);
+		percpu_ref_put(&ctx->refs);
+	}
+}
+
 static const struct file_operations io_uring_fops = {
 	.release	= io_uring_release,
 	.flush		= io_uring_flush,
@@ -6511,6 +6584,7 @@ static const struct file_operations io_uring_fops = {
 #endif
 	.poll		= io_uring_poll,
 	.fasync		= io_uring_fasync,
+	.show_fdinfo	= io_uring_show_fdinfo,
 };
 
 static int io_allocate_scq_urings(struct io_ring_ctx *ctx,

-- 
Jens Axboe

