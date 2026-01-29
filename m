Return-Path: <io-uring+bounces-11974-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CGIJBfnAe2k9IQIAu9opvQ
	(envelope-from <io-uring+bounces-11974-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 21:20:09 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DF1FB434F
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 21:20:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E11B93005321
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 20:20:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A945A338925;
	Thu, 29 Jan 2026 20:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="isaIPkuq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F09E34EF13
	for <io-uring@vger.kernel.org>; Thu, 29 Jan 2026 20:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769718003; cv=none; b=DfyDOTg3spSfekmDh9IQx57ByFJc+mbhIdbElcPoSYc7bUcoJGM43I3GjpfsDDGYCIOehEytiR4PyvKIXsfbaHnpfXHKCNjHluUNK1a+IQeXxV6MG8bXZ+Wicuopc9Azs+J67Gvyq3Au5+LJ+5hvUB35D84BzdOdhiQ1RHtqZCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769718003; c=relaxed/simple;
	bh=w3cRqb8uPgYdOD6Mhn9DsGNTC/D4Rll9ZnB/czavHkw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eyTL1gjKOzAZ2SQsXuNMgNRsL2+sNXzWLQ5BZ+vIsRJlmL4dsFA8oG4mgI0wmQcu+OF7ssrUFqrJlnGGtsLDrD+CbyO9wv51OjqNqW5DlEqGj6MHloeTtAQaQgBKb2CXm4dlGc+BBtV8brVQz4oBzE5fZQXIbxWL8GDPuhEOB1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=isaIPkuq; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-45efde72438so918699b6e.3
        for <io-uring@vger.kernel.org>; Thu, 29 Jan 2026 12:20:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769718001; x=1770322801; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XU2Xdv/MxlViElM6mjsISUR+6xcqbps2hTa4KB0BoAU=;
        b=isaIPkuq0QHNVLhvWed2HFNRZoNT2F7/vCVsrUZVMEB4XtmEmcz0/Bu9mPCLiix/6B
         wHb2qyBrGItIyGNuiFDlLQSSIP5kaGyogsK/c+hgfdEFZczZ/LtNPHcF30IzC3B26tEx
         U2TwPx71yQ3pDyw69EfVX+LnzlivG5vuziYzH+d2Tyyd6XjsWT+THcPTIbzU9dGpc46T
         Z+Spc8fKsA9kKDe01ywQPmfHfSaKeTLXwrzC1oU8jMB/SoHkbbLhYwrX+Y/aLeAga9+r
         Msc5WuqHhuBhSB0ejvWVriAzF4stQXvllpdX5TRg8LVNGWhafQJLE95PPgMsrLm+vlVj
         Gt6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769718001; x=1770322801;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XU2Xdv/MxlViElM6mjsISUR+6xcqbps2hTa4KB0BoAU=;
        b=AAxPe43ZOK6DH8LB3JEulSxq2uIImE/fn0exCT4CERS5IxprP5vJMbnI36U6W/cRBn
         JZsuAXEBfczQckS1v0n9qJqehxRzfO/sxrR3ffEtN0cJNvLXOHl4kBUnuavg+IxqZoCb
         F86n6vbiXD9KmtrN+LdrPXnDKq0EV9BlUfyJTZU6YJPa4ZX0G0O9OA5DSmVOuEzefdZN
         o+2gFsoz9bYAtOPKfWju7h+Ul78GHXmgs0gU8I7jvR1ekkYmd0BdxJ/y3XJrygAOWaSB
         pyJb58rUUXi5SAf+7LoltZzTXaJDJjp8zzLl2uE5GlpmqhCdqp4sDm7+CQT8PKpGnvr1
         jZEg==
X-Forwarded-Encrypted: i=1; AJvYcCVzL3T33Yom/mj3ISnM7Rrj+iQj5Vkdr51Tx48MpAmco379Q9qbXi5yedy2hooV3Yh0qkxQ4CBgmQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzXEPglDbFyqgxF4hj5Kik5WPzeJrkX1B9efesUs1WbaaNlRVbb
	31s2NMneCzyFUHUu0MnEAhi6TyhnQEVRWSBPguodEXGXnzSBN3ZHokIhZsf8RxrruQ4=
X-Gm-Gg: AZuq6aJWekv+3jlBYMkRN/L2iAZimKeo6o0oxH9NjH88/ncSeCchCoZKYIRNGWvOLq0
	puGB4ik7woPUFMAPa5V9Dz/MLCwqAagsgmfc3LDQQVrs0QX4a/xOVBp9KK/cY+Wev/bOyCylcMw
	4jgYGh1nED7bxSw6CKjh18gv8wotZJuhOgPmBS89475Im3VdakKUa9UenDNJp4mQ4wkNcSxPrrt
	Y+q6YJx4ECUQHP7Gcv44QUvPiY90gMZFc7T/3UR8H4Wf0jAZTl5PqJG0eR0ycc/yuT1l22NcgTS
	K09eQGOkMawUwKDXDItq1/IMtMKuQTH0AU5pqMCvYw1n4nZLRy/NM03QO6ld3kBmML+ypWRpAxP
	tWbmMzu8ksDESsxAmqEBAdRri+fBYtZ+p1AsiWWoF8MW6rQsnDsM7L7TDfjknuEdI4MecezIrEa
	vCywoXmM3vTBHmI9Qpg0PqhVUFmsGTZJSVk7lMsh6EGG3pqY/VRYyxWYplTyrNrCFOmjZ4
X-Received: by 2002:a05:6808:16a2:b0:45c:8f03:1e19 with SMTP id 5614622812f47-45f34d254f1mr461195b6e.55.1769718000930;
        Thu, 29 Jan 2026 12:20:00 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-40956cd8290sm4423418fac.0.2026.01.29.12.19.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jan 2026 12:20:00 -0800 (PST)
Message-ID: <ef3a0fd0-d37a-436d-a86c-fe1dc7ec4ccd@kernel.dk>
Date: Thu, 29 Jan 2026 13:19:59 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring: Add size check for sqe->cmd
To: Govindarajulu Varadarajan <govind.varadar@gmail.com>,
 io-uring@vger.kernel.org
Cc: ming.lei@redhat.com, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
 miklos@szeredi.hu
References: <20260129201347.411015-1-govind.varadar@gmail.com>
 <20260129201347.411015-2-govind.varadar@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260129201347.411015-2-govind.varadar@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-11974-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3DF1FB434F
X-Rspamd-Action: no action

On 1/29/26 1:13 PM, Govindarajulu Varadarajan wrote:
> For SQE128, sqe->cmd provides 80 bytes for uring_cmd. Add macro to
> check if size of user struct does not exceed 80 bytes at compile time.
> User doesn't have to track this manually during development.
> 
> Replace io_uring_sqe_cmd() with IO_URING_SQE_CMD() which checks struct
> size for 16 bytes cmd.

Can't we just retain the normal lower case one and add the check? That's
what we do for normal inside sqe data, with io_kiocb_to_cmd(). There
should be no need for all-caps here.

-- 
Jens Axboe

