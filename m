Return-Path: <io-uring+bounces-2892-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1661D95B517
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 14:35:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 334D81C23168
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 12:35:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD0E31C945E;
	Thu, 22 Aug 2024 12:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P2dCnJwF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F211C9453;
	Thu, 22 Aug 2024 12:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724330148; cv=none; b=pEPEAvZUyX33MQPfPPTo3uT4H7oDXiOo0wh4LmyP2KbTIRAAOotuEKDdMeIkM0nMxIc2Tew6TpjkY+4x8sS13yCQZfXLsNhO0P50NecJ8C4U15JtL2AkT4HCOIL3GHl4Zos84fUw8kZyKPp4lMV1lZP5VYmxjCzZsexdCNzKdEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724330148; c=relaxed/simple;
	bh=1HYCmlEdVjw+c3/yAQg5gzoMI5+JTim2crkrdddZZpg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QPtmv5KudviiO9mHc/PvyVNwdetVFQq2d6zLeVKOXhD8mLyXzsxbpS/Puwkd078HPg995epAoPG2p/ANBpZme1mVer6bToQaAdvYpycTE2CWMHIHi754FEAgs+X1wkgL4ccqh7a7ymTm4s8GDvhZul6/9LVHvQwhS84XXlsoK4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P2dCnJwF; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a86984e035aso39522366b.2;
        Thu, 22 Aug 2024 05:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724330145; x=1724934945; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q+0dktRKYHl61I/Q2s7ldhzyAfIA2RsHp0cV11cWAX0=;
        b=P2dCnJwFRfz4EPt3/kerbpOmxy6690IWmXVFsoZIk6J3Q3DjuQdlZJlv1oC0t+matl
         EQ4s8RKFjQqbajlQRNE6Wjghw32T3FsGewt/TsLoUzzry5mJv+i/wZesI3Kd9SqoUgug
         l1AtAQ206ExU2z3jPdFY5RjYFvrmL/roALccdrGBSxsmlTp2whCgM5jPTvckO4BBVw2l
         R//UuXU0YzIcruf+sWw8ajAJKHkVpLHzJibtDGuOd/KPFzYDlXionWBbbPVekTOdlycz
         FDIHC4QMq98x6jk3QffIMaZ/DxFVSGyI8QgWw6f3QB3YYbTX2mE0Hf89dpdM53pzU1n1
         BD1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724330145; x=1724934945;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q+0dktRKYHl61I/Q2s7ldhzyAfIA2RsHp0cV11cWAX0=;
        b=fJlfOWzs9i4UBRsi7KdFasXyT7GJdjz+GHhS+5kY8RsRmVS1CbaDEj9jchuQUpUaiy
         lWDeSGZjkud62vEU2uJ66L8LFXpjMcffq6P80yNzwPEAXKmDFPJouhrhC1UZA452/HHm
         jWxq4yJ+gKKPBCAxRTGwX3p9zVXlpK5OJgyzFocICai8o5yDJ+TlNfy9VIGj4cviCmUU
         t6FR/Igf2+hq2aBOqUgVUtzp3vhJJD/JZzmJENZBF7YggNk0Hdb/iolYyyTXi59utxY8
         w4mjZxGk/TmZ2P1YXWtp44lZV+WDr98QaWusQPGtoXh3qAZb2ujffHAyQzdDfubLobrG
         R99Q==
X-Forwarded-Encrypted: i=1; AJvYcCUnl3l7U3ycadrKGIoAvwE1MvmMnZpCB1vMJrmMAeYjiCs8oTxJxwRDRL3gswRUvTiXHCrRbvv0Sp6gAA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwKX0NJEzFGLMXZl84M+OwsQBU0+YGUsSijIXqIzgQTD9JYDCO1
	3OrY9h3Aq48Lrvm9VW9blDsh839RgCDPUaYabAuI3cw2eVjm2bIl1cr15A==
X-Google-Smtp-Source: AGHT+IHmPxFiKloNbwibXkt5dnFisWioWsMl8U9+Jx66GEN9vlr/Ynj3g2R9B2OuDv68gFviAFDjBg==
X-Received: by 2002:a17:907:d5a7:b0:a7a:ae85:f24d with SMTP id a640c23a62f3a-a866f8c3451mr426343566b.51.1724330145109;
        Thu, 22 Aug 2024 05:35:45 -0700 (PDT)
Received: from [192.168.42.32] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a869cdd4ef4sm1556266b.166.2024.08.22.05.35.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Aug 2024 05:35:44 -0700 (PDT)
Message-ID: <d83350f4-f361-479d-b626-97cf699a0026@gmail.com>
Date: Thu, 22 Aug 2024 13:36:10 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/7] block: introduce blk_validate_write()
To: Christoph Hellwig <hch@infradead.org>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Conrad Meyer <conradmeyer@meta.com>, linux-block@vger.kernel.org,
 linux-mm@kvack.org
References: <cover.1724297388.git.asml.silence@gmail.com>
 <2ef85c782997ad40e923e7640039e0c7795e19da.1724297388.git.asml.silence@gmail.com>
 <ZsbbzDxV2mN29CYh@infradead.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZsbbzDxV2mN29CYh@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/22/24 07:33, Christoph Hellwig wrote:
> On Thu, Aug 22, 2024 at 04:35:54AM +0100, Pavel Begunkov wrote:
>> In preparation to further changes extract a helper function out of
>> blk_ioctl_discard() that validates if it's allowed to do a write-like
>> operation for the given range.
> 
> This isn't about a write, it is about a discard.

It's used for other commands in the series, all of them are
semantically "writes", or modifying data operations if that's
better. How would you call it? Some blk_modify_validate_args,
maybe?

-- 
Pavel Begunkov

