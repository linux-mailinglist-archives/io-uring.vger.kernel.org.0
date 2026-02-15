Return-Path: <io-uring+bounces-12223-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CL/eEw9FkmlysgEAu9opvQ
	(envelope-from <io-uring+bounces-12223-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 23:13:35 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BF20613FE01
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 23:13:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8F39A300B555
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 22:13:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BB003054EE;
	Sun, 15 Feb 2026 22:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="H7Ttdt5O"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24162E9757
	for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 22:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771193611; cv=none; b=dlO0qnaBTsiArno1GGD5VAQiNY66L0Iaur1DA7nzMY2k1695fcVtCdtpSShFOp+R7usaqwqOrJMzZDo5GbivlRiBIR8qVwC9DyY7pgWluGay8OJaUm9DynH7KhlB9BMyUYxOn6FBR2yTfi29LXvpZlnirvjcov7bqeuRNQfi/Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771193611; c=relaxed/simple;
	bh=JV5bg6dtcuwULi9D+Ob2x53ntiI5WtlEHgFYHny45/A=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=A15GXn1Cv0W6NV4Y/TJRzaJlBzcPCzoo31lYB9y57nRktmugf3cw0pfWCEGpc1KnKLhJpev9NtodJVZsFFkyw59Cef4c1JAZ8S9yYzjmMr4loMuQYRAiDpf6zpDuehNKjYou5ZPNk3mxAdi0Ux6YiPOtiDnziMs/J9KSWFDzR5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=H7Ttdt5O; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-40ee486a76eso1659721fac.2
        for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 14:13:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771193609; x=1771798409; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZGXBJEhivoj2Ya/dWYeBjtjCw8frKbR42No6TwSrFo8=;
        b=H7Ttdt5OkrQ+x7B3TpMyQEFhRcTJTOe0rIis2ezmaoY87569UZKCd1qupy1Rw1upCT
         Hb6m6v2G5L4R7tIo41CkpKNtMn87LJZM0m5dDZ3FjyI0bYHo6wwK6u7qIsBDTLsNCj92
         4TY2wH3A0y7bUAEKqjgYE57J/3HhjlK/xstDtvn9UP/8RQSXeNLxCY81IL0upjrsc2LK
         1budK5p82WyU9vHFE5JhS2xH41DmK2glrUbNht/CyLzv9ngCAWhi0dFNdfLRL4K0UtkP
         P8OzNK0qAVbQaM+Pll03RmKOcJjZPbYvW2cJ71fZiRLgD3/wQ+4TMZCtKbmTWb2bVcZ7
         bC6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771193609; x=1771798409;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZGXBJEhivoj2Ya/dWYeBjtjCw8frKbR42No6TwSrFo8=;
        b=w8qaMCe4uZAzAU6aR9+jwn6yhz4/SiPVDysetKwcv3fhYC1i1AQleoJcnl2UabJgP8
         HoRVpqZvTxK1MTpuJFQ7r85YiE57hgDjZuGXESyUY9NtoZAIxsOEeezaMo3xM/6xqdsx
         oFxFpFACBzE3Tfg0ttrlENExOaqonXLV1qr9mnlQ19YPPlSs1q3yHxt5pcAzttCofCE5
         lYJrU8+I+dZCS2GE23wQx4v+jtzNHtmJobHcZTOJZPQUcL9AJ6VM5QU/CdGgvn//HBnF
         fszQ3cxnlsFfrgGi5/op/0TlKnzkhbVj2hT94D20kt4QdrXpjs4zPxYld5/Cq3kGQcW1
         awFA==
X-Gm-Message-State: AOJu0YzwS9JBmlyq4VFoHefBV+ooH5iQ5jentEfoXl3+ifCP1R4xzIXK
	2zSxyRtB5Kbt1J4JiDISSDZs9zdSVv09SPq2Zb2jecChuNUOZzney+Nru/wkRcdLJY0=
X-Gm-Gg: AZuq6aImdTInYhOMtmDZuj+7vjTTlvyNmB8iu4TEK5I2b1QNXEj/2JF9xzLScLgiDhb
	ibTCKfqeSRDgdY0VPm+cEXI6RMh5xE8l2tIueCadJSiBGk0q5ZWEc0GgGbYU/T4QIpLlhvteh8a
	c0vRHlD6PgAK0vT+o/sodUCgceT+nLMb2GMPCcjWQxRXrTZ2eNb+vHzV9fM55abWHIZXCQn6nVY
	zFLwI2nWO6Wik78In6f2pzK3LSMLN3i+W3Kv1LHTfR/ggiiJEefhK1D0XcCfFepve1eEtNQ3R+X
	fBb4xQsQww9w79ASXtjszo7p+XL4NTDpKF5uIkVQLb75eB9LkmdvG4XLN/1DI7KfhFJYrosaixI
	6bVNcxFKlnv6WNAsCoWxzozXhB3Qf5O2rybmMC2EY6hDH0rgmDWHugeu2538+yvjELmC82uzK1F
	3VGsRXCqyfYKYVK9HRI3Hd31sYvFT+oPY3dP2qgYyj5oLj5Rf484kyc+uL/PGMxVO9MSnQ9ck67
	46k
X-Received: by 2002:a05:6870:f206:b0:3ec:4067:3d1e with SMTP id 586e51a60fabf-40eeecd128emr5046729fac.40.1771193608553;
        Sun, 15 Feb 2026 14:13:28 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-40eaf178c1fsm13191922fac.17.2026.02.15.14.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Feb 2026 14:13:27 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org
In-Reply-To: <0e2e7c6211f2b40fb830f69f1084f0a3948bf2ee.1771190842.git.asml.silence@gmail.com>
References: <0e2e7c6211f2b40fb830f69f1084f0a3948bf2ee.1771190842.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/zcrx: check unsupported flags on import
Message-Id: <177119360722.79392.11343291238068825359.b4-ty@kernel.dk>
Date: Sun, 15 Feb 2026 15:13:27 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	TAGGED_FROM(0.00)[bounces-12223-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: BF20613FE01
X-Rspamd-Action: no action


On Sun, 15 Feb 2026 21:29:12 +0000, Pavel Begunkov wrote:
> The imoorted zcrx registration path checks for ZCRX_REG_IMPORT, as it
> should, but doesn't reject any unsupported flags. Fix that.
> 
> 

Applied, thanks!

[1/1] io_uring/zcrx: check unsupported flags on import
      commit: 7496e658a76a61758b20e27cea8abcfeafe3aec4

Best regards,
-- 
Jens Axboe




