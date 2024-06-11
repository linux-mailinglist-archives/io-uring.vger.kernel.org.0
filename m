Return-Path: <io-uring+bounces-2161-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BA5C2903D07
	for <lists+io-uring@lfdr.de>; Tue, 11 Jun 2024 15:22:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6ACE61F245F6
	for <lists+io-uring@lfdr.de>; Tue, 11 Jun 2024 13:22:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2853C17C7D8;
	Tue, 11 Jun 2024 13:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cz0E3gqV"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C52E17C9F3
	for <io-uring@vger.kernel.org>; Tue, 11 Jun 2024 13:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718112093; cv=none; b=A7scHv1YLJY6X+EdZH0N7tza02BClWYmrB4z1A0aVNNHOTPsaVgFAsc9+rVpI+CoclInN7VHlOloXJK5+y0twf7gaCSLHdAd5p3KDSOdNZJZ3FJn4hiWqrJ/SIhBFQd/9eervd2/ylDbbIrJA8ziGsIArKEFVir1mdo2efEHIhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718112093; c=relaxed/simple;
	bh=fbCivy6Dma229kgB+ERgMdVEpz15i1aDAUXy/KA6P1k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uiVVGQIy7pOa8dfK5hA7wlve92Y3rPKUIWpEnxNa2kACfJ4NpPEPpQQtegbObgAR8I4L3Ocl/v6P1jag9dblMLaqeV+PY1AeRuE48AX2To99IvdMODPEZ8J9Ld4tbb+8ZT/tjmKqzQc8GYnVLieFM2j8kC7r6vmY4l44qjrZMEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cz0E3gqV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718112090;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JkPV1uwDAHgIgRebjVf5OO99h1u6icRxw1+w9oqLzmo=;
	b=cz0E3gqVNRtBC5Mw6Uw6P6DRauNQmMFXvMIfVJtwtstQF0B00NLTaBLaWrjjr3RX00KZGV
	/FdprPdxGLO/Jjzy8KySmDnDoNcy6PEORD3a1iJdCKGy/30n26Ncy2K1xev4tqyjtZYaCU
	XX3tDKE7yhOAknHrz0557LbngXdMe1s=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-36-6lHhZgoTM0uSpDyOuW-mEw-1; Tue,
 11 Jun 2024 09:21:24 -0400
X-MC-Unique: 6lHhZgoTM0uSpDyOuW-mEw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1B53B19560A5;
	Tue, 11 Jun 2024 13:21:22 +0000 (UTC)
Received: from fedora (unknown [10.72.112.70])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A3E6819560AD;
	Tue, 11 Jun 2024 13:21:17 +0000 (UTC)
Date: Tue, 11 Jun 2024 21:21:11 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>
Subject: Re: [PATCH V3 3/9] io_uring: add helper of io_req_commit_cqe()
Message-ID: <ZmhPR03SSSWmHLcD@fedora>
References: <20240511001214.173711-1-ming.lei@redhat.com>
 <20240511001214.173711-4-ming.lei@redhat.com>
 <10b4dc44-d7dc-4858-abb9-2837fc688f44@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10b4dc44-d7dc-4858-abb9-2837fc688f44@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Mon, Jun 10, 2024 at 02:18:34AM +0100, Pavel Begunkov wrote:
> On 5/11/24 01:12, Ming Lei wrote:
> > Add helper of io_req_commit_cqe() which can be used in posting CQE
> > from both __io_submit_flush_completions() and io_req_complete_post().
> 
> Please drop this patch and inline further changes into this
> two callers. There are different locking rules, different
> hotness, and should better be left duplicated until cleaned
> up in a proper way.

Yes, the helper is just for making following code more clean & readable.

Actually it changes nothing for __io_submit_flush_completions(), but
io_req_complete_post() can be thought as non-fast path. And we may
keep it only friendly for __io_submit_flush_completions(), meantime
just cover io_req_complete_post().


Thanks, 
Ming


