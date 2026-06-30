Return-Path: <io-uring+bounces-13858-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id K4vqBReKQ2r1agoAu9opvQ
	(envelope-from <io-uring+bounces-13858-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2026 11:19:19 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 670496E20D7
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2026 11:19:18 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eDlxINV3;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13858-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.232.135.74 as permitted sender) smtp.mailfrom="io-uring+bounces-13858-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 866AC30078A7
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2026 09:16:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45DE035837C;
	Tue, 30 Jun 2026 09:16:23 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7AA3537F9
	for <io-uring@vger.kernel.org>; Tue, 30 Jun 2026 09:16:21 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782810983; cv=none; b=kcZnE7Vr/KWLbqL1yeFgRAbpXmP6nanMAgyVSBagqXkpqF2UfGot16SGa4k0WIVKd4sYfGgAvAj408KzgdhPenjKdoA6GND16yQ0MI7vLJYBVlm74ATnsBjGnxL0ZllJLBMaGmPDR0m4kIjX7HbiVKWnxKaRxR+2zSo3rDdYytw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782810983; c=relaxed/simple;
	bh=tSHQKrtS4uUBYixtj7S8kcv8jKe/kKYRqP84dNewn1I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pQjoH8DYi3rSE92TLmplzjaQulbTX4UxL8XuU1rLC1ZjYJxxvQPRUz5UeW2eFUhMOOzcmmOnnFWzoxrvBMFGAQyUGcD2/2Ii/dv79DrkzWHyPIqJC2znly7dVV26l2F0r94xS/h8fGKkLrF7sgpkuPqZltSN6C3psZ+aHNCt/Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eDlxINV3; arc=none smtp.client-ip=209.85.216.54
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-37e11438c66so1701958a91.3
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2026 02:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782810980; x=1783415780; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+W4jFuc1moBoarAVLGwQU2yc+l+yWlolJZtJTsMWc/k=;
        b=eDlxINV3/ZbQc409NwO/hD2UhAB5scYf8uU2SEH8MmfhjMjU56CeZaQy7KUY3NWNGn
         Rcc4/UEPg/Ur4xUhvlJ+5MxuxulrZGIQ3jsCtXRyOHGJI/1DLbsAKpPnEk85fmEf74Pv
         OnIoHkNUSFu4KAg3RWCI5zm9WD4QNbIVQl0VBV8PfvU2se4hG/UcQP6vq90A83nbBGBT
         gO2/bMm1UduFXdMyJv0z6GxTUtJTiiNm8gb2dmetpdMsr5raESqY9rTnjuaneuO0y3XQ
         gDMte4RZZT7+ISTJLhzMqwqYVYOsOlbEs6QqusTPiDCM3bpqt+Hix4LNQzPRAdjWTyam
         qkzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782810980; x=1783415780;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+W4jFuc1moBoarAVLGwQU2yc+l+yWlolJZtJTsMWc/k=;
        b=U7oTOKJMFb26DfIoLTwNjmIqZOGCT88Z8xizB4lFJYCh/B8gtvyn1JxCbFhty58bIt
         mA5Elbnsf9U/lkghJoYfTJchQRJgLUZ2qBn4PteBuBisLSzk+IrNr+djbG8D6V4YdLiq
         FnBLTeDVi1afuPouGdk+ig/1UP3ra6JSTuSVNKE1l2AKD98wiX2AbHJquMpn1RrIvH6N
         rT0/hNHIOfJljL7Eom2WeEKDFf6AZ9JKeLvR05BUh1pCHNKcZnELnQWeyU/as+OU1bOz
         Pbb2dFzYjuTmWOFZOC1ApZ7Z9Iev2D+tqpJxacQKhRwt81ua1YEsHOvCUGb43+3yNuxb
         nGFA==
X-Forwarded-Encrypted: i=1; AHgh+RqjqbhHXipIocGt5xVZA93yf4BFChICBYkdc0oxZq1BJGNHN9rRl8V8WJWe3qcR5i6z/UHpEaPg5w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzMrpwTSlDJ59/CuY+NrjpnNNNJfHJf6eey4is280HdYCFgl5/N
	2PsO129LPmU8NVYISfky94rg5PytVGc0QZpGn2IH8bMZ3yXTOG9mQF5V
X-Gm-Gg: AfdE7ckX/uqysgWEFI2Ax3Q5Rk9adnJmB4NDNb43JN8Huz056FSfiAVPBSiOp8WC6eW
	qzxDApZnsZ5aNbOn3MqjLQ37UKZAUjBoIjTmvkP9V2p9YiWo31+9EAj/n4YoeixmG7n/DyCN4ZQ
	AFq93SURpyY+ujo5EHBFDLCTujuDIqwahZ3C0TftI5wOyKSkBcBiqLQPfBFzFwo2/NfH1TykgsM
	rPmUORac6htw5FOq+Gv2cznI/1O98gTqfCYTXg0S6Z/MbMOSgCZciPTRA6pAXxSIgIg/henFdYH
	WKnUIayo1AykNl1WquaBiaYdpHTIH6y1BKvuAhGURx8weVsdgT2tWh/2ObicUDNMxgkszsBrEwO
	86cm9/5mlj2ZzB+afgmyGYd5RXSpca8NBNeAt4AsxfPptx4vENFMUz5E7IT0TDMzyjZ3dZgnoUk
	RaNw9UHyp5ulVnzXVtkrs=
X-Received: by 2002:a17:90b:3f86:b0:36a:5d1f:7b6 with SMTP id 98e67ed59e1d1-3805259219amr1833349a91.2.1782810980181;
        Tue, 30 Jun 2026 02:16:20 -0700 (PDT)
Received: from gmail.com (vps-8b58878c.vps.ovh.us. [2604:2dc0:202:300::a96])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38052f47a3dsm1336855a91.13.2026.06.30.02.16.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 30 Jun 2026 02:16:19 -0700 (PDT)
From: Yue Sun <samsun1006219@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [BUG REPORT] btrfs/io_uring: GPF in tctx_task_work_run after encoded read error completion
Date: Tue, 30 Jun 2026 17:16:04 +0800
Message-ID: <20260630091609.3414-1-samsun1006219@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13858-lists,io-uring=lfdr.de];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER(0.00)[samsun1006219@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS(0.00)[m:clm@fb.com,m:dsterba@suse.com,m:axboe@kernel.dk,m:linux-btrfs@vger.kernel.org,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[samsun1006219@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,vger.kernel.org:from_smtp,run.sh:url]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 670496E20D7

Hello,

I can reproduce a general protection fault on current upstream master by using
IORING_OP_URING_CMD with BTRFS_IOC_ENCODED_READ on a loop-backed btrfs image
while fail_make_request injects read errors.

Summary
-------

The crash happens while io_uring is running task_work for a btrfs encoded read
completion:

  tctx_task_work_run()
    mutex_lock(&ctx->uring_lock)

The faulting mutex address is poisoned:

  RDI: dead000000001129
  KASAN: maybe wild-memory-access in range [0xdead000000001128-0xdead00000000112f]

The root cause might be a double-completion/use-after-free race in the
btrfs io_uring encoded read error path.

The timing appears to be:

  # CPU0: userspace task issues IORING_OP_URING_CMD.
  io_uring_enter()
    btrfs_uring_cmd()
      btrfs_uring_encoded_read()
        ret = btrfs_encoded_read(...)
        if (ret == -EIOCBQUEUED)
          btrfs_uring_read_extent(..., cmd)

  btrfs_uring_read_extent()
    priv->cmd = cmd
    ret = btrfs_encoded_read_regular_fill_pages(..., priv)

  # In this helper, priv is struct btrfs_encoded_read_private.
  # uring_ctx points to the caller's struct btrfs_uring_priv.
  btrfs_encoded_read_regular_fill_pages(..., uring_ctx=priv)
    refcount_set(&priv->pending_refs, 1)
    priv->uring_ctx = uring_ctx
    refcount_inc(&priv->pending_refs)
    btrfs_submit_bbio(bbio, 0)

  # CPU1: the submitted bio fails quickly, before CPU0 drops its owner ref.
  btrfs_encoded_read_endio()
    WRITE_ONCE(priv->status, bbio->bio.bi_status)
    refcount_dec_and_test(&priv->pending_refs)
    # pending_refs goes 2 -> 1, so this context does not queue completion.

  # CPU0: btrfs_submit_bbio() has returned and the uring branch continues.
  btrfs_encoded_read_regular_fill_pages(..., uring_ctx=priv)
    if (refcount_dec_and_test(&priv->pending_refs)) {
      ret = blk_status_to_errno(READ_ONCE(priv->status))
      btrfs_uring_read_extent_endio(uring_ctx, ret)
      kfree(priv)
      return ret
    }

  # Here priv is the caller's struct btrfs_uring_priv.
  btrfs_uring_read_extent_endio(priv, err)
    bc->priv = priv
    io_uring_cmd_complete_in_task(priv->cmd, btrfs_uring_read_finished)

  # CPU0: task_work is queued, but the helper returns a normal error instead
  # of -EIOCBQUEUED, so the caller takes the synchronous failure path.
  btrfs_uring_read_extent()
    if (ret && ret != -EIOCBQUEUED)
      goto out_fail
  out_fail:
    btrfs_unlock_extent(...)
    btrfs_inode_unlock(...)
    kfree(priv)
    __free_page(...)
    kfree(pages)
    return ret

  # Later, the same task waits for io_uring completions and runs task_work.
  io_uring_enter()
    io_cqring_wait()
      io_run_task_work()
        task_work_run()
          tctx_task_work()
            tctx_task_work_run()
              req = container_of(node, struct io_kiocb, io_task_work.node)
              ctx = req->ctx
              mutex_lock(&ctx->uring_lock)
              # Crash: req->ctx appears poisoned/stale before
              # btrfs_uring_read_finished() is reached.

With injected read failures, the immediate-completion branch can queue
task_work for the io_uring command through btrfs_uring_read_extent_endio()
and then return an error to btrfs_uring_read_extent(). btrfs_uring_read_extent()
treats that error as a normal failure, frees the same btrfs_uring_priv, and
returns an error back to io_uring. io_uring then can complete/free the request
normally, while the previously queued task_work still references the
command/request. When the task_work is later popped, tctx_task_work_run() sees
a poisoned req->ctx and crashes before reaching the btrfs completion callback.

Tested kernel:
- HEAD: dc59e4fea9d83f03bad6bddf3fa2e52491777482
- uname in guest: 7.2.0-rc1-dirty #15 PREEMPT(full)

Crash log
---------

[   63.751791] loop0: detected capacity change from 0 to 524288
[   63.859164] BTRFS: device fsid 889ab22c-9771-46cd-b999-32fef980e076 devid 1 transid 6 /dev/loop0 (7:0) scanned by mount (9336)
[   63.877189] BTRFS info (device loop0): first mount of filesystem 889ab22c-9771-46cd-b999-32fef980e076
[   63.878857] BTRFS info (device loop0): using crc32c checksum algorithm
[   63.928552] BTRFS info (device loop0): deleted orphan free space tree entries
[   63.932111] BTRFS info (device loop0): checking UUID tree
[   63.933786] BTRFS info (device loop0): turning on async discard
[   63.934576] BTRFS info (device loop0): enabling free space tree
[   63.935328] BTRFS info (device loop0): force zstd compression, level 3
[   67.923597] sh (9358): drop_caches: 3
[   68.041155] sh (9360): drop_caches: 3
[   68.051939] BTRFS error (device loop0): bdev /dev/loop0 errs: wr 0, rd 1, flush 0, corrupt 0, gen 0
[   68.054001] BTRFS error (device loop0): bdev /dev/loop0 errs: wr 0, rd 2, flush 0, corrupt 0, gen 0
[   68.056024] Oops: general protection fault, probably for non-canonical address 0xfbd59c0000000225: 0000 [#1] SMP KASAN PTI
[   68.057878] KASAN: maybe wild-memory-access in range [0xdead000000001128-0xdead00000000112f]
[   68.059321] CPU: 0 UID: 0 PID: 9354 Comm: poc Not tainted 7.2.0-rc1-dirty #15 PREEMPT(full) 
[   68.060781] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
[   68.062200] RIP: 0010:__mutex_lock+0x129/0x1d80
[   68.063085] Code: 08 84 d2 0f 85 b2 15 00 00 44 8b 1d d1 e1 97 0f 45 85 db 75 29 48 b8 00 00 00 00 00 fc ff df 49 8d 7f 58 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 98 15 00 00 4d 3b 7f 58 0f 85 a1 0b 00 00 bf 01
[   68.066073] RSP: 0018:ffffc9000da277a0 EFLAGS: 00010a02
[   68.067031] RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000001
[   68.068254] RDX: 1bd5a00000000225 RSI: 0000000000000000 RDI: dead000000001129
[   68.069407] RBP: ffffc9000da27910 R08: ffffffff84b38018 R09: fffff52001b44f34
[   68.070559] R10: ffffc9000da27930 R11: 0000000000000000 R12: 0000000000000000
[   68.071716] R13: dffffc0000000000 R14: dead000000001091 R15: dead0000000010d1
[   68.072872] FS:  000000003084d3c0(0000) GS:ffff8880d673e000(0000) knlGS:0000000000000000
[   68.074173] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   68.075138] CR2: 00007fb18a6164b0 CR3: 0000000035932000 CR4: 00000000000006f0
[   68.076300] Call Trace:
[   68.076790]  <TASK>
[   68.077230]  ? tctx_task_work_run+0x1d8/0xb80
[   68.078018]  ? __kasan_check_byte+0x14/0x50
[   68.078766]  ? __pfx___mutex_lock+0x10/0x10
[   68.079521]  ? __kasan_check_byte+0x14/0x50
[   68.080217]  ? __kasan_check_byte+0x14/0x50
[   68.080876]  ? is_bpf_text_address+0x8c/0x1a0
[   68.081566]  ? rcu_is_watching+0x12/0xc0
[   68.082192]  ? tctx_task_work_run+0x1d8/0xb80
[   68.082877]  tctx_task_work_run+0x1d8/0xb80
[   68.083552]  ? __lock_acquire+0x476/0x2420
[   68.084210]  ? __pfx_tctx_task_work_run+0x10/0x10
[   68.084948]  tctx_task_work+0x7a/0xa0
[   68.085553]  ? __pfx_tctx_task_work+0x10/0x10
[   68.086241]  ? _raw_spin_unlock_irq+0x23/0x50
[   68.086919]  ? lockdep_hardirqs_on+0x7c/0x110
[   68.087610]  task_work_run+0x16b/0x260
[   68.088218]  ? __pfx_task_work_run+0x10/0x10
[   68.088892]  ? add_lock_to_list+0x97/0x130
[   68.089544]  io_run_task_work+0x1be/0x6e0
[   68.090195]  ? __pfx_io_run_task_work+0x10/0x10
[   68.090909]  ? kasan_save_track+0x14/0x30
[   68.091557]  io_cqring_wait+0x16a/0x2a60
[   68.092130]  ? find_held_lock+0x2b/0x80
[   68.092696]  ? fput+0x9a/0xd0
[   68.093152]  ? __pfx_io_cqring_wait+0x10/0x10
[   68.093771]  ? __do_sys_io_uring_enter+0xab0/0x1ba0
[   68.094445]  ? __mutex_unlock_slowpath+0x35d/0x900
[   68.095105]  ? io_submit_sqes+0x123d/0x2630
[   68.095709]  ? __pfx___mutex_unlock_slowpath+0x10/0x10
[   68.096417]  __do_sys_io_uring_enter+0x124b/0x1ba0
[   68.097079]  ? fput+0x9a/0xd0
[   68.097537]  ? __pfx___do_sys_io_uring_enter+0x10/0x10
[   68.098241]  ? __pfx_ksys_mmap_pgoff+0x10/0x10
[   68.098865]  do_syscall_64+0x11f/0x860
[   68.099416]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   68.100108] RIP: 0033:0x4534bd
[   68.100570] Code: c3 e8 b7 23 00 00 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
[   68.102792] RSP: 002b:00007ffca186d1d8 EFLAGS: 00000216 ORIG_RAX: 00000000000001aa
[   68.103764] RAX: ffffffffffffffda RBX: 00007ffca186d968 RCX: 00000000004534bd
[   68.104647] RDX: 0000000000000001 RSI: 0000000000000001 RDI: 0000000000000004
[   68.105513] RBP: 00007ffca186d3c0 R08: 0000000000000000 R09: 0000000000000000
[   68.106378] R10: 0000000000000001 R11: 0000000000000216 R12: 0000000000000001
[   68.107245] R13: 00007ffca186d958 R14: 00000000004c57d0 R15: 0000000000000001
[   68.108119]  </TASK>
[   68.108461] Modules linked in:
[   68.108955] ---[ end trace 0000000000000000 ]---
[   68.110342] RIP: 0010:__mutex_lock+0x129/0x1d80
[   68.111098] Code: 08 84 d2 0f 85 b2 15 00 00 44 8b 1d d1 e1 97 0f 45 85 db 75 29 48 b8 00 00 00 00 00 fc ff df 49 8d 7f 58 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 98 15 00 00 4d 3b 7f 58 0f 85 a1 0b 00 00 bf 01
[   68.113250] RSP: 0018:ffffc9000da277a0 EFLAGS: 00010a02
[   68.113926] RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000001
[   68.114806] RDX: 1bd5a00000000225 RSI: 0000000000000000 RDI: dead000000001129
[   68.115685] RBP: ffffc9000da27910 R08: ffffffff84b38018 R09: fffff52001b44f34
[   68.116471] R10: ffffc9000da27930 R11: 0000000000000000 R12: 0000000000000000
[   68.117167] R13: dffffc0000000000 R14: dead000000001091 R15: dead0000000010d1
[   68.117850] FS:  000000003084d3c0(0000) GS:ffff8880d673e000(0000) knlGS:0000000000000000
[   68.118604] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   68.119165] CR2: 00007fb18a832000 CR3: 0000000035932000 CR4: 00000000000006f0
[   68.195193] BTRFS error (device loop0): bdev /dev/loop0 errs: wr 1, rd 2, flush 0, corrupt 0, gen 0
[   68.197475] BTRFS error (device loop0): bdev /dev/loop0 errs: wr 2, rd 2, flush 0, corrupt 0, gen 0
[   68.197507] BTRFS error (device loop0): bdev /dev/loop0 errs: wr 3, rd 2, flush 0, corrupt 0, gen 0
[   68.199781] BTRFS error (device loop0): bdev /dev/loop0 errs: wr 4, rd 2, flush 0, corrupt 0, gen 0
[   68.200406] BTRFS error (device loop0): bdev /dev/loop0 errs: wr 5, rd 2, flush 0, corrupt 0, gen 0
[   68.200652] BTRFS error (device loop0): bdev /dev/loop0 errs: wr 6, rd 2, flush 0, corrupt 0, gen 0
[   68.200695] BTRFS error (device loop0): bdev /dev/loop0 errs: wr 7, rd 2, flush 0, corrupt 0, gen 0
[   68.202124] BTRFS error (device loop0): bdev /dev/loop0 errs: wr 8, rd 2, flush 0, corrupt 0, gen 0
[   68.210002] BTRFS error (device loop0): error while writing out transaction: -5
[   68.212219] BTRFS warning (device loop0): Skipping commit of aborted transaction.
[   68.212925] BTRFS error (device loop0 state A): Transaction 8 aborted (error -5)
[   68.213625] BTRFS: error (device loop0 state A) in cleanup_transaction:2068: errno=-5 IO failure
[   68.214439] BTRFS info (device loop0 state EA): forced readonly
[   68.215142] BTRFS info (device loop0 state EA): last unmount of filesystem 889ab22c-9771-46cd-b999-32fef980e076

PoC: run.sh
-----------

#!/bin/sh
set -eu

MNT=/tmp/klr_btrfs_mnt_$$
IMG="$(pwd)/fs.img"
DEV=

cleanup() {
	umount -l "$MNT" >/dev/null 2>&1 || true
	if [ -n "$DEV" ]; then
		(/sbin/losetup -d "$DEV" || /usr/sbin/losetup -d "$DEV" || losetup -d "$DEV") >/dev/null 2>&1 || true
	fi
}
trap cleanup EXIT

umount -l /tmp/klr_btrfs_mnt /tmp/klr_btrfs_mnt_* >/dev/null 2>&1 || true
(/sbin/losetup -D || /usr/sbin/losetup -D || losetup -D) >/dev/null 2>&1 || true
mkdir -p "$MNT"

mounted=0
for try in 1 2 3 4 5; do
	DEV=$({ /sbin/losetup -f --show "$IMG" || /usr/sbin/losetup -f --show "$IMG" || losetup -f --show "$IMG"; } 2>/dev/null || true)
	if [ -n "$DEV" ] && mount -t btrfs -o compress-force=zstd "$DEV" "$MNT"; then
		mounted=1
		break
	fi
	if [ -n "$DEV" ]; then
		(/sbin/losetup -d "$DEV" || /usr/sbin/losetup -d "$DEV" || losetup -d "$DEV") >/dev/null 2>&1 || true
		DEV=
	fi
	sleep 1
done

if [ "$mounted" -ne 1 ]; then
	echo "KLR_ENVIRONMENT_MISSING: cannot mount bundled btrfs image" >&2
	./poc
	exit 0
fi

KLR_BTRFS_MNT="$MNT" KLR_BTRFS_IMG="$IMG" KLR_LOOP_DEV="$DEV" ./poc

PoC: poc.c
----------

#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <linux/btrfs.h>
#include <linux/io_uring.h>
#include <linux/magic.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/statfs.h>
#include <sys/syscall.h>
#include <sys/uio.h>
#include <sys/wait.h>
#include <sys/xattr.h>
#include <unistd.h>

#ifndef BTRFS_SUPER_MAGIC
#define BTRFS_SUPER_MAGIC 0x9123683E
#endif

#ifndef IORING_OP_URING_CMD
#define IORING_OP_URING_CMD 46
#endif

#ifndef IORING_FEAT_SINGLE_MMAP
#define IORING_FEAT_SINGLE_MMAP (1U << 0)
#endif

#ifndef BTRFS_IOCTL_MAGIC
#define BTRFS_IOCTL_MAGIC 0x94
#endif

#ifndef BTRFS_IOC_ENCODED_READ
struct btrfs_ioctl_encoded_io_args {
	const struct iovec *iov;
	unsigned long iovcnt;
	__s64 offset;
	__u64 flags;
	__u64 len;
	__u64 unencoded_len;
	__u64 unencoded_offset;
	__u32 compression;
	__u32 encryption;
	__u8 reserved[64];
};
#define BTRFS_IOC_ENCODED_READ _IOR(BTRFS_IOCTL_MAGIC, 64, struct btrfs_ioctl_encoded_io_args)
#endif

struct ring {
	int fd;
	struct io_uring_params p;
	void *sq_ring;
	void *cq_ring;
	struct io_uring_sqe *sqes;
	size_t sq_ring_sz;
	size_t cq_ring_sz;
};

static int run_cmd(const char *cmd)
{
	int ret = system(cmd);

	if (ret == -1)
		return -1;
	if (WIFEXITED(ret))
		return WEXITSTATUS(ret);
	return 128;
}

static int is_btrfs_path(const char *path)
{
	struct statfs sfs;

	if (statfs(path, &sfs) != 0)
		return 0;
	return (unsigned long)sfs.f_type == (unsigned long)BTRFS_SUPER_MAGIC;
}

static int write_text_file(const char *path, const char *text)
{
	int fd = open(path, O_WRONLY | O_CLOEXEC);
	size_t len = strlen(text);
	ssize_t ret;

	if (fd < 0)
		return -1;
	ret = write(fd, text, len);
	close(fd);
	return ret == (ssize_t)len ? 0 : -1;
}

static int enable_loop_fail_make_request(const char *dev)
{
	const char *base;
	char path[256];
	int ok = 0;

	if (!dev || !dev[0])
		return -1;
	base = strrchr(dev, '/');
	base = base ? base + 1 : dev;

	snprintf(path, sizeof(path), "/sys/block/%s/make-it-fail", base);
	if (write_text_file(path, "1\n") == 0)
		ok = 1;

	write_text_file("/sys/kernel/debug/fail_make_request/interval", "1\n");
	write_text_file("/sys/kernel/debug/fail_make_request/probability", "100\n");
	write_text_file("/sys/kernel/debug/fail_make_request/times", "1000\n");
	write_text_file("/sys/kernel/debug/fail_make_request/verbose", "0\n");

	return ok ? 0 : -1;
}

static int setup_loop_btrfs(char *out, size_t out_sz)
{
	const char *mnt = "/tmp/klr_btrfs_mnt";
	int ret;

	run_cmd("(/bin/umount -l /tmp/klr_btrfs_mnt || /usr/bin/umount -l /tmp/klr_btrfs_mnt || umount -l /tmp/klr_btrfs_mnt) >/dev/null 2>&1");
	run_cmd("(/sbin/losetup -D || /usr/sbin/losetup -D || losetup -D) >/dev/null 2>&1");
	run_cmd("mkdir -p /tmp/klr_btrfs_mnt");
	run_cmd("rm -f /tmp/klr_btrfs.img");
	if (run_cmd("truncate -s 256M /tmp/klr_btrfs.img") != 0)
		return -1;
	ret = run_cmd("(/usr/sbin/mkfs.btrfs -f /tmp/klr_btrfs.img || /sbin/mkfs.btrfs -f /tmp/klr_btrfs.img || mkfs.btrfs -f /tmp/klr_btrfs.img) >/tmp/klr_mkfs.log 2>&1");
	fprintf(stderr, "setup mkfs.btrfs status=%d\n", ret);
	if (ret != 0) {
		run_cmd("cat /tmp/klr_mkfs.log >&2");
		return -1;
	}
	ret = run_cmd("(/usr/bin/mount -t btrfs -o loop,compress-force=zstd /tmp/klr_btrfs.img /tmp/klr_btrfs_mnt || /bin/mount -t btrfs -o loop,compress-force=zstd /tmp/klr_btrfs.img /tmp/klr_btrfs_mnt || mount -t btrfs -o loop,compress-force=zstd /tmp/klr_btrfs.img /tmp/klr_btrfs_mnt) >/tmp/klr_mount.log 2>&1");
	fprintf(stderr, "setup mount status=%d\n", ret);
	for (int i = 0; i < 20; i++) {
		if (is_btrfs_path(mnt)) {
			snprintf(out, out_sz, "%s/klr_extent.bin", mnt);
			fprintf(stderr, "setup using btrfs path %s\n", out);
			return 0;
		}
		usleep(50000);
	}

	run_cmd("cat /tmp/klr_mount.log >&2");
	return -1;
}

static int fill_test_file(const char *path, size_t bytes)
{
	int fd;
	void *buf;
	uint32_t x = 0x12345678;
	size_t done = 0;

	fd = open(path, O_CREAT | O_TRUNC | O_RDWR | O_CLOEXEC, 0600);
	if (fd < 0)
		return -1;

	(void)setxattr(path, "btrfs.compression", "zstd", 4, 0);

	if (posix_memalign(&buf, 4096, 1024 * 1024) != 0) {
		close(fd);
		return -1;
	}

	while (done < bytes) {
		size_t chunk = 1024 * 1024;
		unsigned char *p = buf;
		ssize_t wr;

		if (bytes - done < chunk)
			chunk = bytes - done;
		for (size_t i = 0; i < chunk; i++) {
			x ^= x << 13;
			x ^= x >> 17;
			x ^= x << 5;
			p[i] = (unsigned char)(x + done + i);
		}

		wr = write(fd, buf, chunk);
		if (wr <= 0) {
			free(buf);
			close(fd);
			return -1;
		}
		done += (size_t)wr;
	}

	fsync(fd);
	posix_fadvise(fd, 0, 0, POSIX_FADV_DONTNEED);
	free(buf);
	lseek(fd, 0, SEEK_SET);
	return fd;
}

static int ring_init(struct ring *r)
{
	memset(r, 0, sizeof(*r));
	r->fd = syscall(__NR_io_uring_setup, 8, &r->p);
	if (r->fd < 0)
		return -1;

	r->sq_ring_sz = r->p.sq_off.array + r->p.sq_entries * sizeof(unsigned);
	r->cq_ring_sz = r->p.cq_off.cqes + r->p.cq_entries * sizeof(struct io_uring_cqe);
	if (r->p.features & IORING_FEAT_SINGLE_MMAP) {
		if (r->cq_ring_sz > r->sq_ring_sz)
			r->sq_ring_sz = r->cq_ring_sz;
		r->cq_ring_sz = r->sq_ring_sz;
	}

	r->sq_ring = mmap(NULL, r->sq_ring_sz, PROT_READ | PROT_WRITE,
			  MAP_SHARED | MAP_POPULATE, r->fd, IORING_OFF_SQ_RING);
	if (r->sq_ring == MAP_FAILED)
		goto fail;

	if (r->p.features & IORING_FEAT_SINGLE_MMAP) {
		r->cq_ring = r->sq_ring;
	} else {
		r->cq_ring = mmap(NULL, r->cq_ring_sz, PROT_READ | PROT_WRITE,
				  MAP_SHARED | MAP_POPULATE, r->fd, IORING_OFF_CQ_RING);
		if (r->cq_ring == MAP_FAILED)
			goto fail;
	}

	r->sqes = mmap(NULL, r->p.sq_entries * sizeof(struct io_uring_sqe),
		       PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE,
		       r->fd, IORING_OFF_SQES);
	if (r->sqes == MAP_FAILED)
		goto fail;

	return 0;
fail:
	if (r->sqes && r->sqes != MAP_FAILED)
		munmap(r->sqes, r->p.sq_entries * sizeof(struct io_uring_sqe));
	if (r->cq_ring && r->cq_ring != MAP_FAILED && r->cq_ring != r->sq_ring)
		munmap(r->cq_ring, r->cq_ring_sz);
	if (r->sq_ring && r->sq_ring != MAP_FAILED)
		munmap(r->sq_ring, r->sq_ring_sz);
	close(r->fd);
	return -1;
}

static void ring_fini(struct ring *r)
{
	if (r->sqes && r->sqes != MAP_FAILED)
		munmap(r->sqes, r->p.sq_entries * sizeof(struct io_uring_sqe));
	if (r->cq_ring && r->cq_ring != MAP_FAILED && r->cq_ring != r->sq_ring)
		munmap(r->cq_ring, r->cq_ring_sz);
	if (r->sq_ring && r->sq_ring != MAP_FAILED)
		munmap(r->sq_ring, r->sq_ring_sz);
	if (r->fd >= 0)
		close(r->fd);
}

static int uring_encoded_read_once(int file_fd, uint64_t offset, size_t len)
{
	struct ring r;
	void *buf;
	struct iovec iov;
	struct btrfs_ioctl_encoded_io_args args;
	volatile unsigned *sq_tail;
	volatile unsigned *sq_head;
	volatile unsigned *sq_mask;
	volatile unsigned *cq_head;
	volatile unsigned *cq_tail;
	volatile unsigned *cq_mask;
	unsigned *sq_array;
	struct io_uring_sqe *sqe;
	struct io_uring_cqe *cqes;
	unsigned tail;
	unsigned idx;
	int ret;

	buf = mmap(NULL, len, PROT_READ | PROT_WRITE,
		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
	if (buf == MAP_FAILED)
		return -errno;

	if (ring_init(&r) != 0) {
		ret = -errno;
		munmap(buf, len);
		return ret;
	}

	memset(&args, 0, sizeof(args));
	iov.iov_base = buf;
	iov.iov_len = len;
	args.iov = &iov;
	args.iovcnt = 1;
	args.offset = offset;
	args.flags = 0;

	sq_head = (volatile unsigned *)((char *)r.sq_ring + r.p.sq_off.head);
	sq_tail = (volatile unsigned *)((char *)r.sq_ring + r.p.sq_off.tail);
	sq_mask = (volatile unsigned *)((char *)r.sq_ring + r.p.sq_off.ring_mask);
	sq_array = (unsigned *)((char *)r.sq_ring + r.p.sq_off.array);
	cq_head = (volatile unsigned *)((char *)r.cq_ring + r.p.cq_off.head);
	cq_tail = (volatile unsigned *)((char *)r.cq_ring + r.p.cq_off.tail);
	cq_mask = (volatile unsigned *)((char *)r.cq_ring + r.p.cq_off.ring_mask);
	cqes = (struct io_uring_cqe *)((char *)r.cq_ring + r.p.cq_off.cqes);

	tail = *sq_tail;
	if (tail - *sq_head >= r.p.sq_entries) {
		ring_fini(&r);
		munmap(buf, len);
		return -EAGAIN;
	}

	idx = tail & *sq_mask;
	sqe = &r.sqes[idx];
	memset(sqe, 0, sizeof(*sqe));
	sqe->opcode = IORING_OP_URING_CMD;
	sqe->fd = file_fd;
	sqe->off = BTRFS_IOC_ENCODED_READ;
	sqe->addr = (uint64_t)(uintptr_t)&args;
	sqe->user_data = 0x454e435245414431ULL;
	sq_array[idx] = idx;
	__sync_synchronize();
	*sq_tail = tail + 1;

	ret = syscall(__NR_io_uring_enter, r.fd, 1, 1, IORING_ENTER_GETEVENTS, NULL, 0);
	if (ret < 0) {
		ret = -errno;
	} else {
		for (;;) {
			unsigned head = *cq_head;

			if (head != *cq_tail) {
				struct io_uring_cqe *cqe = &cqes[head & *cq_mask];
				ret = cqe->res;
				*cq_head = head + 1;
				break;
			}
			ret = syscall(__NR_io_uring_enter, r.fd, 0, 1,
				      IORING_ENTER_GETEVENTS, NULL, 0);
			if (ret < 0) {
				ret = -errno;
				break;
			}
		}
	}

	ring_fini(&r);
	munmap(buf, len);
	return ret;
}

int main(void)
{
	char path[256] = "./klr_extent.bin";
	int made_loop = 0;
	int fd;
	const char *pre_mounted = getenv("KLR_BTRFS_MNT");
	const char *image_path = getenv("KLR_BTRFS_IMG");
	const char *loop_dev = getenv("KLR_LOOP_DEV");
	size_t file_size = 64UL * 1024 * 1024;
	int results[8];
	uint64_t offsets[] = {
		0,
		4UL * 1024 * 1024,
		16UL * 1024 * 1024,
		32UL * 1024 * 1024,
		48UL * 1024 * 1024,
		60UL * 1024 * 1024,
	};

	if (!image_path || !image_path[0])
		image_path = "/tmp/klr_btrfs.img";

	if (pre_mounted && is_btrfs_path(pre_mounted)) {
		snprintf(path, sizeof(path), "%s/klr_extent.bin", pre_mounted);
		made_loop = 1;
		fprintf(stderr, "setup using pre-mounted btrfs path %s\n", path);
	} else if (!is_btrfs_path(".") && setup_loop_btrfs(path, sizeof(path)) == 0) {
		made_loop = 1;
	} else if (!is_btrfs_path(".")) {
		fprintf(stderr, "no btrfs cwd and loop-backed btrfs setup failed; submitting closest trigger\n");
	}

	if (made_loop)
		fd = fill_test_file(path, file_size);
	else
		fd = fill_test_file(path, 8UL * 1024 * 1024);
	if (fd < 0) {
		perror("create test file");
		return 1;
	}

	if (made_loop) {
		char cmd[512];
		int injected;

		run_cmd("sync");
		run_cmd("sh -c 'echo 3 > /proc/sys/vm/drop_caches' >/dev/null 2>&1");
		injected = enable_loop_fail_make_request(loop_dev);
		fprintf(stderr, "fail_make_request enabled=%s loop=%s\n",
			injected == 0 ? "yes" : "no", loop_dev ? loop_dev : "(none)");
		if (injected != 0) {
			snprintf(cmd, sizeof(cmd), "truncate -s 40M '%s'", image_path);
			run_cmd(cmd);
		}
		run_cmd("sh -c 'echo 3 > /proc/sys/vm/drop_caches' >/dev/null 2>&1");
	}

	for (size_t i = 0; i < sizeof(offsets) / sizeof(offsets[0]); i++) {
		results[i] = uring_encoded_read_once(fd, offsets[i], 1024 * 1024);
		fprintf(stderr, "encoded_read offset=%llu res=%d\n",
			(unsigned long long)offsets[i], results[i]);
		usleep(20000);
	}

	close(fd);
	if (made_loop) {
		run_cmd("umount /tmp/klr_btrfs_mnt >/dev/null 2>&1");
		if (!pre_mounted)
			run_cmd("rm -f /tmp/klr_btrfs.img");
	}

	return 0;
}

