Return-Path: <io-uring+bounces-3939-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E7AF9ACBAA
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 15:53:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 07BD7B2381D
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 13:53:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3E0614B94F;
	Wed, 23 Oct 2024 13:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JBtvyEaw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553541459F6
	for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 13:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729691582; cv=none; b=Gs55lfY33M7GBohQTSrbtwMDutd8G9fCzteOCeuTiBZkECBB0aQjs7eJLQlZ6+STjBYqNp6gnE0/ZlOshM+HvBuWID9jTNzzrE/SmYpdspItnj9y0WIse+7eaQpMKML93pALoZ/uqfv4vRv19x3jHTTPz4L04+HESfgcTVNn7zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729691582; c=relaxed/simple;
	bh=iTRHhX5KsifBICyvjqbq1gxaeTG2w7jeFjeipqXCf/4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=LVi9d77Lo3yRUN9elfb5xF/Aq1St96nrbiZobI/3sHJjSfgkl7jdK+O8PCAQYRLW/uzmmPJv0BYx6EISCggccvf7lTjhMzbSh7mIa2snCSM6UZAqnjp8XiqDHBnGW5mxvnO5eJ2MAmccXvhhMv7f8pf/q5/vrgPy6ehX6Q0SCBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=JBtvyEaw; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-83ab21c269eso272055339f.2
        for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 06:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729691580; x=1730296380; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SdLuzcBynaSFYLgz6VM1IgNDE6YUmUWLXLD1JMeeUiA=;
        b=JBtvyEawwQA+w65vPf6kzrKFNOV5EwMH8YdlCuNrsOWWUrydb9g9qVnkPTfhtfJ0ye
         Jd3iRoS/C8fi3XiXJzQPbKVJMRNIG/cQy2ktZlqKNghuLqwuTDFdBK7tmhV+2TspxdCV
         IS32Ec0SgtxCpX1n9PmX0qLM/vcZpfM4RTqjPR8IdLc67s/v6PftbRF3KHl/V8gLIh8I
         P2lgzLifHzVGFAv9n09QvuL5serPPdfoCuEpnm67mjdaV+TKU0KuMLRVyrK4pmsEZzg1
         hfiKXJuLeo9zpnuXNHo0TZ5miHzFCnydb2vSgAUlq0mHTbScEZwWgTD+xyAgEVI11gB/
         xNzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729691580; x=1730296380;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SdLuzcBynaSFYLgz6VM1IgNDE6YUmUWLXLD1JMeeUiA=;
        b=Rc1E5igXdai5ocRXXobtpERqf5stV1KmzgYUk5m70er6NJKfGgPa5XNUdt+qhzNCT/
         cUOmICyw9uNsQ6jYle8PIgNbf0QMWep1TunrGLC6aHmmcMdhokvAp+IdvsRxfQsv8os+
         pRiE8Tc4lTpvuDAGtFvQgDs2mzJjKj7T1tyAPQ67kScIZtI4Zb1yj3JFh5i4wYX1xoe9
         711BexSnuwPrG6rEdms4RpQ3B2MDcpWlx1uMR64cvzhrec7XomIQdpCUEnI+cjFmgmQj
         1iX8rKaB9iHQdI7ea9fgAADnbCaeo1vJgVLjskn9sRjIk4PF83++YZZUU9KHBdNdfoTt
         kvFA==
X-Forwarded-Encrypted: i=1; AJvYcCUuUJ66Uv29FkpUoKI+xDefOA1vJvcH7JcffC/g9X2xtlpIhGcNY83a648t3xf6wvZI1kJOG9P1lw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxnwR0yfSGOcnzyuC+QYkw9z9ABf/DCmhcRhsMzfYLfyMnmIp4r
	hlln8KtzdD9rb0UwCP1Flp6UR/JzRQbAtWgxEBVoPW0u9/974WVJVhCOuZXVP8XV1pRWaRbP95X
	C
X-Google-Smtp-Source: AGHT+IFkaMFGhzSN9WgU/tn6WRGoB7VaVBeHgzcOwQFa6nR5KP/eEpjYAXBwaBCH02DCKV94C5EEHQ==
X-Received: by 2002:a05:6602:1603:b0:835:4b2a:e52b with SMTP id ca18e2360f4ac-83af61f7668mr274163039f.10.1729691580400;
        Wed, 23 Oct 2024 06:53:00 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-83ad1c64383sm217124239f.25.2024.10.23.06.52.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Oct 2024 06:52:59 -0700 (PDT)
Message-ID: <b15e136f-3dbd-4d4e-92c5-103ecffe3965@kernel.dk>
Date: Wed, 23 Oct 2024 07:52:59 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] implement vectored registered buffers for sendzc
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1729650350.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1729650350.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/22/24 8:38 PM, Pavel Begunkov wrote:
> Allow registered buffers to be used with zerocopy sendmsg, where the
> passed iovec becomes a scatter list into the registered buffer
> specified by sqe->buf_index. See patches 3 and 4 for more details.
> 
> To get performance out of it, it'll need a bit more work on top for
> optimising allocations and cleaning up send setups. We can also
> implement it for non zerocopy variants and reads/writes in the future.
> 
> Tested by enabling it in test/send-zerocopy.c, which checks payloads,
> and exercises lots of corner cases, especially around send sizes,
> offsets and non aligned registered buffers.

Just for the edification of the list readers, Pavel and I discussed this
a bit last night. There's a decent amount of overlap with the send zc
provided + registered buffers work that I did last week, but haven't
posted yet. It's here;

https://git.kernel.dk/cgit/linux/log/?h=io_uring-sendzc-provided

in terms of needing and using both bvec and iovec in the array, and
having the suitable caching for the arrays rather than needing a full
alloc + free every time.

The send zc part can map into bvecs upfront and hence don't need the
iovec array storage at the same time, which this one does as the sendmsg
zc opcode needs to import an iovec. But perhaps there's a way to still
unify the storage and retain the caching, without needing to come up
with something new.

Just a brief summary of the out-of-band discussion.

-- 
Jens Axboe

