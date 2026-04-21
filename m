Return-Path: <io-uring+bounces-13079-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eOejC1qE52m+9gEAu9opvQ
	(envelope-from <io-uring+bounces-13079-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 16:06:18 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C2E1843BBF4
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 16:06:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8DFE6305C97E
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 13:56:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AE9A3A4F58;
	Tue, 21 Apr 2026 13:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="qUC4WXKM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A55E3BAD99
	for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 13:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776779793; cv=none; b=qFhR5Q0cDtkTJKwLujuvIYCT6lr7ZjliMNTHiVfRmOH4rYMCbPvNOuk3ej6VJ34oI6ZidFjsYDaqplMLbcfhs+BgY1l4RcX0ABHrAPHZeHvIJz2l4q1cJYedRhqRePNvfMu/AM+Ebre+q/ihWS7UsBjMB9hxMBjq5W3muFdm0GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776779793; c=relaxed/simple;
	bh=cxUq2NpoHDZchiOJ+/oRWWQdGNAILIA++SfmdMy/Puo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YSMypw+zKxvX3XS9Ur17YhiNhQNSfE7iohVEfVRXzGkE66ZYneb+/Gw+Ns5sKptVZwo1s9uIXchzkJeBky/RuY7CU6jLyN9k36YZ6yowvSv7+eRGCVsMzKOhUsyRLYHEdxLttkIvAuz0fftPRr0og0mAGsnKRKMIR8OcRr944kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=qUC4WXKM; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-4233e152457so2950623fac.1
        for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 06:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776779790; x=1777384590; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wYfV/0s2MY8fY3OtUhWa5yU7qcYyhtnJa1il3KspCwI=;
        b=qUC4WXKMZkBhWVfI/DCe/jloIs1wFkt6ykNOnfnRog6XST8KtK3TFVVMXF/0GrK4OS
         tduPEw60UYFEYP9ByB5iQhc0x5xaywiGCEtBlRgvCt3Ks60cRkR2qVBN6SdW/nw57BbJ
         WFHQ0dvoEgP2L+Wb9LdRYrRl1L0Go/0dJSTNxwDbeDfc6upn/xqrSztCAuWNqGQwePeJ
         tl75G+7rjTQJOT0nQApw4KBFUl1GwnelUMVX8q9c/eJFxb2a6vTBwWeeizDCy08Iuoe+
         SMcPNK2EltVBbbKXbz4vDCpDy6rqj4+uEUQxkcZ4VSX8tDwBwyXLdtoEAcg0teSLwtjq
         bm8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776779790; x=1777384590;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wYfV/0s2MY8fY3OtUhWa5yU7qcYyhtnJa1il3KspCwI=;
        b=KDJArMrCs63+TPsu4S2ZzYKkUj3bkD7JL3IxdZ0Pu7J8P+BDlBKSz73rQQS+fX2YXL
         ZJfUkE8zO9wO/p0f8CZSbe+soiIthFRr8BLWUqKClscnUZZwlrTEY18p2gDBOajuSfvK
         ya241Hf6LCfeMSU6jdGOn6hEjsO/Ry/F1smYWzIhdOC571ZmZSqz5eRCShla/YTwm2Wv
         aWTpFzsjoD0MxPTcfV09NggtYrJkFTHUBMrmKywZ/PRTbj2jKXpWie0tjXv7aoD4HRDS
         CXAal7WxXAyA66jZ+I2W1/Esug+DGD/9ErNBo2TyUXfhXQEWX5w9e6kxwttOstYuzxo9
         gb1g==
X-Gm-Message-State: AOJu0YzS2S95kwUSXd0LwcLX65IkD76rH/JVLw6FzIBdgkf6fMlibqoN
	inxIkIzKWMQZR576aMD9yfaigUr7oV0l1gYU8YuoAD8gNLUdQCangBbFSsulpZcTKU+tX61YXH8
	xKCMFO/g=
X-Gm-Gg: AeBDieu/SSrsODudT8+SiPkUM8iaT/Hr+VdwIefXvNsRGUqRaqgRl8E1SteTtVJD7U7
	qI9rrzjlQNXUNKGaNs0jqZ0qwjFtd6M4h34El4nH4ssT2QsiTdVK8ubu2+3U1icbMyfasellYRe
	k0hKtTpvY4tolx9VVzGyJAZ3V4V+zmud0XZXzGiGiZ1gOVgSgQt8+8ksi1TlO4p1G0W19K7Lxhb
	xgjQnnIwdJhPDwO8L2FPX372clmzy4UNuyZ2N450Fk/LSdLqPvlWuxw+KPtphnWf+bz3RL4eeZu
	KOZrNK6cx//dW4ns2od2viX5fyl2Td7Uni6lFjZVUURk02wsNeSW7oSdITxuiE5UXrUjWmgzCzX
	o/65IL7ZIQQMflNxPef/SvtntT3VJmg5fEf+pu6ZxubMSyuugFsHOEr5LEzrgKKMp6/zAbIIy2x
	WgJU3+zTG3jPAPtcovvjBeDUeQ2WkIMJRxS/h9TON+BASw+opd9NIVm7T5tpeTOruhFS/aVyn34
	qzdbf8=
X-Received: by 2002:a05:6820:1849:b0:694:9fda:6366 with SMTP id 006d021491bc7-6949fda6b76mr205971eaf.6.1776779789754;
        Tue, 21 Apr 2026 06:56:29 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-42b8fe2c52bsm11756474fac.0.2026.04.21.06.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 06:56:28 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/6] io_uring: fix spurious fput in registered ring path
Date: Tue, 21 Apr 2026 07:51:38 -0600
Message-ID: <20260421135626.581917-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260421135626.581917-1-axboe@kernel.dk>
References: <20260421135626.581917-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13079-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,kernel.dk:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: C2E1843BBF4
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Fix an issue with io_uring_ctx_get_file() not gating fput() on whether
or not the file descriptor is a registered/direct one or not.

Fixes: c5e9f6a96bf7 ("io_uring: unify getting ctx from passed in file descriptor")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index dd6326dc5f88..4ed998d60c09 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2575,7 +2575,8 @@ struct file *io_uring_ctx_get_file(unsigned int fd, bool registered)
 		return ERR_PTR(-EBADF);
 	if (io_is_uring_fops(file))
 		return file;
-	fput(file);
+	if (!registered)
+		fput(file);
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
-- 
2.53.0


