Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F33BB2DE8BC
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 19:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbgLRSG4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 13:06:56 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:39634 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbgLRSG4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 13:06:56 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BII3pWt113382;
        Fri, 18 Dec 2020 18:06:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=4/L/2P5bgo6c+P6d3H4cVXbs1FWTjcSn8VEr8zmowy8=;
 b=cEq3SPtHLEhim8wBubpX6ciiLrgzMBp0GMPzideMA8Pf9chgZv4nHA3UNoLrEKVzgPdC
 MssRW3hQTYQIMdBDHYRsanR3XOAgNeTD5vlm0ZxRR20Hyv1Kz0LaOvL9OIsb8gkYOGGF
 ph+rO/myIhp14T42LAQskt/M6EQSpaslieDKKyO5Ex1C42frgM4sAq0e1LUbWf3BPTWr
 PN5SghP1uR+OmfwfFdbr6K0KAgqZh4de5U26V5KyLycQZT5mLza7qhwdaQvloO4Xu1Nl
 4467wMaGv74frEG/4EnHLBLFD9ENRNnF+0PliISQATTAq6yIe+q/6Ro6NsS5xOGGae5l cA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 35ckcbuq2s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Dec 2020 18:06:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BII5RkX095930;
        Fri, 18 Dec 2020 18:06:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 35e6ev0wbf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Dec 2020 18:06:12 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BII6AIv002856;
        Fri, 18 Dec 2020 18:06:10 GMT
Received: from [10.154.184.112] (/10.154.184.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Dec 2020 10:06:10 -0800
Subject: Re: [PATCH v2 00/13] io_uring: buffer registration enhancements
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
 <e8afcd4c-37b8-f02e-c648-4cd14f12636a@oracle.com>
 <b9379af3-c7cc-03ca-8510-7803b54ae7e9@kernel.dk>
 <b6736e0e-157b-a5ee-a3fb-e40903343d2b@gmail.com>
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Message-ID: <fb29933f-7451-40f9-45f0-7327c130ae32@oracle.com>
Date:   Fri, 18 Dec 2020 10:06:08 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <b6736e0e-157b-a5ee-a3fb-e40903343d2b@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Antivirus: Avast (VPS 201217-2, 12/17/2020), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9839 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
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


>> For your question, yes I think we could add sqe->update_flags (something
>> like that) and union it with the other flags, and add a flag that means
>> we're updating buffers instead of files. A bit iffy with the naming of
>> the opcode itself, but probably still a useful way to go.
> 
> #define OPCODE_UPDATE_RESOURCES OPCODE_UPDATE_FILES
> 
> With define + documenting that they're same IMHO should be fine.

I tried to use a single opcode for files/buffers but ran into an
issue since work_flags is different for files/buffers.  This should
be ok for the most part since req->work.flags is ultimately examined;
however, there are place where io_op_defs[opcode].work_flags is examined
directly, and I wasn't sure what would the best way to handle that.
