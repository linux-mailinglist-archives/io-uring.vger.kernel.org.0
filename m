Return-Path: <io-uring+bounces-12159-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EMWXGqiejGmPrgAAu9opvQ
	(envelope-from <io-uring+bounces-12159-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 16:22:16 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D332712593B
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 16:22:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C1A993019FF2
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 15:22:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBDA52DECC2;
	Wed, 11 Feb 2026 15:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="EK54rvKq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D564C2DB7A1
	for <io-uring@vger.kernel.org>; Wed, 11 Feb 2026 15:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770823322; cv=none; b=Mu/XpB0iz7xBfESNYgRIl6QkyHIQZbku+Ji/IzF5LGOJZQ7K+VOUxFVyPmmkPCWgwA9ozI/ac6hnfhM7EeNuplVyFaTa4+NjOhCfbNHb9xlwwCx49A2Twi9r1bMxLOmMZsqSOHyzAolN4azCjRHv6rvggVU1F8kMlj0jts4lD8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770823322; c=relaxed/simple;
	bh=Y7SlTxzS2VnMDuAASMDM/Pc7J/4udBIFLvJlJIOJobA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DkeUMXMsauphDUV1g+XnTN8O9KRu1m0bC+3S6XQKDR8y7Mi5jeccno0vSbVaTKNXgXEqS9wpmdB9V8TzqivvHlESISMvepkFPZdVd/E94O/6Rsga0VjBJAF0lWzLV9U8oXmKmgRMomlVEKELTWzt1CNV7uL47jG45IoYljlh0lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=EK54rvKq; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-45efd53148eso1934575b6e.0
        for <io-uring@vger.kernel.org>; Wed, 11 Feb 2026 07:22:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770823320; x=1771428120; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uQsZus6B6A2LGmBZfcvwZ5r04q2Vs4rLburhJBVv+Qo=;
        b=EK54rvKqXRcj27ID2/ELDBPIaEGh2PE7Owr0N1zTNLC7Am21SrwExpwilO1ZOSy+f1
         CIPpUh0h0dsb/nWyZAJZEnIaqj9mVGAj1u5H4CN5gWBhjXsO9bQJpifndEvuj7HeyWgr
         zbmN9s+mFzqEDfMdgWX/EmTkVw88nQrFkyyDSibPFztLLvV3LnssgQvu/Wg3QgUZtvkO
         EW7JTKhbt6QLncCSDRccDEP+gUulUn6WGCU43f1+gxWNIHH78IpUd2n0K4UHv2FktuDE
         Ad80FQs8+e1qE+R8QIArPq3Ly39uz7piNvq8UXRP/0uX0pkteJjoD5SIKkWP+rIUlFo8
         FfMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770823320; x=1771428120;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uQsZus6B6A2LGmBZfcvwZ5r04q2Vs4rLburhJBVv+Qo=;
        b=rYKbr7oIl9Rx0YnHWSGfQ2dzjA4Jw8yjGer33tKrP310Ip8IgE8Zk/oafyMXA6plWM
         Y9tl1FuOpqCEaJ9v8UxTS5lx4u+WYjZw9Z0dX7u6y0jla1eSVFTM8X8zdLXVUdlbOSww
         RXlZaX15V1Pe516hsRK/SGNDx2yF8Y0nGk1sxmBbVuS6Vyg1ETKY1pzT7YovRcIk1hyP
         eWJTRdz+NmzERr3HBl7kMcz6YdLp8puV2hJb2nRMDkfbakRGdO6vcOVDsL/7R9nm360w
         YoD9vlCCDalebSUhbAtt7gFAbczEHQAXPosk5PBvIEypAv3gGCHGEW2IegOy9hbxfVci
         WLbg==
X-Forwarded-Encrypted: i=1; AJvYcCUxv20a3YekfzDOQLs0pWG8SjDG1SphnJweGbxR/5GSEtRDziNPFYZuyQu/kxkYMN5PXtUY2omEdw==@vger.kernel.org
X-Gm-Message-State: AOJu0YylH3KWQyv3QhAZ4P7pcIQBFd/OymXmgKTMugOe/68gEe8he8C2
	DzZR499mXMQCDa5U/KyyIY0GRRiN+iqA43gFvzSuX1K2NiiBI1cPFtLDK1xlZV2Uzzc=
X-Gm-Gg: AZuq6aJVZ7YIJ/wXk5A9pn2CJKOM+gIMeFjFGBe+919PpZqczJuFw6QDT7OFq6BCcOb
	DhkwWBvNiu834WnDJpUIsyRRgqPzGP7d2zcq35Aq2Jc0NsQWPM/Gr+WH9+su39vizcPRiq3uTma
	7i2CZO8vhpJs2jA11tc/OkTeTPdXSCUc7hr9mKHvACZ23bQ3ztUT+3QY3YIAW6UUlNcpocX7l+q
	pTBamVhVeKVs3OPP1mwbARFkQM9TukhAoSNtWfIzchgjE45tIO1Zoax8mZZCAAqSBrwVehw5Djf
	cAFkvGxXvHxa1M5tvW3m9m0K/Rcc69lFWNEIyPrswSvR4izvwtf3MrBlYK4gkO9KTN8J9JmUHi1
	fSU3P3r041Y1W1mhn1yL9WxC9T9g+49F2JeQjHPgL1ohB4mR/JhBXacBBrbIONb1VgHWOi1Bhjq
	49+tmOjPrBp61s8d/xUJZz8LoqnKEnnYq9De2X6m5VFI3n3OyYJ1xCvPe9gwCHX1qqWFvWTKQz6
	kI+FyW7Yw==
X-Received: by 2002:a05:6808:c23a:b0:45f:1387:973b with SMTP id 5614622812f47-4636627303fmr1352710b6e.6.1770823319741;
        Wed, 11 Feb 2026 07:21:59 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4636b0c8606sm1116368b6e.18.2026.02.11.07.21.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Feb 2026 07:21:59 -0800 (PST)
Message-ID: <55db7c09-5bc8-4dda-818d-53130400ee50@kernel.dk>
Date: Wed, 11 Feb 2026 08:21:58 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/5] io_uring/bpf-ops: implement bpf ops registration
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: bpf@vger.kernel.org, Alexei Starovoitov <alexei.starovoitov@gmail.com>
References: <cover.1770818588.git.asml.silence@gmail.com>
 <7ca5070830c022493eaf45948e146f418aceb747.1770818588.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <7ca5070830c022493eaf45948e146f418aceb747.1770818588.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12159-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim,kernel.dk:mid]
X-Rspamd-Queue-Id: D332712593B
X-Rspamd-Action: no action

On 2/11/26 7:32 AM, Pavel Begunkov wrote:
> +static void io_eject_bpf(struct io_ring_ctx *ctx)
> +{
> +	struct io_uring_bpf_ops *ops = ctx->bpf_ops;
> +
> +	if (!WARN_ON_ONCE(!ops))
> +		return;

	if (WARN_ON_ONCE(!ops))
		return;

?

-- 
Jens Axboe

