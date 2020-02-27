Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8B61713A6
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2020 10:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbgB0JFW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Feb 2020 04:05:22 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44648 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728627AbgB0JFW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Feb 2020 04:05:22 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01R92mrI100909;
        Thu, 27 Feb 2020 09:05:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=T8tGCCI7g34NHBNqX3ptq95FJYXCBtLf/FnjowZ3Q9Q=;
 b=QXPNVaWrEnZISnv11ePayKkyMoLgh5et46+pvSuLCJ5HEKvSiLR9M5ev+GB4Kx/6qGD3
 imJiOAfCJOO2LjejTpuWo9Yq8q2wxCfeBRBReTTxECiWCX4CABcWtmNoUWTqjYid+5q+
 8kTfSPWR1KghuSyYef8pw5146xCMWEjTe8YLth/SUwfzJCe3Ff9HxuDuF391MHJw9fin
 gciin6+83TM0xgHBFmAth8LdWQxm0/7WHJ8/ugOEZpquZSmULv7oRiUx0XGam61e/oU6
 ++UpEn68j/n5HRU5+rGbr3q9jDFu/tPZvzgPivzfWULKNB+ci4z3dsRj15AE3K77YzOv Cw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2ydct39e92-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 09:05:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01R8ug97006754;
        Thu, 27 Feb 2020 09:05:18 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2ydcsbvb44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 09:05:18 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01R95HqF025334;
        Thu, 27 Feb 2020 09:05:17 GMT
Received: from [192.168.1.14] (/114.88.246.185)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Feb 2020 01:05:17 -0800
Subject: Re: [PATCH 1/4] io_uring: add IORING_OP_READ{WRITE}V_PI cmd
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Cc:     martin.petersen@oracle.com, linux-fsdevel@vger.kernel.org,
        darrick.wong@oracle.com, io-uring@vger.kernel.org
References: <20200226083719.4389-1-bob.liu@oracle.com>
 <20200226083719.4389-2-bob.liu@oracle.com>
 <6e466774-4dc5-861c-58b5-f0cc728bacff@kernel.dk>
From:   Bob Liu <bob.liu@oracle.com>
Message-ID: <8386e54e-723a-93e3-776c-b2138d077c77@oracle.com>
Date:   Thu, 27 Feb 2020 17:05:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <6e466774-4dc5-861c-58b5-f0cc728bacff@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270073
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270073
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/26/20 10:24 PM, Jens Axboe wrote:
> On 2/26/20 1:37 AM, Bob Liu wrote:
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index a3300e1..98fa3f1 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -62,6 +62,8 @@ enum {
>>  	IORING_OP_NOP,
>>  	IORING_OP_READV,
>>  	IORING_OP_WRITEV,
>> +	IORING_OP_READV_PI,
>> +	IORING_OP_WRITEV_PI,
>>  	IORING_OP_FSYNC,
>>  	IORING_OP_READ_FIXED,
>>  	IORING_OP_WRITE_FIXED,
> 
> So this one renumbers everything past IORING_OP_WRITEV, breaking the
> ABI in a very bad way. I'm guessing that was entirely unintentional?
> Any new command must go at the end of the list.
> 
> You're also not updating io_op_defs[] with the two new commands,
> which means it won't compile at all. I'm guessing you tested this on
> an older version of the kernel which didn't have io_op_defs[]?
> 

Yep, will rebase to the latest version next time.

