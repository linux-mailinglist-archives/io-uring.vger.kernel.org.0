Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81C91DDC89
	for <lists+io-uring@lfdr.de>; Fri, 22 May 2020 03:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbgEVBUm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 May 2020 21:20:42 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42624 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726737AbgEVBUl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 May 2020 21:20:41 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M1IMlo174748;
        Fri, 22 May 2020 01:20:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Gu9X73Hv362f0bf/CG7SffPNkFYktqNBeIwwjm4bOCI=;
 b=I5g9Xuh+thFdf0THeiRYYEiR0uChyGQau26QwTwRhvkLDxLDU7SHk3WB37xXN6DZIZBm
 P+h1eBqwQs5c51kF+PVwMpfn66Q0EGON+I+Qje1dZpaUpY3QhyZsZUFssDzcIqIfEREX
 Az70abEMjQIfogTRTpR/EY5Vv7GHxcYtjTKvhE0GdLc5Voa98OkTM06+2bj7KGoz2h3Z
 4Lo70mijTcPJsePQQqFgDxOn8oe0L9KSPswoxs1kN7sumClmNCjS3agZbirRWa87K9Ri
 I/yOetlMRvLe+KYv7bDeRm/FC4OI5GhjPvqpMvAEJAWjBpBI3RQdalKTkNf/wLIWxQBY Ug== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3127krkdcq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 01:20:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M1JH7w076338;
        Fri, 22 May 2020 01:20:37 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 315023e0gx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 01:20:37 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04M1KaTo009059;
        Fri, 22 May 2020 01:20:36 GMT
Received: from [10.154.118.183] (/10.154.118.183)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 May 2020 18:20:36 -0700
Subject: Re: [PATCH 2/2] io_uring: call statx directly
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <1590106777-5826-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1590106777-5826-3-git-send-email-bijan.mottahedeh@oracle.com>
 <20200522005053.GK23230@ZenIV.linux.org.uk>
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Message-ID: <47c7c6bc-6b35-71de-56ff-e9aabd7d6aff@oracle.com>
Date:   Thu, 21 May 2020 18:20:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200522005053.GK23230@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Antivirus: Avast (VPS 200520-0, 05/19/2020), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1011 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220007
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/21/2020 5:50 PM, Al Viro wrote:
> On Thu, May 21, 2020 at 05:19:37PM -0700, Bijan Mottahedeh wrote:
>> Calling statx directly both simplifies the interface and avoids potential
>> incompatibilities between sync and async invokations.
>>
>> Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
>> ---
>>   fs/io_uring.c | 53 +++++++----------------------------------------------
>>   1 file changed, 7 insertions(+), 46 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 12284ea..0540961 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -427,7 +427,10 @@ struct io_open {
>>   	union {
>>   		unsigned		mask;
>>   	};
>> -	struct filename			*filename;
>> +	union {
>> +		struct filename		*filename;
>> +		const char __user	*fname;
>> +	};
> NAK.  io_uring is already has ridiculous amount of multiplexing,
> but this kind of shit is right out.
>
> And frankly, the more I look at it, the more I want to rip
> struct io_open out.  This kind of trashcan structures has
> caused tons of headache pretty much every time we had those.
> Don't do it.

Are you suggesting a separate io_statx structure or something similar?

Are you ok with the addition of do_statx() in the first patch?

Thanks.

--bijan
