Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2602EC429
	for <lists+io-uring@lfdr.de>; Wed,  6 Jan 2021 20:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbhAFTt2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Jan 2021 14:49:28 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:47714 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726570AbhAFTt1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Jan 2021 14:49:27 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106JjPDp002802;
        Wed, 6 Jan 2021 19:48:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=4+ZirJQr89JIznI6xACDmHSZ2OHFlnCpl8DrJEGYVKM=;
 b=XjM/aNHsaOhFWMlZCMyxSvD9nDR+4AmJ5MGIZPK4Rk0V1OSGCmKSv76CN4BIu1o2nIpJ
 HZ9m+Hm9l9hdVenksQ78v0RrGHzecsccaho6xil9Zu77E6+EWKhaf+8yEfZ4q0GXWHzn
 JyQAACnsVyVQNVRTtMJKFhU5eeairoKjUbTKbU3bVUNpkKCCLTl73iyYGYbknLlVRJmn
 e+MaQ1XJ6v0P0VPR5M2U5XeZtGRhkBoOab/cev1Rjh4KplF8VKmBEoFFkjznrwBwDyt4
 LZyr76qudIOZncgMcgOt4iJmMX2p01N/wwpwc9c4OHlluxcwzSm5xGaq1ayB8tn2PhWb DA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 35wftx95gs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 06 Jan 2021 19:48:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106JiOll099160;
        Wed, 6 Jan 2021 19:46:44 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 35w3qsexhg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jan 2021 19:46:44 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 106Jkh5X018354;
        Wed, 6 Jan 2021 19:46:43 GMT
Received: from [10.154.148.218] (/10.154.148.218)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Jan 2021 19:46:43 +0000
Subject: Re: [PATCH v3 01/13] io_uring: modularize io_sqe_buffer_register
To:     Pavel Begunkov <asml.silence@gmail.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org
References: <1608314848-67329-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1608314848-67329-2-git-send-email-bijan.mottahedeh@oracle.com>
 <9abd2dbd-94b3-bb50-5160-d565ed2f1e98@gmail.com>
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Message-ID: <cff28b63-a2d7-4a5b-6b1b-6a644ea5fc02@oracle.com>
Date:   Wed, 6 Jan 2021 11:46:42 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <9abd2dbd-94b3-bb50-5160-d565ed2f1e98@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Antivirus: Avast (VPS 210101-4, 01/01/2021), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 priorityscore=1501 impostorscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060111
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/4/2021 1:54 PM, Pavel Begunkov wrote:
> On 18/12/2020 18:07, Bijan Mottahedeh wrote:
>> Split io_sqe_buffer_register into two routines:
>>
>> - io_sqe_buffer_register() registers a single buffer
>> - io_sqe_buffers_register iterates over all user specified buffers
> 
> It's a bit worse in terms of extra allocations, but not so hot to be
> be a problem, and looks simpler.
> 
> Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
> 
> Jens, I suggest to take 1,2 while they still apply (3/13 does not).
> I'll review others in a meanwhile.

I rebased the patches and will send the version soon, so the rest should 
apply as well.

