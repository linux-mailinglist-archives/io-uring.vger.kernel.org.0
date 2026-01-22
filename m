Return-Path: <io-uring+bounces-11895-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4DNHNjatcmmAogAAu9opvQ
	(envelope-from <io-uring+bounces-11895-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 23 Jan 2026 00:05:26 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CC226E648
	for <lists+io-uring@lfdr.de>; Fri, 23 Jan 2026 00:05:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 00FE6300E486
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 23:05:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08A623A2ACD;
	Thu, 22 Jan 2026 23:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IhytD850"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A124C3904EB
	for <io-uring@vger.kernel.org>; Thu, 22 Jan 2026 23:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769123121; cv=none; b=s5VL+SUv90kOCeMlXl8H+pnnT8VJZDfSqKEDUT7HEuVxm3zi0wUBG77MCHBShknWMUrt8hcxTF4dvmeMBLsYOo7XKlw8QAOilQ0+FST/OfFYhzYS1MOMJgYJVAONZmQ4m+umg3gYspCoH1t3lzM7eZiDVJQw7aWQnXPIBCtwXyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769123121; c=relaxed/simple;
	bh=BRkNBM+nAK1fU2edOZNlgCTxosMVEVPliQgsZIi7+yI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=X6HCVcRSP4mtU1ZPH478/eCYGtB8ANAPNjwQEcG9Uz55/aaYpjMGb3tvusZJ8G/W6EAnPRrMXvWvhai0Wtzvzt8is8bHIYQo9NBLAOdRdYYo7XcWfM29Q5HKMe2oRZeANe26W//2DAg1/0f8nJ2eDl7LqSmSLyz+0t89X81ykEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IhytD850; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-6610f045c1eso749744eaf.2
        for <io-uring@vger.kernel.org>; Thu, 22 Jan 2026 15:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769123112; x=1769727912; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xTErY2NBoQwsTHfWwhDbmmqFuZqqlFPuJ/dmdx7ixo4=;
        b=IhytD850BAchdi2lPktj+KfimWRGO8eLrzqTJ7+KqBM2HFl2TbRi08IeDxu39w4MRv
         U027mQUt06k0MMkAVMYzOm/7lNgSldE6vqABBmOvF4o/cp4TCVYBrT7WI+i8Van2Og40
         9MK0dZlqw6Zk5BSGTgHK20ttXlO5Wm8H3HsXsd/IdnnrYdlIHCWmvAVG5oq5cdLBLeyM
         keECRmOpcKlI7xjZwzr3At3wPayThfyRsSlhQg7Q0hjduWYj3x0xWJTXmIziAzkBCtGe
         tMhKFljFA31CRE9s8lwzIPlxeWKnTUlGf5uC3Yt7O6vhK5pAOh5wKhunJA97PpUSbYYr
         8zog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769123112; x=1769727912;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xTErY2NBoQwsTHfWwhDbmmqFuZqqlFPuJ/dmdx7ixo4=;
        b=qWXttzeL5DlO/waw+y9Q6XrHeVGwx0wJLrHIx7GKqKwWMEzC1wfvsNz+id3mi16nax
         PGrSIUpApRCB2LoeHBnPiQzoltohsWHJkWj5nVVC9DaoJWaslXXfHTNwaw3/UnRG06Dc
         eIO7DRhCAEAviVl9Xs2RkPzyd58Cg37wN6nFlZwXa3F0JnChbgCKE3YaXIWZWUiW8Yp/
         69r/t/Vgz9PjJ9rwOssBuOaY/Kg2dIljGTCtXnzyR59VGpGnckoxa0VIKGR0JowD57aX
         baeiK0xJ3XrHId+64NmsHrpBvTiGuVWLxmIkK1kXUVzYteH70bY1nV5Z9DJ1u4KJj0ic
         GLkQ==
X-Gm-Message-State: AOJu0Yxl0F18SRMFlmQnL9eAQRva9NtpOnjIJjXk27Y5lnFActJ83lfD
	aX94qN/OlgS+TQtzA86kR60QSeaDjZc/OBF2C+uVALE0eF3NRbqVBBXy1VfNPRA90+OzfSz7+90
	VZOoK7FQ=
X-Gm-Gg: AZuq6aIsNtwkDQKki5jfXSpcTq7w/zWdPRbO4Yx5PhXaNVnjPL86zlDz1WQPkG1Xsh0
	H8gQeCRxIQUxUMT/G6uOHcPlIuRDtMK/uil1ieYUHJbKvEJr+kx4Usx69lj13hbUn8/efYUrIF9
	zbinHFGI+C2+pAmyq/emEu/a33O19VJZQKjZK7zIRApeI6Rixvg+8fFNW/kHLAwI0Xy+bSQCCqC
	wv2FtBR/Y/BO3iK4V5yxp02ymJ7+fv/p3PGrzVDNjaqjWlQxKR70aRRseMsRIMjNeJtv1GUix9m
	4o94a0c8u5Kk9CVfwcRsELZymkEWBYvhUsHLu0XH0+0SnSq/XmMOhYhwEqmTt/G2bw6LU1+/dNs
	G3Wcq847rS3Rk9d+Tjl1GFjiUXpI8khNvrshiAKrzrb2kwmVA3nW7bBt7eoNLrvnz419o/geCFA
	Ek6MvgNMUAME8QyRrYawSl4fJLNvWGEep9Dj4ekaKFenup5ZjLsAd+2FwXwX6HNV+CHjtqYQ==
X-Received: by 2002:a05:6820:f009:b0:65c:fc52:c338 with SMTP id 006d021491bc7-662cab42982mr625360eaf.50.1769123111879;
        Thu, 22 Jan 2026 15:05:11 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-662cb650fc1sm309217eaf.11.2026.01.22.15.05.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jan 2026 15:05:11 -0800 (PST)
Message-ID: <517fc5f0-5e6d-46ef-800d-9ef4428278a1@kernel.dk>
Date: Thu, 22 Jan 2026 16:05:10 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 0/2] Add support for IORING_SETUP_SQ_REWIND
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
References: <cover.1769034107.git.asml.silence@gmail.com>
 <176912275112.522897.5400530813917730862.b4-ty@kernel.dk>
Content-Language: en-US
In-Reply-To: <176912275112.522897.5400530813917730862.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-11895-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.995];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 8CC226E648
X-Rspamd-Action: no action

On 1/22/26 3:59 PM, Jens Axboe wrote:
> 
> On Wed, 21 Jan 2026 22:23:20 +0000, Pavel Begunkov wrote:
>> Add liburing support and tests for IORING_SETUP_SQ_REWIND.
>>
>> Pavel Begunkov (2):
>>   src/queue: Add support for non circular SQ
>>   tests: add SETUP_SQ_REWIND tests
>>
>> src/include/liburing.h          |  5 ++++-
>>  src/include/liburing/io_uring.h | 12 ++++++++++++
>>  src/queue.c                     |  5 +++++
>>  test/test.h                     |  2 ++
>>  4 files changed, 23 insertions(+), 1 deletion(-)
>>
>> [...]
> 
> Applied, thanks!
> 
> [1/2] src/queue: Add support for non circular SQ
>       commit: c22129cf0b8c936eb478d920ef84e53d89c6a5cc
> [2/2] tests: add SETUP_SQ_REWIND tests
>       commit: 346c063d16bda52f02d00feb744aafe35b4002a9

Hmm I do think you're missing some spots though, no?

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 987b28aaf99e..016be1e80ef2 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -1702,8 +1702,13 @@ IOURINGINLINE unsigned io_uring_load_sq_head(const struct io_uring *ring)
 IOURINGINLINE unsigned io_uring_sq_ready(const struct io_uring *ring)
 	LIBURING_NOEXCEPT
 {
+	unsigned head = 0;
+
+	if (!(ring->flags & IORING_SETUP_SQ_REWIND))
+		head = io_uring_load_sq_head(ring);
+
 	/* always use real head, to avoid losing sync for short submit */
-	return ring->sq.sqe_tail - io_uring_load_sq_head(ring);
+	return ring->sq.sqe_tail - head;
 }
 
 /*
@@ -2063,7 +2068,7 @@ IOURINGINLINE struct io_uring_sqe *io_uring_get_sqe128(struct io_uring *ring)
 	LIBURING_NOEXCEPT
 {
 	struct io_uring_sq *sq = &ring->sq;
-	unsigned head = io_uring_load_sq_head(ring), tail = sq->sqe_tail;
+	unsigned head = 0, tail = sq->sqe_tail;
 	struct io_uring_sqe *sqe;
 
 	if (ring->flags & IORING_SETUP_SQE128)
@@ -2071,6 +2076,9 @@ IOURINGINLINE struct io_uring_sqe *io_uring_get_sqe128(struct io_uring *ring)
 	if (!(ring->flags & IORING_SETUP_SQE_MIXED))
 		return NULL;
 
+	if (!(ring->flags & IORING_SETUP_SQ_REWIND))
+		head = io_uring_load_sq_head(ring);
+
 	if (((tail + 1) & sq->ring_mask) == 0) {
 		if ((tail + 2) - head >= sq->ring_entries)
 			return NULL;

-- 
Jens Axboe

