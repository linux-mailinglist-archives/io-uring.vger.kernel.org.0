Return-Path: <io-uring+bounces-7586-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 26B4BA94B16
	for <lists+io-uring@lfdr.de>; Mon, 21 Apr 2025 04:38:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 12E421887912
	for <lists+io-uring@lfdr.de>; Mon, 21 Apr 2025 02:38:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5038F17BEBF;
	Mon, 21 Apr 2025 02:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JsKiZD6a"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9009C1ADC93
	for <io-uring@vger.kernel.org>; Mon, 21 Apr 2025 02:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745203117; cv=none; b=DfFsR8YN+Jhl9D6aAQ98lbP5ugnygbRDXRZPqK5yFnBFC5AJOUzVdYl4MjGJEO27IeztoS3wzzvBc4w1+m7WGKPidtTcpLX2QVvqqvsGYFeMFtM2unoYYtrCI8ApkdYeSldJaljYGjty3S/Ehf6gzrUYah//WffuSI5lqG+WrF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745203117; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fwZYdtmx+NttD1djra8NJpMSh8/944cZe2+UAqkFObPIwzyZtO+5DiWZji5thZZ67EPyP/vb6djjzUba2WSEaHAA8fnZI4kpQndT/gC6XHc4am+B0XB0uwE+muDsjW4mVzeEcZ5cQYOFipT4jA+u10+ck/wHKhTh+Prj+uDKN8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JsKiZD6a; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-aaf0f1adef8so646360566b.3
        for <io-uring@vger.kernel.org>; Sun, 20 Apr 2025 19:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745203114; x=1745807914; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=JsKiZD6au2YY10gJOQ2rYwXcevuZlfPvQIFXJCUZUMfeahWFhptQUNtECP0PnkrWK/
         CF0q/AX3+//WLH/nnM1FQxaCDdqCHgCRH/1dQBUOxFjVtBI5twfEcmHZ13r+9o0ikuec
         Qm+GWqqOOZFuAzIUPf2yFHQ+fEPMWpMifMmhtDxpRgdfFnu+CNIb/rjdqdpoJGxu38Zh
         gRpufbazxeGntjlgBp7A5ZeeBytLfEvNXFIJPyTseYzD6laxzuE2sCmCh5oJZQIl3+TC
         XUy5TzodSand4Rj5ZId0v8DCVZvu7bSulQtea+V98EdpBLAaqnlkAGDx8Av+vEvlm7yW
         W5WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745203114; x=1745807914;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=wf+y1fzF8dUtrI2WWPqMcRJVPlr2aJ+caeeUF3IO/QytHbPdBkjZfTJfLxcTVKWnI9
         09vaYGeO2PVMwdWE4AoGSYGKJpR7dFn5b6aGH8IUODD+kIkmwBEaZySkJzaekK+NOF6a
         g3LyJvTsXJUFv3R6MSaREIfD7A9QDrkbTSOINz1C+BfhgJWxV+ULMFjVZVQ3fSSZALDZ
         l9oLCszkimoRIW36moDheXjpmpoIHEZ6sHhX87W6n5TTC/KeCGKg9VFPklteTAOK/tg7
         dnolX08E0wtrwvQnmfaYC6oB+Z3e8DtlrkATWrg8UlxgGSAho+8V1Trjh80hP4k25H3J
         GBKA==
X-Gm-Message-State: AOJu0YwuxaDC3B2A8viXouREFc2JKWuYHDF0Qs3IfPiyCOxJKnaHieY0
	WRc0p63+Cn2KOcqNx46tnH+q5Jfah9dRMfBIt3+33mIEKj+XvfqgMwsGK9nTfOC55hhVQeGTlOT
	o1uCWhV9xK/W7VAVCpH89Y/qbhP6WSMo=
X-Gm-Gg: ASbGnctrYuAgO2o6a4PHXlpIuALbJ80IKYUtzXIU4etw5MSqHQNZLBATLnKAPBo7dPB
	w8PL+2/94dreVnb89qEnH8CMOX6DDY8wD+u1TLu8DGN31kC2Mcvbpy1q9iz9fJiwCUfNr2fqev9
	M3XCnF21SV8/Lhr6ypVCC68YfvPnI7WTmSZ//oNFviEnRZdq2MJu1m
X-Google-Smtp-Source: AGHT+IGvkTvrWB7YtLtLqKrwuCiXkTi71/UyY91wY9Co/5n8MGIx6SeawUVfv0LUEc7uk7R7rhXgmqGQJEXl1JZzpGw=
X-Received: by 2002:a17:907:6e8c:b0:ac6:b639:5a1c with SMTP id
 a640c23a62f3a-acb74b5089emr746771266b.22.1745203113608; Sun, 20 Apr 2025
 19:38:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1745083025.git.asml.silence@gmail.com> <e0b2be8f9ea68f6b351ec3bb046f04f437f68491.1745083025.git.asml.silence@gmail.com>
In-Reply-To: <e0b2be8f9ea68f6b351ec3bb046f04f437f68491.1745083025.git.asml.silence@gmail.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Mon, 21 Apr 2025 08:07:56 +0530
X-Gm-Features: ATxdqUEOJBr4UJ9IGOT0C8XOLWtyqwMfLYQ_mXAtzCDMWNZZ_UpSclDGIbR0KTE
Message-ID: <CACzX3AsJczSePwNYPboDUdAoMObnhDK3DVY_9pSYD2t+=jpsjQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] io_uring/rsrc: use unpin_user_folio
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>

