Return-Path: <io-uring+bounces-5564-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B147B9F68DA
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 15:45:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B745C1898897
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 14:42:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1973E1F2390;
	Wed, 18 Dec 2024 14:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GNdiAf9m"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EF11F0E33
	for <io-uring@vger.kernel.org>; Wed, 18 Dec 2024 14:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734532831; cv=none; b=kPWlr9oBHehUc+OnaAQaNJEivwzjFJH8q+8ivll710Szwt+ECbnNQG1LBYJU2ppDre1nPOtXFZkxpz6c+zhyTwGJV/ZgbqHpEOrjXWp7nRry/ZxrqU7B4O1FbMr6U53Vbtbmf/uH45QEMlLxLIDNpb3lPH/NAGgXZQiKPHdOa0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734532831; c=relaxed/simple;
	bh=NutV2UpKj6s7PqPNFOfGdNacIA0IVdXlKusPGgaLyHk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tDIE5vdjYe6HHv8Azet/mB80XwtFUcO8QjwaPTs2oYFYjv8F3GHyNg627ZH6TFiWeJdtxndYDSyVUselVBtKND8pIN19vjNf2/D4dXCLyoSIslIC5kNEeiZRh0LgCcYBtjmLbnj/XuS7H8EWybCQ3KI+YkSX/I826UzkJ/0O9jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GNdiAf9m; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3a7dd54af4bso23457485ab.2
        for <io-uring@vger.kernel.org>; Wed, 18 Dec 2024 06:40:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1734532827; x=1735137627; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AJDGOuIdnuxZMwEFopgwHkwjXajkMEZIhm8f0iRuciQ=;
        b=GNdiAf9m06sL86/Eg4ULKAAtQIq5lElpM8xCMYTMqwIOY5dW6ZyK+M//PtxEhaL26K
         t5st5UmxzBvcbkC4j47oMvQUhjRpgIZi5qCv2Bfa4ufxrXiA7Aj3AtHCDU1siGpxouGk
         ne4BgAsCIXRgYreySZOfVLl/3Ef9kXG4s3UlX0F3pt/FzJrS5xqwEAntEF9wA3HJBF40
         hPoPW04Uc6YCqJMtRCV4Pp5I6pKhiVDybjQm1mpX2GOl4UkQM0RofDxYE8wRTce2xOfr
         miUWxfQHIRBfVybXqjC9nJ/iHP2LA3lhEMqrEEjRZoOGgioeR8jjj0QyLZcoW70Ug5eR
         pS1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734532827; x=1735137627;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AJDGOuIdnuxZMwEFopgwHkwjXajkMEZIhm8f0iRuciQ=;
        b=auA65J88Wnd4NRbr45gjfIlC4frjmefMwoKmM1yD7iPSQCe3kfhOfsNNU4lDXtkHzW
         etYYtn7Ws7b3aTtz9ZqcIRDSozA7lMY9VrtNgr9xlEZrn59p8FLV6aaHHN7XkUk/yu/8
         ybZyj9GBmtp5Bxt1VywPfr5Bu/pJ+eCAYK1S3kHaj82soktYwpUAb71SFJpOnRwoYW05
         pofiaVbaybd/n5a8Gys39gpgMdl1n8M3sLFn7Qao/Vf1P+BK1oDrxb3hXeSzN2vqbXKn
         irh3ZgMivdMP4JLbUV5ykXZkguSxq1k2UT/7Du+ThZLC2F1cB0LuvSlLXIRLf5cJt639
         ymNg==
X-Forwarded-Encrypted: i=1; AJvYcCUGS2XS2m00hruz+Qp5G2FGzNgF/lSGh3ntUHwNvSYzc2xK+n9xjHZ1uG+3OUds7Le2khVUouyWRQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwW6bbrIQpTMcT684eE/hWL0zgiA8zngRsno6ugp/k2wqSIeXSP
	Djy6dsQLlGK0OuyeG6cISV1wwIk3vbZj8EsZrAKQkbfjiw/tBcRa3h3sZ0AVpSE=
X-Gm-Gg: ASbGncu7wRriFxhMWNKs+YNRyNzNWJ7kruHPOZ42pn5b0J4HtUwgonFH+OdAqWf0NHI
	bbYoSTjImTQjo0D6yRIRpVF9etsk4i9dlYA95Jn6mKCRgGp+fjInnVfbYI2V0B3fkJhWGyhThrS
	EhrhHtTTHICZIbGr0bItWpjAsVyNSzhMLT1HS0hdKFuocxmgTvlnSevZ+dMspOYO243rKQJzIDW
	A/ti4Use/C1b4IfXaFQSmmUQThVcReIuIw8bpISZD900BjQHK2R
X-Google-Smtp-Source: AGHT+IF1xjYTetHQMKzb4AksPKutzVdeTKW8D1c5CoJVkGJ3rlE6ZV7s0twdl7FAByD4Ss36+SV8bQ==
X-Received: by 2002:a05:6e02:3308:b0:3a7:a3a4:2d4b with SMTP id e9e14a558f8ab-3bdc1b2ac71mr28204275ab.14.1734532827048;
        Wed, 18 Dec 2024 06:40:27 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3b24d8dc980sm26733005ab.67.2024.12.18.06.40.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2024 06:40:26 -0800 (PST)
Message-ID: <25bcc402-623d-4449-aa48-82b809040f6d@kernel.dk>
Date: Wed, 18 Dec 2024 07:40:25 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND net-next v9 00/21] io_uring zero copy rx
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241218003748.796939-1-dw@davidwei.uk>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20241218003748.796939-1-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

For the io_uring bits:

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

