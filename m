Return-Path: <io-uring+bounces-2475-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CF2792BD59
	for <lists+io-uring@lfdr.de>; Tue,  9 Jul 2024 16:46:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A3E128D431
	for <lists+io-uring@lfdr.de>; Tue,  9 Jul 2024 14:46:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3AC919D06A;
	Tue,  9 Jul 2024 14:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a5vJFnW7"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7516819DF62
	for <io-uring@vger.kernel.org>; Tue,  9 Jul 2024 14:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720536282; cv=none; b=ekOtFP0x8h8nxVq5B963s8FeZjq/3XIluJu9Vc/vxCmE5QW4jaazNPJadK4Lxcf71mLy0dX02hJftxU+TW1JMIJYh9M8CrY/0JwTJM39fwpEeGQIYopCddBXSE1EWTqTs2yUIZolo6neCHfAP7or5t/5Ay6dNu//DD0vTLitvPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720536282; c=relaxed/simple;
	bh=z/HOlnAjVOJAq9jQBAX+TjbVTpO8+2NA70MV4Yvy3+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mdy0CjuVfPBHfS97YdiQb+db4kXvbJCjQbIOLkumU6j83LNKuiLM96QKx0iyxsubVrPwH05y/k9i0IQw5M29fbg3SQfwXH0/ZepkwazwTm9glEG9u79TNGoWotOhmj0q9XvEGUpqzMa+qk2nVzGemZfKb/+ZJb/h3fiP563idj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a5vJFnW7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720536280;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aKQNagMd+/kQwCZ2zdj+xcm1JmpHTDklELtSI1+6xsw=;
	b=a5vJFnW7RvtkSslRspmQ07rVV31WojdnDmV5H8cUJFXdRKncQ90WJbY1VmvPh4lAXEytu3
	wyncflRcnJis/V1cFG/KI8FvtotGrQlvzEwUqQYceTPQUf0+LnW+xb8EcoIfUktidqwQh6
	TPvc10maeFIAIzy+JREtr/GzuC9Ddao=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-513-eWb0xB66N0CoHfYEjm1UEw-1; Tue,
 09 Jul 2024 10:44:33 -0400
X-MC-Unique: eWb0xB66N0CoHfYEjm1UEw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B00D71955E80;
	Tue,  9 Jul 2024 14:44:29 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.45.226.34])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id E8B9A19327CB;
	Tue,  9 Jul 2024 14:43:42 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Tue,  9 Jul 2024 16:42:15 +0200 (CEST)
Date: Tue, 9 Jul 2024 16:42:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Tycho Andersen <tandersen@netflix.com>,
	Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
	Julian Orth <ju.orth@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 2/2] kernel: rerun task_work while freezing in
 get_signal()
Message-ID: <20240709144205.GE28495@redhat.com>
References: <cover.1720534425.git.asml.silence@gmail.com>
 <149ff5a762997c723880751e8a4019907a0b6457.1720534425.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149ff5a762997c723880751e8a4019907a0b6457.1720534425.git.asml.silence@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On 07/09, Pavel Begunkov wrote:
>
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -2600,6 +2600,14 @@ static void do_freezer_trap(void)
>  	spin_unlock_irq(&current->sighand->siglock);
>  	cgroup_enter_frozen();
>  	schedule();
> +
> +	/*
> +	 * We could've been woken by task_work, run it to clear
> +	 * TIF_NOTIFY_SIGNAL. The caller will retry if necessary.
> +	 */
> +	clear_notify_signal();
> +	if (unlikely(task_work_pending(current)))
> +		task_work_run();
>  }

Acked-by: Oleg Nesterov <oleg@redhat.com>


