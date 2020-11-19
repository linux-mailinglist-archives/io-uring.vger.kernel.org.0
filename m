Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED3AE2B9B7D
	for <lists+io-uring@lfdr.de>; Thu, 19 Nov 2020 20:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbgKST1q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Nov 2020 14:27:46 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:33518 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727192AbgKST1p (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Nov 2020 14:27:45 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AJJOXPH137999;
        Thu, 19 Nov 2020 19:27:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=yAWlUmAkRGAhaT31lBIl/egQMtvJYitz46T8l5z9pM8=;
 b=FyR91+AF+OMRBf4UMBhJTl717k4pEdezan21Fz+NX8T0OWrjpKwlQ4eiLIPARMQ0S7CE
 lqG6nQ2KcDoMlB83N0/0B1xyxOYxqgUJxvhRyX9gZZXSFUrACEZXs+13//ixauBX7Een
 sgGXAqdNGDcBWWVNXHzRgOfk8PXQ0Kv+xTsqLYc8qA/BQ9gKoadzDhXYWSAzrvQgvGW5
 xXgiaLIc6eqON6gSZFbLowQaMMRIBsbE6EarkifwUheDUA4jK5vXle47UI7G7GagZ6SN
 SZUPOV6uNumEtwrPFnTrTmzw+0KNlskjk0ruWvn+DIiptTvso6RCI96/bbjv/n9YRG/F Ag== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34t4rb7cdk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 19 Nov 2020 19:27:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AJJQsQi003082;
        Thu, 19 Nov 2020 19:27:43 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 34ts60dmj6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Nov 2020 19:27:43 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AJJRgrs012036;
        Thu, 19 Nov 2020 19:27:42 GMT
Received: from [10.154.120.93] (/10.154.120.93)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Nov 2020 11:27:40 -0800
Subject: Re: [PATCH 7/8] io_uring: support readv/writev with fixed buffers
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <1605222042-44558-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1605222042-44558-8-git-send-email-bijan.mottahedeh@oracle.com>
 <d8c1c348-7806-ce54-c683-0c08e44d4590@gmail.com>
 <0bf865dc-14d3-9521-26d9-c91873535146@oracle.com>
 <4525dea0-e92b-4dd5-44d6-14687f30b674@gmail.com>
 <23841341-15cd-b096-4b0c-66d82cb6fdde@oracle.com>
 <7c28a1d9-a271-e5b7-ca3a-b62e293f3238@gmail.com>
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Message-ID: <7c5c727e-4f14-a3ba-0cd0-729a80708896@oracle.com>
Date:   Thu, 19 Nov 2020 11:27:38 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <7c28a1d9-a271-e5b7-ca3a-b62e293f3238@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Antivirus: Avast (VPS 201006-2, 10/06/2020), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=2 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011190134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=2 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011190134
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/19/2020 9:35 AM, Pavel Begunkov wrote:
> On 19/11/2020 02:34, Bijan Mottahedeh wrote:
>>
>>> Ok, there are 2 new patches in 5.10, you may wait for Jens to propagate it to
>>> 5.11 or just cherry-pick (no conflicts expected) them. On top apply ("io_uring:
>>> share fixed_file_refs b/w multiple rsrcs") to which I CC'ed you. It's
>>> simple enough so shouldn't be much problems with it.
>>>
>>> With that you need to call io_set_resource_node() every time you take
>>> a resource. That's it, _no_ extra ref_put for you to add in puts/free/etc.
>>
>> Thanks for the patches.
>>
>>> Also, consider that all ref_nodes of all types should be hooked into a
>>> single ->ref_list (e.g. file_data->ref_list).
>>
>> Just so I understand, would this common ref_list create any dependency between resource types when unregistering a given resource type?
>>
>> For example in
>>
>> io_sqe_files_unregister()
>> {
>>
>>          ...
>>          if (ref_node)
>>                  percpu_ref_kill(&ref_node->refs);
>>
>>          percpu_ref_kill(&data->refs);
>>          ...
>> }
>>
>> with the "order refnode recycling" patch, would files_unregister block until all requests using either fixed files or fixed buffers complete?
> 
> Yes, IORING_UNREGISTER_FILES will block even if there is a fixed
> buffer request, but IORING_REGISTER_FILES_UPDATE would not.
> 
> The latter follows RCU idea, it removes resources without blocking
> a syscall, so these resources are not accessible for new requests,
> but actual close(file), etc. happens sometime later after all previous
> requests with fixed resources (of any kind) complete.
> 
> IORING_OP_FILES_UPDATE works similarly but I need to look it up
> to be sure.
> 
> Does it answer you question?
> 

I think so, we want to treat fixed resources as uniformly as possible. 
The fact that the unregister dependency is intentional might not be 
immediately obvious so some comments would be needed.


