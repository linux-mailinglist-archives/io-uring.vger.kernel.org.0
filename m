Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA8082ED4FB
	for <lists+io-uring@lfdr.de>; Thu,  7 Jan 2021 18:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbhAGREK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Jan 2021 12:04:10 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:54056 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728088AbhAGREK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Jan 2021 12:04:10 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 107GdNA9179075;
        Thu, 7 Jan 2021 17:03:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=+BzuWqzVQo1O4V6105CQTJ3ZmMm8bTlIPdlQetEeMnk=;
 b=JmeZLVjpwNPXDSgjfimiYMNUktXOAYOzygtBicbkzO1gUIFI6Pro+wCHR9Vx0egF1pTH
 SGsvyk0KuNJylIg5s1CXXDpNIcO1dX/8NWpnYFb0OGsZrNIu1iC1jnSjgvxqSizpNrnl
 tpfs+abs5w5b9GbKBde6fQ5495J6eicCx6IEHq+aDw5UOaFC6lFpJGbTSxdSuzuhPrPV
 xzsb3RtL50/yV+YSHCyrb9yTyxvI7t6GJ2eQe9cuSLYVAeb4B1sYdI4n1vYZHU77L+a1
 TN9tFCL7FB+evdYV/DAKhWeERRnrdHpFnLyWiER67Y/mcp7K92w8M6BdePRaFywRIYXX 1Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 35wepmdbbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 07 Jan 2021 17:03:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 107H1b0T014262;
        Thu, 7 Jan 2021 17:03:27 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 35w3g31au9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jan 2021 17:03:26 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 107H3Niv012927;
        Thu, 7 Jan 2021 17:03:23 GMT
Received: from [10.154.113.215] (/10.154.113.215)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Jan 2021 17:03:22 +0000
Subject: Re: [PATCH v4 00/13] io_uring: buffer registration enhancements
To:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        io-uring@vger.kernel.org
References: <1609965562-13569-1-git-send-email-bijan.mottahedeh@oracle.com>
 <a6ca0151-b600-a57a-e50e-2e4f8aa3619f@kernel.dk>
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Message-ID: <ae9751b1-1d66-1910-c70d-53fd30f0ad97@oracle.com>
Date:   Thu, 7 Jan 2021 09:03:23 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <a6ca0151-b600-a57a-e50e-2e4f8aa3619f@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Antivirus: Avast (VPS 210101-4, 01/01/2021), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101070100
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101070099
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/7/2021 7:53 AM, Jens Axboe wrote:
> On 1/6/21 1:39 PM, Bijan Mottahedeh wrote:
>> v4:
>>
>> - address v3 comments (TBD REGISTER_BUFFERS)
>> - rebase
>>
>> v3:
>>
>> - batch file->rsrc renames into a signle patch when possible
>> - fix other review changes from v2
>> - fix checkpatch warnings
>>
>> v2:
>>
>> - drop readv/writev with fixed buffers patch
>> - handle ref_nodes both both files/buffers with a single ref_list
>> - make file/buffer handling more unified
>>
>> This patchset implements a set of enhancements to buffer registration
>> consistent with existing file registration functionality:
>>
>> - buffer registration updates		IORING_REGISTER_BUFFERS_UPDATE
>> 					IORING_OP_BUFFERS_UPDATE
>>
>> - buffer registration sharing		IORING_SETUP_SHARE_BUF
>> 					IORING_SETUP_ATTACH_BUF
>>
>> I have kept the original patchset unchanged for the most part to
>> facilitate reviewing and so this set adds a number of additional patches
>> mostly making file/buffer handling more unified.
>>
>> Patch 1-2 modularize existing buffer registration code.
> 
> Applied 1-2 for now with Pavel's review, hopefully we can crank through
> the rest of the series and target 5.12.
> 

Thanks.  As for the other patches, #13 needs some attention based on 
Pavel's observations regarding possible deadlocks.  Can you have a look 
at the discussion for that patch in the v2 series?
