Return-Path: <io-uring+bounces-7077-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 851F5A5FBEC
	for <lists+io-uring@lfdr.de>; Thu, 13 Mar 2025 17:37:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 580421887FF8
	for <lists+io-uring@lfdr.de>; Thu, 13 Mar 2025 16:37:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0B052676FD;
	Thu, 13 Mar 2025 16:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ha4zscPH"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4AD1487D1
	for <io-uring@vger.kernel.org>; Thu, 13 Mar 2025 16:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741883828; cv=none; b=jg/RK/7+hW9o1/s3dLL1qaIv+PdwHjQIdKoXxBdtie+dP5SsFoZsm2s3L+cFzUNrZKoJZyv097oYDDkLvHvUkrQ9etOHOniHoifB78cOEQLgkDJiQ2tkK+ErJE9e/pKQM1w79sVWxaHiMwKsrdlWimtnoX2N2FCYeGt5QzMcA/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741883828; c=relaxed/simple;
	bh=H6qhc40XwMTUNTQh23ECN9sTs54dQPRbwVzPji3aicg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=bJTcd7NFZO0N+rJHj3OoDKy2Mc/Ir6UK07JYP97IZOkFhA0ic+UI7xEr/VztFDLCjW+rQJIA5tuRTmmX3RA3byuhqwxvVdCYaGBEesAmL9Ng3D2z0rR5/eOhGwCLeH35dwSfyy0TrzufLNcuagJaFWdriYSTU9m1//cSX71i6xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ha4zscPH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741883826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nteGkwPas523gY7jS4Tf+BW9z14N+lQLPYEP7Fix3sA=;
	b=Ha4zscPHuqGOtxdDk8FRuVcsUbaPt6wNW1O0mO5twsPSQmngHqcByqTlUDR0YnYDYWbc2V
	fozDpIZ7HmuiSI0CBiTE9hXxN4HFd2UPENNMfE/IFK50P3SQBegKnLaI1kFj+EysFo7hf0
	yiHuab4nhPSFdvHg3yH9qNkkTDimtgU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-223--VLMEIm8OcWI3lihAJX-HQ-1; Thu,
 13 Mar 2025 12:37:03 -0400
X-MC-Unique: -VLMEIm8OcWI3lihAJX-HQ-1
X-Mimecast-MFC-AGG-ID: -VLMEIm8OcWI3lihAJX-HQ_1741883821
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1170418007E1;
	Thu, 13 Mar 2025 16:37:01 +0000 (UTC)
Received: from [10.22.82.75] (unknown [10.22.82.75])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A01561800944;
	Thu, 13 Mar 2025 16:36:56 +0000 (UTC)
Date: Thu, 13 Mar 2025 17:36:53 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Ming Lei <ming.lei@redhat.com>
cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, 
    Jens Axboe <axboe@kernel.dk>, Jooyung Han <jooyung@google.com>, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Heinz Mauelshagen <heinzm@redhat.com>, zkabelac@redhat.com, 
    dm-devel@lists.linux.dev, linux-block@vger.kernel.org, 
    linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH] the dm-loop target
In-Reply-To: <Z9FFTiuMC8WD6qMH@fedora>
Message-ID: <7b8b8a24-f36b-d213-cca1-d8857b6aca02@redhat.com>
References: <8adb8df2-0c75-592d-bc3e-5609bb8de8d8@redhat.com> <Z8Zh5T9ZtPOQlDzX@dread.disaster.area> <1fde6ab6-bfba-3dc4-d7fb-67074036deb0@redhat.com> <Z8eURG4AMbhornMf@dread.disaster.area> <81b037c8-8fea-2d4c-0baf-d9aa18835063@redhat.com> <Z8zbYOkwSaOJKD1z@fedora>
 <a8e5c76a-231f-07d1-a394-847de930f638@redhat.com> <Z8-ReyFRoTN4G7UU@dread.disaster.area> <Z9ATyhq6PzOh7onx@fedora> <Z9DymjGRW3mTPJTt@dread.disaster.area> <Z9FFTiuMC8WD6qMH@fedora>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111



On Wed, 12 Mar 2025, Ming Lei wrote:

> > > It isn't perfect, sometime it may be slower than running on io-wq
> > > directly.
> > > 
> > > But is there any better way for covering everything?
> > 
> > Yes - fix the loop queue workers.
> 
> What you suggested is threaded aio by submitting IO concurrently from
> different task context, this way is not the most efficient one, otherwise
> modern language won't invent async/.await.
> 
> In my test VM, by running Mikulas's fio script on loop/nvme by the attached
> threaded_aio patch:
> 
> NOWAIT with MQ 4		:   70K iops(read), 70K iops(write), cpu util: 40%
> threaded_aio with MQ 4	:	64k iops(read), 64K iops(write), cpu util: 52% 
> in tree loop(SQ)		:   58K	iops(read), 58K iops(write)	
> 
> Mikulas, please feel free to run your tests with threaded_aio:
> 
> 	modprobe loop nr_hw_queues=4 threaded_aio=1
> 
> by applying the attached the patch over the loop patchset.
> 
> The performance gap could be more obvious in fast hardware.

With "threaded_aio=1":

Sync io
fio --direct=1 --bs=4k --runtime=10 --time_based --numjobs=12 --ioengine=psync --iodepth=1 --group_reporting=1 --filename=/mnt/test2/l -name=job --rw=rw
xfs/loop/xfs
   READ: bw=300MiB/s (315MB/s), 300MiB/s-300MiB/s (315MB/s-315MB/s), io=3001MiB (3147MB), run=10001-10001msec
  WRITE: bw=300MiB/s (315MB/s), 300MiB/s-300MiB/s (315MB/s-315MB/s), io=3004MiB (3149MB), run=10001-10001msec

Async io
fio --direct=1 --bs=4k --runtime=10 --time_based --numjobs=12 --ioengine=libaio --iodepth=16 --group_reporting=1 --filename=/mnt/test2/l -name=job --rw=rw
xfs/loop/xfs
   READ: bw=869MiB/s (911MB/s), 869MiB/s-869MiB/s (911MB/s-911MB/s), io=8694MiB (9116MB), run=10002-10002msec
  WRITE: bw=870MiB/s (913MB/s), 870MiB/s-870MiB/s (913MB/s-913MB/s), io=8706MiB (9129MB), run=10002-10002msec


Without "threaded_aio=1":

Sync io
fio --direct=1 --bs=4k --runtime=10 --time_based --numjobs=12 --ioengine=psync --iodepth=1 --group_reporting=1 --filename=/mnt/test2/l -name=job --rw=rw
xfs/loop/xfs
   READ: bw=348MiB/s (365MB/s), 348MiB/s-348MiB/s (365MB/s-365MB/s), io=3481MiB (3650MB), run=10001-10001msec
  WRITE: bw=348MiB/s (365MB/s), 348MiB/s-348MiB/s (365MB/s-365MB/s), io=3484MiB (3653MB), run=10001-10001msec

Async io
fio --direct=1 --bs=4k --runtime=10 --time_based --numjobs=12 --ioengine=libaio --iodepth=16 --group_reporting=1 --filename=/mnt/test2/l -name=job --rw=rw
xfs/loop/xfs
   READ: bw=1186MiB/s (1244MB/s), 1186MiB/s-1186MiB/s (1244MB/s-1244MB/s), io=11.6GiB (12.4GB), run=10001-10001msec
  WRITE: bw=1187MiB/s (1245MB/s), 1187MiB/s-1187MiB/s (1245MB/s-1245MB/s), io=11.6GiB (12.5GB), run=10001-10001msec

Mikulas


