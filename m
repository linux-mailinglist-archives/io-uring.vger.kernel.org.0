Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E215281ABE
	for <lists+io-uring@lfdr.de>; Fri,  2 Oct 2020 20:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387692AbgJBSUi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Oct 2020 14:20:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31287 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726215AbgJBSUh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Oct 2020 14:20:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601662836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lqqL3jwW0Qxyljotmq4NPWT4XpzpY6tFGrdJ6FJR2t4=;
        b=dMlSRi+LJzbKdyP9hMsuvtzg9R6vuSX/UtTsBK0mwOxNhWrcCiwIAWJP1e8DJTCrwXEv/1
        cbdLraIEGWOrMrtsllFUslvjIAG4+bqMwaP4KDvIM+EZwtzqo6JGMs5m9tBjOl0P/sQ8AS
        SNTArvIGqmC3f/ENb6j7EBSwO5JBb+o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-565-U-JaIaSIMKi43Vr2Vudc8Q-1; Fri, 02 Oct 2020 14:20:34 -0400
X-MC-Unique: U-JaIaSIMKi43Vr2Vudc8Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B12C3801ADA;
        Fri,  2 Oct 2020 18:20:33 +0000 (UTC)
Received: from bfoster (ovpn-114-177.rdu2.redhat.com [10.10.114.177])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DEFA55784;
        Fri,  2 Oct 2020 18:20:33 +0000 (UTC)
Date:   Fri, 2 Oct 2020 14:20:31 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 3/3] generic: IO_URING direct IO fsx test
Message-ID: <20201002182031.GE4708@bfoster>
References: <20200916171443.29546-1-zlang@redhat.com>
 <20200916171443.29546-4-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916171443.29546-4-zlang@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Sep 17, 2020 at 01:14:43AM +0800, Zorro Lang wrote:
> After fsx supports IO_URING read/write, add IO_URING direct IO fsx
> test with different read/write size and concurrent buffered IO.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
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

The copyright needs fixing.

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

Can you elaborate on why PSIZE/BSIZE are used where they are for the
writebdy option? Also is -R intentionally dropped from the final test?

Brian

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

