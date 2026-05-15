Return-Path: <io-uring+bounces-13364-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6CZ0BONDB2oCvAIAu9opvQ
	(envelope-from <io-uring+bounces-13364-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 18:03:47 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A85B35529FA
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 18:03:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1C64B3097D55
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 15:47:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FDA73FF1DE;
	Fri, 15 May 2026 15:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="NEjzoJAr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC0F3FF1D8
	for <io-uring@vger.kernel.org>; Fri, 15 May 2026 15:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778859977; cv=none; b=S1stO5BsezvVgFIdJIaSHUWsq4iAvcDg3eL7XJqXdC1ewlX8lFMR98oy6lg5XJUzbpb+Xidn+DS13ixK/eOL5E/7L4IlBgwhH9GHtqqMDeaVMXfz2woIPpPMDMVTsQHaH8Heo7ENDMlS4u9NuUvT+M0J80OSZCaWzgrmHVi3ymc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778859977; c=relaxed/simple;
	bh=LeaHE+gC1mCUrXQASoxg5zg1wnUSLSEeoi/7LPe9A1Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sTL4jQ14q4CjqG3rFNzKtGSH1YIEasrrAooRRBCW884asKXQupDmBI2YxEIAeLkwqGMu36DDVKt4HD3plzFsHWWfD0ZJ34NtG2LNJagD5PNdsBVDU0ZOhO7Torn+tFnfz9kynP+0RUcj0omAURTEJkX2SWcYWwvEpr5CpXMRQ5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=NEjzoJAr; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-415b23dd6e5so3559860fac.3
        for <io-uring@vger.kernel.org>; Fri, 15 May 2026 08:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778859973; x=1779464773; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Id222wMSLjsZO63ZhosNw0OVQDl4XEooys+lgVTccZk=;
        b=NEjzoJAr/iM4kw46VXvO3bAQSQiWIR5WHVsCiXv9ala/2/OmV0i65sTEJup4KCYIdy
         rffHnH/vKwLgr8mnr8+T8bByISM1WHDlJpyR2M7H2i3VntD1zA5rBimFSkV7aw70aYHd
         B6WMS0DlZpDKnfWppxU3OkOCrnI44nAMRpaTLOBnMGmbmPd5ED0wg+Hug19HVH3Y8X3y
         /qRobKFLv/v/PGpmPPIKiIdh4Ifn9lSdO4aWgfmOc3LM4JxcKFClKZ637Tm8umo8l2NN
         2sLjJWMf9DR03MQCUJlDR57z/96PGQcJN46qt1/7H/yFLev1Jbrn4VfxLrAPAcNO8LWk
         IVJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778859973; x=1779464773;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Id222wMSLjsZO63ZhosNw0OVQDl4XEooys+lgVTccZk=;
        b=f0OPQ8xnnpLCtO9SjaILqSK61v7FUkLA/xKAwjHrIAPJuLJqKCc2Z/5MNrfrULstq7
         Phtz/5Mh27Hi37Xn7rVXcwYv8t0MbordV7XRAXI5LAXReTZja4KyFfJtZkd6/orgmOpQ
         e+RvEV9j/pq/wEgw0XVT9l3fO0IcqCrZ6h/poVkJ0EJdKZHmF+Jsi5tSdukU4rym8zc5
         lWn0tkM51ACH0oNx4hywGqJOjP3IADh0YKMTzE6XUav05XY3JxuiQGGf6+RjuMSDIOY1
         aRqAA7iT1Re5RSzFwZeECK7J+JUopkLa5hcmUjAgtZXeokJegdC6/XfubovPoP+0L4PE
         jj5w==
X-Forwarded-Encrypted: i=1; AFNElJ/bbpHgsq5vlF9L6pjtttvRAqMegoWkxZ2vTiosjD9YjU2/iz5MGHc2DxEBVbwlMo8ea2Wdp/V1kw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxWUf9ubE1sl7IXjlxGq+TSoAeDSpoN3LySjIviSs4ssFs5R7fa
	KvZPJGFjOgwNayDrncdvsi6RYMuc3b2lSAlvOPGuPwdLm5ffpBTChNxJTHYcH567iG0iek8ey64
	1UOlJ
X-Gm-Gg: Acq92OFUwHUAgW0Z3ZoOpg9w8adOyJJSVfzLx/KQDCwSGAhpEi/sVBKgWRCkMWZDU0q
	GN+JDylf9ehHtoCUoqPsPpcgnR0n8Tcatrh6c2z5htynavz1SJhNHO/pozSjZ8dBGZMCKnpwGy/
	4cjvMqiFjB313gMUTbz7ztGhN4zS61KPUmAzpCGn5cEAo5VJD8odwHh59WxoxVbtKBt3/XPgIaL
	sHlbNNmnqD4MfywRieoWK/yep71PxUatbc/T39e0AlnzQYmK9ChmM7Y96rNje1SZmoESwuCywDY
	FvF/J0Y1cS9PhcXJCCHxMhDbJzgLFRlMuD9pnkO9c4fSKPwjG0/hGpBWDLeA/ykuI/yBrRin2nL
	KZFLIm8Hs6/ZMZgHIDXO3nhVoP27dDQ2OWHHFwyLQAyRhJvMWgt+JtRnfHuDTGkqGQqWrrtsRNc
	2qdtuEqRS1ngLlJxlh0OLgx41p3v0bYqXKdiKKEx7OSBUIcwB/uxL+VPgpfEwV1itbI9GReoLo3
	HJpk3/I
X-Received: by 2002:a05:6871:ea0e:b0:42c:2c15:3769 with SMTP id 586e51a60fabf-43a2d913986mr3109010fac.3.1778859973279;
        Fri, 15 May 2026 08:46:13 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-439fc53f2acsm4468762fac.14.2026.05.15.08.46.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 08:46:12 -0700 (PDT)
Message-ID: <0f7e9184-f317-40f1-b366-d8582cb97ac4@kernel.dk>
Date: Fri, 15 May 2026 09:46:11 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: propagate array_index_nospec opcode into
 req->opcode
To: Michael Bommarito <michael.bommarito@gmail.com>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>, Li Zetao <lizetao1@huawei.com>,
 bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260515145812.1241925-1-michael.bommarito@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260515145812.1241925-1-michael.bommarito@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A85B35529FA
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13364-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FREEMAIL_CC(0.00)[gmail.com,huawei.com,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Action: no action

On 5/15/26 8:58 AM, Michael Bommarito wrote:
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 4ed998d60c09c..7b257a03ef84c 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1739,6 +1739,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>  		return io_init_fail_req(req, -EINVAL);
>  	}
>  	opcode = array_index_nospec(opcode, IORING_OP_LAST);
> +	req->opcode = opcode;
>  
>  	def = &io_issue_defs[opcode];
>  	if (def->is_128 && !(ctx->flags & IORING_SETUP_SQE128)) {

We could just kill 'opcode' while at it, and just use req->opcode for
this. I think that'd end up generating the same code, and avoid having
two versions of opcode.

-- 
Jens Axboe

