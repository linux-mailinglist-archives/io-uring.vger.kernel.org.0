Return-Path: <io-uring+bounces-7301-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F8DAA7561C
	for <lists+io-uring@lfdr.de>; Sat, 29 Mar 2025 12:58:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 397F93B0B93
	for <lists+io-uring@lfdr.de>; Sat, 29 Mar 2025 11:57:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A92011C84C2;
	Sat, 29 Mar 2025 11:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="03Ykc7Wc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE40B1C5D61
	for <io-uring@vger.kernel.org>; Sat, 29 Mar 2025 11:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743249466; cv=none; b=eMpYN5EEkcmSRCDI+kDaLTO3fNhBz9/QhBVq7r4ndmynqRpDKFTpi1ZwrHDJH2cwxPD1E/uoLp8QNuGPz3dr/GCFGJVtkySMUv/DPZIggWVZSBGr31cF45p+UP3tu5v3xDLwXXizsFuD7enJls9sHtE1OExeUn9lE49ryM1COTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743249466; c=relaxed/simple;
	bh=BrKQRSYmo3KLwk1UhJBAvvUH0sb4nGJljQVMCIOEOUI=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=M4e4LJR6Mlh+/M4jKLelwSbPc6FRsYWCJATBskqTEMvRCiH/0/YPJIC6FScU1AVa6naXkCo5QCg2tQqrVqRD65G21bxKZ1yKuGkDgxi2kaux+H9bsG3MxXmmJAyeaPYhU+4eb6eDTB2tzVhr80qjCImyNidVNOdGzS2WV9r/AYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=03Ykc7Wc; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3ce87d31480so16150115ab.2
        for <io-uring@vger.kernel.org>; Sat, 29 Mar 2025 04:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743249463; x=1743854263; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=udULihXRB05YDz8NhWlbUb1y/iHETd0sbA2GL2hDkg8=;
        b=03Ykc7Wcgw/NOqsxlg6pJPRtX9zVrAhVRJ67Ss6201/LBZmOptIhnmUWU438/q4u6c
         H+rD9K09RgCJ5LtZ8NB+hazcMpgI5AOQeU+vFHTWFbs9qeLWY/JGZAtmlhvgnxa8dfEC
         q3LC57JTyZzOCUQ50Nkls4EwVmFjuBCdfb+LwpOrCbc8cawLwra0jWhYxfbrWetLlGWW
         oHaoec9YOj13anGCHtcpatqsqfvHAP5ESsTsd43r2Z6lTpXyaPquB6hlZeiffCTiSbyo
         0lk2DgZgzmNMOKgp2aU27we58pLY+QAtamtTf2UNrEI9vIfpvSSxLqfDAiQ2dxHx1+OF
         q9BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743249463; x=1743854263;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=udULihXRB05YDz8NhWlbUb1y/iHETd0sbA2GL2hDkg8=;
        b=Re5irjb+tZMB7sddOWg3Scjm7CLrorv2p8OoEvEM868JGTcvpgXvfb/hj/AczBehjx
         GS9HHZtXzQpHuJWUVVlnSadIc0ak8gNu5+Ep3G0AGWWDzYnVP58rnR3Tj4+Zlhj1dR6j
         XLPE0Zgm03bOINyD+RNarQZhRmVKPAE2+yuPPcOT12HwxPeUJ5wSdDubsUKf59VGGa6A
         KyCqkn1Z79G259jhhFAx/cCAXT2hNETYUyadHhkbo39qbt7HjvYCCCmBi7Njql+a6Z+F
         39nuAwyb1mD0i/GG9D4Phfs7Ujixi9Z53l/wdTIt4MLVPByGWF9ApYrSGWnc/5sXOGUS
         U5Vg==
X-Gm-Message-State: AOJu0Ywq0BhYUJSV3VNtw0LqFw8+Nt1Lur6uU7uRAkAmlDfv8MZSyo51
	K4ZE1+j8wAGFhTy9eqQWAcwM8FwkQH5hUUjfsrLTP5XcWCnLVSYFzYNv6i6+NFjoGFDju1R38lx
	1
X-Gm-Gg: ASbGncso8T/qO2W31bC7DPwI7WNm9ppvqVeU3weLXV2b3ZQLIFlDI3m3vrRdlO9gel0
	f9P/vSPb2VELiTiC/i1nnYAwZiDH0Z53237TmHoXBNFC/HvxS/kiEyW7cveWzVCXoqVKj+q8yvO
	3tqF/cejj1oF1V16jhtSNo1ulB5Wb3U+jKdLef1oO/UGxIdNSfZpMx+d1a6PvZ2n7DsZFTt7Rkc
	a31nyEaUEBym7fKDbI1sS9VoMv2w07a1+Gir99fsuPSffqlF2hPfGFb8xji9RHXmvetbjDlbvym
	SkwJ+hxIDjXvItvjSiEwScj73UY7qvH3TpnB
X-Google-Smtp-Source: AGHT+IESX6lOdyDsK/AZ6XN6CPdImIWvLPgBR9mT9ZQOiWKdrhmYVQZ7jk3qkuNEq7iDq+C80MSKjw==
X-Received: by 2002:a05:6e02:2144:b0:3d3:faad:7c6f with SMTP id e9e14a558f8ab-3d5e08eb16cmr25793275ab.5.1743249463486;
        Sat, 29 Mar 2025 04:57:43 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d5d5a6345esm9616765ab.1.2025.03.29.04.57.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Mar 2025 04:57:41 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1743190078.git.asml.silence@gmail.com>
References: <cover.1743190078.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/3] msg-ring clean ups
Message-Id: <174324946151.1614213.13391206827276555334.b4-ty@kernel.dk>
Date: Sat, 29 Mar 2025 05:57:41 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Fri, 28 Mar 2025 23:11:48 +0000, Pavel Begunkov wrote:
> Random cleanups I've got for msg_ring while doing some other feature.
> The confusion from Patch 1 reminded about itself the hard way.
> 
> Pavel Begunkov (3):
>   io_uring/msg: rename io_double_lock_ctx()
>   io_uring/msg: initialise msg request opcode
>   io_uring: don't pass ctx to tw add remote helper
> 
> [...]

Applied, thanks!

[1/3] io_uring/msg: rename io_double_lock_ctx()
      commit: b0e9570a6b19fb0e53090489838dc0de27795eb9
[2/3] io_uring/msg: initialise msg request opcode
      commit: 9cc0bbdaba2a66ad90bc6ce45163b7745baffe98
[3/3] io_uring: don't pass ctx to tw add remote helper
      commit: ea9106786e264483312b9b270fca1b506223338d

Best regards,
-- 
Jens Axboe




