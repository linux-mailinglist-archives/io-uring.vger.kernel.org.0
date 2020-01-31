Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C05C714F1F6
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2020 19:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbgAaSJX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jan 2020 13:09:23 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:44784 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726712AbgAaSJW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jan 2020 13:09:22 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00VI0bPB021344;
        Fri, 31 Jan 2020 18:08:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=PhQgkzMs8qd0Nh0+TO4c0jCm56js0xXymHvTafoC26c=;
 b=pncEO13RJB96BIFTBzyaUtws4rQ57+2gfuxkZDmGmnwSY4BsOCFljYK4FK3uMx+1rQgq
 8Qyzi+5bNZ2g02DmDpRoyIul5L826a6Oj3rVpJbLtVyjESN3s2XF6cF8YSqUCnVhGR6x
 Pw60c/uyf8fH33W1kNqpfN9nd1nKovZXev/j4x9/rqDtYALYk+adUL8gComekweG6cit
 r2GZ19e9PKcnTowISzDtfoAuBvsLkiAWOLQOEt6nHWdGUu/zeB2/+fiCoQohAp2wKqt6
 OzhBVHyEiyi+9+OKn/LJtiM+rSofpjyRz1g/nKqbMjnmzJxJ69Vo5PXlDf695PF9wgjc qQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xrdmr44w3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jan 2020 18:08:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00VI2OOe044633;
        Fri, 31 Jan 2020 18:08:58 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2xva6r7ag4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jan 2020 18:08:57 +0000
Received: from abhmp0021.oracle.com (abhmp0021.oracle.com [141.146.116.27])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00VI8u01016813;
        Fri, 31 Jan 2020 18:08:57 GMT
X-ANTIVIRUS-STATUS: Clean
Received: from [10.154.102.175] (/10.154.102.175) by default (Oracle Beehive
 Gateway v4.0) with ESMTP ; Fri, 31 Jan 2020 10:08:19 -0800
X-ANTIVIRUS: Avast (VPS 200131-0, 01/30/2020), Outbound message
USER-AGENT: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
Content-Language: en-US
MIME-Version: 1.0
Message-ID: <9f29fbc7-baf3-00d1-a20c-d2a115439db2@oracle.com>
Date:   Fri, 31 Jan 2020 18:08:16 +0000 (UTC)
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     axboe@kernel.dk, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org
Subject: Re: [PATCH 1/1] block: Manage bio references so the bio persists
 until necessary
References: <1580441022-59129-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1580441022-59129-2-git-send-email-bijan.mottahedeh@oracle.com>
 <20200131064230.GA28151@infradead.org>
In-Reply-To: <20200131064230.GA28151@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9517 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001310149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9517 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001310149
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/30/2020 10:42 PM, Christoph Hellwig wrote:
> On Thu, Jan 30, 2020 at 07:23:42PM -0800, Bijan Mottahedeh wrote:
>> Get a reference to a bio, so it won't be freed if end_io() gets to
>> it before submit_io() returns.  Defer the release of the first bio
>> in a mult-bio request until the last end_io() since the first bio is
>> embedded in the dio structure and must therefore persist through an
>> entire multi-bio request.
> Can you explain the issue a little more?
>
> The initial bio is embedded into the dio, and will have a reference
> until the bio_put call at the end of the function, so we can't have
> a race for that one and won't ever need the refcount for the single
> bio case.  Avoiding the atomic is pretty important for aio/uring
> performance.
I think the problem is that in the async case, bio_get() is not called 
for the initial bio *before* the submit_bio() call for that bio:

     if (dio->is_sync) {
         dio->waiter = current;
         bio_get(bio);
     } else {
         dio->iocb = iocb;
     }


The bio_get() call for the async case happens too late, after the 
submit_bio() call:

         if (!dio->multi_bio) {
             /*
              * AIO needs an extra reference to ensure the dio
              * structure which is embedded into the first bio
              * stays around.
              */
             if (!is_sync)
                 bio_get(bio);
             dio->multi_bio = true;
             atomic_set(&dio->ref, 2);
         } else {
             atomic_inc(&dio->ref);
         }

See my previous message on the mailing list titled "io_uring: acquire 
ctx->uring_lock before calling io_issue_sqe()" for the more details but 
basically blkdev_bio_end_io() can be called before submit_bio() returns 
and therefore free the initial bio.  I think it is the unconditional 
bio_put() at the end that does it.
