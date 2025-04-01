Return-Path: <io-uring+bounces-7348-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C326A78036
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 18:24:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7EC8116FC89
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 16:20:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD13220D4F8;
	Tue,  1 Apr 2025 16:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dgiu43TZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C865A213240
	for <io-uring@vger.kernel.org>; Tue,  1 Apr 2025 16:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743524012; cv=none; b=M04A3p9L7h7BKBIcq7IPMh6jHNVRfHm2hc6bAFm+fGitkuTEnmkXpMO5AhmeHabsKZlTe0UEW/7rvZ9uRvfRKnMSI8MvaJ5MRr3DOtVY4LCCqmKt7m/KLyolqfM8c21SO/Yjv2vZdd4i6BA2Wz+V7Iavy3IM71IsBIUOME6bHYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743524012; c=relaxed/simple;
	bh=x1sZes37bkNAV4PZM/FDi5+EDjdAwj6nkiHn54Y817s=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=VP5dJfDUk+rqoPhjAiiqq4d5j92U6wp6DZ+H0KyzSm64UltOgyFl+kq0Zdqq88G9bnx1PMQiW1Ou+E8+pZBqTbPwma1yij2mK/XLJZmNDTrpf8JEhBqF4pLWPRiw0Z6tLiE6jn03+8MwGmvXqOIK8fRAi4duYffDZyuZV81tQo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dgiu43TZ; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-85e1b1f08a5so133389339f.2
        for <io-uring@vger.kernel.org>; Tue, 01 Apr 2025 09:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743524009; x=1744128809; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=crYPG9KAfumDvhww+Tnd6Ddcecr+v2JwT03XGk7Szzw=;
        b=dgiu43TZc2OSLNA1di0N6314WYp3bHQaESRv1l0/SaXKWyjOMfNdJN6R7sP/5yzx18
         gVfwYE+743hyrYtiAmsfFNSEW34fTv9MxP/6Esn5bh2alUDWO4B3smPehnpfHg9LeucB
         ExvfWr5piZ6KQAXUFnHng1Lt9kreTAP1pdkBNtvhWhOpPtBBblqzUHGWPc25O5xzQ1zI
         gNokdXf3TEXh/SaOh+V+hLYc1Kgok3d8izfv7cWPHJ8pq+wPDzZkISHPqGYitTKFZ+uD
         8By8A8VjkUqP4+xiOT9jxijEtkU0gk+78unRDG3ddMQmo3ttUUfrYsQQ8CXQ9ND12LRA
         743g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743524009; x=1744128809;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=crYPG9KAfumDvhww+Tnd6Ddcecr+v2JwT03XGk7Szzw=;
        b=BdCNmrIoC3TSdxT7a8xyuZ8mqxKB40RnbBC7KihZHkGysM7XnN8wjdg818Y/vjZrwb
         1vMx38VWljjqxB99V/nPFCNNb6TsCbHOGPn3HcnDfBMyYw0g+7Hhitw6jqRoXYLIoAzb
         9h5lLLUmYkpYk1sANIvtanR47kfqHV37BQTvVh35TgJcJlmEnCGOHUkgQzIbKjBLgWVw
         IgiMh177iaNnL8SVZeoO+s7Zk3r1bZmx4vlzR8FizQb2UqlJdkwBa7eeNgWvmuIyyvWS
         Gm/FEOPXSpnOoPFH0RWWIE2VUkl5zItbxLHPK07ZllmrYHchy9DadPT0X7T1DpqVydI9
         xRUg==
X-Forwarded-Encrypted: i=1; AJvYcCVsXM0Nqg1wlsOm4Z05bd6cPNwepc4dLdrDqO/u0bBxEZ3eu258BCIk++SlgsaNoYkys5bpv16yBQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4p5HtPp2/EOhjuMq77X4UairKjhY3x6Kuc7DK+d7v9Slb4ttd
	C89/9mkZ76BL70NjhRHXWECiEMJW1C9z4wzwMzAqsBD6xk27xJ+4C+XHxozVtMY=
X-Gm-Gg: ASbGncv0IOQ7FEoX67HpWMPQ3KFmiDTWI6fevEBF1eXT+fXKQOSZNYsvefobxovgnU3
	EiKYHKMzjI75AbV0ROHg3U0Ol93LuR0MiAiAgk433kMe8qbY6lX4X3p7P0PP6KppBOAmoR8OOiz
	VXM8AREdkWf/Mk7MWBQU9P13Y7toCmTdnk6eWDcdGk0S7a2IFvLEUF+ZrZUd6MF7I0MO55UZZhI
	9A7HmCkWEjPLgxAPxQg3QFbR3sNps/yPq3laiSC+BZdEjpoDsQUntJ0RSS4TwxBxC/kPF0dJ97Z
	Ia0safFCYoGnOou7eqGzXQdK/sxF2023MYL/B5dn4A==
X-Google-Smtp-Source: AGHT+IEQuxqU6W0i2KV7/oh5TeZrFFWbyo7vnf/AfwrpX3AAoL8zL9J1fkgVgW4pxIPF7NrabRaung==
X-Received: by 2002:a05:6602:6a8b:b0:85b:4940:65ab with SMTP id ca18e2360f4ac-85e9e865794mr1373580239f.5.1743524008384;
        Tue, 01 Apr 2025 09:13:28 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-85e8ff80297sm203241339f.7.2025.04.01.09.13.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Apr 2025 09:13:27 -0700 (PDT)
Message-ID: <65765d68-cda0-41fb-acdf-58e7b5c1243f@kernel.dk>
Date: Tue, 1 Apr 2025 10:13:27 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: add lockdep checks for io_handle_tw_list
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <ffd30102aee729e48911f595d1c05804e59b0403.1743522348.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ffd30102aee729e48911f595d1c05804e59b0403.1743522348.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/1/25 9:46 AM, Pavel Begunkov wrote:
> Add a lockdep check to io_handle_tw_list() verifying that the context is
> locked and no task work drops it by accident.

I think we'd want a bit more of a "why" explanation here, but I can add
that while committing.

> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 6df996d01ccf..13e0b48d1aac 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1054,6 +1054,10 @@ struct llist_node *io_handle_tw_list(struct llist_node *node,
>  			mutex_lock(&ctx->uring_lock);
>  			percpu_ref_get(&ctx->refs);
>  		}
> +
> +		lockdep_assert(req->ctx == ctx);
> +		lockdep_assert_held(&ctx->uring_lock);
> +
>  		INDIRECT_CALL_2(req->io_task_work.func,
>  				io_poll_task_func, io_req_rw_complete,
>  				req, ts);

If the assumption is that some previous tw messed things up, might not
be a bad idea to include dumping of that if one of the above lockdep
asserts fail? Preferably in such a way that code generation is the same
when lockdep isn't set...

-- 
Jens Axboe

