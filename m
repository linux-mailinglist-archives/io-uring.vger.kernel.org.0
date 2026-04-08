Return-Path: <io-uring+bounces-12980-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IPKpAioV1mnwAwgAu9opvQ
	(envelope-from <io-uring+bounces-12980-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 10:43:22 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FE713B93D9
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 10:43:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 587B8300615E
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2026 08:43:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02F41385502;
	Wed,  8 Apr 2026 08:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ihdCic1K"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AEA3A782D
	for <io-uring@vger.kernel.org>; Wed,  8 Apr 2026 08:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775637798; cv=none; b=ROpLV8A3hVvFMm03lkSYCxjRDPlvqOrLLZKFwmI+ZBE4M1eTzY/CB0fMMZaP5zTRVPEgBHFYzyRbXnrlAKdEGnDGwWKcc2ODw5IWKs4NPoXZHMpstTbQzaa1acz97tI5VGVv3JZPZkhr4t/Brx+vDCJyPVX1A1nS48c7PS6gBIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775637798; c=relaxed/simple;
	bh=IOobEvPKGDRFdpHofrIsUiTBdRESzbZAgZ9PwACzl68=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q0jOux+GkvjwrMy1/w5FxCRqZMKeUcDuFP2XyaH6De/S5Gmchk+1w8RA7ip5wfDXSCZUrwyAXQxTPJ/0sP/mv86gCp9X+39y0YaEDQWmhTsY4aJTpDgb750SIUEUsuBqf7jBJJ1JvuKEkpBqIXb71ioVR51RI/gK7HuXNuX30OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ihdCic1K; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-488a14c31eeso30945725e9.0
        for <io-uring@vger.kernel.org>; Wed, 08 Apr 2026 01:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775637796; x=1776242596; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YJhZXhA3qjn5/0srZMkofmaH/8Sy1rcxMm1iu8E+Ats=;
        b=ihdCic1KSeMwQ50pBet9yCnXiTAf1bVxhzduqKs84twTeQ7iPyXoaCQLz368tOk8FF
         aKj5tJJ8k1MQwMsa4fbzoVB0qpuj0RPOiJxQZNSpQc+6KpA+0FFs/oFvdRoS//gJvORU
         hCRfeAXb1xzuikFRTCeDSsI5xPyobktvg7Gdn6eXG2E63x8db49HDBQcgzjKq7f+/S2L
         qX092/pt+VTpVDKSBvuP+91N/HYn8vClYPV/zlHaZ/JFOVTkrKHH3YCgxzYVFvGfLzmP
         6h5Ep6SOHF6dZRuItfNTwV+NY8DyrWlpgWQEz5ig7jaaHkzJfN+hM/kCfiuD1cA3BX3p
         nGTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775637796; x=1776242596;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YJhZXhA3qjn5/0srZMkofmaH/8Sy1rcxMm1iu8E+Ats=;
        b=d06ZaUxvhvNrRxf/HuWWB0OAVXvB5ypoml4PpR0GbEhNhn3OZ1tF7bCkFA1u0lQLZc
         RZsjP2FtX27RQF/9pZhEuaajPnKFaAssjm3heIdUxwYHbdw1icLHpbR37NYvANOjsWXc
         xZAeJAGKxmOoJ9n947Lqqvgw7d0Kcl5HIgRMK3rXj3RQAJteAgM0VMf2lHCpzMqTsM36
         0cp0QqOpW3wHbwluxObivwp1Q8nO8Q5mZoJcH5Rg2d3KbjfTkaOYqyVgSJMC0lHp5qMl
         TBw7KKPPEW1jGYJm8Ue/ozqhRk7r3TJDB36ccH7GDeCCoLaJ1dW2HBql0d27R5BXAWDU
         a6FQ==
X-Forwarded-Encrypted: i=1; AJvYcCWKWlH1I3PJgq359/S6UIamrhD7hxMAoB3gMK6w6ysP/Hp5X6RjjhrTtRBqLmz6ZbQ3AeQa6FOPiA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6zL8YKeC78jQ0ETDlCmDSAFjREw6cD0fEmzNP9hccovaplRr2
	FVeBowgL8ZKQXzxtKMKUmsDqM3UWqJPMmonZ4V3zZK/zguTYiAa/IoGq8M789w==
X-Gm-Gg: AeBDievZ27kRueSisE6g8qVwIvpKQ67MN94B8u0W9S5WHFVjfYbCReBxHX0uHmUZfZ/
	Fkxkm8REveIABaaKICf4qs25MQ+XbqJ9973E4H9XoblrrFgp6vw1f1Xx6OX9pbqmG6GyrjSD5cG
	/UFs2eTaCXqWj5RqLNNbEWSb5/Ar46Mn+uGqo+iGU6vRhjpntiJsHzQBN0YDTmPneE69a8MGL/G
	bJU5CjOgHX0ZOtm4GRbBKPb9esfefFZjKbnmGv/VktFVCTki7TJukJAy7c5NCpkTkaVfJWYkP8n
	6sIQkzDVrOmDqU7JysIE5E7styiss9bG5E76U1A/bWQvkToUxMu+ctQNpMrzS+qO2WQODIId7oc
	9eK9DX0wCoJSrdn+3c1ojelZllVSIco9NfNEHFTer/WGLqAFXaBLRJskRPFLVh9IcQZbt+WQCrk
	wpaz25zM08WBfK3p6xTaHjy5xV1u2PVgGFEpcX001He/PP3EwCL6vSXjQDLX5eTzv4qzgsoHoM7
	tns5tFnDrm8IsGcIrZTGpdV3HQAXjHi96zjafjAGp2zvjVu2DNeog/0PUU=
X-Received: by 2002:a05:600c:154b:b0:488:af14:f1de with SMTP id 5b1f17b1804b1-488af14f35fmr160555775e9.4.1775637796113;
        Wed, 08 Apr 2026 01:43:16 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:eaba])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4887e83682fsm649989655e9.7.2026.04.08.01.43.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2026 01:43:15 -0700 (PDT)
Message-ID: <0ffa9a2f-e3d6-4f0d-b6ee-3c84fcaace5d@gmail.com>
Date: Wed, 8 Apr 2026 09:43:20 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/zcrx: reorder fd allocation in zcrx_export()
To: Bertie Tryner <bertietryner@gmail.com>, io-uring@vger.kernel.org
Cc: axboe@kernel.dk, Bertie Tryner <Bertie.Tryner@warwick.ac.uk>
References: <20260406165846.94517-1-Bertie.Tryner@warwick.ac.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260406165846.94517-1-Bertie.Tryner@warwick.ac.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12980-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9FE713B93D9
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/6/26 17:58, Bertie Tryner wrote:
> Currently, zcrx_export() allocates a file descriptor and copies the
> control structure to userspace before the backing file is created.
> 
> While the operation returns an error on failure, it is cleaner to
> follow the standard kernel pattern of performing the copy_to_user()
> and fd_install() only after all resource allocations (like the
> anon_inode) have succeeded. This aligns the code with other
> fd-publishing paths in the VFS.

I don't believe we care about it, to be honest, but I'll take a
look later after 7.1 is released.

-- 
Pavel Begunkov


