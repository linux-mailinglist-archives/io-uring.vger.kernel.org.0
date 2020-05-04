Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 585141C46EA
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2020 21:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgEDTQc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 May 2020 15:16:32 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42934 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgEDTQb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 May 2020 15:16:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044JDPXe099087;
        Mon, 4 May 2020 19:16:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=QqCvzslKy1qxN+LVzduRa3rFtYwHBIGI6A3wkwGuF10=;
 b=DOHL6nTz5/CykW18hOpUWWXuTLuSBLNP5it6Vk34PQOqBq2L4zEi6h68QZcQOneowNiu
 hfJy0vKAKD99EsavsRzWU3aquW2JIFU4Lod1WC7PUHK6ww48k/62uLO1fbenOYYmAPmi
 QCBnFX2x4VwjJ3CsCF4dAaw45/38Or2w3ndl0TRpcTjxa7wgdq/H8ASe6p0hnD6AIWoP
 c9zAtO1IUPoxOPR1sd5FXtV7e62qurxIADLsaI4jPNrKwH3+cFu0GlJOyOXrzfNpIVSL
 o2LdjPo0dy4oNGK10tBn/bMVCTMn5p3Sy9WY0e/k3F0uCap8uyEZx4h7wmEgmMVSogqw XQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30s0tm8umh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 May 2020 19:16:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044JDds3117937;
        Mon, 4 May 2020 19:16:28 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30t1r30tf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 May 2020 19:16:28 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 044JGR0r029699;
        Mon, 4 May 2020 19:16:27 GMT
Received: from [10.154.137.248] (/10.154.137.248)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 12:16:27 -0700
Subject: Re: [PATCH 1/1] io_uring: use proper references for fallback_req
 locking
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <1588207670-65832-1-git-send-email-bijan.mottahedeh@oracle.com>
 <05997981-047c-a87b-c875-6ea7b229f586@kernel.dk>
 <07fda8ac-93e4-e488-0575-026b339d2c36@gmail.com>
 <84554b60-2ec5-9876-79ce-5962ae5580e4@kernel.dk>
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Message-ID: <c25af31e-4d41-7b95-1cfa-8c87210a5e36@oracle.com>
Date:   Mon, 4 May 2020 12:16:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <84554b60-2ec5-9876-79ce-5962ae5580e4@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Antivirus: Avast (VPS 200503-0, 05/03/2020), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9610 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040150
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9610 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040150
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/4/2020 9:12 AM, Jens Axboe wrote:
> On 5/3/20 6:52 AM, Pavel Begunkov wrote:
>> On 30/04/2020 17:52, Jens Axboe wrote:
>>> On 4/29/20 6:47 PM, Bijan Mottahedeh wrote:
>>>> Use ctx->fallback_req address for test_and_set_bit_lock() and
>>>> clear_bit_unlock().
>>> Thanks, applied.
>>>
>> How about getting rid of it? As once was fairly noticed, we're screwed in many
>> other ways in case of OOM. Otherwise we at least need to make async context
>> allocation more resilient.
> Not sure how best to handle it, it really sucks to have things fall apart
> under high memory pressure, a condition that isn't that rare in production
> systems. But as you say, it's only a half measure currently. We could have
> the fallback request have req->io already allocated, though. That would
> provide what we need for guaranteed forward progress, even in the presence
> of OOM conditions.
>
A somewhat related question, would it make sense to have (configurable) 
pre-allocated requests, to be used first if low latency is a priority 
for a ring, or would the allocation overhead be negligible compared to 
the actual I/O?  This would be the flip side of fallback in a sense.

Thanks.

--bijan

--bijan
