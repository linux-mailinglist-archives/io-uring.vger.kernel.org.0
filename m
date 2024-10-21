Return-Path: <io-uring+bounces-3856-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A541B9A6EA4
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 17:47:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 516151F22738
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 15:47:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1260E1C7B65;
	Mon, 21 Oct 2024 15:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Fj0Hlxnb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8741C57BE
	for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 15:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729525624; cv=none; b=J8t3ABzuohYY9/G99lsFcgQ9LA+A8PNqJLgn9LnsL4WA1Ek1eyYm7MrZbU5RCYl070xpYYB2MBn3igcLWuWYlF5PDeF3g7Ajw9XIGOiXMOF7n29rAIEOl9uSRH57BieVzM1UpK1hU3VY7ZSk/3FCVhPMGtM7XENY+6l+mJqbfNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729525624; c=relaxed/simple;
	bh=LF/v2APQUH1XNOf6nW5RuGpUkrh2C2KCHmydIhInUF0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LJxa5zyFlMyE+jQc7sdRUeFZHavGI5YCFnzAnu4ETllmG9SOTVf9hI/Pue4t3VD0WYVR8jZbyPduc9LF/QmUzNcHIpka9cAM5pyyd9oiVr0URW8+G1zp6XYyorhd3QMuGCR2OROlSCJBNu5Pz8Ku04251fpf0tZn4dEehSCT3aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Fj0Hlxnb; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3a3bd42955bso18919065ab.1
        for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 08:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729525620; x=1730130420; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kpdiAit/JMF1gHPpQc8Fla49evuVYP+pTUnVRIxMK3o=;
        b=Fj0Hlxnbv91Sqv34ftbYdunF4ZSyqRBhfKbtCP6kjxuCFPdmhz/48rj8sq8xHpbVAZ
         DewooYlqYESUb+Yq4Z5O4OBsMFXqQrSpGu4BEbMUxrvtJh7Nve4f65eSeGxLcHrju1Bu
         QDCaJOK+HhM8cjd/Aq84PBFC7kqPJAqJXP+8JNTn6rWhGhxMcuGoZfHQZccfSa/d3jeO
         W9TOKwOhhG2sXfU1+w0ZbTaSKa9vwQ8JEBy2TIZT1Z8ujizWnOJEvrLMKF5G9WmfUu9Z
         abue8IJotY1IZkpy8bk4WH8QKD/W9SGVYh6H30VSV+wZ5nBJVhbr7dEDtLLRCGYsTKAo
         gcog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729525620; x=1730130420;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kpdiAit/JMF1gHPpQc8Fla49evuVYP+pTUnVRIxMK3o=;
        b=G8hjQwzZVnm4tpXq1YhapfMkqnl3IIdV1HGnH/tpY3AuEIu5JZKTtJwgSCvkMbT0TE
         zIeUbiODVf+DVUbAiN/njauzKh3lMomLV4mlfosXvvzIrEBlBxSiPsE3luyPyHZthICp
         V70zIjbbw7xyQ2vyvW26tZVExtDFgVHH4sXiC1GmLLKQ4po/BHW5ufr6UqNipnsif7dX
         trHJpa/1KaucKlt9Tnh4/254BON+BR+pm5Tss5CYgwpfcEsxHCnR/A2m6E2i3MvTglHR
         aoH8PhxUsBPJm6dSPtOz2fnXnFsPcjup7JiNIjK1JEC4dxiR+7Ax1mIPd3IxnL6XqKKN
         X4+A==
X-Forwarded-Encrypted: i=1; AJvYcCXGk8HtHG+fw3LTPprkD6BlCSrVx8D/LXaJoHslzV8yXDnJ88XSLe0AKkdinJ6RST/ogtGGSO9Lcw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxtzP0oMxiQw7ywO4nEhNKDaU+L9whYr3/XcPLPs9lRmWbDgLrS
	l3CVrCo4wTwDwCLbPCNrAK02khToaQndL9NEsI+0n5JDbCClvcbah6Kem+pAo2g=
X-Google-Smtp-Source: AGHT+IHr5og69wO715zXAn66waKEp7aqN8OlLYyE12JW9jdHNg5lcBLqOnMIBg6OrprNLXcTQNFtFg==
X-Received: by 2002:a05:6e02:b46:b0:3a0:533e:3c0a with SMTP id e9e14a558f8ab-3a4cb371e0dmr5991535ab.7.1729525620617;
        Mon, 21 Oct 2024 08:47:00 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a400b7f439sm12135375ab.76.2024.10.21.08.46.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2024 08:46:59 -0700 (PDT)
Message-ID: <1f6c0a69-afde-4b7e-8911-683bae66e104@kernel.dk>
Date: Mon, 21 Oct 2024 09:46:59 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 11/15] io_uring/zcrx: implement zerocopy receive pp
 memory provider
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241016185252.3746190-1-dw@davidwei.uk>
 <20241016185252.3746190-12-dw@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241016185252.3746190-12-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Looks fine to me:

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe


