Return-Path: <io-uring+bounces-13476-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0A21Na0bD2qLFgYAu9opvQ
	(envelope-from <io-uring+bounces-13476-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 21 May 2026 16:50:21 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A0FA5A7A60
	for <lists+io-uring@lfdr.de>; Thu, 21 May 2026 16:50:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B4D2332A0B80
	for <lists+io-uring@lfdr.de>; Thu, 21 May 2026 13:47:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C81E535504D;
	Thu, 21 May 2026 13:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="qu1LTnE6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF513DA5A5
	for <io-uring@vger.kernel.org>; Thu, 21 May 2026 13:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779371071; cv=none; b=dg4HUqMAmW9dm45rx9HcWmgWbog5KjLWVsTm8PpDN9oNst5H22B3nkXXAqVU+tz+5fOdlab+d0idNAOIsVGdgeeIrNv9xprI/xcF75YTrT6kovEOIdC2SjCqr/VgXpZ9s/j2qid9n3WnkpU3UNGZOlm97IjM4Tia3+pbOvBuuAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779371071; c=relaxed/simple;
	bh=YbBGl88LfzwtfB/mL8t7kGsfvvnWebWmPn5V7ZYvqrM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lOZSCDaXujsiixi6nF/qfViRqI/rj8MHjn3z8J0GKs3gaWzH69fbqlAKfnx9FrTTriEXsot2t4i0LcihMD+kgJhlPzB+vZP1Riu965loOoTKfIBqWE5Q4qCuZfdathhpiH8YsfAd/GCyPzWqsTREZQVAmobp89PJPdqlKBBtlu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=qu1LTnE6; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-43a833aeda0so4504248fac.2
        for <io-uring@vger.kernel.org>; Thu, 21 May 2026 06:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779371068; x=1779975868; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iHFBTMvL5lJK53TW7HAIyADKt6qDR1oU0q5Ip5cfaGw=;
        b=qu1LTnE6KNGcOvaXL+84LVt5gy6ol1OmQiYL621j9BXDzwM2q3cYgwLjgbP7uXj7yH
         jWwN05TSK0nSh36sRDtUR2YR/Wuzfx7UKBK4wUU3Go0GEk4yZAsuyUwk6ev6zoOUHczp
         3jUIviFdXRgF32OhVu2mcRI+DfV1B7GnIGKnc1yW28zzIeXO4xTcxOxawIMbbJlba/5w
         5yrbTXc9H7ee3xyBqi5ek+TK6JHUZFjmVmca6ALwQkEopiZjx5uw8PgwkcCRABBoxMxJ
         Oun40Bl8CQzhGhM9vv+FZH5J9zdow5xEyl8DSHhPCNDCMDTuNTtkyKP9HObj5eigE1eE
         Alfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779371068; x=1779975868;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iHFBTMvL5lJK53TW7HAIyADKt6qDR1oU0q5Ip5cfaGw=;
        b=qKfMJB8gLml+LE0/QykqHtMsnsPl9UA8q51yhy1cCCYkRimZQIw+kxDwhcc55DqOKO
         pZqIjjfv6jnuatz4BTb/uWvQEGZb1ePGevHdKEvBtR0v8VMcVl/qu4gyOUkRuuKoeJ3h
         qh0SEJhobwpgc1d/kG9hUb0IEPSuyUVAri2OtCLNwCEp+mvS2F6ixkpkUnlFWV8jJc0s
         73xmglAPSZSgUcy4DMQ7T9ISdEKpvzFbYTgw6qv65V4X2/30sl2aCMZTVa8im5zrorlm
         4vGWqKq/TT1J3SP4ThJY1LGiyXfjzOc+A6P/DcrnlATVB7PUDuLx/RYAPSYkubvPo3TN
         +NMg==
X-Gm-Message-State: AOJu0Yx0OgfukVe53pU/KixdaqsWvJoLBBVWAeqIcfC4mlnF9IX41ju1
	nZgdI3BGVcLkNNvJjDDWfOOmqZs9hQA8lm0kwJB0aXKYXfX5m3EID1xbNpCS3g+qX6xjR8z/Ge5
	Vc8Tr
X-Gm-Gg: Acq92OHN2w7zmi7Il90optlSkCRPY2e3u1E4OkrTfPtNqVlWF51UVl4l6fB+7Bt9eo9
	wIrkPAbbSvLxP8a3x2ieAOpUJtWhA31PIBwwE766AyjRgqRSXf3p5A76LY6K02zwNYxUnHh0Czx
	dLPDGmmyS1tuGMwu6PzLsPQ5KfoQRLV2gjvocy/ILwjR1bzWjBdgkdoHtptL/ZNFSsp6EY0jKGr
	QApXQd4QTxLj3/+03fSptWrcbcv6zIOHUoBcts54gX7Vmg4H8NCxN/R13/MRJKQY0FXJvF0QrRG
	eYRBEBNXDq5E59xBh8BXrnp/m0lY8IXMmd0GWb3ZTO23654rNwLNbMdyxyvAbEUgxdvpNmRK3SD
	ANRoeanNlyBDBU7zICijM4GHOkAWYr74eEtIRD/UFGs74VYDzq/hkgurqLTDJevvj8Pw8yPv+xe
	EbQ3GIx0++/Ywt0BYWsv2/yfwD1IaZd9SY0LTewDjRD8urc0QBGYJ2Xl4PIKiGd47iroMlrZvaW
	itjORaR
X-Received: by 2002:a05:6871:2408:b0:43b:5127:7512 with SMTP id 586e51a60fabf-43b51277840mr129348fac.0.1779371067930;
        Thu, 21 May 2026 06:44:27 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-43b44935225sm602086fac.5.2026.05.21.06.44.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2026 06:44:27 -0700 (PDT)
Message-ID: <a3b33647-d806-4d34-828f-6e414b6a37a7@kernel.dk>
Date: Thu, 21 May 2026 07:44:26 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: io_uring MSG_RING SEND_FD skips file_receive LSM hook
To: JUNYI LIU <moss80199@gmail.com>
Cc: io-uring@vger.kernel.org
References: <CADxpCqA4jsObAAgJRcSk2jh-X-VSyVQguk3hAV4_ntO8R5XrQw@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADxpCqA4jsObAAgJRcSk2jh-X-VSyVQguk3hAV4_ntO8R5XrQw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13476-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FREEMAIL_TO(0.00)[gmail.com];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 3A0FA5A7A60
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 5/21/26 12:02 AM, JUNYI LIU wrote:
> Hello,
> 
> I found that io_uring IORING_MSG_SEND_FD can install a registered file
> from a source ring into a target ring fixed-file table without
> invoking the security_file_receive() LSM hook used by classic fd
> receive paths.
> 
> I reproduced this in a disposable kernel lab with a BPF-LSM
> file_receive deny policy: SCM_RIGHTS receipt was blocked and
> incremented the file_receive counter, while MSG_RING SEND_FD installed
> the same file for a lower-privileged receiver and did not increment
> the counter.
> 
> The attached plain-text report includes the affected path, tested
> versions, observed result, claim boundary, and suggested fix
> direction. A tested reproducer is available if you would like me to
> send it.

There's nothing here. To pass a direct descriptor, you need control of
both rings in the first place, and the receving ring could just register
the descriptor in question itself in the first place. Zero capabilties
are added by MSG_SEND_FD that isn't already reachable by design.

Outside of that, the suggested "fix" doesn't even work correctly either,
if the goal was to prevent it.

> This report was prepared with AI assistance.

No kidding, if only some actual reasoning had been applied on top.

-- 
Jens Axboe

