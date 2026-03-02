Return-Path: <io-uring+bounces-12513-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WHWVOEi8pWn8FQAAu9opvQ
	(envelope-from <io-uring+bounces-12513-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 17:35:20 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C3C61DCF57
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 17:35:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 53D88303B4C9
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2026 16:28:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8859F2F3C13;
	Mon,  2 Mar 2026 16:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YsGA+TLm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DFC364038
	for <io-uring@vger.kernel.org>; Mon,  2 Mar 2026 16:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772468929; cv=none; b=DgUluxk4aiAeqVNdhSNIyQCw0WfNhOBTVnJKrdoCjqTT/Huq18ASd0DrI9y/68qJp4RqW44D2sOl8df9HKpKy14VhuIKao8wrZ3pQFImMQJo04r/mW6Dlz36f1yEu3a05sx1g1uOjUCQJHtNNNT4TBtEGYlr11TahKNhVQjm97I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772468929; c=relaxed/simple;
	bh=H/3h5AXOS5WQAuvECHje4+hBpxw2lroEnJ9rk6aavqw=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=LQFTRdpzYDnBSTy7Z5WVPcXdZSSnyShmTgLtjhVJP1REnQDHgh089s7LcFYpV1yM0ERuTf4FRgAgNvsWmgPHtEAI7EgFSLERKqYQg6Q+XyLEhCvV+yJ7N0yudqwT5U1t3jkD+kO2CPVkDclGab6NSVSu7sSjaPPmOrQghiyQONs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YsGA+TLm; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-899aede64e8so43953566d6.1
        for <io-uring@vger.kernel.org>; Mon, 02 Mar 2026 08:28:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772468927; x=1773073727; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lof3znx9pC1SeCY3Z1eFlMRuYmH1KqQXA50mK4U9hCQ=;
        b=YsGA+TLmrjCyL4guZ0HKN1QXepRuo+PH10ieExd9aXqcleioW236ylFdD19v3fuHjc
         x7TRWdnm90vN7za/KlT6O7NZ8IhpEm4pnAjPgtpBR4R9ALsp6tRcHcV+oF0VcGxtuNCA
         bs3iP7gNegwqmwO0TTbddEOFdpg6dZ771JkzAx3UQs5p2RvLL5+Tu0XE+ogMx5k864sK
         7TioWh8i9q0oSe1X1ry1JpSwS5p0EXFmAdzOCFYyeeXiC+0/w2Q3VjK13F/ZhEtYJWRs
         B+HVmP7GxLyKJUYWbRfFPH0ELOXkJ0hRTdKtoBJ3oXa1s6WV2mlhVyfB9IoSkrCiJOYH
         mkQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772468927; x=1773073727;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Lof3znx9pC1SeCY3Z1eFlMRuYmH1KqQXA50mK4U9hCQ=;
        b=TnxpzzyTzl65pSIoT0OzjDVZGof+O9cd/u+jatFf+VVVUA+F8RY114XH6Q8Q3glHeg
         RF15dZpSPj4k38dOtiNO28MtUhUMV5zObxUxP8qSiOgkKlz8zV7GQJqST29/e6e6IY5d
         kDzGcERWkc01ypalRqpQKfJcOaVqRtkMguaGouXohgLzKdzPa0D3wrJx6BE+gOjmwbEM
         OiYSDrS1iPfyuc530SqOxqraJKTdQ2z4A9AUzkRHbLzQ/3HA8Y8EYuxRw0cwYunaqz9n
         yknyMVU9o8HQ8VaG4aU08kiSdq9T4daXf+uOQ4OsQNbswynulEWz66WzY6T4IHB1psvj
         seXA==
X-Gm-Message-State: AOJu0YxOCrOnWyJaWELnFxtMGkFrmSE8mdH0oZlVXZ4MSRBllNjjFusJ
	rmgCehZjyiEBpLnNlWrko38bU1iUBS7LChbQpzgELPNjQ/I3q6XpeSW2e6Nd8S+mV9dnZHQRiTg
	GXAEcVVk=
X-Gm-Gg: ATEYQzwGytxVN+pgp/LKjtspsEF/9LuGzqo7rwoautA7eer9VA8FYziKaz/uKen0le2
	5gNpJyczsspETxOTYeukYd0O7aZp5Nmh7KfDuVMQRgD5YvV1qGW20xtwaXm2t/Vpy+Znv5ju8uc
	/s8le8G6lqams2VWm5jCWwHNrs21Y3Fjp+GirpJbqNg9B4TJsEZhkVHg3VKGvwWKGpbSpne393i
	FsASTy7ws52ktYVLN5G98XMpZO1NU2obAOBqnoOVmfUTemHsd7SS2cingYGYP+Dhzry+97elATP
	hbpYnTniU3Ovc8nK7yUntOV2c1v6F3w5RgC07AvNNHwsBH6w6G6ff90U1M9CqA4tJtAnnRGlQsP
	U7O3qaI7y3TL7VgBbnF1eybKTD9Hn0QVu9wPvtZm91aaNXk0+c+inyJ3WmbStv61l71RThhEHNC
	f1ICv22lZU8KZVJj0MSgMjTOmlpMEaRG4guCxeqaqTe2sPlnvF4Fme7f8dPqmzaqhFNYni/ek6Q
	jo=
X-Received: by 2002:a05:6214:cc1:b0:899:ac8c:dacd with SMTP id 6a1803df08f44-899d2023ac1mr153642376d6.26.1772468927245;
        Mon, 02 Mar 2026 08:28:47 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a04849cb3sm9035126d6.6.2026.03.02.08.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 08:28:46 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1772456786.git.asml.silence@gmail.com>
References: <cover.1772456786.git.asml.silence@gmail.com>
Subject: Re: [PATCH v3 0/4] timeout immediate arg
Message-Id: <177246892619.112159.9148726991074312317.b4-ty@kernel.dk>
Date: Mon, 02 Mar 2026 09:28:46 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Rspamd-Queue-Id: 6C3C61DCF57
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12513-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action


On Mon, 02 Mar 2026 13:10:33 +0000, Pavel Begunkov wrote:
> Allow the user to pass the timeout value inside the SQE instead of
> pointing to a timespec, people asked for it as it makes user space
> simpler. More details description is in Patch 4.
> 
> v3: Enable the feature for the abs timeout mode
>     Convert internal request handling to ktime
>     Validate unused SQE fields for timeout reqs
> v2: ditto for timeout updates
> 
> [...]

Applied, thanks!

[1/4] io_uring/timeout: check unused sqe fields
      commit: db74fcdb2659790cca5a2be7317c703f18289cc8
[2/4] io_uring/timeout: add helper for parsing user time
      commit: e23b896d6b3aa9167206f60abba2d17a188ef010
[3/4] io_uring/timeout: migrate reqs from ts64 to ktime
      commit: e4f28b04894d2d2ced34b1fbc89238881c3a9fdd
[4/4] io_uring/timeout: immediate timeout arg
      commit: ee1d7dc3399054247e6146d8ce35bcd5ab8f2bd1

Best regards,
-- 
Jens Axboe




