Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF8E1703B5
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2020 17:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbgBZQDw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Feb 2020 11:03:52 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:52522 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbgBZQDw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Feb 2020 11:03:52 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01QFwrJV108899;
        Wed, 26 Feb 2020 16:03:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=bTPrEyhpcOfSfNaVqhFzEM0q5hQYCKk2Uy1e7bJvNZo=;
 b=yYSCZzDopW9h4SWhjpFDw1lly4EbPEcpn0N8Rd3alwYjsau/cYgC1uJsRLIKamDimDTi
 1JaNQA/3XuZ5ohKf135zbVY5NcgVA84f6WzYYpXZOZhdtnfymKPAY3HgAgb9bDC0s4oV
 6J2aQydezyZbFmSQBHknbWDKV36vKV1Wg5pFW/N87qmjslVaPaUBV/XzJz11xVPhuMQ8
 fUuTfnfVqSrmIgXvi7Ig0/EmH34I9c5wieXYZbb3K4gctjphQzv9DOI0S/UrOA3ymFmF
 P6mQ1vIE6k5sFkPDVaYe2AyvrUcls56OTt7EuVHL2TsJZU7xnh0aReJxP71+4PNMEZP8 8w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2ydct34ks9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 16:03:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01QFwOE1015124;
        Wed, 26 Feb 2020 16:03:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2ydcs2esbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 16:03:44 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01QG3hK7018233;
        Wed, 26 Feb 2020 16:03:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Feb 2020 08:03:43 -0800
Date:   Wed, 26 Feb 2020 08:03:42 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Bob Liu <bob.liu@oracle.com>, linux-block@vger.kernel.org,
        martin.petersen@oracle.com, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org
Subject: Re: [PATCH 1/4] io_uring: add IORING_OP_READ{WRITE}V_PI cmd
Message-ID: <20200226160342.GB8044@magnolia>
References: <20200226083719.4389-1-bob.liu@oracle.com>
 <20200226083719.4389-2-bob.liu@oracle.com>
 <6e466774-4dc5-861c-58b5-f0cc728bacff@kernel.dk>
 <20200226155728.GA32543@infradead.org>
 <af282e53-7dff-2df3-0d03-62e1bcdb0005@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af282e53-7dff-2df3-0d03-62e1bcdb0005@kernel.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260111
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Feb 26, 2020 at 08:58:46AM -0700, Jens Axboe wrote:
> On 2/26/20 8:57 AM, Christoph Hellwig wrote:
> > On Wed, Feb 26, 2020 at 07:24:06AM -0700, Jens Axboe wrote:
> >> On 2/26/20 1:37 AM, Bob Liu wrote:
> >>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> >>> index a3300e1..98fa3f1 100644
> >>> --- a/include/uapi/linux/io_uring.h
> >>> +++ b/include/uapi/linux/io_uring.h
> >>> @@ -62,6 +62,8 @@ enum {
> >>>  	IORING_OP_NOP,
> >>>  	IORING_OP_READV,
> >>>  	IORING_OP_WRITEV,
> >>> +	IORING_OP_READV_PI,
> >>> +	IORING_OP_WRITEV_PI,
> >>>  	IORING_OP_FSYNC,
> >>>  	IORING_OP_READ_FIXED,
> >>>  	IORING_OP_WRITE_FIXED,
> >>
> >> So this one renumbers everything past IORING_OP_WRITEV, breaking the
> >> ABI in a very bad way. I'm guessing that was entirely unintentional?
> >> Any new command must go at the end of the list.
> >>
> >> You're also not updating io_op_defs[] with the two new commands,
> >> which means it won't compile at all. I'm guessing you tested this on
> >> an older version of the kernel which didn't have io_op_defs[]?
> > 
> > And the real question is why we need ops insted of just a flag and
> > using previously reserved fields for the PI pointer.
> 
> Yeah, should probably be a RWF_ flag instead, and a 64-bit SQE field
> for the PI data. The 'last iovec is PI' is kind of icky.

Heh, I was about to send in nearly the same comment. :)

--D

> -- 
> Jens Axboe
> 
