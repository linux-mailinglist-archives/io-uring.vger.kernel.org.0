Return-Path: <io-uring+bounces-8152-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 873C6AC9034
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 15:30:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 77CE77B30A9
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 13:28:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE4527DA66;
	Fri, 30 May 2025 13:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MecKoN05"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1E420A5F3
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 13:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748611804; cv=none; b=JTaRO1k5sa3/GGCs95Om6j47cCTddUGlkk/KqZMVIu5Ch0DaITYOFw3uBpSM1P6RsRXTQ6XDLZgUpCoZnLQ2+Rm853bQBIYfODKX2PZRPlbCps/qmVxwPnSnCzy5cJEIQI3F4SBIw9df8+tEzzxVdwuJnysSRA3j0AzBe0v7Z3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748611804; c=relaxed/simple;
	bh=RHx4a42drAGL1oYzsD2n8ggD+ROIGozakRFYkRzgh4E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TQWdoxtTiOD14it0gdh0bp+U2E8lwBJiNGEVzOgt9ZdtGMRIFdVjcYt5zSsAJyUjsFgytgco8/ne6HpCAB5qKGVdwjAnNjZrxLcWlzjK4Aqed9wESIxXD6SYcJvMYVTDbHViUsPW40GvWehsrf+KOv31Fv72J/ZIg2PCW66+Hcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MecKoN05; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-85d9a87660fso188122339f.1
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 06:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748611802; x=1749216602; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CNtJuF2JmmWzRjv3i0f39rZGeHHOJRXIAQa1CV7ykN8=;
        b=MecKoN059sY2MsViaD7yhhWcvehLzWv1Wh0o+b8ftdl4XP5C61ytvSiMjA/fxmovUH
         guIuC5j3a8EYSon6ziwcaCrBgCbpl7mKTR+BjGBpUQGvoxKOjHh1htomuIlAKAbZFD0X
         AowW3+3rK2mshZ+kB6fGChf7W0vkTrCzByUhyKjIdNA6zUuVuj91DxIY4lHllUvmm6d6
         w39k/T9SeyGndx26iz8FrtJguGKepqnXL/yUGZFIxC0Rrjcu6MDoIWKkjGkcm2+Wr2/6
         HfLdVTBHA4P+ySGk2LEOZYyv/8FMU/V+nODHapnayDHyrWtJhwxI5iSpk3mt48aotUH7
         8npg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748611802; x=1749216602;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CNtJuF2JmmWzRjv3i0f39rZGeHHOJRXIAQa1CV7ykN8=;
        b=wUnUdSur8J9TtMRiT8IaKCMQXmxcvmCmeHEboDrJOGWix/tUYGsHbxtP9ZYrcM+6+d
         CqfCBCJivwkdWy6KWyupTv3P6vOOx9jn6iT0CVb6vHvzcYmUBtMCx4EHglOD6piEPT6I
         DTyvGLii4zBcEn3INvl2iKcZrcNErR1krGPLJYHk/IwZaieWu24APkunzKir78cBR7rd
         6jrfpdVWo+04JzA0Q8KxBVn+0islm6LLC9PifasEV/xdci6nnEwlsx286NhcjQHkMKsO
         NXxK5uGc1dLuXNMV1ov0p6ewL/thPSDrYnZt4rgBjBAquE6Ue5/JDJ979oUUEKfA+lju
         yxCw==
X-Forwarded-Encrypted: i=1; AJvYcCV1ApIaUVLJrhFQKgDYrJvpW1K+gcH1IEBxLNXK8/wpSPN11XQSmGwlGgMNMXFGeVkAiNq2oKAZbQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyL02Of2wKi4S3FQ3e1Bfqt+a3TSzMwUVteVLGnEKzIlFMB6cPV
	L2PmwrR/NByTpgQojBhyrFd7cxdestG8QULD7bfdiobHh/lsjBdcPD/t0aXpJRbBJJQ=
X-Gm-Gg: ASbGncvlOqtCI78BJdNIFjaarLfo9rKLlhAJZS578GO3KrEGO9YVKXYorV1O9K32oGo
	0zMktkC88HzzbESWj0l4vYfF/eLY285zHmkAiT7OcfZThGYqvXsXro/UsBOMEtCVkyqNLOJYLhq
	SAd3wxawsE+1Y3dx20qVynT4xdMZGyjFhhHx1Ll+zKWKajvgX9DNXPD2WcHS5hJ4ynpTy7BFkfv
	7EkVZApPWIehj1J6FfXY+i0XjVSsh7FANgODeIC4RD90qxUpP5s116sydG5IdKVeCScmuw47aiG
	/gcmQbE1sCOcTtir2XwZXN+dP9puSnO5dV36tMCaH9DiIg0=
X-Google-Smtp-Source: AGHT+IFJumMPoBGvBdYNWiZVJWqOLRlFymAzul3TodVeaMGzL/NuKERkNsYlyzHi/ArMMVUm4zRKrQ==
X-Received: by 2002:a05:6602:3a10:b0:861:d8ca:3587 with SMTP id ca18e2360f4ac-86d0518e799mr213195139f.4.1748611802450;
        Fri, 30 May 2025 06:30:02 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-86cf5fdc62fsm62859139f.37.2025.05.30.06.30.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 May 2025 06:30:01 -0700 (PDT)
Message-ID: <87f8b206-e1a2-4b00-b4cf-e00084fc2a42@kernel.dk>
Date: Fri, 30 May 2025 07:30:00 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH io_uring-next 0/5] io_uring cmd for tx timestamps
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>, Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemb@google.com>, "David S . Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Richard Cochran <richardcochran@gmail.com>
References: <cover.1748607147.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1748607147.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/30/25 6:18 AM, Pavel Begunkov wrote:
> Vadim Fedorenko suggested to add an alternative API for receiving
> tx timestamps through io_uring. The series introduces io_uring socket
> cmd for fetching tx timestamps, which is a polled multishot request,
> i.e. internally polling the socket for POLLERR and posts timestamps
> when they're arrives. For the API description see Patch 5.
> 
> It reuses existing timestamp infra and takes them from the socket's
> error queue. For networking people the important parts are Patch 1,
> and io_uring_cmd_timestamp() from Patch 5 walking the error queue.
> 
> It should be reasonable to take it through the io_uring tree once
> we have consensus, but let me know if there are any concerns.

FWIW, this series looks good to me.

-- 
Jens Axboe


