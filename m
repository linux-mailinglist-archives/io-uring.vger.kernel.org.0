Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8D5204228
	for <lists+io-uring@lfdr.de>; Mon, 22 Jun 2020 22:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbgFVUuo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Jun 2020 16:50:44 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56992 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728553AbgFVUuo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Jun 2020 16:50:44 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05MKgwX1021053;
        Mon, 22 Jun 2020 20:50:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=CdyJ4TvmmhjG1nI0eM8PTc1NPBM1LeG9znxvxzyFQgw=;
 b=Ghc9JzTT8DLCLlM2mX8DXWwLZuXhjCuHeNbvyVAgyIhPRbI0pM7nj5e8OY+6waidUMFT
 VRGKPbu6lcckq1CkaNy31J8qFYxOAUYFUeA5etI+PLtrcV/zyZVz0TcDgoQS20IyaigN
 A8IL51h28pDMrPvs+DzgO26yceYaO4u7k4n0eAh6NPmc+TBM5iNdHLuBpcQelyrQTwUq
 +52cknSkS++OBbpKhybD73vEaABGC3yWxe8W5gvLj1h2sv/PlHpinSKuOOpkRaDRx4km
 DMmT7BxLWZaHo1qRqv7cwZVmgUXCPoA7h90kzA5OC4csEE8ke4yOngK87YTjgT48A/Dl FQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 31sebbhkqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 22 Jun 2020 20:50:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05MKh448099022;
        Mon, 22 Jun 2020 20:48:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 31svcvqjf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Jun 2020 20:48:39 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05MKmcD7008842;
        Mon, 22 Jun 2020 20:48:38 GMT
Received: from [10.154.98.104] (/10.154.98.104)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 22 Jun 2020 20:48:38 +0000
Subject: Re: [RFC 1/1] io_uring: use valid mm in io_req_work_grab_env() in
 SQPOLL mode
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <1592611064-35370-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1592611064-35370-2-git-send-email-bijan.mottahedeh@oracle.com>
 <a812d57b-7d95-8844-4c50-9155aca0884d@gmail.com>
 <e6178e2d-8fa7-4837-a2c1-b167179177dc@kernel.dk>
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Message-ID: <e64db48d-6870-3b09-9ad4-85eaf4d3624e@oracle.com>
Date:   Mon, 22 Jun 2020 13:48:36 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <e6178e2d-8fa7-4837-a2c1-b167179177dc@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Antivirus: Avast (VPS 200622-6, 06/22/2020), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 malwarescore=0 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006220135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 cotscore=-2147483648 mlxscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 suspectscore=0 clxscore=1015
 impostorscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006220135
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/20/2020 7:22 AM, Jens Axboe wrote:
> On 6/20/20 3:59 AM, Pavel Begunkov wrote:
>> On 20/06/2020 02:57, Bijan Mottahedeh wrote:
>>> If current->mm is not set in SQPOLL mode, then use ctx->sqo_mm;
>>> otherwise fail thre request.
>>
>> io_sq_thread_acquire_mm() called from io_async_buf_retry() should've
>> guaranteed presence of current->mm. Though, the problem could be in
>> "io_op_defs[req->opcode].needs_mm" check there, which is done only
>> for the first request in a link.
> 
> Right, Bijan are you sure this isn't fixed by one of the fixes that
> went upstream yesterday:
> 
> commit 9d8426a09195e2dcf2aa249de2aaadd792d491c7
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Tue Jun 16 18:42:49 2020 -0600
> 
>      io_uring: acquire 'mm' for task_work for SQPOLL
> 

I was running next-20200618.

Both 0618 and 0620 contain

io_uring: acquire 'mm' for task_work for SQPOLL


The commit

io_uring: support true async buffered reads, if file provides it

however is different in 0618 and 0620, the 0618 version is missing the call

if (!io_sq_thread_acquire_mm(ctx, req)) {

in io_async_buf_retry().

https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/fs/io_uring.c?h=next-20200618&id=a3bb0c190b85781d7857b7a55cb9cefded5f527b
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/fs/io_uring.c?h=next-20200622&id=3ad1d68c04bf9555942b63b5aba31e446fdcf355

I pulled the 0622 and the read-write test runs fine.

--bijan
