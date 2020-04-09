Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8794F1A3C33
	for <lists+io-uring@lfdr.de>; Fri, 10 Apr 2020 00:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgDIWDr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Apr 2020 18:03:47 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47680 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbgDIWDr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Apr 2020 18:03:47 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 039M3QBW081748;
        Thu, 9 Apr 2020 22:03:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=zpjssNcfucWmOFTF7EZQpB0ckFX3r6Gf7PK1935vju4=;
 b=nKJeknZgx6x1sqXl8tDLfJRnJQpgQDCyzOgvTqFuE9IBEt4DCYUm2OM6dcIiNSHyF1n4
 wTSnhPYpVGz1JByjW0jU9/GE76eVuaSO9v4Adg2MKDDGsOaE4b6sKIsSyioYXs31OZO9
 uq6etGmhGSee4jJrJaKVxDC7NFxYPAQshpb6cprmn91zlWNdL6W+jeYqTmSsuvPl0EBy
 PO6x/NfgBjrD095GuTL0hnYSICP/VASg1DJBPLSDuM1XhqQrnkFabn2rBRSqlKzeh/gY
 dTCPJE8R7jApa3tgpBTtGGDoj6uaz0bzYaaUBVLXVO5BzCHKh1ePY5qIp1RpOnYMs9Z6 FA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 309gw4fwyg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Apr 2020 22:03:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 039M1ehx035096;
        Thu, 9 Apr 2020 22:03:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3091m9rabp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Apr 2020 22:03:45 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 039M3iLh025873;
        Thu, 9 Apr 2020 22:03:44 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Apr 2020 15:03:44 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [RFC 0/1] io_uring: preserve work->mm since actual work processing may need it
Date:   Thu,  9 Apr 2020 15:03:36 -0700
Message-Id: <1586469817-59280-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9586 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 adultscore=0 suspectscore=3 mlxlogscore=860
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004090155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9586 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 suspectscore=3 malwarescore=0 spamscore=0 mlxlogscore=921 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004090155
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The liburing madvise test crashes the system with a NULL pointer
dereference because io_madvise() is passing a NULL mm value, previously
cleared in io_wq_switch_mm(), to do_advise().

I'm not clear why work->mm is being cleared, especially since it seems
to run contrary to what the comment above it states, but in any case
preserving the work->mm value gets rid of the crash.

--------------------------------------------------------------------------

Running test madvise
[  165.733724] BUG: kernel NULL pointer dereference, address: 0000000000000138
[  165.735088] #PF: supervisor read access in kernel mode
[  165.736027] #PF: error_code(0x0000) - not-present page
[  165.736971] PGD 8000000fa3c32067 P4D 8000000fa3c32067 PUD fc4e17067 PMD 0
[  165.738254] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC PTI
[  165.739140] CPU: 18 PID: 30105 Comm: io_wqe_worker-0 Not tainted 5.6.0-next-1
[  165.740640] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-4
[  165.742721] RIP: 0010:__lock_acquire.isra.29+0x37/0x6c0
[  165.743656] Code: 25 40 8e 01 00 53 48 83 ec 18 44 8b 35 e6 2f 61 01 45 85 fc
[  165.747020] RSP: 0018:ffffc9000b08bba0 EFLAGS: 00010097
[  165.747989] RAX: 0000000000000000 RBX: 0000000000000130 RCX: 0000000000000001
[  165.749276] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000130
[  165.750552] RBP: ffff888fa35224c0 R08: 0000000000000000 R09: 0000000000000000
[  165.751862] R10: 0000000000000130 R11: 0000000000000000 R12: 0000000000000000
[  165.753195] R13: 0000000000000001 R14: 0000000000000000 R15: 00007f5c4ecea000
[  165.754490] FS:  0000000000000000(0000) GS:ffff888ff4600000(0000) knlGS:00000
[  165.756007] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  165.757054] CR2: 0000000000000138 CR3: 0000000fc709c002 CR4: 0000000000160ee0
[  165.758339] Call Trace:
[  165.758805]  ? load_balance+0x1b4/0xd00
[  165.759525]  lock_acquire+0xf9/0x160
[  165.760202]  ? do_madvise+0xa59/0xb20
[  165.760894]  down_read+0x3c/0xe0
[  165.761479]  ? do_madvise+0xa59/0xb20
[  165.762188]  do_madvise+0xa59/0xb20
[  165.762830]  ? kvm_sched_clock_read+0xd/0x20
[  165.763643]  ? free_debug_processing+0x291/0x2c8
[  165.764535]  ? do_raw_spin_unlock+0x83/0x90
[  165.765303]  ? free_debug_processing+0x291/0x2c8
[  165.766184]  io_issue_sqe+0xafa/0x11e0
[  165.766867]  ? kvm_sched_clock_read+0xd/0x20
[  165.767641]  ? __free_pages_ok+0x3db/0x550
[  165.768390]  ? _raw_spin_unlock+0x1f/0x30
[  165.769129]  io_wq_submit_work+0x2f/0x80
[  165.769800]  io_worker_handle_work+0x38a/0x540
[  165.770650]  io_wqe_worker+0x32a/0x370
[  165.771342]  kthread+0x118/0x120
[  165.771948]  ? io_worker_handle_work+0x540/0x540
[  165.772784]  ? kthread_insert_work_sanity_check+0x60/0x60
[  165.773766]  ret_from_fork+0x1f/0x30
[  165.774419] Modules linked in: xfs dm_mod sr_mod sd_mod cdrom crc32c_intel nt
[  165.777124] CR2: 0000000000000138
[  165.777733] ---[ end trace 2a1a5b9c912bd387 ]---

Bijan Mottahedeh (1):
  io_uring: preserve work->mm since actual work processing may need it

 fs/io-wq.c | 2 --
 1 file changed, 2 deletions(-)

-- 
1.8.3.1

