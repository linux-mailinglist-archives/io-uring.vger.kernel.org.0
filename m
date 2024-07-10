Return-Path: <io-uring+bounces-2493-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AED6692D8F6
	for <lists+io-uring@lfdr.de>; Wed, 10 Jul 2024 21:20:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6AD6E28171C
	for <lists+io-uring@lfdr.de>; Wed, 10 Jul 2024 19:20:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0375A197A9F;
	Wed, 10 Jul 2024 19:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ee2/A8RF"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12ADA197A76
	for <io-uring@vger.kernel.org>; Wed, 10 Jul 2024 19:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720639220; cv=none; b=Xei94H1EYIzFCkCXzNRpN5NsVbpN82osquH2pnMOoLB60a07ia2Fp2hZ3jqrqA/hpm2XF0fROPE9bq/RV+R04to/Pe65RAIQRuSlqv52QKGjCWPm1hfSJ9snk8KqDNYJ0cIKNczHxLIf/m3nW85VigWgrHbF2pOiEmEC8i0xTCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720639220; c=relaxed/simple;
	bh=0fsclPJO+0S/lvzn0RI6aYyeLzEsX1Mg7kOsvhED/bc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZfOR9fkh9OS8p5mKyJoSDTvPsPRiXcvrLLh5pjmHckQGvsDi/4XenDGGedpLV620zFhh/9aQjwT4LBO0gQJOjsX8yXdA54H5QIozLcHf7uDvMxxJWcnCYgP7xoeuFrekS62p7UzA89V+Cu+wDCW95V5aI3CqZwiBfBGSZSQ/Idc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ee2/A8RF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720639218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0fsclPJO+0S/lvzn0RI6aYyeLzEsX1Mg7kOsvhED/bc=;
	b=ee2/A8RFt/M/d+bnVPJaVQqwzkEcfYaHk3hBQ2DnWbn6i8MYgbJvtEc8ION/qrIbkuK9dk
	jXh3HYZIAzCYzc8MlqCto4h9Ms2bl/QQ8iSOW+Yy8dXMXD9gYsmLpATnlY+KKm7K+XM1fK
	w7YE/pA5krI9ekhP2SQqFeoj//XZp+o=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-615-rqcydCwYOAGWRZkmxDNCLQ-1; Wed,
 10 Jul 2024 15:20:10 -0400
X-MC-Unique: rqcydCwYOAGWRZkmxDNCLQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7B9F81955F42;
	Wed, 10 Jul 2024 19:20:06 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.45.224.169])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id E2AD81955F40;
	Wed, 10 Jul 2024 19:20:01 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Wed, 10 Jul 2024 21:18:29 +0200 (CEST)
Date: Wed, 10 Jul 2024 21:18:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Tycho Andersen <tandersen@netflix.com>,
	Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
	Julian Orth <ju.orth@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 2/2] kernel: rerun task_work while freezing in
 get_signal()
Message-ID: <20240710191824.GD9228@redhat.com>
References: <cover.1720634146.git.asml.silence@gmail.com>
 <89ed3a52933370deaaf61a0a620a6ac91f1e754d.1720634146.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89ed3a52933370deaaf61a0a620a6ac91f1e754d.1720634146.git.asml.silence@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

I have already acked this patch, so I am sorry for the noise, but

On 07/10, Pavel Begunkov wrote:
>
> Run task_works in the freezer path. Keep the patch small and simple
> so it can be easily back ported,

Agreed.

I tried to argue with v1 which added the additional task_work_run()
into get_signal(), but I failed to suggest a "better" change which
doesn't uglify/complicate get_signal/backporting.

Oleg.


