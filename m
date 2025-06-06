Return-Path: <io-uring+bounces-8261-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB767AD0791
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 19:37:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 458717A4E99
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 17:36:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37DBC289819;
	Fri,  6 Jun 2025 17:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="W2Njs83e"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926391DFD9A
	for <io-uring@vger.kernel.org>; Fri,  6 Jun 2025 17:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749231443; cv=none; b=WUkpnzgrm8psdr3q3SiFu7RvW978dZLPaPx6yQnnlRERNyV20GxaCYE3X+l4nAvou8mKGgl41isACiwRlSsFXo8Qw6nvBhto6mamOSfUmwX0UrYoCSpsExfDhHOPgLUZj2n3R4zaH91BFjIP2FImBWEwSPs60GRKI/VlK+lGPiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749231443; c=relaxed/simple;
	bh=+L+8Cm7Wah/hWtY+XTFfTzbZh3uMQwc3wqvclz4CuXw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bMa2HrLA/RFvr3245q16Ma1hbFIrDBcAPSSyCauzBMqj19ntNVaezc+W9csC18FK9VvFC9qEjLTo6lSTpVUFgMv6Ub2m8O3njBRbcJGGdeiy55RW+PFmHq5hPCSoFnhTURn8Q59jC3VpBe981QKBnXk6EHaK9Q3Pm7XOtGsuG/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=W2Njs83e; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-308218fed40so317250a91.0
        for <io-uring@vger.kernel.org>; Fri, 06 Jun 2025 10:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1749231441; x=1749836241; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+L+8Cm7Wah/hWtY+XTFfTzbZh3uMQwc3wqvclz4CuXw=;
        b=W2Njs83eDdAPRzT5lHHQ0pdpOUNm6DfbcDf56pe5qWLlR/ZYaA7Z8S42hCZvtQCU3Z
         pB3niZS/8kXrggkH8NcX4iksS1twbrPcSB4jTkxx+N/M2cgFHDx74AR6n+YI2GOQR8TK
         TlUD5Sd4iSUZNYMlDgz6s9btvWxlhgLBuRIyk7qxnJEW93KCVfl2m035n2dVEsFJrD+u
         J+Ga1VWu+pkWkmYpw2OMspiSlH4I5zVMnPYd71E3a9y//BFfGv+9YdCT/jSAjAtDLak9
         +Rn40/yWGXiNCNvdI93k5K9wDQwnEQRzZIJtIPBXWwWoSpYv1QVu7JYJ7+DDSumLuuXl
         cbBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749231441; x=1749836241;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+L+8Cm7Wah/hWtY+XTFfTzbZh3uMQwc3wqvclz4CuXw=;
        b=kATVFALHpnKoW/aoxZYly3s32XsKJd9nRcsHgeAb/mUKwY2CVYs0X+7hvP8DcBS/sF
         OlWKM90WKmucCFeO4I1ZJVfWH5j34HXQpmUcapz2BEhHgSg28ZPa6fxymwG+b+/YxyT0
         Mm2oMr7DGr7wh7j+2JRpZ0DsSNt048e0VxExE8yZzwqaFOPSlYLqq44XmQ9LSdeeQqN+
         X5U12eFQEDHU4Kj7pTdn1H0EheXAAM0g72kAVbUc/c9zLuVz4SJi188p3skuTN4DAtOU
         hWKKXtt3lFvOX2llOS7Z48eebIIG8BAvEQhw1DJsi55OA71AN29/DLy7Qmdc+9/JD3ca
         SimQ==
X-Gm-Message-State: AOJu0YzXGIUo0i2kfuLMxMPVFrfmLKYHcbCUl5srkJRReS0n4ysJdb2w
	p/09Cfdy6N4liXDi8Gl2EO9cGUgUGYpPVZfLtVWzk9uxICKENVK2q9Os9adUgiJB56KlNMINHNv
	S0NKORH1DJXRb7T+jvop0Zz5e8MVhg3RLNTKiph/1SDL9lVZYl6ww
X-Gm-Gg: ASbGncvc8Eo+YCPfcDCQnoyjOBqpH4np74JaZy7Qe+zG1uZpNlItwr2dPzoY6ofjS8U
	vlYD51+lDYF3lMA/1Q7TtWUwNLPK2syTT2kTZWRgS9u61s22aDc0XeT7HPUCT0FnZhN/bjl8vcD
	q488JU0vonzpAWkU9EFL6oKJqhY/jZjjvW
X-Google-Smtp-Source: AGHT+IEsqP/FFCn71tMrL2oYkfa9FxHmuxT79wpWpmyG8iT5iS1vRaa3TTHKPs1YanYVSCu30GaY6NKIJZ+DUNkp6YI=
X-Received: by 2002:a17:90b:4b85:b0:313:2bfc:94c with SMTP id
 98e67ed59e1d1-3134e43144amr1746386a91.8.1749231440918; Fri, 06 Jun 2025
 10:37:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250605194728.145287-1-axboe@kernel.dk> <20250605194728.145287-4-axboe@kernel.dk>
In-Reply-To: <20250605194728.145287-4-axboe@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 6 Jun 2025 10:37:09 -0700
X-Gm-Features: AX0GCFti6cITEeqWwpr_NL7HHkUueFWXwNtxuCxgu394ncEotUJcStlyHvsxTHM
Message-ID: <CADUfDZqC7e6+xCWbgmUJr4oLeoAf81-SfGGB6_w+1ck0X+Pvnw@mail.gmail.com>
Subject: Re: [PATCH 3/4] io_uring/uring_cmd: get rid of io_uring_cmd_prep_setup()
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 5, 2025 at 12:47=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> It's a pretty pointless helper, just allocates and copies data. Fold it
> into io_uring_cmd_prep().
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>

