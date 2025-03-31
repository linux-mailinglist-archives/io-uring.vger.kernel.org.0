Return-Path: <io-uring+bounces-7324-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 58761A76D46
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 21:07:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 80884188A210
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 19:07:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 980EB21A443;
	Mon, 31 Mar 2025 19:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Y10JY1jJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1226921A420
	for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 19:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743448000; cv=none; b=Tmyp6YhO/NcQFokBfznL3xcuiFKjG/CBzUsqZdi2K40pIHvKLGN2VdOZrzvsqzviCf3C9o84uS2SfPnfCaoZ+rg7oXnbsIypgmuzKjjVTmK8kzHjT9iIpqOEpkBYtCgqIllAmPjkEoGi4YM/14jfdSJmC7b63I5leNvI6UBtBBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743448000; c=relaxed/simple;
	bh=XXg2nsrHOEEVQvhianBWazdd/TiXULgI4tf2oqP5+WQ=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=g1tT+ruADaT1KIrzkd10QVmNgsqWAMhN8Vzyakqg+6GGa0TscJQMZX746YijkKtTTjVFIp1fEVIuMM4AiVCyDp5m1LIijkprbbnWiB6bAeuU5tC9cSxUavtuLwyO/4ygYQGc/JRUf16SlCQWwzmz3BWEQEfcEG8krzDL/0qX5F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Y10JY1jJ; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-85e15dc8035so106532839f.0
        for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 12:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743447997; x=1744052797; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aHkehgjdRdBzPhHwu/Ai6lnkZTGGmF7OmzkCZD9R8Fw=;
        b=Y10JY1jJo3TL3YWzSYnh5ouAASFPjZINipPGl4++XQ9au4O2iZWofGK4/YqzUSAaoF
         mt6NJnTWYikBvS6eBIfiFPbPJ4b7M76r8Tx1cAcZOR74bg/d+EvN/8SYQSn8czsHAFYX
         q6EjuELhdHlgegh+7mY4TBFsTIi6dGKpGvP1BocIia+bCalLFDZh+dHjYhe9rFOofrfX
         mKVPbPWIndaRIw8boAuk1vEFVZvekd/ujBanwlESMMybUzlCqh/a9/+CkhOUMOBzbWn6
         GsxMPP0avRbvFZhl9415lq11g2B5OPnLtorQZVA0g+T2AmFGoWCx/f92nOK2b+74Qm6C
         HNsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743447997; x=1744052797;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aHkehgjdRdBzPhHwu/Ai6lnkZTGGmF7OmzkCZD9R8Fw=;
        b=wQIpEPWYOiEiA2X+rxsF050vBP++vRq+ar1HGs2wdoKCcaKYtgGPHdOaLYLq1GDSXo
         YW1oDtIIgsuPjFtRGgRbq8M6V4+ZLKw9jpkHBADRjYdJ87Dk+tvukiTq6Bj/Rp1LTD3y
         kqL/K1PqsRvVpC0viu6bDL2vuRTXr4txS9lGz3NKj6ZC/HXiuJekAL0Rk+bMHW/uOBMV
         96foxdSC5Ue4R3+4oxcxaq//eRkFik/mMkl/UL9kkPmGwMf5UmtlZfj5vzFtLhlomWar
         G0Z/M0UDRMtQvl+Eh2FaUKm/ajdYoQQ4eET46YTwZBMoe+X19dzEHYfDfAK3A/yBjHiu
         eluQ==
X-Gm-Message-State: AOJu0YyS4utkU1+KL/uRYJRsxVvJobgAcaayYjnHEkVcsGhpDWp6vNp1
	TD/QVdacpl6WQajKH3DUlaN/xmu28Pa4WYBMffiDH+Nvnu9m6sSbDe/+Yt05WcTV+//Vt0ct3pn
	6
X-Gm-Gg: ASbGnctN6jEdwULDzvmYN5AHQxt3AkWLdh9F6GtQxM5nMV1/kE4rUi6BpWW+SzFefam
	ZQtCKuQDsv43WlUcvVmN+uAEnuutvrHlp3N7mlN9S4D3gb4og3Ozi1pwWMe8fPyju4h26Vdq7EN
	6um97ycyLI0TwUrL/XhbVLH/shrF0b53J77JzLHYYqElyR5O9QPjhRnF5Zyb0SssG5Hw+WdB6r+
	BW15yPNqXd+AUcGYiyLh3EVL+SuVB9Ya8kHJkYQtN993DfafQcPEm39U1+KC4DAPPf6I6l3rHBa
	JkkBCj+uygWYM78XfLHJvqOZKHmoIOSEs8S9
X-Google-Smtp-Source: AGHT+IHSvkiPpBzZtP++qgBw1nnagWrDfkLkWQ5j2oIfxuYi/+pWuekWPPCwInk8eIpkWtcTHceM7Q==
X-Received: by 2002:a05:6602:c87:b0:85b:4941:3fe2 with SMTP id ca18e2360f4ac-85e9e873470mr994127639f.7.1743447997656;
        Mon, 31 Mar 2025 12:06:37 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f46487193dsm1995145173.79.2025.03.31.12.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 12:06:36 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <f9c2c75ec4d356a0c61289073f68d98e8a9db190.1743446271.git.asml.silence@gmail.com>
References: <f9c2c75ec4d356a0c61289073f68d98e8a9db190.1743446271.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/rsrc: check size when importing reg
 buffer
Message-Id: <174344799657.1769197.6450412362128698617.b4-ty@kernel.dk>
Date: Mon, 31 Mar 2025 13:06:36 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Mon, 31 Mar 2025 19:40:21 +0100, Pavel Begunkov wrote:
> We're relying on callers to verify the IO size, do it inside of
> io_import_fixed() instead. It's safer, easier to deal with, and more
> consistent as now it's done close to the iter init site.
> 
> 

Applied, thanks!

[1/1] io_uring/rsrc: check size when importing reg buffer
      commit: a1fbe0a12178a006b04a7fa528457f9901d6c6d0

Best regards,
-- 
Jens Axboe




