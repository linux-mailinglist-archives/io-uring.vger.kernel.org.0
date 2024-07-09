Return-Path: <io-uring+bounces-2479-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EDB092C3FE
	for <lists+io-uring@lfdr.de>; Tue,  9 Jul 2024 21:40:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B8B541F233A1
	for <lists+io-uring@lfdr.de>; Tue,  9 Jul 2024 19:40:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D97518004E;
	Tue,  9 Jul 2024 19:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PDuqNAfv"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61FB1B86ED
	for <io-uring@vger.kernel.org>; Tue,  9 Jul 2024 19:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720554018; cv=none; b=d1atqVhH6NqfFX1mjsucCSm/V85Rsk0bxJCplrPsvpeZ//ceAIo/VMYO06LaJqdJ/gjZ2ZiUmMMzY8M560a8h1qtys5AxUNULa2iEFgEZlVjgwrHgaLHVLI9mo2hFSXXJsqGSO63Vd9ZVybyScatF3Z1KiJnf+8r2yjIBWk4SpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720554018; c=relaxed/simple;
	bh=YGzvZ8dxVRYalMaq9tCBYutkYQYcNWBWhQBGtLwI18k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jVgsJV1oVkgAiiyRISo1+HqbMSiR49jjnXEQ6RG4ktqrnRY2sGyRkkijl5QMZBkyeM1c/Rs4/kAqtaO/y+Y+9yLlDpkGGn9BaiJOH4DnIgqwpI45gDW69o78ZUzhTfzpEIoE9UoLB+c/1xL4Uptgh+IaZrG91ZTJjDTCWzRCVzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PDuqNAfv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720554015;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YGzvZ8dxVRYalMaq9tCBYutkYQYcNWBWhQBGtLwI18k=;
	b=PDuqNAfvLNMp6576OC8HL9be98zosGLNM6kb0jWdtvW2ejBAlI7PmqLA/WWfIBTbcwNmM1
	znPKaQFKQu2eH58YsId0CZ+JQeVheQvYGNhtRRLUHl0nD7Kiexwsw919/dv0hRYLA4MCJh
	NbyQkX6wJTfvUAj6eGFG+B85lTASqSQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-142-kLF32l6iPcugtoWkZu6kxg-1; Tue,
 09 Jul 2024 15:40:12 -0400
X-MC-Unique: kLF32l6iPcugtoWkZu6kxg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C0DA0195609F;
	Tue,  9 Jul 2024 19:40:09 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.45.226.34])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id E0DB519560AE;
	Tue,  9 Jul 2024 19:40:05 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Tue,  9 Jul 2024 21:38:33 +0200 (CEST)
Date: Tue, 9 Jul 2024 21:38:29 +0200
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
Message-ID: <20240709193828.GC3892@redhat.com>
References: <cover.1720368770.git.asml.silence@gmail.com>
 <1d935e9d87fd8672ef3e8a9a0db340d355ea08b4.1720368770.git.asml.silence@gmail.com>
 <20240708104221.GA18761@redhat.com>
 <62c11b59-c909-4c60-8370-77729544ec0a@gmail.com>
 <20240709103617.GB28495@redhat.com>
 <658da3fe-fa02-423b-aff0-52f54e1332ee@gmail.com>
 <Zo1ntduTPiF8Gmfl@slm.duckdns.org>
 <20240709190743.GB3892@redhat.com>
 <d2667002-1631-4f42-8aad-a9ea56c0762b@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2667002-1631-4f42-8aad-a9ea56c0762b@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On 07/09, Pavel Begunkov wrote:
>
> On 7/9/24 20:07, Oleg Nesterov wrote:
> >Hi Tejun,
> >
> >Thanks for looking at this, can you review this V2 patch from Pavel?

Just in case, I obviously meant our next (V2) patch

[PATCH v2 2/2] kernel: rerun task_work while freezing in get_signal()
https://lore.kernel.org/all/149ff5a762997c723880751e8a4019907a0b6457.1720534425.git.asml.silence@gmail.com/

> >Well, I don't really understand what can snapshot/restore actually mean...
>
> CRIU, I assume. I'll try it ...

Than I think we can forget about task_works and this patch. CRIU dumps
the tasks in TASK_TRACED state.

> ... but I'm inclined to think the patch makes sense regardless,
> we're replacing an infinite loop with wait-wake-execute-wait.

Agreed.

Oleg.


