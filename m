Return-Path: <io-uring+bounces-13226-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qMLTKpdQ+GmQsQIAu9opvQ
	(envelope-from <io-uring+bounces-13226-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 04 May 2026 09:53:59 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 49F9F4B9ACF
	for <lists+io-uring@lfdr.de>; Mon, 04 May 2026 09:53:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5D6BA3002100
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2026 07:48:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 880D730FC1D;
	Mon,  4 May 2026 07:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SA+yGwQL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D57330F7E8
	for <io-uring@vger.kernel.org>; Mon,  4 May 2026 07:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777880911; cv=none; b=SfBvfzDCVxfZiivaAB0fHT5IDbj/u2WIQfvLLyNcBzYgOKehHiy5vDojpV0TP6bGAPyS2e6KiJWmtPOO8fKLpzTqKN9HlYH6fM/ZHriFrcYr43ZwsgRidwj6dAcgVlyIoYGWU+Iu/4X4474FAJ/wUMA0/N/wVz6QnAVD/6FIw7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777880911; c=relaxed/simple;
	bh=syP/zGuq+yDpz2ntWKmIkyUC4cRaNsdLDkiSlVzoXkY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gHpWrU+IN774L20274qpFqDKWZoaTYGPtmSYzM7QmIzZCYdFPg5Qd5YceI6StQJfaBJ0NrLsdWxztgQdTYa8puWnD9BqcDd5lSWz+45Im6dbTyCtc9e7RKo1AugfH+uJ9P9434N0lpGAyUgWoczmQeG5Vux4JVPJ3hqWlHkbYZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SA+yGwQL; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-488b0e1b870so60898305e9.2
        for <io-uring@vger.kernel.org>; Mon, 04 May 2026 00:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777880908; x=1778485708; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kDtQ/aQ1w0ElKE7YAKSB1b+1NzDJOAnZ5IlgFYDi7x0=;
        b=SA+yGwQLvOxundI6OitPu2d74xPn2n0oBaGXFMHzT/X9sK8ndZLqU5RFDiWBPXPgCv
         st0MBjH8fnGbwf/G5Edpa5i23FT3iY+uHIFt4RqnHo2gAM9YaDvgicKRBWT4Wiorf/oy
         QfDo6gjmnH1Hzfdnv0DMMD9rwRdxNh/nvMuuhXNvcUVCbbyM8mnQ5ExcrtWp1kLlj6Lc
         SYjiF0iNFkg0KoIeKgsuMYIQNouam57KSRUca3InPScEhhE0l7qAYnskaFF9cgooWa95
         elgx3oHRnrXHmAsY9ypasdBPLHAa/rna+671j8U0+0J98sLA1i0VBuIiyNEa9hfNkj2h
         F/Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777880908; x=1778485708;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kDtQ/aQ1w0ElKE7YAKSB1b+1NzDJOAnZ5IlgFYDi7x0=;
        b=i4hmdjYxLihjYwcv4QwNd9kSxSyc9XlZMtiVO29iBG50c8uECB+K5AKc5gj+wFzYsj
         7SlWbjsdqZJy1r/AS0it0bDJAYYvU5mcbzX3cEitNe4OQ3jRtCnq8CJpqjx09g1GzO4F
         QbTOSbL7/aV7Udc4jE5qDHzOq7Lnh9x4mvFsXe58QN8jZSrPpiRUb7kfscLljv26+Wxs
         pEt/JsuJnLKEEyaoD7C1/6RruOKJN4S46FoUdEWVAlbzY03xP053tk5tWQHRvGKwCvJd
         VxuINc4o/4gZdmJ3tUckqz5NFtIACM5bbkY0B05XwyTB4UUCm5/Dy8b9Oil4yA9H8sWi
         j5xQ==
X-Forwarded-Encrypted: i=1; AFNElJ+I36d8Ti1G6RBjliSkhjH1RG1RSy5yOXv/SzLwEhYbAb2tbrnykDKk8sWl99pUhnVMLbQeaF58SA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzOPl1EmNkqP/5l5yO+wXzzuRo2MvKN6AXTJZmO+6+qaIGREbT9
	XNWB3ry91NZbcN7X9AzGPRKTINbPPfku3xyH3gdFIKVCxmXzREK4Fy3k
X-Gm-Gg: AeBDieuBpNvmibbe36M4LY6lZEn0jbLz4gvuefemAH0cRhl51YrWYHimh1Jq9VvFTp7
	W0iq2n0WvAQYSrPtlD7bXRhIKXy5HhJYVqB0PTlj2uUzfPnJr6c+/MxkeB3IxNPsPt+CuBMcfrS
	l/NCg90ir971bibuVsPVCEEtvQLprjdSC/ykjVsV5q8DH+5bVrPGILOz1lUXPb1haGu5t68KKmd
	YOF7ENLUyWgfNH8iPDStLKlOARq8ABDvpCqUlnwB0yilSGcYu25J/z4xXLxUJQxC7w0ZTRXZbOJ
	knnl7hwCfrPYC33Jdinz6TB9bBH1i/hdfG+dQIfj76cFBRDQCZOYRlsoPIIgKKbbw4U53SKpuf9
	BPLCkX55HDrWLlwXSDruD5wUlcT5y8eOFeRJhKNqyd5Etx/7FfhRCy3Lsz+Rwg8Ji1iuDt9zf/8
	smh1Ubd1Fku6f0GaMwBcIQmr4d5haFRur1luNFc9iJw+KLePQ6n053ShDCMtavPVWsAEz8mxINJ
	t4hS0+k3zLSDs8JApNIvJbji/05j9ExixXJss9/QTU=
X-Received: by 2002:a05:6000:61e:b0:43c:f90b:5668 with SMTP id ffacd0b85a97d-44bb65e0608mr14826168f8f.23.1777880908394;
        Mon, 04 May 2026 00:48:28 -0700 (PDT)
Received: from [10.211.10.33] ([213.147.98.98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-44a981dee7asm24754038f8f.21.2026.05.04.00.48.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2026 00:48:27 -0700 (PDT)
Message-ID: <988f7486-0353-4239-badc-6c0dc9b3abd7@gmail.com>
Date: Mon, 4 May 2026 08:48:11 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: io_uring: should IORING_TIMEOUT_ABS honour the submitter's time
 namespace?
To: Jens Axboe <axboe@kernel.dk>, Xie Maoyi <maoyi.xie@ntu.edu.sg>
Cc: Andrei Vagin <avagin@gmail.com>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <TYZPR01MB67582BE6855BE725AA5174CBDC332@TYZPR01MB6758.apcprd01.prod.exchangelabs.com>
 <85b63dbc-1fb3-4913-9419-90908c5b6358@gmail.com>
 <TYZPR01MB6758466089A9CAADC5095F20DC332@TYZPR01MB6758.apcprd01.prod.exchangelabs.com>
 <TYZPR01MB67581D3389689A4427E41E92DC302@TYZPR01MB6758.apcprd01.prod.exchangelabs.com>
 <aa9ea9e9-dbf3-41b9-874c-1638f454c2d1@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <aa9ea9e9-dbf3-41b9-874c-1638f454c2d1@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 49F9F4B9ACF
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	SUBJECT_ENDS_QUESTION(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13226-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_FROM(0.00)[gmail.com];
	DKIM_TRACE(0.00)[gmail.com:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5]

On 5/4/26 07:06, Jens Axboe wrote:
>> While verifying SQPOLL, I also noticed io_uring/wait.c around lines
>> 230-234. The IORING_ENTER_ABS_TIMER path on io_uring_enter() parses
>> ext_arg->ts inline rather than going through io_parse_user_time, so it
>> does not pick up your fix. Same shape of bug, separate code path. PoC
>> on vanilla shows elapsed = 1 ms, patched shows ~1000 ms. I can send
>> the small follow-up patch for that path as a separate thread once your
>> IORING_OP_TIMEOUT side has landed, or fold it into the same series.
>> Whichever you prefer.

Yeah, I noticed that as well

> Might make sense to refactor a helper that does the time translation,
> and then patch 1 would basically be Pavel's fix and patch 2 would be
> sorting out the io_cqring_wait() translation as well. Both should be
> able to use the refactored helper.

Unless there is some more unification b/w cq wait and timeout requests,
it'll very likely be cleaner to have two timens_ktime_to_host() call
sites, but I haven't taken a look

-- 
Pavel Begunkov


