Return-Path: <io-uring+bounces-13036-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0C0vBQEd3mk1ngkAu9opvQ
	(envelope-from <io-uring+bounces-13036-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2026 12:54:57 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 746083F8FBE
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2026 12:54:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 40EE73039FCF
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2026 10:50:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B67B3D5662;
	Tue, 14 Apr 2026 10:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ABcUZRXY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE69396B98
	for <io-uring@vger.kernel.org>; Tue, 14 Apr 2026 10:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776163826; cv=none; b=OHihQzObGMqio95PsMgRYMso0bUdnUYAIrVw606ki2StICrH+6AOCmnI6gyB8c21OY/HhI9RfDg+c43EfgTa/CZiF0CzADrnMPVhTS/MPCHBDx1Sb6jJkyiH1IrTrfGEE9BF1cRERCr/GhBtEDnV9LDdOBMzbZAEfeOUXE+5idI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776163826; c=relaxed/simple;
	bh=xQ/F4sjfp5kH2q5+N9ZJKZ7oj9p1H4ZffoOPykj/Ckg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a2qhsEW3GyNkxKviXwhBN1d+AWhBAnE1z3q3OtI6zFJtq/6AIubF0gvXfBDEd9pK4z/khTHM0zWScfR9kNFL42Y70tn4ee+9GvbFu+upa1UfwdgYQroZcMVe22aIhMsxmukWmeS4+1nA0M91KQyb912VDFq5Vm951DJi8Ek8evA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ABcUZRXY; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-488b0e1b870so85747375e9.2
        for <io-uring@vger.kernel.org>; Tue, 14 Apr 2026 03:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776163821; x=1776768621; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fo/7dZgKXfQSzb5UuAww1Ue/91GdNh0mngtdwnrcF9s=;
        b=ABcUZRXYLO7GlJaYZOxPYPSOL3SCLixxXQXmTEY/TV94B3YDGhr+WjmGe/TbNEKfxo
         VEuF3bLnqPYLXjsjDHwfqEqtq1SLBLCah8kNTkv9qNWwVx8zbf7dTgm3vw0vtJ/7mT3N
         JokicTxKIqPiFJgtghr4U12unM4enXVCdwoFZzpAqnpwnbzk4xEKMiuUBaKCQYpqBqzW
         UJ9QxRoR+HA7mqqOK1V8NQNst1xkshJKrlLAppvzckqWq3osoyygsxXVUtSikVDMfekJ
         31F5xEnbl83MxGUGzcpT053RUE5DK7wRe1iyzWpaNCdn5sIuwi9JCMCehTJv0wFVl7Oc
         zzEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776163821; x=1776768621;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fo/7dZgKXfQSzb5UuAww1Ue/91GdNh0mngtdwnrcF9s=;
        b=DqHz1cbc83NU9z0bwvwcljks/OqaJ1rdVpvmyHVauDl0UNXzW+tqm+F8jlKpTTgfTz
         2428QVmdcQ8fDSy1WGNUIx260QD0kWGSvoXDznT1E3mhKpafF6ip2/aENQvsQ2Z/ER92
         q6hmZTMQNNxGPEIpgqF0ASMokh3vsSLm3ji8UTI+XiBeExsS/+pIfstlOis+9JXHwFlF
         67g9CeBysKddvwWrpR6PiotrtmywdItzPYDlakVX+VMs/jCHQNqmrOK2PuDQltTU6IAr
         xI1iAz/rWSs8u/ly1vsJ+6WQnVVfYlAoTBoBfmTRG2S7PEjbnQojcv7nV6JRD4P3R264
         fVuA==
X-Forwarded-Encrypted: i=1; AFNElJ/W4ch2Mc1iOWCrBEvkUQhEcS4Ysir544IY6rcGshqYfPOukXRJNK2qg7ALlJKk87BrXACj+WDLCA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9lvQMc/b45GxyZfZ4DWTYZO5DhN23BdA8NIUqeHq4wKQuDdNc
	i9mroiIgIiQq6SAcnngrZdsOO4hWWC8k+MH7pm0A1oLXwBUc5zpEacLb
X-Gm-Gg: AeBDieu4u5++gIklCiFjjqRRR15gcuTRvvxXtqF335+G7slduTkoyx9uJg9TzsXfQHk
	H52vfcY11GLzK2ez69EQ1ElPVC3XGKusDmHkBIC+0lIVJP2ZhR87M5pDyeyzag3QWzAc2JBlLmW
	ab7wXPShqBZHN55jM6MOK13oPI4Xbcj8Nu840NDnJjzidwUQJiLszgdoMS61lKHbJQ5oUOtJEP/
	lpzwgQ7wMVFkv0wdemKMceY93CD3YrTd0LOOoD1XauJYJHS89Z/nOHjAUwDTMrdC0T29kRWxHyq
	iaE3wqedqin6brkAioVUdxaIR+qOtdjMLUxsISTqhJ+VZ5v8amaXNCGQW21w3n2i/wWErK4bRAz
	Wo3dbsSGB4fqww0Xaf1laYBAIiit6XrB9sV9raq4wx7w5/Osg9oC1LJxsBZgcVyKHc1RNR97AIs
	Ye2hFc6a73/zSsmO9eYqIg8CVcjm8YBWZ5X4BbcwZmlMKpqYyQPG9UPoonLMeR+uHpQlBOvaDOx
	paKmu8nlnd7lkCs4RUhczwi93effSZ8gyDnR065HVYNFS+mlhrm5ZSnoB5qdnEh6PNkqbpF/C19
	dg==
X-Received: by 2002:a05:600c:4709:b0:488:ae6c:42c0 with SMTP id 5b1f17b1804b1-488d67d2ab2mr200517885e9.7.1776163820803;
        Tue, 14 Apr 2026 03:50:20 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488ede1e050sm70962745e9.5.2026.04.14.03.50.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2026 03:50:20 -0700 (PDT)
Message-ID: <703f88ff-5242-406c-87e2-8cf1a70bbf57@gmail.com>
Date: Tue, 14 Apr 2026 11:50:29 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/poll: fix signed comparison in
 io_poll_get_ownership()
To: Ren Wei <n05ec@lzu.edu.cn>, io-uring@vger.kernel.org
Cc: axboe@kernel.dk, yifanwucs@gmail.com, tomapufckgml@gmail.com,
 yuantan098@gmail.com, bird@lzu.edu.cn, zcliangcn@gmail.com, ylong030@ucr.edu
References: <cover.1775965597.git.ylong030@ucr.edu>
 <3a3508b08bcd7f1bc3beff848ae6e1d73d355043.1775965597.git.ylong030@ucr.edu>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <3a3508b08bcd7f1bc3beff848ae6e1d73d355043.1775965597.git.ylong030@ucr.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[kernel.dk,gmail.com,lzu.edu.cn,ucr.edu];
	TAGGED_FROM(0.00)[bounces-13036-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,ucr.edu:email]
X-Rspamd-Queue-Id: 746083F8FBE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/12/26 09:38, Ren Wei wrote:
> From: Longxuan Yu <ylong030@ucr.edu>
> 
> io_poll_get_ownership() uses a signed comparison to check whether
> poll_refs has reached the threshold for the slowpath:
> 
>      if (unlikely(atomic_read(&req->poll_refs) >= IO_POLL_REF_BIAS))
> 
> atomic_read() returns int (signed). When IO_POLL_CANCEL_FLAG
> (BIT(31)) is set in poll_refs, the value becomes negative in
> signed arithmetic, so the >= 128 comparison always evaluates to
> false and the slowpath is never taken.
> 
> Fix this by casting the atomic_read() result to unsigned int
> before the comparison, so that the cancel flag is treated as a
> large positive value and correctly triggers the slowpath.

Looks good, thanks for the patch

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov


