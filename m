Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F462176888
	for <lists+io-uring@lfdr.de>; Tue,  3 Mar 2020 00:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgCBXzw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Mar 2020 18:55:52 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:56394 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbgCBXzw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Mar 2020 18:55:52 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 022Nqweu180262;
        Mon, 2 Mar 2020 23:55:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=x12n1YU+YeODw4y58TaGfFaeAOyuG1M71NnAG1rqrg4=;
 b=kMNUXwf6H96fEuW06nLZWuqRWEXhjrTUhj/jHyHTClaXLSmUXb4X1gtBO3pAvx2QVspR
 qpIg6N74YKxH5MTQcAmcXUlJrgrS6rS9iTID8rBHvraCq4hdJKASeaKxmQKanh+aaMUz
 C/MEoILhOXrmNpDEpqxWvVX212ikzFhTodqZU/vhzyRrT+W7sSdHfIYdfKPzKB/lcRtc
 T7Bkil+pEEelYWrxaKQUd9gwcUOZTKspnJp3995yH0TkJ+WvRHW1lmVkKZ/VLix7Ak43
 O+DY46nT8k7zP8Cwlt1Kjpt63gGeKsi0NX9ApHolGAueEAGY2eTMbnsZOHuFXYnD3Jf/ Hg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2yghn2y20y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Mar 2020 23:55:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 022NqxHm120809;
        Mon, 2 Mar 2020 23:55:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2yg1ej5gtb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Mar 2020 23:55:49 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 022NtmSj015354;
        Mon, 2 Mar 2020 23:55:48 GMT
Received: from [10.154.114.32] (/10.154.114.32)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Mar 2020 15:55:48 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: io_uring performance with block sizes > 128k
Message-ID: <53e29125-025c-2fc1-f9b3-fccdea3060e6@oracle.com>
Date:   Mon, 2 Mar 2020 15:55:46 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Antivirus: Avast (VPS 200301-0, 03/01/2020), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9548 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003020156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9548 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 spamscore=0
 impostorscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003020156
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I'm seeing a sizeable drop in perf with polled fio tests for block sizes 
 > 128k:

filename=/dev/nvme0n1
rw=randread
direct=1
time_based=1
randrepeat=1
gtod_reduce=1

fio --readonly --ioengine=io_uring --iodepth 1024 --fixedbufs --hipri 
--numjobs=16
fio --readonly --ioengine=pvsync2 --iodepth 1024 --hipri --numjobs=16


Compared with the pvsync2 engine, the only major difference I could see 
was the dio path, __blkdev_direct_IO() for io_uring vs. 
__blkdev_direct_IO_simple() for pvsync2 because of the is_sync_kiocb() 
check.


static ssize_t
blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
{
         ...
         if (is_sync_kiocb(iocb) && nr_pages <= BIO_MAX_PAGES)
                 return __blkdev_direct_IO_simple(iocb, iter, nr_pages);

         return __blkdev_direct_IO(iocb, iter, min(nr_pages, 
BIO_MAX_PAGES));
}

Just for an experiment, I hacked io_uring code to force it through the 
_simple() path and I get better numbers though the variance is fairly 
high, but the drop at bs > 128k seems consistent:


# baseline
READ: bw=3167MiB/s (3321MB/s), 186MiB/s-208MiB/s (196MB/s-219MB/s)   #128k
READ: bw=898MiB/s (941MB/s), 51.2MiB/s-66.1MiB/s (53.7MB/s-69.3MB/s) #144k
READ: bw=1576MiB/s (1652MB/s), 81.8MiB/s-109MiB/s (85.8MB/s-114MB/s) #256k

# hack
READ: bw=2705MiB/s (2836MB/s), 157MiB/s-174MiB/s (165MB/s-183MB/s) #128k
READ: bw=2901MiB/s (3042MB/s), 174MiB/s-194MiB/s (183MB/s-204MB/s) #144k
READ: bw=4194MiB/s (4398MB/s), 252MiB/s-271MiB/s (265MB/s-284MB/s) #256k


--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1972,12 +1972,12 @@ static int io_prep_rw(struct io_kiocb *req, 
const struct
                         return -EOPNOTSUPP;

                 kiocb->ki_flags |= IOCB_HIPRI;
-               kiocb->ki_complete = io_complete_rw_iopoll;
+               kiocb->ki_complete = NULL;
                 req->result = 0;
         } else {
                 if (kiocb->ki_flags & IOCB_HIPRI)
                         return -EINVAL;
-               kiocb->ki_complete = io_complete_rw;
+               kiocb->ki_complete = NULL;
         }

         req->rw.addr = READ_ONCE(sqe->addr);
@@ -2005,7 +2005,12 @@ static inline void io_rw_done(struct kiocb 
*kiocb, ssize_
                 ret = -EINTR;
                 /* fall through */
         default:
-               kiocb->ki_complete(kiocb, ret, 0);
+               if (kiocb->ki_complete)
+                       kiocb->ki_complete(kiocb, ret, 0);
+               else if (kiocb->ki_flags & IOCB_HIPRI)
+                       io_complete_rw_iopoll(kiocb, ret, 0);
+               else
+                       io_complete_rw(kiocb, ret, 0);
         }
  }


With the baseline version, perf top shows a significant amount of time 
for lock contention.  I *think* it is nvmeq->sq_lock.

Does that make sense?  I do realize the hack defeats the io_uring 
purpose but I though it might provide some clues as to what is going 
on.  Let me know if there is something else I can try.

Thanks.

--bijan


