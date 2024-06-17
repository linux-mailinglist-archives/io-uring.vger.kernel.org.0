Return-Path: <io-uring+bounces-2232-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B220F90A1DF
	for <lists+io-uring@lfdr.de>; Mon, 17 Jun 2024 03:43:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53C32280CFE
	for <lists+io-uring@lfdr.de>; Mon, 17 Jun 2024 01:43:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23FD627733;
	Mon, 17 Jun 2024 01:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gbf3R5eg"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F302561D
	for <io-uring@vger.kernel.org>; Mon, 17 Jun 2024 01:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718588577; cv=none; b=ARwNxMZdfWEeMhwm9qqr+eW0grLiRwhHciDpXId8FPLjITzHT3FV6ogNbHdMQEHB0eh3xInRbYvfod+esAzqFBx+CU3mKg4v0DlUgAkqKZXUcq6GheCpnZflYd1xKThOY0g7OiHrMHd7W6p8PmHE5XKiJN+SWPCNJxYnactqMqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718588577; c=relaxed/simple;
	bh=l/SUyG922f0iQomiCu8eMu6cEZdnWcIvkvuq7uNlwUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N/kapDgPS8DkaN4LL+77e7mepeyjy99fdAW/gHZWCP0L8AvBqgKzLDk+xgaXI+9JwYTdjWbsGTw7i9GBc1zjaHvOW+KiWlfRVgPzTvqQSAkgBmremwrSKwKyPqb6naBnZ9Z68pIGXj2g1+YUWgeQoKqZ5/0RNXPmDFLuF3eOSa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gbf3R5eg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718588574;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5HolzKzigdBw1BymILTK/m4wDYK4OrAakuyTQsRuWHo=;
	b=Gbf3R5egUeQnaPT7RX+hiHyPA34DpWyim8Sjzw+BdA8U/vN5DC6k9cO4+cXzgC59gl3gDo
	tKxJkBgPWZZ9Hmdy6w3+px3CZ7w6OJKlZY5m6/JKNHaWExr7CjaVs8PoUfgHMkZm/jzqzy
	2WlXruXOHHSvRITKh4SFCj7kCdwj8LU=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-615-KDUT3vASPI-8vudV0F6yCA-1; Sun,
 16 Jun 2024 21:42:51 -0400
X-MC-Unique: KDUT3vASPI-8vudV0F6yCA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7A81D19560A2;
	Mon, 17 Jun 2024 01:42:50 +0000 (UTC)
Received: from fedora (unknown [10.72.112.55])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A531019560AE;
	Mon, 17 Jun 2024 01:42:42 +0000 (UTC)
Date: Mon, 17 Jun 2024 09:42:37 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>,
	ming.lei@redhat.com
Subject: Re: [PATCH V3 5/9] io_uring: support SQE group
Message-ID: <Zm+UjU+B6A/1hwk9@fedora>
References: <20240511001214.173711-1-ming.lei@redhat.com>
 <20240511001214.173711-6-ming.lei@redhat.com>
 <ZkwNxxUM7jqzpqgg@fedora>
 <3fd4451f-d30e-43f8-a01f-428a1073882d@gmail.com>
 <ZmhR3/TipsQI5OxN@fedora>
 <7a147171-df1b-49f5-8bf0-dd147c6b729f@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a147171-df1b-49f5-8bf0-dd147c6b729f@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Sun, Jun 16, 2024 at 07:14:37PM +0100, Pavel Begunkov wrote:
> On 6/11/24 14:32, Ming Lei wrote:
> > On Mon, Jun 10, 2024 at 02:55:22AM +0100, Pavel Begunkov wrote:
> > > On 5/21/24 03:58, Ming Lei wrote:
> > > > On Sat, May 11, 2024 at 08:12:08AM +0800, Ming Lei wrote:
> > > > > SQE group is defined as one chain of SQEs starting with the first SQE that
> > > > > has IOSQE_SQE_GROUP set, and ending with the first subsequent SQE that
> > > > > doesn't have it set, and it is similar with chain of linked SQEs.
> > > > > 
> > > > > Not like linked SQEs, each sqe is issued after the previous one is completed.
> > > > > All SQEs in one group are submitted in parallel, so there isn't any dependency
> > > > > among SQEs in one group.
> > > > > 
> > > > > The 1st SQE is group leader, and the other SQEs are group member. The whole
> > > > > group share single IOSQE_IO_LINK and IOSQE_IO_DRAIN from group leader, and
> > > > > the two flags are ignored for group members.
> > > > > 
> > > > > When the group is in one link chain, this group isn't submitted until the
> > > > > previous SQE or group is completed. And the following SQE or group can't
> > > > > be started if this group isn't completed. Failure from any group member will
> > > > > fail the group leader, then the link chain can be terminated.
> > > > > 
> > > > > When IOSQE_IO_DRAIN is set for group leader, all requests in this group and
> > > > > previous requests submitted are drained. Given IOSQE_IO_DRAIN can be set for
> > > > > group leader only, we respect IO_DRAIN by always completing group leader as
> > > > > the last one in the group.
> > > > > 
> > > > > Working together with IOSQE_IO_LINK, SQE group provides flexible way to
> > > > > support N:M dependency, such as:
> > > > > 
> > > > > - group A is chained with group B together
> > > > > - group A has N SQEs
> > > > > - group B has M SQEs
> > > > > 
> > > > > then M SQEs in group B depend on N SQEs in group A.
> > > > > 
> > > > > N:M dependency can support some interesting use cases in efficient way:
> > > > > 
> > > > > 1) read from multiple files, then write the read data into single file
> > > > > 
> > > > > 2) read from single file, and write the read data into multiple files
> > > > > 
> > > > > 3) write same data into multiple files, and read data from multiple files and
> > > > > compare if correct data is written
> > > > > 
> > > > > Also IOSQE_SQE_GROUP takes the last bit in sqe->flags, but we still can
> > > > > extend sqe->flags with one uring context flag, such as use __pad3 for
> > > > > non-uring_cmd OPs and part of uring_cmd_flags for uring_cmd OP.
> > > > > 
> > > > > Suggested-by: Kevin Wolf <kwolf@redhat.com>
> > > > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > > > 
> > > > BTW, I wrote one link-grp-cp.c liburing/example which is based on sqe group,
> > > > and keep QD not changed, just re-organize IOs in the following ways:
> > > > 
> > > > - each group have 4 READ IOs, linked by one single write IO for writing
> > > >     the read data in sqe group to destination file
> > > 
> > > IIUC it's comparing 1 large write request with 4 small, and
> > 
> > It is actually reasonable from storage device viewpoint, concurrent
> > small READs are often fast than single big READ, but concurrent small
> > writes are usually slower.
> 
> It is, but that doesn't make the comparison apple to apple.
> Even what I described, even though it's better (same number
> of syscalls but better parallelism as you don't block next
> batch of reads by writes), you can argues it's not a
> completely fair comparison either since needs different number
> of buffers, etc.
> 
> > > it's not exactly anything close to fair. And you can do same
> > > in userspace (without links). And having control in userspace
> > 
> > No, you can't do it with single syscall.
> 
> That's called you _can_ do it. And syscalls is not everything,

For ublk, syscall does mean something, because each ublk IO is
handled by io_uring, if more syscalls are introduced for each ublk IO,
performance definitely degrades a lot because IOPS can be million level.
Now syscall PTI overhead does make difference, please see:

https://lwn.net/Articles/752587/

> context switching turned to be a bigger problem, and to execute
> links it does exactly that.

If that is true, IO_LINK shouldn't have been needed, cause you can model
dependency via io_uring syscall, unfortunately it isn't true. IO_LINK not
only simplifies application programming, but also avoids extra syscall.

If you compare io_uring-cp.c(282 LOC) with link-cp.c(193 LOC) in
liburing/examples, you can see io_uring-cp.c is more complicated. Adding
one extra syscall(wait point) makes application hard to write, especially in
modern async/.await programming environment.


Thanks,
Ming


