Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC9C1DA421
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2020 23:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbgESVxA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 May 2020 17:53:00 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37144 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgESVxA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 May 2020 17:53:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04JLpjQZ041350;
        Tue, 19 May 2020 21:52:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=hkrknn39MwCUC0H8zlN1H59M61+1bHG0Sr5s2jj3qOI=;
 b=WaelewXI0leTzmgesFlrO3w61KJ5mOWWboQ/FS6s34M0QcqeWgozMoKziUUxXeLy0H6X
 ZPfQbJGa4wwzhD2vtfSE6w+Du4Bz9I3NVEorpKKR1707CxRE4Q1Iqkgs78cc01k5YO2/
 XXgSPeHA4N/ktrtLPNsr8Bfw8pUA6cyZqZG5RZci8cdC9Vq9ONzCSgSTSnV6zj91iS4g
 Cb8vR6ef4mfxUEcvFOBsfqcOqL6Np+lpCeXJcRPEza/st7kcvKuoQR5gHmSYaG+YgsP0
 YZhttUCn9G8++xT54+Q4/OuO1UdzSOdxOLRbb/dLh1HaYfImbXQYZpXNckHpCXpw5r3E SA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31284m00cx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 May 2020 21:52:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04JLqPMd020035;
        Tue, 19 May 2020 21:52:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 314gm5vp2s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 May 2020 21:52:57 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04JLqurs005844;
        Tue, 19 May 2020 21:52:56 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 14:52:56 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [RFC 0/2] io_uring: don't use kiocb.private to store buf_index
Date:   Tue, 19 May 2020 14:52:48 -0700
Message-Id: <1589925170-48687-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=1
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190184
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005190184
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patch set addresses problems hit when running liburing
500f9fbadef8-test.

- Patch 1 is a suggested fix to overloading of kiocb.private since it
can be written by iomap_dio_rw().

io_import_iovec() can fail a submission as follows:

	/* buffer index only valid with fixed read/write, or buffer select  */
	if (req->rw.kiocb.private && !(req->flags & REQ_F_BUFFER_SELECT))
		return -EINVAL;

so a read request fails with -EINVAL upon retry if iomap_dio_rw() has
written to iocb->private:

       WRITE_ONCE(iocb->private, dio->submit.last_queue);

The suggested fix is use a separate variable to store buf_index.

- Patch 2 reverts c58c1f8343 which had changed the error for
REQ_NOWAIT requests to non-mq queue from -ENOTSUP to -EAGAIN.

	/*
	 * Non-mq queues do not honor REQ_NOWAIT, so complete a bio
	 * with BLK_STS_AGAIN status in order to catch -EAGAIN and
	 * to give a chance to the caller to repeat request gracefully.
	 */
	if ((bio->bi_opf & REQ_NOWAIT) && !queue_is_mq(q)) {
		status = BLK_STS_AGAIN;
		goto end_io;
	}

I'm not clear what the original reasoning was but io_wq_submit_work()
will call io_issue_sqe() continuously as long as -EAGAIN is returned.
I'm not sure if this could break something else.

I ran fio as specified in c58c1f8343 with this change and don't see any errors.

Bijan Mottahedeh (2):
  io_uring: don't use kiocb.private to store buf_index
  io_uring: mark REQ_NOWAIT for a non-mq queue as unspported

 block/blk-core.c | 10 +++-------
 fs/io_uring.c    | 15 +++++++--------
 2 files changed, 10 insertions(+), 15 deletions(-)

-- 
1.8.3.1

