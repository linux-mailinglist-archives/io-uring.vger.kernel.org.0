Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCE31705F9
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2020 18:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgBZRX1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Feb 2020 12:23:27 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43346 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbgBZRX0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Feb 2020 12:23:26 -0500
Received: by mail-pg1-f196.google.com with SMTP id u12so1584885pgb.10
        for <io-uring@vger.kernel.org>; Wed, 26 Feb 2020 09:23:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Ayv+DSmzjrJNWUK8cn1lsMg9J+2aKdAE9zeY+oulVVA=;
        b=clY8NF2vdMMt5KBGlzRKnYEROfmCXbnHnqcNu+UkDWFdJMdWkJ5FlFDqeaRHqdVCsW
         aE+NstGgF7vui9xAeHpZtuOAUPW8DPIqwFzHCT7rIsbh1bxg9dR3b0aJNQnGg+EZtGlF
         a91vYC0prlcQ5YysAC2MzCdOH4K0bNovtNRdcgIOAwcGtTsJ6DdyplrG5xuMbndqBuwS
         FhoflE3sTAd5oC4mrizmk8w7yaDGXaKwEEfFJ27kGeWA0/6ulwrLccVKgN+pbCsL4FRh
         l1ClfUJVz3lpnSiwIluAiVmSNWq+VGLgM41jkxjvZDJAibL9w4CII9ONjgXUxynjCg5o
         x3dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Ayv+DSmzjrJNWUK8cn1lsMg9J+2aKdAE9zeY+oulVVA=;
        b=gJsV89f5n+j8Qw/AWCyUYx7nQ047J4yAWqL9RYiwrPGX0J4NoLfosv1BZTm0iHdKOh
         0LHj+SgN5ng9p1bx5KoUEaV2GCUTogfbY6DxnnuLSzla6I8Ua1XWx8nRUugACQ++iy8X
         F8F4m573nhIZnRcXpMn7kCtz5e6RqU01Rhf/JsD7KyUD7i2tVSRs4Y6H2M+NDQY7/JY0
         wzAcQEyhq9+f3Qwoym9aSUdWPdmu93gQmDRcx8W0gqPycBRQA9hWMvejDPvVCzJTh60y
         D9JK8377jjedgOY1xOpZ8yj4tNkSK/S5iXyn8MrViN1VXS4KYIh0v5Amij0g1RFTRBGk
         rhZA==
X-Gm-Message-State: APjAAAWCvTHI1USZhhT8us9COO92V4MNLsMvswxQsGqQgzfoYrkIXKEn
        9DN/eOE9B7mf5G/H/k1Q5RWMKvOuWBQdpA==
X-Google-Smtp-Source: APXvYqxzygd8rsiFRKZeMsuqp2fGsbB0W7yIZrQOImUjgS7FZyXma7FH4wnqGrENBZ5ah3bFMYEJ5g==
X-Received: by 2002:a63:180c:: with SMTP id y12mr1958340pgl.120.1582737803863;
        Wed, 26 Feb 2020 09:23:23 -0800 (PST)
Received: from ?IPv6:2620:10d:c085:21d6::137a? ([2620:10d:c090:400::5:890])
        by smtp.gmail.com with ESMTPSA id x7sm3874109pfp.93.2020.02.26.09.23.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2020 09:23:23 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: drop file set ref put/get on switch
Cc:     Dan Melnic <dmm@fb.com>
Message-ID: <38cfbeb4-708f-5029-8249-a9335cf60e3c@kernel.dk>
Date:   Wed, 26 Feb 2020 10:23:21 -0700
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

Dan reports that he triggered a warning on ring exit doing some testing:

percpu ref (io_file_data_ref_zero) <= 0 (0) after switching to atomic
WARNING: CPU: 3 PID: 0 at lib/percpu-refcount.c:160 percpu_ref_switch_to_atomic_rcu+0xe8/0xf0
Modules linked in:
CPU: 3 PID: 0 Comm: swapper/3 Not tainted 5.6.0-rc3+ #5648
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
RIP: 0010:percpu_ref_switch_to_atomic_rcu+0xe8/0xf0
Code: e7 ff 55 e8 eb d2 80 3d bd 02 d2 00 00 75 8b 48 8b 55 d8 48 c7 c7 e8 70 e6 81 c6 05 a9 02 d2 00 01 48 8b 75 e8 e8 3a d0 c5 ff <0f> 0b e9 69 ff ff ff 90 55 48 89 fd 53 48 89 f3 48 83 ec 28 48 83
RSP: 0018:ffffc90000110ef8 EFLAGS: 00010292
RAX: 0000000000000045 RBX: 7fffffffffffffff RCX: 0000000000000000
RDX: 0000000000000045 RSI: ffffffff825be7a5 RDI: ffffffff825bc32c
RBP: ffff8881b75eac38 R08: 000000042364b941 R09: 0000000000000045
R10: ffffffff825beb40 R11: ffffffff825be78a R12: 0000607e46005aa0
R13: ffff888107dcdd00 R14: 0000000000000000 R15: 0000000000000009
FS:  0000000000000000(0000) GS:ffff8881b9d80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f49e6a5ea20 CR3: 00000001b747c004 CR4: 00000000001606e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 rcu_core+0x1e4/0x4d0
 __do_softirq+0xdb/0x2f1
 irq_exit+0xa0/0xb0
 smp_apic_timer_interrupt+0x60/0x140
 apic_timer_interrupt+0xf/0x20
 </IRQ>
RIP: 0010:default_idle+0x23/0x170
Code: ff eb ab cc cc cc cc 0f 1f 44 00 00 41 54 55 53 65 8b 2d 10 96 92 7e 0f 1f 44 00 00 e9 07 00 00 00 0f 00 2d 21 d0 51 00 fb f4 <65> 8b 2d f6 95 92 7e 0f 1f 44 00 00 5b 5d 41 5c c3 65 8b 05 e5 95

Turns out that this is due to percpu_ref_switch_to_atomic() only
grabbing a reference to the percpu refcount if it's not already in
atomic mode. io_uring drops a ref and re-gets it when switching back to
percpu mode. We attempt to protect against this with the FFD_F_ATOMIC
bit, but that isn't reliable.

We don't actually need to juggle these refcounts between atomic and
percpu switch, and if we drop those, we can also drop the FFD_F_ATOMIC
bit and clean the whole thing up. With that, the io_atomic_switch() is
now useless, so drop that too.

Fixes: 05f3fb3c5397 ("io_uring: avoid ring quiesce for fixed file set unregister and update")
Reported-by: Dan Melnic <dmm@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b30cc0bcec61..7fde4bbaf183 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -185,17 +185,12 @@ struct fixed_file_table {
 	struct file		**files;
 };
 
-enum {
-	FFD_F_ATOMIC,
-};
-
 struct fixed_file_data {
 	struct fixed_file_table		*table;
 	struct io_ring_ctx		*ctx;
 
 	struct percpu_ref		refs;
 	struct llist_head		put_llist;
-	unsigned long			state;
 	struct work_struct		ref_work;
 	struct completion		done;
 };
@@ -6121,7 +6116,6 @@ static void io_ring_file_ref_switch(struct work_struct *work)
 
 	data = container_of(work, struct fixed_file_data, ref_work);
 	io_ring_file_ref_flush(data);
-	percpu_ref_get(&data->refs);
 	percpu_ref_switch_to_percpu(&data->refs);
 }
 
@@ -6293,14 +6287,6 @@ static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
 #endif
 }
 
-static void io_atomic_switch(struct percpu_ref *ref)
-{
-	struct fixed_file_data *data;
-
-	data = container_of(ref, struct fixed_file_data, refs);
-	clear_bit(FFD_F_ATOMIC, &data->state);
-}
-
 static bool io_queue_file_removal(struct fixed_file_data *data,
 				  struct file *file)
 {
@@ -6321,11 +6307,7 @@ static bool io_queue_file_removal(struct fixed_file_data *data,
 	llist_add(&pfile->llist, &data->put_llist);
 
 	if (pfile == &pfile_stack) {
-		if (!test_and_set_bit(FFD_F_ATOMIC, &data->state)) {
-			percpu_ref_put(&data->refs);
-			percpu_ref_switch_to_atomic(&data->refs,
-							io_atomic_switch);
-		}
+		percpu_ref_switch_to_atomic(&data->refs, NULL);
 		wait_for_completion(&done);
 		flush_work(&data->ref_work);
 		return false;
@@ -6399,10 +6381,8 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 		up->offset++;
 	}
 
-	if (ref_switch && !test_and_set_bit(FFD_F_ATOMIC, &data->state)) {
-		percpu_ref_put(&data->refs);
-		percpu_ref_switch_to_atomic(&data->refs, io_atomic_switch);
-	}
+	if (ref_switch)
+		percpu_ref_switch_to_atomic(&data->refs, NULL);
 
 	return done ? done : err;
 }

-- 
Jens Axboe

