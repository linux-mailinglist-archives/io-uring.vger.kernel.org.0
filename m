Return-Path: <io-uring+bounces-12445-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8EyYG3zZoGkDngQAu9opvQ
	(envelope-from <io-uring+bounces-12445-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 00:38:36 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 0781B1B0F40
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 00:38:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5856D300AB21
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 23:38:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43E79331238;
	Thu, 26 Feb 2026 23:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DPESGMYc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06188331217
	for <io-uring@vger.kernel.org>; Thu, 26 Feb 2026 23:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772149114; cv=none; b=UwWUPXQttFDbq4aW6eYl1Zd+iQyKarQKmW49IUPvUFtV9UiIsmnLnGXuGx+O5/x1BS/U2lLgc+SUAkxGT7uviOF/Rcga7s0bianU8T85nM/uXt0gvu+2s/yLRe2dtMWxnj37V2Ze4hVK3TzVmslJTb8MNcZxYCvAeWtiGPdZ0vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772149114; c=relaxed/simple;
	bh=uC7aiyhuUJUmZaGZ1u66NknKDlFxu+Nn2BkTPOoqtQ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=huefNKOwW1ha5CjcPwx6h4qb2OSkASRIMGPnDExCeCEPqz7x614oSnXJIFl0ZXxceFUWrC/SQXHBMiqRKOeLXzSbIMQPayM/zjXkl0Ap9i4uMWkrDY715hYis0+cLVwUtfEEANDh5IOJGk4CtP0I1IJTuo3Y50h9a8mzuil7u3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DPESGMYc; arc=none smtp.client-ip=74.125.82.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-126ea4e9697so1630c88.1
        for <io-uring@vger.kernel.org>; Thu, 26 Feb 2026 15:38:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772149112; x=1772753912; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=h6aVatOQZhnn3/l3DG/K29SIadSoM5JJykVYfBXclQE=;
        b=DPESGMYcqw7kqD31vMzSdAkOIV5l+tlRHGE4vbTrNKTPRVfUDpNn5bxNk6Q/VtogW+
         b66wK33FtjHxY9g7MLThM6/FsZI5xQNcXElTIqupYFIt3Hb78olS9AGpRRkz2ZDXKWU8
         J6kOF32riDkjHn7hBdvM3T+eQ9X/jUJ2hLrgN5Ox8Iuvx9B5ub+BX6h5ufaH2RCnMwqS
         yt2z6+IzLmul/d96bcVPYtSfbr8GI+xCrAZp5wWZhLWNHnpQHuJZcUiorznaBAHt9j9m
         M8IdzqRJnJnDpie8QNvz25ySYymWkILXYYwYG+9k3NQsGUvVjG/34iejDMkxnb14tgDk
         rmzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772149112; x=1772753912;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h6aVatOQZhnn3/l3DG/K29SIadSoM5JJykVYfBXclQE=;
        b=jSH5yNOy/6FDmK8pWdL/LahX2xWXdy6b3mwlbj6sHezmqEUrL+ZeN6F/F8WptbB9yd
         aJqWbUD4UhCHZU+ORgHhmY5mS30OXKa4wpugGb5LV9xyD66yDaMjFNG+/IiX+NZ5MCBo
         l7AzkI95KAy8B/697HH60bYvrOaMjvy36UD8FCYqHqWBwAGZEV52oRwO5WxRKqDAs9DJ
         xWtd5q0ql50RMhL4y9NAY3yMIXLT6C7XXHqtxCS3K8hjQzKT/kzF91wJk3ho0zGSuBq+
         ev1ZAnD40UT0BJVBOKW+Zl8iNYStjvuGhxRuSPVfsItpjP/KwnI3RXKWGqEJ0mVeyFAw
         hi6Q==
X-Forwarded-Encrypted: i=1; AJvYcCXaML0kk5FBeRKWLEu4i4nyEtfkDCmcu2Dzx5TyrTfXeWdQTd6/Z1hqkz4mMtGQkIQuL0L5Tpf7ZQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyrCg99Ga5tg7GuPcGX61kBoCKF5hdCeMX3In+akoF8mEPX2K07
	s6a9DyK0ht63uAI8dCSI0VCAoG5eaW8lFlvnA0FWwQrXv84IcaR+kYXz3NSDfiluEA==
X-Gm-Gg: ATEYQzwnVb5PtvBUDR50kkJVn+zOvOKT5KtSAtmReZac7CQ/BOdJTnwsRERo0VIxobf
	izyjSGpGEttTO49T+MehLoOuPJ/99XuxShPVrc1jeaTamv6hbP4lRPKuRTZCnwcpiB8mEWDspi4
	Mbbp/Em06Y9s7Q8fMVHwZcVyoJg4vNidD3bQVgMCdvNNayFBGYiyRUPjWFoRTfb7UbBX+wFUyny
	E+v0wduTHhBe6TO+uoVWhOyLF8pkMAIAoih3lsLBX/Ev+tCDPymUp2tlROj6ih1XNUy0At/YSqL
	y17rz4XUpSOzBiZ/U6bHUuEkUXM26OxWuoocYmfSPDV3WrK92qygANVhb5ZZE/jEkvAXFV3Dmlk
	c7OGz0OW6jenUOAR0tHNyfYa+pQM/jQJ6hheHFQxAYtf62OIX1LX5gCwtBa0CprinN11hsZurzu
	awemrEd+eXaP/FLPzvjSxwhWDrTDKmVHZbg5bm9FWKTwCURmTQfIkGyoCUSNsu/EVl
X-Received: by 2002:a05:7022:f10b:b0:119:e55a:8091 with SMTP id a92af1059eb24-12788fe0b17mr248037c88.14.1772149111311;
        Thu, 26 Feb 2026 15:38:31 -0800 (PST)
Received: from google.com ([2a00:79e0:2e51:8:d9de:6ece:634a:85ca])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2bdd1f23c3csm3225980eec.17.2026.02.26.15.38.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 15:38:30 -0800 (PST)
Date: Thu, 26 Feb 2026 15:38:25 -0800
From: Isaac Manjarres <isaacmanjarres@google.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org, io-uring <io-uring@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"Gohad, Tushar" <tushar.gohad@intel.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Christoph Hellwig <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Subject: Re: [LSF/MM/BPF TOPIC] dmabuf backed read/write
Message-ID: <aaDZcZCwIqTrE7Z1@google.com>
References: <4796d2f7-5300-4884-bd2e-3fcc7fdd7cea@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4796d2f7-5300-4884-bd2e-3fcc7fdd7cea@gmail.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12445-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaacmanjarres@google.com,io-uring@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0781B1B0F40
X-Rspamd-Action: no action

On Tue, Feb 03, 2026 at 02:29:55PM +0000, Pavel Begunkov wrote:
> Good day everyone,
> 
> dma-buf is a powerful abstraction for managing buffers and DMA mappings,
> and there is growing interest in extending it to the read/write path to
> enable device-to-device transfers without bouncing data through system
> memory. I was encouraged to submit it to LSF/MM/BPF as that might be
> useful to mull over details and what capabilities and features people
> may need.
> 
> The proposal consists of two parts. The first is a small in-kernel
> framework that allows a dma-buf to be registered against a given file
> and returns an object representing a DMA mapping. The actual mapping
> creation is delegated to the target subsystem (e.g. NVMe). This
> abstraction centralises request accounting, mapping management, dynamic
> recreation, etc. The resulting mapping object is passed through the I/O
> stack via a new iov_iter type.
> 
> As for the user API, a dma-buf is installed as an io_uring registered
> buffer for a specific file. Once registered, the buffer can be used by
> read / write io_uring requests as normal. io_uring will enforce that the
> buffer is only used with "compatible files", which is for now restricted
> to the target registration file, but will be expanded in the future.
> Notably, io_uring is a consumer of the framework rather than a
> dependency, and the infrastructure can be reused.
> 
> It took a couple of iterations on the list to get it to the current
> design, v2 of the series can be looked up at [1], which implements the
> infrastructure and initial wiring for NVMe. It slightly diverges from
> the description above, as some of the framework bits are block specific,
> and I'll be working on refining that and simplifying some of the
> interfaces for v3. A good chunk of block handling is based on prior work
> from Keith that was pre DMA mapping buffers [2].
> 
> Tushar was helping and mention he got good numbers for P2P transfers
> compared to bouncing it via RAM. Anuj, Kanchan and Nitesh also
> previously reported encouraging results for system memory backed
> dma-buf for optimising IOMMU overhead, quoting Anuj:
> 
> - STRICT: before = 570 KIOPS, after = 5.01 MIOPS
> - LAZY: before = 1.93 MIOPS, after = 5.01 MIOPS
> - PASSTHROUGH: before = 5.01 MIOPS, after = 5.01 MIOPS
> 
> [1] https://lore.kernel.org/io-uring/cover.1763725387.git.asml.silence@gmail.com/
> [2] https://lore.kernel.org/io-uring/20220805162444.3985535-1-kbusch@fb.com/
> -- 
> Pavel Begunkov

Hello,

Thanks for sharing this, I am interested in this topic. The io_uring
bit specifically, as it might be helpful for a usecase in Android
for loading a file into a dmabuf.

Thanks,
Isaac

