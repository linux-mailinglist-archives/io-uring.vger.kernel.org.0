Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0AC281ABD
	for <lists+io-uring@lfdr.de>; Fri,  2 Oct 2020 20:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733260AbgJBSUb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Oct 2020 14:20:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47759 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726215AbgJBSUb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Oct 2020 14:20:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601662830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xLfzykIEHRegJd/pcuWhEZ+Ei2zRQfNKi+JBh0AA0CI=;
        b=UOXI+NLI1P8Uj+J5skMhAtuZV4R3d3DQGMMfgfZBpCEymAQLTh7KTn9WtjFACBIGp3LIs+
        EoDQmZLE56+918KAjfDJyt9DcbttcpUAqTvg5LFhgjQMv5jUvTLcuHXynrQ0zednkPzhsV
        CRJB08vP482YF+Gf2toV3jOMLymNcwk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-jxVmJsxjPHacqgeGOHWrsw-1; Fri, 02 Oct 2020 14:20:25 -0400
X-MC-Unique: jxVmJsxjPHacqgeGOHWrsw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49A7C839A48;
        Fri,  2 Oct 2020 18:20:24 +0000 (UTC)
Received: from bfoster (ovpn-114-177.rdu2.redhat.com [10.10.114.177])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D869C5D9D3;
        Fri,  2 Oct 2020 18:20:23 +0000 (UTC)
Date:   Fri, 2 Oct 2020 14:20:22 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 2/3] generic: fsx IO_URING soak tests
Message-ID: <20201002182022.GD4708@bfoster>
References: <20200916171443.29546-1-zlang@redhat.com>
 <20200916171443.29546-3-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916171443.29546-3-zlang@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Sep 17, 2020 at 01:14:42AM +0800, Zorro Lang wrote:
> After fsx supports IO_URING read/write, add a test to do IO_URING
> soak test of fsx.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
>  common/rc             | 16 ++++++++++++
>  tests/generic/609     | 58 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/609.out |  2 ++
>  tests/generic/group   |  1 +
>  4 files changed, 77 insertions(+)
>  create mode 100755 tests/generic/609
>  create mode 100644 tests/generic/609.out
> 
...
> diff --git a/tests/generic/609 b/tests/generic/609
> new file mode 100755
> index 00000000..1d9b6fed
> --- /dev/null
> +++ b/tests/generic/609
> @@ -0,0 +1,58 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Red Hat Inc.  All Rights Reserved.
> +#
> +# FS QA Test 609
> +#
> +# IO_URING soak buffered fsx test
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
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_supported_os Linux
> +_require_test
> +_require_io_uring
> +
> +# Run fsx for a million ops or more
> +nr_ops=$((100000 * TIME_FACTOR))

The value used here doesn't match the comment. Though it looks like this
is modeled after generic/512, which does specify 1m ops, but also isn't
included in the auto group presumably due to the time required to run
the test.

Brian

> +op_sz=$((128000 * LOAD_FACTOR))
> +file_sz=$((600000 * LOAD_FACTOR))
> +fsx_file=$TEST_DIR/fsx.$seq
> +
> +fsx_args=(-S 0)
> +fsx_args+=(-U)
> +fsx_args+=(-q)
> +fsx_args+=(-N $nr_ops)
> +fsx_args+=(-p $((nr_ops / 100)))
> +fsx_args+=(-o $op_sz)
> +fsx_args+=(-l $file_sz)
> +
> +run_fsx "${fsx_args[@]}" | sed -e '/^fsx.*/d'
> +
> +# success, all done
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/generic/609.out b/tests/generic/609.out
> new file mode 100644
> index 00000000..0d75b384
> --- /dev/null
> +++ b/tests/generic/609.out
> @@ -0,0 +1,2 @@
> +QA output created by 609
> +Silence is golden
> diff --git a/tests/generic/group b/tests/generic/group
> index aa969bcb..cf50f4a1 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -611,3 +611,4 @@
>  606 auto attr quick dax
>  607 auto attr quick dax
>  608 auto attr quick dax
> +609 auto rw io_uring
> -- 
> 2.20.1
> 

