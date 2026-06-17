Return-Path: <io-uring+bounces-13765-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id pNy9Azm+MmoW5AUAu9opvQ
	(envelope-from <io-uring+bounces-13765-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2026 17:33:13 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 57EDD69B068
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2026 17:33:12 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=AjjFp2Ah;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13765-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13765-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 14B2832A06B1
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2026 15:11:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F53E264FBD;
	Wed, 17 Jun 2026 15:07:32 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBD52E7F38
	for <io-uring@vger.kernel.org>; Wed, 17 Jun 2026 15:07:30 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781708852; cv=none; b=brXNRhCg5pdrkAwIJvU5K43SxygjZRtInc9L60hD1bpbMTqvmnmBGsAYD7E5wTSpqjZlX6LGJd940S0aJ+PbTDGfUxcq/+r3/0tFxO7wTDPD0nxawd39hEDTL8gCEPvZwBiFPRrXORBf1PaIzgJZKatuDRRqX7gJDBu98JUygXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781708852; c=relaxed/simple;
	bh=Hup6bQtV+sI6+eYnihssAlmn/NHHpxKAT0ZKeU40Brs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tgz+DMQ7eUD77sFTt8rK88EpVZq0OhH3OCS7QnQL+C+KP+9QLXGnyIqEL2agitiVgqW7bnFT2+4qZwsoRQqCfqLQbhGM6gmG6HkfNKZFWLhJ3r1vgM8XDNIFCDSspYk7GHtA+wEdF41Dj+al9XejmS92qKwFz3hJRsEM5qcdq4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=AjjFp2Ah; arc=none smtp.client-ip=209.85.210.48
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7e6b5c374e5so1067747a34.0
        for <io-uring@vger.kernel.org>; Wed, 17 Jun 2026 08:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781708850; x=1782313650; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VTqgRSDM50GdObxPKaJS7hQCX2UQLatSq3fVImZdhC8=;
        b=AjjFp2AhPDfsnKp3HRzjoa0dFZt/nSjQN/Az2qDw1I2fv6NUsR9pWk0cQNdMSNoR2C
         KkubH6gX0Tk7KBORsJ/Y9Z9leyLgUD3pgMZFmkgu/BHrhQxT5xsyJS+UyDMDJtRWNdJJ
         G8oSqNcEER7i98My2zV7Sr4E4p2uwSBTg4rzZBGl8+oyDgY/QW0mybsbtUXmtSeS+8KY
         JMhscxM4bAWSKgbEuKwUolsxXLic4Q1j29jNbWaiRdrrb+nfutlCQ9eF9RBTGHKw/7Hp
         yAi4gg0vxeoZPF8EEQQqqD2QOnUyMvGAaK74DuD7e39MVvJXanDfKQPLxw7+fQlzKalS
         nvJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781708850; x=1782313650;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VTqgRSDM50GdObxPKaJS7hQCX2UQLatSq3fVImZdhC8=;
        b=A2tRr+ROA5F2/MXRm7op8NJgf0ASEtKUaP8cUkCpn9stLsZfgENfZKObj1rf3ZYuaf
         sAqablj725Rztly+tRXWz1oPEm84y+kMr8Rc6c9B+54QW7mjpfbbyTHW/aQRf5XxGcfn
         E77a68Ko/7nZgReprwbuNl9LLurt87N3hL5OdgxPMShcMQPUq/bVdem7mMYCYiisbBGz
         yFJGHIzHSJqQtOia6ojUwqnM5A7FkHjX3MK7qPJcPt0mAnb6lzSVvv2/hG+M7Bgd70Md
         +ropifIr3uI4AmjwOEA3Vg69Ije9wBUm9Ncn7xubYb6DeJ++hzNOSvqMGCN02y89bi+c
         vXAA==
X-Forwarded-Encrypted: i=1; AFNElJ/PqOfj1Gtyc/f6eevzYS8LJ6EcF9fQcqs91nrfMkgNolk42F1SJ8YzJLgE/Ljxzm8pYxVPUkS+zA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0mnxKcByrqnCOLfR72Y79nY0t8rVhNTlB1T/v5MSbXo14Meuz
	G+XEA45+dq56ypmmyNFXPKC3OVXu7CVpzT6rsKAMl2DUm7yqMp82vlc2C/AmMv0I4wlt6rlByCS
	uMFjXz8E=
X-Gm-Gg: Acq92OGgxaPAS0wlruv11J+l6SToGzO8x4uLK7dVqQIlf22PzWfIF30JqEK4NFxEzJ4
	aXTANv4tc17LCHJkdaF4l4Mx65grdmuExqa4X1qQBhNZLhFOksFzl/fzZmnZ3kzTxutlg9y5fqg
	scYQKGfMG6w5Jkf2l/qrPHxVsBGXfDOdGV6n5y97cKzSji7tx9Laedlehlxrc8MZun1QFtYLsAM
	mX06MvFanKr1qeT5YB8WmyGiPvUiAiuqnF2pYlBfh62RW6SccbmZaz0+ALR5tD35NiHxhCvj8Zf
	t7jxHH6fzCFjgcK85K8W+t8GTfGyxGEvD2qMxOkKmPYq5XaKDP9ymqs6WCE44HouLGWHgKN4+j8
	v+S2d9YkPTPp4KnvwLWVNeQ9uc49XQwoXVuZg1qjKUHwDrKBSOmiH5KUkT7fXjKlIqyWlDxBdt/
	e1SDpkXRV+hEgNsEVxbOdJH7MsoMmFVqSAKHctVEzcSm6KFfruIQ==
X-Received: by 2002:a05:6830:380e:b0:7e6:50c4:e954 with SMTP id 46e09a7af769-7e90e107315mr2450645a34.11.1781708849876;
        Wed, 17 Jun 2026 08:07:29 -0700 (PDT)
Received: from [172.19.0.220] ([99.196.128.98])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e79f5a11efsm9482951a34.1.2026.06.17.08.07.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2026 08:07:29 -0700 (PDT)
Message-ID: <870ac7c0-a521-45b0-ab0b-fed5f97a319f@kernel.dk>
Date: Wed, 17 Jun 2026 09:07:19 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/net: fix netmsg_cache iovec leak on BIND and
 CONNECT
To: Yang Xiuwei <yangxiuwei@kylinos.cn>
Cc: krisman@suse.de, io-uring@vger.kernel.org
References: <20260617025348.1301777-1-yangxiuwei@kylinos.cn>
 <20260617033035.1373691-1-yangxiuwei@kylinos.cn>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260617033035.1373691-1-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-13765-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:yangxiuwei@kylinos.cn,m:krisman@suse.de,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,kernel-dk.20251104.gappssmtp.com:dkim,kernel.dk:mid,kernel.dk:from_mime,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 57EDD69B068

On 6/16/26 9:30 PM, Yang Xiuwei wrote:
> Hi Jens,
> 
> Please drop this patch.

Haven't picked it up, nothing to drop.

> After rebasing on the latest io_uring tree, I noticed that this issue
> has already been fixed upstream by:
> 
>   3979840cd858 ("io_uring/net: Avoid msghdr on op_connect/op_bind async data")
> 
> BIND and CONNECT no longer allocate async data from netmsg_cache via
> io_msg_alloc_async(). They now use struct sockaddr_storage directly, so
> the iovec leak path described in my patch no longer exists. My fix is
> also incorrect on the current code base.

But then we should probably mark 3979840cd858 for stable, then? Gabriel,
can you take a look? Currently traveling...

-- 
Jens Axboe

