Return-Path: <io-uring+bounces-1977-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 90D358D1F00
	for <lists+io-uring@lfdr.de>; Tue, 28 May 2024 16:39:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 273E71F23323
	for <lists+io-uring@lfdr.de>; Tue, 28 May 2024 14:39:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2322D16F91C;
	Tue, 28 May 2024 14:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="S4z+EojQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9C073475
	for <io-uring@vger.kernel.org>; Tue, 28 May 2024 14:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716907151; cv=none; b=nw3Q5YZ/8zm3atdnv7z6UYxGAmQiBML7ZMNNd9eFby4oErDxALbjfm9Q3lnym/zj6FsAAPw0K0lzclveNsiP1ZRNaZUeHgFenYTdqIPuxcaSx2TtoB5R+4SrnhFZDng+Edx3d858WhT7QCSWYewbTQS5ctJA0p0NkrrHYLvc6eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716907151; c=relaxed/simple;
	bh=wjd77ka4tAktrQzDeiE8icpH0CPaRMLDiCih8nc6Bb4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=Xrc+UiUFUMFGAgyO4nG6NOrdV3qS8UUuCZ8a+yGp2yRvKZZamNryuCunZxbZaCQtEYOX4yooNltxfcrXfIeAqjUPQNQ2GY68zwJYnWUogDptsYDVDvCJD6lmsE+bOvxUUGJupUCocf8ypNDGej2R5S2nSvJzJLeW9JDVCvP+MJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=S4z+EojQ; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-5b97fb03132so91236eaf.2
        for <io-uring@vger.kernel.org>; Tue, 28 May 2024 07:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1716907147; x=1717511947; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CJOgMRUDnmBDniUt7ABK/yMryU39njYSwrO5MHUMWGk=;
        b=S4z+EojQLflPPwZvKHhMhUe5N35a0rNXJDsEDwf1wWOZwFxlk2z6saEh2jJgmhosrA
         9/DkfU+j/UXz3p0AgLxjTBKdc7oMRt4wnFyJxb1Vu1bYi3K5yeTFHysWzw7KkWYT8U/Z
         elH6COLx2jxmIX1/uSfrdZ1QgWfkGIp4DV5eJjU66TtJXnMkFQCLPZGGFaBudstv6cXo
         0+vHoSGL2DVJHciWShbRjXGbCX4bBlHUMZwaQJ8mUYO1tkuf5511GLxyjBR+h4N46pds
         FPnUOERDh5TLhuPUJvfCAZw+M0IIWRPG7RxJvViBFkoEKO7zH0t54MGK3zvWzVy0ZuyE
         dMEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716907147; x=1717511947;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CJOgMRUDnmBDniUt7ABK/yMryU39njYSwrO5MHUMWGk=;
        b=Kdgj6f7Tml5eUXc4d5qi33+YAi/BLAUqHA11aHz69Ac8ZRvNL2t9/VRJIAhwJe2kue
         qkx6IIO2Nt+vFUgn2OrAYpab4ldmPeJ3eErvrFrmGKAbUsrGVsQp3yi8sdr8s526pt6E
         4cihY61k0HrlMOhNVA9xk1mtpaW4ME6SedR1FHhnDVhEFq3EocGpxS+RUdtPacRi+FNP
         EsrhOdZchL6E8b1I2IjySZrHw1OqO3SXvE5ARmFzNJNM0qNzWqGfMGDsJpB5kovIHyPj
         KYkQp0k38YvbP1Nunzz6kQLp2gmpr8rJCLmfsGEkITQDZVbLf5tMbjlT5J++8dT0U/1v
         B+yg==
X-Forwarded-Encrypted: i=1; AJvYcCXWFW9FGwIEJejGJwNE3B37fIsxAAzKueHKp2WazdBREOafyT0PKn4atrSe+FBIO2z8FsrFUGjkSmTneoe+thWL2Sbnb30pTVs=
X-Gm-Message-State: AOJu0YzPC429fbTKxkiXKmWy5oYhBce17G32FccmmRDQujuAm8180tqp
	vv9WNC9jDtpdP+LjkqFqXWAFA/NMBwoCRy/qRNtvhhJtgtUJWqUyRAFz0dZHIiYue5/MSruiXXf
	9
X-Google-Smtp-Source: AGHT+IG7aDhdr0cHietO+/98Pt1ZAGHOy4L3OWG6RgylKJXJfoL1/+HXeLnE/Cn1qOPznDA49fYwSw==
X-Received: by 2002:a05:6830:2d86:b0:6f0:e2aa:ea49 with SMTP id 46e09a7af769-6f8d0ba7f9amr13446745a34.3.1716907147612;
        Tue, 28 May 2024 07:39:07 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-6f8d0daf302sm1937155a34.20.2024.05.28.07.39.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 May 2024 07:39:07 -0700 (PDT)
Message-ID: <d431bf6c-546f-4051-96bd-c8895d822f8f@kernel.dk>
Date: Tue, 28 May 2024 08:39:06 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET 0/3] Improve MSG_RING SINGLE_ISSUER performance
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20240524230501.20178-1-axboe@kernel.dk>
 <3571192b-238b-47a3-948d-1ecff5748c01@gmail.com>
 <94e3df4c-2dd3-4b8d-a65f-0db030276007@kernel.dk>
Content-Language: en-US
In-Reply-To: <94e3df4c-2dd3-4b8d-a65f-0db030276007@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/28/24 8:34 AM, Jens Axboe wrote:
> You could just make it io_kiocb based, but I did not want to get into
> foreign requests on remote rings. What would you envision with that
> approach, using our normal ring task_work for this instead? That would
> be an approach, obviously this one took a different path from the
> previous task_work driven approach.

Foreign io_kiocb itself isn't even enough, you'd need an overflow cqe
allocated upfront too for posting directly without waiting for the
reply. Basically it needs to be confident it'll post successfully on the
remote ring, otherwise we cannot complete the source msg ring sqe
inline.

-- 
Jens Axboe


