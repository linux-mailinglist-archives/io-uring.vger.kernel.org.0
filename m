Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6512F6EB0
	for <lists+io-uring@lfdr.de>; Thu, 14 Jan 2021 23:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730984AbhANWzO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Jan 2021 17:55:14 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:45592 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730928AbhANWzN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Jan 2021 17:55:13 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10EMniwi021589;
        Thu, 14 Jan 2021 22:54:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 references : message-id : date : mime-version : in-reply-to : content-type
 : content-transfer-encoding; s=corp-2020-01-29;
 bh=vf+vPPzVr1rbrwrQszz4VKY4ly7WVfwQ18Ont7S14qY=;
 b=YNZfUxnzcYF9BwDB/Z6cidm3FQc64+jgxYtzaEnDhm/s7X+LfcP248ae+CVgmENFBqrc
 WOOYuM33ZjSFUm+UuwPecccGLIV3Ps5z/vwDDZJvypCdMWyh9tQfauMpSulLZe3zN9aL
 mAkHK44vkSwbRmmgF3jDPu9RS86vFzByC3P/wZz3sqUeH+2y4grZkoZKw+xNDveM2ryz
 kz1OxyLeoUeAWR5Fcmb7jJ4sEuCdTOLq4zFMFXv8LQylVwuEUxuVIKplzmRnDNMmt3hP
 WmfrNkCqqOSb0WwhxGlhI13G3WaRsjlE/bN4Of9P5TnqBI9tvsss2hjdKawsAg2tzwWL Xw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 360kg22m78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jan 2021 22:54:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10EMoF4O095989;
        Thu, 14 Jan 2021 22:54:31 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 360kf2qtqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jan 2021 22:54:31 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10EMsT5u027308;
        Thu, 14 Jan 2021 22:54:29 GMT
Received: from [10.154.113.143] (/10.154.113.143)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 Jan 2021 14:54:29 -0800
Subject: Re: [PATCH v5 00/13] io_uring: buffer registration enhancements
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     Pavel Begunkov <asml.silence@gmail.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org
References: <1610487193-21374-1-git-send-email-bijan.mottahedeh@oracle.com>
 <86a8ae2e-78b4-6d8c-1aea-5f169de5aabc@gmail.com>
 <e071e7e5-207b-9595-1de7-82f702864198@oracle.com>
Message-ID: <50be90bb-1ccf-0266-ff32-f6b72958fdb9@oracle.com>
Date:   Thu, 14 Jan 2021 14:54:29 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <e071e7e5-207b-9595-1de7-82f702864198@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Antivirus: Avast (VPS 210113-0, 01/12/2021), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101140132
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 clxscore=1015 impostorscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101140132
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/14/2021 2:44 PM, Bijan Mottahedeh wrote:
> On 1/14/2021 1:20 PM, Pavel Begunkov wrote:
>> On 12/01/2021 21:33, Bijan Mottahedeh wrote:
>>> v5:
>>>
>>> - call io_get_fixed_rsrc_ref for buffers
>>> - make percpu_ref_release names consistent
>>> - rebase on for-5.12/io_uring
>>
>> To reduce the burden I'll take the generalisation patches from that,
>> review and resend to Jens with small changes leaving your "from:".
>> I hope you don't mind, that should be faster.
>>
>> I'll remove your signed-off and will need it back by you replying
>> on this coming resend.
> 
> Sure, thanks.

Do you have any other concerns about the buffer sharing patch itself 
that I can address?
