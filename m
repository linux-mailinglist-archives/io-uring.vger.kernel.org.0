Return-Path: <io-uring+bounces-13676-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id K0r4CWv+Kmo60wMAu9opvQ
	(envelope-from <io-uring+bounces-13676-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 20:28:59 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 870036746D7
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 20:28:58 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=G6wxcgi5;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13676-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13676-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8F74330D7EBB
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 18:28:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E126348033E;
	Thu, 11 Jun 2026 18:28:54 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E5440B6E2
	for <io-uring@vger.kernel.org>; Thu, 11 Jun 2026 18:28:50 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781202534; cv=none; b=fOYl+T+r3zubeDSikC2d15WYNojJ52qnBM4TVjaUAazWPbpTBGC2LhrvoNbTYpfPoKJ+FU3F2UttdvsgYUG3mp75TD16CuFfIqfVuPk+5hwA6kS1nvINnHYu74yydZHQpOdqISrJl0CErkQ/zM/tKHr/QIoB1CmMlDkz/VMu3aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781202534; c=relaxed/simple;
	bh=11EploZr1Ts5GGTP+efShLuMtW+SJAfFVf/uB5OEJgQ=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=r3L1tGItVykSd2qWRqQa2tZ7J9C4zND2v2NpK0C+fiaPEV6x10w7qdLcRN1S+ZC4ISuviOgNpljC/X6jBHDY/4XHZEE5ILTc0h0HRiyRytFX+MmYjIyr2ir5OK7d3YeEtRzHNUxxNluhDSLxr6VveGQESobGtVLIh6HA0WEe3ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=G6wxcgi5; arc=none smtp.client-ip=209.85.167.180
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-4864a5c83f1so177967b6e.0
        for <io-uring@vger.kernel.org>; Thu, 11 Jun 2026 11:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781202530; x=1781807330; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JiNxR1LQccy0VO3MqleyAEqAALy/LDrOj/Ae0Q5E/YE=;
        b=G6wxcgi5KSlCnAFVgVeA8RLBfz1EEIaRgI2obMbo0nlgRrOlPi+luvpCD2AXAPkdg2
         kLxi5+6aK+1mjCHMu9YBX75jNRjgGe8LdkTn6bmxZ4ERzMwA3SVbEXTWDhJVtc3kHnOD
         Hzy2DqJ9EnlP7Crq7Pq2a1oYLB9MMdKg/8hWHlwHFlTUcip8sPokq2hUs/uK3ZLiejLW
         odbtL8DQ8lcz1hRSyYeZFikiXwEPoiXs8Ds+OlTdHYK5GCJQjs2FlCRr1ovw7AHZ0jop
         y7S69FkE6nDL5XhWPa7Qv2yKZo/ZcOnA/61F6Vo8sBDyZT4bAfmeAP5D5/D8my/69M48
         WMtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781202530; x=1781807330;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JiNxR1LQccy0VO3MqleyAEqAALy/LDrOj/Ae0Q5E/YE=;
        b=dIJ/1dBssvhCS4kxeuy7zZU3nyskkZ5XhjaMzdJe8E47jK93ZjfOqhJI8Qj2iIP8e2
         PhNod2YwXVLudDFdYu3Awxnw9l8tdw479APqblTFRNFixQ2apb2kO7+RL3dNT1SfpU6o
         2xZiNrn3udfv2W80DH1swtWJUjf20HjOZfGr/QXZTAv1bVuyJV/b0IK8jLqLkSC8pZ1j
         4+RLiCjFjrFu180VJIvU5YhsMRpIXjEZtZRcQwgLuDC9/DixnJEe1wvIxIT4jdCpW+6k
         /2kknAmkYnmzA49mE1dB39xfNSXKNtrX/qr35dNgmNn48jrojJe1H61e1R8h3vN3oMra
         hqvw==
X-Gm-Message-State: AOJu0Yz1DU3KGS+iMr5Zq9q7JnO8hqy/AXyJdpWKTDlHhOzifb9YJEbn
	hFF2kMQfBKvV6OMdMJyzyowtXkDiA5FATfi3D0Msfx8hoTekFC+7qqPpdXOrJhZ4ldQlQy9YYrE
	HbXoCzHc=
X-Gm-Gg: Acq92OHCLyR7f8AKpxM3EEOxj/Mu2uasGsKKfuQNUVVOLvDVjAshuXSkMvnyy5+1ka5
	lYkewZm27Fggp4dUESgghxrfIfErue+98is0GzOrciDQI0H7HDV9E13DvgQALL7nnE1gcsPETnP
	mGcMaRYC9f7vcQcX46+OdDsFqwiwWP8pdOxgIJR1CyGyNCr8aM/XwhS04SGjOH2rEAUSe1HqX99
	e7Kay+ujZjRFq3skSL4gIgh80fzHcYJWJaMDUYJgbnn17aHXfw+gOwD/BfcsE6xxg0r2zaSs2Ce
	fSv4PVUtjFAEyut4BsH4qtaIMQU5C+fWstdkmpEOyprEUFHm2T12qf2m4bO80RT4sbrT2nLthWm
	x+FDyvO27HqLVxf7HKLGE2atJM1J2Vez4vkpmXwO37cl52X0/SMx2g8nVU4Yg+aH7PaR7qTrrfx
	1q3ooEE8bN2EZYRqtia+dcWUYp+PR5FJ//rOgBezRyXqdaQ77w7eZVGnaovZwVU43dHJHaGVOS4
	gL80IIG
X-Received: by 2002:a05:6808:13c1:b0:46e:df55:2403 with SMTP id 5614622812f47-4871a092d28mr2835364b6e.18.1781202529888;
        Thu, 11 Jun 2026 11:28:49 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4865ba20b68sm21491805b6e.18.2026.06.11.11.28.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2026 11:28:49 -0700 (PDT)
Message-ID: <6c374ba9-7c73-4e1b-9285-447e985c9ef6@kernel.dk>
Date: Thu, 11 Jun 2026 12:28:48 -0600
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
Subject: [PATCH] io_uring/zcrx: kill dead 'sock' member in struct io_zcrx_args
Cc: Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13676-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:asml.silence@gmail.com,m:asmlsilence@gmail.com,s:lists@lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FORWARDED(0.00)[lists@lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 870036746D7

This member is only ever assigned, never read. Kill it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 6bd71435e475..49163f9c39df 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -339,7 +339,6 @@ static void zcrx_sync_for_device(struct page_pool *pp, struct io_zcrx_ifq *zcrx,
 struct io_zcrx_args {
 	struct io_kiocb		*req;
 	struct io_zcrx_ifq	*ifq;
-	struct socket		*sock;
 	unsigned		nr_skbs;
 };
 
@@ -1733,7 +1732,6 @@ static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 	struct io_zcrx_args args = {
 		.req = req,
 		.ifq = ifq,
-		.sock = sk->sk_socket,
 	};
 	read_descriptor_t rd_desc = {
 		.count = len ? len : UINT_MAX,

-- 
Jens Axboe


