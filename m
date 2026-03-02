Return-Path: <io-uring+bounces-12512-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0E/sKq21pWkiFQAAu9opvQ
	(envelope-from <io-uring+bounces-12512-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 17:07:09 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id ADA181DC5FC
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 17:07:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id AF21530288FB
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2026 15:57:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6F5F41C0C8;
	Mon,  2 Mar 2026 15:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="zHZDllC4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D07421F00
	for <io-uring@vger.kernel.org>; Mon,  2 Mar 2026 15:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772466878; cv=none; b=nmw4Jjl0qrAhUE3fwyOAdJ0c/Wrea+5Fe+3oSPqEnOOCwxed6/k2atl7g324t7x7tuhrO8OEjNQ3EKz32KCix4ixcKRAfkaj/Z9Y+evSjZFL9asj0VKhPHq8Yi/docJspetEp+JUv1GM5ux1HRspPPSNVDDkWJs+p6G04SmsN+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772466878; c=relaxed/simple;
	bh=dDpcbfDi0yi7fEFTxd12xIV5BQ3X3OV+mFeaeykwVCM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=loAL/vuuJ6NMgpLJ4jfxXhi0Vq2F+h9GAwcOPUvr3INVEOXrALLxMpDZFZ0I1UEq7zPndxR+fLcTZiD/iNI2UBmVMtdNWamaAk+jZm5ZMzVK7uEVbehRGHyV8THuQnOurYo3nrsFx6G/D9FYBUvhaboxo8T0WWzw/N2tM7qskAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=zHZDllC4; arc=none smtp.client-ip=74.125.82.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-2be06a2be90so2286166eec.0
        for <io-uring@vger.kernel.org>; Mon, 02 Mar 2026 07:54:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1772466870; x=1773071670; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vYKX84PLbw1ik011AtUFY/JoiQVlKtt+8d30XwsrbyA=;
        b=zHZDllC4F8vhmIye6X0hKfi9I2znFzlhAdHfhUzK/9PJ1wSMBFVNUcRV2K/Q0E6FbO
         dGSLu/ViHr6mZbr+JxW8NvqoUglssyBfP4LnrZ1BmfutjquEOmST1/7G3ZETOXSA3Z0y
         A4Jidrl15Ex/tcF6Vn2k/gjER8+zmvFhkeNhvoIwCZTIa5GZc16Qbo7QHNFDudOqu7CE
         0ZfH7KVe56T242mitHDwKgrCsLFynQRTJ0MY5TI7EIBEEYNUhAsh6l/UPSPfsESPvRzM
         kdXFOVjBgWDRvAm1jA4hweX9x96FI8oH3LchAe6U58mnQkFtCsbUjkHTdL3Iee3u5Blt
         5C9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772466870; x=1773071670;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vYKX84PLbw1ik011AtUFY/JoiQVlKtt+8d30XwsrbyA=;
        b=AbaHJiv6SbCewRgbsyEgrk502+nj989pHEXPVmK/lAnfDZS/gbK5VWyjQGa2+m8vBk
         dGle3MgIcevhmMBHQFoHoXLVMW12qFLqkE/djrs7qMDHB/geEruWQC2bOxePn8S2AvdL
         Lg3l+wOa4fhQcE39qJ9mX/JNZQGCQOo2oMWeVMDWeco2VEj7vfa4ZORAywuFdJMyrQsD
         JPC9dPHj7mCSgWNACcUj67zzQrjgYK1RhoZKgaMCF3s7YTTCw0jiuMR4qenowHHKt44q
         r2OLrXv/gWmdPUHCvufQT/P3roE1gg2qGqP0nsUc3Jf7s9G2xS2kpC2D2nwtU+pjEA/T
         7t1g==
X-Forwarded-Encrypted: i=1; AJvYcCVySkMfyivT4kf6roXIAWjgCNXZILKgzOMNJWPxVWovKPmtDroQbD8LWnfMfiZjSrw8HYDH7l5fzA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyQF+7QrqsqkpWtezYoQlc/S/xkFY4agUXnhSwM17dG6WQU4+j4
	wSsmrtdxPTukvtIZuH9VNNQUrXr/Bivc30bl4ZkHmMmeWCtAszWTUSkFGZulbR3bXtI=
X-Gm-Gg: ATEYQzz22GzyTmslhS4amHcr6ZQFP24A/B0pAzoEowJ0soaKhgnIo1DRjob/tZdnydW
	jL1EwmEw/bvFurRamfRJLW4GmMoJEWfQWs7p62KpB0AYny9k+idfQ/pT/woEM5BImcuvUq3dUSL
	eB9y920CXl2b8pZ2mr6GaHWuonj+q2dUbnjuL2qermaqma0pYuKcdJiPnHVjDzOx95aG38jn1y+
	MnRwDS8QWpROA2bR/aOMAnuECTK0C3uEtBCumtsF92yqWJ6rhWY8iVSNDGHC0qViOV+xL9pQQeZ
	OCPuTxPTo8S9HOvUGD20yue3lBsbnTov8o7CDZEDhk8zybVDeaZGLWrkKu01UhFRAkTErolgiBK
	ztOhNQ8Btx3xkzTCUvA3ZbnO58IDAbhjAsa0XPcQI5H+DHxaCHexxdCnIiPJ3zDIG4eO1bufGtH
	ELvJxpwYBXBTvyImi//gOx+Y2Cf8BSs2evC+DQkNxcPKmNIqwuJACLcb1tN1FK6a20eVibL20QY
	X47ATMpJfOBkPJStN7EKWuazkMCQUPz
X-Received: by 2002:a05:7301:fa0b:b0:2be:617:2ddf with SMTP id 5a478bee46e88-2be06173268mr2046986eec.16.1772466870425;
        Mon, 02 Mar 2026 07:54:30 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1156:1:c8f:b917:4342:fa09? ([2620:10d:c090:500::badb])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2bdd1a45a58sm10660215eec.0.2026.03.02.07.54.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 07:54:30 -0800 (PST)
Message-ID: <90cfcf06-e987-4817-acba-2037a436a744@davidwei.uk>
Date: Mon, 2 Mar 2026 07:54:28 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 2/3] selftests: drv-net: iou-zcrx: rework large
 chunks test to use common setup
To: Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc: netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
 andrew+netdev@lunn.ch, horms@kernel.org, jdamato@fastly.com,
 asml.silence@gmail.com, io-uring@vger.kernel.org, shuah@kernel.org,
 linux-kselftest@vger.kernel.org
References: <20260227171305.2848240-1-kuba@kernel.org>
 <20260227171305.2848240-3-kuba@kernel.org>
Content-Language: en-US
From: David Wei <dw@davidwei.uk>
In-Reply-To: <20260227171305.2848240-3-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: ADA181DC5FC
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[davidwei-uk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12512-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[davidwei.uk];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,google.com,redhat.com,lunn.ch,kernel.org,fastly.com,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[davidwei-uk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dw@davidwei.uk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring,netdev];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[iou-zcrx.py:url,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,fastly.com:email]
X-Rspamd-Action: no action

On 2026-02-27 09:13, Jakub Kicinski wrote:
> Commit a32bb32d0193 ("selftests: iou-zcrx: test large chunk sizes")
> and commit de7c600e2d5b ("selftests/net: parametrise iou-zcrx.py with
> ksft_variants") landed at similar time. The large chunks test was
> actually not included in the list of tests, so it never run.
> We haven't noticed that it uses the old-style helpers
> (_get_combined_channels, _get_current_settings, _set_flow_rule)
> that were removed by the other commit.
> 
> Rework test_zcrx_large_chunks to reuse the single() setup function
> and add it to the ksft_run cases list so it actually gets executed.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: shuah@kernel.org
> CC: dw@davidwei.uk
> CC: jdamato@fastly.com
> CC: linux-kselftest@vger.kernel.org
> ---
>   .../selftests/drivers/net/hw/iou-zcrx.py      | 31 ++++---------------
>   1 file changed, 6 insertions(+), 25 deletions(-)
> 
> diff --git a/tools/testing/selftests/drivers/net/hw/iou-zcrx.py b/tools/testing/selftests/drivers/net/hw/iou-zcrx.py
> index c27c2064701d..1649c23e05e2 100755
> --- a/tools/testing/selftests/drivers/net/hw/iou-zcrx.py
> +++ b/tools/testing/selftests/drivers/net/hw/iou-zcrx.py
> @@ -135,36 +135,16 @@ SKIP_CODE = 42
>   
>       cfg.require_ipver('6')
>   
> -    combined_chans = _get_combined_channels(cfg)
> -    if combined_chans < 2:
> -        raise KsftSkipEx('at least 2 combined channels required')
> -    (rx_ring, hds_thresh) = _get_current_settings(cfg)
> -    port = rand_port()
> -
> -    ethtool(f"-G {cfg.ifname} tcp-data-split on")
> -    defer(ethtool, f"-G {cfg.ifname} tcp-data-split auto")
> -
> -    ethtool(f"-G {cfg.ifname} hds-thresh 0")
> -    defer(ethtool, f"-G {cfg.ifname} hds-thresh {hds_thresh}")
> -
> -    ethtool(f"-G {cfg.ifname} rx 64")
> -    defer(ethtool, f"-G {cfg.ifname} rx {rx_ring}")
> -
> -    ethtool(f"-X {cfg.ifname} equal {combined_chans - 1}")
> -    defer(ethtool, f"-X {cfg.ifname} default")
> -
> -    flow_rule_id = _set_flow_rule(cfg, port, combined_chans - 1)
> -    defer(ethtool, f"-N {cfg.ifname} delete {flow_rule_id}")
> -
> -    rx_cmd = f"{cfg.bin_local} -s -p {port} -i {cfg.ifname} -q {combined_chans - 1} -x 2"
> -    tx_cmd = f"{cfg.bin_remote} -c -h {cfg.addr_v['6']} -p {port} -l 12840"
> +    single(cfg)

Let's use ksft_variants() with both single() and rss()?

