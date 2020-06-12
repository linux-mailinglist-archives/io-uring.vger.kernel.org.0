Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A98ED1F7CD5
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2020 20:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbgFLSYp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Jun 2020 14:24:45 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39346 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbgFLSYp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Jun 2020 14:24:45 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05CIMUjk029529;
        Fri, 12 Jun 2020 18:24:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Q9yk5/2yam4+MaSyqkv33PqnEzX9NZJ3ZBIFBRJiQk4=;
 b=Swn7t85xTz7E3hcEi3dG/XWiL6wUd0EF2nwOBNzS/p7Ta54+xrFZLLVfstAMEvdz0dct
 4niVFf8KY4zqHVLdKGxHHOquyoGdJ1rr7cVIMSZjjkjmY+/aWVJMSlnru9M8wUhfpbPA
 iEHbg1wTaIWiklyzHpi5Y7vvGNM/voL3XBq3Lu3zyb+7F+wdnvM+DkJ7rlLfRRn0vPIL
 6+3IDv+GIEZRGeOp+GI8NfazazapHLUsTAr6dyiClUhHtNa31jp51kFGqCc9GyNdsFDI
 hAsT7WyF6wHUNQdD7lYtxXX9BV3NkpXSEt9TVopB5JctDrFs5CuoM+w9CP2niqPetnwV 8A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 31g2jrpasf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 12 Jun 2020 18:24:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05CIGb3T169469;
        Fri, 12 Jun 2020 18:22:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 31meug0vye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jun 2020 18:22:42 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05CIMfIV032681;
        Fri, 12 Jun 2020 18:22:41 GMT
Received: from [10.154.146.78] (/10.154.146.78)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 12 Jun 2020 11:22:41 -0700
Subject: Re: [RFC 1/2] io_uring: disallow overlapping ranges for buffer
 registration
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
References: <1591928617-19924-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1591928617-19924-2-git-send-email-bijan.mottahedeh@oracle.com>
 <b33937c3-6dbb-607a-d406-a2b42f407d86@kernel.dk>
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Message-ID: <fb0ec799-a397-ff7f-531d-6fcf8d5883cc@oracle.com>
Date:   Fri, 12 Jun 2020 11:22:38 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <b33937c3-6dbb-607a-d406-a2b42f407d86@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Antivirus: Avast (VPS 200612-2, 06/12/2020), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9650 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006120133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9650 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 cotscore=-2147483648 priorityscore=1501 spamscore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006120134
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/12/2020 8:16 AM, Jens Axboe wrote:
> On 6/11/20 8:23 PM, Bijan Mottahedeh wrote:
>> Buffer registration is expensive in terms of cpu/mem overhead and there
>> seems no good reason to allow overlapping ranges.
> There's also no good reason to disallow it imho, so not sure we should
> be doing that.
>

My concern was about a malicious user without CAP_IPC_LOCK abusing its 
memlock limit and repeatedly register the same buffer as that would tie 
up cpu/mem resources to pin up to 1TB of memory, but maybe the argument 
is that the user should have not been granted that large of memlock 
limit?  Also, without any restrictions, there are a huge number of ways 
overlapping ranges could be specified, creating a very large validation 
matrix.  What the use cases for that flexibility are though, I don't know.

--bijan
