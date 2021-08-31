Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2ABF3FC50E
	for <lists+io-uring@lfdr.de>; Tue, 31 Aug 2021 11:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233195AbhHaJlV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Aug 2021 05:41:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26364 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233098AbhHaJlU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Aug 2021 05:41:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630402825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JlYe75219M3Zyilg7LUCycvzbCPGGXDQXClfWpFWVZo=;
        b=eC5afelMuSZ6QcNMU6KBQvuTIoWUchjVNBGQmIGLZWzxMifqmAa7CnPRWaXOx/xRAwKA+H
        i/RA4zbvjjcPIixj6+7k5mqOjaeCXr9z4hE/mxeCQMcll+g5TSA0WzuRg6io+y5X2FlqgP
        RTBq4h4YlUv7NI6oESJtIuTJL7++wAQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-46-fdsAdo7rNZyiV9AuLcvxyw-1; Tue, 31 Aug 2021 05:40:21 -0400
X-MC-Unique: fdsAdo7rNZyiV9AuLcvxyw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 217F51853024;
        Tue, 31 Aug 2021 09:40:20 +0000 (UTC)
Received: from T590 (ovpn-8-22.pek2.redhat.com [10.72.8.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 97C1427CA8;
        Tue, 31 Aug 2021 09:39:58 +0000 (UTC)
Date:   Tue, 31 Aug 2021 17:39:53 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH] io_uring: retry in case of short read on block device
Message-ID: <YS346UEo3IojG9aF@T590>
References: <20210821150751.1290434-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210821150751.1290434-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Aug 21, 2021 at 11:07:51PM +0800, Ming Lei wrote:
> In case of buffered reading from block device, when short read happens,
> we should retry to read more, otherwise the IO will be completed
> partially, for example, the following fio expects to read 2MB, but it
> can only read 1M or less bytes:
> 
>     fio --name=onessd --filename=/dev/nvme0n1 --filesize=2M \
> 	--rw=randread --bs=2M --direct=0 --overwrite=0 --numjobs=1 \
> 	--iodepth=1 --time_based=0 --runtime=2 --ioengine=io_uring \
> 	--registerfiles --fixedbufs --gtod_reduce=1 --group_reporting
> 
> Fix the issue by allowing short read retry for block device, which sets
> FMODE_BUF_RASYNC really.
> 
> Fixes: 9a173346bd9e ("io_uring: fix short read retries for non-reg files")
> Cc: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>

Hello Jens and Pavel,

Any comments on this fix?


Thanks, 
Ming

