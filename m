Return-Path: <io-uring+bounces-6639-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CCBFA40BDD
	for <lists+io-uring@lfdr.de>; Sat, 22 Feb 2025 23:33:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D60F5189EDC5
	for <lists+io-uring@lfdr.de>; Sat, 22 Feb 2025 22:33:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69C592AF04;
	Sat, 22 Feb 2025 22:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mr3h8kQQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D0B28382;
	Sat, 22 Feb 2025 22:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740263595; cv=none; b=B1qvFq4FzcJIti58ibm4FKmsw5xo8dv7gxyymVobYwfgUArvck65Q2+Escpv23xyebPKZaHGagtwJ0UxGhsvYl/pAEWetutkPghvALRzzC+HYqmyKIwrhMXWtgm3hVLUSMOn/CK6ZVJ0qZUYV7Qe//orOeDoqpOTEuQjZcG2rHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740263595; c=relaxed/simple;
	bh=RLWtNXs9ysLMMKwXmAdPY6LGztPL9sdx0oXS8oi8GVM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hbT4yFc5fjbC3uUdkQIzPtXrUedxx5/+S6nkaJhHE1SaDcmUpRyD5edSSz7qpypoWDw0u0X/pm6XkX4PZiC0xJdHfrKlVv61YvMBWQwijS/ZDsAey4hPf17Je0/p2tRG2LIaf4C+3ppr+0AOitGWtTWDUu/tflHfwifN7bgTHvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mr3h8kQQ; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-5fa8fa48ee5so903784eaf.2;
        Sat, 22 Feb 2025 14:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740263593; x=1740868393; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OpmUdkAFvr/HHT7ByhYr326xu17suEKWbKWkF/nbpCQ=;
        b=Mr3h8kQQgZsadqJ+xZPeu5Ub/e/4bZElWyfmKLAbIrjXTVHacNMPH77xIvHEP5xBe1
         r3oNZ3TkspKugW6EhLNW00Tv94/K54O8CbtNZlmb6LR6xy5hUlxXqTo6SkHCJKa8hOAv
         hZYmGS6KfJfsYVj72lIqdlL2VPsyVBxLUgDecVcf5meAto+gB1oq1BMol5uEbQaJf0Fk
         172Htm+h1SY9GUDQUrh4ch60AJMKGk9yULFI9OjCsLHjTqZJrLcFQXPukpG6rqb06mEF
         m3hIuz1eFsDybIHJ7TS3WNyUNzQJpcA5+P/tJAoHPhjhyFVNJ1x4fys7UhKyDz3zl1qI
         /8rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740263593; x=1740868393;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OpmUdkAFvr/HHT7ByhYr326xu17suEKWbKWkF/nbpCQ=;
        b=VdTaaVZSAj1bAAOrCjmYfv4QP0/BHL5XVGebA0P8LkE1SxdCYMEAupQcJQDNnvAt6P
         y8pr+i3MDS9++nA5LkjMpQuEgkUtpmxnO1IgcBpfLf5DdzrAL+SKMy4fc4r5Fe17ElUx
         5/u75BZwP7ShFO4VjP+jV0oAKTDTgMryYcbK/OK9H2y5TclsXGEJjHkR72jIooJRslVA
         Pkrd1+uMBWcaEhLHIIC70anESl+k+oCsU3SNZkHF7hC8lrkyypPsucYyZfXuuqQCXizL
         huihfikbSrdnzMLU1sgo43rQO3/tFq6l31m2r6L4Lxr3/l3Uu0doaDHoSoi/s9cZdbDN
         kM4w==
X-Forwarded-Encrypted: i=1; AJvYcCVdJRgg3z15ibH1+PFsWfDgbjV9r1nRmpN8lXlfccUkPdcvKAgiNG8MBDIOrmvSljgQSgpClzBcaw==@vger.kernel.org, AJvYcCW4nQfgTNOVwxS8Xen7R99ihV2XRg6Ku2lWiF36eyvqrqZzOuMXvfGQSUlHaCoJVKyKqMC0mP0zunFvYZM3@vger.kernel.org, AJvYcCXXUCFiGfmd0OkKVjpvdNwIsuS23xRWRygW9UShq11ktfwc8WRvXDXQ9OuP7JsaPayqro9Ty4FQ0q4n4AWrDQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2tudhZ2b+9s6f01KHnd7BfzCH7tn6dgOiCZNFfthO0wjFOU6c
	8mfUgZ25pTQMWHyeE1Ajk2+FKzPsAXGXpf7LS6PZEB/mgcfR1RWd
X-Gm-Gg: ASbGncsc3nBnSD8h7P9lCLs6YlZohlZNmmNlD/SJhnNc2mVcfo7S0o1hog1j3eV8YAK
	oaQjfogdG1Z2ITrdiAFjAVsWolruJNFov7nmC8NnHswnZzbYAvvEdIyKrMMeVOAfoyZC/GkDBjw
	sbMzhaLgbNAPdglxaUALLrrUh8nZ1kS0SO8YlEOITMPVeywCmfweQE1P62No9fU+bDFixa2nYmj
	Dqu6TAMiv8ocQ6xQX47Wc/vxy1VLx7erUHH2/KV6q7BBacnV8oAviP8cEywymNFmiP3CHjdki+G
	hWakfNTpJZX7cCmV9UvOnmCBPVhtbCTiDUF2c6lqAiL73lwrTWnuRFoeuelfwcp+JOly9+W7aeK
	TVqo6oV573OOfWA==
X-Google-Smtp-Source: AGHT+IEt4I20z57w2RykjGAqyFdMYoecevd276qdDBpBuzxP63YseJKRAHVSAehXQCSvmiFxAVIACA==
X-Received: by 2002:a05:6808:1920:b0:3f4:435:cb0e with SMTP id 5614622812f47-3f4246b695emr8093156b6e.9.1740263592796;
        Sat, 22 Feb 2025 14:33:12 -0800 (PST)
Received: from ?IPV6:2603:8080:1b00:3d:9800:76a6:5d39:1458? ([2603:8080:1b00:3d:9800:76a6:5d39:1458])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3f3ff911a99sm3093693b6e.33.2025.02.22.14.33.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Feb 2025 14:33:11 -0800 (PST)
Message-ID: <cda3cf68-6ed1-4e06-b29a-ce5aee34ec20@gmail.com>
Date: Sat, 22 Feb 2025 16:33:08 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH] Fuse: Add backing file support for uring_cmd
To: Amir Goldstein <amir73il@gmail.com>, Bernd Schubert <bernd@bsbernd.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <CAKXrOwbkMUo9KJd7wHjcFzJieTFj6NPWPp0vD_SgdS3h33Wdsg@mail.gmail.com>
 <db432e5b-fc90-487e-b261-7771766c56cb@bsbernd.com>
 <e0019be0-1167-4024-8268-e320fee4bc50@gmail.com>
 <9a930d23-25e5-4d36-9233-bf34eb377f9b@bsbernd.com>
 <216baa7e-2a97-4f12-b30a-4e21b4696ddd@bsbernd.com>
 <CAOQ4uxgNyKL9-PqDPjZsXum-1+YNwOcj=jhGCYmhrhr2JcCjNw@mail.gmail.com>
Content-Language: en-US
From: Moinak Bhattacharyya <moinakb001@gmail.com>
In-Reply-To: <CAOQ4uxgNyKL9-PqDPjZsXum-1+YNwOcj=jhGCYmhrhr2JcCjNw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


> Without CONFIG_FUSE_PASSTHROUGH, fuse/passthrough.c
> is compiled out, so the check cannot be moved into fuse_backing_*
> we'd need inline helpers that return -EOPNOTSUPP when
> CONFIG_FUSE_PASSTHROUGH is not defined.
> I don't mind, but I am not sure this is justified (yet).
Sent out a review for this. IMO even without multiple use sites, the 
static inline helper method seems cleaner to me. I'm ok if we don't want 
it, but I really do think it would make our lives easier.

