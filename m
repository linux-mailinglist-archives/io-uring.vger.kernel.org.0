Return-Path: <io-uring+bounces-10768-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79204C80CF9
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 14:39:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 522433A1B30
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 13:38:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23D62306D58;
	Mon, 24 Nov 2025 13:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Os99fXi/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BEB306B02
	for <io-uring@vger.kernel.org>; Mon, 24 Nov 2025 13:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763991537; cv=none; b=HuG6mdMfuOvjPJFluf+BPfnig2HnHHwA84RPKUjSbdpJK8f01+IzH5o+PTVX7ApPIl0kKXn3EPuNh/hKWIC+yVyEzfVeJEvSIC16LaVcwkf0Q8wW6yFEof8zp2dW/1ibuj4e6Kms5myHahBBJo5UXlrB55o6ETFms25RcrrZA4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763991537; c=relaxed/simple;
	bh=hFssPJTM7dfkeo3nvA01t4OSU6WT4LDzj+frYOuLW9w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OjE9sFrCmLLSWMSCZOZpsXI/NDavcNKiR6aezRuuc0dT0gIW3WuCLjDPtLyfBUjbdS00mD6LQRfJF3GrZq+0UNIprmI3Y4/Rrr6Co+YIhajN9BkzCUYzn26t1O3nT944kLNj3Kd99pzV95bEZGTxzMIAD3DsQ6x9y4NsI+Zk07o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Os99fXi/; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-64320b9bb4bso197145a12.0
        for <io-uring@vger.kernel.org>; Mon, 24 Nov 2025 05:38:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763991534; x=1764596334; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fGnf1zvNYnk55vDoYwHQmt5WFO2pnbA0Jle9HXGkL5k=;
        b=Os99fXi/P5CtZqR0D3ax0akt+Gp2AWkUY8AfW1xNYM3Z26PGCN2nf6zaAjKy/Ikd8d
         Qntn5kv6SU1FT40UgPr8zjJzkyV8h8MLTGyNwIRLmhOq4ww4rVliyKsDTmLpP2YTgbJ9
         OgxGJptnmlRfQ7plwEN0TMg4/kDuvtseCKxW311HD+6vHq6yFn8OkOPag8Uy4U88YNXb
         TMZzomQujHkv6vZi1yL80iDMicSrsGT3c0GAlAH2iCLY0mEpkCARFupuwPF1jx2qyQj7
         SPrUm8JCnGMgkeTABaMj+nI1buehfnfBxXcCAyP6BxzmauWDRi7bB0H53rHOpLBbPEUN
         K6dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763991534; x=1764596334;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fGnf1zvNYnk55vDoYwHQmt5WFO2pnbA0Jle9HXGkL5k=;
        b=PxYPLqGcSTqhpIk9YSMBKOvYRHmA+sKOgiOOwEByo3WBRyqCDsy6gAorZEXbFPOM6u
         i10X5yj//u2BL14N1gJAL/yk+1BxGJO1qUYW5BrTT5ntGVyD/265tzuOwzBFqnjL+NvC
         And49dHJqGGt0ykFM4UupD5lKyhX45k0Hj7npb2Wn6cTzMcA4hNFoIipYzsVfwChbYnk
         QVbEygWq2Ljg9KbzUV+eekB+d3KoyF9hgRhAKJeQW7MOzwPCBPn7ymNmN+8ujOrRN/wT
         gnoj9ivfQmufEVAa/goE13/9Y7PnnHLukw97NpeckMfSGggiZGWl+Smfr3XC0Q5qqW+9
         1YCQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3RXonOD7RM72EcSWibspFpW5vxXJjH/wfRuaYERUjxiL/yX3tT8C57TTvN50ogHAnmfOgv/cICw==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywe1mzhZDno9vaRC1HTCP+Q87kQ9TopEayhtho9ui/W+gVuD6IE
	T5XiIFHw2TLF3P397ptYp9PFAozzgDNlQEGrnTNuNwREMevXcckHsXSkl5rbKh6t+Z5yWE4WLzy
	F9DVVX4V/Skshw+L5x8e/SIF44th41g==
X-Gm-Gg: ASbGncuUDlvvR9+8sSx4kTyZJf/n7KbQnUOR8pmD+K6/LdPHA8kIfTyu2bUpoh2aplR
	+wVa5xx97mGET7/s4LDjbqPABCPspCobuu+jkE+EAPgL454A0a1X/EjlHZRqhF5iZPi67So2JqR
	nXq9QuRtw3QMy/Fnd6wt9taRVblUbEMf7clYYuGEvj2uTxogQKf1QsoaAbEW7hhaSCrZilheJjC
	yG+R0zMxPbLP8952/2+MwDUVI5sDrHLjRM4WFRRLGSeiz0D0d+XnAgbjnJBoZ2tHnUqCEGJydqT
	MWiIDPZ3pqJxGJuFx4yMiTuqzzak33JW42I0PoYGyPEJJTaVa4qItKAK57V8uFKjDrk=
X-Google-Smtp-Source: AGHT+IEIrrPvcFC3+rTLrgAPrW5zl0/cNdfSGGH+WdJU8CBkNncTEWdpxNp4QGdNjnbB8MXP5BRq+4un+OL6bxIbhcQ=
X-Received: by 2002:aa7:d814:0:b0:640:93ea:8ff3 with SMTP id
 4fb4d7f45d1cf-6453969fc53mr9852940a12.13.1763991533736; Mon, 24 Nov 2025
 05:38:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1763725387.git.asml.silence@gmail.com> <51cddd97b31d80ec8842a88b9f3c9881419e8a7b.1763725387.git.asml.silence@gmail.com>
In-Reply-To: <51cddd97b31d80ec8842a88b9f3c9881419e8a7b.1763725387.git.asml.silence@gmail.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Mon, 24 Nov 2025 19:08:16 +0530
X-Gm-Features: AWmQ_bnDcYvcgkdgCo-kXgELlQbBhcvXrCXwL82qa0EngBmCaaIoNiIBz4Az0nk
Message-ID: <CACzX3As+CR4K+Vxm2izYYTGNo1DezNcVwjehOmFjxTqaqLrDGw@mail.gmail.com>
Subject: Re: [RFC v2 05/11] block: add infra to handle dmabuf tokens
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org, io-uring@vger.kernel.org, 
	Vishal Verma <vishal1.verma@intel.com>, tushar.gohad@intel.com, 
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, 
	Sagi Grimberg <sagi@grimberg.me>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"

> +void blk_mq_dma_map_move_notify(struct blk_mq_dma_token *token)
> +{
> +       blk_mq_dma_map_remove(token);
> +}
this needs to be exported as it is referenced from the nvme-pci driver,
otherwise we get a build error

