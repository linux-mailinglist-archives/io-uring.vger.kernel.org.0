Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857601F7233
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2020 04:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbgFLCZy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Jun 2020 22:25:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46900 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbgFLCZy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Jun 2020 22:25:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05C2Ggpa061216;
        Fri, 12 Jun 2020 02:25:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=mpmhQrx1NiHB5OY/HvWkFt44G99mbKA3VLdXf98VAIU=;
 b=tVH4URx55J402DHLRp20NZqQ3V3Qoi7ubh2aOSJfHTBibcYd1MWK4tSnWR/3QDmvokFa
 2/0ig7u2rA9/2p2XOdJgKL7E8DZlpcPgAQxUGTu5FIgwdh1duOUD84OTVbsYrfHt2PPC
 qg3JlZWntvY4XhRlBKKoK5sJLFrIb/h8eg/AOvmiPPMNHzGT0iWIgaQLClpe0IljMZ1j
 pvsJwMc3PgOe2L398uGs4gCN2MOCa0YhOO2Bz74oWi/okVgpObVbRBhfnr6CEOKopPvo
 zQovnDvZUg9MBPQgGBG3kK0a5J223xxW/c1HrcTvvA8taXaT5PxCX6k20LXvBiOZI16N lw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31g3snaq5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 12 Jun 2020 02:25:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05C2Mquj146792;
        Fri, 12 Jun 2020 02:25:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 31m0vdg562-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jun 2020 02:25:51 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05C2NgF3009591;
        Fri, 12 Jun 2020 02:23:42 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 11 Jun 2020 19:23:42 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [RFC 0/2] io_uring: disallow overlapping ranges for buffer registration
Date:   Thu, 11 Jun 2020 19:23:35 -0700
Message-Id: <1591928617-19924-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9649 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxlogscore=761 mlxscore=0 adultscore=0 suspectscore=1 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006120017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9649 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 cotscore=-2147483648 suspectscore=1
 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 mlxlogscore=788 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006120016
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patch set has a couple of RFCs.

The first patch aims to disallow overlapping of user buffers for
registration.  For example, right now it is possible to register the same
identical buffer many times with the same system call which doesn't really
make sense.  I'm not sure if there is a valid use case for overlapping
buffers.  I think this check by itself might not be sufficient and more
restrictions may be needed but I figured to send this out for feedback and
check whether overlapping buffers should be allowed in the first place.

The second patch aims to separate reporting and enforcing of pinned
memory usage.  Reporting the usage seems like a good idea even if no
limit is enforced and ctx->account_mem is zero.

However, I'm clear on the proper setting and usage of
	user->locked_vm
	mm->locked_vm
	mm->pinned_vm

Looking at some other pin_user_page() callers, it seem mm->pinned_vm
should be used by I'm not sure.

Bijan Mottahedeh (2):
  io_uring: disallow overlapping ranges for buffer registration
  io_uring: report pinned memory usage

 fs/io_uring.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

-- 
1.8.3.1

