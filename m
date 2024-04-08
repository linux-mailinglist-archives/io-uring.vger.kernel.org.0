Return-Path: <io-uring+bounces-1462-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF61E89C82A
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 17:24:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C7DE283A56
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 15:24:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B783140383;
	Mon,  8 Apr 2024 15:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hlm0GUTu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587E713FD87
	for <io-uring@vger.kernel.org>; Mon,  8 Apr 2024 15:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712589840; cv=none; b=BKa1F6I9jciDd7M9x0gy61jymQoF1f/yculzsB9WnMqypfkleMSrepD9r6rdIEZEd6cV+MTGrXQ0ZNMjYVzTM1rTXnKYDYku7UDh+FrJP5BfggvjCcfsFdAA159Y/Qbi9z4qOtsCPSVwjA0E0jmvck1cnIfXeplZNpArtJnQFyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712589840; c=relaxed/simple;
	bh=9Tti1PE5C05IUQFb0CzfrpGNGyF0kYXSsHuB0mBmaZc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aN5IILi6/VnTRtrJaYjmcra56sydBB+gOvaSMLIrek7GG6ab30hKAPAoZ1u1Pl75cWNJ/TeIh4xGZI2lCfKJR3D5noEyW04OlUD8PVSicGtzqglHvPKdDtCdw7ZCTXNyGM7tOk+cBLyYvEvfkJZNxSfGNOBK6xdqxYuw7LTUInE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hlm0GUTu; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-516dd07d373so1277012e87.3
        for <io-uring@vger.kernel.org>; Mon, 08 Apr 2024 08:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712589836; x=1713194636; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oTsKwkpVBcjNVL20CC9OgFYxe5iLHFsiYASu4nkt+KQ=;
        b=Hlm0GUTuJk06/ebgfDfv3cWKplkQU2ghdpDF8QL+EkYtqROG2HJBHtKTD+MJRTJ0qC
         lseamxiJ90zjro0G1gJkDIoMmqjPbIJdzeN8lSBvZXkOcDnC82gkIhvaVidCDOuUSrOn
         SuemOhiSHWym736Waasj91yJDCTbFJgJJ2cET8+t6QJ7X1s5jhJq6woxZlYuC47Gl4oO
         cyJzw0FXKnbb7atMf1YcA9BueIq8Is6K5F2fxG7WZukSr61fZPSaWfvrxjZRrfzjiDSu
         j5qVvrbmdNF+WVHQEQKMixXHl7V7AhaaJRJh7zSQAH2IqMQi2hSsP0XQdgjdmKUAkhMt
         jmGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712589836; x=1713194636;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oTsKwkpVBcjNVL20CC9OgFYxe5iLHFsiYASu4nkt+KQ=;
        b=ZjKmd7zWpFbljA8ULaNLdnC2MFNkkfxpytuwaAWM9g/2c6a9kvb7EksBp+BdxxbZfi
         LJGdJc4J8jMvJ52MeZ8JB8W5putmFxwFbaoMqXu+wQjVQVh0Vz2ghF9ECzPzEnkSwVzU
         FixCjF8aKaDh1yLdFqiVPjf1ZKFYyKAL8ziz0udy3yJ3GMJAMmP6xUdMcmpckeP3H1ZI
         VxbFxq40YwxIe8B14LOXUCLI1pT3rnHlVzmNmjOLeHnG0WTBu1//BnjFoB9wD0cEKcj0
         FIDlPEToF/YO/mBCtSO9XMI8la+0XGkqFia32S/Dt+UF8r7x2MfXHZet/O/YVqP4MfYc
         CaFw==
X-Gm-Message-State: AOJu0YyNhB80lim7gxVgqhuqu25p8azhrFYOF2JUrn1vLicLiGIwU65C
	BipI8idDG1EfET+Cjwd9/hdLJdUV/F1CeEJ1HGaruUUUwoG/oyGknklxs6pV
X-Google-Smtp-Source: AGHT+IHZhhSbTT6zQbXI6KZgoa6iXG7w3Qy6T2/jz+Mpndu9xQyWGijqEIn5UZk2lX5qPc+B+4PpiA==
X-Received: by 2002:a05:6512:2387:b0:513:5951:61a4 with SMTP id c7-20020a056512238700b00513595161a4mr6503324lfv.6.1712589835831;
        Mon, 08 Apr 2024 08:23:55 -0700 (PDT)
Received: from [192.168.42.195] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id fi9-20020a056402550900b0056bdc4a5cd6sm4150738edb.62.2024.04.08.08.23.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Apr 2024 08:23:55 -0700 (PDT)
Message-ID: <f8a47d94-f9e0-4150-9e2e-7ff2900cdd83@gmail.com>
Date: Mon, 8 Apr 2024 16:23:54 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 3/3] io_uring/sendzc: add DEFER_TASKRUN testing
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
References: <cover.1712585927.git.asml.silence@gmail.com>
 <83567247122f6b3d4206dcd8f874651703184792.1712585927.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <83567247122f6b3d4206dcd8f874651703184792.1712585927.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/8/24 15:24, Pavel Begunkov wrote:
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   test/send-zerocopy.c | 166 +++++++++++++++++++++++++++----------------
>   1 file changed, 106 insertions(+), 60 deletions(-)
> 
> diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
> index bfb15d2..4699cf6 100644
> --- a/test/send-zerocopy.c
> +++ b/test/send-zerocopy.c
> @@ -769,12 +769,69 @@ static int test_invalid_zc(int fds[2])
>   	return 0;
>   }
>   
> -int main(int argc, char *argv[])
> +static int run_basic_tests(void)
>   {
>   	struct sockaddr_storage addr;
> -	struct io_uring ring;
> -	int i, ret, sp[2];
> +	int ret, i, sp[2];
> +
> +	/* create TCP IPv6 pair */
> +	ret = create_socketpair_ip(&addr, &sp[0], &sp[1], true, true, false, true);
> +	if (ret) {
> +		fprintf(stderr, "sock prep failed %d\n", ret);
> +		return -1;
> +	}
> +
> +	for (i = 0; i < 2; i++) {
> +		struct io_uring ring;
> +		unsigned ring_flags = 0;
> +
> +		if (i & 1)
> +			ring_flags |= IORING_SETUP_DEFER_TASKRUN;

That's not right, it's missing SINGLE_ISSUER and then skips the
test. I'll resend

-- 
Pavel Begunkov

