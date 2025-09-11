Return-Path: <io-uring+bounces-9738-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BD2CB53130
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 13:44:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D021560BCB
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 11:43:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEB87313539;
	Thu, 11 Sep 2025 11:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mpHfBY+N"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77E031D361
	for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 11:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757590727; cv=none; b=AG3+l6PigbTQnsuatthm0Gga5w8C5aYKoky6SeGN5/BJKgOkrOnIzngRvQg6gfWAeBDoeX6Z+jqJpMLy1+ZbccbFpdPnxNdI3VHVPZgIGYJewy6ZUUEUhNd6IePtnOAQj00vTVNRAaXa+Qq9isJvoFkfgH3BCeyP5jnPZv9hY30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757590727; c=relaxed/simple;
	bh=QI7YmJ+2L4HNw+xwuzl55g52MzkpTAGsdyWFZcS8w78=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=YwqIxSWwEHg0o2vmXqSf4w9wpmXN6PfHquezIRJbtzr5cckUBu97jIe5DrmMDYL6JsMZ/3KpBYKSdD5R0FnDTiB9aEtr4iLwGz4bIMnYHsJBPe+3EhZqojuxpaq5mbzcoGKN6+OWS+Lov0JdC9f6xEV+TjbBNK0YAXIVqYTktJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mpHfBY+N; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3d19699240dso1002176f8f.1
        for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 04:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757590724; x=1758195524; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D5zUT8DC7PzUZRuB7uen2bIXfEHlXbm0H4ETEn+p9GQ=;
        b=mpHfBY+N69zTAm3eDh8RmJeQ7lSUTa2butCfIC3lOyvJcW0mq9761F5wW2wU2tqksP
         0AoXxYxufgQglqHWC0bAffmb0n/5XgKBgzAvtqjUxT+wzpRzTqWOs+0MtGCw6grbce+n
         LOo+s5F/yfhErarhkonP4NLSu2tWIBUR0gk+/2zxarrvWhDdEQJddD8gAbh2XUl6aWej
         I+h8C6EIBF9rLs6avzeIfUsOxmRYF2uUmoB4i/hB5Tuy6HzNhr9UxL+uZzecEe3L5rew
         OBFC1oN+NhPo3k1eIa+LcI7wO2hom1KpN6nLuQA+is2JotiDuODHFfZhReCrCKmpitJw
         H3Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757590724; x=1758195524;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D5zUT8DC7PzUZRuB7uen2bIXfEHlXbm0H4ETEn+p9GQ=;
        b=GjlTQmadKUxvmR7sM+fpdJy2GckHspVcZZ5sMcAGm1GcXfw3nylXWk44aLByav6CFI
         fz1jBTWUzJ6Xa6+pF1Cg/C2xb6RmoP7XYrS3Hrk6Ua7HWynosnQc+ugaMLhPHDx852N9
         Z328iWdUtkD//52UIvfplVCgyKe8MyllQEfzitNuU5Ma95wrNuM0YYnpkYxHXQ74qUMR
         2LkHCwxBKKVoXnKghOpmZKdinW03iNP+xbM8VPQmHd3LQodqqcnX9MOu8M1KJpt3ZVGv
         CZRWONID8MGM6DE/Ej5gCdLvUHZpztff38O3RUmjdTl0rKKw0pQqdY807qmmqae69RB8
         ixdQ==
X-Forwarded-Encrypted: i=1; AJvYcCV3RDVdeiiPZRugKicha/rTl2l7S9VCUjZMyV3CiL4We+PXNB49wobelx5G+z2VMZT2WIRXcihduw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2lWZNVfd/230sosY5NHM56hYCz0KG+IJnLrqNBUUDUtiAIYUg
	Ty5/7wmNn1fYf3HH8ipiZmLsGkbVI2JgplqoQvcwmjI6eAW1JEEiPacu
X-Gm-Gg: ASbGncv7Ax4sf15PrtQ1mcpyvHd+TnpDlErvTB1L0uBR6Nsygkfe2nGQI4j7LaKJAPk
	lYD7SMbffqp78joHIs/CcC8mkpk5XHK+0KNxfODDdjZ6hdHE9xCPYOiXpYkav2jkutC19EnpRAg
	JTPAQ+LTxSPkHnLE/y4QXpHU4e8nPcceg3drdPiAaqMjD/hPGTo5U7Zh1iSDOawlz1rnrZXOTPk
	RcXHtCDKVN+hEuvU/ku8ekSrlILLXyVHgmAHubQr/oWHEFKLE0Pg4dgf/UpPzGg8+oqZBjX3+1i
	TpchmPFWOFl5JicVRTwXZryDf5Zuh0ciK+IE8LrarwM0idnTLVbnrnEMQzpvgRNEkIJh06NFl3F
	F2ffJ14M45yRl+qzoLLfMw5mOAEXR9UB6IajKSPwhoZm7Ftnj1LEcUaw=
X-Google-Smtp-Source: AGHT+IHdyaZMtS0EWsIyi8R2CUBlvXC09PMT/hUDhsu5U0vmzYjAG9net18SHOKJSfLxOxm1ykW5Jw==
X-Received: by 2002:a05:6000:4284:b0:3e2:a287:2cf2 with SMTP id ffacd0b85a97d-3e75e0f8619mr3459545f8f.23.1757590724009;
        Thu, 11 Sep 2025 04:38:44 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:a309])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e760787604sm2155719f8f.24.2025.09.11.04.38.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Sep 2025 04:38:43 -0700 (PDT)
Message-ID: <6e347e14-9549-4025-bc99-d184f8244446@gmail.com>
Date: Thu, 11 Sep 2025 12:40:16 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next] io_uring/query: check for loops in in_query()
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <2a4811de-1e35-428d-8784-a162c0e4ea8f@kernel.dk>
 <a686490e-03f0-4f21-a8d6-47451562682a@gmail.com>
Content-Language: en-US
In-Reply-To: <a686490e-03f0-4f21-a8d6-47451562682a@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/11/25 10:02, Pavel Begunkov wrote:
> On 9/11/25 01:13, Jens Axboe wrote:
>> io_query() loops over query items that the application or liburing
>> passes in. But it has no checking for a max number of items, or if a
>> loop could be present. If someone were to do:
>>
>>          struct io_uring_query_hdr hdr1, hdr2, hdr3;
>>
>>          hdr3.next_entry = &hdr1;
>>          hdr2.next_entry = &hdr3;
>>          hdr1.next_entry = &hdr2;
>>
>>          io_uring_register(fd, IORING_REGISTER_QUERY, &hdr1, 0);
>>
>> then it'll happily loop forever and process hdr1 -> hdr2 -> hdr3 and
>> then loop back to hdr1.
>>
>> Add a max cap for these kinds of cases, which is arbitrarily set to
>> 1024 as well. Since there's now a cap, it seems that it would be saner
>> to have this interface return the number of items processed. Eg 0..N
>> for success, and < 0 for an error. Then if someone does need to query
>> more than the supported number of items, they can do so iteratively.
> 
> That worsens usability. The user would have to know / count how
> many entries there was in the first place, retry, and do all
> handling. It'll be better to:
> 
> if (nr > (1U << 20))
>      return -ERANGE;
> if (fatal_signal_pending())
>      return -EINTR;
> ...
> return 0;
> 
> 
> 1M should be high enough for future proofing and to protect from
> mildly insane users (and would still be fast enough). I also had
> cond_resched() in some version, but apparently it got lost as
> well.

Tested the diff below, works well enough. 1M breaks out after a
second even in a very underpowered VM.


commit 49f9c37c612967f9a6111e113c072aace68099bf
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Thu Sep 11 12:28:18 2025 +0100

     io_uring/query: prevent infinite loops
     
     If the query chain forms a cycle, the interface will loop indefinitely.
     Cap the number of iterations at 1M, that should hopefully be enough for
     even the most inventive future use of the interface. Also make sure it
     checks for fatal signals and reschedules when necessary.
     
     Fixes: c265ae75f900 ("io_uring: introduce io_uring querying")
     Reported-by: Jens Axboe <axboe@kernel.dk>
     Suggested-by: Jens Axboe <axboe@kernel.dk>
     Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

diff --git a/io_uring/query.c b/io_uring/query.c
index 9eed0f371956..1af40e5e9a2a 100644
--- a/io_uring/query.c
+++ b/io_uring/query.c
@@ -6,6 +6,7 @@
  #include "io_uring.h"
  
  #define IO_MAX_QUERY_SIZE		(sizeof(struct io_uring_query_opcode))
+#define IO_MAX_QUERY_ENTRIES		(1U << 20)
  
  static ssize_t io_query_ops(void *data)
  {
@@ -74,7 +75,7 @@ int io_query(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
  {
  	char entry_buffer[IO_MAX_QUERY_SIZE];
  	void __user *uhdr = arg;
-	int ret;
+	int ret, nr = 0;
  
  	memset(entry_buffer, 0, sizeof(entry_buffer));
  
@@ -88,6 +89,13 @@ int io_query(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
  		if (ret)
  			return ret;
  		uhdr = u64_to_user_ptr(next_hdr);
+
+		/* Have some limit to avoid a potential cycle */
+		if (++nr >= IO_MAX_QUERY_ENTRIES)
+			return -ERANGE;
+		if (fatal_signal_pending(current))
+			return -EINTR;
+		cond_resched();
  	}
  	return 0;
  }


