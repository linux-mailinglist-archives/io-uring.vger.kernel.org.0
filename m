Return-Path: <io-uring+bounces-10429-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id C784FC3DCE7
	for <lists+io-uring@lfdr.de>; Fri, 07 Nov 2025 00:23:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5EE7D34C645
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 23:23:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EF29357A2E;
	Thu,  6 Nov 2025 23:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="3G1DDF1J"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC9F35773E
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 23:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762471295; cv=none; b=LTLWlWLGAxpvb4yN+uc40ydz1ryebCrY8QY3dzrLe0H68alVA6KI5oyboKhMzclidg+jHCdXtMkMMe3tqOgMpv5tHOg0RczRJ0778BJCmzdb2XCiEvVwIZc4szpalcNuy88JJQSczGm54e38DUkxtNRG8W+42Bz0LfmwlFIepAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762471295; c=relaxed/simple;
	bh=Bssuky49KgzsBbl93nxGJPM72qehHS0AHF2yOa7tEJo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=vFFRaE/kLrYsocxCnlVJwoLNROdbb5Skc6oCFaAw+v4VR0ksYU42jKPKhMY03n2sBlTBq6phTaovSEZGCGjkoP0AtdBdrrmxb9Hbn5r8J/lGZh+yGZlDrh9xoCa4FZSbWMWW2zFQEUSjUbVtjL5A2HLczQe0QzuQtHPb38cnJtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=3G1DDF1J; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ed7024c8c5so1247351cf.3
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 15:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762471291; x=1763076091; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jgqQMv8vC1wnvm8jLlkIn4alZVszPP8l8LlzETRj8QA=;
        b=3G1DDF1JFmZfPkbOQeJ8B96axX0JFB/PgZsEhVJ6kEVsVq9Pux5msW2qh79rORZhwq
         NkVo2fiUmLhZEk2C5FOe1qB4a9l8JkQIMxL5gx2HEoLgD3IW7WrkluhnDdFhC659EW3K
         ZnTJzsXzc0ZUT75fyqtWOkVmVZWq8YxED3XRH0D/wi5ivOCu4cHI9xLHeDC4VJGALncy
         Bq2MRqXA7A9GEjafBmSjRe7lVNmjDJqKXM9WYY9dKvTI5+9B0m7StRN/2vLE83bmE4LG
         1fqcwoWXczip1F3eKYr6NWC/rKipoCRbBgOQKeub7cyosIqyC66Z1WRG5DBMV++BIetg
         fFpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762471291; x=1763076091;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jgqQMv8vC1wnvm8jLlkIn4alZVszPP8l8LlzETRj8QA=;
        b=JeegKXL/ZIciPlc2JrUNX5a5gN4PLlAlTNtWY+9hqa43tUstJ3bxJd0GQpP5NvkMkO
         QS2PxxsiOXdT3BB7De4qI4DIqBUxJd3Jogea9fJcGxd2ItJNV11o7eQVaMVovqZFdY5I
         zMuuw5UZNj609IILdUKHtLYr/MVIIYIGi+0F9RRnhfF3neMSeSbN6UAOaZdsHkdHpglj
         i6X9QFTco1+B8iV/XirdpRtVcrnc3wVf+FPOSgxDiAinbNiYoYoyM81L1+zv5ISeh7Cs
         ODWsbDqHdH8WSsYmRERBrCx35ORffbam+FCz9MsJMwlm2yt4552d8x2/f2df2n85A/TE
         dTuA==
X-Forwarded-Encrypted: i=1; AJvYcCV2qVhFEMPNAgX4OUR1xUZ0SOqp5rK2K154B5Wy7eySYT+rYB05sFaRdWpi5Me94YOYotdT7/E24A==@vger.kernel.org
X-Gm-Message-State: AOJu0YwiInvD0tRGkTC98OMaJmkgsdRePKdHwzO/0vqWnOxAn5PUNrOv
	zxefWjP0SA36eMFOyAOqvOdHNWCVqjER5SNWnssodtbl1BCdUVbLxUtYgtI/i7qIp4P922bADEx
	JwvP9
X-Gm-Gg: ASbGncvPDjOoZvz0WVmOE9h+pq+sg5ohqqCH4Qqd1DixI3elipXJcdEPUPHhb+Plhdh
	3ybFjIuuOtrBCCoVzmN3tewYunRZStGo44HnwsDHhI+OuKcotvBfz/BgFDXotDkaNXhXDJ9VOp/
	mEjZLea8/vaMR+UGBmS7cHTR7dbs8UKx0VHxVr8FI6Qvp7T5AULxfUXbmqU4nt/EkLWM0W08OQQ
	HXw+YixTzW3QTkXrQZO/RV573S1pYI3YXAwKFdLG3li3w4BTBFdRK8YIGqhMSI6pkEP+u4EhMFg
	2bJTSGz6pXyhfkKxRxJmwyygBYFc4eQRQTwkFTTwag52aJ4NdVRVpyDxKN9FC0C7pdreefVPVms
	3tSfrxq7A1j5JD1nR0CT6pBrUesOKIHWr8me414HlwEPSuzCus9cOsRI9ehdSbLtdanKLr4qD
X-Google-Smtp-Source: AGHT+IFs8nv2iSTBNiLQbQjkP0+tXreSWwWDjWUWICeAfSmO4PhPgvjHoBW7ZL7oOwk5O9rhFRsK0g==
X-Received: by 2002:a05:622a:2d5:b0:4e8:ae80:3e68 with SMTP id d75a77b69052e-4ed9496461fmr14560731cf.22.1762471290999;
        Thu, 06 Nov 2025 15:21:30 -0800 (PST)
Received: from [10.0.0.167] ([216.235.231.34])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ed813f7333sm27047761cf.36.2025.11.06.15.21.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Nov 2025 15:21:30 -0800 (PST)
Message-ID: <c39297cf-daab-43e0-82c7-3210d570e427@kernel.dk>
Date: Thu, 6 Nov 2025 16:21:29 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/7] reverse ifq refcount
To: Pavel Begunkov <asml.silence@gmail.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
References: <20251104224458.1683606-1-dw@davidwei.uk>
 <358f1bb5-d0c2-491e-ad56-4c2f512debfa@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <358f1bb5-d0c2-491e-ad56-4c2f512debfa@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/6/25 9:10 AM, Pavel Begunkov wrote:
> On 11/4/25 22:44, David Wei wrote:
>> Reverse the refcount relationship between ifq and rings i.e. ring ctxs
>> and page pool memory providers hold refs on an ifq instead of the other
>> way around. This makes ifqs an independently refcounted object separate
>> to rings.
>>
>> This is split out from a larger patchset [1] that adds ifq sharing. It
>> will be needed for both ifq export and import/sharing later. Split it
>> out as to make dependency management easier.
>>
>> [1]: https://lore.kernel.org/io-uring/20251103234110.127790-1-dw@davidwei.uk/
> 
> FWIW, if 1-3 are merged I can take the rest to the mix with
> dependencies for David's work, but it should also be fine if
> all 7 go into io_uring-6.19 there shouldn't be any conflicts.

Let's just stuff them into for-6.19/io_uring and avoid the extra
roundtrip.

-- 
Jens Axboe


