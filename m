Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24F22A0C3A
	for <lists+io-uring@lfdr.de>; Fri, 30 Oct 2020 18:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725844AbgJ3RLU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Oct 2020 13:11:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34382 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726662AbgJ3RLT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Oct 2020 13:11:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09UH5QZ4061642;
        Fri, 30 Oct 2020 17:11:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 references : message-id : date : mime-version : in-reply-to : content-type
 : content-transfer-encoding; s=corp-2020-01-29;
 bh=iIwQ7sa9Z2jgM/vtgR69ktmUqWi/Kf3j+qImL7PG1Nc=;
 b=FU9H3Lib/CSi1HIYXvQoJ1DahVuLuNKrjNqb0ATzEUdB56DXWHBDXXIUGxP21GwSMx+w
 KU86kbZInbK2I25s4qjdsUIoWW5EBZd7IReCfslcjtu83GBoldNK8Fu8yQctlXvUEWzU
 AWyjDT7PWxLJbogfF1cLsTrlE7v5MPA76xL/NCAJjYUd+dbg0NJ0jH8MPqpKJowK8yva
 mCRkzQwHzBgWXPSFi21U95al6IkZn/SDd7/P1lsQBUqsv5IE5o85x8xk5kdWK8/Qc5+N
 0ABFlVTgeLWngBO/5klZFj4+s6FM5UvIH/+12tbYYh5qfnXghzsHHuvl+IWgAliX1gqF 4A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34cc7masup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 30 Oct 2020 17:11:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09UH5UGl066006;
        Fri, 30 Oct 2020 17:11:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 34cx70x7vd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Oct 2020 17:11:16 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09UHBGHJ002970;
        Fri, 30 Oct 2020 17:11:16 GMT
Received: from [10.154.136.100] (/10.154.136.100)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 30 Oct 2020 10:11:15 -0700
Subject: Re: [RFC 0/8] io_uring: buffer registration enhancements
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org
References: <1603408443-51303-1-git-send-email-bijan.mottahedeh@oracle.com>
Message-ID: <cc844d10-bde1-67c8-2838-6ce3a232faab@oracle.com>
Date:   Fri, 30 Oct 2020 10:11:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1603408443-51303-1-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Antivirus: Avast (VPS 201006-2, 10/06/2020), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9790 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=929 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010300127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9790 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=945 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010300127
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A gentle ping.

On 10/22/2020 4:13 PM, Bijan Mottahedeh wrote:
> Hi Jens,
> 
> This RFC implements a set of enhancements to buffer registration consistent
> with existing file registration functionality:
> 
> - buffer registration updates		IORING_REGISTER_BUFFERS_UPDATE
> 					IORING_OP_BUFFERS_UPDATE
> 
> - readv/writev with fixed buffers	IOSQE_FIXED_BUFFER
> 
> - buffer registration sharing		IORING_SETUP_SHARE_BUF
> 					IORING_SETUP_ATTACH_BUF
> 
> Patches 1,2 modularize existing buffer registration code.
> 
> Patch 3 generalizes fixed_file functionality to fixed_rsrc.
> 
> Patch 4 applies fixed_rsrc functionality for fixed buffers support.
> 
> Patch 5 generalizes files_update functionality to rsrc_update.
> 
> Patch 6 implements buffer registration update, and introduces
> IORING_REGISTER_BUFFERS_UPDATE and IORING_OP_BUFFERS_UPDATE, consistent
> with file registration update.
> 
> Patch 7 implements readv/writev support with fixed buffers, and introduces
> IOSQE_FIXED_BUFFER, consistent with fixed files.
> 
> Patch 8 implements buffer sharing among multiple rings; it works as
> follows based on previous conversations:
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
> TBD
> 
> - I think I have to add IORING_UNREGISTER_BUFFERS to
>    io_register_op_must_quiesce() but wanted to confirm.
> 
> - IORING_OP_SHUTDOWN has been removed but still in liburing, not sure why.
>    I wanted to verify before removing that functionality.
> 
> I have used liburing file-{register,update} tests as models for
> buffer-{register,update}, and it seems to work ok.
> 
> Bijan Mottahedeh (8):
>    io_uring: modularize io_sqe_buffer_register
>    io_uring: modularize io_sqe_buffers_register
>    io_uring: generalize fixed file functionality
>    io_uring: implement fixed buffers registration similar to fixed files
>    io_uring: generalize files_update functionlity to rsrc_update
>    io_uring: support buffer registration updates
>    io_uring: support readv/writev with fixed buffers
>    io_uring: support buffer registration sharing
> 
>   fs/io_uring.c                 | 1021 ++++++++++++++++++++++++++++++++---------
>   include/uapi/linux/io_uring.h |   15 +-
>   2 files changed, 807 insertions(+), 229 deletions(-)
> 

