Return-Path: <io-uring+bounces-10340-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21794C2DFD4
	for <lists+io-uring@lfdr.de>; Mon, 03 Nov 2025 21:07:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CCA703BA29C
	for <lists+io-uring@lfdr.de>; Mon,  3 Nov 2025 20:07:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E013245005;
	Mon,  3 Nov 2025 20:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Pv+l/PiT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720E1299AAA
	for <io-uring@vger.kernel.org>; Mon,  3 Nov 2025 20:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762200429; cv=none; b=KR2hv1OwoAzaSupmMZnrVWIpdi/JdvfOZQ9zRl985w8tOgT9osapVwvS68rF5kVN1I0aZurgqteTgC+g1PB9V6dmyjFlS+O8EwvPJJo/bCJhvpN4KiDxuR81akhbxMLJrA7MlTlx61+FmMml1MT8sB9ZybuezQfW8PYSMkIi8n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762200429; c=relaxed/simple;
	bh=GiKgec7ngTikHOHSjKx6BwDm2EjHZWFr9d2CqhfP/bU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qi2Vl7Az98T+DG4bxSsXve3yxSCA1HL/ZDX46BrTDaLHuAzFi22Hp05LAG5pRZLKPezFKaufbiAuufhKfMK1MVKTGS0KKFk7kaFnFt1H5YYF25+e9n9Mn0Jb0LQ1lR7PrRJc8vqMMDrhehUGfiMkevFW61leDfIuk6RL8kv+q20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Pv+l/PiT; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-4330ef18daeso12998195ab.3
        for <io-uring@vger.kernel.org>; Mon, 03 Nov 2025 12:07:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762200426; x=1762805226; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aAEX0koCAPFxvjYuXW2W3bjaZICrr2wnGcmP7E7k/4s=;
        b=Pv+l/PiTGUgNeBNreiSgWtwrhMmv1fFl5o8MtdFj1py1JGjm5DjFtIFCE/da1AQrCN
         2CKlumMP5ofoqP8Qay7Q0MCQtrqKXNRRDjQ8wdo/cokvb06ecQdg/394/Dtn4Mc6rKe0
         E8E7d+Nbf1W4wcK8ZPSsUsI+HM+ZywO2TuwxwDxJWxCsEPznWe6gKoQU9wsbrkgXIclO
         clgY6DtvGcTUv9CZeNk9hV5QGefwj8BLLBy9smG7kt9sCz6Dg5KsDqy2RboFLzEjB4ZX
         AX4PF9nywL9iIB7eNG4sWwNtgY8sC2f70/kBvHOP+ULS0QsDzidfqAeXmw0AhG2c7RnO
         WSdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762200426; x=1762805226;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aAEX0koCAPFxvjYuXW2W3bjaZICrr2wnGcmP7E7k/4s=;
        b=CG6oZcUvsSaD9rJJ8LoDp0qXcAPALq+xTOtM3EsG9qpdy+1eaobkRrM7imKVUZ81pR
         mpHRxv4sGfgwUFSiL5Thaadx34slzegX4bEnsCQ70oCEhwrPfR0lO63NAa27Jmw+XLVw
         rbIcMvkHNt+Qs8DlRh5k/QbkPkh+ZtZsT/0Sk0BIPzzPi8C6svZXfT1jdnsIkrJTazlu
         MakvqN+UVo9CcQybc+z4X9x0qF/kKm1l/LvOtZ1UFC/3M7K7tMgQC+lGys12RJ150acV
         cvvI/TRkNlLaj6x1ZxLHLdh+uUaov77gAaAclBt7HA2yrpisvo9xGx3Ri5ep/oS8LRP5
         rzfw==
X-Gm-Message-State: AOJu0Yy+xzFq6A2bIHFYih2LSknrzuz8ApEqs7M3YYu71k5fdMNZx6E3
	Bg6UbwN/NQ1QQyBzFYlMCMGAuJMjxOJF/aNQ6Glp0VJV0ciQdX0XIWiaj0X7Qr/w1qs=
X-Gm-Gg: ASbGncuKQpsxWD6Igq4NpfEiXql5oFte5Au2AX+Ur/6EDNor7lb1WsILgIs7zBGZN9a
	h+8QacPe2gtn1OYcjQ0Rjv3RngjhzEkoYBYEhDqI6oYssM6TTbXMqQJnhGQsixY9KmYB8GBkQ7e
	Hp3b1+83TJOJMgEfykaqAUejNxDnxrOegXtHu9e7kx0g6reiprz6CwPicgKX6GLDxQNgmc8BpGs
	coTngNcjN+0w5R0L+gBvArRQTySoO6wGAfUawS/8sXZtGn3ovxbBhis0moXqNsoG2BYZDCY6aOl
	N9bR3S4qh9TOpbCz1M13vurti1Dh2fbk7zazYvfUrJifvsFjAVLvu1VGFHqao2z72c+NLgFtLZy
	Yfb46mOw6YpkN9vdrcVk+ARpaNMdxtaLebk/C4LAo6HemCMrZ74wFVsdz0Lr0tfadr/f0ZxSf
X-Google-Smtp-Source: AGHT+IGH8toKxw75e9lks1D1eLczCWJzuOJzKorNF7XgrQzKNt3gJl8ETsv0rH+NVLYkwtk59SitZA==
X-Received: by 2002:a92:ca49:0:b0:433:2df8:5dcb with SMTP id e9e14a558f8ab-4332df85f7fmr61837955ab.17.1762200426405;
        Mon, 03 Nov 2025 12:07:06 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-43335a91913sm5061305ab.3.2025.11.03.12.07.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Nov 2025 12:07:05 -0800 (PST)
Message-ID: <2352e59f-0555-4318-820f-4d075acdda07@kernel.dk>
Date: Mon, 3 Nov 2025 13:07:05 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/memmap: return bool from io_mem_alloc_compound()
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251015172555.2797238-1-csander@purestorage.com>
 <CADUfDZq807sZ5ZMeX3adbV70Pjjbn299kTwyADhEiJqcxMO6xA@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZq807sZ5ZMeX3adbV70Pjjbn299kTwyADhEiJqcxMO6xA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/3/25 1:03 PM, Caleb Sander Mateos wrote:
> Hi Jens,
> Any comments on this minor cleanup?

Looks fine, arrived while I was on PTO and apparently got lost in
the noise... Applied now.

-- 
Jens Axboe


