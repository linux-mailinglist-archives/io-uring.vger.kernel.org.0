Return-Path: <io-uring+bounces-12717-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SArLIwiouGkthAEAu9opvQ
	(envelope-from <io-uring+bounces-12717-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 02:02:00 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E255B2A26A2
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 02:01:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 854823002B60
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 01:01:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 040361DDC1D;
	Tue, 17 Mar 2026 01:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1ZxQjh7l"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7797C1CAA78
	for <io-uring@vger.kernel.org>; Tue, 17 Mar 2026 01:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773709317; cv=none; b=NVQkaNMrzGSIsoG6q8N37OG8MeIf4+LpUoLuG3WZO7D51P6vc26HuiDOtlSMUORLJyJ8oxTk/Dlyc6/m8JGgu7T0Nzm3Y+gYjmVeT5AkN2q0WLt4QN6bJa+l4RFnla6PAAo16QqjGjK/hEVvpFKKXg+1ffprxD13PG7Q8TBACSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773709317; c=relaxed/simple;
	bh=C/loUq0tFUgMLr34wJLTDt+4x7X+MaWqr8W3H9NNxfo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=ADvO5dXamCZzRQGTDROVJdCG2MHqXHp579Ohrd4bq65judP9apnLRblGa1MomszdUnl9SROxEdtyBeXxFQgTDEuGjF6B0eQbltUVpabU9jHf76LXdZSn9oBr7znD1TUILgUjqCK0aW27ITiHD71+lZlVhCPdYw+0Fs58o6SE8OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1ZxQjh7l; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7d75371d873so5430006a34.3
        for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 18:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773709315; x=1774314115; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xJmZWcweGo/5CL7dk1HuKW3M8jV+oED2e+YlbfIAvtA=;
        b=1ZxQjh7lFqwAEgjoYrA+rvTDDve2nb2K92204Jf27OkKt/2BWY4ZD4mEdOHnqqRpod
         BLDqReKlSIuvjQoUsrHsMigvGpWJA8YKOQ7hodq6j8BIk05XA1LUNfg4JiLHQP2I27nD
         Fr+EHUXSvKXTfh+6b3yrnV+xPZapYx5mUMjMnLO4x51CK8vCoQ5smOb+16ycaPfT7Kfx
         JR+Woxtn1ZCZeuEsc7A3QL8e5lPWhVv6aPPjeAzY53SDyf8HoZmRFMP4Hfw6+pwXEyol
         G+ejw6PnZ0yi3+bae3gnFpnSVisfMzYduKdiZHnhR9DJoQExzjV35/NxwnoSWgXzLSce
         2uWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773709315; x=1774314115;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xJmZWcweGo/5CL7dk1HuKW3M8jV+oED2e+YlbfIAvtA=;
        b=DwpObFdnRI5kOIJ2eiHvrZHShDTOclxK+gwOLPpfymCZoGiPjZuLw0We3XFXLEprlc
         SbkTnTB+aULi0HuEjmHhKYgLIYDUE2MC86uUfUdKR/ZwuRdf7VSLtiubXKEugUv5fC/X
         RKkpNoJqUDMEXA8e/ORlqdk1MlQZf0LxMEzGoNN8eig9ogLdO9GDACnRyVjB0GLo2Fzh
         OTZ8MLBjsoJxToO3C+5sU1E6hjLKtT/w5ndSHEoKFoQuB7g/hLs54UKU6kaLGS6jylbe
         dlZooF+RNeJ0rCnXPj/FXHYfb/EyLS2cWIe7tuPZv+TJUmQOHt1kyEAwTh40NGohoJzq
         SBcQ==
X-Gm-Message-State: AOJu0YxldfAO290YWy9kPIXIw9dlASmIrHF+WszzP2D/wqRMs771sKRe
	ZS+ijIGtOMoQji9FBUE06cX9LhSSamNNSpU19zvgDewLz22aRUNJlYK7Y/XNHfRy0fV+msX0DZU
	NWDEp78Q=
X-Gm-Gg: ATEYQzyJvee7r4wGiE0JpFZCtyOJluvVuaS0n62tqcw1TtPGU0Ex0pKZwrJETiJ1ADM
	a9R+hMXnIvag0TNgNKR+HvOXG3PYz8IYQnpHuNT6u3SnEHt4fxMh7uH0a+V27fGuzJnvBLvBUUc
	4dHxpJcSXVMoKS5ZcDhD7KEvT+fdfvH0o504OdpNInlmhT3QJPBW/Qwh4+1fXoHRqMHpsquxaFG
	JDzPMdEjg84BJEm6IB6oHPOINrEtz68oP4psS/Nyqk7csRcQHESEq1AyXflalBhCzoH6jz/zgNd
	LL4Ab04dt1eIS/iDLDzD3wMmjsQOi/rIjEg5gwvC29+PxH8XxiqjZ4ZhHz+lcv+0oxUQ/XaEUBJ
	JUK/Su3AxkjbCvs3401wBT90v0H0yoqiI1eKOisMTMzWZyfTem1TlQUZkDfaMRtISS5DmHborK+
	m29x2Lsu/GyCtzDFkb+TvjAFUZT5tCzf9PkCkYD1wHEtbBKP6foZbgjW1YTZozGRB0lpEjxtpy+
	Lk512wvgGIA4WMU9wJy
X-Received: by 2002:a05:6830:3e07:b0:7d5:96a3:f7a5 with SMTP id 46e09a7af769-7d782519025mr10383836a34.18.1773709315458;
        Mon, 16 Mar 2026 18:01:55 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d77c961e79sm10284487a34.7.2026.03.16.18.01.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2026 18:01:54 -0700 (PDT)
Message-ID: <307e4126-91ed-4ca8-9eb0-3f24f1490aa8@kernel.dk>
Date: Mon, 16 Mar 2026 19:01:53 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/5] io_uring/uring_cmd: allow non-iopoll cmds with
 IORING_SETUP_IOPOLL
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>,
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-kernel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>,
 Kanchan Joshi <joshi.k@samsung.com>, Ming Lei <ming.lei@redhat.com>
References: <20260302172914.2488599-1-csander@purestorage.com>
 <177369928494.700746.8101380068186003544.b4-ty@kernel.dk>
Content-Language: en-US
In-Reply-To: <177369928494.700746.8101380068186003544.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-12717-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: E255B2A26A2
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/16/26 4:14 PM, Jens Axboe wrote:
> 
> On Mon, 02 Mar 2026 10:29:09 -0700, Caleb Sander Mateos wrote:
>> Currently, creating an io_uring with IORING_SETUP_IOPOLL requires all
>> requests issued to it to support iopoll. This prevents, for example,
>> using ublk zero-copy together with IORING_SETUP_IOPOLL, as ublk
>> zero-copy buffer registrations are performed using a uring_cmd. There's
>> no technical reason why these non-iopoll uring_cmds can't be supported.
>> They will either complete synchronously or via an external mechanism
>> that calls io_uring_cmd_done(), io_uring_cmd_post_mshot_cqe32(), or
>> io_uring_mshot_cmd_post_cqe(), so they don't need to be polled.
>>
>> [...]
> 
> Applied, thanks!
> 
> [1/5] io_uring: add REQ_F_IOPOLL
>       commit: 9165dc4fa969b64c2d4396ee4e1546a719978dd1
> [2/5] io_uring: remove iopoll_queue from struct io_issue_def
>       commit: 7995be40deb3ab8b5df7bdf0621f33aa546aefa7
> [3/5] io_uring: count CQEs in io_iopoll_check()
>       commit: 3a5e96d47f7ea37fb6adf37882eec1521f8ca75e
> [4/5] io_uring/uring_cmd: allow non-iopoll cmds with IORING_SETUP_IOPOLL
>       commit: 23475637b0c47e5028817c9fd4dabe8f7409ca6c
> [5/5] nvme: remove nvme_dev_uring_cmd() IO_URING_F_IOPOLL check
>       commit: f144dbac4b177cfd026e417ab98da518ff3372cb

Caleb, want to send the liburing tests and documentation updates too?

-- 
Jens Axboe


