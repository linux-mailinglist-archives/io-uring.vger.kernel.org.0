Return-Path: <io-uring+bounces-13677-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id PKjhJUMAK2r50wMAu9opvQ
	(envelope-from <io-uring+bounces-13677-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 20:36:51 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F6DE674780
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 20:36:51 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=dsRfERR5;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13677-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13677-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 32EE530FF46E
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 18:36:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2BAB48B37F;
	Thu, 11 Jun 2026 18:36:26 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0144D2ECB
	for <io-uring@vger.kernel.org>; Thu, 11 Jun 2026 18:36:24 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781202986; cv=none; b=ZNGiqhmt56+XRXYUeR4DHVzMm0gyqD+jkuOENbH3XlUcmgd8lzqUXwTDldT152iXmErk3So2eSPyIL4lxEWL2zR4Se0Qyw7hJbxv6EcHZvWC80vpkQhtybXn25Ce3ubWCNQyyivKfRDDCoxb4p0mQNy/z/CcrA3R1iEffnRxUhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781202986; c=relaxed/simple;
	bh=DVyDRdHfurjhiZzXkqIiYsJ8e/4Qe844Uj12+BMsIJ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qhkLHYtGO7XfX3hG0zS5n7k3BIm0Iy8WZTVlGUganpkoHdJo5F4h8YurEpVuMCimKlItRQxv95QZyr3BhQt5vcEbNPJ7YbwtPZrHXQBho8O6Mx9fDwYELHoP2bviwloS+KlT3RfREml/JLkdYbKh+9xfJAei7tfaJq1HhCANfSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=dsRfERR5; arc=none smtp.client-ip=209.85.160.51
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-43cce8288c7so108855fac.3
        for <io-uring@vger.kernel.org>; Thu, 11 Jun 2026 11:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781202984; x=1781807784; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jErdoPozY6XvPSRjRYAzCEz9KJzlAoJoY/0XbKzlQEU=;
        b=dsRfERR5LPK6rULHpJLK6m0F3kSLlNTmCyCmqfdG5CJYtieMRsIHb0NkuquOl0GQOm
         nrGQyugyapXcIJhfFE2rQtL0pDL/Prnp8CpsgHz+POu4sBU7v2HyFr3kj23D2Q3+Lxf7
         OjnfE1KO8ntEVzsVhEtYLJY51sj/ERmqCMbenMBeLxmDNe6QUYnHeyXSUc9NE0cgVXNG
         CiWtyX6KE0gW2hUIR6YXApTKqNjWFzg5O/ykoxI9Ul0sg02uKNhCWyt4gVqW1nfsrvQ+
         5MLymBl36lBOVE2Udgue9unKYxT7U5Br9nRmQAzEEpjY6rwldt10EzoeMu00ZCLaEx5N
         ghCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781202984; x=1781807784;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jErdoPozY6XvPSRjRYAzCEz9KJzlAoJoY/0XbKzlQEU=;
        b=KWvM44kgA66A8wmXiXq3BaEI5KpnVpaRv4DxmbU72ghSbKaXmBlCQquMnd5sIcF7xh
         m8MgEA5L23RNuqkTgPK5JgNr+b82xNuVl1vARMi3BcBC2SAOGiYFPxtNVXPNrWFgf1Je
         jkqG70oPLrepnPU57FKQ0TBwfO1hfn4n3sl5rF9U5aXyRhm4lmA/CWa61GjU0NRONC0m
         xcMymzwncZgz87F6yxA+L6lZSTFD0zT61Jvif+0LukVpk1W1KrpMTTPvbnS7/+uLnD58
         PoCa0sn/NA1P7KPDxngX2cuw2mJL9A7S2Qqd0n7AKZT2KY/O+xzMxH/DbZsQEeke/XKX
         hI2w==
X-Gm-Message-State: AOJu0YwxPgk9/2FVgrxVniQbfbZpVVbZMvcrGU+29SpkLfdEZQ1GR64G
	jF68RoPR8dZn0Qh0rjIJ4hpiRhZAj4bl4mCerMiIwXZRIQ9bER2IqHOi1kBvKV7gJzW3r6tZ4cm
	rOfxR8oo=
X-Gm-Gg: Acq92OEns88rxu6p7OiNItTTTn013PpcU/j4yEpyryI6QhYDpBKKpu/j7Iqyz1vOoVI
	a77EdYZId/hkhveXrW0xOeKRhAi3LYCZ3QCCBFVMfK66bf3x4OVNVy4PrcC/66Ohl//alk2U7SD
	HQuY7Jtfm3NO516f9tcl6eqV/C3EcZ1TCHbNg/t1GznMxfIjqSVwohVyt2CVT+wJs1zaQjvbGof
	9Bqg3SDyhhHmHDro5XvQrVn3gzs6DjyubnRAqZlRTPKVR+Zs3S0v9Qe2YcVGRXouhuga6PksPLC
	4V4OpfYcVuHTdoJ/+UZgn9r0N2Txcb/LpT1T4vEMZIaVud3Ins93mLvdUYXc0hE1oLpoCNmkTPF
	cMvNiAHUsCCFpeGNVaf0ANSHuDAAbPqDP5jojmnTa4wN56KHGv2/u5KyDurtl6wNBs+1IaaJoNP
	jDfD8hmsy8Ip7RsEfpZ+7Ugqn+efj0NXr3mwiUndQWQbZK6feUFm8HDxibSq6sydf8MQuH77Mbq
	L3XzD2u
X-Received: by 2002:a05:6870:450:b0:417:435c:b9ef with SMTP id 586e51a60fabf-442416d1a47mr2891440fac.11.1781202983847;
        Thu, 11 Jun 2026 11:36:23 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-442446babc9sm1658805fac.8.2026.06.11.11.36.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2026 11:36:23 -0700 (PDT)
Message-ID: <d75fe34f-dc14-455c-8d80-04d341a9744d@kernel.dk>
Date: Thu, 11 Jun 2026 12:36:22 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring/rw: fix link failure on successful pipe
 short reads
To: Yang Xiuwei <yangxiuwei@kylinos.cn>
Cc: io-uring@vger.kernel.org
References: <20260611012236.3020181-1-yangxiuwei@kylinos.cn>
 <20260611012236.3020181-2-yangxiuwei@kylinos.cn>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260611012236.3020181-2-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13677-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_RECIPIENTS(0.00)[m:yangxiuwei@kylinos.cn,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,kernel-dk.20251104.gappssmtp.com:dkim,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 0F6DE674780

On 6/10/26 7:22 PM, Yang Xiuwei wrote:
> __io_read() treats a short read on pipes and sockets as success and
> returns without filling the iov. However, __io_complete_rw_common()
> compared the transfer length against the original iov size and set
> REQ_F_FAIL when they did not match. That incorrectly failed linked
> requests behind a successful head request, for example a nop after a
> naturally disarmed link timeout.
> 
> Treat short reads and writes on non-regular files as success in
> __io_complete_rw_common(), matching the issue path.

Not sure I follow - the "short read/write is an IOSQE_IO_LINK failure"
is widely documented. So not sure I agree with this approach.

-- 
Jens Axboe

