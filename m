Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 166653ABF0D
	for <lists+io-uring@lfdr.de>; Fri, 18 Jun 2021 00:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbhFQWmF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Jun 2021 18:42:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60326 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231558AbhFQWmF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Jun 2021 18:42:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623969596;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=emxWcjkIG4L80S5gttO8GBQmev22i+AiArghauOxLZY=;
        b=gIyYlCqcw0d7BVpT77zfXZkmTdnNEkNIjXpMx96e6tN6HCvCwskhqg4PjZn2/oBIh3bQLi
        8ggt7T2yXLmHfXNoSG9zpMJA4lENHEvegFinUGiv6VGIkESM5HDJFLExFZ2Eis1kO4jBVV
        1zHEWr9wSly7/L35FP1RDhz8BakA2f0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-383-fNcSeow_P0-LqGG7H2l9dw-1; Thu, 17 Jun 2021 18:39:55 -0400
X-MC-Unique: fNcSeow_P0-LqGG7H2l9dw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 29447801B14;
        Thu, 17 Jun 2021 22:39:54 +0000 (UTC)
Received: from T590 (ovpn-12-22.pek2.redhat.com [10.72.12.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C841B1F6;
        Thu, 17 Jun 2021 22:39:48 +0000 (UTC)
Date:   Fri, 18 Jun 2021 06:39:43 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [Bug] fio hang when running multiple job io_uring/hipri over nvme
Message-ID: <YMvPL/WhRsFfMIfi@T590>
References: <CAFj5m9+ckHjfMVW_O20NBAPvnauPdABa8edPy--dSEf=XdhYRA@mail.gmail.com>
 <6691cf72-3a26-a1bb-228d-ddec8391620f@kernel.dk>
 <1b56a4f7-ce56-ee32-67d5-0fcd5dc6c0cb@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b56a4f7-ce56-ee32-67d5-0fcd5dc6c0cb@kernel.dk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jun 17, 2021 at 10:56:53AM -0600, Jens Axboe wrote:
> On 6/17/21 10:48 AM, Jens Axboe wrote:
> > On 6/17/21 5:17 AM, Ming Lei wrote:
> >> Hello,
> >>
> >> fio hangs when running the test[1], and doesn't observe this issue
> >> when running a
> >> such single job test.
> >>
> >> v5.12 is good, both v5.13-rc3 and the latest v5.13-rc6 are bad.
> >>
> >>
> >> [1] fio test script and log
> >> + fio --bs=4k --ioengine=io_uring --fixedbufs --registerfiles --hipri
> >> --iodepth=64 --iodepth_batch_submit=16
> >> --iodepth_batch_complete_min=16 --filename=/dev/nvme0n1 --direct=1
> >> --runtime=20 --numjobs=4 --rw=randread
> >> --name=test --group_reporting
> >>
> >> test: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T)
> >> 4096B-4096B, ioengine=io_uring, iodepth=64
> >> ...
> >> fio-3.25
> >> Starting 4 processes
> >> fio: filehash.c:64: __lookup_file_hash: Assertion `f->fd != -1' failed.
> >> fio: pid=1122, got signal=6
> >> ^Cbs: 3 (f=0): [f(1),r(1),K(1),r(1)][63.6%][eta 00m:20s]
> > 
> > Funky, would it be possible to bisect this? I'll see if I can reproduce.
> 
> Actually, this looks like a fio bug, that assert is a bit too trigger
> happy. Current -git should work, please test and see if things work.
> I believe it's just kernel timing that causes this, not a kernel issue.

Yeah, current -git does work, thanks the fix!

-- 
Ming

