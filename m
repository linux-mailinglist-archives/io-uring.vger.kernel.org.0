Return-Path: <io-uring+bounces-2520-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DB479330A2
	for <lists+io-uring@lfdr.de>; Tue, 16 Jul 2024 20:48:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DBA681F239B1
	for <lists+io-uring@lfdr.de>; Tue, 16 Jul 2024 18:48:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E708B18059;
	Tue, 16 Jul 2024 18:48:10 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A4C1643A
	for <io-uring@vger.kernel.org>; Tue, 16 Jul 2024 18:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721155690; cv=none; b=YPxkfWur1pl/rrFq2kNR4MCOzCM7DDRSBua2TlmwKF1Zw0WY183UYwzHua5Be96uFHqG1Mz3fIw2dBZyAQphZGN++O6Qec4eudYMc7iGk/9K2hjvOvVzKGyhR0wGM9lVEFeH6naLYyPD/RNOaDShybcv0zTkiQAAZQC0OQc2m0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721155690; c=relaxed/simple;
	bh=lwz8LqtRjITK5DSC7RPwPF0lEJsOhjI3QWln4RlQysE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZjAG1xxD/q8VvGM7zemJkshpvMLE+mZ0tzFY+HFx9MHipXo7XpAgtD01fdTmMty2jP3MQxScLC/fjH5APIEp/CikEeIoynbwkXeAsapkMAOm2N+W2Dpf6w+O1+F3Dca9CHmNwD+kW7YjB1svQlR5EqenMKwA6x55M/W7qKLkvhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-58b966b4166so6458279a12.1
        for <io-uring@vger.kernel.org>; Tue, 16 Jul 2024 11:48:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721155687; x=1721760487;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rO3c9KqX0x45zX78u+ER7Rz5Dz9NX292WgeA8/7D3mY=;
        b=rBNc/t3r3alSboOdVKFaXXmC/Ce76qixh/C2XQmrgM408OCyBvpA/v+ajjayxN55Ya
         yd1FgdDXVqsDMJiZmG5oxJTjsnT/uDnL5i7tIB9kjgWiO9QBWS2NYzzwA6aF6ewuw4ce
         XTiW9XoCUX/WUmuz9VT7KWRk+2nVKaOwHGBoTfgygZKVQZh0xoT0EPU8G54AiQBfPpcH
         gGhjR7QAK6NhFpBsVC6+aLO29hd3HQ2IjR7WVnmQpbpjymcNIbqst0+KsxKTr1Og8cZU
         vWQxNuzEj7IKHrOB9meLuprpm4jVZe89Y69RxZ2RqlwRAJ8sY0G7b1VvGHkAsYdlgrPi
         kJSA==
X-Gm-Message-State: AOJu0Yz6mqePrOlNFATsldu3UpCpH/JswejeJms+Zm5SpMTEWdnlhW1c
	rhpBo+uU4CevJx43z4NvJZOtpoYo3t+1RBDDFiPydlsXkvXshJTW
X-Google-Smtp-Source: AGHT+IG7CX0rU4cHi3y5sV2qdO41woN6kNPMi35HDpiawkEdYzIX/NijR861DqY5MzkTmWoMpaUo/A==
X-Received: by 2002:a17:907:e8d:b0:a77:e55a:9e79 with SMTP id a640c23a62f3a-a79ea3ea44cmr245195566b.4.1721155687036;
        Tue, 16 Jul 2024 11:48:07 -0700 (PDT)
Received: from gmail.com (fwdproxy-lla-002.fbsv.net. [2a03:2880:30ff:2::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a79bc5b8366sm342121966b.61.2024.07.16.11.48.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jul 2024 11:48:06 -0700 (PDT)
Date: Tue, 16 Jul 2024 11:48:04 -0700
From: Breno Leitao <leitao@debian.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH 1/1] io_uring: fix lost getsockopt completions
Message-ID: <ZpbAZB+InQKJlSVZ@gmail.com>
References: <ff349cf0654018189b6077e85feed935f0f8839e.1721149870.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff349cf0654018189b6077e85feed935f0f8839e.1721149870.git.asml.silence@gmail.com>

On Tue, Jul 16, 2024 at 07:05:46PM +0100, Pavel Begunkov wrote:
> There is a report that iowq executed getsockopt never completes. The
> reason being that io_uring_cmd_sock() can return a positive result, and
> io_uring_cmd() propagates it back to core io_uring, instead of IOU_OK.
> In case of io_wq_submit_work(), the request will be dropped without
> completing it.
> 
> The offending code was introduced by a hack in
> a9c3eda7eada9 ("io_uring: fix submission-failure handling for uring-cmd"),
> however it was fine until getsockopt was introduced and started
> returning positive results.
> 
> The right solution is to always return IOU_OK, since
> e0b23d9953b0c ("io_uring: optimise ltimeout for inline execution"),
> we should be able to do it without problems, however for the sake of
> backporting and minimising side effects, let's keep returning negative
> return codes and otherwise do IOU_OK.
> 
> Link: https://github.com/axboe/liburing/issues/1181
> Cc: stable@vger.kernel.org
> Fixes: 8e9fad0e70b7b ("io_uring: Add io_uring command support for sockets")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Reviewed-by: Breno Leitao <leitao@debian.org>

Thanks for the fix.

