Return-Path: <io-uring+bounces-12502-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WH2iBQOKpWk4DgYAu9opvQ
	(envelope-from <io-uring+bounces-12502-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 14:00:51 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F1F81D959C
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 14:00:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D90B0301FDAD
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2026 12:58:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47D6B36C598;
	Mon,  2 Mar 2026 12:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZHCECwYM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5CE3B9616
	for <io-uring@vger.kernel.org>; Mon,  2 Mar 2026 12:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772456323; cv=none; b=m7Rj6Dr14fOli1eaWpHJSuTlc+GmbEvLHAipbA+LDHb7sULHJz3esmMONffEIF6OFMkn1BKqCrVrZErZWx+qJeAnonDXhjuifb5Ix4BRvrqvZyXwKJFoXMnIYuZkAjTz1d8v1Elzo2Euish/mC2zVsOpo99L+wdLU/7cva1/tbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772456323; c=relaxed/simple;
	bh=v4zPAM05rGLONHcYnMa5Xn8SsS1qvZ8KlSBUMRk66ZM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D+dAArVFG8akTc1aC4TPG9rbO4Mnzx5pqLdeRozB0W/BhA0mWechVy2H935J1UNwNaUvwesDyuV7vDIx4rhvhbzJFmCARH306AgoSUS9pVaWtW+lkLVvGMlZMjVEsixzKKqBwaFl7QcmvgN0efWQanKuOnGLdC4pwsZ7OkqaJXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZHCECwYM; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-48336a6e932so27704205e9.3
        for <io-uring@vger.kernel.org>; Mon, 02 Mar 2026 04:58:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772456320; x=1773061120; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iwsfcpaPA+sBM/Dsqy2PkGNFVaNFvip5lRHhomQWQuw=;
        b=ZHCECwYMO2EpiL3bKk6VGNReEi1fniaDPAt76lmDluabJOJn7k6iG6ZwlFT/tmqNvl
         X89Cg2/qWn7BqViNns83BzQbSnd6sCQrP9yaeWlrI5bS2UvSjN9695jpabbl49CNVHGn
         N7xUN/Y1O/IVAOCAJZLFdQBsYHyP6fOdEagBsj+UTHExCpmct+ik8gtMvGniTLGyunA0
         jzK+RNYCQ1RdEoBq9azR6G5sgNgMnSdQ1riuhegjVJ0gseMIeklPkCbwIPL7zYH3/LRs
         BJ93VsbEgfSiogq/6G0ADwtRf4jm9XO1XSIc79CZ67FPKyoQ3ejV8U54EDh6PAVo74MP
         cAXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772456320; x=1773061120;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iwsfcpaPA+sBM/Dsqy2PkGNFVaNFvip5lRHhomQWQuw=;
        b=uitqjRkom6GMLzQvBO0yK6zaNhu/TNCwukW+jzJHNLoqoYvxPTYYx9GhMeYdEh1OnW
         gKJk8hu57WbIgH+LChKby3F7kh22r1Yf9AfnLz6XwakXirZF8sL3L8BANeOq1I6Uo5Ms
         Kz+DSGX6ljVFbCemA637ldSF3/1mY4srOjJCeUBJon+PusESTmiJ2IpviJXW0qAPblHn
         0uhz9Y9LdRIaLJFE7dRVwogC9D/kH7ctlsDx+H7DY+H+RG/3hGdfG+zjqAQQXi/MgO0d
         HqU4CJ17ERORd6qhI/aZUig8cAxtRxmzsJAb+bGsoyyaAvJnrrlyN/yKrTXDOMJmg1Df
         AMUg==
X-Forwarded-Encrypted: i=1; AJvYcCUZl/JCKLcw/0CD3H/XcIWsRPJhYbF8OqdGceSm7fLBIG2d6/MFB0KBC05KAAqeB93MqdQZI8+UGA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0B7hI4tHs2s1SxTbq6Q5u512OglTL5VxSzomlKwmYafeu+DV7
	ZQ1/32beBDWFwOeMmWtoBvUTszrzWpxXsMRwXH7uRzmY66e3iaiXP3gs
X-Gm-Gg: ATEYQzw4pYQKQhU1Sz7n1WlOQsiiASge5v0x1bt68siEp9OwDN67y2stP6OZb5X2trq
	uOlFO/DE21NO6Jzbiz+MrHryhqGKOCEDV0+bmvmJTMB6/y5wYDArwEVvy/7gn/EN7/+QNHZLblD
	TALKbM7Yw1sXz+1PDCo2oGfJGy8yy+jTaWCkd7k0ngn6UjnX0EmnqwvNG+I7jCaX5rJT/CEG22q
	wSfKZvzTgei+PHaoSVSv9pvkyMXXtbytXoIzfebq6MwpxlSHqHohNfkA3MvHKvQCjppOL7/UOox
	tThKv9EBM7AwRqSh/ada0tbLaKynnz0JiAdsDGqf1iq4+8Rt/8MCindvHbgfw3VQgdlkO+WQuxV
	1V37lBEuC4CI1lV1jfZ/6+XZTrEm+6lwfvbE7ZrDQZhiSPLUXGcrAolND5MvIbNpSswyRlKoZMN
	TT3Sn1oJLgXbHlCylRAWakB30GNH73mBNbdiEJ2mlCCvxr0RBZex507pG2Kq8RpaW3OXF2GqxLf
	5T5XmWPelfKl/7WP+sTSopTzj0mZeMJWrFh9U6/8/cdAWHdo/7PJAqivyY=
X-Received: by 2002:a05:600c:8711:b0:47e:e20e:bbb2 with SMTP id 5b1f17b1804b1-483c9b970a5mr196432565e9.7.1772456320028;
        Mon, 02 Mar 2026 04:58:40 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:cad2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bd702e7bsm452277675e9.5.2026.03.02.04.58.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 04:58:39 -0800 (PST)
Message-ID: <5271eff2-1562-4a71-be3c-ac0350670101@gmail.com>
Date: Mon, 2 Mar 2026 12:58:34 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] io_uring/timeout: immediate timeout arg
To: Jens Axboe <axboe@kernel.dk>, Stefan Metzmacher <metze@samba.org>,
 io-uring@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>
References: <cover.1772015321.git.asml.silence@gmail.com>
 <6151302f1dc01d1c4e3176da50ab4224947b709f.1772015321.git.asml.silence@gmail.com>
 <3ae98749-590e-4f8b-a835-c9a15d7866c2@samba.org>
 <a6cbceb5-2065-42ff-bcca-bdb1c2443b96@gmail.com>
 <1cd9a071-dc93-48d1-81c9-24b65e65e8bf@kernel.dk>
 <dcb21382-36a6-4d5b-8e79-66290e522f2c@gmail.com>
 <2daa9b01-d989-4922-b892-e7f3f06297ac@kernel.dk>
 <cc9ba4b8-88f1-48c9-8aae-fe30a6b5c282@gmail.com>
 <e834eb01-6cde-4249-a797-ed1fd9f8c713@kernel.dk>
 <2ab205f2-fd87-4fcc-9c0a-0bdebbadeb58@gmail.com>
 <3a8e5738-b417-440a-9851-b8ecc2a82b82@kernel.dk>
 <11058b2c-55b2-4a4f-8d80-7533211b16bf@gmail.com>
 <b4c878d6-dcca-421c-a722-84a1fc77a1ee@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b4c878d6-dcca-421c-a722-84a1fc77a1ee@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12502-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1F1F81D959C
X-Rspamd-Action: no action

On 2/28/26 13:44, Jens Axboe wrote:
> In the spirit of not pointlessly arguing this to death, how about a v3
> that includes the ktime_t conversion?

Ok, let's spin v3. ktime could've been on top, but since you already
dropped it.

-- 
Pavel Begunkov


