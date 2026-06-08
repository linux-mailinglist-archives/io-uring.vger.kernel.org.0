Return-Path: <io-uring+bounces-13636-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id BFKHExsyJmpNTQIAu9opvQ
	(envelope-from <io-uring+bounces-13636-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 08 Jun 2026 05:08:11 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 37A92652617
	for <lists+io-uring@lfdr.de>; Mon, 08 Jun 2026 05:08:10 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=CdbtgOLx;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13636-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c15:e001:75::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13636-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 43E763001580
	for <lists+io-uring@lfdr.de>; Mon,  8 Jun 2026 03:08:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C778282F09;
	Mon,  8 Jun 2026 03:08:06 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6313D4A23
	for <io-uring@vger.kernel.org>; Mon,  8 Jun 2026 03:08:03 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780888085; cv=none; b=SnlIXGiphmVW12pCkmtKAhyBWfpDaGFylvVW0+66k7RwwyuWIJRKo34R4KiaaqXYjMjhfhvjBOF5yGrIarRyNgfayyfa7HW9T5WaZj6U6fiTrWbIy1F3TAGP7Rc4jZR7e24YW/MtulpLmZOkxK5AbEAIKX7ipc71tnsIxZXlDhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780888085; c=relaxed/simple;
	bh=kay8r/0c7jvbRLSHW49oDVaVx65HKHuzXXybFw81Iyg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=UWzBVhTcbbw+24xtkPNPdvpTbGks/YhsdK6w/nKIdLI0n/evfH6BIMYApKzPGfvGqimt7QOWji4+dYE0KTndFLkyPCvuHy9GVwRquM1iewFpT0YziimPKP60tBpFXUVEQW5nK9/s5mrRNE/xaGy4LdAUKGfQC9/Rs8pyC/gloxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=CdbtgOLx; arc=none smtp.client-ip=209.85.160.44
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-43f5927e70aso1522762fac.1
        for <io-uring@vger.kernel.org>; Sun, 07 Jun 2026 20:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1780888082; x=1781492882; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JlIbLTcwILf9l2b6O22N/g0xIicNNh2DbEUGvz2/uFE=;
        b=CdbtgOLxKXIMuFmDOdRTSHnhSi5KGmCDD/tu/4NorcfMYXzaeKxYEkWtutM4+qc4Tr
         uL9FScpvA4iX9DqI6+9gR6QXHDsX/rSNv86wODW1tv2khhoWQ1vEYfvBUQyPtpq0xrhd
         HMlGtDJ8t29QmnU86xrV64K0eW4BiWBe4XVdqQiQCSJEeEnisRleTtFRTFLWLsQfp+mg
         K12fxMJezPY2MnB0vhaV70Kj7HO9TgG98yvzehaUjE2hbV2BN53LYXyoAYtYx9CR74Wk
         6ijcmmsv/i8PPQQzXIqX7lxDTJsZXr1Evk4lEQFoKii5R3t+KS1n5lrS5y8l6jiikzrX
         Njrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780888082; x=1781492882;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JlIbLTcwILf9l2b6O22N/g0xIicNNh2DbEUGvz2/uFE=;
        b=ncGEGpJKEv3f3K49C1iPQnZyBTanYIaFTOLe/Xh7S3xhCZeoF2SOeN2Ibh+GFyGej1
         92XxDdAlu90NV1cvvZU3sL/gwdmhwtSzSowKOISKu/M3/tA6RFZlp0BxTJgCx4dkkNNL
         +lm/1+YvHDQ0sAU2v8VpLiXLQ5l5ixHM2c9WAb+njFNXVkqEOH8CBto9PtIPmAivcugE
         abT9GQAvOah0/UI9BdHA1DNjzUspDpAMlc6fgqxLn+WgKvfaP8EN4fAt0yWCqBoI6ktN
         Vu/MUU516mOb8yPgjc4Cb2pZ7msq1EUjN2T4lbxkExl92aSeUC4FxpclDj5TbDn8bqlx
         S0dg==
X-Forwarded-Encrypted: i=1; AFNElJ+i7JszLg46MiHevWofE+C12VPDEfeMpUs0ZJMtioB1Myyry1IkZ2CuQBdsjSWWMLvvq0KkYvY/rw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyFhf14jSZ4kSYsptKUNPVildX2V58l4pLGRpNV8+YmIdgsdW8s
	CI1dHfOAY0gVw4Q6DO2F9nEMuCeFsLGPK15lFDWIQEydQBmRrXYkKtg8j/EvS8XWs0iZ0y+/GR3
	CR5rY
X-Gm-Gg: Acq92OEA8Qtl1ZpwMYWsmv/P21OVR4+6hP01jnWodJtJWbXTNstph1a80x7psy48rJh
	Yqv/XTQfaKCpGIiH1OUNQkQ5mVJRsLAjo0LstxbxdX8UEVPcd63i4UrUpkj4Bw+ji0645iiAP1U
	f8G8aDx5CPN1USJUPaP9d5fd0UXTxIcoidEn10WU60ueRiWC4hge+FY80xLv6SPA3etqx0PFelY
	jiTrLuYgp0yBYhhW8GndIFsdCzIfo9D4dcmpbogORtzjjDFVJpfcMbghHI1VQ0nJBvaX+Jhq57m
	Axiz4U/wiTLYswfUIN+jreNGd4XuzPVAaK95kwHyX9UFvN3X9qZOqy/LVAf5PWZO2WOdlRVc1Sa
	SVEOkH8042GJUx5y+mqu6nefMncgHXQICu1fHq34ZmpjjRGVEcYTDctQFvqXaJbWp+0sLihZQty
	Pcc4Ocigccd1vAWqJA/H+3HGdWcq12UoFv5EAqPBo3nKxtsF85m8P+7C6VcgNStuUfdg+7fx7az
	+JEVX2fqdc+UFTNpp0G
X-Received: by 2002:a05:6809:c1:10b0:486:b56c:f786 with SMTP id 5614622812f47-486b56d5e22mr1873956b6e.30.1780888082206;
        Sun, 07 Jun 2026 20:08:02 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-44183257897sm3948167fac.1.2026.06.07.20.08.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jun 2026 20:08:01 -0700 (PDT)
Message-ID: <2a7adb67-2c39-41dd-8f79-9738d422fb71@kernel.dk>
Date: Sun, 7 Jun 2026 21:08:00 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring/net: support registered buffer for plain
 send and recv
To: Ming Lei <tom.leiming@gmail.com>, io-uring@vger.kernel.org
References: <20260601095853.3670199-1-ming.lei@redhat.com>
 <20260601095853.3670199-2-ming.lei@redhat.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260601095853.3670199-2-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:tom.leiming@gmail.com,m:io-uring@vger.kernel.org,m:tomleiming@gmail.com,s:lists@lfdr.de];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13636-lists,io-uring=lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel.dk:from_mime,kernel.dk:mid,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 37A92652617

On 6/1/26 3:58 AM, Ming Lei wrote:
> diff --git a/io_uring/net.c b/io_uring/net.c
> index f01f1d25e930..9c42c3dbccd7 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -431,6 +432,14 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  	sr->flags = READ_ONCE(sqe->ioprio);
>  	if (sr->flags & ~SENDMSG_FLAGS)
>  		return -EINVAL;
> +	if (sr->flags & IORING_RECVSEND_FIXED_BUF) {
> +		/* registered buffer send only supported for plain IORING_OP_SEND */
> +		if (req->opcode != IORING_OP_SEND ||
> +		    (sr->flags & IORING_RECVSEND_BUNDLE) ||
> +		    (req->flags & REQ_F_BUFFER_SELECT))
> +			return -EINVAL;
> +		req->buf_index = READ_ONCE(sqe->buf_index);
> +	}

I think this should either reject IORING_SEND_VECTORIZED, or if there's
a use case for it, ensure that it actually works.

Outside of that, change seems straight forward to me.

-- 
Jens Axboe

