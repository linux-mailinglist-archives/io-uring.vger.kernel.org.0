Return-Path: <io-uring+bounces-12365-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MLIcC7panGmzEgQAu9opvQ
	(envelope-from <io-uring+bounces-12365-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 14:48:42 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 976171773F8
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 14:48:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 88DBC306A3A9
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 13:47:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ACC626ED37;
	Mon, 23 Feb 2026 13:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Ej9nTyvM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5BD24DD15
	for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 13:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771854442; cv=none; b=QNXh1+50R7F53Kk7kyBnQChOuAl5pJ0MZsnJS4W4Drj5h/JQ7Wl/R2uRNOG3Pb+k3ORpQYvIXvr7kN42D9RD5hhLA6YdgaMIGNXDMh+G9On5wnU4z6d+FzB8UIliWILjv1Rlw92chv2TEl18uIUAJ6P4xWZWsHRpr2H1zCFGDnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771854442; c=relaxed/simple;
	bh=9w+SjGw6n4t29t08fv4rkwYt66K61EqhDXjmeXFpd/g=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=CGFr2oZX4CfXJZ1bR7b1zqolYU6irX0nGdxh0KfUE545EQTnFp6EwSqJ5W2ngojGmgpe03rcTK15ypJ6OOTkTSh2mzCeN9uZ8bMWi6nvnHfAaE88NIjEXYBkpeEJs2PTS5qzR7Lk/xdsfZN5W6RIi4QF+AGbMvK4OKYTpyDHxPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Ej9nTyvM; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7d4c383f2fcso3761177a34.0
        for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 05:47:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771854440; x=1772459240; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xU3SfDvX7n0CH4qpAqG10f1VSdcLt50DI5AjNEC7anw=;
        b=Ej9nTyvMtoArdk+0MMfxny1wod6hSIAs1DvvQtTp2OlV+FmrH9nPVCWu2jDCQXdbLA
         OLoxNCwU6PCDDDQdPO3XRdFabXfZB0QP3ryXLPoDtTjXHVlX38Xk7qAqz52Xy/2NUHxM
         8D+5sVTrZqmZcSa+PSjiACCPLW/ZhMU8XZfjM5c+aj58kx+YBMh2+vnm3EcM7gfzuhDQ
         cN0OGH2zJi6ZpspkxKFfGyK/gAaSTz+KAvNABFrj5TKD0S7CJD26MBjB9ObXqxahHwIm
         4wSW324kNRMOm9h9dkwmlgc4ifDk/vIxwbQQGtbpAuy36cIL42WZGLgcTd2GNoRKFgV3
         0D/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771854440; x=1772459240;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xU3SfDvX7n0CH4qpAqG10f1VSdcLt50DI5AjNEC7anw=;
        b=XOSzGUqS92m+TXm06/pghtBcPNRrzkNZkwgNJJg9ncD6cK/jbpBooExyaymxNA4fW3
         TaYR+FHCGY5ddOsGTIkWcklJUyBHp2AX7Xt/O4FvEcFHE2+RGpNTq3m8Qbct254loXSU
         6KsZUmZ5qufgMAWhgOzrtPZzzt8dXq4YLfpQXCK2m2W4tSscuHc7k+LJXNl2akcQUZQr
         4jBWtw2Y5kMCswVZOMTHVpG8vaRvCdLuXPqWLzMczkKtYGRrkbs+N1Utk+9x5qR8bqZ9
         ffCZCdV2lC8ehgFzNT4D2fySPBEppK+8X1Xr51NAhT0IVHFImV4nM/304Vc7mQuvv/iB
         M//w==
X-Gm-Message-State: AOJu0Yx4VNMQXyWNwljF5/1Kmf1E0KhNYuOvucFXe3DZ+9K+edx7jsd0
	D+ulIHbtfM5vuly6SNr2WNtm+AXX70H4gG/QCZgH09kQHX5xK2IsYJezMh7S4EOm19w=
X-Gm-Gg: AZuq6aJkidHRrDghaQGu+njVZQwwdTWdidgA9y4dZtEhR1/ftOr/epGdBV5q3mZKlD6
	0hBgo0n3lVKmqgSv2SqAgBKNzrrMNtCpWAVNQS27vMo+N60T+YY1GEGUeNV2LYQrIcmK9Qmi5oU
	0Ka4tOLcd+CujJrX/U5b89olqSxfZOljqkQBMoD5KtitxbRpqc9c74U1Ilvfqsl/DgJuUN44XNT
	9W6Fe4hxtJt/HYt2/2p2gOucTz0GFT6rVHPUunDv6KN/3efSdHZHtt0HwJZkmSMIxZiQfG1t53i
	K+aRVJ5fbqS9bAy184ce6ZBQd6w0zfc4dhg/tHpX7mcIlhyIF1R3Wkwhwi99OmG+c7FBHzfYhzL
	edz+qRRlJ4te9G5r5mlwiDYOA+/FBWPaX4zA8jpzu1/bg78WtfWrE3jnf5aKpV/qLLf+U4Kh0/Y
	IS8BaXi/JIF/Y/NnheKmKYjhry3UP+ZqWAwNnwpn9VDMCvTZiOoxN+3NQlQrqKbBs+Vsiln7ueg
	S5O
X-Received: by 2002:a05:6830:61c3:b0:7cf:d201:c32d with SMTP id 46e09a7af769-7d52bdf76b3mr4727680a34.3.1771854439829;
        Mon, 23 Feb 2026 05:47:19 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d52d04dadesm7246370a34.23.2026.02.23.05.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 05:47:19 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org
In-Reply-To: <b68ff77af39422191154413f262717a08dfc9e04.1771197486.git.asml.silence@gmail.com>
References: <b68ff77af39422191154413f262717a08dfc9e04.1771197486.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/zcrx: declare some constants for query
Message-Id: <177185443873.636584.937001806515054998.b4-ty@kernel.dk>
Date: Mon, 23 Feb 2026 06:47:18 -0700
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
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12365-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	NEURAL_HAM(-0.00)[-0.997];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim,kernel.dk:mid]
X-Rspamd-Queue-Id: 976171773F8
X-Rspamd-Action: no action


On Sun, 15 Feb 2026 23:29:39 +0000, Pavel Begunkov wrote:
> Add constants for zcrx features and supported registration flags that
> can be reused by the query code. I was going to add another registration
> flag, and this patch helps to avoid duplication and keeps changes
> specific to zcrx files.
> 
> 

Applied, thanks!

[1/1] io_uring/zcrx: declare some constants for query
      commit: d4d8bf4122f291571f576da7bae158d1150e5c9d

Best regards,
-- 
Jens Axboe




