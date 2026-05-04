Return-Path: <io-uring+bounces-13224-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mJ0zFGhM+GmQsQIAu9opvQ
	(envelope-from <io-uring+bounces-13224-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 04 May 2026 09:36:08 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FC494B96A4
	for <lists+io-uring@lfdr.de>; Mon, 04 May 2026 09:36:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 749C23011583
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2026 07:34:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1602E2D877D;
	Mon,  4 May 2026 07:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="i3j/wyBE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF812E091E
	for <io-uring@vger.kernel.org>; Mon,  4 May 2026 07:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777880084; cv=none; b=l9ENluHwOFHguprxH0LiCHy/cjOcaI0s6SNP8X4hqB+rvk7Stppvgkf4qpuE7FKBBwFIv+v1+rOnuuekdj14W8R8YJiuUNe3wJQQg9h0hyMCmwfF0lmmWx+JVUWO6fVRXe4PjIk4br5TzoR/SHdYNSJsgYo6alwUOhXI42igHV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777880084; c=relaxed/simple;
	bh=H6egnWjtmRg3Wpu7WIbhUI+AJb/XOyvV8VVR1HJ4rBY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=layEI4mxapDCuJwWRPXnJQMhj2KLD08VUppwiIeYmQgykI9oHAAGUL6WKkqeemoHfR3K14oBYTy1OWc2EGpc81y0jZ8zyp/EfQ0JyqXiPIdIcgxoCEzfmdwjme8lgC+qB9K14KV89V/zYJrPb77UkG5v3Y/CBdLWmOjhAblNJ/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=i3j/wyBE; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4852a9c6309so29369925e9.0
        for <io-uring@vger.kernel.org>; Mon, 04 May 2026 00:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777880080; x=1778484880; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T8Am8QvwPOlSf+dSkObzcsYC2FIMD4Og3MRHu3U4LRk=;
        b=i3j/wyBEIT33FolOHB/7rIOsKtvSQq+YlRrt3k+E9o+hslD02yMlDBsWvIAZE2/DV6
         IrnZDQz/BMRek/MXsZL66zzBmfgWMIKSPTjoGuaK0ZG+o1dFR2HA1HW3ZxV1ksLSopwn
         P3mVK7m809Q+FDxjVdQuAom6mt6t06aV3A3NXaKaJE75uwEL0MdH1nzL7byiihxmMekP
         U1o5yxX9ok69zwITNctyOkETOPEbHBjTfM6PfILvKdl/6pgDTfo0b5CN8o1QmLaeGof+
         Frqkc93XEX1Lc43hSRVvg6YD7mZLDcLCYJ7GyPyLlNK3jgYj7cCU5YFhSskWfbV2zRkt
         J1cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777880080; x=1778484880;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T8Am8QvwPOlSf+dSkObzcsYC2FIMD4Og3MRHu3U4LRk=;
        b=JCEdMWbjyuJDzxl2p0Ykt/J4/G9U+2uUsZpAX4RNOwObQB2rtjdxgQ1+YhCDW9kuFf
         IDXQYVaNs/Crt0ByU18rEdJdOuMXFCa32sLjTA/HCzjJHHlgp1T6HOeVnjb1ZOKJzw16
         88dVlqVlPHuRD+Cjf0IKRT154W8fxRHLljt2Art0pI79uNyEDuKZBUkYQMH5Z5rZNbZb
         GIOdVTHpyBG8U8lqbwMVY2C7Jfi3YxRNrwONe2pAtFaPPmChRyzRu+ttCo5jfUNp/kPS
         NMsN9LBD4QVXDpKRNIo0AT2sVTIJXFHk/Umq+6JZMdg5u01SxcqZUt6aGjRaHFFwnF9c
         6V+g==
X-Forwarded-Encrypted: i=1; AFNElJ/Cr79+oyI8wm6PZ4infjCkmbDr8bOdSNHrRGvARIpPKBBliOaGS6DOipkx4TOYo49VxXzQJmD1CA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxP5me2XO2vx1qL0abbVA/BeZgZoLFBy19vT84CKaMTKtQUKyF9
	hlEqwxjlmUT/2bSlZGa2n9a3/xZOfoAGbEMGbf38sBQqradEx2blVguBB3qyHjcfwt4=
X-Gm-Gg: AeBDievjce4ke6aSDUd1ow4KubS/xGCIVgq8SjslNJTRi4QJYoMCbpmeaaZS9EKesHl
	xQ0im0XsRVX9AZkJnhN/skmwzRf22+GE+Fg7ExL8VFpZooxiU6VPuNhaEPBNZg+VEOlSfz01vnL
	K40X2LgZ+cnvgT24ru6H3iPG/33vzDFQk0jxpSw9FAs3hMQnc20y+lk9LIsz/zO5ExoJK3bglx/
	a6GUbWRBOcAS7LOy3uaLXo9zue9aQJ3Tbij3I4X98pxrJ1mu9vFiHGF9XyjbHDyw0kUI4VYrnrB
	3cIK9CX9AplFzpOyCdMH1MHof/WrcEcTf+SgqmWpCsB734dpXtzbABb5JhHcT5iX1oIMlY6WLUq
	hHgiSjsjXAaw7K/vGYQMgodUonZnJ8Gu3S+0Cw6Ygic0PvaI2zoAAgbuRhPmclbfwel0gWWf1K8
	E1WkcDDIyWVe1c4wTw8mJCD0gz4T0qBXSPilyKjKGtl4wQyV0dAZZo4dKXDpnPt560luAr3t4Qo
	+pas3U+2XN3UzAEsKOb
X-Received: by 2002:a05:600c:a118:b0:489:ecee:c4ef with SMTP id 5b1f17b1804b1-48a9865daacmr92637525e9.13.1777880080191;
        Mon, 04 May 2026 00:34:40 -0700 (PDT)
Received: from [10.211.8.175] ([213.147.98.98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-44a981dee7asm24650614f8f.21.2026.05.04.00.34.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2026 00:34:39 -0700 (PDT)
Message-ID: <393cb843-a625-4a7d-9817-be77cfc50037@kernel.dk>
Date: Mon, 4 May 2026 01:34:38 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: io_uring: should IORING_TIMEOUT_ABS honour the submitter's time
 namespace?
To: Xie Maoyi <maoyi.xie@ntu.edu.sg>, Pavel Begunkov <asml.silence@gmail.com>
Cc: Andrei Vagin <avagin@gmail.com>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <TYZPR01MB67582BE6855BE725AA5174CBDC332@TYZPR01MB6758.apcprd01.prod.exchangelabs.com>
 <85b63dbc-1fb3-4913-9419-90908c5b6358@gmail.com>
 <TYZPR01MB6758466089A9CAADC5095F20DC332@TYZPR01MB6758.apcprd01.prod.exchangelabs.com>
 <TYZPR01MB67581D3389689A4427E41E92DC302@TYZPR01MB6758.apcprd01.prod.exchangelabs.com>
 <aa9ea9e9-dbf3-41b9-874c-1638f454c2d1@kernel.dk>
 <OS8PR01MB674993B75C46D1763F925ADDDC312@OS8PR01MB6749.apcprd01.prod.exchangelabs.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <OS8PR01MB674993B75C46D1763F925ADDDC312@OS8PR01MB6749.apcprd01.prod.exchangelabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9FC494B96A4
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	SUBJECT_ENDS_QUESTION(1.00)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13224-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[ntu.edu.sg,gmail.com];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5]

On 5/4/26 1:23 AM, Xie Maoyi wrote:
> On 5/3/26, Jens Axboe wrote:
>> Might make sense to refactor a helper that does the time translation,
>> and then patch 1 would basically be Pavel's fix and patch 2 would be
>> sorting out the io_cqring_wait() translation as well. Both should be
>> able to use the refactored helper.
> 
> Understood. I will prepare a 2-patch series along those lines:
> 
>   1/2 io_uring: introduce io_timens_to_host_ktime() helper and apply
>         it in IORING_OP_TIMEOUT / IORING_OP_LINK_TIMEOUT (= Pavel's
>         fix for io_parse_user_time).
> 
>   2/2 io_uring: route io_uring_enter()'s IORING_ENTER_ABS_TIMER path
>         through the same helper (covers io_uring/wait.c around the
>         ext_arg->ts parse).

Sounds good.

> Could you point me at the right base to develop on top of? Pavel's
> draft uses io_parse_user_time which is not in v7.0 mainline, so I
> assume the target is one of the io_uring trees (for-next?). I will
> also re-run the SQPOLL and ABS_TIMER reproducers against the
> series before sending.

Right, that helper landed in 7.1-rc, it's not in 7.0. Use my
io_uring-7.1 branch and we can land this in 7.1, and then for the stable
backports we just pull in the helper that you already have in 7.1. By
definition, work can only go into the currently open branch, which is
7.1. Anything else has to be stable backports.

-- 
Jens Axboe

