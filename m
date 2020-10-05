Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2E6283CB5
	for <lists+io-uring@lfdr.de>; Mon,  5 Oct 2020 18:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgJEQpN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Oct 2020 12:45:13 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:42272 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726659AbgJEQpM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Oct 2020 12:45:12 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095Ge8qN154387;
        Mon, 5 Oct 2020 16:45:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=hLjK2hMGMtYoln2Xf+r7ll0kB2WsYowLHYRxYE4dHXQ=;
 b=kUFNpOQ9xlQcalJ8TAxaVhLXK12X4R/w6CD/1RUpdTRrN0SnBVNyAkjVMmwty41Vfd+g
 LYYTyUgk8OlrxCfZVv4LX6XbbrWTFNuC/OSn7IoxYGS/00RFyZy4Vssj8E697rIw2GJK
 VdoOngB/w62+yqFzLK8dBHDgr+NnqDdxLCV165ScQhRh/rTWWkqDmNr9Qb4Aq8sqwRdv
 2DCoFUm60VMoR3nTCp5qaKjnhgbbmi4sBKX2mBC6seMSNwfLogdo2gupUQtXlIZvHP1+
 VFKApHQDgh27v9+04IYjwgPUxgexhrdnuRkXxaIJkgtyZktJaicIS3G4ggNap+O2F+7M Jg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 33xetaprxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 05 Oct 2020 16:45:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095GfCXM196370;
        Mon, 5 Oct 2020 16:45:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33y2vkr8tc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Oct 2020 16:45:10 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 095Gj9Z2014586;
        Mon, 5 Oct 2020 16:45:09 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 05 Oct 2020 09:45:09 -0700
Date:   Mon, 5 Oct 2020 09:45:10 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 3/3] generic: IO_URING direct IO fsx test
Message-ID: <20201005164510.GG49541@magnolia>
References: <20200916171443.29546-1-zlang@redhat.com>
 <20200916171443.29546-4-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916171443.29546-4-zlang@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=1 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010050122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1011 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=1 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010050122
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Sep 17, 2020 at 01:14:43AM +0800, Zorro Lang wrote:
> After fsx supports IO_URING read/write, add IO_URING direct IO fsx
> test with different read/write size and concurrent buffered IO.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>

Funny, I would have expected this to be a clone of generic/521, much
like the previous test was a clone of g/522.  I guess it's fine to test
various fsx parameters, but in that case, is there a reason /not/ to
have a long soak io_uring directio test?

--D

> ---
>  tests/generic/610     | 52 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/610.out |  7 ++++++
>  tests/generic/group   |  1 +
>  3 files changed, 60 insertions(+)
>  create mode 100755 tests/generic/610
>  create mode 100644 tests/generic/610.out
> 
> diff --git a/tests/generic/610 b/tests/generic/610
> new file mode 100755
> index 00000000..fc3f4c2a
> --- /dev/null
> +++ b/tests/generic/610
> @@ -0,0 +1,52 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 YOUR NAME HERE.  All Rights Reserved.
> +#
> +# FS QA Test 610
> +#
> +# IO_URING direct IO fsx test
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux
> +_require_test
> +_require_odirect
> +_require_io_uring
> +
> +psize=`$here/src/feature -s`
> +bsize=`_min_dio_alignment $TEST_DEV`
> +run_fsx -S 0 -U -N 20000           -l 600000 -r PSIZE -w BSIZE -Z -R -W
> +run_fsx -S 0 -U -N 20000 -o 8192   -l 600000 -r PSIZE -w BSIZE -Z -R -W
> +run_fsx -S 0 -U -N 20000 -o 128000 -l 600000 -r PSIZE -w BSIZE -Z -R -W
> +
> +# change readbdy/writebdy to double page size
> +psize=$((psize * 2))
> +run_fsx -S 0 -U -N 20000           -l 600000 -r PSIZE -w PSIZE -Z -R -W
> +run_fsx -S 0 -U -N 20000 -o 256000 -l 600000 -r PSIZE -w PSIZE -Z -R -W
> +run_fsx -S 0 -U -N 20000 -o 128000 -l 600000 -r PSIZE -w BSIZE -Z -W
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/610.out b/tests/generic/610.out
> new file mode 100644
> index 00000000..97ad41a3
> --- /dev/null
> +++ b/tests/generic/610.out
> @@ -0,0 +1,7 @@
> +QA output created by 610
> +fsx -S 0 -U -N 20000 -l 600000 -r PSIZE -w BSIZE -Z -R -W
> +fsx -S 0 -U -N 20000 -o 8192 -l 600000 -r PSIZE -w BSIZE -Z -R -W
> +fsx -S 0 -U -N 20000 -o 128000 -l 600000 -r PSIZE -w BSIZE -Z -R -W
> +fsx -S 0 -U -N 20000 -l 600000 -r PSIZE -w PSIZE -Z -R -W
> +fsx -S 0 -U -N 20000 -o 256000 -l 600000 -r PSIZE -w PSIZE -Z -R -W
> +fsx -S 0 -U -N 20000 -o 128000 -l 600000 -r PSIZE -w BSIZE -Z -W
> diff --git a/tests/generic/group b/tests/generic/group
> index cf50f4a1..60280dc2 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -612,3 +612,4 @@
>  607 auto attr quick dax
>  608 auto attr quick dax
>  609 auto rw io_uring
> +610 auto rw io_uring
> -- 
> 2.20.1
> 
