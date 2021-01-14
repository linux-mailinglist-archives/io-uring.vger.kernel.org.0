Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 851252F6E81
	for <lists+io-uring@lfdr.de>; Thu, 14 Jan 2021 23:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725863AbhANWp1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Jan 2021 17:45:27 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34216 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730796AbhANWp1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Jan 2021 17:45:27 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10EMeXjP021362;
        Thu, 14 Jan 2021 22:44:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ZAeeTGzJx1p93gMaHNWkeG9AEqXkpWs9OyI+LXMSgjI=;
 b=f0FFaUymqKWS7l4D1qDzag55efBwjJjzSZW7f1VawQQATF/g0+mJvzB5Hbw6lynIkxWv
 rBzP6bYLBfcd9RmshCeTTBisZKRp/uZl5hxPj87Ash9ILHb+uiXVMxU4vWIuh8F9jyIL
 s5rqUg3K14bZ47BiItOs8gyJcbCtkYpRp4Ntz/vZrzcMKyCCY3LZSuqhOjbsnzeMKfyE
 TudTOJj+NhIP/FAI1B55jw4ewbAbX7+W3sICEkIA88XHYDYNcg1uyw+m8CLvmDkLuDMa
 w6348F/Q9R0DLq6YCcNJp9t19Ed9BfdTmksA52LacxDYbgEvjtoGXdDbVdWVe4Hn0khI DA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 360kd02hnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jan 2021 22:44:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10EMeGb0074283;
        Thu, 14 Jan 2021 22:44:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 360kf2qk20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jan 2021 22:44:38 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10EMic9c012932;
        Thu, 14 Jan 2021 22:44:38 GMT
Received: from [10.154.113.143] (/10.154.113.143)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 Jan 2021 14:44:38 -0800
Subject: Re: [PATCH v5 00/13] io_uring: buffer registration enhancements
To:     Pavel Begunkov <asml.silence@gmail.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org
References: <1610487193-21374-1-git-send-email-bijan.mottahedeh@oracle.com>
 <86a8ae2e-78b4-6d8c-1aea-5f169de5aabc@gmail.com>
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Message-ID: <e071e7e5-207b-9595-1de7-82f702864198@oracle.com>
Date:   Thu, 14 Jan 2021 14:44:37 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <86a8ae2e-78b4-6d8c-1aea-5f169de5aabc@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Antivirus: Avast (VPS 210113-0, 01/12/2021), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101140131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 impostorscore=0 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101140131
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/14/2021 1:20 PM, Pavel Begunkov wrote:
> On 12/01/2021 21:33, Bijan Mottahedeh wrote:
>> v5:
>>
>> - call io_get_fixed_rsrc_ref for buffers
>> - make percpu_ref_release names consistent
>> - rebase on for-5.12/io_uring
> 
> To reduce the burden I'll take the generalisation patches from that,
> review and resend to Jens with small changes leaving your "from:".
> I hope you don't mind, that should be faster.
> 
> I'll remove your signed-off and will need it back by you replying
> on this coming resend.

Sure, thanks.
