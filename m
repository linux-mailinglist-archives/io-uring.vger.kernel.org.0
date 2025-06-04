Return-Path: <io-uring+bounces-8217-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6010ACE19B
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 17:37:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD94E16FBC2
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 15:37:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 072A717332C;
	Wed,  4 Jun 2025 15:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SvpvAiLF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C2718A6DF;
	Wed,  4 Jun 2025 15:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749051452; cv=none; b=k0c5ltldw3apNLIN36fkS/Hbyb3LfFIWAMuzbmNgFQQ4vha/Pd932fIfk4ky4VNnBI5skZMKCYuomY6zxAYDDJQpsqkWKLNx4Ce6Ak2S/smCBkbWIafCk4MAFbk+iaeEavfVEpc7jBIXXvDA4o2ChCRZPTTgGdKHB5zfwKU2cJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749051452; c=relaxed/simple;
	bh=OIWScFTbRtAyZU8qazE2K44V2EpK2DL+b0d+DcCMzXc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L6GPOw4UIOz9tI9GOCHNnPB9WoPSovc4wHeCPpWiJdB5LipLSFjPZx3jaRj+EmeO9mFzzDuFwUW5epsvErxDjkDGvEN+vR6GRgHFXS604LEQQqCm/Kpr1VqQC/RDozKn3Y6kchs78lAC/6by/lhP9INBVYXZrN9MYb7Cwr0O8k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SvpvAiLF; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7390d21bb1cso23516b3a.2;
        Wed, 04 Jun 2025 08:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749051451; x=1749656251; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5fSk2OUmkjj7RD/Ad1phnyBOfqyAgqFwvFeqjBFY26s=;
        b=SvpvAiLFjlh1Bql4ZiPYCmnstaM/adYT4Zd0ee1pJJR5P9+mYtocosUpzlgo2/dpc+
         m0kNQVIP2djnikDEEgc1aev31BEbx35qGzKdpislhh3KAFpwtx3fSt/ROTSoQLKqG0wF
         vFdhoSm9PnVfmCYr3t/5yVWBkv4EMvj+Qxz0QhVesfpi8P1Z3Bdwbf/2cLqS+0mAaaa9
         OoBjuxS4Mwg+D0GCfrO/ek3QsvBMJ+6KbcASpUvxdmzOIYxLrdYLDb46+7Kx8GmoWyWK
         BoHQvl8A3/uX6YwndpdgVOrlXAEfy8rqMwTuo5DcKdxG9xvsCF474jFCzHJTyMwLy6o7
         /VoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749051451; x=1749656251;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5fSk2OUmkjj7RD/Ad1phnyBOfqyAgqFwvFeqjBFY26s=;
        b=rbykcA/6rNKxfmb3h/5oPnvPUNFsa1E8wpf5XScpR550f0yvxxlhihL2NQRDULCC8k
         MgNj6SmMzr4Mv2sG327abora4bIR/MHxqOnldE5fFApYOayIj4Qy1A0QyVZngsFclkFB
         TvYaI68LJZq0ryhQk17Y1YeoApcS6dEB1DFalidxbXPx2RzipTjx7xGu9tJH3rzVoRv4
         tJaJnJvrwWpVWxeKC+Shct+ee7ym1yGSSYpB4FFPPrgbSCqIAIj5GrVtrSzHq7/1309+
         7Vi9He7fotH7KJMf/7p9LQGxF/NaBefzYCEhDaGk7EhWUTl4uq6HzRnyS4VF71hEE+bK
         5dyA==
X-Forwarded-Encrypted: i=1; AJvYcCWbfchAjs49vy82zTpSMjjrmAgUZ02xjGHruNGz9WSjaXmgnlhgak7GjZ/q/3jBI7verHfv5LM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzTNV7nLweufzCxCcV7uZPqO0j6Xvt4DNJOChmg6WaSQLtYwKU
	FnBGhz+N6c/O9K15Nc/szDrFFrJ3z7uDaMcEFIORy/LOUx3TfrQ7Bg9yPZK7
X-Gm-Gg: ASbGncsvvFL7psYQMxzUiqWUGFkcTPytn3adFAqlK5VeJQQH7V3YDEUa3hYPm19ZnT7
	ZKYV5o8Pi68IgBnSxAthlfc/VJoOoA2lGXtnNpZYMYhz81HhvdOvaofh0NTr2wqMTTj9Mspzinv
	eVgJUL4DLHgIx6hkZpavMt/1pcoXpnYrtgZ/unn1DDes5P8XWsEtlhTJcKnJPt21eguujP+gm9+
	knBkrGGxvnsYc3U74H32ZJvu8J1T1khKTGCe8OA1CzyR+p1cl+b5WaeMb0d+4VPlrhLCAkK9+Os
	bESOM7vzN5zCSYjZpJk5oyq0M62RoDfCff16Oyv6HnCsf5RZHESl5BYnm8JJJ+WxoxIXb2bTVZU
	kBosc57gNYeUggXVrwAprEao=
X-Google-Smtp-Source: AGHT+IGjrOWo59Mc0cOg6HI4CgZRpA8eUXaieFguKTRl0eq2z1lxlaQMgrPHzEA43wahX+9WTLdXlA==
X-Received: by 2002:a05:6a00:2e86:b0:740:41e4:e761 with SMTP id d2e1a72fcca58-7480d059991mr4446654b3a.22.1749051450662;
        Wed, 04 Jun 2025 08:37:30 -0700 (PDT)
Received: from localhost (c-73-158-218-242.hsd1.ca.comcast.net. [73.158.218.242])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-747affafc55sm11664312b3a.96.2025.06.04.08.37.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 08:37:30 -0700 (PDT)
Date: Wed, 4 Jun 2025 08:37:29 -0700
From: Stanislav Fomichev <stfomichev@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH v2 1/5] net: timestamp: add helper returning skb's tx
 tstamp
Message-ID: <aEBoOaxXbqBSWuOV@mini-arch>
References: <cover.1749026421.git.asml.silence@gmail.com>
 <3fd901885e836b924b9acc4c9dc1b0148612a480.1749026421.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3fd901885e836b924b9acc4c9dc1b0148612a480.1749026421.git.asml.silence@gmail.com>

On 06/04, Pavel Begunkov wrote:
> Add a helper function skb_get_tx_timestamp() that returns a tx timestamp
> associated with an skb from an queue queue.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Acked-by: Stanislav Fomichev <sdf@fomichev.me>

