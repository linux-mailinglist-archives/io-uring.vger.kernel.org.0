Return-Path: <io-uring+bounces-13879-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id KLEoDNHGRmpmdQsAu9opvQ
	(envelope-from <io-uring+bounces-13879-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 02 Jul 2026 22:15:13 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D08F6FCB07
	for <lists+io-uring@lfdr.de>; Thu, 02 Jul 2026 22:15:12 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=vkEoBSEy;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13879-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13879-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8E4E23037F6F
	for <lists+io-uring@lfdr.de>; Thu,  2 Jul 2026 20:15:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FF3B382284;
	Thu,  2 Jul 2026 20:15:10 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EA82EB874
	for <io-uring@vger.kernel.org>; Thu,  2 Jul 2026 20:15:07 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783023310; cv=none; b=BBzmpPO+rHklc2e8sHWTnPW9FVvOvsLsKQfYdBsoqDt2eiLbQ+Bj8gjjglsM0Xca6o1lNsrAhpafCfdnj2pONy4piQaNN/kN1LUK1txqaswpShNPkwfg8e+ujEJSMlVgUcBOFeJS3uzs7FHmyhWlDr0GOJpi0nyvBnwSH3GrMqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783023310; c=relaxed/simple;
	bh=Sbva0bOCRo49I72c3nka2ipHlIyeM/8waunBoebWN3E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OnRLnQ4wXtkSF5ZZYZvlPoQ0jn2l+wJkhnibfg6OfDW5KU80sJJGJBO4Gv7k64InXK+gOFrvEI3JThTqFhQ1ckkJvTdUYuic5XEUWrlDEfL2mtxy1v/8FvVIztXl+RtgReAsOfwQ/BkQ0MIPcN0MUlxRH7ddsgZt2z4R4cOgEr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=vkEoBSEy; arc=none smtp.client-ip=209.85.210.50
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7eb6573bd52so343942a34.3
        for <io-uring@vger.kernel.org>; Thu, 02 Jul 2026 13:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1783023306; x=1783628106; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4yxNypmEEH64+aFG4dtZjWD7QI6sCFX8VJKaCr7lOIs=;
        b=vkEoBSEyeot7pUm6tLw9EKr5E3GgF6LJ+eoky+14gaNWej5vNxJpMGzfanGUZZ3kKz
         k7LF/6mnoeXchm4rQYBoMhDEW96X82sMeHjPvo+7pdQYvY+YOzsDaOcRZCcK1XJ+2Rq+
         bF8cs72Ke7XlIGA/ZWRTpNKmJC4bW96LXC/aLi6lpugXh5yUSbpgXMaTEt3t2bnlqdZb
         3HYpMjuf4DPri0zCM2aXD78L36iXwrRm9772/284v9kMKPE2C53LOm8jVFoKytxLkUGn
         YFE6mImFsl6P+WoWupFYmnHn42OcAaEkaxL/T7arvv8oPy+8G5+xPdqR2LHbDA3O1LTm
         ixmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783023306; x=1783628106;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4yxNypmEEH64+aFG4dtZjWD7QI6sCFX8VJKaCr7lOIs=;
        b=Bd+24Am+y+hbyyZwp2Z/SrFA07O8JjI/wUqU04oZ0YM8l/YGwMMx7KvWJDVtDwzH98
         10F+ef8lxRfdLQAG6YBdHZ4wI6Ee1u4InBQmgk2nNiSKuSDTBZXd38UgT6QrZtanalAE
         tC/xEim+IgnMh+S97rCGF0Gb75pBSy1rKLbilHbQXiA25o7uzXKQHioFaMFW9EQQgJlK
         3UOZHiNYZkA1ERoDsm8GfFlzTm8QLINi96xuqc63VCzXUZZ6P6m4JNnIA2R1rCXsQlKg
         Cc6RAkEmcd3KkXft9iMR37v0frcmTWv+kYzMzlFOyy9Y2JRj2Hj6XFFUc8wjV4AX27AP
         CIgw==
X-Gm-Message-State: AOJu0YxlyvrZaoqpU/qPU+LvYliQYNIZ+q/19CaxJvh4vLyCRhcWPLjU
	vpfNa08psbBFMBl2d8u338NEai+pkADRQ8IZ7d3imqSVu8T+/CfL+MTgTEKVkr4Ia/w=
X-Gm-Gg: AfdE7cnQyGO31JMOHxt7YAm6PQP5M27KlWiU/fAwpjNFbGve8GpK/+uT6PLe1794jVM
	6X+REyxrIq9xKXVC05c1EpsN22n4MwiydmXja9r2Eza35hfyJ8u+V4NS+IbPog1TVfm0iY/olnX
	dDxO/Hr+3skFFtfauRZH8xYewXzaQTMYwNEo9jFmQSpjWKOf0yCa4vzALTvQzf2/mKSOkP5lDfR
	qPcKxUvlCRI0hVWapLHkiFuGro29Hzax/Astk6AWXRQtYMHaxWasdDFUijf3bG2jXrFSs5nZpC8
	JUI8KnZ5Soq5biH6uGUXqhOs4tKPOXP1bAEsx7DtvQnAACv+ME8CzkYuzSC2s4blG7NQtRlu/84
	7H/AObe6ToDzOBvUpE9E97iwbRzSvC0lHfShuz1/LdcI4Uwa6hfdU5An6W+tryHo8KO2TFAFBU1
	cSrULYPmacpMnzjyKR5ZwPixOZmQrjqO6dbEQ+Uu6U0kq/4VgsWXGQh5BHnVqtqt9hJtKFpvmwA
	qJTEa/S
X-Received: by 2002:a05:6830:2316:b0:7e7:16b9:e274 with SMTP id 46e09a7af769-7eb48ac2515mr4628097a34.8.1783023306263;
        Thu, 02 Jul 2026 13:15:06 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7eb542d017csm3316862a34.8.2026.07.02.13.15.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2026 13:15:05 -0700 (PDT)
Message-ID: <ce98e216-98bf-42cf-b1a0-89a2ea62f897@kernel.dk>
Date: Thu, 2 Jul 2026 14:15:04 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring/uring_cmd: copy SQE before issue_blocking
 punt
To: Caleb Sander Mateos <csander@purestorage.com>,
 Yang Xiuwei <yangxiuwei@kylinos.cn>
Cc: io-uring@vger.kernel.org
References: <20260702082937.3707134-1-yangxiuwei@kylinos.cn>
 <20260702082937.3707134-2-yangxiuwei@kylinos.cn>
 <CADUfDZqMpc5PCai9ZeUJQCJ++Cd3PszkDxyVu6WUMBKqwu1boQ@mail.gmail.com>
 <CADUfDZp4DmCvwGyp9dJEEojSbkkcW8Bj9ZZEXVg3vw_7KsWhyQ@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZp4DmCvwGyp9dJEEojSbkkcW8Bj9ZZEXVg3vw_7KsWhyQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-13879-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:csander@purestorage.com,m:yangxiuwei@kylinos.cn,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp,purestorage.com:email,kernel.dk:mid,kernel.dk:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 3D08F6FCB07

On 7/2/26 12:06 PM, Caleb Sander Mateos wrote:
> On Thu, Jul 2, 2026 at 10:43 AM Caleb Sander Mateos
> <csander@purestorage.com> wrote:
>>
>> On Thu, Jul 2, 2026 at 1:41 AM Yang Xiuwei <yangxiuwei@kylinos.cn> wrote:
>>>
>>> io_uring_cmd_issue_blocking() punts to io-wq without copying the SQE
>>> off the submission queue, unlike the -EAGAIN and fallback paths. Copy
>>> the SQE into async data before queuing the work.
>>
>> Add a Fixes tag?
>> Fixes: ecf47d452ced ("io_uring/uring_cmd: implement ->sqe_copy() to
>> avoid unnecessary copies")
> 
> Actually I'm not convinced this is an issue at all. Since commit
> 212ec34e4e72 ("block: only read from sqe on initial invocation of
> blkdev_uring_cmd()"), blkdev_uring_cmd() only accesses the SQE on the
> initial issue. Even if the uring_cmd is re-issued asynchronously, it
> doesn't rely on the SQE having been preserved.

Yeah I agree, after taking a closer look. I'll kill this patch. I do
like your followup cleaning up the punting, will queue that for 7.3.

-- 
Jens Axboe


