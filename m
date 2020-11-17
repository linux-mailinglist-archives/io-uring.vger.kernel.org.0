Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0722B55AC
	for <lists+io-uring@lfdr.de>; Tue, 17 Nov 2020 01:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730977AbgKQAX6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Nov 2020 19:23:58 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34348 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgKQAX5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Nov 2020 19:23:57 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH0Kuab022669;
        Tue, 17 Nov 2020 00:23:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=70fICN6P464O83/WnEZVRfVsMA0bWG32P4YwvsMxc/U=;
 b=G7c+5kxicKpj9FWqBm/slWrHskhstsRCkZtItB0K0gwG84HcPtzTUgGyR5ZFzuF+qJ50
 A14AQOQzTxEIXlHjGvVX7S0PGrDbSAno/gg6//C498+EIFbP7MG6c5NPEsGeaGfiwJsd
 mi0244PXRuek9AKORpQFW1zXhrtAU0Xv7dvAKn+hQwItzzI3ONQVqdPIIs1WCxVksZWL
 zcFwA/GXQPhpY6Ob19uY+g91copqjKobKqlJIm61unVJUTFX75Vj5oqNWcYsRmNOR7sM
 dQdNDrNRUS/mEOnr1Ia8BaIfrIneh3C0dd/a7QyOdXayx0D3h5QCL7SjTG63/bK5R/4r Ow== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34t76kqyk1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Nov 2020 00:23:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH0LQwt040684;
        Tue, 17 Nov 2020 00:21:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34ts0q58te-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 00:21:53 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AH0LqJr020683;
        Tue, 17 Nov 2020 00:21:52 GMT
Received: from [10.154.175.238] (/10.154.175.238)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Nov 2020 16:21:52 -0800
Subject: Re: [PATCH 0/8] io_uring: buffer registration enhancements
To:     Pavel Begunkov <asml.silence@gmail.com>, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
References: <1605222042-44558-1-git-send-email-bijan.mottahedeh@oracle.com>
 <55bd38e0-2f76-413a-04ce-c7ef89e6e13d@gmail.com>
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Message-ID: <436cf34b-8065-bae4-6900-7730f0df1999@oracle.com>
Date:   Mon, 16 Nov 2020 16:21:49 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <55bd38e0-2f76-413a-04ce-c7ef89e6e13d@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Antivirus: Avast (VPS 201006-2, 10/06/2020), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=832 adultscore=0
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 mlxlogscore=850
 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011170001
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


>> This patchset is the follow-on to my previous RFC which implements a
>> set of enhancements to buffer registration consistent with existing file
>> registration functionality:
> 
> I like the idea of generic resource handling
> 
>>
>> - buffer registration updates		IORING_REGISTER_BUFFERS_UPDATE
>> 					IORING_OP_BUFFERS_UPDATE
> 
> Do you need it for something specific?

Incremental buffer registration, see below.

> 
>>
>> - readv/writev with fixed buffers	IOSQE_FIXED_BUFFER
> 
> Why do we need it?

It makes fixed files/buffers APIs more consistent, and once the initial 
work of generic resource handling is done, the additional work for this 
support is not much I think.

> 
>>
>> - buffer registration sharing		IORING_SETUP_SHARE_BUF
>> 					IORING_SETUP_ATTACH_BUF
> 
> I haven't looked it up. What's the overhead on that?
> And again, do you really need it?

For our use case, a DB instance may have a shared memory size of TB 
order and very large number of processes (1000+) using that memory.  The 
cost of each process registering that memory could become prohibitive.

We need to allow for incremental buffer registration given the 
potentially large size of the shared memory.  It also makes the API 
between files/buffers more consistent.

I had a chat with Jens a while back and he also felt that the static 
nature of buffer registrations and the requirement to reload the full 
set in case of changes was problematic.

> 
> The set is +600 lines, so just want to know that there is
> a real benefit from having it.

Sure, understood.

