Return-Path: <io-uring+bounces-7214-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EBC7CA6D28E
	for <lists+io-uring@lfdr.de>; Mon, 24 Mar 2025 01:26:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A5746188987E
	for <lists+io-uring@lfdr.de>; Mon, 24 Mar 2025 00:26:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E0A7800;
	Mon, 24 Mar 2025 00:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ilX+WhyH"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405BB1FDD
	for <io-uring@vger.kernel.org>; Mon, 24 Mar 2025 00:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742776006; cv=none; b=SszRRXgQJCYSELesdOkMk1Xoi4J99Ku1vjimVbr0vX9J9svCAkT4UXDsr3jtjg+TNCiJgLU9uY9g6hKdjOhHrowHZvfL4FWBzgyXxJWerhvnSb2Psw4KC9YxpnyMbfVI49VCdTuAbUd9oAsLhBFlXUDx8c5qHXQqWJ285gvFyXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742776006; c=relaxed/simple;
	bh=EdxmE/xnMJC+rkOhusOV+TVKt+RM3p8J03AiiHMRkhQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iWroNZTkrTPMRj5nIFbwfPur8bA2RNBWZL9MEZFgyfS6kxFb2RPZoYjH+BcpqbuXPVelNBBEZMm2rFg3DJjgdEwliWa/YChVGVLjSdZvVCEeV3Kd3HCWU5vyYdmTxBp721z4qk7GDbawl7w2RcRzgRlIWg1G/u7PaBf1vcxt1sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ilX+WhyH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742776002;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FsQdOwHsxMeWdXvdzlATxDSdpOK01aNHHUnQWm+u1aE=;
	b=ilX+WhyHpdgpP6NTA6YvCv90G6j+NtJE2KiYyopj6psr3qtzRv11l7ERinWZ0DqUfzgWoy
	7Hs7/6blFHirGAAcEDgypJkyZP0Qc/Svrc6NpByY33/wgqdeanZoK7qgKMvVwH3ai8wtWF
	3i+KuLSa9tURQim02KepbUi+C1YF9Es=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-689-Nu5yeeMLNLClLHi58XmDww-1; Sun,
 23 Mar 2025 20:26:39 -0400
X-MC-Unique: Nu5yeeMLNLClLHi58XmDww-1
X-Mimecast-MFC-AGG-ID: Nu5yeeMLNLClLHi58XmDww_1742775998
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 164E5196D2CD;
	Mon, 24 Mar 2025 00:26:38 +0000 (UTC)
Received: from fedora (unknown [10.72.120.9])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 837A519541A5;
	Mon, 24 Mar 2025 00:26:32 +0000 (UTC)
Date: Mon, 24 Mar 2025 08:26:27 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH] io_uring: zero remained bytes when reading to fixed
 kernel buffer
Message-ID: <Z-CmsyslSS2nP-YB@fedora>
References: <20250322075625.414708-1-ming.lei@redhat.com>
 <CADUfDZp2TwVuLW+s+WEPOy=gHE8R7-JWEtxZhbmVeRy6CrGh6g@mail.gmail.com>
 <Z99Q_RQob_GBe8WO@fedora>
 <CADUfDZp9J_0QEJDpD=X0i2jUUs6TM7S8KsvUOPO+psOKSnjr8Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZp9J_0QEJDpD=X0i2jUUs6TM7S8KsvUOPO+psOKSnjr8Q@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Sun, Mar 23, 2025 at 08:55:25AM -0700, Caleb Sander Mateos wrote:
> On Sat, Mar 22, 2025 at 5:09 PM Ming Lei <ming.lei@redhat.com> wrote:
> >
> > On Sat, Mar 22, 2025 at 11:10:23AM -0700, Caleb Sander Mateos wrote:
> > > On Sat, Mar 22, 2025 at 12:56 AM Ming Lei <ming.lei@redhat.com> wrote:
> > > >
> > > > So far fixed kernel buffer is only used for FS read/write, in which
> > > > the remained bytes need to be zeroed in case of short read, otherwise
> > > > kernel data may be leaked to userspace.
> > >
> > > I'm not sure I have all the background to understand whether kernel
> > > data can be leaked through ublk requests, but I share Pavel and
> > > Keith's questions about whether this scenario is even possible. If it
> > > is possible, I don't think this patch would cover all the affected
> > > cases:
> > > - Registered ublk buffers can be used with any io_uring operation, not
> > > just read/write. Wouldn't the same issue apply when using the ublk
> > > buffer with, say, a socket recv or an NVMe passthru operation?
> >
> > IORING_RECVSEND_FIXED_BUF isn't handled for recv yet, so looks socket recv
> > isn't enabled...
> 
> True, that specific example doesn't work. But my point was just that
> the issue (if it exists) wouldn't be specific to read/write
> operations. In fact, the ublk server could complete the read request
> without performing any I/O at all to fill in its buffer.

Now actually it has been handled in ublk driver side, which requires
both zero_copy & user_copy implementation(trusted) returns correct result
for short READ, either actual read bytes or failure code has to be returned
from ublk server.

And io_uring read/recv/.. needn't to be bothered.

> >
> > > - Wouldn't the same issue apply if the ublk server completes a ublk
> > > read request without performing any I/O (zero-copy or not) to read
> > > data into its buffer?
> >
> > Yes, it needs ublk zc server implementation to be trusted, and ublk zc
> > can't work in unprivileted mode.
> >
> > For non-zc, no such risk because request buffer is filled with user data.
> 
> The issue doesn't appear specific to zero-copy. If the ublk device is
> configured with UBLK_F_USER_COPY, a buggy/malicious ublk server that
> doesn't fill in the read request's full buffer would also leak the
> existing contents of the buffers. But both UBLK_F_USER_COPY and
> UBLK_F_SUPPORT_ZERO_COPY require CAP_SYS_ADMIN. So I think it's
> reasonable to say that we are trusting any privileged ublk server to
> fully initialize read requests' buffers.

Right, this kind of thing(include above) should be documented.


Thanks,
Ming


