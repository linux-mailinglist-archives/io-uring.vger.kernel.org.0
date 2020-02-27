Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5FD1713F8
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2020 10:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbgB0JTi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Feb 2020 04:19:38 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:38092 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728504AbgB0JTh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Feb 2020 04:19:37 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01R9F6Hl091510;
        Thu, 27 Feb 2020 09:19:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=d4b3D5DmveOIQH3fWRGTZrbAVm/isi1FEEnnWao0g3Q=;
 b=Mzto7rMY0tpW51J82egbXBwUzv80GMbUmMq+I+MPuPuT06flkQU7cEnFXvakSmEOPQUl
 2FE94qyM26vHcglBUprf18NvBk/Yqtc+jBEYR6Rd7ia1J51MSHY/Sislq0/PGJo3lx4u
 UqwHhW83khyME/iq3oWXHJG8Sezjlp511+qV5P3816W8+mLB4QcjTt/Dnju2yMBRbt7B
 jglV0+YI5znbvlkZCNqgYphv+lTKb2ngvIAlJCyC4B9AS5daMsyRtEIaPSdyHdb2OAvo
 ImVUxGwzN9RyYtObMVp8Tb/df+wI5FJdsIFDOUan4sMjejc/lW+H3MWhMG+q2HPvf/Nj Mw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2ydct39hds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 09:19:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01R9EJiw172581;
        Thu, 27 Feb 2020 09:19:28 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2ydcs4mxj6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 09:19:28 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01R9JRun026400;
        Thu, 27 Feb 2020 09:19:27 GMT
Received: from [192.168.1.14] (/114.88.246.185)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Feb 2020 01:19:27 -0800
Subject: Re: [PATCH 1/4] io_uring: add IORING_OP_READ{WRITE}V_PI cmd
To:     Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, martin.petersen@oracle.com,
        linux-fsdevel@vger.kernel.org, darrick.wong@oracle.com,
        io-uring@vger.kernel.org
References: <20200226083719.4389-1-bob.liu@oracle.com>
 <20200226083719.4389-2-bob.liu@oracle.com>
 <6e466774-4dc5-861c-58b5-f0cc728bacff@kernel.dk>
 <20200226155728.GA32543@infradead.org>
 <af282e53-7dff-2df3-0d03-62e1bcdb0005@kernel.dk>
 <20200226165309.GA3995@infradead.org>
From:   Bob Liu <bob.liu@oracle.com>
Message-ID: <c3a98504-947b-1235-c9d6-c9f1ccbaba6f@oracle.com>
Date:   Thu, 27 Feb 2020 17:19:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20200226165309.GA3995@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=923 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270075
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=963 mlxscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270075
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/27/20 12:53 AM, Christoph Hellwig wrote:
> On Wed, Feb 26, 2020 at 08:58:46AM -0700, Jens Axboe wrote:
>> Yeah, should probably be a RWF_ flag instead, and a 64-bit SQE field
>> for the PI data. The 'last iovec is PI' is kind of icky.
> 
> Abusing an iovec (although I though of the first once when looking
> into it) looks really horrible, but has two huge advantages:
> 
>  - it doesn't require passing another argument all the way down
>    the I/O stack
>  - it works with all the vectored interfaces that take a flag
>    argument, so not just io_uring, but also preadv2/pwritev2 and aio.
>    And while I don't care too much about the last I think preadv2
>    and pwritev2 are valuable to support.
> 

Indeed, actually the 'last iovec is PI' idea was learned from Darrick's original
patch which support PI passthrough via aio.
https://www.mail-archive.com/linux-scsi@vger.kernel.org/msg27537.html

