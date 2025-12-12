Return-Path: <io-uring+bounces-11021-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DD47CB7A52
	for <lists+io-uring@lfdr.de>; Fri, 12 Dec 2025 03:12:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EFB3930084D3
	for <lists+io-uring@lfdr.de>; Fri, 12 Dec 2025 02:12:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCE3D28C00C;
	Fri, 12 Dec 2025 02:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RHEJ7Cfq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68687290DBB
	for <io-uring@vger.kernel.org>; Fri, 12 Dec 2025 02:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765505542; cv=none; b=XfmhUzgZdbpaW3B4a8aQjUL0xlXs2sbina6j3wX8uFJpIurbSuZvgx3YBKh+qlGpWxT1uyykc8n7yv963OPdh/tHzovIsO4Assdkra9q+i0ZrwWHVFPiyUj7x4UfDW1By7F/+h2vzoa0R5GNC/lXlp1aO+h7waHOgbdPKwIMTpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765505542; c=relaxed/simple;
	bh=Vxpx3eccWi0kCP1XPB9iXUTVgvvAg1Vda89sOV3uE90=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iiL6q3Hbh63JxTSoF6ZnQBvU9unhjvzxrQ44/KOtrzlPGVuUiFSRTe8NwvH/us56HzPzdJfxUMa4m9nFxBA5nENsMZfwULFBWp2hBzPvmW6f4PZVksvkLiQd1HOVl25apIP7i9cnwjcNQcuA/K/L0ZyDyZAgxp5IOPv8VJk127o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RHEJ7Cfq; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7bab7c997eeso869492b3a.0
        for <io-uring@vger.kernel.org>; Thu, 11 Dec 2025 18:12:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765505541; x=1766110341; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TGLnR8Di6TNxZG4VYNv1XF3XAKVisY08s0a5El0hQzQ=;
        b=RHEJ7CfqlNMzj8lOK5ldqIU21O6He98oBkpP1e/00aOWauV1zIz/tu8vYHpAW8lnBj
         kfNigXsw9XSJL5MZUmE3/FKlmrOnL5NRXx4bs/x7Xksvp93WrnyPLCc6jWagj9CJ4/3V
         uFVf3lx60/3IVs6RsL+f8xT58UdcafcZck0m6u3jEb4qTUN8QDLV9RTgQegcsR7N2qjO
         0MgKwE87j6eRMq8q6040abw0cBO+GiRAjSe0R7x2DLgPEFtgaVKSe5vv+v82VM+9sFUO
         F6JWe+6P2PwC1/rZe8v1Yrjhofi4c0u13Ecvsct/9RLMhT+8YNvCEvwkqUcxh0eKF8vW
         03gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765505541; x=1766110341;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TGLnR8Di6TNxZG4VYNv1XF3XAKVisY08s0a5El0hQzQ=;
        b=cyuL5JjgEVN3wzBlcw9+QB+bAaSDixFrhoT6crpxrxCkjOkzDySCi3xP4n92Mp3STN
         pvyoKBJoagtV4NxTP3rYhkZJIFmCFoa4AxZ/nCbce09KDBVuX++mlU+kkkpsv2uy1Vrr
         n4gOIslMkhUwZHDRFT0yedRJV0oawHwwFWveoT/OHA+D92Bys4T85pfA7oqsTyW7SvCO
         +eiczKyd9Poh9bSuFarqJOhTuimFVf4ZiWAdfi8i+f8EC6rADnVeU1d2He8QH48Y1HLr
         Dw2RYm4rOEmPl6RccJIyOWLBdrH+4jwkZGII0B4EUX93YL0dhPHv+n/8tv2//tLb2pSy
         2Jow==
X-Forwarded-Encrypted: i=1; AJvYcCUkSA4W4wQ2ZdjQ+msnvnCRUhxe4au/fOZDxkzbghOV3axxy6iXQH+81ussuO41ziFhBwQPoCpMgA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6+Rv+wgXyc4d73cR8DS7zjJ0tZXKAZgkce8EtgQQIPSBktwZO
	wT2QCTV/iNJCZha7kYvCd4OkxAgdojds+aNjGWtF6y/IBZx13LuJsUQm
X-Gm-Gg: AY/fxX5Gv6dQug+oco5z0L7MA5JyAlfytjyALokUuHR07PpBDnOvJRjMoDmxfj7mudq
	QWmCmDQ0e8exdGl2F/f4K/kkhbc9nvy6iV/g0+flUTmr4JBSGBaBthIyTbpqW6iAMufPGNFA617
	oElceEwbdlPAwy8B5siu0t8iVK7ux7ALFS/obi1rreNhHStW/2AnvIiKhMI0NyPHJVK/Sr6/ba/
	8cvoY93r3axPDcr4O+DQ9U50cOA8Yxf9rfM2HLoFphh/1qUuffym+JXB4cq79jkwfuu4Ri9NCaK
	e43JSnWvGu0A+hbI4SX/ZBY5RypAhErbKTAqkP+n2rlZQCW/hmqj8p+govCAovsvljhTEHWTMKv
	4zh0Jvb1qj7v72yqKgoefkW5VX4YAt2r/4PCeazcaiEgfAeZsQmECuAJjma/ACFKNuo1GH1r9Cb
	VnIK97Bi7KtOvfHD3qMPca8d0XmEajyQY=
X-Google-Smtp-Source: AGHT+IEKJp+ey7pd/29n0PdL9jcJmNgLN0hs2QknJ2ZxR5AYGbEXBfO61dFQD19IASYa7Jk432JvLA==
X-Received: by 2002:a05:6a00:419b:b0:7e1:7a1c:68b3 with SMTP id d2e1a72fcca58-7f66810b2d4mr536888b3a.30.1765505540774;
        Thu, 11 Dec 2025 18:12:20 -0800 (PST)
Received: from [100.82.101.13] ([203.208.167.148])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7f4c2d4c2eesm3668423b3a.29.2025.12.11.18.12.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Dec 2025 18:12:20 -0800 (PST)
Message-ID: <f987df2c-f9a7-4656-b725-7a30651b4d86@gmail.com>
Date: Fri, 12 Dec 2025 10:12:15 +0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] io_uring: fix io may accumulation in poll mode
To: Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
 io-uring@vger.kernel.org
Cc: Fengnan Chang <changfengnan@bytedance.com>,
 Diangang Li <lidiangang@bytedance.com>
References: <20251210085501.84261-1-changfengnan@bytedance.com>
 <20251210085501.84261-3-changfengnan@bytedance.com>
 <ca81eb74-2ded-44dd-8d6b-42a131c89550@kernel.dk>
 <69f81ed8-2b4a-461f-90b8-0b9752140f8d@kernel.dk>
 <0661763c-4f56-4895-afd2-7346bb2452e4@gmail.com>
 <0654d130-665a-4b1a-b99b-bb80ca06353a@kernel.dk>
 <1acb251a-4c4a-479c-a51e-a8db9a6e0fa3@kernel.dk>
 <5ce7c227-3a03-4586-baa8-5bd6579500c7@gmail.com>
 <1d8a4c67-0c30-449e-a4e3-24363de0fcfa@kernel.dk>
From: Fengnan Chang <fengnanchang@gmail.com>
In-Reply-To: <1d8a4c67-0c30-449e-a4e3-24363de0fcfa@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2025/12/12 09:53, Jens Axboe 写道:
> On 12/11/25 6:41 PM, Fengnan Chang wrote:
>> Oh, we can't add nr_events == iob.nr_reqs check, if
>> blk_mq_add_to_batch add failed, completed IO will not add into iob,
>> iob.nr_reqs will be 0, this may cause io hang.
> Indeed, won't work as-is.
>
> I do think we're probably making a bigger deal out of the full loop than
> necessary. At least I'd be perfectly happy with just the current patch,
> performance should be better there than we currently have it. Ideally
> we'd have just one loop for polling and catching the completed items,
> but that's a bit tricky with the batch completions.
Yes, ideally one loop would be enough, but given that there are also 
multi_queue ctx, that
doesn't seem to be possible.
>


