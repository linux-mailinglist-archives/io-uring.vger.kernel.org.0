Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85E542DE8BB
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 19:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgLRSGx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 13:06:53 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:39574 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbgLRSGx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 13:06:53 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BII3nur111173;
        Fri, 18 Dec 2020 18:06:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=oXzgMN4IU8PN6WoU7e9QYB3Wn9Ef5yDJzFrKbE2S4mY=;
 b=FjXc8JniXtJBI3edFK5Qvh0zCHBt9rLAhZ4lxCLrqqHfuhoJ7oBtqbxg6V9NkoooArDH
 NEsRphDq7RYZN+W0R1zbtZGAfwFrEM8fUkQeJNeZi/1X56JkvJINpvK1o8dTDY7JAaiT
 GYoLV1Sa9iSw+gCCDmAMiI/3YFTLAurVFQDouLYDbbjaHSBn0CicYFphywLdvogd++lm
 UAYxfFiePZcH6S+T3TWS4MSky0OfezdtbI5S/kd5BI+CnXAz3n/VVkIoPp7fVGqE042w
 acwcfc+qQj3fvq8vNKGdkIr+4ysf0uw/80NTR1C1mujhQIjnhH2efi6a0Ar+qN/xRCnQ fA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 35ckcbuq2n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Dec 2020 18:06:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BII5Ncc028414;
        Fri, 18 Dec 2020 18:06:09 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 35d7eskhes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Dec 2020 18:06:09 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BII68IN013870;
        Fri, 18 Dec 2020 18:06:08 GMT
Received: from [10.154.184.112] (/10.154.184.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Dec 2020 10:06:08 -0800
Subject: Re: [PATCH v2 00/13] io_uring: buffer registration enhancements
To:     Pavel Begunkov <asml.silence@gmail.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org
References: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
 <c1f6faa1-63a4-777c-fe46-2ee7952baa2f@gmail.com>
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Message-ID: <d90ec8a1-6661-dd66-ed1d-916b7b8a8475@oracle.com>
Date:   Fri, 18 Dec 2020 10:06:06 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <c1f6faa1-63a4-777c-fe46-2ee7952baa2f@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Antivirus: Avast (VPS 201217-2, 12/17/2020), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9839 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012180124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9839 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012180124
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


> Thanks for the patches! I'd _really_ prefer for all s/files/rsrc/
> renaming being in a single prep patch instead of spilling it all around.
> I found one bug, but to be honest it's hard to get through when functional
> changes and other cleanups are buried under tons of such renaming.

I've tried to gather as much of the renames that can be grouped together 
in the next version I'm about to send.  It is hard however to put all 
renames in one place since they often go hand in hand with a 
corresponding functionality change.  I appreciate though that the 
renames get in the way, sorry for that :-)  If you think more can be 
done after the next version, I'll look into more.
