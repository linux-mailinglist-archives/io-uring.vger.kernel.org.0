Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2403F201EDC
	for <lists+io-uring@lfdr.de>; Sat, 20 Jun 2020 01:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728687AbgFSX7x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Jun 2020 19:59:53 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48468 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728949AbgFSX7w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Jun 2020 19:59:52 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05JNwvAT069673;
        Fri, 19 Jun 2020 23:59:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=Eg27P06PkD30oeKFKX6seuOb1NXibWwLdDzIwNbI7sU=;
 b=qXN9TY4/F4HqiojUHXIUySliF5En07VGGR0bLysvDoxdhvEs/yYoHDdt5MmRdJpE0g7I
 Q1Jo++y1MTW/Xofztu3kEBCljIFMTQGKgw82rGzJ7SogU1XqR6QP/aKsy7JgjpkwII8Q
 4PrjFPdhZ4LCqBFH7OrrQLeOv9lgmu55wVoC34/Fk106tqb62HYMXJbRn+s3flkkUAs4
 ycDre7ZMbPjnwWtxXBfXgEPQ8nVUhD1SG6EVLNOKuQqLOPh2t3a1uMovU5tlL9eSjaGt
 3yVjXIW4NvcvHwjzricE/tz1yFjKWzWfpNivRLVpx2+SnFg3znf++SIzZqVBjy8J3Lpo DA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 31q66095dd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 19 Jun 2020 23:59:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05JNrV1t001547;
        Fri, 19 Jun 2020 23:57:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 31q66wty8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Jun 2020 23:57:49 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05JNvmt0017041;
        Fri, 19 Jun 2020 23:57:48 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 19 Jun 2020 16:57:48 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [RFC 0/1] io_uring: use valid mm in io_req_work_grab_env() in SQPOLL mode
Date:   Fri, 19 Jun 2020 16:57:43 -0700
Message-Id: <1592611064-35370-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9657 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=967
 bulkscore=0 adultscore=0 phishscore=0 suspectscore=1 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006190168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9657 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 spamscore=0 clxscore=1015 mlxlogscore=971 suspectscore=1 impostorscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006190169
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The liburing read-write test crashes with the strack trace below.

The problem is NULL current->mm dereference in io_req_work_grab_env().

Sending this as RFC since I'm not sure about any personality implications
of unconditionally using sqo_mm, and the proper way of failing the
request if no valid mm is found.

[  227.308192] BUG: kernel NULL pointer dereference, address: 0000000000000060
[  227.310320] #PF: supervisor write access in kernel mode
[  227.311789] #PF: error_code(0x0002) - not-present page
[  227.313170] PGD 8000000f951e7067 P4D 8000000f951e7067 PUD f9768d067 PMD 0
[  227.314918] Oops: 0002 [#1] SMP DEBUG_PAGEALLOC PTI
[  227.316094] CPU: 4 PID: 6209 Comm: io_uring-sq Not tainted 5.8.0-rc1-next-203
[  227.318050] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-4
[  227.319964] RIP: 0010:__io_queue_sqe+0x503/0x790
[  227.320706] Code: 68 00 00 00 01 49 83 be c8 00 00 00 00 75 2d 42 f6 04 bd 60
[  227.323688] RSP: 0018:ffffc90001297db8 EFLAGS: 00010202
[  227.324520] RAX: ffff888f9aa90040 RBX: ffff888f98dc8af8 RCX: 0000000000000000
[  227.325644] RDX: 0000000000000000 RSI: 0000000000001000 RDI: ffff888f98dc8b28
[  227.326767] RBP: ffffc90001297e38 R08: ffffc90001297c18 R09: 0000000000000001
[  227.327929] R10: 00000000ffffffeb R11: ffff888facb3b800 R12: 0000000000000000
[  227.329042] R13: ffff888facb3b800 R14: ffff888f98dc8a40 R15: 0000000000000001
[  227.330155] FS:  0000000000000000(0000) GS:ffff888ff0e00000(0000) knlGS:00000
[  227.331419] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  227.332338] CR2: 0000000000000060 CR3: 0000000f97bbc002 CR4: 0000000000160ee0
[  227.333449] Call Trace:
[  227.333864]  ? kvm_sched_clock_read+0xd/0x20
[  227.334537]  ? task_work_run+0x61/0x80
[  227.335151]  io_async_buf_retry+0x3b/0x50
[  227.335760]  task_work_run+0x6a/0x80
[  227.336356]  io_sq_thread+0x14e/0x320


Bijan Mottahedeh (1):
  io_uring: use valid mm in io_req_work_grab_env() in SQPOLL mode

 fs/io_uring.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

-- 
1.8.3.1

