Return-Path: <io-uring+bounces-6002-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30E32A16227
	for <lists+io-uring@lfdr.de>; Sun, 19 Jan 2025 15:28:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 123F47A2CEB
	for <lists+io-uring@lfdr.de>; Sun, 19 Jan 2025 14:28:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D19561DDC2D;
	Sun, 19 Jan 2025 14:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HID91rtm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162631D4335
	for <io-uring@vger.kernel.org>; Sun, 19 Jan 2025 14:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737296888; cv=none; b=UAbneztCq1gEScqDW9vpTdy7yTOsFS7vJZiyzaI4THR0M5jhjcfn07QFqR9SGpNvxIL1pSWiNQHbilc8cTNmnt1CeijTSoTZUn/RjK8fHjVaZzz9MKBlQT6T30CjMjK+PsPFoPj4xh4BDn05nIFJ1D9nOeWdbsxHl05RqaKbst4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737296888; c=relaxed/simple;
	bh=s/QBnPzwI+8A30i8RtyWFIiUspj7nqxP9IRumrOehlk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CKc6nEXDhhjmD4V6sGziXZG6c6IunZ5zcz0sM56/fzstgmlWg/fGJ9Yi+mk5pFq5MCIRaMG/tevmq6/+oXvt/+edO2khAOxpoL3LD40qWBI2f8bKet1VREafXOlx8gqhUYnmXQSrRfKLYc1n3UjFbhhBXFMhcidur4T2WVGiibE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HID91rtm; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-216401de828so62378175ad.3
        for <io-uring@vger.kernel.org>; Sun, 19 Jan 2025 06:28:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737296885; x=1737901685; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rDhWogoim4g5YVJEhKyf80vC+SG8qHV5+KKD/7G+Zmg=;
        b=HID91rtmuy61J0JFiHrf4tJiKxaNsxyubXhDTeENLro4QIuJXWr//svAnyWB3iOKaJ
         2JzbZbSKsytIXQvTF10O+eGua4MUwLnSdOXumLMZFOqrds3XaQcdNHjBQ40GWHTKYoZ1
         14qjp/nxF7pR7nx1xyJ4eHfKu/ft4IrLL3h2st2zJR/A6nclSFBAJXIzaMsadYQlRjoB
         OU6sX6f/DuSMKb3PdF2CwdOWejI21usGPfHQ7FAYi7BBhGrRCYt4nd2KEzG4jW116Y1y
         jyKARAyDDtLAB4ty/v9M9tWRcHtBLxYk43EFiBLu9JjLWFJeZAlpbYAVmeKXAbvRNH0/
         vOwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737296885; x=1737901685;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rDhWogoim4g5YVJEhKyf80vC+SG8qHV5+KKD/7G+Zmg=;
        b=hUYi0UXJHeOZUqVeiKGmGDqCt1ChoyT9kiE+fLfM2V5q4hNOKs3LaZO9Kz7zzPYtyi
         QoUtepX+ojNu1vWKk1hOE8kckK4rz+g8Vx1GAGXTSm25dRJG7tqW7qDB5YutzUmz+dP1
         KYZ9ow4ZLGHEI/KY3j8E+FWBq9T3chM30gktmcQEqVKzAn+bpSYPy7LzhJ+yobg5ZkT+
         FylElhI3kdOUq0mv/oDY00bJ1pDK+SviEI6wLC05rAeSQ5KjIwI3A3OyntG3JgZJ3ecB
         LgwsNUzxg8TkcYX8/8q/q6oC2meVvrWe9aPlvcZnO+WsOCUvm2CZ2TmbqmhEkNeu4FyC
         wqwg==
X-Forwarded-Encrypted: i=1; AJvYcCW7pWPcFAyXC4KPkFC+/liT009FAWhGnVLp5oNtGiQYX5NLXCPvufWJ2nsCfg+NINc8KnizossLdA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzs+w4fzRzldwuIVXTwpQ80U6sugSiet7nUqdxsWHTu4pI6JSM/
	J4QMcuLrNJ29D0Wuo+a9G3TtMZG1L6ANSvy9zlJCZHkqvqNJp/B2wuteBkRIW/E=
X-Gm-Gg: ASbGncth4LODTRucdpa+keVEXgHtq3mspMHFu7QURjUJNCF0Aogpiwomlo7ERPb4Mo/
	Spyx27S7LFFaX+YkjB2dnZUwmaTm4IvJbpAF/5I5nYv1rlpP919l82EwcpDS5PPpVcyCR4G4ZWL
	zSkYW6Xyjy6mA8qmEJLX0ozz+jc6+sihTu1mEXtu06YwDybKqQ9dKHOOOHXnIAiZsPIFErVI/O+
	Sj6/24bSi0NQBVf8Su75keiivvjg3HTI8gaReJEu8cxkE30O8ij8OT3MGkc7IZ22bIfLngPLc+U
	DtMBE3nJb/jK8a4/FIHh6oHQLRW4C34m4MTB
X-Google-Smtp-Source: AGHT+IGaG1oRqwGEeFkz4NWIiM01JQqVDYkdDntFQ46G7kDRMTuU9WpFCZ94WedWoukFKfc/EUAgCA==
X-Received: by 2002:a17:902:d48f:b0:216:282d:c697 with SMTP id d9443c01a7336-21c35544097mr119855425ad.27.1737296884945;
        Sun, 19 Jan 2025 06:28:04 -0800 (PST)
Received: from ?IPV6:2600:380:6c18:e44c:3622:e9ea:5693:cb1d? ([2600:380:6c18:e44c:3622:e9ea:5693:cb1d])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21c2cebaebcsm45456485ad.99.2025.01.19.06.28.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jan 2025 06:28:03 -0800 (PST)
Message-ID: <2c0ee9b0-bdcf-4470-88f7-80a616f64cd2@kernel.dk>
Date: Sun, 19 Jan 2025 07:28:02 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH] fix io_uring_show_fdinfo() misuse of ->d_iname
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
 io-uring@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
References: <20250118025717.GU1977892@ZenIV>
 <cf13b64b-29fb-47b9-ae2d-1dcedd8cc415@kernel.dk>
 <20250119032649.GW1977892@ZenIV>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20250119032649.GW1977892@ZenIV>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/18/25 8:26 PM, Al Viro wrote:
> 	Output of io_uring_show_fdinfo() has several problems:
> * racy use of ->d_iname
> * junk if the name is long - in that case it's not stored in ->d_iname
> at all
> * lack of quoting (names can contain newlines, etc. - or be equal to "<none>",
> for that matter).
> * lines for empty slots are pointless noise - we already have the total
> amount, so having just the non-empty ones would carry the same information.

Thanks Al, I'll queue this up.

-- 
Jens Axboe

