Return-Path: <io-uring+bounces-7230-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A282A701DF
	for <lists+io-uring@lfdr.de>; Tue, 25 Mar 2025 14:32:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E15C18884E3
	for <lists+io-uring@lfdr.de>; Tue, 25 Mar 2025 13:16:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7F7F259C88;
	Tue, 25 Mar 2025 12:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CX5aDAh+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1691EBA1C
	for <io-uring@vger.kernel.org>; Tue, 25 Mar 2025 12:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742907129; cv=none; b=Sk8CUkOnxZlb8Jw20MpIY3WNKJ4lhKyibtCEpLNr4DfNOVbTWGZzVxZ+X8LoodXMgosSElPlFMgUFk94HkJ02On+iIvq4DePG9IokSRK6zblobHkRY95YyXDY7o99OfMvivXW6kZLOn4RX2V3nCdonf3OHpt/nEfcaNfPy5fVSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742907129; c=relaxed/simple;
	bh=tj03Iy2cOddp5Dpo6rnyDthdPVJfZRvM2w2yOeQBtyc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i4GUIgbL8af9vF7xLCWscNZqEGlr6z/2yWOYbb7GYWONXjHTrWs9slFgvamf98cZWjBQrpx0e2wdMifP8UaapLDMFN8qB+ePQ7TBohKj7HuM5SlZVxEPjT1OFJ8KGIj5V9r3TW4xUQIesKqN0b1LHutabHXTmla/r1NbdkYVGFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CX5aDAh+; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-476977848c4so56527061cf.1
        for <io-uring@vger.kernel.org>; Tue, 25 Mar 2025 05:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742907127; x=1743511927; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oPJxOALUzRJxRqwO/dJ1oQ2Yu8yWnLQ9Qghb9Fdffx4=;
        b=CX5aDAh+B2RplNkVJaER0zHAmQ++nERhrzKiz8fSi4iwM4tbDKnj5Gj5wym3VClJKe
         WGNk9eC8v8wl56SR/ICHu/H+Vqn929dHqH6bHeBuYWocWOoW4qEX0dtVtGU86wtfJgVi
         xLpEzUF0x+Yh3CeO5dQ/U2HtPgP2/8wRVLZOZQT7o+1yS/X3E4saigIdwBZ8eMqN+/2Y
         Z9v9+A3c5y4X9BclrDEMya1DNFrbNNREWJfgiO8o4DOWqQtveztTgxa7/FbHkq/RmPgX
         FxlVTCCBByZptzq96ilWR2RVhryQJnvYbnz4n3e+0popfOVLxFZOOB5oG6bGQICU8fYO
         Sy8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742907127; x=1743511927;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oPJxOALUzRJxRqwO/dJ1oQ2Yu8yWnLQ9Qghb9Fdffx4=;
        b=gz19JEfwTcruyZU90Hky/NEP5ILRgKEXsqEgUvVr0PNiw4mI57PiY5Vn4TT+ABEfb6
         rc/4CQbfe4P/A5jBr/m/yHmXuDkJ/k+rxiJkSHwbDPpt9vyEPdRkwKcQNLAhkN6a3wjo
         t/BGYUkOfINKvAc3xwG1y+cYyqwCR//b7E4Mv94AvXNCES3jtfmi9wLnZYeW6INQvsbA
         UqXHI8WA/POZEc0h5G9f+emaMjPKBSmdKr+P7+E0RWg5HBxBV1lKRsiFX1oCQCmqzeej
         tZXqHhAwrm0cci+nvLJKpC+VFoZmCEBMMjOREXWXP8rsmO7myPPlRURfFohVnzLhg3eq
         TFmA==
X-Forwarded-Encrypted: i=1; AJvYcCWpzNTIjzooZ7t+dnkzzluaT37xPpLn2grHKqj2v7sJ/nLIeWJIHFwDbay00nTfzZRR557Q7qWMOA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyJTte0wWwNzicjLWFO3Xm+CIRXKE+tbhWllajGTQWEceaftqEp
	1K2jtjz1y9OxyqrT9ATTaVezQ6H8vTTiDsvD6FangmHOv4tWX7BtSOUTC1rQQ0I=
X-Gm-Gg: ASbGncta+BDcBRNt3MDgTjKbe67IotV5R06I+j1gDFdGrPld2ITBWb99oixa4pQNMnz
	Cc/7MuE7D9/A5YYCT0iwOldJj0VGPzj7NohJ8qX7Ni+rgj0CiAzZ/Fl9m3tY4XWEsHYL3mrBe5n
	CpOsHRYamvk//YQpvebamFgrlbu8uqEPp1OqInazW0YzBsHowa/SHbO2E8NRoF6I7rLZDb6zV9R
	ZcNjSEXeSZcXEzDOn0zldCuiSlcLpihT89ra/KKe/hQuNheum4gIi7e7NnFh1W7FXvjdmCi0XBG
	r2Sz+3AIjiWozhq048bNlifLPCZlT1535kd6otI54w==
X-Google-Smtp-Source: AGHT+IGqEToBEJbz0GNzaBV9LfDIy0nCojMJeT0B2Xje5qrSOLPVomFIE6YsCWtEQNR3KpSKRJwAJw==
X-Received: by 2002:a05:622a:2513:b0:471:b8dd:6411 with SMTP id d75a77b69052e-4771de62864mr302505941cf.47.1742907127141;
        Tue, 25 Mar 2025 05:52:07 -0700 (PDT)
Received: from [172.22.32.183] ([99.209.85.25])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4771d18f6a3sm59449381cf.38.2025.03.25.05.52.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Mar 2025 05:52:06 -0700 (PDT)
Message-ID: <bb7eb5db-6675-4e24-b08d-b48378ebbc88@kernel.dk>
Date: Tue, 25 Mar 2025 06:52:05 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] nvme/ioctl: move blk_mq_free_request() out of
 nvme_map_user_request()
To: Caleb Sander Mateos <csander@purestorage.com>,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, Pavel Begunkov <asml.silence@gmail.com>
Cc: Xinyu Zhang <xizhang@purestorage.com>, linux-nvme@lists.infradead.org,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250324200540.910962-1-csander@purestorage.com>
 <20250324200540.910962-3-csander@purestorage.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250324200540.910962-3-csander@purestorage.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Reviewed-by: Jens Axboe <axboe@kernel.dK>

-- 
Jens Axboe

