Return-Path: <io-uring+bounces-12642-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cG2KM+7VsmlDQAAAu9opvQ
	(envelope-from <io-uring+bounces-12642-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 12 Mar 2026 16:04:14 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 72AA6273E11
	for <lists+io-uring@lfdr.de>; Thu, 12 Mar 2026 16:04:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E6665304AAEE
	for <lists+io-uring@lfdr.de>; Thu, 12 Mar 2026 15:03:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D862340DFD6;
	Thu, 12 Mar 2026 15:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Jt1ZcQYL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F1938B142
	for <io-uring@vger.kernel.org>; Thu, 12 Mar 2026 15:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773327773; cv=none; b=YMWwLFud0Ph5TrewVnInQkbxPUXIZFoXlO7JiVI2gL+XMmSQ4+76ZB6ONXbJU+sstkBBs8szYILRYmKLCu6BP6jUTk+nPUyLSMYJdiEhrA3slzpTye1+kBMwlLh82pa3ejBUSkNHGscASDi7wgjcVip9r0uM1dwO/VsSGWP6DXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773327773; c=relaxed/simple;
	bh=qvC7uk8WTdHxywDWmFHp5xbFxZANBrkQF0quj17Qyyo=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=fz1DOiq7XIxgTTcD8je7QRrRxgnFSlWvWWVTADNURj0EHjjxmnBN/iuEHCOAvrSa8O84qUO2bnwcsVv8srYi2BunP2z8EIIOQXyTEiLqT0aYI3eq+eGvXQobTGgLt2AJYOgK7jCqtjHj+zAdzBSWc0BbqsWSr4pu+bywZNVqADA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Jt1ZcQYL; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-4671cbce32bso290258b6e.3
        for <io-uring@vger.kernel.org>; Thu, 12 Mar 2026 08:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773327770; x=1773932570; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dJhEy6JgP7KS4pnqAnLYK5ynzL0YX9LNZAkSVPpGjCI=;
        b=Jt1ZcQYLCYoOdmRLLjbB5APPVCJf/8e1Ahprka66DEVWGXImUUWC8T/d5oSPCBWqki
         V00xIqky/6qAY+9Co3iTUavxga0Xi6HFd/etBcfHTl0xLFDTCXGjkRo+6sA1KvpUZMxn
         +zb1gmzLW1LZ0wtk4XYcv36Op/hFxHbaAZVVQ42ZoK6m3WbQL87UFQLaGmzIv7HY3m09
         wKo5LAJWz/XjN0HaXF9aDqMttVKTO21i1/g/3PJQTZkV5m7uKste5mbCLSEscPtersWn
         AWeEXTnX/iZUbFx7hM4nMPSpG6BRCeJopBrej2prtJ24LVVrBiEGRawqT9JG3NQeuNWr
         0GRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773327770; x=1773932570;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dJhEy6JgP7KS4pnqAnLYK5ynzL0YX9LNZAkSVPpGjCI=;
        b=mTOhZE4eqEbeIESNVvDBG+EWasBD1vzP7EDkQx8B55l70yhThTfDF73r/vKUWBp16q
         xVaRF/F1hJ1GP3t5tlM9CMlBhAHotrY5Mg3+D46tJlNksYdk0geFUxjHEjyQGTiHuy60
         dCMucL22pImn/r3GrOMzcOGNOUDcZSHBYkgshI2qkJ+MqsOkJ1j0Y9cjYoreXXXmjUZ2
         l7ePrmBLiT7gEEbQa1TDtU9bDSnk7jBubU8mdRL6LZZAe1wwikOjYuHqZ2n567OENEkz
         N2hHe/B3/HG0XsW1nso/HQ+d1AHKY4p7V6dkxAHZIhBy1AXyUQhO1FchylIbCUzOxi5t
         DlOA==
X-Gm-Message-State: AOJu0Yz8DaEgXqttGFIFnvO5KDslwvsPDFO/qUO4EqTLvXcFXtTPY1qb
	cKdiBCI4EbLUh4hR9K5pH9OVWHZ3lfDYhpnYEpiU7azSFVh+RpeAjprrcZQ4p2tLpS8qj6aHgvW
	L87JIW4Q=
X-Gm-Gg: ATEYQzxddS5+TjJJxqi+H/YgiFLwPi6YpmzOzKjPDC2BxvMD520QNsKrp4iGrQsfYK2
	QJOu4n8ZICo57OuJsm9Xd+OoqSq6KXRlyyEWiu2QfTkP1LUyp7wvjccTfHR4+A2h9nOq1uyydOB
	uuLHySN8el8LJ0+ToaZkU6hjHWiBzd5gbZ2JjUaWvvawapN4FWZw5ScPpYhFK9SyYiXItojksTh
	+SmwGyxjErvbj9dFHaiH8gc+M429a+UAy+zIXypZUZ2Awqdgef7mCSi9ej8APmQpuFGlkKFibeb
	B3E0/NlHd79+k/+1gWxb6GuNFXNACsR62Mwn5jujkY+zCpwkix6ciF2uVihspCmhMLSCgmecJ43
	/6N5j+EFqldz3HuxloPr0BhcT522ePoJSzTIYMyySmsNAa3qlhxnaMn6dPtS3tlci5YKMctvOAR
	e3dlVuXte9ZbCWSYhNlgbTe1jZ4iKExUWH5MVmU7eAKhmxpWU/kWYrGkJOdsBaJ22jAywlSrv0s
	h0z7nuF
X-Received: by 2002:a05:6808:1903:b0:467:26e4:728f with SMTP id 5614622812f47-467334231bbmr3230183b6e.12.1773327769606;
        Thu, 12 Mar 2026 08:02:49 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5094a03556csm14897141cf.2.2026.03.12.08.02.48
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2026 08:02:48 -0700 (PDT)
Message-ID: <dc1ec0a6-9697-4d94-9bdf-a091da29c77c@kernel.dk>
Date: Thu, 12 Mar 2026 09:02:46 -0600
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
Subject: [PATCH] io_uring/kbuf: check if target buffer list is still legacy on
 recycle
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-12642-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MIME_TRACE(0.00)[0:+]
X-Rspamd-Queue-Id: 72AA6273E11
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

There's a gap between when the buffer was grabbed and when it
potentially gets recycled, where if the list is empty, someone could've
upgraded it to a ring provided type. This can happen if the request
is forced via io-wq. The legacy recycling is missing checking if the
buffer_list still exists, and if it's of the correct type. Add those
checks.

Cc: stable@vger.kernel.org
Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
Reported-by: Keenan Dong <keenanat2000@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index dae5b4ab3819..e7f444953dfb 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -111,9 +111,18 @@ bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags)
 
 	buf = req->kbuf;
 	bl = io_buffer_get_list(ctx, buf->bgid);
-	list_add(&buf->list, &bl->buf_list);
-	bl->nbufs++;
+	/*
+	 * If the buffer list was upgraded to a ring-based one, or removed,
+	 * while the request was in-flight in io-wq, drop it.
+	 */
+	if (bl && !(bl->flags & IOBL_BUF_RING)) {
+		list_add(&buf->list, &bl->buf_list);
+		bl->nbufs++;
+	} else {
+		kfree(buf);
+	}
 	req->flags &= ~REQ_F_BUFFER_SELECTED;
+	req->kbuf = NULL;
 
 	io_ring_submit_unlock(ctx, issue_flags);
 	return true;

-- 
Jens Axboe


