Return-Path: <io-uring+bounces-3417-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 350249904E7
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 15:54:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D42191F22B6A
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 13:54:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61F4E212EE8;
	Fri,  4 Oct 2024 13:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="irgO3T1u"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D11156678
	for <io-uring@vger.kernel.org>; Fri,  4 Oct 2024 13:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728050077; cv=none; b=iCIaC2UCefFBbXACrAF9Hb2laxYZJEXI5Rdd5+PzXht+a4sqEj38LtTXPIyqdsVr/Om2CNPaGHEBcPjrsyto3nb5iGxJGkqpEcgXf0ZPRFjfbOlKWybrq5pGmSzWJu3jJaZrvr8zUMvRoTHlpEBJGRYkpCA0hhf8V8/OJXU99Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728050077; c=relaxed/simple;
	bh=pE2BTdCoOY3z32NGXnwHmBA6vt9J3ZDwUGqbcCPBSR4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=sPwovORDYX7xoCOgwdPmFzdQOd9eDlIDnPIvy/P/VEFyV2iKYV1R4pVA6VyWDR2g1pnrwcI6iWEtfl+9Rt6cSUaqfMkgOaX8aLP1ka/0CxRflx7Ir7DBfMIlu2Yp4yxEbz94n3jJqbUZt02hKQX6u1GbdWe2aoeuGJ+KuGVea9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=irgO3T1u; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3a0cc384a85so9227005ab.1
        for <io-uring@vger.kernel.org>; Fri, 04 Oct 2024 06:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728050073; x=1728654873; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qUsPFga+l7NGX+YSyeJgkq9wMk7CMvGEEkxj7kPkE/s=;
        b=irgO3T1uSFCi9LqHrRe4qvDahskymK49pUCxi1U3tDktebT4+c2nih6Vr2aj1XgRKg
         fWnplYM6I0CUyvlo8xIxUv9y3qzoeqCUscInPao1kjZsttRw3sHHYWwter2yDPOtzNme
         m/AfU9XfhHG+jgrGc8aTLimBIeRh09Bm2XjvDqIt77zdUbKvqf1t7zerJIOUpEUmiAfH
         Q4wZ0jpZeRBISaA8618/AvJGcgW+lVUaQ3U8LA/JnH3Qevnmr7Z+4gWtpgWQvXJUcnTN
         3nrN8b+j3lANUTLSM3MjrOll3sajnNvkVnvKJFOcs347Ct8nkT038D/wPitmST5qAjLj
         7teQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728050073; x=1728654873;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qUsPFga+l7NGX+YSyeJgkq9wMk7CMvGEEkxj7kPkE/s=;
        b=YdroeIB131n8xKtJs2zHwWskx6/drVtMx44MFB0GsdanQ1ZQUPO2n33OYL/G+IVcZx
         tfy9tjPz1Ga9n451OoIVk/tuo4QOrmOuPMaV4n0x7DVpeHCRi7JhhBRWnftbSp+Xg+MH
         Gx5TzV6pDaP6YM8eIBH+fxBR/523HRurtU5nRwEzjMOgMuza6avwVOzukkWBO/F4tXmO
         JBiX+0O6qvd/SIzXB1DrO0jD+1PRp2D/+klYolV7/W4DlKHrNl+4qWkndeom/HidbSrG
         Wlt2PFiOPaXo6f6JmT0paRSbXKJnuwktqIazSBQiDM7v7IhBE7249oDzqppvCKSxzMt3
         MSLg==
X-Gm-Message-State: AOJu0Ywsf2Wy2NlLU8P/GwMG6GANKCIyey/bwY9m+xV7C/nnX/M/Wnq9
	PYOKPn96EqqeGqcmvgRqhXoSS25SNiRaaZNYvFRsrBioWusOSX3nL/8KZpKLHxgZ3SEKZWsXpDb
	FFJs=
X-Google-Smtp-Source: AGHT+IHFw87SwHUFHan6Mbx1BSUi1ReA64uu9Fn9oSGJbXNBO914gkkf/mQA5pIZTFF8jlTJIyKFEQ==
X-Received: by 2002:a05:6e02:1fcd:b0:39f:558a:e404 with SMTP id e9e14a558f8ab-3a3759780bemr28327155ab.4.1728050073278;
        Fri, 04 Oct 2024 06:54:33 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a371906a50sm7183945ab.7.2024.10.04.06.54.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Oct 2024 06:54:32 -0700 (PDT)
Message-ID: <7d658ea9-44be-493c-9d68-957f293883c8@kernel.dk>
Date: Fri, 4 Oct 2024 07:54:32 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] io_uring/poll: get rid of unlocked cancel hash
From: Jens Axboe <axboe@kernel.dk>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: io-uring@vger.kernel.org
References: <e6c1c02e-ffe7-4bf0-8ea4-57e6b88d47ce@stanley.mountain>
 <2f2cc702-609b-4e69-be1a-a373e74692f4@kernel.dk>
Content-Language: en-US
In-Reply-To: <2f2cc702-609b-4e69-be1a-a373e74692f4@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/4/24 7:50 AM, Jens Axboe wrote:
> On 10/4/24 3:00 AM, Dan Carpenter wrote:
>> Hello Jens Axboe,
>>
>> Commit 313314db5bcb ("io_uring/poll: get rid of unlocked cancel
>> hash") from Sep 30, 2024 (linux-next), leads to the following Smatch
>> static checker warning:
>>
>> 	io_uring/poll.c:932 io_poll_remove()
>> 	warn: duplicate check 'ret2' (previous on line 930)
>>
>> io_uring/poll.c
>>     919 int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
>>     920 {
>>     921         struct io_poll_update *poll_update = io_kiocb_to_cmd(req, struct io_poll_update);
>>     922         struct io_ring_ctx *ctx = req->ctx;
>>     923         struct io_cancel_data cd = { .ctx = ctx, .data = poll_update->old_user_data, };
>>     924         struct io_kiocb *preq;
>>     925         int ret2, ret = 0;
>>     926 
>>     927         io_ring_submit_lock(ctx, issue_flags);
>>     928         preq = io_poll_find(ctx, true, &cd);
>>     929         ret2 = io_poll_disarm(preq);
>>     930         if (!ret2)
>>     931                 goto found;
>> --> 932         if (ret2) {
>>     933                 ret = ret2;
>>     934                 goto out;
>>     935         }
>>
>> A lot of the function is dead code now.  ;)
> 
> Thanks, will revisit and fold in a fix!

Should just need this incremental. There's no dead code as far as I can
see, just a needless found label and jump.

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 69382da48c00..217d667e0622 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -940,13 +940,10 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 	ret2 = io_poll_disarm(preq);
 	if (bucket)
 		spin_unlock(&bucket->lock);
-	if (!ret2)
-		goto found;
 	if (ret2) {
 		ret = ret2;
 		goto out;
 	}
-found:
 	if (WARN_ON_ONCE(preq->opcode != IORING_OP_POLL_ADD)) {
 		ret = -EFAULT;
 		goto out;

-- 
Jens Axboe

