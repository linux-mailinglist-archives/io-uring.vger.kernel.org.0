Return-Path: <io-uring+bounces-13390-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iLB8IgrtCmo89gQAu9opvQ
	(envelope-from <io-uring+bounces-13390-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 12:42:18 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E43DC56ADBD
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 12:42:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B6A33307357F
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 10:33:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8CFE3E8671;
	Mon, 18 May 2026 10:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kKGD8u9W"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341843EF0BA
	for <io-uring@vger.kernel.org>; Mon, 18 May 2026 10:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779100371; cv=none; b=hMGwgAMz3Z/D9WzC0IouxsZ9bHEUNnmvNGPJUaW79zthooeKM0+JjPeawbNUvSAHxJ1W7CaoKwixXNhGnQdfrywV38saqplp/5Cyal5C4IxA7GfQwYOUG482NDUxxttDIbRHdvfI8xSLBKqDhdbgElrxL7cX2zkGR+E395ka7TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779100371; c=relaxed/simple;
	bh=m9+vZFxcuGPYWJBP3wktaN7W2WK4EAv2F55wBzi2Ppk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OVq3qgtmLQbd0XNZ5Gor0m0HP4BS28PitGglnh60OIAsjz40m8TILiZVRz0UtNige2wDubIL9xHQrLQpjzyCyM6zO5nBIDo0vokFvocgqyu/V/YFgFlipH2HzCnTmv87ePyeYdUItnlZHPVtelSbe1sGhBmukwAsep/KXaIqwig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kKGD8u9W; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-bd85ebb368fso90083666b.1
        for <io-uring@vger.kernel.org>; Mon, 18 May 2026 03:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779100340; x=1779705140; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zoNzxGFL2Ujj/KuhI6hgWUIPCWaa3YVWWoq6Rexykog=;
        b=kKGD8u9WfUlh8C8qg0OHIKF7TnWNfk/Zq1f43h7Tzl2hvqn8D8PrBSiN9K0XDJx1qy
         WyuwcExNonp7DfifZfgFSPaWaTIpWvNE9/QlRj+eteLbPnAUgA07jgGtwroWjq8SASNF
         PXRiasnlodQUPHCOIoZpjvuCOGwdeYmjItzY5PdpyrYZ1Ka8uJgjXXJPAxGsyNdfQV0O
         Zv9mDKJ3jb+/ntQz+UeqCvbrwBx3z9X3PwXcH/LXktJqpFzdQOzkS43NdylIsOnkL9qn
         aNK6crOdJr6yhtaeEM39pBCfsWKzbGjGF2+2jtIMsnKOLZFccDbPwmxCCRw7iqZ4lxSl
         1E0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779100340; x=1779705140;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zoNzxGFL2Ujj/KuhI6hgWUIPCWaa3YVWWoq6Rexykog=;
        b=JpBx4UsI+Gh9upwERKTNkJ4rDcSZV3lqbbDjEUzx7rZRwytwRPZ62eBj3TeQ5P/hR2
         v7JvVjtsumy/3HhhjuFH27TmP/1s/xo7yGORgj84lFZcqnD+/dRZu4rULYIaYfQL+wPq
         C0AG33DQ94pSIx/oeuQt3SZ2mqXXvKplSVv6wJWY1A3syTmOo4mZRd9h3il6XS28tSfv
         qHK6W6mXCTCOKseWr4KXOSy5vTR16BPWCge7Ovcmimabn33x9XLMiFEZ1qO805mduxEO
         ZaGYTGHb8XB/eKohkv12tkWKchXhlOKJVr640q+0cUGSaneU1JQckzL4jJ9N09KFdsay
         /iZQ==
X-Forwarded-Encrypted: i=1; AFNElJ/+eCIRaXfZYY0LGC97UeDBxg+Yl9Y23jZjVibsAdF1ZFy2ikHTQOZ0tvKX798Iu/kMtfYCMqC9PA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzB6IUdBjfCFkOnOv2LvpuPum77UjxTMWBE70MBgKm81885G28Z
	ctFtK63LqHF30tIE3CyIrPra88AiiO2JYJ6MFhNiqEVbmvHQ7tR3iYbt
X-Gm-Gg: Acq92OFDRUALebI1LJEAvXjLixjWrLcA+OoP/GxYdg0geSg/Q0rwghv9W10qBDsA71g
	k0fH445OowMPsFcD5tVjo6nqMlo6+2k8pDlHHHyrbmIEpQouxB4r9uf9wYW9b/NIasoEmzwaubD
	CtWrNWILuVDiWY0oeFCXBLSzlf4ruakajnyu3t1vBUKWKvy7f3VIcoB5AsaWxbikC8VN3f0SI94
	eLYmWPupAJAyQXrcwD7ZflynHMoQ14L7tSNeVr5/KdHZBTvSOfkuApLcm+TH9ro9R1yfUGXM66O
	r5NTlbjcZjbT133twEr7hvqxTbWGqgKmYWNv0l2v6YfBu9oRWGlbSVEEPwEXRaTa6bQwdzulooc
	1JHhBU/Bcs7SLcGHb2n4ZAipGjZH5ASZGbGrIAw+ZRKIO4LJt/JRZh32uVYL+tw2H59E6PYlZzy
	7m24tjEvdqRRUMXpK+ZGCsGvDoyGpNfKm1pj8p1UVj0SER57GK3kPTrc2fFDnt2a+4SWv26c/AY
	jUDYyhDML1FCUrFtKYNhmh/vrUuwWsX9AMmuhBLRepGHm8p5jzt1icgFaM=
X-Received: by 2002:a17:906:4fd2:b0:bcc:e8f:c3a8 with SMTP id a640c23a62f3a-bd51797a61emr744815966b.29.1779100339507;
        Mon, 18 May 2026 03:32:19 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:ec20])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bd4f4ded942sm545073266b.36.2026.05.18.03.32.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 03:32:18 -0700 (PDT)
Message-ID: <edcff681-bb4f-491d-b87b-eab5919d0623@gmail.com>
Date: Mon, 18 May 2026 11:32:16 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] fuse: wait for aborted connection before releasing
 last fuse_dev
To: Bernd Schubert <bernd@bsbernd.com>, Bernd Schubert <bschubert@ddn.com>,
 Berkant Koc <me@berkoc.com>, Greg KH <gregkh@linuxfoundation.org>,
 Miklos Szeredi <miklos@szeredi.hu>
Cc: "security@kernel.org" <security@kernel.org>,
 Joanne Koong <joannelkoong@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 Jens Axboe <axboe@kernel.dk>, fuse-devel <fuse-devel@lists.linux.dev>
References: <20260517095846.fuse-iouring-uaf.dc5f5dbb71dc@berkoc.com>
 <2026051703-equinox-multitude-91e2@gregkh>
 <20260517-fuse-uaf-cover@berkoc.com> <20260517-fuse-uaf-patch2@berkoc.com>
 <08d3f6e0-7745-4084-995a-95ddb77f7f11@ddn.com>
 <9f3f3dc7-1c52-49b6-91d5-046f1fc7b2a8@gmail.com>
 <a44344bb-ad71-41f5-a3c5-81eb99442e5e@bsbernd.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <a44344bb-ad71-41f5-a3c5-81eb99442e5e@bsbernd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E43DC56ADBD
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13390-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,vger.kernel.org,kernel.dk,lists.linux.dev];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Action: no action

On 5/18/26 10:50, Bernd Schubert wrote:

>>>> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
>>>> index 5dda7080f4a9..7d9c06654a98 100644
>>>> --- a/fs/fuse/dev.c
>>>> +++ b/fs/fuse/dev.c
>>>> @@ -2566,6 +2566,7 @@ int fuse_dev_release(struct inode *inode, struct file *file)
>>>>                   if (last) {
>>>>                           WARN_ON(fc->iq.fasync != NULL);
>>>>                           fuse_abort_conn(fc);
>>>> +                       fuse_wait_aborted(fc);
>>>>                   }
>>>>                   fuse_conn_put(fc);
>>>>           }
>>>
>>> I might be wrong, but I don't think it is possible, Maybe Pavel or Jens
>>> could help (added to CC). Basically as long as
>>> fuse_uring_async_stop_queues() runs we do not have completed all
>>> io-uring commands via io_uring_cmd_done() and as long as we do not have
>>> completed these io-uring commands.
>>
>> If I understand the question right, yes, fuse io_uring cmd requests hold
>> a reference to the fuse file, so until you complete them the file will
>> not get released.
> 
> 
> Sorry, had totally messed up the phrase, can't read it myself.
> 
> What I mean is that the io-uring was set up with /dev/fuse as file and
> as long as fuse holds non-completed 'struct io_uring_cmd *cmd' objects
> there is a reference on the /dev/fuse fd, which blocks the call of
> fuse_dev_release().

Yep, that's right

-- 
Pavel Begunkov


