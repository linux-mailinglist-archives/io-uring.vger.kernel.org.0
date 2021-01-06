Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE3A52EC424
	for <lists+io-uring@lfdr.de>; Wed,  6 Jan 2021 20:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbhAFTrg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Jan 2021 14:47:36 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35674 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbhAFTrg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Jan 2021 14:47:36 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106Jj1h7129084;
        Wed, 6 Jan 2021 19:46:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=VYxHP4P2+mmZRy0CJagdRL4KPDbbxfXIuO8g6PmUQWI=;
 b=tCENxYC7T4FkbeG2Lal36+eLN7qzgiYQakuo5nDCPq452h7WflssU8MQRmKC2R0ilEoX
 3MoITmsFMKwmykpfTqfAGlIhh94xRHKYobG4vXsQXrpxLM/prtx5t+4xRpxLAIbdm4xq
 4vac26Npi1j5M9PiqKBvfIAcdEKlSCRE+LwBSAl/B6enr4Ue+xmTuP39/yho7rhDu+UT
 GCek7R/x/8gg32SuXxTELgVIwTUHHmkno+4kbuZy/MzOpTieDoJ6BDD3Extu0UJZzbW5
 B5nUH5m9g5UvA05y44Ut/OJUOFNZn/ew8nf2wxuwSIGRJ3CzntzTCCWYK6vy5BhX4khP vg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 35wepm9jq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 06 Jan 2021 19:46:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106JiVin052010;
        Wed, 6 Jan 2021 19:46:53 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 35v4rd2k2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jan 2021 19:46:53 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 106JkqFC024017;
        Wed, 6 Jan 2021 19:46:52 GMT
Received: from [10.154.148.218] (/10.154.148.218)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Jan 2021 19:46:52 +0000
Subject: Re: [PATCH v3 03/13] io_uring: rename file related variables to rsrc
To:     Pavel Begunkov <asml.silence@gmail.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org
References: <1608314848-67329-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1608314848-67329-4-git-send-email-bijan.mottahedeh@oracle.com>
 <4299b6c0-5ab8-ba8c-c763-7bdf8b569347@gmail.com>
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Message-ID: <c182d14b-635e-939e-d3e9-0bfea9b8304a@oracle.com>
Date:   Wed, 6 Jan 2021 11:46:52 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <4299b6c0-5ab8-ba8c-c763-7bdf8b569347@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Antivirus: Avast (VPS 210101-4, 01/01/2021), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060111
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/4/2021 5:53 PM, Pavel Begunkov wrote:
> On 18/12/2020 18:07, Bijan Mottahedeh wrote:
>> This is a prep rename patch for subsequent patches to generalize file
>> registration.
> [...]
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index d31a2a1..d421f70 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -285,7 +285,7 @@ enum {
>>   	IORING_REGISTER_LAST
>>   };
>>   
>> -struct io_uring_files_update {
>> +struct io_uring_rsrc_update {
> 
> It's a user API, i.e. the header used by userspace programs, so can't
> be changed or would break them.
> 
>>   	__u32 offset;
>>   	__u32 resv;
>>   	__aligned_u64 /* __s32 * */ fds;
>>
> 

I defined files to be same as rsrc in io_uring.h:

#define io_uring_files_update   io_uring_rsrc_update

As for liburing, I have modified it to use io_uring_rsrc_update.

Does that look reasonable?


