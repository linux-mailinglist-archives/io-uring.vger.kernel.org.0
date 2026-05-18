Return-Path: <io-uring+bounces-13389-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cG1zIqbsCmo89gQAu9opvQ
	(envelope-from <io-uring+bounces-13389-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 12:40:38 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E26BA56AD71
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 12:40:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0ADF430427E4
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 10:31:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 892AD3EF0C4;
	Mon, 18 May 2026 10:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SFtHjJDu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797203EAC74
	for <io-uring@vger.kernel.org>; Mon, 18 May 2026 10:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779100273; cv=none; b=U4Tefmnl+UBiVY0rAR2lna+VwmlJJzJsGUJ4aAwkAIDxSy7xsBxLV8gmXRi5UWS6jjFccTXykxQBNa070GDfPHWf3YmBLbXdUQhqq49dvFllFXdLChsDv2P+SEmYU096qGDAYOa14TZb4qArFRqo6nBZ4xr4fJ3V8I2fBfB0ypI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779100273; c=relaxed/simple;
	bh=uNvks5nLVhab845gPs8D4jnOry1W6hE6xPWWd9nU+CA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S96uZtyONy61S+kXVxoVp79lcmjMHERVXx1mumSUw5MA7B0mjqLOQoUj2qEXGrUIzG/QAjdImlsEszstX0En9fmXxJf0sFzUHOGhdQtrBcBhwEUKShmTnJDQLc5MvMatdBu3vHUcHoHgtyHUHaJVAhl5U1kCMnCZZbTu6bRBn90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SFtHjJDu; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-bd4f7f05e90so427747166b.2
        for <io-uring@vger.kernel.org>; Mon, 18 May 2026 03:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779100257; x=1779705057; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hx27Zr2PfQkgYP6DocpvbcVC/5/Kjswu2b3jiJPzVQY=;
        b=SFtHjJDu5+thx67ZQgSBSlnzrWP8St/IsgqvFJBv+8gm1ZrL2dyXiR9tOuiCjTHlxK
         leC3X5LwO9ivz6GpTCXdCkORR5nUXpH3H7zydiX32uINNdws6VGv3HNPz767MpzZyFLv
         CwtfM3jnULTNL8ABAm8hoRo8Gid93oQikbr8Xq08xamILO2ehZBd0oG56QxnAvJixFAt
         w6azypF0dMLXHB6c7c0334C/m+OJ2yS/GGsT+E/iEqTBoTUUM1K96VkKyWLbFWOKggQK
         i0EgO1KZSz8N0Ht7I8I199PJpHmud6anBnAwiAxTKU6aQqsnKb7fdI6vF+DEf3UPLiaQ
         +FvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779100257; x=1779705057;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hx27Zr2PfQkgYP6DocpvbcVC/5/Kjswu2b3jiJPzVQY=;
        b=EQwpdkOZ8gxvJp8J949TvwFApOAYijy8TgkLvMcxab1BwlO9Qy6TkIzCXYPavNagXW
         DOQZNwdpFzxvZbWrWkDiiuu0m79bOBZBFBpWhC5aTmeOfgg5vWCxGl3Gxk0nztfVw/6C
         RHScwwSza6bBiteoVthSeLl4e66x5qKiQZ4bS12wgFmgq2c+aJ37P8l+eQHO8wcFRiLO
         pE9YIvEojQUQg4BSAt38TZh3/4BtaJXREUsh76p+k+EsjaWv347X7eprJCjSeZ8tVoQG
         3yAybQOphbpamlFvDkseD3wpQI9nJTZ3lf7/2ZOK8/+Xg5LGiLWj5LjNRAAH4QTkI5DV
         k7fA==
X-Forwarded-Encrypted: i=1; AFNElJ8d+a3JP0LTMaJlQibeacQdah6lnIN+azUsGWsvQ8rYlCbuvnki34S8Slp9LF9xncLYEM9BLasZMw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzxi0LKqNX7HtRsH9+z1Y/YBylZHVouYlVyhH2k9ZTbZmmDoD2t
	lzkM+7EuHMoGPvXfhr9WPxU/lGgn4rsPM7UYTx3NRpDOYYnyx1HpieUI
X-Gm-Gg: Acq92OEsIIftib8cJ2VPwr1Ci/DEDib7CAATmaAv90t9bKjJ8ABuF8LarFAFgCkSZml
	c6MSdddLUYOMmOiU+szcPmazYHqgDZb7DwcHbwj5UoDD97k6Ntsb+qfG1kLb5e+GKVkpeJOdqHa
	NXW/MpmXe+aQlvIA1QI8s9eTflBzE5CUBGB+VzwSdXfPsAEHp/r5vyww4LwNU0Y0tUR1T+QgjwQ
	J3fMTVO9dK1yvyRf6gJ6KzMHrkN7CxPlQ1iKD/UxMRhPMAUrqmfOG+EQrvnhFxNj2UcB6At9u6c
	P5JzCjgLKpOelrg2ZniO6JEj08iwJo9AylaNR/o+jkxzn1MrShiPwKWU8z8jeL0AV53WDR2YACF
	Sz/IbDD6LnWRSmmfFun7S1dMZFGdweh6h3w+F1oa4wpO0NVjRrl/LbK6GiS4psk35HYffTdAAA9
	MAgv0g6bi8r5QLDsvmCtuOPxXY0nN9oFtoomYGunsWqKI4ZjqPhDz1zpTEClOhYYcJcTjc62G8Z
	gQkO/k4CdYBQSD+oKd2nam8TR9o75LNrmxvKBazRAKCKsX+fBlnAF4busw=
X-Received: by 2002:a17:907:1c0d:b0:bd2:bd3:1ef8 with SMTP id a640c23a62f3a-bd517a99797mr714341866b.35.1779100257041;
        Mon, 18 May 2026 03:30:57 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:ec20])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bd4f4e4d54dsm542055466b.47.2026.05.18.03.30.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 03:30:56 -0700 (PDT)
Message-ID: <574f42cf-0d72-437a-8eba-fd970011e206@gmail.com>
Date: Mon, 18 May 2026 11:30:54 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/10] nvme-pci: implement dma_token backed requests
To: Anuj Gupta/Anuj Gupta <anuj20.g@samsung.com>,
 Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Jason Gunthorpe <jgg@nvidia.com>
References: <cover.1777475843.git.asml.silence@gmail.com>
 <5cecb1157ab784f9f303a91449fdf11b03aa6002.1777475843.git.asml.silence@gmail.com>
 <20260513083817.GC6461@lst.de>
 <CGME20260518092930epcas5p30d3b49f26efa5969ddcdb15351a886f3@epcas5p3.samsung.com>
 <50ed7240-d8d3-4816-bcc9-ce8adbbbf841@gmail.com>
 <f9e04625-50c6-4fa9-8b12-76496e29f10c@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <f9e04625-50c6-4fa9-8b12-76496e29f10c@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E26BA56AD71
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13389-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[21];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Action: no action

On 5/18/26 11:18, Anuj Gupta/Anuj Gupta wrote:
> On 5/18/2026 2:59 PM, Pavel Begunkov wrote:
>>> FYI, I really want SGL support before this get merged, but ignoring that
>>> for now:
>>
>> I was hoping to let Samsung guys to send a follow up they already have,
>> but I'll ask them to have about taking it into this patch set.
> 
> I had done patches on top of v3 adding SGL support and PRP list reuse
> optimization for the dmabuf path.
> Branch: https://github.com/SamsungDS/linux/commits/rw-dmabuf-v3-nvme-opt/
> 
> Also pasting the SGL patch here for quick reference:

Thanks Anuj!

-- 
Pavel Begunkov


