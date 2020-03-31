Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D63ED199E48
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2020 20:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgCaSnz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Mar 2020 14:43:55 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42810 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgCaSnz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Mar 2020 14:43:55 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02VIhPep003003;
        Tue, 31 Mar 2020 18:43:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ADi5iHr+DiyFeoElDNeP30DVd+kVi1D13wCm7TLp2M0=;
 b=KnpqFIXds0AUFbe1rkdV1n59kycF8PtCIdI1mfyYqfGPq1wMSsejKYUao2cPbbcDgFog
 EiDoqcmovPjVMDTUYGSrLryRcHq1ZAxvRVfEYOv/3kSKCWztT2akoGthF+W0DULDiD6A
 xLWB6fV7o67HTxyemwHSYa6Br2bTP8vVU7lLqMwrkHomoOVjskcgXOeNi0wTH4ULc6Lu
 hd2eGp62X3da/VLZt4+guyVZSI+H9rDyU6ECc6Zwz+McE/h0HOf6DR2MJmocXVtrxgO0
 3fnpJQlyDK249ruHhAsFlgC05Awv7trr34fhCJ+JiaBc1Ue6HWBxL9pKvkH6eZZ2dt36 Iw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 303yun3wyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Mar 2020 18:43:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02VIh2hX182122;
        Tue, 31 Mar 2020 18:43:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 302gcdcm2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Mar 2020 18:43:51 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02VIhnMI006243;
        Tue, 31 Mar 2020 18:43:49 GMT
Received: from [10.154.118.208] (/10.154.118.208)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Mar 2020 11:43:49 -0700
Subject: Re: Polled I/O cannot find completions
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <471572cf-700c-ec60-5740-0282930c849e@oracle.com>
 <4098ab93-980e-7a17-31f7-9eaeb24a2a65@kernel.dk>
 <34a7c633-c390-1220-3c78-1215bd64819f@oracle.com>
 <d2f92d20-2eb0-e683-5011-e1c922dfcf71@kernel.dk>
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Message-ID: <400a73dc-78de-0de7-79b4-4a4e8bed34ce@oracle.com>
Date:   Tue, 31 Mar 2020 11:43:46 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <d2f92d20-2eb0-e683-5011-e1c922dfcf71@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Antivirus: Avast (VPS 200330-0, 03/30/2020), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9577 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxlogscore=502 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003310156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9577 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 mlxlogscore=567 bulkscore=0
 suspectscore=0 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003310156
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


>> Does io_uring though have to deal with BLK_QC_T_NONE at all?  Or are you
>> saying that it should never receive that result?
>> That's one of the things I'm not clear about.
> BLK_QC_T_* are block cookies, they are only valid in the block layer.
> Only the poll handler called should have to deal with them, inside
> their f_op->iopoll() handler. It's simply passed from the queue to
> the poll side.
>
> So no, io_uring shouldn't have to deal with them at all.
>
> The problem, as I see it, is if the block layer returns BLK_QC_T_NONE
> and the IO was actually queued and requires polling to be found. We'd
> end up with IO timeouts for handling those requests, and that's not a
> good thing...

I see requests in io_do_iopoll() on poll_list with req->res == -EAGAIN, 
I think because the completion happened after an issued request was 
added to poll_list in io_iopoll_req_issued().

How should we deal with such a request, reissue unconditionally or 
something else?

--bijan
