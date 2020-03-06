Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5887917C059
	for <lists+io-uring@lfdr.de>; Fri,  6 Mar 2020 15:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgCFOgh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Mar 2020 09:36:37 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:52778 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbgCFOgh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Mar 2020 09:36:37 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 026EZt8N119834;
        Fri, 6 Mar 2020 14:36:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=xa65RcA52aSBC9k32u2gnoNOdze/X6lwyq6dnX69pNM=;
 b=P88AOonRfnU1JRYDh7zY2PZrjrAjh5Uu0+nLglIKN+BXnnEZi9EmfdHUvgQ9YFFWwoo2
 MLiLc2/apoBnta6LzJICVwlbvuMxM7ypm/mdTZv6Zlew3UH3kz46sVnOUe9DVKy5TPF+
 qdWkWD3RJIJ22PrjDWZ/74Zgedg7nASUzF1Ixz9kH8ktMJKDLrPZidks9upo5FTI8p7J
 byPH9GDFtxLD51TDdVAGUCGAsJ2BFkVLxkCzhZVtGpohaa8DhwKAejFz8Zli4s1YofEu
 lN28zbQqxe1nhguOwtTEixSpS9p27qqybb0HAhsJZybyow4A1R2XPvDVDTaaRHqC6JOf EQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2ykgys27dy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Mar 2020 14:36:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 026EWxgG188705;
        Fri, 6 Mar 2020 14:36:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2yg1s0t5r6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Mar 2020 14:36:00 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 026EZwWS006594;
        Fri, 6 Mar 2020 14:35:58 GMT
Received: from kadam (/41.210.146.162)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 06 Mar 2020 06:35:57 -0800
Date:   Fri, 6 Mar 2020 17:35:52 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+e017e49c39ab484ac87a@syzkaller.appspotmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, io-uring@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>, tony.luck@intel.com,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: KASAN: use-after-free Read in percpu_ref_switch_to_atomic_rcu
Message-ID: <20200306143552.GC19839@kadam>
References: <00000000000067c6df059df7f9f5@google.com>
 <CACT4Y+ZVLs7O84qixsvFqk_Nur1WOaCU81RiCwDf3wOqvHB-ag@mail.gmail.com>
 <3f805e51-1db7-3e57-c9a3-15a20699ea54@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f805e51-1db7-3e57-c9a3-15a20699ea54@kernel.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9551 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=750
 suspectscore=2 malwarescore=0 adultscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003060103
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9551 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 lowpriorityscore=0
 mlxscore=0 mlxlogscore=796 bulkscore=0 impostorscore=0 phishscore=0
 adultscore=0 priorityscore=1501 spamscore=0 clxscore=1011 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003060103
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


There a bunch of similar bugs.  It's seems a common anti-pattern.

block/blk-cgroup.c:85 blkg_free() warn: freeing 'blkg' which has percpu_ref_exit()
block/blk-core.c:558 blk_alloc_queue_node() warn: freeing 'q' which has percpu_ref_exit()
drivers/md/md.c:5528 md_free() warn: freeing 'mddev' which has percpu_ref_exit()
drivers/target/target_core_transport.c:583 transport_free_session() warn: freeing 'se_sess' which has percpu_ref_exit()
fs/aio.c:592 free_ioctx() warn: freeing 'ctx' which has percpu_ref_exit()
fs/aio.c:806 ioctx_alloc() warn: freeing 'ctx' which has percpu_ref_exit()
fs/io_uring.c:6115 io_sqe_files_unregister() warn: freeing 'data' which has percpu_ref_exit()
fs/io_uring.c:6431 io_sqe_files_register() warn: freeing 'ctx->file_data' which has percpu_ref_exit()
fs/io_uring.c:7134 io_ring_ctx_free() warn: freeing 'ctx' which has percpu_ref_exit()
kernel/cgroup/cgroup.c:4948 css_free_rwork_fn() warn: freeing 'css' which has percpu_ref_exit()
mm/backing-dev.c:615 cgwb_create() warn: freeing 'wb' which has percpu_ref_exit()

regards,
dan carpenter

