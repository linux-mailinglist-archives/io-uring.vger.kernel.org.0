Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD0C6304D1E
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 00:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731600AbhAZXCp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jan 2021 18:02:45 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53360 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730253AbhAZFcE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jan 2021 00:32:04 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10Q5VD8A099735;
        Tue, 26 Jan 2021 05:31:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 references : message-id : date : mime-version : in-reply-to : content-type
 : content-transfer-encoding; s=corp-2020-01-29;
 bh=U6S0BEfLyRX9mbZv9vZ7WTP9bSA8SofsjlQKO1MQKqQ=;
 b=lXjfxJOIsWHyYfjxQwwZw0y/oTSsbiO8fgYSPLhnoaFzujwmQLru7pUQwPLpddHAZeSK
 Jx5+JvRZoSVcPrF/DWhcxzKaxWIGbx1rqp8R7WjPjy5tHO6FKKY74V3QxY3uzIm3Os9H
 4RQt1lViWVpl2N4hT+ZgbVdTm0+qvFMQY2Zk6Mp4t4JqCiJ7IMqheD0HM1bvanKBtISD
 a0FLa2/Q10FO84xrrlpDZDn0Ev1HZzuFsU0QctpllV/OcS8chApm5lp6EALz/5kj7P6x
 kja8C1e6QR+oxUhh49eOi861NHTAsdVzUaMxhi4/AaUFol9PaDhD/LzHAbDKZwhm7R/I vg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 368brkgdrw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Jan 2021 05:31:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10Q5UV90010238;
        Tue, 26 Jan 2021 05:31:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 368wpxh6xt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Jan 2021 05:31:12 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10Q5VBTD032234;
        Tue, 26 Jan 2021 05:31:11 GMT
Received: from [10.154.187.70] (/10.154.187.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 25 Jan 2021 21:31:11 -0800
Subject: Re: [PATCH v6 0/5] io_uring: buffer registration enhancements
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
References: <1611274976-44074-1-git-send-email-bijan.mottahedeh@oracle.com>
Message-ID: <88cb72b0-5b3c-cea3-a72a-23ddf00ef3f1@oracle.com>
Date:   Mon, 25 Jan 2021 21:31:10 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <1611274976-44074-1-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Antivirus: Avast (VPS 210113-0, 01/12/2021), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9875 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101260028
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9875 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101260028
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Gentle reminder to please review this next version.

> v6:
> 
> - address v5 comments
> - rebase on Pavel's rsrc generalization changes
> - see also TBD section below
> 
> v5:
> 
> - call io_get_fixed_rsrc_ref for buffers
> - make percpu_ref_release names consistent
> - rebase on for-5.12/io_uring
> - see also TBD section below
> 
> v4:
> 
> - address v3 comments (TBD REGISTER_BUFFERS)
> - rebase
> 
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
> Patch 1 calls io_get_fixed_rsrc_ref() for buffers as well as files.
> 
> Patch 2 applies fixed_rsrc functionality for fixed buffers support.
> 
> Patch 3 generalize files_update functionality to rsrc_update.
> 
> Patch 4 implements buffer registration update, and introduces
> IORING_REGISTER_BUFFERS_UPDATE and IORING_OP_BUFFERS_UPDATE, consistent
> with file registration update.
> 
> Patch 5 implements buffer sharing among multiple rings; it works as follows:
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
> buffer-{register,update,share}, tests and they run ok. Liburing test/self
> fails but seems unrelated to these changes.
> 
> TBD
> 
> - Need a patch from Pavel to address a race between fixed IO from async
> context and buffer unregister, or force buffer registration ops to do
> full quiesce.
> 
> Bijan Mottahedeh (5):
>    io_uring: call io_get_fixed_rsrc_ref for buffers
>    io_uring: implement fixed buffers registration similar to fixed files
>    io_uring: generalize files_update functionlity to rsrc_update
>    io_uring: support buffer registration updates
>    io_uring: support buffer registration sharing
> 
>   fs/io_uring.c                 | 448 +++++++++++++++++++++++++++++++++++++-----
>   include/uapi/linux/io_uring.h |   4 +
>   2 files changed, 403 insertions(+), 49 deletions(-)
> 

