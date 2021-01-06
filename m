Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25A432EBFED
	for <lists+io-uring@lfdr.de>; Wed,  6 Jan 2021 15:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbhAFO6u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Jan 2021 09:58:50 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:50432 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbhAFO6u (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Jan 2021 09:58:50 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106Ew3uq095751;
        Wed, 6 Jan 2021 14:58:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=GcACcs5EFh1ti406bdHdMFj0TpEouxSixSDHJN7UaXk=;
 b=JkTriWJdvKqppf3MWj5GekFgHkoelK6KAYQcrG3aPcrENY0/Ber3GWCNxfIx3tqKYTdz
 gPEArE8PcEB67kBM6qMFt0YNAhpvPHnSEBgbefrjfpZk1nwvsBGThvUL2VfZ63G7FYPI
 j+zQ8iceYWlLbzNkd14TaPLk+I7t2V7lQZLJTB3aS9IeAjS0bx0KRsYlSZGETTOf5B4c
 aYIzSt7Xb7ZlvOHSrqhdLSpxCPXXtVsQPB48rrsDQM4Ktenq1+sPKBZPX/zqrlaqBfRO
 UUF89Rip8r/Vvk+55RpzZitq7tAX7O0D0HbzaRpp2blQrSIeDlHbj2cug7oJW/FIZWPJ /w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 35wcuxrkgh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 06 Jan 2021 14:58:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106EuSa6181217;
        Wed, 6 Jan 2021 14:56:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 35v4rcrvg5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jan 2021 14:56:29 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 106EuIFg020625;
        Wed, 6 Jan 2021 14:56:18 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Jan 2021 06:56:17 -0800
Date:   Wed, 6 Jan 2021 17:56:10 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] io_uring: fix an IS_ERR() vs NULL check
Message-ID: <20210106145610.GC2831@kadam>
References: <X/WCTxIRT4SHLemV@mwanda>
 <c88d8500-681d-7503-77ca-ae10d230a11b@gmail.com>
 <20210106143401.GD175893@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106143401.GD175893@casper.infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060094
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101060094
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens just applied my patch right before you sent this.  I don't have
strong feeling either way about this.  I guess I sort of agree with
you.  If Jens can drop my patch then it should be pretty trivial for
you to add a commit message to your patch and give me a Reported-by
tag?

regards,
dan carpenter

