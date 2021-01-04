Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5D92E9BBE
	for <lists+io-uring@lfdr.de>; Mon,  4 Jan 2021 18:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbhADRLu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jan 2021 12:11:50 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:43784 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbhADRLu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jan 2021 12:11:50 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 104H4qCm140722;
        Mon, 4 Jan 2021 17:11:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 references : message-id : date : mime-version : in-reply-to : content-type
 : content-transfer-encoding; s=corp-2020-01-29;
 bh=43Wmz+OFzg1p1oUYkF89dMoksP9NuUyFa0kji3q4UOg=;
 b=yI85ZUNqlPgpMflscd0FsUjci6IzkK/PbJ4ZNX424V0T/XRrFx9pf5dEnapKx1leb/XK
 kyVK97hEJyHtPZGXOsqJiETAF6YKbkDAzcpw4J/GXKK+U+r4U79/pPPlCu4jPOB+s5Yy
 mn3v35EpxpVmPHxdRKwBKcA6FTwjp8bzN7yqNWiJ3/CxafM4p1M8JrUWtI05utl3Z2Ye
 HZEMSphqGipdLaLgQlKPl45TACPFEvO8pncyyBDq8Zu0PsOz78Oxiay5bkLupy7wG0Pf
 ibIbnCdtJpYIhiAbwoOGml+lCF+hTtZkvaMvUTEGz2QehJZpAsM2E0esbb4tGmcjcQDk Vg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35tgskn8hm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 04 Jan 2021 17:11:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 104H6Iwd058096;
        Mon, 4 Jan 2021 17:09:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 35uxnren08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Jan 2021 17:09:06 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 104H945h016288;
        Mon, 4 Jan 2021 17:09:04 GMT
Received: from [10.154.188.254] (/10.154.188.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Jan 2021 17:09:04 +0000
Subject: Re: [PATCH v3 00/13] io_uring: buffer registration enhancements
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
References: <1608314848-67329-1-git-send-email-bijan.mottahedeh@oracle.com>
Message-ID: <d1d0d364-cd9b-9ded-aa0b-992e33569156@oracle.com>
Date:   Mon, 4 Jan 2021 09:09:04 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1608314848-67329-1-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Antivirus: Avast (VPS 210101-4, 01/01/2021), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9854 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101040111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9854 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 impostorscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101040111
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A reminder to please review this version.

> v3:
> 
> - batch file->rsrc renames into a signle patch when possible
> - fix other review changes from v2
> - fix checkpatch warnings
> 
> v2:
> 
> - drop readv/writev with fixed buffers patch
> - handle ref_nodes both both files/buffers with a single ref_list
> - make file/buffer handling more unified
> 
> This patchset implements a set of enhancements to buffer registration
> consistent with existing file registration functionality:
> 
> - buffer registration updates		IORING_REGISTER_BUFFERS_UPDATE
> 					IORING_OP_BUFFERS_UPDATE
> 
> - buffer registration sharing		IORING_SETUP_SHARE_BUF
> 					IORING_SETUP_ATTACH_BUF
> 
> I have kept the original patchset unchanged for the most part to
> facilitate reviewing and so this set adds a number of additional patches
> mostly making file/buffer handling more unified.
> 
> Patch 1-2 modularize existing buffer registration code.
> 
> Patch 3-7 generalize fixed_file functionality to fixed_rsrc.
> 
> Patch 8 applies fixed_rsrc functionality for fixed buffers support.
> 
> Patch 9-10 generalize files_update functionality to rsrc_update.
> 
> Patch 11 implements buffer registration update, and introduces
> IORING_REGISTER_BUFFERS_UPDATE and IORING_OP_BUFFERS_UPDATE, consistent
> with file registration update.
> 
> Patch 12 generalizes fixed resource allocation
> 
> Patch 13 implements buffer sharing among multiple rings; it works as follows:
> 
> - A new ring, A,  is setup. Since no buffers have been registered, the
>    registered buffer state is an empty set, Z. That's different from the
>    NULL state in current implementation.
> 
> - Ring B is setup, attaching to Ring A. It's also attaching to it's
>    buffer registrations, now we have two references to the same empty
>    set, Z.
> 
> - Ring A registers buffers into set Z, which is no longer empty.
> 
> - Ring B sees this immediately, since it's already sharing that set.
> 
> Testing
> 
> I have used liburing file-{register,update} tests as models for
> buffer-{register,update,share}, tests and they run ok.
> 
> TBD
> 
> - I tried to use a single opcode for files/buffers but ran into an
> issue since work_flags is different for files/buffers.  This should
> be ok for the most part since req->work.flags is ultimately examined;
> however, there are place where io_op_defs[opcode].work_flags is examined
> directly, and I wasn't sure what would the best way to handle that.
> 
> - Need to still address Pavel's comments about deadlocks. I figure
> to send out the set anyway since this is a last patch and may even be
> handled separately.
> 
> Bijan Mottahedeh (13):
>    io_uring: modularize io_sqe_buffer_register
>    io_uring: modularize io_sqe_buffers_register
>    io_uring: rename file related variables to rsrc
>    io_uring: generalize io_queue_rsrc_removal
>    io_uring: separate ref_list from fixed_rsrc_data
>    io_uring: generalize fixed_file_ref_node functionality
>    io_uring: add rsrc_ref locking routines
>    io_uring: implement fixed buffers registration similar to fixed files
>    io_uring: create common fixed_rsrc_ref_node handling routines
>    io_uring: generalize files_update functionlity to rsrc_update
>    io_uring: support buffer registration updates
>    io_uring: create common fixed_rsrc_data allocation routines.
>    io_uring: support buffer registration sharing
> 
>   fs/io_uring.c                 | 1004 +++++++++++++++++++++++++++++------------
>   include/uapi/linux/io_uring.h |   12 +-
>   2 files changed, 735 insertions(+), 281 deletions(-)
> 

