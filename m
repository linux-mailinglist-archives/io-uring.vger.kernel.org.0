Return-Path: <io-uring+bounces-10231-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D417C0CDF8
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 11:07:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 788E9188B456
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 10:04:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8474B13B280;
	Mon, 27 Oct 2025 10:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y3lBY4vU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D461DE4E1
	for <io-uring@vger.kernel.org>; Mon, 27 Oct 2025 10:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761559454; cv=none; b=Sj2SlbDDBWk2lipySUqVcOtRSGag+bofcivc86DG9Hvo3HtMgTM9YnIRE0/n1Nubu0dfZNg6fpvFHALtw+a43sSa3TFrlt1fE/qEG8dLKXY5SUfIymNr6pjb4rwXjBx2X2SGqQp0MQnDdeYag5EcLzbWDdUSFqiDoX2ExEzOR+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761559454; c=relaxed/simple;
	bh=9h3JF2Jsr0bLr+MYsKAm+lyyaTDNMUS6YLXcZVa+WHo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mmg5nhs0apor3b+pUT05ci1/afMow/dZrS05oWHQF6+tKcj+g4T8ucbQ5CurzAKCTm0H23skRaLxaVAPRmlmisCUPE+ZPL1sXI3BuA7PtQvppGXENxul960nIdCvN0xNLdDK3yDZEbqdPPpHFSsjb2nqlTCET8pCmva9pdeAUfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y3lBY4vU; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-4298b49f103so1398890f8f.2
        for <io-uring@vger.kernel.org>; Mon, 27 Oct 2025 03:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761559451; x=1762164251; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KKJ1wg6u1UDCN2tuMgCmCoT9rKQEtjNwHunwEx8cPko=;
        b=Y3lBY4vUt6Sdw6Ksc/GOP6j1dSuo168GcHkkUngf1EZVCWALNE7+agjIAZAjlQgv4G
         pvzlxhX2BTc+37WTzefuDuSq207T633FQfsqQCBAfEgwZ17rTohzC3QP8TdnQ6F3Fh1k
         VvdXg2rLbcotOsingqZimVnQRb7ubW4cpNVx4+O3nMPGmrDG+o3r020BLFe2JrK67eQV
         i5iAMmCIDO46kjQ4JLz6IjEDIvTM+STSNbIC/ELzwEg8Daa2VM7SYsaDCGh+FO7cfk0Y
         2sZj9AbRYVOKkvXpYrss5l74lWrEPBEOpoINtzu5wj3VlzlXRmuz2j67TJMG2nS+zYQl
         m7Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761559451; x=1762164251;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KKJ1wg6u1UDCN2tuMgCmCoT9rKQEtjNwHunwEx8cPko=;
        b=Gzkr9ms+s212+np+RWglepA3EdMMEwZP1ftIVvY1Y1Tgwa7q57KOb35DOEfxfQLbNo
         r8ISFzrzxTb49N3g2Cc7tXfATz8pMbMzW7JT7QTC5OnfBF1TnnwFEiBlvvuxgoFGXFFw
         vOJAh14rttYZjSexUnURawvla8LpJv0ox2lcJm9OHq4miyGu6GByjxYIRUjKi9Nvj0Vw
         xLhS+vUZxrDTHaWxVOVNpAbesOS6CTOe8l8ig/xXO+lXZSrioTLS7nDN1V9AR/SslSk8
         1f3KQiN52SeyDA0w4LhoDmIsc5NemzS1dqKR4pNHGQpVUiNE/VVPq8jzGwu4veiDYQQb
         0h4w==
X-Forwarded-Encrypted: i=1; AJvYcCX828zz64BNRchmRjVUM5fXyvDXcMIBuTWHHD/j7sN2VE32obeSz6aR6EEKLbTCPMqdIjC+k+TCQA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxukj5rMA8h2h5Lr+7IGM3SDKeRXu2QJ8eS0w0M6W7l8lG6UlwT
	1F4IlSsISytPQ9SRrz4rjoUHdWynz3DPyqM91q+4erm6KKeBeyU1aCaJ
X-Gm-Gg: ASbGncuAo9upbppSgkGxl2vPvibX1mLrJiJnzfX2oetYcxauc1u0r4IRRuXdDbDYE/Q
	ytsybNsPdDdTX0gvNeIgx7D4NvQ2H+xIno6utD0HI7JSXDowekZ8emKF1lJm1pbe+JO1ccGSTuW
	+VA9rWljOCL+/fKHPMBaIHt1hKq3cY5bPtnupEUe9lhcGpk94jnNPDGynzaUt6o8Cx/ncwHIeJN
	cWHfTTLIoR5umieRzFAoTb8mb9fWWvuZqJCQe87MNoebmEQXPAIZWANYHHx3VDgaVrIKIAHtYgN
	syyJDQHVWZsnCexCDBs9tFeqIoam5HhKwKsrjfH8wwf+UZ71X2ch926m/E/borjrNr8Y0V+nVjr
	vIOrYg6K7HxY4cCVa/79coBixCHGiA7uSgUkGKvLy2MfSZIG6JqVfKABt6tqVkwdTLmOJFaY6rv
	N2igxZ2cEbZbdOZm1B+4V5GI3XaNGFfAQg
X-Google-Smtp-Source: AGHT+IF4fsgQiwGl63VPBGIPyCwDHMyRRafneFK7MUW9p1IOLSi9/nVRRkViP/Dxx76BiIBnVUk/Gg==
X-Received: by 2002:a05:6000:4b10:b0:427:6a3:e72f with SMTP id ffacd0b85a97d-42706a3e74bmr21755793f8f.34.1761559450855;
        Mon, 27 Oct 2025 03:04:10 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:8b1a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952df62dsm14277603f8f.45.2025.10.27.03.04.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 03:04:10 -0700 (PDT)
Message-ID: <c3a45eaa-0936-41a7-92cd-3332fd621f6a@gmail.com>
Date: Mon, 27 Oct 2025 10:04:08 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] io_uring/rsrc: rename and export
 io_lock_two_rings()
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
References: <20251026173434.3669748-1-dw@davidwei.uk>
 <20251026173434.3669748-2-dw@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20251026173434.3669748-2-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/26/25 17:34, David Wei wrote:
> Rename lock_two_rings() to io_lock_two_rings() and export. This will be
> used when sharing a src ifq owned by one ring with another ring. During
> this process both rings need to be locked in a deterministic order,
> similar to the current user io_clone_buffers().

unlock();
double_lock();

It's quite a bad pattern just like any temporary unlocks in the
registration path, it gives a lot of space for exploitation.

Ideally, it'd be

lock(ctx1);
zcrx = grab_zcrx(ctx1, id); // with some refcounting inside
unlock(ctx1);

lock(ctx2);
install(ctx2, zcrx);
unlock(ctx2);

And as discussed, we need to think about turning it into a temp
file, bc of sync, and it's also hard to send an io_uring fd.
Though, that'd need moving bits around to avoid refcounting
cycles.

-- 
Pavel Begunkov


