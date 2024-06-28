Return-Path: <io-uring+bounces-2382-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D77E891C47F
	for <lists+io-uring@lfdr.de>; Fri, 28 Jun 2024 19:08:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C08481C22213
	for <lists+io-uring@lfdr.de>; Fri, 28 Jun 2024 17:08:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 277041CB338;
	Fri, 28 Jun 2024 17:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IHZrvxyG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA411CB337;
	Fri, 28 Jun 2024 17:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719594429; cv=none; b=ck2JNZHL/VypYysB4pkk+Cdt3Cvii0zrp/9WK+gLzSQyf9Ye8ezanhOHN8KUJ5UUdc9Ktm+92xhCQ0A2iOd/T/Omyu9bG15BzqmFVOyeiIshoiO6KRPVPP9FsqjwT5EynOxHj7iZ1jYoNlEklP91ESIB3Lyvrxu7o5ZNUfN5pyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719594429; c=relaxed/simple;
	bh=NGWk7agTAycvTglMD2fmXO1KDCeoH2mnVyI+o/lhjto=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=EjqG79FiBLP8G20AOi3q4A8h2eF4ceQwXzjGUiYuocXutZvS9AMGq0nZ54oGuxoV+X6qzhexLXWJQQS9fdLEBoW3uaALOKeT9Qn8ak3KALK2lRrabtMXnF+5OZUkX7HhALz8+SDBsLWC4zLKzny6V6RIZfw24/cHvnwIv2o8/WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IHZrvxyG; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-6b51ae173ceso4078406d6.3;
        Fri, 28 Jun 2024 10:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719594426; x=1720199226; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZZA0HaeL5zUHFhaLh/XvVZNaG/JilaJVDzRrJLmVz+c=;
        b=IHZrvxyGsNFf395xB4T1hy3k5uq13WQ3uBJwTo0loMHevzmkO8JKi74LwtuTVhh4LR
         X7a70K53L1CfL0yc6lTHTb/igmQBosmBmet2/9hoUyyeLvkjZcc659zwkFEc4DNE9Zt7
         YR/G7wiJuMDPSnkoz7Xo1dy8KH1KVZ2lycs4H74F7YA+57iaRu0sYFsEhT+NOGYV5kmP
         i+pt9dYjlrsnb5Al6B+vFHeq7hRb5OEMCj2FnsQZL/V20YEvaA1qZAsnulLkkr3NZaYA
         lB6MosIBQN5Kwu8m9SaPUBlehkP8iUHEO627U+Uxocvj57V4Tn/05nmL26d1lEM1yRq5
         uzqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719594426; x=1720199226;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZZA0HaeL5zUHFhaLh/XvVZNaG/JilaJVDzRrJLmVz+c=;
        b=qMZ063Xuvz1kdB991d/IacvDxzFuCXLROXTU88R6ZgJa77Ut+Fr5n2b2WdhFEvc8mV
         Ev/M/GEBYz1PeNn9UPWspyoL7UGhVUFupG6UrB9eDu3k/alHHeI9lCCnRsp7Jjoyiytq
         vkfGa53m5VnS9KJZLTFijhELtMHaYl8EZyaXAgz+C0JSyXMjUewU2c/hOCLlSy/xJnR6
         QAYddjc4zEuA/9iCUgTYelSDfJKbhEcGVxN8Z+vhwt8wMXyshkC4uzzqbnJyGPT925Xk
         xe9NzERp4c1WSrSLAzPv5TG0PPu6hf/c+uKY+XOHUlNuSyyUF4anctT4SXifozcUElPX
         k2Gw==
X-Forwarded-Encrypted: i=1; AJvYcCU6PMzaYSkkjE5KS1zlRx2oM6S/dn5QfGgxsgYBmYqmfqQkEjQSeporTbxZR4BnKqNtoBRcQR0nYoWnR7atjUGcZ3gLqANI2mayg3Cxdmj9w3HN02vZn9773sXoO/Ilckk=
X-Gm-Message-State: AOJu0YxixfdYtSabRgnauAPsYDBzFpmzsDy0MaRbcsXmLluQbQccJpRa
	46ssWlI3kQgEI/uGQtoI9/X7dA72EDimKBejCzbmrwLoPt/Rbvsu
X-Google-Smtp-Source: AGHT+IGdpOT/5KUTTwPittZKo0YFKf1FoMEoo1EzrwWvuJthvD6OxvoSvvOmhi0obZdGBgtFIhqoBQ==
X-Received: by 2002:ad4:5910:0:b0:6b5:3bc:388f with SMTP id 6a1803df08f44-6b53bcda326mr154607536d6.32.1719594426552;
        Fri, 28 Jun 2024 10:07:06 -0700 (PDT)
Received: from localhost (56.148.86.34.bc.googleusercontent.com. [34.86.148.56])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b59e574615sm9341666d6.50.2024.06.28.10.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jun 2024 10:07:06 -0700 (PDT)
Date: Fri, 28 Jun 2024 13:07:05 -0400
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
Message-ID: <667eedb9e0679_2185b294f@willemb.c.googlers.com.notmuch>
In-Reply-To: <3f4a39b3966204f062200caad857ff822f9f2895.1719190216.git.asml.silence@gmail.com>
References: <cover.1719190216.git.asml.silence@gmail.com>
 <3f4a39b3966204f062200caad857ff822f9f2895.1719190216.git.asml.silence@gmail.com>
Subject: Re: [PATCH net-next 5/5] net: limit scope of a
 skb_zerocopy_iter_stream var
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
> skb_zerocopy_iter_stream() only uses @orig_uarg in the !link_skb path,
> and we can move the local variable in the appropriate block.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>

