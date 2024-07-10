Return-Path: <io-uring+bounces-2492-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32D0E92D8D3
	for <lists+io-uring@lfdr.de>; Wed, 10 Jul 2024 21:12:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 516661C227F9
	for <lists+io-uring@lfdr.de>; Wed, 10 Jul 2024 19:12:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81F63197A95;
	Wed, 10 Jul 2024 19:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BAqyBvzA"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F1B197A7E
	for <io-uring@vger.kernel.org>; Wed, 10 Jul 2024 19:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720638733; cv=none; b=sx5tPhL9IAV8qHeEdc6sElvm+gmbtgzWsyJLfahCB7uKNxFL3PrkOrJwUyNaQRLdIJjYhHwoOTx3CRGEJK8pIDCI0qZ4rSJzMXkgkfxQnoQ01Z/BQWeS7QkU3VLpjUUZy0X4ofh95FsUbCjFLwoLf/lfo2OHreeQbA2pBWFOT9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720638733; c=relaxed/simple;
	bh=bDGvO62jYHv4lNM4mC2NUu6D837SU3bgt8PZd2SN7Rw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CTyTouxJBAdjiiBcFZHHj7TDJNm5FjaL+z0ATHKUpI9/UfgQ3FxMtYdmjZft6gE1DF9uxggamOQDsNrHc5Og7aX2UH2SjmA5v1hrrQ4xVLnzY7jYADDev/pmiqGMnEMJwoefVQ+kbm7BJpkK5fRNaP8d8N2bILRnFE9CIUIejQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BAqyBvzA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720638730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bDGvO62jYHv4lNM4mC2NUu6D837SU3bgt8PZd2SN7Rw=;
	b=BAqyBvzAzCvdYso+cYELbueVPGQbhVZmX0vl/OxNL/RatpBy+YYRxG2OxdQAWWa/Gx2m1Q
	Pi2INu5ol7/5g4kSp5SXY4zmqxotn2H//A/VrvJ3Cj02D8MzxyqtMlezccJZSvp6Z9a5AO
	jcYJzDunSyXjCvYy/0pEwz7vZP8APyM=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-96-BD8xhm5hPVKh_Kem2s7ygA-1; Wed,
 10 Jul 2024 15:12:02 -0400
X-MC-Unique: BD8xhm5hPVKh_Kem2s7ygA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 568511955BC4;
	Wed, 10 Jul 2024 19:11:58 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.45.224.169])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id BECBF19560AE;
	Wed, 10 Jul 2024 19:11:53 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Wed, 10 Jul 2024 21:10:21 +0200 (CEST)
Date: Wed, 10 Jul 2024 21:10:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, io-uring@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Tycho Andersen <tandersen@netflix.com>,
	Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
	Julian Orth <ju.orth@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] kernel: rerun task_work while freezing in
 get_signal()
Message-ID: <20240710191015.GC9228@redhat.com>
References: <62c11b59-c909-4c60-8370-77729544ec0a@gmail.com>
 <20240709103617.GB28495@redhat.com>
 <658da3fe-fa02-423b-aff0-52f54e1332ee@gmail.com>
 <Zo1ntduTPiF8Gmfl@slm.duckdns.org>
 <20240709190743.GB3892@redhat.com>
 <d2667002-1631-4f42-8aad-a9ea56c0762b@gmail.com>
 <20240709193828.GC3892@redhat.com>
 <d9c00f01-576c-46cd-a88c-76e244460dac@gmail.com>
 <Zo3bt3AJHSG5rVnZ@slm.duckdns.org>
 <933e7957-7a73-4c9a-87a7-c85b702a3a32@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <933e7957-7a73-4c9a-87a7-c85b702a3a32@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On 07/10, Pavel Begunkov wrote:
>
> On 7/10/24 01:54, Tejun Heo wrote:
> >Yeah, the question is: If CRIU is to use cgroup freezer to freeze the tasks
> >and then go around tracing each to make dump, would the freezer be enough in
> >avoiding interim state changes? Using CRIU implementation is a bit arbitrary
> >but I think checkpoint-restart is a useful bar to measure what should stay
> >stable while a cgroup is frozen.
>
> Sounds like in the long run we might want to ignore task_work while
> it's frozen,

Just in case, this is what I have in mind right now, but I am still not sure
and can't make a "clean" patch.

If nothing else. CRIU needs to attach and make this task TASK_TRACED, right?
And once the target task is traced, it won't react to task_work_add(TWA_SIGNAL).

Oleg.


