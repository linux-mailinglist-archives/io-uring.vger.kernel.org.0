Return-Path: <io-uring+bounces-12591-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id APB9I4jKrmnEIwIAu9opvQ
	(envelope-from <io-uring+bounces-12591-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 14:26:32 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 31F6F239B7C
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 14:26:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 977D230172F2
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2026 13:26:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF5411B3925;
	Mon,  9 Mar 2026 13:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lyfj3NgG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644F3198A17
	for <io-uring@vger.kernel.org>; Mon,  9 Mar 2026 13:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773062790; cv=none; b=U+ZdhF1qBqECbEa7t3/Y/2SnNlmIkCIal6x+IhuLDfh9+Tk1oTV7g49dQ6TcCqfUfGa0DAn7k67j+4bjVfTBrDjY39tFgCIstNaEudoY5a1ohRC4u6rsejfiOcF6lLdIcIXrvidQZpIHCbXPQlwuPRQoPdf5C+67ctMRIbZAiU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773062790; c=relaxed/simple;
	bh=Po909CKk+S77J6CV+gYffxYX6wnVpZbmvR6aZ+a0k1k=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=a6zqhmkfE3g/M16FRvi3Qz1cpZecCiPDigCw3EffixlamOZA7qF925uaZuJkh5PqcUAxlKvN/IUvRKCqyAkMAS9vpAlT3T2668LgTiRCsqGhC3x6ETfRZtRE7eW+k4PAWsbc/dqs8KHNdXWWgBfiW0+qRyO7JDoRGHF+dNmcvVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lyfj3NgG; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4852b81c73aso19154675e9.3
        for <io-uring@vger.kernel.org>; Mon, 09 Mar 2026 06:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773062788; x=1773667588; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=068ylNecgB7DS++RzLk+Ps2uMW7wW30/2l+0PdiHrHY=;
        b=Lyfj3NgGqdWRBTni2g1dZpOszwfdVzaYaMY7xdm48bfTSBka9KEKtxcnttqtIpOMQ3
         NUH+E4GL+fHeoRQbaP+Z7N0cwk/VjffoNzQ2sPaQq8o9iRzZ2j+0FDk81kHheNT6Sm52
         P9mAqOcpOIqn1ckzkrL9HhcrGMQhD3YY6q0e4AhByWqe3uQnxQvzd/7U8gVafyZPk41M
         enjPHDtsg5KNcJsFy0h0MBsrOvzEVCWhbV85qleoxE9ePiyZ5GHnXObR797gIiGgYhmo
         siNpBR/qxqRyhZifo93/wviTRoLdC9jCyhGkRg7gdDtqemGuYZMMUJincvM6VfBrEYdp
         fYhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773062788; x=1773667588;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=068ylNecgB7DS++RzLk+Ps2uMW7wW30/2l+0PdiHrHY=;
        b=M++1jY7+ugxdNygCxjstsspyiRp3VwIztTHz6PYmro35Mut56/0n5vrDKz0Lv+4Sk5
         rvWgkocMbTN6Z0pYgJk9I7HR9G2p1QtgNL41pwb1e8dcJhJEMHcIfHYeMQ+Qom2CFHAT
         jIndVlX7jwF+V1sz17wC2gwisrh1ruXePewG9TSHJANrh9Vi6PCvizJtz+sB9MdJZT2q
         DiBttNxJVQcDoO/IMNZsfL9dTQBNQqoelYVIyEvxmAuLbOsVLPQ48QvgDC00Bc5rbPu1
         1FDC2geZi7usXp1oYoUHkSGVvnDyE7IwFRxQ8VZZnBrBQOIWDiW8tlVAQADdT+Ey/pCQ
         liUQ==
X-Forwarded-Encrypted: i=1; AJvYcCWw+lCr3S7g46tVq92CHq2uP71r4jgsMonT9exE1IQuf9H2BF9yVBGOwz41a7VdjmpTT49et52nkg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwIoOR3+cpY1Y0bnuXPSadOWh4TjUXWHe4+9hbxZCrCilWmvsQ0
	D76w0clzrC5AQkUxwg9QgUqdGW1uMHDt+hx5bt41/Z4Ftag5qD1aBXMQ
X-Gm-Gg: ATEYQzyyds8z6kLkBKzzwppr9pdcSnWofEOg0FBzffAnXa0tjPwr5y+G521VQy4UkAY
	JqDYfbwc4XM1gGPpowu1VsgVRTVV10XC0PZ2WlxFxR7XF19qw4BKbktZx6C2pDyHPBesu8WrMhU
	/pYTIhgIgtHiZfXRcH/yaOqDyaoqu/8UdfzYPhABsPuWYMmTOiaoEmQmHVclwE/w4JvRkBRFKuM
	VONYCTMW4kyCe/o39cJpSSfl/akHNhnFub6gi8+UGJS5l5zXmrEtUNjxA+WBL2sFb9kVi2pvehE
	o/sU1M65PWgXiYDdIkpqJfk6T8bXGqqq180BkJQtdmQXDpiYbv2hUTaB6yFIpkDoM8OnHccQXgh
	3jt3EhP6jXMgQHl2mxgrSlZvnDrikk7f+f3Frhq3nLOePHbbkqrk2qRWp1QJQAgs8qGIm4VCt4R
	X8HdfVuR+62FqfdU8icE1wDY0f4Cft3rYyiJ+s+njRnJlacmUzOVSvUDV9JKO+bEvhDjjcaIOzA
	0Zmg5Nnr6feV0zW2RfW/VuXvg5YAJ732gdsVO3gvDOFgwARzDU52Jdsze3JfTUH6EIKqJoqkAIX
	vQ==
X-Received: by 2002:a05:600c:3b8e:b0:485:3ae8:2231 with SMTP id 5b1f17b1804b1-4853ae824cemr67463135e9.30.1773062787608;
        Mon, 09 Mar 2026 06:26:27 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4852381c61csm88895815e9.11.2026.03.09.06.26.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2026 06:26:27 -0700 (PDT)
Message-ID: <4c53fa3e-e2f3-46e1-bf70-e3a63d330d55@gmail.com>
Date: Mon, 9 Mar 2026 13:26:26 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/net: allow vectorised regbuf send zc
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <c151f006cbac6eb51863881d338b101186740cc1.1772493339.git.asml.silence@gmail.com>
 <14f88099-6c27-4dd9-8868-f7e61ce68474@gmail.com>
 <c7efb1af-3270-4959-ba40-98c315e6bdc6@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c7efb1af-3270-4959-ba40-98c315e6bdc6@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 31F6F239B7C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12591-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.933];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

On 3/9/26 13:21, Jens Axboe wrote:
> On 3/9/26 7:17 AM, Pavel Begunkov wrote:
>> On 3/3/26 12:32, Pavel Begunkov wrote:
>>> Enable IORING_SEND_VECTORIZED with registered buffers for
>>> IORING_OP_SEND_ZC. Set IORING_SEND_VECTORIZED for all msg send requests
>>> to differentiate if the vectorised version is expected.
>>
>> Any comments for this patch?
> 
> Looks fine, but it depends on the patch that just landed in -rc3, so
> need that first for staging for 7.1.

Ah, forgot about that. Let me know if I need to do anything
here, otherwise I assume you'll be considering it after you
rebase for-next on top of rc3

-- 
Pavel Begunkov


