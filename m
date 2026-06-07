Return-Path: <io-uring+bounces-13631-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id Mgu9LTXtJWouNwIAu9opvQ
	(envelope-from <io-uring+bounces-13631-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 08 Jun 2026 00:14:13 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 155C1651CAC
	for <lists+io-uring@lfdr.de>; Mon, 08 Jun 2026 00:14:13 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=swhxnwwh;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13631-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13631-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E869E301CA45
	for <lists+io-uring@lfdr.de>; Sun,  7 Jun 2026 22:11:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AF4431194C;
	Sun,  7 Jun 2026 22:11:47 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC57D6FC5
	for <io-uring@vger.kernel.org>; Sun,  7 Jun 2026 22:11:44 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780870307; cv=none; b=uw3k26KeoWtZ8kh9myzOCWBhUGbzq0L4D3aamDvGmV+uxXrjfgM8NZcHJISj7ESKJypVPZKyFLL2MXts+piBEQrlkuxRFgRSj0LaKU+Ud6KLk8mKr+IdhffN3Ld0dMCJNpFev3Po9zlHArwR7YIxjdNqBQjjbb4z05qVItse1lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780870307; c=relaxed/simple;
	bh=smNzr7I3tG4Nwf8SXiS2GEFzmFuEZmJwiIcI1cxjksc=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=bt4NKG8imfUOKYeEhTVjY7RbeQOonF6yeIuV4W0revNBi+BvUzKTkxvl8h44NtGve9R4NRr+Vs6120XDqljC+HYDDZjUJYn2J0T8W6BAjhWLPPmJCIbqofyx88WgpQsXYQsGbsyudxs/5Rqn0XP1SZ5X10Cant3ExLiKr/ftr8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=swhxnwwh; arc=none smtp.client-ip=209.85.210.49
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7e6b571750bso2665956a34.1
        for <io-uring@vger.kernel.org>; Sun, 07 Jun 2026 15:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1780870304; x=1781475104; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fQjIrr44njyhdwUCr2/UUGktUn+EtASljoVcuBOYOts=;
        b=swhxnwwhcAK4WhlWIp8wHnlzToZU+M7f4LdGkmuuoscioDvMgHwn+O7ekxFt8xOAXR
         8hHy3RVL0Bq9CjClJhx7vuqzWrKcsfaGzFO7Vl+jn+cP2pt1dUjq3FNpoSKaKm2iTaTi
         qx8SQlS2UtEi4i1AGb8dRLgUFLfzOJl7nVnpefABPdZV2mWPHuP+xnxY4jJ2K6QgDkv6
         lNKeQLOs5e+h40tVGElU16Tv/4tesaCHOmPsDgvZeKSJTiQlE8pq6n0/EVPXgZbM8ONl
         DLCSyFxhc+ffTgUdWejOQt5z4YIHPGEODbIXura3wIfx0xpXC/c0+5TMi25Fm3GzJoxo
         ef4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780870304; x=1781475104;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fQjIrr44njyhdwUCr2/UUGktUn+EtASljoVcuBOYOts=;
        b=Om1SjWEKJT8QlG5X9xyJYd03Tas1bLHsnSfNb5Pt4yHVfHmpAkuanYhkuEd2OC5fp5
         m1qMRBKId6wteYU00Ygx40G4U1C1IDBiyJkjOesk88pY3bKYl8CXW3lMEtuMoBlaCnIw
         po5vSGeHXd8vNrs08GQCiBKFBzNTsM2baaQUshURdcyEtZDzEJrm6FYBYr8lv4W9lGe1
         kPINxtweoJ5kQxItg0mDUaXO2Bge3MZLdoXFSkTE3nujX/eXl9sArxa7npxQ9wPwnZKr
         jsuHp4bC6PJ4SB/BuQvh36nFIILFDVmaGCXDfAH9y1mmjQ53xwcLo2McwE87lVMKeBnW
         MsgQ==
X-Gm-Message-State: AOJu0YxyewvC+W5TF0GlFb5qjzL5dNS8zQZ3lNB6E2GiuzKXxPpY23d+
	5ANpW1qa1i0b8/u0a7Ismhk8HHh1RBMCAGQ5hdnSE9DHyKQe6s5YvmMqwJzy8eIhrF0+BRzSK7b
	fukI7
X-Gm-Gg: Acq92OGQ/Mu+IfoIl1nkiFDdBAW88mMFo8v00+u4nQUAcIea1MWmPZvB0WFlII+HfsO
	cEI7OWZwOiFsaGi/EveBn+zXChnX6t+LEVwGbeHKIzz7d9a2flWWF0vFYeWb+M6f19KBFWl9Ba4
	aS1UXO1EPIt59tsnzRVixmGFAJlgrRR8F5LnskdL3rHkIqrvxO3bZvBUL0vD2HZZTt51jFeeksO
	5GIReJnBN3E5zoBOl8p50NT60uY34eEPfphIKVThEK4KVvwgo8h/Itu8XDRp0h8oYV+K0/nvLBZ
	OsSCsLhGFb3BSbrF2fNH1XWrgZGBYeuTa3bNCOJV3ToAb5XuGE2FSRH/Xd92MeJgCFmJZQY70hq
	nXUoIGNXveDEbGApRXbNAjJ2TLZ5xd2Jl9e07+NYVftfuvLgtPjOsPdL33ZKQGmwv2jZdqq6s2S
	aTR4sobObobHXVoVmgJqZn+g5uvhJKwvcvlx8oZ6IgQxog/1U0HWxsCoQ2LsUku0c7iAVNgIZGn
	A2C8e/KWLX66Mk2Uc3Y
X-Received: by 2002:a05:6830:83b1:b0:7dd:9b19:a875 with SMTP id 46e09a7af769-7e70c5ac29emr7395594a34.2.1780870304008;
        Sun, 07 Jun 2026 15:11:44 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e6e75db138sm10617848a34.11.2026.06.07.15.11.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jun 2026 15:11:43 -0700 (PDT)
Message-ID: <12e32fad-16a7-4cee-a1be-e95a938e187d@kernel.dk>
Date: Sun, 7 Jun 2026 16:11:42 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/kbuf: don't truncate end buffer for bundles
Cc: Federico Brasili <federico.brasili@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13631-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:federico.brasili@gmail.com,m:federicobrasili@gmail.com,s:lists@lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FORWARDED(0.00)[lists@lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid,kernel.dk:from_mime,kernel.dk:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 155C1651CAC

If buffers have been peeked for a bundle receive, the kernel will
truncate the end buffer, if the available length is shorter than the
buffer itself. This is unnecessary, as applications iterating bundle
receives must always use the minimum size of the buffer length and the
remaining number of bytes in the bundle. The examples in liburing do
that as well, eg examples/proxy.c.

If the kernel does truncate this buffer AND the current transfer fails,
then the buffer will be left with a smaller size than what is otherwise
available.

Just remove the buffer truncation, as it's not necessary in the first
place.

Link: https://lore.kernel.org/io-uring/CAAEr8jbY60noGj1fw_k91UJRBkyiRVoS6=nLhZ7Svwidjn4CAA@mail.gmail.com/
Reported-by: Federico Brasili <federico.brasili@gmail.com>
Cc: stable@vger.kernel.org
Fixes: 35c8711c8fc4 ("io_uring/kbuf: add helpers for getting/peeking multiple buffers")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 63061aa1cab9..926254b6898f 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -305,7 +305,6 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 				arg->partial_map = 1;
 				if (iov != arg->iovs)
 					break;
-				WRITE_ONCE(buf->len, len);
 			}
 		}
 
-- 
Jens Axboe


