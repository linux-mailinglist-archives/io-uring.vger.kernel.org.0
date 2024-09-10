Return-Path: <io-uring+bounces-3127-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A84FE9740F6
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 19:46:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0E8F0B2A011
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 17:44:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B3691A2C21;
	Tue, 10 Sep 2024 17:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dD9aw3zZ"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A58A1A4E93
	for <io-uring@vger.kernel.org>; Tue, 10 Sep 2024 17:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725990162; cv=none; b=ZrZP2lS8NcI0jnJlXwJ4LnZ5Xhg0BaVtJbrwjOZHY9lK8EcFWtj4Aono1qqE8tdNFD0p2FuCYe7RqNHy5YPx9KXmJ98dxQSbfXGHlYARqDlGHXqG8/3XRXSAK01ju5wvYEbs67YgV+jw8HEwCO/Qu7P4ZDuC7MssN9+KsNe+Koo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725990162; c=relaxed/simple;
	bh=fMoTGHkDaTGI1XLrajc2behIZwpEPBgHFXWguQYcElg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r5KbZcHVDsbn2zKTi7hx8ojj9cVAuSLm4agVNKb1Gqn/OOUYgqzD3Zv66FBmBm1Xhul+4qSkP3RvG+gSZSYxreZWrPejQNn6qVdy0XEeZ70MvXLyrOnhLUvEAlEaJN4HmHyvSpXmJMY6FlCdhQct/jVcDL177QgJEY5hWznBQYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dD9aw3zZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725990159;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8vALpOiTX4q65DEi6gKSQySJMF+gLJveZ7rgNLBab20=;
	b=dD9aw3zZ1q0nwkDl3dEEeTqTxaOrAl7/AP1d8Z5Q0c4qI/6HfoIxpHtryzQxnFQs6fZnGI
	Nu4SmX9WWTW6nSkR74PnZ76FrXhnphkyFbZdA8lBwQpv8v3AJuRl/8p2GX/TD42yoTZSBz
	iQe+IKbwRf8dyhq3zkDdFz+/MsMkLXo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-658-X8RgaX72Oh-hzdVSHFc2Zw-1; Tue,
 10 Sep 2024 13:42:36 -0400
X-MC-Unique: X8RgaX72Oh-hzdVSHFc2Zw-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E825C195608B;
	Tue, 10 Sep 2024 17:42:33 +0000 (UTC)
Received: from [10.2.16.251] (unknown [10.2.16.251])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EA0021956086;
	Tue, 10 Sep 2024 17:42:31 +0000 (UTC)
Message-ID: <1589cf94-6d27-4575-bcea-e36c3667b260@redhat.com>
Date: Tue, 10 Sep 2024 13:42:30 -0400
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] io_uring/io-wq: inherit cpuset of cgroup in io
 worker
To: Felix Moessbauer <felix.moessbauer@siemens.com>, axboe@kernel.dk
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org, cgroups@vger.kernel.org, dqminh@cloudflare.com,
 adriaan.schmidt@siemens.com, florian.bezdeka@siemens.com
References: <20240910171157.166423-1-felix.moessbauer@siemens.com>
 <20240910171157.166423-3-felix.moessbauer@siemens.com>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20240910171157.166423-3-felix.moessbauer@siemens.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15


On 9/10/24 13:11, Felix Moessbauer wrote:
> The io worker threads are userland threads that just never exit to the
> userland. By that, they are also assigned to a cgroup (the group of the
> creating task).

The io-wq task is not actually assigned to a cgroup. To belong to a 
cgroup, its pid has to be present to the cgroup.procs of the 
corresponding cgroup, which is not the case here. My understanding is 
that you are just restricting the CPU affinity to follow the cpuset of 
the corresponding user task that creates it. The CPU affinity (cpumask) 
is just one of the many resources controlled by a cgroup. That probably 
needs to be clarified.

Besides cpumask, the cpuset controller also controls the node mask of 
the memory nodes allowed.

Cheers,
Longman

>
> When creating a new io worker, this worker should inherit the cpuset
> of the cgroup.
>
> Fixes: da64d6db3bd3 ("io_uring: One wqe per wq")
> Signed-off-by: Felix Moessbauer <felix.moessbauer@siemens.com>
> ---
>   io_uring/io-wq.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
> index c7055a8895d7..a38f36b68060 100644
> --- a/io_uring/io-wq.c
> +++ b/io_uring/io-wq.c
> @@ -1168,7 +1168,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
>   
>   	if (!alloc_cpumask_var(&wq->cpu_mask, GFP_KERNEL))
>   		goto err;
> -	cpumask_copy(wq->cpu_mask, cpu_possible_mask);
> +	cpuset_cpus_allowed(data->task, wq->cpu_mask);
>   	wq->acct[IO_WQ_ACCT_BOUND].max_workers = bounded;
>   	wq->acct[IO_WQ_ACCT_UNBOUND].max_workers =
>   				task_rlimit(current, RLIMIT_NPROC);


