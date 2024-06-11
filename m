Return-Path: <io-uring+bounces-2163-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 00066903D6B
	for <lists+io-uring@lfdr.de>; Tue, 11 Jun 2024 15:32:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1349B1C20BB3
	for <lists+io-uring@lfdr.de>; Tue, 11 Jun 2024 13:32:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4B4E17CA1D;
	Tue, 11 Jun 2024 13:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VjC8+aiT"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384F2176AB8
	for <io-uring@vger.kernel.org>; Tue, 11 Jun 2024 13:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718112751; cv=none; b=LZzC29Y5binBX80uGzIqMg1wBfGO7bM4yzmEQwONQr2iYzfaVgoOuMVd3hLEWlm5E939x91P2laDaZeOT/vEQvbhED0OMeqXfam1yY4E+xiAS9cW0qI50XJ4vVVt+uNQbVqWWZ4+kqxI4f03leRXTx3zm9NdwzfGIKCgDy9G7j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718112751; c=relaxed/simple;
	bh=yZ1G3ZXgVsPiMUUSvPSCxhIv3qBhQnzM1JpR2ct50GI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q8ZCsFbGdDzzNPeSK50CPDx69hCckUMAdJUaTLZj9GYXB63t1TOsnMBdZ4Aiu0u4lLVYDOEbFSCrB/p8JtM52WPg3zTrohdqA6pOb3f8oalMMfGJhI0+jUxesiHw+i9I7QlpR+B+Sq7apG/AU5paswLOxgo7fXMS6ZCxYiV1BJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VjC8+aiT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718112749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=73RaZnALNPWVfPpsEbuTyGk+0J31QH8qbBFI99wuIDg=;
	b=VjC8+aiTH00HnqSQ6Kg6vsVjz7Cp8b16maWVQ8MOZIdAYk8BPMSHgD4L0sAWER0jwiRdFr
	l6GIiA50LB1O/7SAa5t6IPwhnLhptfgYFaUJNQ4A0nZ2J0tZolOZ4e9fDLRfX9BEGRGLSz
	gByf2s/aVj7uE0Jt467VW05FtpIbqJc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-538-OoATnb5yPZ-PV4dZJr1fXg-1; Tue,
 11 Jun 2024 09:32:26 -0400
X-MC-Unique: OoATnb5yPZ-PV4dZJr1fXg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9828A1955D9A;
	Tue, 11 Jun 2024 13:32:24 +0000 (UTC)
Received: from fedora (unknown [10.72.112.70])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8012330000C4;
	Tue, 11 Jun 2024 13:32:20 +0000 (UTC)
Date: Tue, 11 Jun 2024 21:32:15 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>
Subject: Re: [PATCH V3 5/9] io_uring: support SQE group
Message-ID: <ZmhR3/TipsQI5OxN@fedora>
References: <20240511001214.173711-1-ming.lei@redhat.com>
 <20240511001214.173711-6-ming.lei@redhat.com>
 <ZkwNxxUM7jqzpqgg@fedora>
 <3fd4451f-d30e-43f8-a01f-428a1073882d@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fd4451f-d30e-43f8-a01f-428a1073882d@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Mon, Jun 10, 2024 at 02:55:22AM +0100, Pavel Begunkov wrote:
> On 5/21/24 03:58, Ming Lei wrote:
> > On Sat, May 11, 2024 at 08:12:08AM +0800, Ming Lei wrote:
> > > SQE group is defined as one chain of SQEs starting with the first SQE that
> > > has IOSQE_SQE_GROUP set, and ending with the first subsequent SQE that
> > > doesn't have it set, and it is similar with chain of linked SQEs.
> > > 
> > > Not like linked SQEs, each sqe is issued after the previous one is completed.
> > > All SQEs in one group are submitted in parallel, so there isn't any dependency
> > > among SQEs in one group.
> > > 
> > > The 1st SQE is group leader, and the other SQEs are group member. The whole
> > > group share single IOSQE_IO_LINK and IOSQE_IO_DRAIN from group leader, and
> > > the two flags are ignored for group members.
> > > 
> > > When the group is in one link chain, this group isn't submitted until the
> > > previous SQE or group is completed. And the following SQE or group can't
> > > be started if this group isn't completed. Failure from any group member will
> > > fail the group leader, then the link chain can be terminated.
> > > 
> > > When IOSQE_IO_DRAIN is set for group leader, all requests in this group and
> > > previous requests submitted are drained. Given IOSQE_IO_DRAIN can be set for
> > > group leader only, we respect IO_DRAIN by always completing group leader as
> > > the last one in the group.
> > > 
> > > Working together with IOSQE_IO_LINK, SQE group provides flexible way to
> > > support N:M dependency, such as:
> > > 
> > > - group A is chained with group B together
> > > - group A has N SQEs
> > > - group B has M SQEs
> > > 
> > > then M SQEs in group B depend on N SQEs in group A.
> > > 
> > > N:M dependency can support some interesting use cases in efficient way:
> > > 
> > > 1) read from multiple files, then write the read data into single file
> > > 
> > > 2) read from single file, and write the read data into multiple files
> > > 
> > > 3) write same data into multiple files, and read data from multiple files and
> > > compare if correct data is written
> > > 
> > > Also IOSQE_SQE_GROUP takes the last bit in sqe->flags, but we still can
> > > extend sqe->flags with one uring context flag, such as use __pad3 for
> > > non-uring_cmd OPs and part of uring_cmd_flags for uring_cmd OP.
> > > 
> > > Suggested-by: Kevin Wolf <kwolf@redhat.com>
> > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > 
> > BTW, I wrote one link-grp-cp.c liburing/example which is based on sqe group,
> > and keep QD not changed, just re-organize IOs in the following ways:
> > 
> > - each group have 4 READ IOs, linked by one single write IO for writing
> >    the read data in sqe group to destination file
> 
> IIUC it's comparing 1 large write request with 4 small, and

It is actually reasonable from storage device viewpoint, concurrent
small READs are often fast than single big READ, but concurrent small
writes are usually slower.

> it's not exactly anything close to fair. And you can do same
> in userspace (without links). And having control in userspace

No, you can't do it with single syscall.


Thanks, 
Ming


