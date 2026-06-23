Return-Path: <io-uring+bounces-13822-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id I6tgCva5OmqEFAgAu9opvQ
	(envelope-from <io-uring+bounces-13822-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2026 18:53:10 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B33D6B8E0B
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2026 18:53:09 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BLft5KCT;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13822-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13822-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CC80130CE045
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2026 16:48:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F9C731A7E2;
	Tue, 23 Jun 2026 16:48:27 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5492731AABF
	for <io-uring@vger.kernel.org>; Tue, 23 Jun 2026 16:48:26 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782233307; cv=none; b=ck+2rUp2Gnw6+3VfYwV88kGhjiWeUFJbRjK9pqkb+p+BdR6O7TyiPXwkhOdURqxKqUcJn+c1gA464MluV+pZ00U2NXUqjFdEAKLQ2DdaNO37HUJzkfGoWNFS8vnC81ndddFqWRly/WG3YW9GgsvxMYmu26yGrh9vBK2c2Q/7stI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782233307; c=relaxed/simple;
	bh=5W9/ysumqOx/C+0z46WnNJc2ZT8vCEWjgUPP9cz3mcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zq+FqkQVIyg7sf5LQzs8M4mr9x2ycakbNI+Vzg91FWNFJbYWtO9HDnKlBpTgncQYy8692/+C/xHZ4K9kZESrrUgPepNlE8Z/e2y9DDxOTPXFgYHBPQLNu6xli2pwMtKd6dllsPMBH3Um2QtRQdtNy8ZVfQ6sFrdvQs+9JaIxjBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BLft5KCT; arc=none smtp.client-ip=209.85.210.176
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-84232e83ca9so76417b3a.2
        for <io-uring@vger.kernel.org>; Tue, 23 Jun 2026 09:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782233305; x=1782838105; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TuCsDRN0XC49lSZ5pSlY0k50HNKNpHDnltXtgvvLnGA=;
        b=BLft5KCTw0/hChM9fZkA1zNKMSEoaesq6UtK6XR+rZET67uWoV+GYbWngnyM3YcVlX
         irazIHpvZlGz6XHV7rqYc7dj1EwSQqlwFMcNEVwUBc0r68l07TaWrLsuEy+eVrmUsiDc
         4sH6HbgTXgH5gMxced3PzVOWu55l3Fo2oQQyanuyENRuRWGKuC06/HANJjw9ecQeSoX5
         PJYJQodKi3psSAJpdmwlc1ieC2hGIMiiMwUrgoNX7X2drUmG3Gp89XMSk1e2ogS8mSil
         oZBepW8anXLXYYACKBn63K5ZdEs/AjcMgiNfcCymnIf1bEcOLZyhph3tXWva4uy6TNFm
         nr9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782233305; x=1782838105;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TuCsDRN0XC49lSZ5pSlY0k50HNKNpHDnltXtgvvLnGA=;
        b=ce8/EwVY4cvbrr/1J9FCpB1MCJtVSYYZE18Ug1A012wupRvrl71Vk7CqonIvdQihrH
         79qCa9oRO0EPI6bh/A/FDGS1BvbSikG/XMw/B4oOBpa/nxB7P051A9Ola9b8k0Li01v+
         ox5dHMtNJyxU98Vf4kU1jWo3e9S5wq3NTj0b3nzWqC4Z50TTaJJ5S9yDYXEijcXpENoH
         TnssRIq848xI07KNv5xvToNKRLh01VD9WpNv83pIBft4XqhY60gXLNPuEauRRs/SRWIv
         qFkTMh2K93yODOZrWTLLCXdqBU5PJDSCy48Ec8YjDONZsFjAiYyoio3D4stKTnwpoj6v
         NZxw==
X-Forwarded-Encrypted: i=1; AFNElJ+q/lHY3MbgTb9OHXXu4tLysBuU04tH/uIBsx4H1y1tgBASCJbQyBqChTSMrqliUnVF3P1bLMOCHg==@vger.kernel.org
X-Gm-Message-State: AOJu0YysPWCEnP843xrI4S8Qq8Yj2yGgNWK5NBvFfR6VD5Iyn7S6cnNd
	T7w+/0tKxwHneKhHROET/ahDh1TqMbyhI+gpKkpSgYBEGcQbUfbbvmCk
X-Gm-Gg: AfdE7cnnbMZxIwDdkRsuSElDIiqZrmAC6JYaMl+co8u2n85N0+yFFL2cyDJA9e9VnCU
	IX38XwVyU/10k/urOI6IEFWkn8+X/XbRaiJ7RoiydYZWjncHTRtq5tdkzDsl4r1B+7B1knaoXFq
	CT20q/g611ecfqkQhVGJKDz0X23GGZ1VUE1+sUbicU52qbCTcCvLUc60kMFYvI8qXCHOiXFtnHI
	VGE5EujIeYIAwX/BT3bSZoo7U2ngVPPb2pUZZBfP9Llv2GyrWmtGqTu/zDg/lTTpL32En2yjO8Q
	cGX7I6hP6XtK30mGeVi+bQPGWgMNcF1c283eCBG5HkwbMmL4/8AJweskWTqnxyzZ7G0VUPVoTjN
	0VByC+RDVkLEy2sOk/Giwj1g19COJE+aUHvUcD/j4QY+1ZiKFbpIeTMC0LxJIdqtoJnuN5JXEpX
	yVhDqcEis/E1hfRbgKsdRNYASpCdnIZD9QZRyGrzk6aqVONw==
X-Received: by 2002:a05:6a00:4616:b0:842:7992:bdc5 with SMTP id d2e1a72fcca58-8459544013fmr4670334b3a.41.1782233305513;
        Tue, 23 Jun 2026 09:48:25 -0700 (PDT)
Received: from Athena ([58.146.97.171])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84564ecd779sm11373382b3a.53.2026.06.23.09.48.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 09:48:25 -0700 (PDT)
From: Harshal Chavan <harshal24.chavan@gmail.com>
To: krisman@suse.de
Cc: axboe@kernel.dk,
	gregkh@linuxfoundation.org,
	gustavoars@kernel.org,
	harshal24.chavan@gmail.com,
	io-uring@vger.kernel.org,
	kees@kernel.org,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] io_uring/register: add IORING_REGISTER_CLONE_FILES opcode
Date: Tue, 23 Jun 2026 22:18:01 +0530
Message-ID: <20260623164801.5680-1-harshal24.chavan@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <871pdyxrxw.fsf@mailhost.krisman.be>
References: <871pdyxrxw.fsf@mailhost.krisman.be>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,linuxfoundation.org,kernel.org,gmail.com,vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-13822-lists,io-uring=lfdr.de];
	FORGED_SENDER_FORWARDING(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:krisman@suse.de,m:axboe@kernel.dk,m:gregkh@linuxfoundation.org,m:gustavoars@kernel.org,m:harshal24.chavan@gmail.com,m:io-uring@vger.kernel.org,m:kees@kernel.org,m:linux-hardening@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:harshal24chavan@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[harshal24chavan@gmail.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[harshal24chavan@gmail.com,io-uring@vger.kernel.org];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 3B33D6B8E0B

Gabriel Krisman Bertazi @ 2026-06-22 20:04 UTC writes:

>Hello,
>
>Do you have the liburing side and test cases?
>
>A few comments inline.

Hello, 
Yes I will update the liburing side with helper function 
and add appropriate test cases.

>> +	/* clone file descriptors from another ring*/
>                                                ^ spacing

Fixed in v5

>> +	if (ctx->user != src_ctx->user || ctx->mm_account != src_ctx->mm_account)
>> +		return -EINVAL;
>
>I don't think it makes sense to check ->user here.  But is mm_account
>necessary either?  How could you get the src_ctx from another process?

Yes, Keeping this check would unnecessarily break valid use case like
Root user passing FDs to guest user

Removed it completely in v5, thanks for catching this!.


>> +	registered_src = (clone_arg.flags & IORING_REGISTER_SRC_REGISTERED) != 0;
>
>This is better written as
>
>registered_src = !!(clone_arg.flags & IORING_REGISTER_SRC_REGISTERED);

Understood, updated this in v5

>> +out:
>> +	if (src_ctx != ctx)
>> +		mutex_unlock(&src_ctx->uring_lock);
>
>Make the mutex_unlock unconditionally above the out label.  It is never
>locked in the error context.

Yes, moved the unlock statement before out without any conditions.

Thank you for the review.

Regards,
Harshal Chavan


