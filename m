Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C77222D9FFF
	for <lists+io-uring@lfdr.de>; Mon, 14 Dec 2020 20:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440779AbgLNTKX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Dec 2020 14:10:23 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:60948 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440745AbgLNTKL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Dec 2020 14:10:11 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEJ4DPC139195;
        Mon, 14 Dec 2020 19:09:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 references : message-id : date : mime-version : in-reply-to : content-type
 : content-transfer-encoding; s=corp-2020-01-29;
 bh=+xhuVCZ6nZCJS5B75dJS87WsLaSPUGqd60kxHumxH1Q=;
 b=mY09Ms/kPXyytpRf0tnNO2DkQ4XGYjLb7b8/vAJyXSW/OmRls+RhwoCnpfiyi/QP6hqw
 hNGh/6M6RCnA+MOc875u5NG9T6FTJod8Kb2FZ1xPBGNSf3146AYetRDmR+B4KD4KJuB0
 wYgrz5Zbzg2DYQMGxdsTnwD1j/0omBKmp9Nx1vpuBA6n0Qtgm+nEsHWp42SDAqvRqXfR
 knb66a57PXP08sG+R2zhMucjfqrPYKHrtkcz3p6b5tHrPjCXlOuNq8bhOEl8k3krolX9
 Vmc3LvgHOu5eq1jAjoyiuH7Y7ZCVXRAzePa5nrorAZMwokahebeb7n9vVk0j4era2XHY XQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 35cn9r6yw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 14 Dec 2020 19:09:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEJ65nu043115;
        Mon, 14 Dec 2020 19:09:24 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 35d7suyr0k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 19:09:24 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BEJ9M2r026403;
        Mon, 14 Dec 2020 19:09:22 GMT
Received: from [10.154.105.161] (/10.154.105.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Dec 2020 11:09:22 -0800
Subject: Re: [PATCH v2 00/13] io_uring: buffer registration enhancements
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
References: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
Message-ID: <e8afcd4c-37b8-f02e-c648-4cd14f12636a@oracle.com>
Date:   Mon, 14 Dec 2020 11:09:20 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Antivirus: Avast (VPS 201006-2, 10/06/2020), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140125
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140125
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Just a ping.  Anything I can do to facilitate the review, please let me 
know.


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
> - Haven't addressed Pavel's comment yet on using a single opcode for
> files/buffers update, pending Jen's opinion.  Could we encode the resource
> type into the sqe (e.g. rw_flags)?
> 
> Bijan Mottahedeh (13):
>    io_uring: modularize io_sqe_buffer_register
>    io_uring: modularize io_sqe_buffers_register
>    io_uring: generalize fixed file functionality
>    io_uring: rename fixed_file variables to fixed_rsrc
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
>   2 files changed, 732 insertions(+), 284 deletions(-)
> 

