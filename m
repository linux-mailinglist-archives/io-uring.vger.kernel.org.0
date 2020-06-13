Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDE31F8106
	for <lists+io-uring@lfdr.de>; Sat, 13 Jun 2020 06:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725535AbgFMEns (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 13 Jun 2020 00:43:48 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33866 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbgFMEns (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 13 Jun 2020 00:43:48 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05D4hkPl143204;
        Sat, 13 Jun 2020 04:43:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=YRKO4rvZ8CKCFve2eSuhNnBJY1x5JLT3fz5qTm/8/IY=;
 b=F2oYKQ8WbkiWoEK1EOBW6dISAYUafHE/zrD38+lKL2S0+ew2Mzm26ObcMKS54cwGNRuY
 N/u/gp9Xsdyok4dIAmpiLHoALqJSjLmUYAcNs1sVFihcO4m+m5FcFEKXu84ZnniSh5sN
 D+e8ZqljibqmSrfQxoNtYIoDP/nBv41Xttx1NYdXhHztRJ3WxxFYI6S4Yk/ikXNCVwF1
 w7zO1gAfcAYCHyaOMyLAK12fiKBmN9MAY18ypbEkUp7mClbErADzaOJaTY25VLk0hJmT
 Mt7Wq05Duwwg3UpdKXQc4HVTC3mkh5MU8d8iqijf0EabV6ui8RvfGTcetA9drBw4uTlv Mw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 31mp7r0630-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 13 Jun 2020 04:43:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05D4ggWo129165;
        Sat, 13 Jun 2020 04:43:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 31mmu8d42r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 13 Jun 2020 04:43:45 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05D4hhHM026554;
        Sat, 13 Jun 2020 04:43:43 GMT
Received: from [10.154.146.78] (/10.154.146.78)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 13 Jun 2020 04:43:43 +0000
Subject: Re: [RFC 2/2] io_uring: report pinned memory usage
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
References: <1591928617-19924-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1591928617-19924-3-git-send-email-bijan.mottahedeh@oracle.com>
 <b08c9ee0-5127-a810-de01-ebac4d6de1ee@kernel.dk>
 <6b2ef2c9-5b58-f83e-b377-4a2e1e3e98e5@kernel.dk>
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Message-ID: <32054e77-0ee4-ebab-d2c3-fef92261eecf@oracle.com>
Date:   Fri, 12 Jun 2020 21:43:39 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <6b2ef2c9-5b58-f83e-b377-4a2e1e3e98e5@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Antivirus: Avast (VPS 200612-2, 06/12/2020), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9650 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006130038
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9650 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 clxscore=1015
 cotscore=-2147483648 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006130038
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/12/2020 8:19 AM, Jens Axboe wrote:
> On 6/12/20 9:16 AM, Jens Axboe wrote:
>> On 6/11/20 8:23 PM, Bijan Mottahedeh wrote:
>>> Long term, it makes sense to separate reporting and enforcing of pinned
>>> memory usage.
>>>
>>> Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
>>>
>>> It is useful to view
>>> ---
>>>   fs/io_uring.c | 4 ++++
>>>   1 file changed, 4 insertions(+)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 4248726..cf3acaa 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -7080,6 +7080,8 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
>>>   static void io_unaccount_mem(struct user_struct *user, unsigned long nr_pages)
>>>   {
>>>   	atomic_long_sub(nr_pages, &user->locked_vm);
>>> +	if (current->mm)
>>> +		atomic_long_sub(nr_pages, &current->mm->pinned_vm);
>>>   }
>>>   
>>>   static int io_account_mem(struct user_struct *user, unsigned long nr_pages)
>>> @@ -7096,6 +7098,8 @@ static int io_account_mem(struct user_struct *user, unsigned long nr_pages)
>>>   			return -ENOMEM;
>>>   	} while (atomic_long_cmpxchg(&user->locked_vm, cur_pages,
>>>   					new_pages) != cur_pages);
>>> +	if (current->mm)
>>> +		atomic_long_add(nr_pages, &current->mm->pinned_vm);
>>>   
>>>   	return 0;
>>>   }
>> current->mm should always be valid for these, so I think you can skip the
>> checking of that and just make it unconditional.
> Two other issues with this:
>
> - It's an atomic64, so seems more appropriate to use the atomic64 helpers
>    for this one.
> - The unaccount could potentially be a different mm, if the ring is shared
>    and one task sets it up while another tears it down. So we'd need something
>    to ensure consistency here.
>
Are you referring to a case where one process creates a ring and sends 
the ring fd to another process?
