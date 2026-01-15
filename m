Return-Path: <io-uring+bounces-11726-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EA31D220DD
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 02:42:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DD8993019E1B
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 01:42:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2C702745C;
	Thu, 15 Jan 2026 01:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C/+cVYki"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CE427456
	for <io-uring@vger.kernel.org>; Thu, 15 Jan 2026 01:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768441373; cv=none; b=kUGvygPPO+CAa1HJJqbDtAvg2ed0kjMrA7U+Rgjhrjy6nZbC23SA3mEymp4HB5XYcqkEtMreIoGAAy93wxbmKttyBc4PdOm9cQH7RBKGrQNWN1Nw3tmi6kHa1dbQpy/D+UtjXnBtfkco7+eA4KSvjGqzS9wA6LvKacCUxvFyK6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768441373; c=relaxed/simple;
	bh=QT12WAvFM896Nyj4l7zpuUq1lc2yAWX2rD6E/p8M+QM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LpKljcJVyW9rKVff0RZMkUV7FsuF3sLXTWHbbgbV54AbxgudDYwY2dyuRKti0ypgAUEoKqQXMl2q4usSMJ18NpZ25/WD8YzCZxipDusui9Om9yqbOcMBtsmVskOzmodAysuBbIKynloyzh/Sfpyjs/QJERJgRt07YS2avEWm+Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C/+cVYki; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768441371;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PQwJ0AAOzV5VcxgixE4zfFf4Vv+bfjgYrPdcdgn3ozQ=;
	b=C/+cVYkiLYXKAOqNjLgSfBMrznrdwaArfQTQgCvu7ysECq6H0hYNz+Xhs32myOZ+8zWLuW
	72Ltr5dziMTHlDfG/Fa0fXRBCTGWopHTr/KPYPrvpUOrXEm7b1NNo3gIh096eloK1kX7wX
	ifECkSneGBhjJ8UgQB0fjiroxiW0BTk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-78-5vKb6k0hO0aBtpYd4Z9H6Q-1; Wed,
 14 Jan 2026 20:42:49 -0500
X-MC-Unique: 5vKb6k0hO0aBtpYd4Z9H6Q-1
X-Mimecast-MFC-AGG-ID: 5vKb6k0hO0aBtpYd4Z9H6Q_1768441369
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DCA341956094;
	Thu, 15 Jan 2026 01:42:48 +0000 (UTC)
Received: from fedora (unknown [10.72.116.198])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F1EA819560A7;
	Thu, 15 Jan 2026 01:42:45 +0000 (UTC)
Date: Thu, 15 Jan 2026 09:42:40 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>, Yi Zhang <yi.zhang@redhat.com>
Subject: Re: [PATCH v2] io_uring: fix IOPOLL with passthrough I/O
Message-ID: <aWhGEMsaOf752f5z@fedora>
References: <c008dbd2-6436-40da-b5c6-f34844878a6f@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c008dbd2-6436-40da-b5c6-f34844878a6f@kernel.dk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Wed, Jan 14, 2026 at 08:28:49AM -0700, Jens Axboe wrote:
> A previous commit improving IOPOLL made an incorrect assumption that
> task_work isn't used with IOPOLL. This can cause crashes when doing
> passthrough I/O on nvme, where queueing the completion task_work will
> trample on the same memory that holds the completed list of requests.
> 
> Fix it up by shuffling the members around, so we're not sharing any
> parts that end up getting used in this path.
> 
> Fixes: 3c7d76d6128a ("io_uring: IOPOLL polling improvements")
> Reported-by: Yi Zhang <yi.zhang@redhat.com>
> Link: https://lore.kernel.org/linux-block/CAHj4cs_SLPj9v9w5MgfzHKy+983enPx3ZQY2kMuMJ1202DBefw@mail.gmail.com/
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> v2: ensure ->iopoll_start is read before doing actual polling

Looks fine, also not see regression in ublk selftest:

Reviewed-by: Ming Lei <ming.lei@redhat.com>


Thanks,
Ming


