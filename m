Return-Path: <io-uring+bounces-5337-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B58A9E9A36
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 16:17:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D205D285665
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 15:17:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5A061C5CAB;
	Mon,  9 Dec 2024 15:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="pTHDdzUE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45931BEF89
	for <io-uring@vger.kernel.org>; Mon,  9 Dec 2024 15:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733757441; cv=none; b=mj4tJ7wHZe5++90yOOMZRBaA6LwfZTMSm0wS6p0uGIs5C7Gg0K8U9Ijaer8z0qIwdRe3IUhk6FFffY4MRhvEw/UV76DKTwS/CHK0LQJnynsXUzIUXlxgHGGdgAmDryYTsDq17IsytYcHeDpldrlP8/qASgI6iGZivI+YPvkw7JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733757441; c=relaxed/simple;
	bh=yCmCSDr0f5K8TTbaZ/hcDTbNZbPTpvf3veWmFPJ6oAw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=r2tpOm6U3/OM/m1mwQaqOH4PqXLH9qSzVZpZmgExVWrAFurmqRDsKUDXTX03F3BtY6b9UrtD5O702b37AnxXLOeFOcsD55ljKpqJX+N1gs5WVCFutizMgSTAQJGEIwHH5j6lGxXPDeUbdol2tipOVggCQ0g2LkZqQjETvvdLhUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=pTHDdzUE; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-29f9e76802aso878951fac.1
        for <io-uring@vger.kernel.org>; Mon, 09 Dec 2024 07:17:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1733757437; x=1734362237; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MJKJ2SYaRxOIpplG34UCurYaJs54cfqVVXLORuA2HsU=;
        b=pTHDdzUEoU+A6YudPGVHTTCsQGs2eDjUbztr8w42198FfUZRItLAkMNvawI9BeNfx/
         4y6Q/fiLcE5aOdjnJ942zA1UGeVZoDxNka6j4rUVXllSrATZAiEJz7fMnsoGJ/eEX4lr
         pHsD2h4KscWiUyKeR68oK5FWLoZfVEnTilGHEZycW5zeQYfrixHXHgRxTcN8avs7ID9Y
         Wg5YFmYE0AyutUAg7GYFnC272Fa1nO6aDfgAlNiht4JnWrOzC237kUutwsyqwLXA5yMu
         OH73fiaDbOBIlzQeoZRHFQvQk1HlNhH5JYcZuRE1LARldauZx0UOWZmmRxfcq3ToTSnQ
         qcMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733757437; x=1734362237;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MJKJ2SYaRxOIpplG34UCurYaJs54cfqVVXLORuA2HsU=;
        b=E21lXMGkLmpx03oV457MvxLg5ADhPJ/x1IG9Q9MFLniTFcgu2nFG4ReScY0QiaYkDU
         AqZn6kbUJze7fbBSQRz8fwS5/X7ZWEGGmbdDoybkFFJspuI8/50Lu1H8XufXSj7VR0Xh
         CqRkA4UugbWqIudsNKf16xNo0442NVGX8FI82Otzpj0F/40oCQqlML8AwQUHGndeuPkq
         59/s65YgM//cC14nkhNL5LQrgyFLy9OGUZYc4EvNqNnTr12UGwV/3tonHR0QS/A7MRaE
         9R2TvNGYq6ir4dmCqc7owhokiB/xCy1tud9iZ3eXM68BUoygLXIRnC1ZAcXun5KYbqFb
         w1KQ==
X-Gm-Message-State: AOJu0YyZRpsZR0fUA4xncwLkj15qI050puzLjHzKaPv5HUVysx8AhRoI
	alzrG6yRYscCCxIj8+fEfe+zzfUmyJd8XuI2VcWdHxVtGq8kx0Fv8yx/nFGZubUzlKCAeFPRZnK
	p
X-Gm-Gg: ASbGncsAdT4esDL/ulNxl7cw7kEjZw7vwpOSLTaw8gD5yJcBzrW9abUDVjI53qI63BO
	6nwfzOz7HtrooKjDs3uMZPIwD5kaBkSszhU1okTth2i1fgum/aL7rC9c3bFI9FhCuMkCQCpAudH
	wjLIKrn4jNxn/LLTTx8Cdm0BmJ+S6PEcHekVzuE0TOPKXXQv53GCklV5QrEtS8jdgOgHBxd09DD
	EOFHAJIaFQ3vug37CwHhQ8mIJhK+HA176urc8wX
X-Google-Smtp-Source: AGHT+IGKjaPrNmA+OqJhqBwAK0MnlC134y997CJoFd16ulAvQ2uVLZG74X/V9rPrKD2Ixr9Imf5b/g==
X-Received: by 2002:a05:6870:e8c5:b0:29a:ea3b:a68e with SMTP id 586e51a60fabf-29f4faac5d2mr8905688fac.0.1733757437622;
        Mon, 09 Dec 2024 07:17:17 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-29f567c4a77sm2661779fac.32.2024.12.09.07.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2024 07:17:16 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: jannh@google.com
In-Reply-To: <1e3d9da7c43d619de7bcf41d1cd277ab2688c443.1733694126.git.asml.silence@gmail.com>
References: <1e3d9da7c43d619de7bcf41d1cd277ab2688c443.1733694126.git.asml.silence@gmail.com>
Subject: Re: [PATCH v2 1/1] io_uring: prevent reg-wait speculations
Message-Id: <173375743659.192859.14931287060083266808.b4-ty@kernel.dk>
Date: Mon, 09 Dec 2024 08:17:16 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-86319


On Sun, 08 Dec 2024 21:43:22 +0000, Pavel Begunkov wrote:
> With *ENTER_EXT_ARG_REG instead of passing a user pointer with arguments
> for the waiting loop the user can specify an offset into a pre-mapped
> region of memory, in which case the
> [offset, offset + sizeof(io_uring_reg_wait)) will be intepreted as the
> argument.
> 
> As we address a kernel array using a user given index, it'd be a subject
> to speculation type of exploits. Use array_index_nospec() to prevent
> that. Make sure to pass not the full region size but truncate by the
> maximum offset allowed considering the structure size.
> 
> [...]

Applied, thanks!

[1/1] io_uring: prevent reg-wait speculations
      commit: f137f14b7ccb78d274430d11b4526617d90739a1

Best regards,
-- 
Jens Axboe




