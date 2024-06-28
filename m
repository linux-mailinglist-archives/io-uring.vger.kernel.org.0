Return-Path: <io-uring+bounces-2378-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2446391C457
	for <lists+io-uring@lfdr.de>; Fri, 28 Jun 2024 19:03:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD7571F21D78
	for <lists+io-uring@lfdr.de>; Fri, 28 Jun 2024 17:03:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45A6715697A;
	Fri, 28 Jun 2024 17:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UOXLusb+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2191CD15;
	Fri, 28 Jun 2024 17:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719594192; cv=none; b=aB8qf1vKDXiRau6YzENI2jx1P6KDMp18AbH3NSzcIkQOgP0E/shy2YORh8z1hMXuX2siRn3P3d66+nmieRsX/7NBRuOG5yuKftbIzeX3z83kr5l4ww1vX9YD+QQDG8Npi7uBB1JwQpINn9C2o93kx1jksT6FiErJmcfvSmrKFQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719594192; c=relaxed/simple;
	bh=Nw9gP26oISOrl74PWxUu9ohsansX7ov4gdqBakTZl+w=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=Bxip4p2RU3wcR5oPz/4zI80Dql9xL6AQs4YY/Pl1IHTMfyBCPcwmcXD8HLIPfnKHFR0Cb/fOzvfuNN76oW5bWMtTGnoeLvsFulxPoodcFrr0mNguQo1L8J1eceoCp8XEvgacfr3NCJERxDjwE5SOceKwR8bVSHUpw84N9XumvTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UOXLusb+; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-6b2c6291038so7159876d6.0;
        Fri, 28 Jun 2024 10:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719594189; x=1720198989; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PY51QnhJZBm06Cvr9BwCn8tfpmgEnSHWyZ8/uliBZvo=;
        b=UOXLusb+QYTRd5ZHj0dSIteWhW8UlOXKqiMYPGOd7pJ99MmP53/EDqrSb+62hR8L73
         C+xgeDMVv9PlLhYq8K4yoc1qk99lJE8A0+2Btrh6U/0CxScl5VbPr++ZA2Mj4FXHh8h6
         WfTuaztk45f6LCWl9udHSA8Utqu5e/flzybaEjyUKVsv5EtITojsWViq2Ni8oKkvIdfY
         4BPdzfcq0joNYwm4FZ+oz3kCzQnsfscnyRN36APXNZgdUWW9DQO7OsNTsHMaivBrzEZE
         hLtffiKV2H7AMBMYhZ5Qd58K9odrILYdOOB9X7ue/BDFSTHqZNyV/sW//XH5ZYvppDdk
         ZSIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719594189; x=1720198989;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PY51QnhJZBm06Cvr9BwCn8tfpmgEnSHWyZ8/uliBZvo=;
        b=hm/IM0QKPaENdlAsxD8K+eouvxXGl36Qt8JXWD7BK8DLc+m9e+kZs2mEM26KfWH+CX
         HzNk/9cnkx2OWwlfembfrZQcyKlOBDjPkZANZ80H0mf+uGMAF3ff4KG2Go7rexVf0Lm5
         xkG2gZUsjH8FHHR4KbUcyHEeww98Iyz/zXvund+MPT2hRWaeVrK95eIqTKCtzyzUqcxY
         dzk/fB04WEwx3JcIbvQzw/qx4iiVxqnmhZlbt2Yh/2WUf2gbfuRmD4VkPJl68FNFlsEN
         2IPP+5ZhDz9ia5Cv5R+otDeTrvzmuUDHu5pv304zxm0E73voDTuHUEknseEZOxfxfllz
         UQYw==
X-Forwarded-Encrypted: i=1; AJvYcCVfeRb1DVm8irzZs5Lf2ZuoSnbe20auhtwE2DSeFu+KR09SXOWqOWmw44z5a9RuQCCfjD9h4//xSz48FNk/AUhTCEZSiXj/XAV8FF7q5dOGKncR4qmvNDAjCVrIwV0A/gM=
X-Gm-Message-State: AOJu0YxantIAtl+l4RJ2Hz1RzfR2ZR+nDeQrGXXzyvfNPe82U3lbD1r5
	ZVs29/+59YNUiEYFm5YG6kTxGsb/HZ0b1+izSbdUT74/FQ/fTvpv
X-Google-Smtp-Source: AGHT+IFlyPK1h1MZSqai8ztpY9YDYAkSmzleE+dkN6eCUmTJUu9lIvupJNBs2FUCXyKt6FtlyiAPEg==
X-Received: by 2002:a05:6214:f6f:b0:6b5:2a29:cd08 with SMTP id 6a1803df08f44-6b5a5483dc9mr42032506d6.27.1719594188449;
        Fri, 28 Jun 2024 10:03:08 -0700 (PDT)
Received: from localhost (56.148.86.34.bc.googleusercontent.com. [34.86.148.56])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b59e57b375sm9408816d6.59.2024.06.28.10.03.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jun 2024 10:03:08 -0700 (PDT)
Date: Fri, 28 Jun 2024 13:03:07 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 io-uring@vger.kernel.org, 
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, 
 asml.silence@gmail.com, 
 "David S . Miller" <davem@davemloft.net>, 
 Jakub Kicinski <kuba@kernel.org>, 
 David Ahern <dsahern@kernel.org>, 
 Eric Dumazet <edumazet@google.com>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Message-ID: <667eeccba59a6_2185b29416@willemb.c.googlers.com.notmuch>
In-Reply-To: <398a9b0f677348f62edf3572a4896ddb0ebfb940.1719190216.git.asml.silence@gmail.com>
References: <cover.1719190216.git.asml.silence@gmail.com>
 <398a9b0f677348f62edf3572a4896ddb0ebfb940.1719190216.git.asml.silence@gmail.com>
Subject: Re: [PATCH net-next 1/5] net: always try to set ubuf in
 skb_zerocopy_iter_stream
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

Pavel Begunkov wrote:
> skb_zcopy_set() does nothing if there is already a ubuf_info associated
> with an skb, and since ->link_skb should have set it several lines above
> the check here essentially does nothing and can be removed. It's also
> safer this way, because even if the callback is faulty we'll
> have it set.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>

