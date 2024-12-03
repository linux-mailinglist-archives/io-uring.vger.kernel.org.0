Return-Path: <io-uring+bounces-5192-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C0C49E1EF8
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 15:24:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1DBA7280F45
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 14:24:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63E411F6664;
	Tue,  3 Dec 2024 14:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cyrqY2O3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C611F4730;
	Tue,  3 Dec 2024 14:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733235834; cv=none; b=H6rMvfrDSs6D6SFatqCJ8TxH6EvCKpbotwBYdlqOQB/ZcvYRRQL+PaclQdVNavlIjLNB1fP1In/dkaCIeE5dU6DmX9UlxOS1cKgGcvO9jo6+eaW6ni7aSZCHCyVaog1HYuOKdHtZrt1UKYrJRJaEZxt19oG7w2ArQepQIc5M1sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733235834; c=relaxed/simple;
	bh=GEGswRiLiJjvgpO7PtOriaWEjx1G/fkS76tvSW7G3JI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sk6W5fs9PDvhKXMTGW0SizniIuhk+m9dmERuXazLPTj8khvbu6aW89opyjDrilpQRGcrhTYWOh+REYORu4sbovaSMFCASTsbeD9MCw8txvWPMx7I6QCvCc8fYjv3wE39aWO44xH9ntLyLnNYgSZ+8pwgbFTdMQUZtCWzQ+XlQSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cyrqY2O3; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-aa52bb7beceso640343566b.3;
        Tue, 03 Dec 2024 06:23:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733235831; x=1733840631; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ycevanaHbIdtBTfowEreiZr9retqDIhJGzAsK2gLEJA=;
        b=cyrqY2O3VH8YhckYfAduiRu+9PWJTOHC1J6agTjqqQijw/iGKjFnieqTiU6uOJ8vFK
         B7XDMx2XlaxF41VPX5/da7cxMrLW6IfCQhBM+4HPo9UEctuIlSy1AxEAz+Al5KhD1w6F
         9ZBRl/5qnZek7QgT9MMjGPDU5i4ofNVSoqYTSqK9gI4cZLVF0gbiYaLtp054j/n0z9aB
         9QuOqC4WZGse5DDV61/9PUvRJ5OEUVMHnMJp+MaoE6SvkhumH2mAM1dtQXLNlgcn9sBV
         bOwPpB4tXhKoBTRDehqdSnDeWxr5DCVn+FNWRq+c6l/ojY4bym1IQVbTYmzrIxnqAwTS
         xbKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733235831; x=1733840631;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ycevanaHbIdtBTfowEreiZr9retqDIhJGzAsK2gLEJA=;
        b=L/t1xfHpVxxnxUN3AAIWmfuKqiZiGLrGQXTkw1gh4yToqzcv1BiakZl0HLMyCY/zpQ
         zHChLDN8iqNZd8DNkPeLouvXSpwYAa4VxUtjsy0GQfpu6C/4nPUi8JDd+r5mMw2h8LHw
         RdsDMa7IxqyBLDkQyjiSqbTlVQWFs/6kSKRqBgPh9VwKNnVBcsOkYQJM+3XCmQ7AnGit
         Uqe4bC5rGeep3TYOL7e4ycc9BQeozEl6vyN/3xLF+s1Q1yNYEN81//sDGwh/I5ant1IN
         Ztp99emY44FN4Urrt6ny/IPXWRekZE3bISF6h0MRTKFfrpLGVTKm6xwOCymn/KLO3jxc
         568Q==
X-Forwarded-Encrypted: i=1; AJvYcCU47Pv7SbEaE6p+IOE83JLrFRXSrsCLIR/HEwW5BK865ySj2aoHsTu/uSufhALMfJv1MkKweheowZ6brbmPOw==@vger.kernel.org, AJvYcCWB5B4DZuJZJYtidaoFBZhf++pYicbmilCWIH/Ed1W6yJF6Vl9Ctkhkz53+KdrGmlWY1q0PoxAk0Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4kLS/ZzfcxyXUrPybK8NPD/RKYJe11mpI45H+nnNBxQSgAGCC
	uwALTh+jfUZH7NQygnjb7rgCv7UO2yxnbXKUKeneo2bEWlr0tMDzVJnpIQ==
X-Gm-Gg: ASbGncvh63z/D7VFILG5aBhgCVnNZ/lWYTTOk1aiImmfzKe8WdmnYdzTnjZG3N7AiA9
	to4Ltk8UGB0SR78hxdN13YErChv0Wf36q/vAnsPe95Wl87/yGCAa4EY8iZy0C7TUJmuQ4vslrJT
	H8kxTuOpXbs6Pfz0VL5Ln+YYE6bxYTO84XpoLsQdT0H/zpHpuMUYFy5wToRKrhVidWLoFqZ8+Ba
	WlQ06dxBUzkdnxtGXAbq64BBfMecCgzD9TmnZIZxABH2chFBfMihpQuQhAO3A==
X-Google-Smtp-Source: AGHT+IFoRRiv2aN7LwAahZQ+T9x+G79dCuivWaAX18jIIgD1tsDYYaWgIWICJeCO3Cd2WBC3OX3mUA==
X-Received: by 2002:a17:906:3199:b0:aa5:30a6:13d3 with SMTP id a640c23a62f3a-aa5f7daba95mr217668566b.27.1733235830691;
        Tue, 03 Dec 2024 06:23:50 -0800 (PST)
Received: from [192.168.42.182] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa5996c13f2sm626346766b.2.2024.12.03.06.23.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2024 06:23:50 -0800 (PST)
Message-ID: <57546d3d-1f62-4776-ba0c-f6a8271ee612@gmail.com>
Date: Tue, 3 Dec 2024 14:24:46 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v7 00/16] fuse: fuse-over-io-uring
To: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>,
 bernd@bsbernd.com
References: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/27/24 13:40, Bernd Schubert wrote:
> [I removed RFC status as the design should be in place now
> and as xfstests pass. I still reviewing patches myself, though
> and also repeatings tests with different queue sizes.]

I left a few comments, but it looks sane. At least on the io_uring
side nothing weird caught my eye. Cancellations might be a bit
worrisome as usual, so would be nice to give it a good run with
sanitizers.

> This adds support for uring communication between kernel and
> userspace daemon using opcode the IORING_OP_URING_CMD. The basic
> approach was taken from ublk.
> 
> Motivation for these patches is all to increase fuse performance,
> by:
> - Reducing kernel/userspace context switches
>      - Part of that is given by the ring ring - handling multiple
>        requests on either side of kernel/userspace without the need
>        to switch per request
>      - Part of that is FUSE_URING_REQ_COMMIT_AND_FETCH, i.e. submitting
>        the result of a request and fetching the next fuse request
>        in one step. In contrary to legacy read/write to /dev/fuse
> - Core and numa affinity - one ring per core, which allows to
>    avoid cpu core context switches
> 
> A more detailed motivation description can be found in the
> introction of previous patch series
> https://lore.kernel.org/r/20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com
> That description also includes benchmark results with RFCv1.
> Performance with the current series needs to be tested, but will
> be lower, as several optimization patches are missing, like
> wake-up on the same core. These optimizations will be submitted
> after merging the main changes.
-- 
Pavel Begunkov


