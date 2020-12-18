Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAD72DE8BD
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 19:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgLRSHD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 13:07:03 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:39730 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727866AbgLRSHD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 13:07:03 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BII3n0m111371;
        Fri, 18 Dec 2020 18:06:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=vwxSV1XP3jRjg0ZZ9uLbJkeza1jPulexBC53CxJD7rc=;
 b=nJB9xUPpJnnQz77g8Iishpwl8Aff5+07+xXsW3Wu6EutkU1zKiGTc9YAvx8VQVTYYlbu
 1ITJIDuUUwliVAppaERUyxhEgZVms2JdDbTgw7ysyMr4P9MIAtEJZVkBkZFp1Hqb6oJM
 hP7bBG/nmzlWjCJ+MHFR3Q7cEJUdscRPm8pIuQ+Sydbag85qmK99GcM4psChIVNyFsbI
 NfuflKGXYDdEGhzVLjQ1KQugXQ02VSP+t3Uy9N7urBzwO2iqdIkf8Go8hb7HONWwy0MV
 LLbsRUQSfhahwVt98ETGqpiShR1MvjK/eEsZLgCMGeW6m8//sa4AZRY1CsjAajAKf+A9 bw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 35ckcbuq33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Dec 2020 18:06:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BII5Ni4028376;
        Fri, 18 Dec 2020 18:06:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 35d7eskhmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Dec 2020 18:06:19 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BII6I9T002982;
        Fri, 18 Dec 2020 18:06:18 GMT
Received: from [10.154.184.112] (/10.154.184.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Dec 2020 10:06:18 -0800
Subject: Re: [PATCH v2 06/13] io_uring: generalize fixed_file_ref_node
 functionality
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org
References: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1607379352-68109-7-git-send-email-bijan.mottahedeh@oracle.com>
 <99458b93-b1b1-76f7-c190-953a01fa45dc@gmail.com>
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Message-ID: <45272312-db80-616c-c0e8-4375bebcc4b3@oracle.com>
Date:   Fri, 18 Dec 2020 10:06:16 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <99458b93-b1b1-76f7-c190-953a01fa45dc@gmail.com>
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


>> +static struct fixed_rsrc_ref_node *alloc_fixed_file_ref_node(
>> +			struct io_ring_ctx *ctx)
>> +{
>> +	struct fixed_rsrc_ref_node *ref_node;
>> +
>> +	ref_node = alloc_fixed_rsrc_ref_node(ctx);
> 
> if (!ref_node)
> 	return NULL;

Ok.

