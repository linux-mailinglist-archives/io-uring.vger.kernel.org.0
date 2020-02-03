Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2013F151193
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2020 22:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgBCVIG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Feb 2020 16:08:06 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:38030 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgBCVIG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Feb 2020 16:08:06 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 013Kwm0i142694;
        Mon, 3 Feb 2020 21:07:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=DXO8hDrG8JkjrxM0Pjgy8qUKrcH8Owfmwlj8mx4PKdw=;
 b=sW01S/2jLwXJv9hkcpn2llt2vCAIhSEM+4tuHKXAP0FtueRuMuF5SFccC2eWDaEm4RIh
 O5H/OOI7mhxMP2sOJgITdR9FX/irTh81Mj8F3kHlP/wAzoylmTgcXb5KsUfk8MuCXBRm
 NzM3DWt4Fzd7PHs4cE61wY8qbk74P9luIFrxqEQf8TKd1oHtI+h3H5dthMzktEE0tyGy
 HX+jqXetEVBbxh2u05+rnrZoz6y5gxrbQGToaxfXVvzk8W7z5bdFcWBMegyco4ebrTed
 520ud4lhkXWFTArp4fLs17GS+PpU1QHgGUZueOoX8aoUbcsMTrRznHXjdUbdw50fxJXB wg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xwyg9erfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Feb 2020 21:07:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 013KxGUL137449;
        Mon, 3 Feb 2020 21:07:56 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2xwjt50m5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Feb 2020 21:07:56 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 013L7qW4029558;
        Mon, 3 Feb 2020 21:07:52 GMT
Received: from [10.154.153.81] (/10.154.153.81)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 03 Feb 2020 13:07:51 -0800
Subject: Re: [PATCH 1/1] block: Manage bio references so the bio persists
 until necessary
To:     Christoph Hellwig <hch@infradead.org>
Cc:     axboe@kernel.dk, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org
References: <1580441022-59129-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1580441022-59129-2-git-send-email-bijan.mottahedeh@oracle.com>
 <20200131064230.GA28151@infradead.org>
 <9f29fbc7-baf3-00d1-a20c-d2a115439db2@oracle.com>
 <20200203083422.GA2671@infradead.org>
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Message-ID: <aaecd43b-dd44-f6c5-4e2d-1772cf135d2a@oracle.com>
Date:   Mon, 3 Feb 2020 13:07:48 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200203083422.GA2671@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Antivirus: Avast (VPS 200202-0, 02/01/2020), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9520 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002030152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9520 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002030152
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/3/2020 12:34 AM, Christoph Hellwig wrote:
> On Fri, Jan 31, 2020 at 06:08:16PM +0000, Bijan Mottahedeh wrote:
>> I think the problem is that in the async case, bio_get() is not called for
>> the initial bio *before* the submit_bio() call for that bio:
>>
>>      if (dio->is_sync) {
>>          dio->waiter = current;
>>          bio_get(bio);
>>      } else {
>>          dio->iocb = iocb;
>>      }
>>
>>
>> The bio_get() call for the async case happens too late, after the
>> submit_bio() call:
>>
>>          if (!dio->multi_bio) {
>>              /*
>>               * AIO needs an extra reference to ensure the dio
>>               * structure which is embedded into the first bio
>>               * stays around.
>>               */
>>              if (!is_sync)
>>                  bio_get(bio);
>>              dio->multi_bio = true;
>>              atomic_set(&dio->ref, 2);
>>          } else {
>>              atomic_inc(&dio->ref);
>>          }
> That actualy is before the submit_bio call, which is just below that
> code.
>
>>
>> See my previous message on the mailing list titled "io_uring: acquire
>> ctx->uring_lock before calling io_issue_sqe()" for the more details but
>> basically blkdev_bio_end_io() can be called before submit_bio() returns and
>> therefore free the initial bio.  I think it is the unconditional bio_put()
>> at the end that does it.
> But we never access the bio after submit_bio returns for the single
> bio async case, so I still don't understand the problem.

Ok, I see your point.

My concern is with the code below for the single bio async case:

                            qc = submit_bio(bio);

                            if (polled)
                                    WRITE_ONCE(iocb->ki_cookie, qc);

The bio/dio can be freed before the the cookie is written which is what 
I'm seeing, and I thought this may lead to a scenario where that iocb 
request could be completed, freed, reallocated, and resubmitted in 
io_uring layer; i.e., I thought the cookie could be written into the 
wrong iocb.

So I have two questions:

Could we ever update a wrong iocb?

Is the additional bio_get() the right way to mitigate that?  I see that 
this might not be true since end_io() calls ki_complete() regardless.

Thanks.

--bijan


