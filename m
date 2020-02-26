Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD2B1706C2
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2020 18:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgBZR4u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Feb 2020 12:56:50 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45563 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbgBZR4u (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Feb 2020 12:56:50 -0500
Received: by mail-pg1-f193.google.com with SMTP id r77so19411pgr.12
        for <io-uring@vger.kernel.org>; Wed, 26 Feb 2020 09:56:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=P79GjLdnQsJvdAA9vfm/KbP2Qlv5eoazQW7UAtUTerU=;
        b=fEMtoj+9iVC/2tgjx49Fnr+yiDc1Y1b1qqia0KGuG5ntZUEG4RS/Hh/AAAXyp8qYGs
         r+VmbrKbvnpuIU8a1QPZAwPniD1C9SHAGVMeZ5CLRE1LNe/Rma2nABzRdyg2cAQ5CDXV
         RQJEjy+F2rBmeFhtV7vKt8g6QncLjlAloVI1B1Swc1ha33H7vxxnnsVlVkQsxKqFYglx
         5YZUSYdxG3XH454IDJTCCefxdds5s7tHsIJxbOJCjpavIODHKcigq7i/rs8LAG0/hPdZ
         QzzII7PXPzyAklvQpeJjiuC2dRi/I0WY09x82nifQkvKK6z6g9SsG1hOseXZ2rXxoGJL
         IWFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=P79GjLdnQsJvdAA9vfm/KbP2Qlv5eoazQW7UAtUTerU=;
        b=YuPrOoyHwRiBuWuxnx2jvnv2qeYWhaR02uG8fLuU/Obh5LKOOSQ2vo5LrWwLizBe9O
         2DUhM/2qG5AECGMT1At9/qQBWCKQGrkCUfhfIqmCJ+b4UIYPleF/bC7lQHIoq0x19ROl
         NunoJW0U/wNm8xH82ThN40PSw1u8iUUGBxek4tc6drBT+3eXx1pSMfaTOxoKP+DHOHCO
         GbxJ3/I0SnYjdLdX0nRcBAUDla5dYqEd+Wz2M46LdThxzR+DRrTRlXpajmee/hdefRhc
         0ynDn8PM/OusDDyOCDQgwZ1SsU+TIts9od/AeoYJBOBJaGhPpONNhGtgskEDM1yyQdmC
         kNxg==
X-Gm-Message-State: APjAAAVaSsQJlayoYKr7ora+p3q2/GAXgLAATpDyVmXKsxduu73tCBM/
        nb5AKvYdILMMahqK01Z8wTVOD0sZ1JW0vw==
X-Google-Smtp-Source: APXvYqzOSjWVujFbIZ6NoYr598TBz1BuBO6th2kGF+aCu7IoOExzIPIPZscy744M5VVHFqQ1iqIVMQ==
X-Received: by 2002:a62:3304:: with SMTP id z4mr5203599pfz.79.1582739807566;
        Wed, 26 Feb 2020 09:56:47 -0800 (PST)
Received: from ?IPv6:2620:10d:c085:21d6::137a? ([2620:10d:c090:400::5:890])
        by smtp.gmail.com with ESMTPSA id 70sm3817103pfw.140.2020.02.26.09.56.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2020 09:56:47 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Dan Melnic <dmm@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] io_uring: drop file set ref put/get on switch
Message-ID: <8bd031cc-83e2-7ef2-11b4-91382db61ec1@kernel.dk>
Date:   Wed, 26 Feb 2020 10:56:45 -0700
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
percpu switch, we can just do them when we've switched to atomic mode.
This removes the need for FFD_F_ATOMIC, which wasn't reliable.

Fixes: 05f3fb3c5397 ("io_uring: avoid ring quiesce for fixed file set unregister and update")
Reported-by: Dan Melnic <dmm@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Changes:

- We do need to ensure we hit ref zero, that schedules the actual
  removal. But do so in io_atomic_switch(), so it's nicely balanced,
  instead of relying on not being in atomic mode when we need to
  schedule another switch.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 36917c0101fd..e412a1761d93 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -183,17 +183,12 @@ struct fixed_file_table {
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
@@ -5595,7 +5590,6 @@ static void io_ring_file_ref_switch(struct work_struct *work)
 
 	data = container_of(work, struct fixed_file_data, ref_work);
 	io_ring_file_ref_flush(data);
-	percpu_ref_get(&data->refs);
 	percpu_ref_switch_to_percpu(&data->refs);
 }
 
@@ -5771,8 +5765,13 @@ static void io_atomic_switch(struct percpu_ref *ref)
 {
 	struct fixed_file_data *data;
 
+	/*
+	 * Juggle reference to ensure we hit zero, if needed, so we can
+	 * switch back to percpu mode
+	 */
 	data = container_of(ref, struct fixed_file_data, refs);
-	clear_bit(FFD_F_ATOMIC, &data->state);
+	percpu_ref_put(&data->refs);
+	percpu_ref_get(&data->refs);
 }
 
 static bool io_queue_file_removal(struct fixed_file_data *data,
@@ -5795,11 +5794,7 @@ static bool io_queue_file_removal(struct fixed_file_data *data,
 	llist_add(&pfile->llist, &data->put_llist);
 
 	if (pfile == &pfile_stack) {
-		if (!test_and_set_bit(FFD_F_ATOMIC, &data->state)) {
-			percpu_ref_put(&data->refs);
-			percpu_ref_switch_to_atomic(&data->refs,
-							io_atomic_switch);
-		}
+		percpu_ref_switch_to_atomic(&data->refs, io_atomic_switch);
 		wait_for_completion(&done);
 		flush_work(&data->ref_work);
 		return false;
@@ -5873,10 +5868,8 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 		up->offset++;
 	}
 
-	if (ref_switch && !test_and_set_bit(FFD_F_ATOMIC, &data->state)) {
-		percpu_ref_put(&data->refs);
+	if (ref_switch)
 		percpu_ref_switch_to_atomic(&data->refs, io_atomic_switch);
-	}
 
 	return done ? done : err;
 }
-- 
Jens Axboe

