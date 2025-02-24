Return-Path: <io-uring+bounces-6672-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 953DEA42086
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 14:27:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 558C21731D8
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 13:24:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3617A1B041E;
	Mon, 24 Feb 2025 13:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JB2iYc5K"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E02423BD1C
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 13:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740403441; cv=none; b=g3EYbLTkMaIC4N7ZhO+nOGRkr6L5gwRVSgwVsQVFX+mfzNNddLuYF7YMP7Wy5LDQgN6ZP9mtwLV9Hz70MD25UXtQDkpMxg0OVjmqmc4UlZRi7nGjMOekbLq6eZ3k91P50nDqhabHosySyexMfYrItE2dbfwSDNoVw52Iac6CNHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740403441; c=relaxed/simple;
	bh=O/Pd0MtD0eJiwbPuzLhvxnxopeoCFeBWmTgyugx7VjQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cQHKzByvXnU+VIeWJSG6IHK/hKt0IlCY2Rx02AMdihqoqJnNvRooEb8/VUsDuB1m0915PFsuRsoHL9os5Fvus3kdPZuE4Kt+fNi3yC2Jz1F8hm1/iYlPuHd4PqwVAGDn/kpfXjFWeuGkVyaCMcxqpMx+RGe3DIw6uHOTs0FzG0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JB2iYc5K; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5e04cb346eeso7317360a12.2
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 05:23:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740403438; x=1741008238; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O/Pd0MtD0eJiwbPuzLhvxnxopeoCFeBWmTgyugx7VjQ=;
        b=JB2iYc5KbxqFC/9lnVtESTaDjPip89XqD1ObLhbgrbAGhx3qy91ErOX3zXVyTy99wn
         Z81hqpAXXKL4yQ42VRgX+DDUE/T2t4FnfUOyUUtUf5VpsvXdGNmQpsMYuF0+LHKqv8ue
         EiCgFMlrWDT/yP+zMr+oE5mEsaXuiDKQX74/XOeUlJTtMF232f+D8UoFR+BJUoFs56p6
         eQJIY5KqCDz+E/yhk7vLNh0TIJDJ2I1oeQ+6IPiqYo5YMTQ1lJAFNFhIefYRls5FCZCt
         bHFJgto/KFT5P8yyR2dQtSB/xTpmi8HYYkZTB3t0nVAdtjS9VbBj3S27SIgNP9TOYMu4
         QBfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740403438; x=1741008238;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O/Pd0MtD0eJiwbPuzLhvxnxopeoCFeBWmTgyugx7VjQ=;
        b=Nev/kZYBbCX9lIjPSXUXGSxkWWL40QMKCjZfzR2L0LtVRG2Cs9hIFQvQCpLR0MSkZm
         hcuDmayQvo3mXdoFjohTmIJfDPmOZhSAUIU9DY5y4o3ydCoEMr0VpvOCVsV/+tfNxY/0
         y9Kxa1kHI8SHMhnhUbvTu7/s1gN1SI8QAd7dQ+tuPf8LGMlapwpPtPfxQQUOVvkVP5Lc
         w3hp7fQ7Hc7ncwoL0LHXcr6NyhVSVT6egTPWUlfRi+OEMkpTxvCS6OJUTwXR7pJE/wC1
         2m/mlSnYMK1qiCFpEoFIneYg4HhO1M1f2sbv+QqmQwgM900yOiXVD/ajxxerPJMuNj7G
         HPTQ==
X-Gm-Message-State: AOJu0Yzo4VjajSu3ggEk3+M+bnhhtRo3sgh5i5NKDeCc8kUCcDW+jj3/
	OJ4Tybg+JKya+zNIlKt9w6/T9yiCIqWWUCNTdI98N+6W4uNThgYpBkMXeGVgQYYvvIJh/KOgblR
	prRF0p+43//l6UCXMFKu5UL85vdDtVNY=
X-Gm-Gg: ASbGnctZlE1/yZiliAJx5DoNKmaVODliVU20LnH3z+F0Jx0LD5csi/A+PWDipHMflyW
	5Deg1q+dcUTPKlWGLfNnUx33ol9HksWhbmQcQnXQlzJen7qYCgkUjBIeTxSw09lojEaVCXVvxXq
	3FHK4MH+I=
X-Google-Smtp-Source: AGHT+IF9l78F6vidySSAOfsFNPrpD6yf5C1OIcm0w/z6QHs3OQdwTf3dfLpYcy7e1sEKDu2pYOpfdvBoAQ7uux8hbKY=
X-Received: by 2002:a05:6402:520e:b0:5db:f5e9:6745 with SMTP id
 4fb4d7f45d1cf-5e0b6fd7696mr14284793a12.0.1740403436188; Mon, 24 Feb 2025
 05:23:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1740400452.git.asml.silence@gmail.com> <28c5b5f1f1bf7f4d18869dafe6e4147ce1bbf0f5.1740400452.git.asml.silence@gmail.com>
In-Reply-To: <28c5b5f1f1bf7f4d18869dafe6e4147ce1bbf0f5.1740400452.git.asml.silence@gmail.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Mon, 24 Feb 2025 18:53:19 +0530
X-Gm-Features: AWEUYZm9d6-7hDPIUfWTqDR7Nc7zispoZs6aSoCu4wO-Kzgd127QtJXW2JOl39g
Message-ID: <CACzX3Auh2A14jFzE8pUboK3etqHegntTCK47YoSFtx2x5nWkFA@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] io_uring/waitid: use io_is_compat()
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"

Looks good:
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>

