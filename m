Return-Path: <io-uring+bounces-10280-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D2F31C1B32E
	for <lists+io-uring@lfdr.de>; Wed, 29 Oct 2025 15:27:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E55D15A1D6A
	for <lists+io-uring@lfdr.de>; Wed, 29 Oct 2025 14:09:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C74411509AB;
	Wed, 29 Oct 2025 14:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YjfqrzVj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0009F17A305
	for <io-uring@vger.kernel.org>; Wed, 29 Oct 2025 14:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761746514; cv=none; b=hP6l+t3Iv+2fWt5QKHSjxtalPDwmf24Z+nCCSqMp457hIWmAArLOybOIK2bHFOJvxOSzdC+81cJrKpTgwrU8nvX5iLNvK75apxE8pvnsXs5rvMclmKbnUHEAX5eYx7wjxDkgP/8+tIxfdk/19CYSKv+owLxm4p6hu03RYpSStjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761746514; c=relaxed/simple;
	bh=+rTwBXkrk8jd67gFcjP3VAxT3XoRYyLkGViTbqEXWs0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CiPL275768eixEfckgzGvNiQvYCpmieVdma+0uqZKMsRPkmVYqwb0JuneOLLUxKtK2v31ddMn+Cx2NC5XKlNBlXeNCEuUfvDW3XlaGcLdpyZfeL5iixcgfJf0B8SGfYpzHhCz24UnBoFxBnrhxlN2xBInNwPeuPVh/yhpiFbX1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YjfqrzVj; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4710683a644so10440355e9.0
        for <io-uring@vger.kernel.org>; Wed, 29 Oct 2025 07:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761746511; x=1762351311; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2rMYPcT0vUjf262H+Q8TuoH4jAzWuzkQrPmzc5xLpsU=;
        b=YjfqrzVjhhhucthl9z1qe16KLN3fXmAbc90ghSJWldWPaPDBJDg8NTVrjmZnCn/SMW
         3JykydyotCYl9nyN4yDMQcGd+rUXRdi9E/28vHYzAZPGfisQ0qTNkbv1sptZR9ks3qIW
         65GOc2z1gFPnP0ZxxL5BuuKk971jcRH+n295cwlvc2Y+DIAPyzWRbePWABdTtZh8T9MT
         EgfgilYjZMuKvYgJ9Dmge+byslyU6+omUrbvYx7PJKwv6+y9WTSWAgQyp3PH/YhOXfsM
         oDmRv5xSz8xexf5YQm/ogLIn5UIcm8X6bRn7M3S+Rmendve1iSj8LTEiIqZMDzEYmcgL
         bdYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761746511; x=1762351311;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2rMYPcT0vUjf262H+Q8TuoH4jAzWuzkQrPmzc5xLpsU=;
        b=IBfHg4Tr2g6YjWaNEMoWfUb1A6KwdebZPlvW8Ggc+mIUp0c+/+tI+faqxY8ymcdQ5D
         mjDJ7rKag+YNFs0YQ0XiVuP4VBbxBmL4beIvpgEdN5whEqPrwS4alydHnkje32BTz9I4
         A0FzjKjNhVbJynRgnUcKUcjdjnjn2aO5rSFlVYJHI71TKZM6XkPsNCdJi1ucpo5NGdHv
         2Lyy/hjCIkvHEvWIx7aLbwogpxaZUH/C/avFzKVAwiHJJW/Dc/eTBjkVuESz4zXbLS8z
         x+fJ/LX/spY9+RfHhjEeMqTp01/ARR2SWipfhuDjFbYJFuAkiABuUOjAY6e1KNR6w21x
         6y3A==
X-Forwarded-Encrypted: i=1; AJvYcCWpRttPyYYLESyzeod5yY/ejcEbIYmVDsK4gvFrU86q7S7rz5OplVUhXbutFIAt3oQY+/leeN569w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwDWjeEZZhtowQx1xE+eAlj7ml7252hQyB+L9bs3ooV12zWeiZE
	FtM3H/jDWnLfxbv1Zh7g9Gey/40urmuPphJx0hGLR6uvEAkn9j20dviMuWriUQ==
X-Gm-Gg: ASbGncsZmQwRUNlPgdM+D96k6Jv5JQS/jWLpwcsgpsi+aHZGjYPkk89875eQTzxZkpt
	Kq+tZ6rHkmADggdQtAnrCxdTAfH/uQrbm63iUM/+xDiqJo1i1SIfnb2biYCVJiFmM+M0aYVk3hx
	frj1+Xin3RBuA6gktMjbQRqiy5DuBvee0M7H4ij53k4dnWREmtathFVwCmxJRr77zzYQUlV/GEy
	snanS+fwtanwhiQSyFJTSBqhm6JcwbxC9d62eouZpyh5t6aWUpBlxi9gIOlzvGnE+LZD7hEYA++
	pdjFSDvmDpvXC1fm1HOFWlJW91ZWnV7yUPaMrHjZ6tFxvhNueBNx5JYHiFmXEexPczD5Tvtz7OG
	k3Jya8Z18GdERRnJ0UtZRAWlqhI78LSiZuTWuUwcQa/ucF+LGmHBd1QEpZ5txDkNiSlRiU51r4+
	kmqXKYKRhvN4uUx2CiAOPPpXxlWvKC0rFpasoWSGdYHAk1U4khnp/KTjCCg2jFflHSPA==
X-Google-Smtp-Source: AGHT+IGtuSHh0+Byv59OFxIgZzhRPw4PiAXZpC1qk/p0PcjfnUKrIOrNIC2+YkX1CVaDZipa6oiEYQ==
X-Received: by 2002:a05:600d:830f:b0:475:d91d:28fb with SMTP id 5b1f17b1804b1-477180f3b54mr46255965e9.4.1761746510979;
        Wed, 29 Oct 2025 07:01:50 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47725bd740dsm303775e9.0.2025.10.29.07.01.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Oct 2025 07:01:50 -0700 (PDT)
Message-ID: <455fe1cb-bff1-4716-add7-cc4edecc98d2@gmail.com>
Date: Wed, 29 Oct 2025 14:01:46 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/8] io_uring/uring_cmd: add
 io_uring_cmd_import_fixed_full()
To: Joanne Koong <joannelkoong@gmail.com>, miklos@szeredi.hu, axboe@kernel.dk
Cc: linux-fsdevel@vger.kernel.org, bschubert@ddn.com,
 io-uring@vger.kernel.org, xiaobing.li@samsung.com, csander@purestorage.com,
 kernel-team@meta.com
References: <20251027222808.2332692-1-joannelkoong@gmail.com>
 <20251027222808.2332692-2-joannelkoong@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20251027222808.2332692-2-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/25 22:28, Joanne Koong wrote:
> Add an API for fetching the registered buffer associated with a
> io_uring cmd. This is useful for callers who need access to the buffer
> but do not have prior knowledge of the buffer's user address or length.

Joanne, is it needed because you don't want to pass {offset,size}
via fuse uapi? It's often more convenient to allocate and register
one large buffer and let requests to use subchunks. Shouldn't be
different for performance, but e.g. if you try to overlay it onto
huge pages it'll be severely overaccounted.

-- 
Pavel Begunkov


