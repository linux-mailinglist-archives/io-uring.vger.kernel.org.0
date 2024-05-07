Return-Path: <io-uring+bounces-1811-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2692F8BEA27
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 19:13:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C96B2B2A5F6
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 17:09:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D04316C845;
	Tue,  7 May 2024 17:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="F7uOl27M"
X-Original-To: io-uring@vger.kernel.org
Received: from msa.smtpout.orange.fr (smtp-71.smtpout.orange.fr [80.12.242.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4B516C6A0;
	Tue,  7 May 2024 17:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715101712; cv=none; b=pULo1BMxpYO49OLnlgoBQSn3H8wrSHtJv64r/eNerVDVXMb1Y0LWHlkWAIrvJ/qPn3UHiJr+9Ecxd4uvBENiYFrleWlflOhLQiiIxBzddR44+mmafg51c/3giHLY3FsJwO0xhziSi9sJGXmvOPkp3tYbMWurX1t74oLh6KRHeC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715101712; c=relaxed/simple;
	bh=YER7gzQN8vR+dUrNqJYh4yp9BQl12GcuPdIaBB/It4E=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=LWQtKuFOqM2LmM6naweaLiF/pLe72Axmw3uDFK30gJ3qN5elFweg5IveawJgPac63KYJC0NeeqaLkodWX+2YNswx8+r5A/LxbUKs8QVAISOstmgxvYlu9g75+Jk3OGe7dHZ2ZJIvR6MtpK8u8YC8tHuNOgE7PjHr6l0xMjY7G3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=F7uOl27M; arc=none smtp.client-ip=80.12.242.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Received: from [192.168.1.37] ([86.243.17.157])
	by smtp.orange.fr with ESMTPA
	id 4NmOsXZ4Obh6Q4NmOsmkDW; Tue, 07 May 2024 18:35:02 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1715099702;
	bh=eecUBrjzZFlKhop2/+Jd/2n9Y8uQHQJpZaSD3Xf2tZw=;
	h=Message-ID:Date:MIME-Version:From:Subject:To;
	b=F7uOl27MZLjpRbpqI/ges5e0txwnLxb+8Y/NjPRIKQqxtuknZkgkgafiD6oxCxGJb
	 UaTReDfCCUUQuJx0vU3+fkaGcX8kEkD+2E4srW87D16Zio3q3hiv9YI6GxNVUkLljD
	 P4JnWcyBkMdEprH+JWDEcSg3ulHHX5e+FKdajNKimaTQkpLUzm0j0bd3NeNrM9I9Dy
	 K8pNXt7x3R98asKxlg5VDCHOWOWizDPnbpCHiKVqu6ChqnxZXtobYsx7f67Ez0vLDK
	 +jciSdbiXjlQPP/5IH7Su+W5l0yshy41nITwIKYNDXbHjwr7PScpZzFT3FwBD75jGN
	 /jK6leSYhQBBQ==
X-ME-Helo: [192.168.1.37]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 07 May 2024 18:35:02 +0200
X-ME-IP: 86.243.17.157
Message-ID: <7ce84a03-d682-45aa-a67c-b789e3e90499@wanadoo.fr>
Date: Tue, 7 May 2024 18:34:59 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH v2] io_uring/io-wq: Use set_bit() and test_bit() at
 worker->flags
To: Jens Axboe <axboe@kernel.dk>, Breno Leitao <leitao@debian.org>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: "open list:IO_URING" <io-uring@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
References: <20240507150506.1748059-1-leitao@debian.org>
 <d7d87db7-af34-4d48-8e26-ac13b5abced9@kernel.dk>
Content-Language: en-MW
In-Reply-To: <d7d87db7-af34-4d48-8e26-ac13b5abced9@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 07/05/2024 à 17:09, Jens Axboe a écrit :
> On 5/7/24 9:05 AM, Breno Leitao wrote:
>> @@ -631,7 +631,7 @@ static int io_wq_worker(void *data)
>>   	bool exit_mask = false, last_timeout = false;
>>   	char buf[TASK_COMM_LEN];
>>   
>> -	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
>> +	set_mask_bits(&worker->flags, 0, IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
> 
> This takes a mask, no? I think this should be:
> 
> set_mask_bits(&worker->flags, 0, BIT(IO_WORKER_F_UP) | BIT(IO_WORKER_F_RUNNING);
> 
> Hmm?
> 

Because of that:

  enum {
-	IO_WORKER_F_UP		= 1,	/* up and active */
-	IO_WORKER_F_RUNNING	= 2,	/* account as running */
-	IO_WORKER_F_FREE	= 4,	/* worker on free list */
-	IO_WORKER_F_BOUND	= 8,	/* is doing bounded work */
+	IO_WORKER_F_UP		= 0,	/* up and active */
+	IO_WORKER_F_RUNNING	= 1,	/* account as running */
+	IO_WORKER_F_FREE	= 2,	/* worker on free list */
+	IO_WORKER_F_BOUND	= 3,	/* is doing bounded work */
  };

yes, now, BIT() is needed.


CJ

