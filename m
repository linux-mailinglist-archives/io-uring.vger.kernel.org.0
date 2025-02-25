Return-Path: <io-uring+bounces-6751-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DF177A44555
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 17:03:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 268BD19C5E3E
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 16:03:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 639D7175AB;
	Tue, 25 Feb 2025 16:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ac1jta0D"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE78215C14B;
	Tue, 25 Feb 2025 16:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740499398; cv=none; b=Tr+UXXgYa1wnhpoiI+Ih7hbW2Z6rLStIV200L9r5/JMJgd0IGOtiwxg4KF1bJVukS2Uay4dZduxMJfICOI59ugrKPxvXyRYAg9JbREwPdi6COvCW314KBRcUvfWzGn77t49YWqItizmsVIfs0VBrXS5AmpbjV1TBTE1uwaUMgjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740499398; c=relaxed/simple;
	bh=X4/2DA7iaxqlHTXjsynUyuDNJ0XxSPs9nWcSzVkopYM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kqDExjyQ6jkAufEDj1Dsk6J/scnsFiCLZHUCrHtNI6/3Izx685MQPaSJbRBg6VzUHItJCGh9KGKQvUnhQJjYIdfikBUBVlddB1PAOhrCZ/1U8q8ebpLpRTWKG6quN2i4G+orPDmmd5oVaOnGt8CxzK5ZF6o6leBMim67zA8qxfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ac1jta0D; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-abb81285d33so1109678266b.0;
        Tue, 25 Feb 2025 08:03:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740499394; x=1741104194; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ipewdMRD1nCVcVpjgeEJlDhYkaA7eDoFkcmAftoRLrI=;
        b=Ac1jta0D03vwQ4ADHVbDLVhgR9F/JewMVNqfIWNEhuiOcj2JyYNYQDO7JNyDFyQj0S
         ixQKqQOGPndSuKMaHV+6oyEh/sxveCX5gZIarq+CZYnJDmGgj8415v1gk5Gqi0jOafGi
         xXO1Lo4Ld0qhKVgtRA7xJLXoWL3bDKejvqRX0GjjWlpXQzXJLdsTqmdNL/6daudED9Ek
         ukbDFnE7iEeWhqWPqRP2yp3sZInXBw3/gNcSwuF+t91NNJ46yZyHj98+HTVB9e4KRSck
         spCXjmA8yxV80cKxI/FRJSVulRVeKRlSFdLo3SZpZ2ulDb7fc+5ad1IeN+04/fkfnCjW
         5MkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740499394; x=1741104194;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ipewdMRD1nCVcVpjgeEJlDhYkaA7eDoFkcmAftoRLrI=;
        b=LpYQEsCf66rA9vfGJvkeqpKH+ibgWlJobj8Ai1XUR4p7QHJGthaPlOTqgQWmbjDrkd
         xmvhkMeCGwBOAonyt8lG32F0ahIKNRqAeiUb4S1PWODWbXFqlumyxwcRnHr6K8jFnR2u
         q54Mj7OSswbV1067dVhzo3NqSeS9f+/JkKIDHcHtwI2uolm5kOBJEmkPJJ3yNrjooftS
         xdI5Jp2msXMLCZo4iDhHapiT5dkNy7q/IOMxnizsxACo8FK5KZChpXyZ3JUQQ2YP8Zvr
         czmCv9EM8jxD6HFbrUn6SMK4W8Qqz2CDBErrEN2xfsoPnWOIoUfEBjJrxqg9E7lffF0M
         a6ZA==
X-Forwarded-Encrypted: i=1; AJvYcCUGEBVRiU2e5C0I01ka8zv0Orx8CgNVIhKbF+hSCKLjCrw2GRkpCrAfQkb9yb7RkmgBAOnUF6wA1fwdk90=@vger.kernel.org, AJvYcCUouaqoqNXVZMi5N3iKN+l+QQtHVBhm+a+rNxpAiQd+QOwsYOON4MW9Qpu9Nf4lVOgYglmzOzfkjw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyG9C8WDvvjyl+0ab2N8I1u9TfrBRUt7FrR3Nb5E2JbRmdRJaUg
	0hECAAHcn9C48lAEPrpR8dPL7SFSemaIPptQlQkUbQbUuIV7yw6d
X-Gm-Gg: ASbGncvZnjQ8NwEdHVMmlzj8G8exSDQWG3eEUQYF4OWBtC7zjwZNWaoUkNSz/i8sg77
	0ygh0obYTA+K8Tb0CtPV46KYH461zOx8G6088brmhYCL2Sd2Qp4e8O8jqOZWkadSjFpqFmEf4pN
	MQuZre0ow5+h/bSULFXs1pg0xoZ01B3TQ7VnA3iHr8VHMpMfUVfyJkwEGTmx80B2wBfdrv586+t
	+eL65eybIiIq7dj20ITEiLdAaLGCx97eLKITeOh+lafMXMLTwLs0xdkJmStfQQ6sjJaBTzO13dt
	+z/aEyb3VEYCTtojLIeGnHe9RNl9A55NF6ebFpyIaH5jks7l80W9omSGZ40=
X-Google-Smtp-Source: AGHT+IFfOTbzP9u2gwE/omVUjwOuG51c9V4XmyPaI6aplynHopfrV0s6mGQlsmSCUZFNmXJOLoqs/A==
X-Received: by 2002:a17:907:96a0:b0:ab7:f0fb:3110 with SMTP id a640c23a62f3a-abc099b380emr1930780366b.5.1740499393434;
        Tue, 25 Feb 2025 08:03:13 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:9e08])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed1da0803sm162065866b.76.2025.02.25.08.03.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2025 08:03:12 -0800 (PST)
Message-ID: <6b8a61c5-364c-44ff-928e-eec6e1dbff08@gmail.com>
Date: Tue, 25 Feb 2025 16:04:12 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv5 10/11] io_uring: add abstraction for buf_table rsrc data
To: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, axboe@kernel.dk,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc: bernd@bsbernd.com, csander@purestorage.com,
 Keith Busch <kbusch@kernel.org>
References: <20250224213116.3509093-1-kbusch@meta.com>
 <20250224213116.3509093-11-kbusch@meta.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250224213116.3509093-11-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/24/25 21:31, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> We'll need to add more fields specific to the registered buffers, so
> make a layer for it now. No functional change in this patch.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov


