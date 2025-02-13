Return-Path: <io-uring+bounces-6423-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A01BA34E46
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 20:14:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 583127A28F9
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 19:13:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EB56245AEE;
	Thu, 13 Feb 2025 19:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jDn7KKKO"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A06F2036E4
	for <io-uring@vger.kernel.org>; Thu, 13 Feb 2025 19:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739474065; cv=none; b=ep37vmBth7MZcQlg04CpjFsxloVgW3xctPILW0goZafXwN9YZy2vxZicVpb4ddiy+ua6dhyDXHhvN5OJYIkJuzsDl7EdTBr3nb1IE8YBPu4yUorQCrKfvHZeZQvyfCxcl3UuvSKDDDPgINqpv0TT3sSUzowbDAjlHH/J+UYWyGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739474065; c=relaxed/simple;
	bh=9PB4zpIvPUbfL/58yEOmKrdDno6R+gqJIsf5m8yynWs=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:
	 MIME-Version:Content-Type; b=qIfJh/sOLfdi86GwZF7guj7S5sk7nowujh1X8KdNqm0zF8WVXlybguM4bNtITo9HRGGyDwz6EmCyezF4DA5nQNO9OP+T97swuwdnWwWRa3HZIEOMhR1QP6e0pC9mTBIDVRykkXtf3LWx4xnRXc+c5vqfH5dDEQbBl4tmlSRWvmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jDn7KKKO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739474062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e8NHn74KfJVVBpJZyHQb+/7alEwyZmF7Ww8c2L3Kvj4=;
	b=jDn7KKKOYI9KxWrW6YAjFEc7awG8TV2jBL7haFW0fburXYHHPrYAswVBs/8ynQ6UesL92+
	q0IWcBUnFQ3w8J0TZqxFsTIo9HkxlCojIogCRcSf+TbK228XUwRu3eo3fO3lB9Gb2FeuPv
	7uncnHzlCQJOJGdeg/EOxKCWvLvPYZc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-424-9OcBqQxiPzuXgFTV9ya9AQ-1; Thu,
 13 Feb 2025 14:14:04 -0500
X-MC-Unique: 9OcBqQxiPzuXgFTV9ya9AQ-1
X-Mimecast-MFC-AGG-ID: 9OcBqQxiPzuXgFTV9ya9AQ
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5E7151800875;
	Thu, 13 Feb 2025 19:14:03 +0000 (UTC)
Received: from segfault.usersys.redhat.com (unknown [10.22.81.182])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 39D5C1800359;
	Thu, 13 Feb 2025 19:14:01 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Jens Axboe <axboe@kernel.dk>,  Pavel Begunkov <asml.silence@gmail.com>,
  io-uring@vger.kernel.org
Subject: Re: [PATCH] io_uring: do not assume that ktime_t is equal to
 nanoseconds
References: <20250213154452.3474681-1-dmantipov@yandex.ru>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Thu, 13 Feb 2025 14:13:59 -0500
In-Reply-To: <20250213154452.3474681-1-dmantipov@yandex.ru> (Dmitry Antipov's
	message of "Thu, 13 Feb 2025 18:44:52 +0300")
Message-ID: <x49ed01lkso.fsf@segfault.usersys.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Dmitry Antipov <dmantipov@yandex.ru> writes:

> In 'io_cqring_schedule_timeout()', do not assume that 'ktime_t' is
> equal to nanoseconds and prefer 'ktime_add()' over 'ktime_add_ns()'
> to sum two 'ktime_t' values. Compile tested only.
>
> Fixes: 1100c4a2656d ("io_uring: add support for batch wait timeout")
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> ---
>  io_uring/io_uring.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index ceacf6230e34..7f2500aca95c 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -2434,7 +2434,7 @@ static int io_cqring_schedule_timeout(struct io_wait_queue *iowq,
>  	ktime_t timeout;
>  
>  	if (iowq->min_timeout) {
> -		timeout = ktime_add_ns(iowq->min_timeout, start_time);
> +		timeout = ktime_add(iowq->min_timeout, start_time);

I don't think this solves the issue stated in the commit message.  Look
at where the min_timeout comes from, in io_get_ext_arg:

	ext_arg->min_time = READ_ONCE(w->min_wait_usec) * NSEC_PER_USEC;

Perhaps that should be:

	ext_arg->min_time = us_to_ktime(READ_ONCE(w->min_wait_usec));

I also don't know whether this warrants a fixes tag, given it doesn't
change any behavior.

Cheers,
Jeff


