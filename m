Return-Path: <io-uring+bounces-12898-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gGiZD9bPy2mILwYAu9opvQ
	(envelope-from <io-uring+bounces-12898-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 15:44:54 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A41CD36A70A
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 15:44:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B0A73312BCED
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 13:39:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C00AB3E8C44;
	Tue, 31 Mar 2026 13:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1mMHaeQv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502A13E316C
	for <io-uring@vger.kernel.org>; Tue, 31 Mar 2026 13:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774964346; cv=none; b=CImmn4rxrHjVKkj59/jn//UKO079PDy0By3jPrQzQQE4OVr3Uh4Mr45zaPlwDakY+XynjGWEfMGHjnwfJbRS7w03M3r/HT6EpZGhLt61b+3JerxpaCMRrQqMGP1H0j17jMY76yFBXRnhDXODb4xEBKt12qK6yZ/tujIpcoW48l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774964346; c=relaxed/simple;
	bh=Z/EC+aRfV8ju1um/gIwX5O2VLsueuB/+hiQhhMNao20=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eeMbU3JCVQzsS0Y/8svjx8iGPtpkHggodQ9JpCLUTgCrmhwMvuqOdegQR6c38Ir/ThmxS0ngx+nYDdsfnjUEk6deWmdACHCVnbFsJplon5fKnH47mqBMiyNzpklEC5k8wqioMATKA51mL9owAcRG9OEbCsVz7HYz/sCTxBPy+2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1mMHaeQv; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7d8b2703f37so5279899a34.1
        for <io-uring@vger.kernel.org>; Tue, 31 Mar 2026 06:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1774964342; x=1775569142; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=50nUh9BMCsdvnViBxcjmC6PQkZINW8u+M608QuKp/5U=;
        b=1mMHaeQvCorgLSeyVfkK5aRumHxSEleczGOzh/NGEdXT/Q1jiFGjv4DTZzBINf4bMN
         /UIDaokzgpDKoLwDhuqg5WBUwhaMOY29shOuhh1W9jUowUbKQiwzMDTCnNA7AVb9FaJo
         eXccwEzYGOx/+ywhrgfydS/p3HjJkt5Tmc7H/+zJBpsSJXLSd38QPomPLQEtwOEZx0ZR
         Nroozu+QqELuQGV7qLWMWXUExB/kduYJztJ7IUiHJtlJLSIBD4fiQKU3E0hzrCcNVmjK
         lUHJDM0+9WhNOeQlbcf2J6VKVak9f+sLPZvdw151qyusbjzryuKDkR0wvbkUvfEicuby
         WVSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774964342; x=1775569142;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=50nUh9BMCsdvnViBxcjmC6PQkZINW8u+M608QuKp/5U=;
        b=PHfRpt7tS4qkdy954gC7thx6+I5U32eMsrd41MH860BOGotLvMimajeIvV4DWwIHom
         u0sIN/efvngNk8PqhrE69Df8k+lH285gX4qDztRHZlqIm2qPlPL3gUo0npL6zfBJn2oB
         QjRHoTL1w93z6DRlUncitTNppBX42Ag5uA+OijJYjEXBdZiO9BotWa8Z6nF6kUlwq2B/
         x2tXGnqVZDestuTU/ZLwO8S7ono81yKQ9dby5k3hNMHIEN8ToSr1G9PQ9dLGBRS1z87j
         SzhCuv3JZEDEJmB6RyzaLFcyCiyCv8VArZm/OyCVYC/z4u79/n6kAnitNV10Cmk3UXjY
         7dZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDRUTjj34ef+uz3CLB6bO6a/GQ553TZ4ULuFVGmGvGAD/5XMtjdp6zlAW3Vkes+7XuC2N8a4cRBA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzQLPvvu7D2kyb5f5LorSoB/0VUgxFeQDxztuTBhA+OHTXFL75V
	WOOcWH0i3yoQYMqNYRp3AcCFiIkaHnLgkeF8mdKV7mDq7bFIpYi4PBMyKMIyi1a/GQo=
X-Gm-Gg: ATEYQzxGClzaasDPYJVtsUFXe+fRj/Q2nEA+CEeQcrT81jjTLg3RbCCJqTCMzSw48A6
	rjXEd6fIKc9fnurVgqqry3q/dVZA8eqGKbMSs7Adp1FFicbL/5rRvP/nmrEp6A2nVSs4v4QRwKE
	uegzjMwccWu11FE1+BnFtt2MGaOKxibp/tnOn0auWwklmUoLLG+5y5Jq+6Q/50zuLUTA5JagyPh
	fll++t50TDwo2OtC6amdrjiaQVSYzmsdYpC0cHd7NSPN9UZyrErNCk9VwCX+3uqrQnpqhWjq651
	91Lh+/CWpcpyGTzecC+O68Njqb5u3DnUtJ8ETLAb+CcalRXgfTAprnQjgyPjFvw68IAgkcNyMM8
	0URclEEKYeATkh2LJ//MWEhN65iLooiaX+UBxu/SwxiZXJ4sDXrejkGPpb7oHSoiaYpcOQ17fdf
	Zad+aDSVbl9q2P2n1T97CxgyXNjhGrOXRZAKFNQlAAl8nhzrEWHvX0x+Gs2SFE8Oaugmrl6ABA3
	Tkg57AYqg==
X-Received: by 2002:a05:6830:f88:b0:7d7:c87a:4feb with SMTP id 46e09a7af769-7d9fafafaf6mr8767610a34.30.1774964341946;
        Tue, 31 Mar 2026 06:39:01 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7da0a335421sm8048036a34.3.2026.03.31.06.39.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2026 06:39:01 -0700 (PDT)
Message-ID: <a85f11a8-7014-4b01-b35e-69974319f425@kernel.dk>
Date: Tue, 31 Mar 2026 07:39:00 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?Q?Re=3A_=5BBUG=5D_WARNING_in_io=5Fring=5Fexit=5Fwork_=28io?=
 =?UTF-8?B?X3VyaW5nLmM6MjE4NykgdmlhIElPUklOR19SRUdJU1RFUl9CUEZfRklMVEVSIA==?=
 =?UTF-8?Q?=E2=80=94_confirmed_on_7=2E0-rc5_and_rc6?=
To: antonius <bluedragonsec2023@gmail.com>, io-uring@vger.kernel.org
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <CAK8a0jzF-zaO5ZmdOrmfuxrhXuKg5m5+RDuO7tNvtj=kUYbW7Q@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAK8a0jzF-zaO5ZmdOrmfuxrhXuKg5m5+RDuO7tNvtj=kUYbW7Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12898-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,googlegroups.com];
	TO_DN_SOME(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.994];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: A41CD36A70A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/31/26 7:32 AM, antonius wrote:
> Hello,
> 
> I am reporting a kernel WARNING discovered via Syzkaller fuzzing of Linux
> 7.0-rc5, targeting the new IORING_REGISTER_BPF_FILTER subsystem (new in 7.0).
> 
> The bug is confirmed on both 7.0-rc5 and 7.0-rc6. It is NOT fixed in rc6.
> In rc6, the WARNING appears to have changed from WARN_ON to WARN_ON_ONCE
> (fires only once per boot), which may explain why it was initially missed.

Interesting, that's why I added those WARN_ON's. I'll take a look
at this.

And yes, they would only fire once, because are WARN_ON_ONCE()...


-- 
Jens Axboe


