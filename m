Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B7B26C37E
	for <lists+io-uring@lfdr.de>; Wed, 16 Sep 2020 16:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgIPOCr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Sep 2020 10:02:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22825 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726562AbgIPNli (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Sep 2020 09:41:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600263667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b13vJ/YMMQgxYKz2obXogkk12TYbgR42Hva4f1WmCM0=;
        b=C81WBRq9zREb9OaRIhv5OLNgqPX4DcE5UJqE1M7pyGkhpli+wd1NxVqj3D4W4Twlc1wHeQ
        CXTOSRsr7qPzW1wJyqHIo1Exjo7xWkzmMSBEHpBuk0C3JxE+nL/HWnFm71dWLerLyu4oWe
        g5aHNgI2bNsDy0r/tjebOjfwzezVBW4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-PjTnAyf5Nvm0IxHXmWxXfw-1; Wed, 16 Sep 2020 09:20:01 -0400
X-MC-Unique: PjTnAyf5Nvm0IxHXmWxXfw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5CEBC1021D28;
        Wed, 16 Sep 2020 13:20:00 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A83CC78813;
        Wed, 16 Sep 2020 13:19:59 +0000 (UTC)
Date:   Wed, 16 Sep 2020 09:19:57 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: occasional metadata I/O errors (-EOPNOTSUPP) on XFS + io_uring
Message-ID: <20200916131957.GB1681377@bfoster>
References: <20200915113327.GA1554921@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915113327.GA1554921@bfoster>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Sep 15, 2020 at 07:33:27AM -0400, Brian Foster wrote:
> Hi Jens,
> 
> I'm seeing an occasional metadata (read) I/O error (EOPNOTSUPP) when
> running Zorro's recent io_uring enabled fsstress on XFS (fsstress -d
> <mnt> -n 99999999 -p 8). The storage is a 50GB dm-linear device on a
> virtio disk (within a KVM guest). The full callstack of the I/O
> submission path is appended below [2], acquired via inserting a
> WARN_ON() in my local tree.
> 
> From tracing around a bit, it looks like what happens is that fsstress
> calls into io_uring, the latter starts a plug and sets plug.nowait =
> true (via io_submit_sqes() -> io_submit_state_start()) and eventually
> XFS needs to read an inode cluster buffer in the context of this task.
> That buffer read ultimately fails due to submit_bio_checks() setting
> REQ_NOWAIT on the bio and the following logic in the same function
> causing a BLK_STS_NOTSUPP status:
> 
> 	if ((bio->bi_opf & REQ_NOWAIT) && !queue_is_mq(q))
> 		goto not_supported;
> 
> In turn, this leads to the following behavior in XFS:
> 
> [ 3839.273519] XFS (dm-2): metadata I/O error in "xfs_imap_to_bp+0x116/0x2c0 [xfs]" at daddr 0x323a5a0 len 32 error 95
> [ 3839.303283] XFS (dm-2): log I/O error -95
> [ 3839.321437] XFS (dm-2): xfs_do_force_shutdown(0x2) called from line 1196 of file fs/xfs/xfs_log.c. Return address = ffffffffc12dea8a
> [ 3839.323554] XFS (dm-2): Log I/O Error Detected. Shutting down filesystem
> [ 3839.324773] XFS (dm-2): Please unmount the filesystem and rectify the problem(s)
> 
> I suppose it's possible fsstress is making an invalid request based on
> my setup, but I find it a little strange that this state appears to leak
> into filesystem I/O requests. What's more concerning is that this also
> seems to impact an immediately subsequent log write submission, which is
> a fatal error and causes the filesystem to shutdown.
> 
> Finally, note that I've seen your patch associated with Zorro's recent
> bug report [1] and that does seem to prevent the problem. I'm still
> sending this report because the connection between the plug and that
> change is not obvious to me, so I wanted to 1.) confirm this is intended
> to fix this problem and 2.) try to understand whether this plugging
> behavior introduces any constraints on the fs when invoked in io_uring
> context. Thoughts? Thanks.
> 

To expand on this a bit, I was playing more with the aforementioned fix
yesterday while waiting for this email's several hour trip to the
mailing list to complete and eventually realized that I don't think the
plug.nowait thing properly accommodates XFS' use of multiple devices. A
simple example is XFS on a data device with mq support and an external
log device without mq support. Presumably io_uring requests could thus
enter XFS with plug.nowait set to true, and then any log bio submission
that happens to occur in that context is doomed to fail and shutdown the
fs.

I'm not sure how likely a use case and/or how easy to reproduce that
would be, but I think it's technically valid and possible, so probably
something else to consider with this whole io_uring context topic..
Perhaps this state is something that should be associated with bios that
target a particular device rather than something that arbitrates all bio
submissions from a particular task context (i.e. current->plug)..?

Brian

> Brian
> 
> [1] https://bugzilla.kernel.org/show_bug.cgi?id=209243#c8
> 
> [2] fsstress callchain that exhibits I/O error:
> 
> [ 3839.327329] ------------[ cut here ]------------
> [ 3839.328309] WARNING: CPU: 1 PID: 4160 at fs/xfs/libxfs/xfs_inode_buf.c:149 xfs_imap_to_bp+0x1ec/0x2c0 [xfs]
> [ 3839.330605] Modules linked in: xfs(O) libcrc32c tun bridge stp llc ebtable_nat ebtable_broute ip6table_nat ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_raw iptable_security snd_hda_codec_generic ip_set nfnetlink ebtable_filter ebtables ip6table_filter ip6_tables sunrpc snd_hda_intel snd_intel_dspcfg snd_hda_codec snd_hwdep snd_hda_core snd_seq snd_seq_device snd_pcm snd_timer virtio_net snd net_failover virtio_balloon failover soundcore i2c_piix4 virtio_console virtio_blk qxl drm_ttm_helper ttm drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm virtio_pci virtio_ring ata_generic serio_raw virtio pata_acpi [last unloaded: xfs]
> [ 3839.344011] CPU: 1 PID: 4160 Comm: fsstress Tainted: G           O      5.9.0-rc4+ #164
> [ 3839.345550] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
> [ 3839.348430] RIP: 0010:xfs_imap_to_bp+0x1ec/0x2c0 [xfs]
> [ 3839.349547] Code: 84 24 98 00 00 00 65 48 33 04 25 28 00 00 00 0f 85 c0 00 00 00 48 81 c4 a0 00 00 00 44 89 e0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 <0f> 0b 41 83 fc f5 75 b1 41 81 e6 00 00 00 40 75 a8 b9 96 00 00 00
> [ 3839.353756] RSP: 0018:ffff8881f15d72c0 EFLAGS: 00010282
> [ 3839.354782] RAX: ffff8881f15d7300 RBX: 1ffff1103e2bae5c RCX: ffffffffad2fa134
> [ 3839.356230] RDX: ffffffffc13d26e0 RSI: 1ffff1103e2bae1e RDI: ffff8881e76161a0
> [ 3839.357601] RBP: ffff88815c2fda28 R08: 0000000000000001 R09: ffffed103cec2c35
> [ 3839.359041] R10: ffff8881e76161a3 R11: ffffed103cec2c34 R12: 00000000ffffffa1
> [ 3839.360332] R13: 0000000000000000 R14: 0000000000000000 R15: ffff8881f15d73e0
> [ 3839.361627] FS:  00007fe5b98f2040(0000) GS:ffff8881f7280000(0000) knlGS:0000000000000000
> [ 3839.363288] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 3839.364844] CR2: 00007fe5b98ef000 CR3: 00000001defd8000 CR4: 00000000000006e0
> [ 3839.366409] Call Trace:
> [ 3839.367065]  ? xfs_inode_buf_readahead_verify+0x10/0x10 [xfs]
> [ 3839.368208]  ? do_raw_spin_lock+0x126/0x290
> [ 3839.369092]  ? rwlock_bug.part.0+0x90/0x90
> [ 3839.369992]  ? xfs_trans_ijoin+0xf9/0x200 [xfs]
> [ 3839.370961]  xfs_trans_log_inode+0x3ef/0x930 [xfs]
> [ 3839.371919]  ? rcu_read_lock_sched_held+0xa0/0xd0
> [ 3839.372890]  ? xfs_trans_ichgtime+0x190/0x190 [xfs]
> [ 3839.373812]  ? do_raw_spin_unlock+0x54/0x250
> [ 3839.374911]  xfs_vn_update_time+0x301/0x590 [xfs]
> [ 3839.375898]  ? xfs_setattr_mode.isra.0+0x80/0x80 [xfs]
> [ 3839.376895]  touch_atime+0x18f/0x1e0
> [ 3839.377588]  ? atime_needs_update+0x570/0x570
> [ 3839.378377]  ? copy_page_to_iter+0x1e1/0xc60
> [ 3839.379216]  generic_file_buffered_read+0x14ed/0x2010
> [ 3839.380185]  ? do_syscall_64+0x2d/0x40
> [ 3839.380912]  ? native_usergs_sysret64+0x1/0x10
> [ 3839.381767]  ? fs_reclaim_release+0xf/0x30
> [ 3839.382557]  ? pagecache_get_page+0x6d0/0x6d0
> [ 3839.383403]  ? down_read_trylock+0x19a/0x360
> [ 3839.384285]  ? xfs_ilock_nowait+0xd5/0x4e0 [xfs]
> [ 3839.385175]  ? rwsem_spin_on_owner+0x2b0/0x2b0
> [ 3839.386026]  ? rcu_read_lock_bh_held+0xb0/0xb0
> [ 3839.386959]  ? xfs_file_buffered_aio_read+0xcf/0x340 [xfs]
> [ 3839.388134]  xfs_file_buffered_aio_read+0xe2/0x340 [xfs]
> [ 3839.389221]  xfs_file_read_iter+0x257/0x550 [xfs]
> [ 3839.390139]  io_iter_do_read+0x82/0x190
> [ 3839.390951]  io_read+0x80e/0xbd0
> [ 3839.391594]  ? is_bpf_text_address+0x80/0xe0
> [ 3839.392382]  ? kiocb_done+0x2e0/0x2e0
> [ 3839.393089]  ? profile_setup.cold+0xa1/0xa1
> [ 3839.393894]  ? arch_stack_walk+0x9c/0xf0
> [ 3839.394684]  ? io_read_prep+0x71/0x2f0
> [ 3839.395377]  ? io_prep_rw+0xd90/0xd90
> [ 3839.396084]  ? __lock_acquire+0xbd7/0x66b0
> [ 3839.397036]  io_issue_sqe+0x4e9/0x5000
> [ 3839.397768]  ? lockdep_hardirqs_on_prepare+0x4f0/0x4f0
> [ 3839.398753]  ? __fget_files+0x19f/0x2d0
> [ 3839.399555]  ? __ia32_sys_io_uring_setup+0x70/0x70
> [ 3839.400415]  ? rcu_read_lock_bh_held+0xb0/0xb0
> [ 3839.401252]  ? lock_acquire+0x191/0x7d0
> [ 3839.401998]  ? __fget_files+0x5/0x2d0
> [ 3839.402694]  ? find_held_lock+0x2c/0x110
> [ 3839.403417]  ? __fget_files+0x19f/0x2d0
> [ 3839.404243]  ? __io_queue_sqe+0x266/0xc30
> [ 3839.405004]  __io_queue_sqe+0x266/0xc30
> [ 3839.405765]  ? io_wq_submit_work+0x270/0x270
> [ 3839.406606]  ? rcu_read_lock_sched_held+0xa1/0xd0
> [ 3839.407559]  ? rcu_read_lock_bh_held+0xb0/0xb0
> [ 3839.408368]  ? io_file_get+0x415/0x870
> [ 3839.409118]  io_submit_sqes+0x1130/0x1d60
> [ 3839.409926]  ? __mutex_lock+0x44f/0x11c0
> [ 3839.410683]  ? io_queue_sqe+0xf70/0xf70
> [ 3839.411387]  ? __x64_sys_io_uring_enter+0x50c/0x7e0
> [ 3839.412327]  ? mutex_trylock+0x2b0/0x2b0
> [ 3839.413086]  ? __x64_sys_io_uring_enter+0x202/0x7e0
> [ 3839.414008]  ? find_held_lock+0x2c/0x110
> [ 3839.414763]  ? __x64_sys_io_uring_enter+0x28e/0x7e0
> [ 3839.415773]  ? syscall_enter_from_user_mode+0x22/0x80
> [ 3839.416737]  __x64_sys_io_uring_enter+0x51d/0x7e0
> [ 3839.417655]  do_syscall_64+0x2d/0x40
> [ 3839.418315]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [ 3839.419262] RIP: 0033:0x7fe5b99ef37d
> [ 3839.419966] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d eb 6a 0c 00 f7 d8 64 89 01 48
> [ 3839.423393] RSP: 002b:00007ffcc0d57838 EFLAGS: 00000216 ORIG_RAX: 00000000000001aa
> [ 3839.424975] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fe5b99ef37d
> [ 3839.426374] RDX: 0000000000000001 RSI: 0000000000000001 RDI: 0000000000000003
> [ 3839.427672] RBP: 0000000000000004 R08: 0000000000000000 R09: 0000000000000008
> [ 3839.428975] R10: 0000000000000001 R11: 0000000000000216 R12: 000000000000f8b8
> [ 3839.430379] R13: 00007fe5b9aff000 R14: 000000000001b991 R15: 0000000000a4f440
> [ 3839.431782] irq event stamp: 54797391
> [ 3839.432456] hardirqs last  enabled at (54797399): [<ffffffffad3130db>] console_unlock+0x6eb/0x9b0
> [ 3839.434248] hardirqs last disabled at (54797408): [<ffffffffad312fad>] console_unlock+0x5bd/0x9b0
> [ 3839.435915] softirqs last  enabled at (54797422): [<ffffffffaf2005b9>] __do_softirq+0x5b9/0x8a0
> [ 3839.437463] softirqs last disabled at (54797417): [<ffffffffaf000faf>] asm_call_on_stack+0xf/0x20
> [ 3839.439061] ---[ end trace cbd4c49b2879030e ]---
> 

