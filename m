Return-Path: <io-uring+bounces-2162-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B7F51903D4F
	for <lists+io-uring@lfdr.de>; Tue, 11 Jun 2024 15:29:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA1561C23021
	for <lists+io-uring@lfdr.de>; Tue, 11 Jun 2024 13:29:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F099A17C7DA;
	Tue, 11 Jun 2024 13:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VRaPShbS"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6582117CA0B
	for <io-uring@vger.kernel.org>; Tue, 11 Jun 2024 13:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718112514; cv=none; b=sIjP20F/xhVu7KC+asZnefB6cKuqTeo3oPix/Uu5a8VvxPEo1R03JnT8JFsPtV9nQcOXf1nq8ck8Cv5gu1RumXu3Vs/oc0mNJ9yL6LJOTFqzqHlSrRQvT/cFpSsLWUoo62DXqykYQqZz8oGmX6yjxUUYGVivNBz0Cq06TRbhcAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718112514; c=relaxed/simple;
	bh=6/zlc8WPbROK9H0qUXpqc+qthg2KS/DV6CsXppj46yI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UuXFUrFH/w5JNvV2ZghywRHFIefHSaWg+Ky2/vEKPO7Jh5/MATbO3MpGuno2twRRRFORAtCISIUKVviBBa//cS1SimWLjeHmPog6so5k+QFWsIOY8xbkqfV2Ey9ClBpIvhEI1gW513Vno7ePcM3u0tAtz5uAaKT8HZP25PKgAt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VRaPShbS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718112512;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IcMKS/qQrzYfBu4nsNZn9hRCEKSKd6dyX2sOy7GeW14=;
	b=VRaPShbSel+NPVZR6wdtKPqF7X0A5k61zmgWJjCO8lG0a6Moh23c3jKGrVqARclkE/trli
	fU932320kkGFJAupqtQTe2ANKAuJpw+q3kEptAStNpOTK/VuF6FTwVB2SYLqUIBjfdb+je
	92Mcz1bdqKcpZOG/bkJY/BFcsFxslNE=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-18-yh1CRDYDMxWoUSEfxpoiZw-1; Tue,
 11 Jun 2024 09:28:28 -0400
X-MC-Unique: yh1CRDYDMxWoUSEfxpoiZw-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3EF2E19560AB;
	Tue, 11 Jun 2024 13:28:27 +0000 (UTC)
Received: from fedora (unknown [10.72.112.70])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E21831955E80;
	Tue, 11 Jun 2024 13:28:22 +0000 (UTC)
Date: Tue, 11 Jun 2024 21:28:17 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>
Subject: Re: [PATCH V3 4/9] io_uring: move marking REQ_F_CQE_SKIP out of
 io_free_req()
Message-ID: <ZmhQ8X6q2RvKpn38@fedora>
References: <20240511001214.173711-1-ming.lei@redhat.com>
 <20240511001214.173711-5-ming.lei@redhat.com>
 <f7b3164a-b9a5-4c61-84c9-ff5b18e2e92a@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7b3164a-b9a5-4c61-84c9-ff5b18e2e92a@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Mon, Jun 10, 2024 at 02:23:50AM +0100, Pavel Begunkov wrote:
> On 5/11/24 01:12, Ming Lei wrote:
> > Prepare for supporting sqe group, which requires to post group leader's
> > CQE after all members' CQEs are posted. For group leader request, we can't
> > do that in io_req_complete_post, and REQ_F_CQE_SKIP can't be set in
> > io_free_req().
> 
> Can you elaborate what exactly we can't do and why?

group leader's CQE is always posted after other members are posted.

> 
> > So move marking REQ_F_CQE_SKIP out of io_free_req().
> 
> That makes io_free_req() a very confusing function, it tells
> that it just frees the request but in reality can post a
> CQE. If you really need it, just add a new function.

io_free_req() never posts CQE.

This patch can help to move setting REQ_F_CQE_SKIP around
real post code, and it can make current code more readable.


Thanks, 
Ming


