Return-Path: <io-uring+bounces-12900-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kMA7BdfYy2kaMAYAu9opvQ
	(envelope-from <io-uring+bounces-12900-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 16:23:19 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id A7D4736ADF6
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 16:23:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3A2213045C14
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 14:21:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC3DB3D7D7B;
	Tue, 31 Mar 2026 14:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="irmZG6KO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744943E958F
	for <io-uring@vger.kernel.org>; Tue, 31 Mar 2026 14:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774966882; cv=none; b=sjUX9g9I+dUKZ5kg8P/Gbj/YECO03iBq1ArvSZH7RnUK5HHjXtJbREc0k6Hp+9JK4FDf5CBa5ctxxC8Zy+3EXvSITd2giiXM+GADrRRWjukJuh3ZZjVGokZomjIbk5cv/wMEjhYeoPYavOzkVpXLhHTqwR0FKjhcDAy5cLn+IXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774966882; c=relaxed/simple;
	bh=SOSRtPDNSO8JH8QIMZ/LnU++kds61yIh+oeojl7bWpc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=g33PxsXXQBK7VuD4Qz07qmM0aDW1YAWVyFQrdFPlDlMNVhVpnnVStKoGCgvGOwKw+6gmeOusgxgCIaq30Ue49xJJSrbxvIZM4iIcrO09UoEFTo4Kgj16VWloDuhJ1pFi6ruDx2hylwirIVnvBAYT9LwjV3Y2UCCTOFNOzeft6Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=irmZG6KO; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7d4c12ff3d5so5529798a34.2
        for <io-uring@vger.kernel.org>; Tue, 31 Mar 2026 07:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1774966880; x=1775571680; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9KMM5K3KSx836ZMreWjO549fXqRM3bm95gx4gAnhC9o=;
        b=irmZG6KO9K4bC6NWekDoyfRJd+RgN/J8Ebq5p8LSzAdjTLywNpntSPezRJWL5YmjjL
         4syaRCRQ1+Ow1o3PjKOQO8XO+66mS4bF2OhP15GY/zkpTVEn8y4GjOSetm4S2pkQzejY
         a8rn3DGFYuqF9QRwT7MFSs8OsGOwOwtXwSKGBWnCd15q0ReCIaHmx58YmhAvfH3BrKqs
         HLfIhc6ZfsQiENElH7APxVXgyiVbf+OYPFRXZPceJuXxMS134ZGQHszrIT0uFs1UFr3/
         yx0yuNeusVWQUSMMhjcSO7qNSECAHjCT+cKTWrLUhNwqXcQ+iD4Rjn1j1wExWbpldYFs
         fhmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774966880; x=1775571680;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9KMM5K3KSx836ZMreWjO549fXqRM3bm95gx4gAnhC9o=;
        b=n7ijXRXn336Yx7JT3vw2y/RA4Z1nI+mL8bymnFQgrsMKSG6rdbcxcpL1T7v4hRvoiu
         0GVdadqbJn0iAcnYwOR1IBFIUa2yC3S7dkdAGuCAff28hpl0vD3kwJZyDZVtj5Da1P6A
         Aju3Blcu1Gv1vjijpFvfuzmcPowaSlsYxzmLm+aXWf0F+Lf7ubSCJU7WDPyBAcbNMFcE
         i6zcx/Z/NDYgTpTBFwEsWqPmK3kZfbQApy17wpLhyl1u/3abMsdLNhvs1D42yNCp4BrK
         1ccQwbuHV0+h+OAWeT3z6RiWAbEgpUiRmwOoZT66yqesa2OcE1/nNH0yglgrzv+eFDkM
         JMbQ==
X-Forwarded-Encrypted: i=1; AJvYcCU9sFSxee3mw/JtJgXfZAApl2hMxxqPH5Rzwv1AMmWs9lT3QgMWsbjlGa/XUxyvPQZsjit66AS7VA==@vger.kernel.org
X-Gm-Message-State: AOJu0YycITd3liKJmikwa+7KOvwXmyR2RbxQS4fTics3tRDWPkdPhQ68
	AEUEYVpFfOJA+onat9cgocbSE1BtH3syz8YOOdCiI093RmQE+NbeFOfscxOubvZgGdk=
X-Gm-Gg: ATEYQzzBr4pUHUu9yW7QJqbbR9NsFkgowPYdOSx2M8pAWRaRCj/M3FCabWDHNEtiecV
	bZ1fU5pw1v7JAlHJrqoTERCFaCrf0SdcyB8nh5VkZ5v9I0uWJFwULDXQ1Pmah1JW6B/KzTFOzhL
	ysBcevG/YU+9vM6VYP4lSzFZ6OeXgeKar/0qFtgLGKnlTGMWHRuFNC3aeaHC5bVwG9/yCSgB6HC
	0mDodHlaIDNtUi5RX1apLnWhnMBBtREEqA/xH5dtddAOHF58oLKzaEr/Ib/WGmCAmMnbUFrexgj
	Vk5QTWFFXcqAumKedj/tthmgKJACHVQX2N1akyk/xzh3KM0jN7LYRvCUy+yLuv3aKJfRBe7N2xV
	L+0IEserr2yLBqHhc/D5J2I2tF5rUrrvakvUzB85Jws+PdUooUTT4j0mSoROXhi5wTzV9c7xHbs
	Tas1VFvOnjAogt8E9r0ea+cuJI5PB5k6+7kxjfh5OKWTGvyNwGQ/355VQJjPwxsSQxpFSoZveZc
	jOphGgMA8icdB/ey5pr
X-Received: by 2002:a05:6830:6509:b0:7d7:5959:946f with SMTP id 46e09a7af769-7d9fad710d4mr8964047a34.7.1774966880061;
        Tue, 31 Mar 2026 07:21:20 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7da0a821746sm8842974a34.24.2026.03.31.07.21.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2026 07:21:19 -0700 (PDT)
Message-ID: <8e452521-4186-42bd-b1c9-b83c22c1660c@kernel.dk>
Date: Tue, 31 Mar 2026 08:21:18 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?Q?Re=3A_=5BBUG=5D_WARNING_in_io=5Fring=5Fexit=5Fwork_=28io?=
 =?UTF-8?B?X3VyaW5nLmM6MjE4NykgdmlhIElPUklOR19SRUdJU1RFUl9CUEZfRklMVEVSIA==?=
 =?UTF-8?Q?=E2=80=94_confirmed_on_7=2E0-rc5_and_rc6?=
From: Jens Axboe <axboe@kernel.dk>
To: antonius <bluedragonsec2023@gmail.com>, io-uring@vger.kernel.org
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <CAK8a0jzF-zaO5ZmdOrmfuxrhXuKg5m5+RDuO7tNvtj=kUYbW7Q@mail.gmail.com>
 <a85f11a8-7014-4b01-b35e-69974319f425@kernel.dk>
Content-Language: en-US
In-Reply-To: <a85f11a8-7014-4b01-b35e-69974319f425@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12900-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,googlegroups.com];
	TO_DN_SOME(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.994];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: A7D4736ADF6
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/31/26 7:39 AM, Jens Axboe wrote:
> On 3/31/26 7:32 AM, antonius wrote:
>> Hello,
>>
>> I am reporting a kernel WARNING discovered via Syzkaller fuzzing of Linux
>> 7.0-rc5, targeting the new IORING_REGISTER_BPF_FILTER subsystem (new in 7.0).
>>
>> The bug is confirmed on both 7.0-rc5 and 7.0-rc6. It is NOT fixed in rc6.
>> In rc6, the WARNING appears to have changed from WARN_ON to WARN_ON_ONCE
>> (fires only once per boot), which may explain why it was initially missed.
> 
> Interesting, that's why I added those WARN_ON's. I'll take a look
> at this.
> 
> And yes, they would only fire once, because are WARN_ON_ONCE()...

diff --git a/io_uring/register.c b/io_uring/register.c
index 5f3eb018fb32..837324bf0223 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -178,9 +178,17 @@ static __cold int io_register_restrictions(struct io_ring_ctx *ctx,
 		return -EBUSY;
 
 	ret = io_parse_restrictions(arg, nr_args, &ctx->restrictions);
-	/* Reset all restrictions if an error happened */
+	/*
+	 * Reset all restrictions if an error happened, but retain any COW'ed
+	 * settings.
+	 */
 	if (ret < 0) {
+		struct io_bpf_filters *bpf = ctx->restrictions.bpf_filters;
+		bool cowed = ctx->restrictions.bpf_filters_cow;
+
 		memset(&ctx->restrictions, 0, sizeof(ctx->restrictions));
+		ctx->restrictions.bpf_filters = bpf;
+		ctx->restrictions.bpf_filters_cow = cowed;
 		return ret;
 	}
 	if (ctx->restrictions.op_registered)

-- 
Jens Axboe

