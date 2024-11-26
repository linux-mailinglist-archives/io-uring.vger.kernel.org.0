Return-Path: <io-uring+bounces-5047-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 80CD19D8F90
	for <lists+io-uring@lfdr.de>; Tue, 26 Nov 2024 01:33:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 211BBB29233
	for <lists+io-uring@lfdr.de>; Tue, 26 Nov 2024 00:33:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 510BB3C14;
	Tue, 26 Nov 2024 00:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nc+KjNwP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDB679D2;
	Tue, 26 Nov 2024 00:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732581188; cv=none; b=Pz+qVHsrHU6NZ+20i+wydXZMoqRvt0Fmwe38yaaCCPm4v7O3kAZnk6jKLvI0/w95jv++jK7uyv5+2dS3jlPYijpWgKp/NkyRKP4+mNIBueLXeLnACIxEgIbs2LkusqjtU3r/1Q81+q4g/GgA0ca+YK+DUXBlEAD+UT8ADwvRW6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732581188; c=relaxed/simple;
	bh=5EHVuzh066EnI6nub6/pnNW9U1+jsKJr8tRebQ4PCrA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=S+sqUFkU1OmYUCFIHwuc2xmGSocW1NpWi6ZPaF2JGaaKsV6OyNsJB6vj/oVF7cdGjB30YCIlujVmuT5XRXa4ll8QLe666xdp/hJh59RSCFlX8elo3U8s8LP048nbWJjdWlYcbgvkVh57rW1XIaqVkeMPvjCMt5+ZU59+okBc80Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nc+KjNwP; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3824709ee03so3641029f8f.2;
        Mon, 25 Nov 2024 16:33:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732581185; x=1733185985; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yrtKPrbIgqR07KYGtyJNTIsUmt5QaOuuCjfMUACj5cQ=;
        b=Nc+KjNwPpZxjZYojgtZC/rfHcot1klxKCFT7y3a+D/i/qBevqU3M1z6Whhz/aDRFs1
         WxlzpkT63c/hzwZHYQxRO5ej4IHEGTxL89aK7qFztevLdcjoXOFOLmbjMycphAJ8oWYh
         wi6fQUaVQbjJHZkdBLcWe5J6GUW7y5anUw2kTWhr98NO7QsuzBfqSZ8PFTjqSZCbcQoG
         c1ukWtU1mUCWBODRN+vtIJtNNcSzw9rDbcuSoxTrqDuR3kakhc14gYsOKqykNegnHE7Q
         UbiZP13fHx9Bax1PR+oAAPWUdk+GetP3bksrcJDLyTy5i52w9jZ6x/AtpOr7s+5KOrfV
         m/hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732581185; x=1733185985;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yrtKPrbIgqR07KYGtyJNTIsUmt5QaOuuCjfMUACj5cQ=;
        b=bK+GXa9xbiJgyMGgk1aNh7Han83g2iPk/angTIGZV83qqTf9M08CaXZfPUNvWZVzri
         iwuqO85lYWnu5aTp8NdLc5OZVwo6WCf0/sQ5JCAz9tF4in/DFMtnwvG1NHue6C2U84f3
         kgneOiOUaDQoI2D2M/6VpH4mbEzlsuSiNEDt9iLhG/TVDlBuZPS0u2J0nr45rUWVHqGV
         iWoh8lLfZyK7hXry8UET+gLZadMfP51zZzZvl0yUHlnxJQRqF+sCxxlqWjFiMnXh2g7K
         NDqs6ifFBCIWygxxik5JofRBcIFHXaV8a1zSu6bN0oCaQhRlmhkPC8AIuJxZJf3Z3Y85
         EadQ==
X-Forwarded-Encrypted: i=1; AJvYcCWMm8UqVbYCG4lOKLAfpRSxKbH0xaCRchrdAwnTneq8SNHOL+C80Ln2wK7QdHsWFyi4Zbel79LCxw==@vger.kernel.org, AJvYcCXddCTlWHVhLvgucbn5E40l833g1/npYAgWjWEU+a3NPZ1Pkx536ca1CThdVbzsE3NJRonZNX+UfM/KMzd+@vger.kernel.org
X-Gm-Message-State: AOJu0YxObP4jlEPrrr9ePqEc+bfuClSV5zOGKFAQMXvbFzYChkA+2bto
	9KSokwrVqkqJsLSQzw2F1ql5WYPgvN91gNXefGljPdp+hQ+woj/b
X-Gm-Gg: ASbGnctxg+DDGbOmV2CgtgwbB2/HhKDIUXb4yVn3SoCKWKopY7cXPMWO+RUtmFW7hjZ
	AJoaajX6+hzwlKrGuYlPksELJeh6toOxXuRqGli+9PDWJRvtVV/HCZWkEsgsWJITa2QehUQuQHN
	JgRCsFBl4O3ZLI9Au9ZzvDIeLPtrhbsvfUv4Awvm0L23aKQbVDAiOnoACPTzmeQ5Q+OtIC35Is2
	0pu5J1ohKJlVh40Qel7nMrI+Bcul7BtdbCotE9LG9vDG3FZlJ2tlFvFe2U=
X-Google-Smtp-Source: AGHT+IEGrpwDNpw9ehsr9qkJwHtW3IiOOOzDqyzDorNJDXfgbt+9EkVkohIU95vfumQpAjPhOCNqSg==
X-Received: by 2002:a5d:5f55:0:b0:382:4b80:abdd with SMTP id ffacd0b85a97d-38260b73d1fmr12261704f8f.21.1732581184918;
        Mon, 25 Nov 2024 16:33:04 -0800 (PST)
Received: from [192.168.42.143] ([85.255.233.86])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3825fad6292sm11742190f8f.19.2024.11.25.16.33.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2024 16:33:04 -0800 (PST)
Message-ID: <1806e4a5-7e78-4264-87af-2468289e34af@gmail.com>
Date: Tue, 26 Nov 2024 00:33:52 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] WARNING in io_pin_pages
To: syzbot <syzbot+2159cbb522b02847c053@syzkaller.appspotmail.com>,
 axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <67450969.050a0220.1286eb.0006.GAE@google.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <67450969.050a0220.1286eb.0006.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/25/24 23:34, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> WARNING in io_pin_pages

Tested with the repro this time

#syz test: https://github.com/isilence/linux.git syz/sanitise-cqsq

-- 
Pavel Begunkov

