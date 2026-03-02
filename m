Return-Path: <io-uring+bounces-12511-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +IiWFXixpWk8EgAAu9opvQ
	(envelope-from <io-uring+bounces-12511-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 16:49:12 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BD55C1DC28A
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 16:49:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id EB88530059B7
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2026 15:49:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2471341324E;
	Mon,  2 Mar 2026 15:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="uj9wYsAM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D223A411603
	for <io-uring@vger.kernel.org>; Mon,  2 Mar 2026 15:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772466549; cv=none; b=oCHSRBRkSejdQ2Hcg7khWPB0zWCk0xW9PbOAkVCsFBJYNBBbT+0n/ENmJOnaXlneRTITfaHuK+N003dl9Wq9nEXDzm0c11uqLFc6kq7krZKEytG2lY/VUXG/48Q+db78yenPYhzBe6SwsSz+pxnDKZ9FSahSrkxnXFKPjLdC8xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772466549; c=relaxed/simple;
	bh=GmZVrQsPKyO0mE+7f3nSOvSJIW9k/uVI5rYijR2wkjw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vd8QwsRj5EOVrOAS5I1niDtciKLH5fsX/IG9N1Z/JaDBq0vd/HMcBFMsCbzpwFT42bBHSJCO6HzQ6EfxVE7P0WoX6ypt+OkzwiwRN9qqo1mzUaffVRvEXsWxvLbTvdsTlhrAB1dLSSkngKSnPUtWntKAMM2DZ7u4NSSGf7htGX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=uj9wYsAM; arc=none smtp.client-ip=74.125.82.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-126ea4b77adso5865551c88.1
        for <io-uring@vger.kernel.org>; Mon, 02 Mar 2026 07:49:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1772466547; x=1773071347; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hKcLgp4ecTYImMNgqgWm4N1laI6U5+FQMPbSa6L123Q=;
        b=uj9wYsAMTqN4Orqw1jAf0xMIBj/akw7Kueq6HOwpTdyvUcSDLQ6Ao5U6WcDy0T15BW
         kMQ28DwarlYMF+PkuI2ITSxkxyi6+3n8B+ePLFfCvvmM0ORywI80MgV3rNuc9NhKibGt
         eVknKfjkd5Ciz8m051nWFI65NBh2NXkZqV+nEIeAkf52ftrjLMr4MSzpM+6y29noRj4q
         5HcZm3qQbWI0ig24BfyzmixGYCm/usuzbjNq0FAUrgUZvqFV8xyXrm4PE7nl2te6bIM7
         8Sa/J2PndioGfHmROC/M1eopLDZeLxMvcdjWNdWJ5LRU3paCXqyHVVWRogYqy2s75wu8
         SRvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772466547; x=1773071347;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hKcLgp4ecTYImMNgqgWm4N1laI6U5+FQMPbSa6L123Q=;
        b=FoemFkiutzM4StPi+q3USSAatMchB2P9ObhrpnC1Wy13LBNzqKt8BJ+KQDAtNcJuxH
         Tid541w3YaLyNN8p3dcMlBI+IHvqm2rnIRDrEFmh/waVyzAjcLBkvRtLgH/UZjw8dR06
         V1fSwYUxnVMIWM6o4icKmWvC5vJjlPgAJ6iuO+ASD2vbPTbGkamUDnsR3laaqLEsc2Ke
         Cl6nE3Tflhdn+ZHsxTFHY1ehlhwbiQ993fyzJWNHfeH2gFRO7C5OAJT64URNvTLBe5sm
         PEpkp+crbz4kgw68vK6QDwQPUgHQXFGVOLOq8WEyCQqOiD8zuZ+FHxzjHFBu+7mDn8z0
         tL5w==
X-Forwarded-Encrypted: i=1; AJvYcCXwcn4xajMqwy4QLeqUvFUVIYKg3cCLan/AddyeeWirhMzyfAgFSiizfJ2HHZwHa9Qx189g2RPa0Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YxPjHjO1pJO/SbJND98qXGDFxEqTOLhQtvpSX8wpVduodfyOQRa
	Es8hqx4AMR9waoSEPjCXIAu9fCzQBUDmzHRqtgAo6WxDhDXTSERXFmnIqG7OQJC6l/w=
X-Gm-Gg: ATEYQzwWEbX8+nW9vmWVSh2QFN+gXDng4BzysMj9IN8pn6FK7HmP9Cc495Ida5YVJZy
	NrGVj25gMA+GTOmKHGaLTe/rxk1wMVzt3pQDZQyPpMKkYKwCib9IrNirhN9LxXVXFXlNpgWyp9u
	ru1vCX/OBhPjSQRD3GA2LMppY2/0XRfctN2MTzgYbY93axnh/avavvtKIzmeMPdcLVpZFM6ErKr
	W8ryqSL0eeRPOOJZlRCd0VqkLzVAeoabuZj1FshxRNyoBdyuPsXv2Fdb/OGFzDVAUbj8wknQF+q
	7C8d6RuFf6FxcllecY7pQkMj9K8LyTxMH7TNb+8wHlWFpV9JZNB47pFL3vFpJXsIViBwS0lOtaM
	pk8X7RaIcDgGlWjcRqqfUigNQ5tnkQxzhbITYnTtrA6EremhBR279eKb+bAqyiUMn19TNTbxdkc
	Oa1TN/NEeLVcMaeDUHNTwYyCytELratkU7CKiR9BOfcsFQDeSM2Vth/2miEVPNkyem79YVrFneW
	2dKLUx29qcSPVFfJY5e5w==
X-Received: by 2002:a05:7022:f83:b0:127:366c:8727 with SMTP id a92af1059eb24-1278fc915a9mr4984202c88.40.1772466546711;
        Mon, 02 Mar 2026 07:49:06 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1156:1:c8f:b917:4342:fa09? ([2620:10d:c090:500::badb])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12789a32dabsm16392875c88.11.2026.03.02.07.49.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 07:49:06 -0800 (PST)
Message-ID: <8489fcbf-ab76-48a9-a21f-d7f6873b9a2f@davidwei.uk>
Date: Mon, 2 Mar 2026 07:49:01 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 1/3] selftests: drv-net: iou-zcrx: wait for
 memory provider cleanup
To: Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc: netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
 andrew+netdev@lunn.ch, horms@kernel.org, jdamato@fastly.com,
 asml.silence@gmail.com, io-uring@vger.kernel.org, shuah@kernel.org,
 linux-kselftest@vger.kernel.org
References: <20260227171305.2848240-1-kuba@kernel.org>
 <20260227171305.2848240-2-kuba@kernel.org>
Content-Language: en-US
From: David Wei <dw@davidwei.uk>
In-Reply-To: <20260227171305.2848240-2-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BD55C1DC28A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[davidwei-uk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12511-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[davidwei.uk];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,google.com,redhat.com,lunn.ch,kernel.org,fastly.com,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[davidwei-uk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dw@davidwei.uk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring,netdev];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,davidwei.uk:mid,davidwei.uk:email,fastly.com:email,davidwei-uk.20230601.gappssmtp.com:dkim]
X-Rspamd-Action: no action

On 2026-02-27 09:13, Jakub Kicinski wrote:
> io_uring defers zcrx context teardown to the iou_exit workqueue.
> 
>    # ps aux | grep iou
>    ...    07:58   0:00 [kworker/u19:0-iou_exit]
>    ... 07:58   0:00 [kworker/u18:2-iou_exit]
> 
> When the test's receiver process exits, bkg() returns but the memory
> provider may still be attached to the rx queue. The subsequent defer()
> that restores tcp-data-split then fails:
> 
>    # Exception while handling defer / cleanup (callback 3 of 3)!
>    # Defer Exception| net.ynl.pyynl.lib.ynl.NlError:
>        Netlink error: can't disable tcp-data-split while device has
>                       memory provider enabled: Invalid argument
>    not ok 1 iou-zcrx.test_zcrx.single
> 
> Add a helper that polls netdev queue-get until no rx queue reports
> the io-uring memory provider attribute. Register it as a defer()
> just before tcp-data-split is restored as a "barrier".
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: shuah@kernel.org
> CC: dw@davidwei.uk
> CC: jdamato@fastly.com
> CC: linux-kselftest@vger.kernel.org
> ---
>   .../selftests/drivers/net/hw/iou-zcrx.py       | 18 +++++++++++++++++-
>   1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/drivers/net/hw/iou-zcrx.py b/tools/testing/selftests/drivers/net/hw/iou-zcrx.py
> index c63d6d6450d2..c27c2064701d 100755
> --- a/tools/testing/selftests/drivers/net/hw/iou-zcrx.py
> +++ b/tools/testing/selftests/drivers/net/hw/iou-zcrx.py
> @@ -2,14 +2,27 @@
>   # SPDX-License-Identifier: GPL-2.0
>   
>   import re
> +import time
>   from os import path
>   from lib.py import ksft_run, ksft_exit, KsftSkipEx, ksft_variants, KsftNamedVariant
>   from lib.py import NetDrvEpEnv
>   from lib.py import bkg, cmd, defer, ethtool, rand_port, wait_port_listen
> -from lib.py import EthtoolFamily
> +from lib.py import EthtoolFamily, NetdevFamily
>   
>   SKIP_CODE = 42
>   
> +
> +def mp_clear_wait(cfg):
> +    """Wait for io_uring memory providers to clear from all device queues."""
> +    deadline = time.time() + 5

This is potentially a very long time to wait if code is buggy, as I
found out when debugging netkit queue lease. How about reducing this to
say 1 second?

