Return-Path: <io-uring+bounces-12876-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cCsrG2BtxmmkJwUAu9opvQ
	(envelope-from <io-uring+bounces-12876-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Mar 2026 12:43:28 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D2D7C343A75
	for <lists+io-uring@lfdr.de>; Fri, 27 Mar 2026 12:43:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3DE5A312B63D
	for <lists+io-uring@lfdr.de>; Fri, 27 Mar 2026 11:38:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83D6537267C;
	Fri, 27 Mar 2026 11:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Kj2y2SQF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B6031A56C
	for <io-uring@vger.kernel.org>; Fri, 27 Mar 2026 11:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774611498; cv=none; b=InTMAb55zgxN+aL8TvfoNGKhGY2ZheYGlayh2PlIcH8j6t9Te9GoMK6RvjCor9mZeIMdKnxtqdZ6tRd0y4MM8Uiy0enRWpRO2yK0AFKgr4aF0CkZO3jynWyUXTnaCAOld6LwzgDfonct+sy6MoneM9hMxUoD6D+X0GXZqJlFt78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774611498; c=relaxed/simple;
	bh=1cbDYIOY1EYSH+Q8KJA+D6F5PV9QM5Zck6T9APZk6ZU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=DAXxtkAJ6NLZG4Bb1JtdSgBxSvvT7aLEYZBN4dJsz+eW9ejhIh0rr+msQiGtEyX6PQedOlH61IRnRd+ugLgsfpXYvx2o2Lw00cIB5Foe10NXpACldyRpEhL1EeaDKQlknZcTQtZ/uGc+dxE8LJ8aAqVWODUHanDDoidHS0g0tKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Kj2y2SQF; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-404254ffe8aso1182935fac.0
        for <io-uring@vger.kernel.org>; Fri, 27 Mar 2026 04:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1774611494; x=1775216294; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ELwgikS6hb7zBj4EsEUBt2n5j7H2KX04fYfhxEEp3Og=;
        b=Kj2y2SQFSPALyAl/N3A9Ix4uPAfTojZ2ronM6iZGRjI8zTOY5foDvRCXfSBVKaFGa9
         tAOE93ZBowlvLMiDWQ5a3vT6rMcBcVapv/mu5DStVpgSJqESPw6dRw+PlAwRj2cj1cPm
         nZkjl2qJ5UGULGS4HuxpvHyX6txGywihub5EaMzMD/gZXLVULZLRltt9vgW5tpD/wvaD
         0RP+RzWH1SEsAK1YyPVXrSXSrmy3L8FlbTyq3ks4oLSVsON7j1Jup+ILjZ7JwJXcdjRK
         NRqkxKLO4ca4hGWTBNA1eizKRRQwUhijyzaUE0kP606JfYS9mG5w4DFrEo+ZlDK1kaXW
         6BLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774611494; x=1775216294;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ELwgikS6hb7zBj4EsEUBt2n5j7H2KX04fYfhxEEp3Og=;
        b=gPVj03TdlGlG1fhuQtak/hQCZRUL1ZEQFqK+1obZMhTW2YumtzFKY7jL6LIbVk3y8v
         v/UJn+ZwtImL4UW8CvHBCs3GOWgxHt6a0c+po5FNpLg1EMaDdDzGs3Teb7AQQ4Le6hGI
         bmJKb1PsB8p4pT4KG7oArUyWbVLOm0tGVodbrxBip1Bg1ecu0rZbEadxjf8Re1afFyy7
         mwokPl4kY2FF7mtw8ESYah2lYMTswT3H4OkxABbmHHVN2r9XT48Ex9ZJA1W+BUU1a/76
         ouWhPXvn6vmZPXRaTm1fIdwznzfDaaiPiToNJLuR0CIQkbPTcwujwAN6Z0y9EsywWeO7
         wfKQ==
X-Gm-Message-State: AOJu0Ywd1AnqRo2kib9WZ6xLrNm+xzqf0eN+V0L596Cy/iNAFCi97N7p
	Fz+Q3HTFGhIqujGXAVV7kNg4tHSagZmroptkR+wMQIO07RLuHskVv/myGYRpoReStrWdc4Uuw+Y
	AxjEu
X-Gm-Gg: ATEYQzy7clc0Xf9oDJ4MakzOM7GcXvU82Cu8P435r+cBfyZb7QPbS0g5DWp/t7uGAbn
	uhwrrcZwbzlDwJUmsp22WM8j/syt4IZ9tkTt08NgyMXDWho2VPw1EbaopZeGt/UjonxF8To/vfL
	0GSTT29lOUE2G6boHN2ULI6ITBku7qBYk+jGrfPYoN3mwBlI5PdtgV0eEbzlFcd6fYqmURPqaLi
	vk3N0gxDAlEtsFX+l48wwf/LoL5DXZqOM1vME/+yNuCpzh2wwqr1kVvhOh7ogHO8b8PBsRjAdAb
	MfbVA3a0Oxpn5lDbkdYKmeynFHCRJZbfhQb/I5T/U7WQFyFLBU6yQQRg7kAvYTcK4uUUN4ZPkNk
	KsOrK4gVlB3HulDik7wYaf895kAATK6fiSz36RvgSU5BH9J2oh2kz8IeQCzXlpuRwFhI4H8dV+n
	cubOEz1+5fakBCvK9rWI+XUjN/GVHqbDL1TO7rx4GjRX/8Xs1W1a7FWRWetgxxsJ4OQeQTbjawI
	kOk
X-Received: by 2002:a05:6871:4048:b0:417:3689:a380 with SMTP id 586e51a60fabf-41cd7cf8b4emr2430689fac.16.1774611493819;
        Fri, 27 Mar 2026 04:38:13 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41cc7b49aadsm4156549fac.13.2026.03.27.04.38.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 04:38:13 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, nicholas@carlini.com
Cc: Keith Busch <kbusch@kernel.org>
In-Reply-To: <20260327021823.3138396-1-nicholas@carlini.com>
References: <20260327021823.3138396-1-nicholas@carlini.com>
Subject: Re: [PATCH] io_uring/fdinfo: fix OOB read in SQE_MIXED wrap check
Message-Id: <177461149247.257144.11021832307527401699.b4-ty@b4>
Date: Fri, 27 Mar 2026 05:38:12 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.1
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	TAGGED_FROM(0.00)[bounces-12876-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D2D7C343A75
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr


On Fri, 27 Mar 2026 02:18:23 +0000, nicholas@carlini.com wrote:
> __io_uring_show_fdinfo() iterates over pending SQEs and, for 128-byte
> SQEs on an IORING_SETUP_SQE_MIXED ring, needs to detect when the second
> half of the SQE would be past the end of the sq_sqes array. The current
> check tests (++sq_head & sq_mask) == 0, but sq_head is only incremented
> when a 128-byte SQE is encountered, not on every iteration. The actual
> array index is sq_idx = (i + sq_head) & sq_mask, which can be sq_mask
> (the last slot) while the wrap check passes.
> 
> [...]

Applied, thanks!

[1/1] io_uring/fdinfo: fix OOB read in SQE_MIXED wrap check
      commit: 5170efd9c344c68a8075dcb8ed38d3f8a60e7ed4

Best regards,
-- 
Jens Axboe




