Return-Path: <io-uring+bounces-8365-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AB4FCADB488
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 16:56:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 88BE37A294F
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 14:52:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E0C02BF012;
	Mon, 16 Jun 2025 14:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SM1x2MV3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38DA176AC5;
	Mon, 16 Jun 2025 14:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750085614; cv=none; b=SqfnOkRt3m0gQ+57rWE5jm7UmKeXL8yRKcYCPWOztuhCTG1ph9nH6EQxx8AWsfOwjlCZOh6KwFeYli3iyQHBjk4wqtoFezKlmXRs9i6OH5ke5rlj5V6qXYmWv+6JsLx1T6qW3tyVBLHFTbYLk1z75mCsNWf2UZ4QR1ak7YTt3Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750085614; c=relaxed/simple;
	bh=xK4CduiMa57XqNZZ3qsiup/fd4KpMPJRP2hf58ywbtI=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=PutXBPIRkGs4lnau/716vfLdoQbtHEyijnYQdETiniW/dVww5DnAPiLiQcyHR/q24aGnkAJMb3JSZjgnklYTu3ULHZGaBL5YQe+PtRjyWbpPp+Bttx6FT5XbjVwoVRRUloVYm/h+hBHDVzPKxyI9qKwy3GL+Pbd9Iw2wFmhmtFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SM1x2MV3; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-70f862dbeaeso45046397b3.1;
        Mon, 16 Jun 2025 07:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750085612; x=1750690412; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5VQE+OauxeCKEmTfpf9PoviywXszi+tFuUWbU7eiSKM=;
        b=SM1x2MV30kA0ciD8d+fS8+RrWbtqDKbIS717p+nr2tZBVDwX1Rgj5EnWhtC+GG/4ll
         3BT+TWi/u1XCpewHT0Ob2+879iWML/vqAGSG8F0hX6rViVsYhEzFog7EKfr0NeyQLqtX
         2ovfq8JPLU11Lka6nGLuxgIzBWipO4domrAWqQvDAAWl4HMnmdWbGcpSvyMEvTiHl4gq
         ZVGfEFGOiS0O/oXTCvh/ym+W0kkH8BrlsnXaDDIFmcn9SXVwX0Ys6y41j7jJkEIIxPfo
         i/NdyRCcSld6UvRC0Cc9RpO3a6bDtfq2OpNJXgyf8hQ20JD+JG9dR27U8xilZd5CnBdc
         QhWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750085612; x=1750690412;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5VQE+OauxeCKEmTfpf9PoviywXszi+tFuUWbU7eiSKM=;
        b=eDy6FpJbYTzsxemAEhdHyWzcnJRs6R0iQ/RcqEyvFR1nQnxrS3T3sfqOvHrpIPZ5tb
         fG9XU9tcbyfUO96kWdMnzeHnfzS2F2HbOQqkyh07TNLbF0BLxmlKYL2a7tUgKT0/s+lA
         3JYjOhwON5lU2PGf48WdjsXj2hoM+RErDiIt3774ItaZMXIgaFLGS4HUjOGaF8Jf1t+z
         +ERo3wL2fXEDALuCQ1oHSFztsXKrndBqKCxYH+JRao1+Xk978VzN2DM7zRWcEwJvYIQo
         3miBseBwBMaIYTHKW2xSY2NxbzRlKDjBe3U3tLP/ZsqdhpzlyRdFMJkfNypH3+l7cmm0
         dRUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUn2TsTrHdyEIwI8iOo1mwhcEjJsZvAERcsw4p6pGXwhPRmKBRW3GTUphu1VK4ztX6ixaQcbhau@vger.kernel.org, AJvYcCXpTdfy/lR+RXBh2RUK2meUNc02X5qUjHxdwBTUlmZWWdMGZzLjnTF07qzB2yn9ZLUBUgStNyiGtw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxjEgh4Xq1Xym+LeSSyzrElbvRjbK37bfOtJY+Mgb5b8p0VvmcC
	AM3PoDj9AQhKq7KVxm7sBQo5kIwfA57QnYWGRlwLuwzDpCkoPRVPkPxL
X-Gm-Gg: ASbGnctcfgCdB7n41n2yIbWcQC57msubNsmP6gPyXVsPo/Bk8si+VU1yHnLkWRHmjHb
	OCenRVDa/phW+0AGNJPq9waVnJhQhLm36Nl2bS9plrRIIoHbiWt3xEmSVKQ2zdDEkIsUIdN84HS
	/gpeKAe/9woNphUMQzuIMboL2ui8rekuHHbTjvE2nNCwfyVMpimUKPWpEwRM6eaFReKqhMESeMq
	HoxvkjzJDC3cfEPnOt6n2YhGVJRn7XBtraUKtJMGLfk2Lu19j3Acpptpj4MDxObip5ZRnIzuHPE
	nu7ARDtwGbvkxks6OL0EQUg9j4rLxrEEHKgOQVy0e+WnPrtfucu4JaUQ8Bz1zDdf4MquHCj6rt4
	Pug4TfHrnIBWSctnNOrJ6BnWc1he2/OGroCQkT49YawggSj49r4T6
X-Google-Smtp-Source: AGHT+IHoqCJrYRdyUIXTOCrEUdPAaLyx1d7jVQxXIARSYU44p6FBM5bl0U/AGzqVxIrp/hQGdD90yQ==
X-Received: by 2002:a05:690c:3808:b0:70f:83ef:ddff with SMTP id 00721157ae682-7117544368dmr135204427b3.30.1750085611934;
        Mon, 16 Jun 2025 07:53:31 -0700 (PDT)
Received: from localhost (141.139.145.34.bc.googleusercontent.com. [34.145.139.141])
        by smtp.gmail.com with UTF8SMTPSA id 00721157ae682-7118589be31sm7096047b3.80.2025.06.16.07.53.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 07:53:31 -0700 (PDT)
Date: Mon, 16 Jun 2025 10:53:31 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 io-uring@vger.kernel.org, 
 Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: asml.silence@gmail.com, 
 netdev@vger.kernel.org, 
 Eric Dumazet <edumazet@google.com>, 
 Kuniyuki Iwashima <kuniyu@amazon.com>, 
 Paolo Abeni <pabeni@redhat.com>, 
 Willem de Bruijn <willemb@google.com>, 
 "David S . Miller" <davem@davemloft.net>, 
 Jakub Kicinski <kuba@kernel.org>, 
 Richard Cochran <richardcochran@gmail.com>, 
 Stanislav Fomichev <sdf@fomichev.me>, 
 Jason Xing <kerneljasonxing@gmail.com>
Message-ID: <68502feb1175d_20ce862947@willemb.c.googlers.com.notmuch>
In-Reply-To: <702357dd8936ef4c0d3864441e853bfe3224a677.1750065793.git.asml.silence@gmail.com>
References: <cover.1750065793.git.asml.silence@gmail.com>
 <702357dd8936ef4c0d3864441e853bfe3224a677.1750065793.git.asml.silence@gmail.com>
Subject: Re: [PATCH v5 1/5] net: timestamp: add helper returning skb's tx
 tstamp
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
> Add a helper function skb_get_tx_timestamp() that returns a tx timestamp
> associated with an error queue skb.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Acked-by: Willem de Bruijn <willemb@google.com>

