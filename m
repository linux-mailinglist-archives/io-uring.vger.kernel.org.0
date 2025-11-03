Return-Path: <io-uring+bounces-10341-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 420BAC2DFDA
	for <lists+io-uring@lfdr.de>; Mon, 03 Nov 2025 21:07:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 010AC3A5FF9
	for <lists+io-uring@lfdr.de>; Mon,  3 Nov 2025 20:07:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8652A72622;
	Mon,  3 Nov 2025 20:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kE+QAWeG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E77291C33
	for <io-uring@vger.kernel.org>; Mon,  3 Nov 2025 20:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762200446; cv=none; b=BVab7ZJNk2P2hLB/ecwGSd9sJisix1rqeMhA3pPykdrau8j1BdLmeIW2kr/igcHuyG1ixqTY97HzLqtgYgt5ma0GLp1gDe5IfXZ2hFCQc2C7NXCCnvkdYfe0NWu4tsPCrP/3CPbgdsRGUm5ED0Xm35WCta+h9WZb0EqGQZKf9cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762200446; c=relaxed/simple;
	bh=NBEn8mxcCFy5XE2p/jAy1j14JayKDlepQ2B2GEuOpN4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=IHiASiUAjNiGvY/0Fn0D2zI1AmQ3r7HW83ajaglW2C7sPNeONs+7raemWUiXj88ppKYkgq+uHkmXRHxSx23JwZWAYiBDM66o0/QNv8yT/m+CtNMLr5ljLpUZccj8bbswS0Wz1w9HgmZsKvCze6gHSHPt8cHKCNC59nwW2dTFZHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kE+QAWeG; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-43326c74911so8449195ab.2
        for <io-uring@vger.kernel.org>; Mon, 03 Nov 2025 12:07:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762200444; x=1762805244; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VSAZ9wp4LQ3zdWbO19uW0sqtvrrI+ZIztN8/muyD6hs=;
        b=kE+QAWeG7J6W0LESMYCigP/vP8cU9AreoeO1bPyZ1iNN0X2FPsQZ983QGdll/VP+FA
         wHsehYjZwPvZpqP5a8NRlyjpB04LXk1zLgDCnODj21W1NRbbTTSeBuKp0e+th+VDlVhV
         e3kkqK2lwGumMlLe3j0g8CuXxVMJPfpy8aL8RAx/Zk06+hEq5vpyUaRuuAvwtjHNPzw4
         LrLubfv6R1NXaze/N8wzJuRnEjigrVBoGv31VlmUouIUKySpEuAqQJcH1nCP0vSgQZ7z
         SDoxfCa5o95ZfwMSXjyWcTB+smmQ1TYF4UgfDUi1lzqVVTdXdpyQcEqMrJ6aR4PnFeL+
         PMPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762200444; x=1762805244;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VSAZ9wp4LQ3zdWbO19uW0sqtvrrI+ZIztN8/muyD6hs=;
        b=OQ7twKOm34yY9kvtJAA5dKl6X7J/iqycSEwxIcupTxsitN2i/kaf20qRMjEdh4o9sl
         HTKF27kjsfibv7+CpMAVIDHvtkLXJfLngcjua1sgcaMDulpzOYt8UNuLFgyli178i1B4
         P29yfy/6ix+2mTBEgm8GNm3Wij4JQB5iSvdgoxcXJIR91M200kl/GpzparNuLDF2nLiP
         eDcXWnAmmE3qCO0rojNRc7UAZ2pRf7SMpA97VxV3xruh3y2g6/10FU3EAgIlx0SG3JS1
         cA3/nmJE0lxOko2skYl4QkBFkZp9GnL4nnQ77pKQU5ILi0FSWi4B98sDL8TBxDsZOpVQ
         MXoQ==
X-Gm-Message-State: AOJu0Yz+W3jBkzRglEO9bQYqUw2xEYClLANuDQV6j2AokuNk+knzgmTP
	fZazQlZviVDjS08AxajROLCMLzkxBnd7DpKBqT9DnEi2cSbv78uY2p/Qryf5Lxz81+k=
X-Gm-Gg: ASbGncuip23NSQrqjo9Xrbf4m6tcVyo90WGtqon5OWF6rj+kXgejiKj3N7ze4LJ7y7y
	x3C1/MQVOmgYOedn8KldtngBNgvDRFdxu67eyv85diLmvR6Kd/cEDLkMzyciVpFaVlVQtF9QA1S
	VRhZD6rk60Ce5GTutNpLP7RdHiPpaFrVnKnQ+WVRMk+v9/qMc7u5w9jgXS16u1eRypxn8twDMoi
	m9nqKR+ZwgD+Cx69PbqJ2mCtMOvPrmmgTrXzMugJmsS7opdY/yaca+3CgeKleQpFhl4hhWxs9eR
	fWBoq1DB+p7/FtUwTtuK9EmC0Ik0ZP5ADRwyBv1ZCi+hK86Otevijg9BU2NbdsX9Hos1J5YwtZo
	3ZHANAEIdZZvWcBaIqDYdGrQN/UE+xecymhF5qcqXr3mILT7kXv8DWchCi9gSTg0KTX89p/0Vml
	1pvqRrI7Y7IjgY
X-Google-Smtp-Source: AGHT+IFepDq1c9YHwpgY47neWSa2Yv6qKASTLUT40TJcDgjYo0pyG4q62+mkr5pS+n1lX0BcN5b5ZQ==
X-Received: by 2002:a05:6e02:3109:b0:42f:94fd:318f with SMTP id e9e14a558f8ab-4330d137096mr203654965ab.9.1762200444106;
        Mon, 03 Nov 2025 12:07:24 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-43335a9ed58sm5341315ab.13.2025.11.03.12.07.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 12:07:23 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20251015172555.2797238-1-csander@purestorage.com>
References: <20251015172555.2797238-1-csander@purestorage.com>
Subject: Re: [PATCH] io_uring/memmap: return bool from
 io_mem_alloc_compound()
Message-Id: <176220044294.102668.3150096156004881564.b4-ty@kernel.dk>
Date: Mon, 03 Nov 2025 13:07:22 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Wed, 15 Oct 2025 11:25:54 -0600, Caleb Sander Mateos wrote:
> io_mem_alloc_compound() returns either ERR_PTR(-ENOMEM) or a virtual
> address for the allocated memory, but its caller just checks whether the
> result is an error. Return a bool success value instead.
> 
> 

Applied, thanks!

[1/1] io_uring/memmap: return bool from io_mem_alloc_compound()
      commit: 13bbfacf0e330f72875f93cdc709efd54abcfa8d

Best regards,
-- 
Jens Axboe




