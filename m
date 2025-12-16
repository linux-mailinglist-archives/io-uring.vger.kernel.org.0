Return-Path: <io-uring+bounces-11119-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C065BCC0E80
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 05:32:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8E80A302A749
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:32:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD25F332EA0;
	Tue, 16 Dec 2025 04:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dnuy74tg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583AE332EAC
	for <io-uring@vger.kernel.org>; Tue, 16 Dec 2025 04:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765859551; cv=none; b=BkF2JLsM7df/AaMlfSMQrKNjIEepyJxgYOUZjuFRZjl5IZh13dA//aaXfOHbSmWY/loEm486itsXfpqTCHVdft49RtPRxyp1TLAeHpHjGHjlUCDY05G1sfhmY/oJPqDPb18GxGshblwK0ezqCc3hBv+wkyq52Lsr5fmgtQNUxLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765859551; c=relaxed/simple;
	bh=JAC7T84OH3rJpKA9s8hbP8b38NGlwWMNJLYmPCkoa0A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OF/FKR4i11ZmBloY72ac15PoCv3VPVHK28QPKJLf2F7BZmiCKn8ck2luyzbrEXJNNL5bBWXu8cZj40Njf0sufdLbkkP1KCSVmfOe4LWg+Sd+V5HuodmerjFQ9gtcmwuPCycc6MQtJnFY3sD08EMH5RZX3cZFosAcM5MXH/sEJfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dnuy74tg; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b7355f6ef12so797655666b.3
        for <io-uring@vger.kernel.org>; Mon, 15 Dec 2025 20:32:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1765859541; x=1766464341; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=u04lKI+ITCEhSjyN8l/3SfN1GaX76pkUdUELbvLmtVI=;
        b=dnuy74tgEdeg4sZQHPQgfnWfF65ZIaEb5VaAbZbGlMltJVDW0a5u0idlX00NVT9MKv
         aZEye1jQa/uTxf9x3WflndEYSycittJiYS4qGTFjnB2wgj5nLvrkoDLkfrTvUXZsVqJJ
         GjdJkjtJqCXh0J0oBfcOTARTHjwr6JFQic18M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765859541; x=1766464341;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u04lKI+ITCEhSjyN8l/3SfN1GaX76pkUdUELbvLmtVI=;
        b=RdX48SYljRiVmGYz5NVg8cp+fZYYc0UTSexneAiFskaiP1h0VkuRWUSnOYQf29c29J
         shstw3SGZw8KDtgOJUi6pgIL1Wj8UzioIsAEQJ/bY+P6JMVYfqL6C4oZMKqT7Ljw2L/U
         ZKD0kK3pVeQM37AefxZtvUVR5Cwq/9qnC5xkc5gp3msW4uW/DWu56+es8yMK2ylIgkmq
         xSaAVYqsiAC68fI8wdQKQlFNncuHWxZDdpL1fNbEah7k8zuC9gjlnlUpfZswru4V6YXU
         14wnrqdGMNBj1jzT+Z4Ov/aRH3P3xkvc9YPNfWmtzdt0bCdm97MviwQJIXy/5jc6w7TH
         4Wkw==
X-Forwarded-Encrypted: i=1; AJvYcCXrfSdGw58wnZAU5/EkOwgJC1LlyQOjciWBqb6+YFt6G2xDqKyBe5thB6oc38FneDleGZBGiA15xg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7y5MVf3rkrJcLCIiw8/TruyGQHhby96VBqHgg1kfDcVOuSQmI
	t52c4+IqR4WzqzwotF4zh5GjGIXhzy9nkvx1MwP8jDw6vXVbrhe0UqEy+ar3TzOWPkxsCcXzZ3T
	0efjoznePbQ==
X-Gm-Gg: AY/fxX516qjNJ+niWdJq2l9WS1b7pESHZJnCMHu7G47X5YP8wjzlVcLj+IC0jPXzoKg
	cxhyKS88UPRtc6IK2VjzYeMC9lZWlJtSk5TtSff3u7ViN4JW/g/vwKAyJGQPHGwsMtioJZyAH5L
	KxbSM+WgpHYQy/aI9voxKEvk3cWt0mksPNOnDaYLY6Ld37y9TbglyGrGNcLlNfHCaDwL9Baq/Ye
	0lAcYsS/WkWihWi2n1wPCstp7LiCvNc65yZ7M4/UKKN8KApAhtUTDd6X1UBfDKZEcvKXIiru4FA
	m4Bm6EPOCRbir3mTN5LaYtykzYRKViPKY/QHVYPcAd+6NXfjracpyQM77F5whqncKd0gTAwd6Rq
	iJ4itTrgVrD1cWGxUi/4SDgUfxNbFAtxH+t9oDetnKDU9rPMBgSP9vAQP0MMWQiuyoWmZlwZFoA
	zEFJha2rp2DszhuFwM48jKDeiPq98eIgPqX44Bjwbq+JheBCiH31JrQoPzDzKX
X-Google-Smtp-Source: AGHT+IF0xmiqiJ++KXKGj/vsGF9CfhaIO3VSMORQKNTflNnxMfvm7Bp61Cp0igOs4mV2CojIqONx/Q==
X-Received: by 2002:a17:907:6093:b0:b73:7fc8:a9c9 with SMTP id a640c23a62f3a-b7d23ab3780mr1389039466b.29.1765859541001;
        Mon, 15 Dec 2025 20:32:21 -0800 (PST)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7cfa2ed80dsm1562589366b.16.2025.12.15.20.32.19
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Dec 2025 20:32:19 -0800 (PST)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b728a43e410so658294566b.1
        for <io-uring@vger.kernel.org>; Mon, 15 Dec 2025 20:32:19 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUcIjX24efJ3Jj2qKDNdUVn4GR4eMPorqdG2nXE92ynsQ6ItcB2RSVIJBHdhM8d0mDdgWbrx/DWtQ==@vger.kernel.org
X-Received: by 2002:a17:907:7e8d:b0:b7a:2ba7:18c0 with SMTP id
 a640c23a62f3a-b7d23d13db8mr1509432666b.61.1765859539518; Mon, 15 Dec 2025
 20:32:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251216035518.4037331-1-viro@zeniv.linux.org.uk>
In-Reply-To: <20251216035518.4037331-1-viro@zeniv.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 16 Dec 2025 16:32:03 +1200
X-Gmail-Original-Message-ID: <CAHk-=wi4j0+zDZPTr4-fyEE4qzHwNdVOwCSuPoJ4w0fpDZcDRQ@mail.gmail.com>
X-Gm-Features: AQt7F2rYyucJ8k8M5suIcIYwHZryFGRojM10TYRYQXZevxtnA0xqMtui8-ALNA8
Message-ID: <CAHk-=wi4j0+zDZPTr4-fyEE4qzHwNdVOwCSuPoJ4w0fpDZcDRQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 00/59] struct filename work
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, brauner@kernel.org, jack@suse.cz, 
	mjguzik@gmail.com, paul@paul-moore.com, axboe@kernel.dk, 
	audit@vger.kernel.org, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

So I like the whole series, but..

On Tue, 16 Dec 2025 at 15:56, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
>   struct filename ->refcnt doesn't need to be atomic

Does ->refcnt need to exist _at_all_ if audit isn't enabled?

Are there any other users of it? Maybe I missed some?

Because I'm wondering if we could just encapsulate the thing entirely
in some #ifdef CONFIG_AUDIT check.

Now, I think absolutely everybody does enable audit, so it's not
because I'd try to save one word of memory and a few tests, it's more
of a "could we make it very explicit that all that code is purely
about the audit case"?

                    Linus

